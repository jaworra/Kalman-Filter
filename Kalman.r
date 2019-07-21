#Author: John Worrall
#Project - STA8180
source("pMetrics.R")
library(dlm)
library(ggplot2)
library(zoo)
library(gridExtra)
library(KFAS)

#Build Kalman filter one step ahead

irData <- read.csv("IronOre2.csv", header=TRUE)
irData<-irData$Price
train <- irData[1:459]
test <-irData[460:471]


#build model for state space
model.build <- function(p) {
  return(
    dlmModPoly(2, dV=p[1], dW=p[2:3]) +
      dlmModSeas(12, dV=p[4])
  )
}

#parameter estimation with MLE
model.mle <- dlmMLE(train, parm=c(1, 1, 1, 1), build=model.build)
#Does it converge
if(model.mle$convergence==0) print("converged") else print("did not converge")
# "converged"
model.mle$par
#Given convergence with MLE parameters are parse to build final model
model.fit <- model.build(model.mle$par)
#Apply Kalman filter to data
model.filtered <- dlmFilter(train, model.fit)
#Add smoother to data
model.smoothed <- dlmSmooth(train, model.fit)

n <- 1*12
model.forecast <- dlmForecast(model.filtered, nAhead=n)

x <- index(irData)
a <- drop(model.forecast$a%*%t(FF(model.fit)))
ab <- irData[459]
c <-a
c[1] <-ab

#Arima for comparison
model <- auto.arima(train)
arimaorder(model)
model.forecast <- forecast(model, h = n)
m.arima<-as.numeric(model.forecast$mean)

#Compare all
df <- rbind(
  data.frame(x=index(irData), y=as.numeric(irData), series="original"),
  data.frame(x=x[1:459], y=apply(model.filtered$m[-1,1:2], 1, sum), series="filtered"),
  data.frame(x=x[1:459], y=apply(model.smoothed$s[-1,1:2], 1, sum), series="smoothed"),
  #data.frame(x=x[460:471], y=a, series="forecast")
  data.frame(x=x[460:471], y=c, series="KL forecast"),
  data.frame (x=x[460:471], y=m.arima, series="ARIMA forecast")
)
g.dlm <- ggplot(subset(df, x>400), aes(x=x, y=y, colour=series)) + geom_line()
g.dlm

g.dlm2 <- ggplot(subset(df, x>450), aes(x=x, y=y, colour=series)) + geom_line()
g.dlm2

g.dlm3 <- ggplot(subset(df, x>0), aes(x=x, y=y, colour=series)) + geom_line()
g.dlm3

m.klfore<-c


#Performance metrics of ARIMA
dataObs <- test
dataSim <- m.arima
res <- abs(dataSim - dataObs)
ar_pMetrics<-pMetrics(dataObs,dataSim)


#plot arima
par(mai=rep(0.5, 4))
layout(matrix(c(1,2,3,3), ncol = 2, byrow = TRUE))

hist(res,col = "red",
     main="Histogram absolute error frequency", las=2, xlab = "Errors", cex.lab = 1.3)

plot(dataObs, dataSim, main="Scatterplot prediction against observed", 
     xlab="Data Obervation - value ", ylab="Data Simulated - value", pch=19)
abline(lm(dataSim~dataObs), col="red") # regression line (y~x) 
rTxt <- paste(c("R2 is"), round(ar_pMetrics$R2,4))
lg<-c("line of best fit",rTxt)
legend(x="bottomright",inset =0.05,lg,cex=.8,col=c("red","black"),lty=1:0)

ylimMax <- max(dataObs,dataSim)+1
ylimMin <- min(dataObs,dataSim)-1
plot(dataObs,type="l",col="black", ylim = range(ylimMin:ylimMax))
lines(dataSim,type="l",col="red")
title("ARIMA (1,1,1) forecast model")
legend("topleft",c("Actual","Predicted"), col=c("black","red"), lty = 1:1, cex=0.8)

#Performance metrics of Kalman
dataSim <- m.klfore
kl_pMetrics<-pMetrics(dataObs,dataSim)
res <- abs(dataSim - dataObs)


#plot kalman fitler
par(mai=rep(0.5, 4))
layout(matrix(c(1,2,3,3), ncol = 2, byrow = TRUE))

hist(res,col = "red",
     main="Histogram absolute error frequency", las=2, xlab = "Errors", cex.lab = 1.3)

plot(dataObs, dataSim, main="Scatterplot prediction against observed", 
     xlab="Data Obervation - value ", ylab="Data Simulated - value", pch=19)
abline(lm(dataSim~dataObs), col="red") # regression line (y~x) 
rTxt <- paste(c("R2 is"), round(ar_pMetrics$R2,4))
lg<-c("line of best fit",rTxt)
legend(x="bottomright",inset =0.05,lg,cex=.8,col=c("red","black"),lty=1:0)

ylimMax <- max(dataObs,dataSim)+1
ylimMin <- min(dataObs,dataSim)-1
plot(dataObs,type="l",col="black", ylim = range(ylimMin:ylimMax))
lines(dataSim,type="l",col="red")
title("Kalman forecast model")
legend("topleft",c("Actual","Predicted"), col=c("black","red"), lty = 1:1, cex=0.8)


#depricated=============================
#using kfas library

#Project - STA8180
source("pMetrics.R")
irData <- read.csv("IronOre.csv", header=TRUE)
irData <- read.csv("Train.csv", header=TRUE)
IrPrice <- irData$Price


#Build Kalman filter one step ahead
library(KFAS)
currency=(log(IrPrice))  #log format
currency=IrPrice
#ssm is state space model
#Q and H are uncostraided time invariant convariance estimates
logmodel <- SSModel(currency ~ SSMtrend(1, Q = 0.01), H = 0.01)
out <- KFS(logmodel)
par(mfrow=c(1,1))
ts.plot(ts(currency), out$a, out$att, out$alphahat, col = 1:4)
title("USD/Iron Ore")
df<-data.frame(currency, out$a[1:471], out$att[1:471], out$alphahat[1:471])
#a-is one step ahead predictions states
#att-are filtered estimates of states
#alphahat-smoothe estates states

#train prediction at 67.39
model_KFAS <- SSModel(currency ~ SSMtrend(1, Q = list(matrix(NA))), H = matrix(NA))
model_KFAS <- fitSSM(model_KFAS, c(log(var(currency)), log(var(currency))), method = "BFGS")$model
our_KFAS <- KFS(model_KFAS, filtering = "state", smoothing = "state")
par(mfrow=c(1,1))
ts.plot(ts(currency), our_KFAS$a, our_KFAS$att, our_KFAS$alphahat, col = 1:4)

conf_kfas <- predict(model_KFAS,n.ahead=50, interval = "confidence", level = 0.9)
pred_kfas <- predict(model_KFAS,n.ahead=50,interval="prediction",level=0.9)



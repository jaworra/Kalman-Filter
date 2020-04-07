#Author: John Worrall
#Project - STA8180
source("pMetrics.R")
irData <- read.csv("data/IronOre.csv", header=TRUE)
#spit traing testing set - 12 month ahead prediction
train <- irData[1:459,]

# summary(irData)
# var(irData)
# #kurtosis(irData$Price)
# sd(irData$Price)
# range(irData$Price)

IrPrice<-train$Price

#plots
par(mfrow=c(1,1))
plot(IrPrice, type="l", las=1, xlab="Time (months)", ylab="Price (US per ton)",main = "Time Series: Iron Ore Price" , panel.first = grid())
grid(NA, 5, lwd = 2)
#PACF
par(mfrow=c(1,2))
pacf(IrPrice,main = "PACF: Iron Ore Price")
p<-pacf(IrPrice,main = "PACF: Iron Ore Price")
#acf
acf(IrPrice,main = "ACF: Iron Ore Price")
a<-acf(IrPrice,main = "ACF: Iron Ore Price")
#first diff
plot(diff(IrPrice, lag=1),type="l",main = "First Difference Iron Ore Price")

#-----------------
#Auto ARIMA
library(forecast)
#non seasonal
arIrp <- auto.arima(IrPrice)
arimaorder(arIrp)
#seasonal 
sesArima <-auto.arima(IrPrice_ts,max.P = 3, max.Q = 3,trace=TRUE,approximation=FALSE, stepwise = F, seasonal = T)
arimaorder(sesArima)

#itnerative approach - no season
(arima_010 = arima(IrPrice, order = c(0, 1, 0)))
(arima_110 = arima(IrPrice, order = c(1, 1, 0)))
(arima_011 = arima(IrPrice, order = c(0, 1, 1)))
(arima_210 = arima(IrPrice, order = c(2, 1, 0)))
(arima_012 = arima(IrPrice, order = c(0, 1, 2)))
(arima_111 = arima(IrPrice, order = c(1, 1, 1)))
(arima_013 = arima(IrPrice, order = c(0, 1, 3)))
(arima_310 = arima(IrPrice, order = c(3, 1, 0)))
(arima_211 = arima(IrPrice, order = c(2, 1, 1)))
(arima_112 = arima(IrPrice, order = c(1, 1, 2)))


#itnerative approach - yearly seasonal
IrPrice_ts <- ts(IrPrice, start=c(1975,12), end=c(2015, 2), frequency=12)

(arimaSea_111_001 = arima(IrPrice, order = c(1, 1, 1),seasonal = list(order = c(0,0,1))))
(arimaSea_111_002 = arima(IrPrice, order = c(1, 1, 0),seasonal = list(order = c(0,0,2))))
(arimaSea_111_100 = arima(IrPrice, order = c(1, 1, 1),seasonal = list(order = c(1,0,0))))
(arimaSea_111_101 = arima(IrPrice, order = c(1, 1, 1),seasonal = list(order = c(1,0,1))))
(arimaSea_111_102 = arima(IrPrice, order = c(1, 1, 1),seasonal = list(order = c(1,0,2))))
(arimaSea_111_200 = arima(IrPrice, order = c(1, 1, 1),seasonal = list(order = c(2,0,0))))
(arimaSea_111_201 = arima(IrPrice, order = c(1, 1, 1),seasonal = list(order = c(2,0,1))))
(arimaSea_111_202 = arima(IrPrice, order = c(1, 1, 1),seasonal = list(order = c(2,0,2))))


#performance metrics
#models ARIMA(1,1,1) and ARIMA(1,1,1)(0,0,2)[12] chosen
#best arima_111
dataObs <- IrPrice
dataSim <-fitted(arima_111)
res <- abs(predicted - actual)

AR_pMetrics<-pMetrics(dataObs,dataSim)

#plots
par(mai=rep(0.5, 4))
layout(matrix(c(1,2,3,3), ncol = 2, byrow = TRUE))

hist(res,col = "red",
     main="Histogram absolute error frequency", las=2, xlab = "Errors", cex.lab = 1.3)

plot(actual, predicted, main="Scatterplot prediction against observed", 
     xlab="Data Obervation - value ", ylab="Data Simulated - value", pch=19)
abline(lm(predicted~actual), col="red") # regression line (y~x) 
rTxt <- paste(c("R2 is"), round(KL_pMetrics$R2,4))
lg<-c("line of best fit",rTxt)
legend(x="topleft",inset =0.05,lg,cex=.8,col=c("red","black"),lty=1:0)

plot(actual,type="l",col="black")
lines(predicted,type="l",col="red")
title("ARIMA (1,1,1) model")
legend("topleft",c("Actual","Predicted"), col=c("black","red"), lty = 1:1, cex=0.8)

#forecast
par(mfrow=c(1,1))
forc <- forecast(arima_111,h=198)
plot(forc)




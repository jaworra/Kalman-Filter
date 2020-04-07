#Author: John Worrall
#Project - STA8180
#prep Data
irData <- read.csv("IronOre.csv", header=TRUE)
summary(irData)
sd(irData$Price)
range(irData$Price)

IrPrice <- irData$Price
irTs <- ts(irData$Price,
           start=c(1980,12),
           end=c(2019,3),
           frequency=12)

par(mfrow=c(1,1))
par(mar = c(5.1, 4.1 ,4.1 ,2.1))

plot(irTs, type="l", las=1, xlab="Time", ylab="Price (US per ton)",main = "Time Series: Iron Ore Price" ,col="blue")
grid(lwd = 2, col=gray(.9))
abline(v=2018, col="grey57")

#n of sample size
pN<-0.85
len<-nrow(irData)
smp_size <- floor(pN * len)
train <- irData[1:smp_size, ]
test <-irData[(smp_size+1):len, ]

#split for 50 months test
train <- irData[1:421, ]
test <-irData[(422):len, ]


#split for 12 months- year test
train <- irData[1:459, ]
test <-irData[(460):len, ]

write.csv(train, file = "Train.csv")
write.csv(test, file = "Test.csv")


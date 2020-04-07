pMetrics <-function(dataObs,dataSim){
  
  #function definitions
  sumsqr<- function(series) {
    ssq <- 0
    for (k in 1:length(series)) {
      ssq <- ssq + series[k] * series[k]
    }
    return(ssq)
  }
  
  R2 <- function(dataObs,dataSim){
    R21=sum((dataObs -mean(dataObs))*( dataSim - mean(dataSim)))
    R22=sqrt(sumsqr(dataObs -mean(dataObs))*sumsqr(dataSim - mean(dataSim)))
    r2 = (R21/R22)^2;
    return(r2)
  }
  
  RMSE<-function(dataObs,dataSim){
    rmse <-sqrt(sumsqr(dataObs - dataSim)/length(dataObs))
    return(rmse)
  }
  
  rRMSE <-function(dataObs,dataSim){
    rrmse <-(sqrt(sumsqr(dataObs - dataSim)/length(dataObs)))/(sum(dataObs)/length(dataObs)) * 100
    return(rrmse)
  }
  
  MAE <- function(dataObs,dataSim){
    mae <- (sum(abs(dataSim - dataObs)))/length(dataObs)
    return(mae)
  }
  
  MAPE<-function(dataObs,dataSim){
    mape<-(sum(abs((dataSim - dataObs)/dataObs)))/length(dataObs)*100
    return(mape)
  }
  
  #calculate metrics
  a_r2<-R2(dataObs,dataSim) 
  a_rmse<-RMSE(dataObs,dataSim)
  a_rrmse <-rRMSE(dataObs,dataSim)
  a_mae<-MAE(dataObs,dataSim) 
  a_mape<-MAPE(dataObs,dataSim) 
  a_pmetrics<- list(a_r2,a_rmse,a_rrmse,a_mae,a_mape)
  names(a_pmetrics) <-c("R2","RMSE","rRMSE","MAE","MAPE") #set list names
  return(a_pmetrics)
}
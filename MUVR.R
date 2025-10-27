#install.packages("doRNG")
library(devtools)
library(remotes)
library(doParallel)
library(doRNG)    
library(MUVR)
library(readr)
library(randomForest)
library(pROC)
data <- read_csv
X <- as.matrix(data[, 4:624])               
Y <- data$Liver_regeneration_rate
IDR <- data$ID                         
X <- sqrt(X)
X <- log1p(X)
X_log <- log2(X + 1)
nCore <- 7               
nRep <- 20                
fitness <- 'RMSEP'        
nOuter <- 5               
nInner <- 4               
varRatio <- 0.8           
method <- 'PLS'            
set.seed(119)            
cl <- makeCluster(nCore)
registerDoParallel(cl)
registerDoRNG(119)        
regrModel <- MUVR(
  X = X,
  Y = Y,
  ID = IDR,
  nRep = nRep,
  nOuter = nOuter,
  nInner = nInner,
  varRatio = varRatio,
  fitness = fitness,
  method = method
)
stopCluster(cl)
regrModel$fitMetric    
regrModel$nComp         
regrModel$nVar      
cbind(Y, regrModel$yPred)  
plotMV(regrModel, model = 'min')        
plotVAL(regrModel)                           
plotVIP(regrModel, model = 'min')         
plotStability(regrModel, model = 'min')      
important_vars <- getVIP(regrModel, model = 'min')  
print(important_vars)
if (method == 'PLS') {
  biplotPLS(regrModel$Fit$plsFitMin, comps = 1:2)
} else {
  varImpPlot(regrModel$Fit$rfFitMin) 
}
library(readr)
library(rstan)
tea_discipline_oss <- read_csv("tea_discipline_oss.csv") 
View(tea_discipline_oss)

uncensored_data = subset(tea_discipline_oss,ACTIONS>0)
tea <-data.frame(x=uncensored_data$GRADE,y=uncensored_data$ACTIONS)
tea$intercept =1
tea<-as.list(tea)
tea$N<-nrow(uncensored_data)
fileName <- "poisson.stan"
stan_code <- readChar(fileName, file.info(fileName)$size)
resStan<-stan(model_code=stan_code,data=tea,chains=3,iter=1000,warmup=1000,thin=10)
traceplot(resStan, pars = c("beta"), inc_warmup = FALSE) #set inc_warmup = TRUE to see burn in
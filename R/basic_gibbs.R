#Sampling from the normal-gamma model

sampler1 <-function(data,mu0=0.,kappa0=1.,alpha0=1., beta0=1.,num_samples=1000){
  n = length(data)
  xbar = mean(data)
  mu<-rep(NA, num_samples)
  omega<-rep(NA,num_samples)
  mu_n <- (kappa0*mu0 + n*mean(data))/(kappa0+n)
  kappa_n<-kappa0+n
  alpha_n <- alpha0 + n/2.
  beta_n = beta0+0.5*sum((data-xbar)**2) + n*kappa0*((xbar-mu0)**2)/(2*(kappa0+n))
  
  for(i in 1:num_samples){
    omega[i]<-rgamma(n=1,shape=alpha_n, rate=beta_n)
    mu[i]<-rnorm(n=1,mean=mu_n,sd=1/sqrt(omega[i]*kappa_n))
  }
  return(list("mu"=mu,"omega"=omega))
} 

sampler2<-function(data,mu0=0.,kappa0=1.,alpha0=1., beta0=1.,num_samples=1000,burnin=100){
  n = length(data)
  xbar = mean(data)
  mu<-rep(NA, num_samples+burnin)
  omega<-rep(NA,num_samples+burnin)
  mu_n <- (kappa0*mu0 + n*mean(data))/(kappa0+n)
  kappa_n<-kappa0+n
  alpha_n <- alpha0 + n/2.
  beta_n = beta0+0.5*sum((data-xbar)**2) + n*kappa0*((xbar-mu0)**2)/(2*(kappa0+n))
  omega[1]=alpha0/beta0
  mu[1]=mu0
  for(i in 2:(num_samples+burnin)){
    beta_param = 0.5*(kappa_n*((mu[i-1]-mu_n)**2)) +beta_n
    omega[i]<-rgamma(n=1,shape=alpha_n, rate=beta_param)
    mu[i]<-rnorm(n=1,mean=mu_n,sd=1/sqrt(omega[i]*kappa_n))
  }
  return(list("mu"=mu[(burnin+1):(burnin+num_samples)],"omega"=omega[(burnin+1):(burnin+num_samples)]))
}
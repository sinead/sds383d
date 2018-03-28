 // Basic Poisson glm
 
 data {
   // Define variables in data
   // Number of observations (an integer)
   int<lower=0> N_obs;
   int<lower=0> N_cens;
   
 
   // Covariates
   int <lower=0, upper=1> intercept[N];
   int <lower=-1, upper=12> x[N];

   
   // Count outcome
   int<lower=5> y_obs[N_obs];
   int<lower=1,upper=5> y_cens[N_obs];
 }
 
 parameters {
   // Define parameters to estimate
   real beta[2];
 }
 
 transformed parameters  {
   //
   real lp[N];
   real <lower=0> mu[N];
 
   for (i in 1:N) {
     // Linear predictor
     lp[i] <- beta[1] + beta[2]*x[i];
 
     // Mean
     mu[i] <- exp(lp[i]);
   }
 }
 
 model {
   // Prior part of Bayesian inference
   beta[1]~normal(0,1);
   beta[2]~normal(0,1);
 
 
   // Likelihood part of Bayesian inference
   y_obs ~ poisson(mu);
   y_cens ~ poisson(mu);
 }
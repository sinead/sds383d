import numpy as np

def sampler1(data, mu0=0.,kappa0=1.,alpha0=1., beta0=1.,num_samples=1000):
    n = len(data)
    xbar = np.mean(data)
    mu = np.zeros(num_samples)
    omega = np.zeros(num_samples)
    mu_n = (kappa0*mu0 + n*xbar)/(kappa0+n)
    kappa_n = kappa0+n
    alpha_n = alpha0 + n/2.
    beta_n = beta0+0.5*np.sum((data-xbar)**2) + n*kappa0*((xbar-mu0)**2)/(2*(kappa0+n))
  
    for i in range(num_samples):
        omega[i] =np.random.gamma(shape=alpha_n, scale=1/beta_n)
        mu[i] = np.random.normal(loc=mu_n,scale=1/np.sqrt(omega[i]*kappa_n))
  
    return mu, omega

def sampler2(data,mu0=0.,kappa0=1.,alpha0=1., beta0=1.,num_samples=1000,burnin=100):
    n = len(data)
    xbar = np.mean(data)
    mu = np.zeros(num_samples)
    omega = np.zeros(num_samples)
    mu_n = (kappa0*mu0 + n*xbar)/(kappa0+n)
    kappa_n = kappa0+n
    alpha_n = alpha0 + n/2.
    beta_n = beta0+0.5*np.sum((data-xbar)**2) + n*kappa0*((xbar-mu0)**2)/(2*(kappa0+n))

    omega[0]=alpha0/beta0
    mu[0]=mu0
    for i in range(1,num_samples+burnin):
        beta_param = 0.5*(kappa_n*((mu[i-1]-mu_n)**2)) +beta_n
        omega[i]=np.random.gamma(shape=alpha_n, scale=1/beta_param)
        mu[i]=np.random.normal(loc=mu_n,scale=1/np.sqrt(omega[i]*kappa_n))
  
    return mu[burnin:],omega[burnin:]


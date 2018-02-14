function [mu,omega] = sampler1(data, mu0,kappa0,alpha0,beta0,num_samples)
if nargin==1
    mu0 = 0;
    kappa0 = 1;
    alpha0 = 1;
    beta0 = 1;
    num_samples = 1000;
end
n = length(data);
xbar = mean(data);
mu = zeros(num_samples,1);
omega = zeros(num_samples,1);
mu_n = (kappa0*mu0 + n*xbar)/(kappa0+n);
kappa_n = kappa0+n;
alpha_n = alpha0 + n/2.;

data_diff_sq = (data-xbar).*(data-x_bar);
beta_n = beta0+0.5*sum(data_diff_sq) + n*kappa0*((xbar-mu0)^2)/(2*(kappa0+n));

for i=1:num_samples
    omega(i) =gamrnd(alpha_n, 1/beta_n);
    mu(i) = norm_rnd(mu_n,1/np.sqrt(omega(i)*kappa_n));
end
end

function [mu,omega] = sampler2(data, mu0,kappa0,alpha0,beta0,num_samples,burnin)
if nargin==1
    mu0 = 0;
    kappa0 = 1;
    alpha0 = 1;
    beta0 = 1;
    num_samples = 1000;
    burnin=100;
end

n = length(data);
xbar = mean(data);
mu = zeros(num_samples+burnin,1);
omega = zeros(num_samples+burnin,1);
mu_n = (kappa0*mu0 + n*xbar)/(kappa0+n);
kappa_n = kappa0+n;
alpha_n = alpha0 + n/2.;

data_diff_sq = (data-xbar).*(data-x_bar);
beta_n = beta0+0.5*sum(data_diff_sq) + n*kappa0*((xbar-mu0)^2)/(2*(kappa0+n));

omega(0)=alpha0/beta0;
mu(0)=mu0;
for i=1:(num_samples+burnin)
    beta_param = 0.5*(kappa_n*((mu(i-1)-mu_n)^2)) +beta_n;
    omega(i)=gamrnd(alpha_n, 1/beta_param);
    mu(i)=normrnd(mu_n,1/np.sqrt(omega(i)*kappa_n));
  
end
mu = mu(burnin:(burnin+num_samples));
omega=omega(burnin:(burnin+num_samples));
end
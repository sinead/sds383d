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

data_diff_sq = (data-xbar).*(data-xbar);
beta_n = beta0+0.5*sum(data_diff_sq) + n*kappa0*((xbar-mu0)^2)/(2*(kappa0+n));

for i=1:num_samples
    omega(i) =gamrnd(alpha_n, 1/beta_n);
    mu(i) = normrnd(mu_n,1/sqrt(omega(i)*kappa_n));
end
end

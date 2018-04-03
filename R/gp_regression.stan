// Based on code from Michael Betancourt
// Defines a function for sampling from the predictive distribution, for visualization.
functions {
  vector gp_pred_rng(real[] long_2,real lat_2
                     vector y1, real[] long_1,real lat_1,
                     real alpha, real rho_long, real rho_lat, real sigma, real delta) {
    int N1 = rows(y1);
    int N2 = size(x2);
    vector[N2] f2;
    {
      matrix[N1, N1] K =   cov_exp_quad(long_1, alpha, rho_long).*cov_exp_quad(lat_1,1,rho_lat)
                         + diag_matrix(rep_vector(square(sigma), N1));
      matrix[N1, N1] L_K = cholesky_decompose(K);

      vector[N1] L_K_div_y1 = mdivide_left_tri_low(L_K, y1);
      vector[N1] K_div_y1 = mdivide_right_tri_low(L_K_div_y1', L_K)';
      matrix[N1, N2] k_x1_x2 = cov_exp_quad(long_1, long_2, alpha, rho_long).*cov_exp_quad(lat_1, lat_2, 1, rho_lat);
      vector[N2] f2_mu = (k_x1_x2' * K_div_y1);
      matrix[N1, N2] v_pred = mdivide_left_tri_low(L_K, k_x1_x2);
      matrix[N2, N2] cov_f2 =   cov_exp_quad(long_2, alpha, rho_long).*cov_exp_quad(lat_2,1,rho_lat) - v_pred' * v_pred
                              + diag_matrix(rep_vector(delta, N2));
      f2 = multi_normal_rng(f2_mu, cov_f2);
    }
    return f2;
  }
}

data {
  //Data
  int<lower=1> N;
  real longit[N];
  real latit[N]
  vector[N] y;

  //Locations for predictions
  int<lower=1> N_predict;
  real long_predict[N_predict];
  real lat_predict[N_predict];


}

parameters {
  real<lower=0> rho_long;
  real<lower=0> rho_lat;
  real<lower=0> alpha;
  real<lower=0> sigma;
}

model {
  // sets up squared exponential kernel, plus gaussian noise.
  matrix[N, N] cov =   cov_exp_quad(longit, alpha, rho_long).*cov_exp_quad(latit,1,rho_lat)
                     + diag_matrix(rep_vector(square(sigma), N));
  matrix[N, N] L_cov = cholesky_decompose(cov);

  // priors on hyperparameters -- feel free to change!
  rho_long ~ inv_gamma(1,1);
  rho_lat ~ inv_gamma(1,1);
  alpha ~ inv_gamma(1,1);
  sigma ~ inv_gamma(1,1);
  //likelihood
  y ~ multi_normal_cholesky(rep_vector(0, N), L_cov);
}

generated quantities {
  // generates a random function
  vector[N_predict] f_predict = gp_pred_rng(long_predict, lat_predict, y, longit,latit, alpha, rho, sigma, 1e-10);

  //adds on noise
  vector[N_predict] y_predict;
  for (n in 1:N_predict)
    y_predict[n] = normal_rng(f_predict[n], sigma);
}


data {
  int<lower=0> N;  // number of observations
  int<lower=0> J;  // number of categories
  vector[N] x; // observation year
  vector<lower=0>[J] y[N]; // observations
  real xpred; // prediction year
  real sd_mean; // Standard deviations of each group (1960-2005)
  real slope_mean;
  real intercept_mean;
}
parameters {
  real mu_alpha; // Alpha prior mean
  real mu_beta; // Beta prior mean
  real<lower=0> sigma_alpha; // Alpha prior std
  real<lower=0> sigma_beta; // Beta prior std
  vector[J] alpha; // category intercepts
  vector[J] beta; // category slopes
  real<lower=0> sigma; // Common positive std
}
model {
  // priors
  mu_alpha ~ normal(intercept_mean,10);
  mu_beta ~ normal(slope_mean,100);
  sigma_alpha ~ normal(300,100);
  sigma_beta ~ normal(3000,1000);
  alpha ~ normal(mu_alpha, sigma_alpha);
  beta ~ normal(mu_beta, sigma_beta);
  sigma ~ normal(sd_mean, 1000);
  
  // likelihood
  for (j in 1:J)
    y[,j] ~ normal(alpha[j]+beta[j]*x, sigma);
}
generated quantities {
  // Prediction for combusted materials
  real ypred_c = normal_rng(alpha[1] + beta[1]*xpred, sigma); 
  // Prediction for recycled materials
  real ypred_r = normal_rng(alpha[2] + beta[2]*xpred, sigma); 
  // Prediction for landfilled materials
  real ypred_l = normal_rng(alpha[3] + beta[3]*xpred, sigma);
  // Replicated data sets
  real yrep_c[N] = normal_rng(alpha[1] + beta[1]*x, sigma);
  real yrep_r[N] = normal_rng(alpha[2] + beta[2]*x, sigma);
  real yrep_l[N] = normal_rng(alpha[3] + beta[3]*x, sigma);
  vector[J*N] log_lik;
  
  for (j in 1:J) {for (n in 1:N)
    log_lik[n + (j-1)*N] = normal_lpdf(y[n,j] | alpha[j]+beta[j]*x[n], sigma);
    // "n + (j-1)*N" calculates the column index of the S-by-N 
    // matrix, from the row & column 
    // index of the observation.
  }
}

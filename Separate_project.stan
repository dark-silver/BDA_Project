data {
  int<lower=0> N;  // number of observations
  int<lower=0> J;  // number of categories
  vector[N] x; // observation year
  vector<lower=0>[J] y[N]; // observations
  real xpred; // prediction year
  vector[J] alpha_mean; //Means for alpha priors
  vector[J] beta_mean; //Means for beta priors
  //vector[J] sds; // Standard deviations of each group (1960-2005)
}
parameters {
  vector[J] alpha; // category intercepts
  vector[J] beta; // category slopes
  vector<lower=0>[J] sigma; // category stds
}
model {
  // priors
  for (j in 1:J){
    alpha[j] ~ normal(alpha_mean[j], 100);
    beta[j] ~ normal(beta_mean[j], 1000);
    sigma[j] ~ normal(400000, 100000);
  }
  
  // likelihood
  for (j in 1:J)
    y[,j] ~ normal(alpha[j]+beta[j]*x, sigma[j]);
}
generated quantities {
  // 2019 prediction for combusted materials
  real ypred_c = normal_rng(alpha[1] + beta[1]*xpred, sigma[1]); 
  // 2019 prediction for recycled materials
  real ypred_r = normal_rng(alpha[2] + beta[2]*xpred, sigma[2]); 
  // 2019 prediction for landfilled materials
  real ypred_l = normal_rng(alpha[3] + beta[3]*xpred, sigma[3]);
  // Replicated data sets
  real yrep_c[N] = normal_rng(alpha[1] + beta[1]*x, sigma[1]);
  real yrep_r[N] = normal_rng(alpha[2] + beta[2]*x, sigma[2]);
  real yrep_l[N] = normal_rng(alpha[3] + beta[3]*x, sigma[3]);
  // For LOO-CV
  vector[J*N] log_lik;
  
  for (j in 1:J) {for (n in 1:N)
    log_lik[n + (j-1)*N] = normal_lpdf(y[n,j] | alpha[j]+beta[j]*x[n], sigma[j]);
    // "n + (j-1)*N" calculates the column index of the S-by-N 
    // matrix, from the row & column 
    // index of the observation.
  }
}

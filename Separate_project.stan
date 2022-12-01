data {
  int<lower=0> N;  // number of observations
  int<lower=0> J;  // number of categories
  vector[N] x; // observation year
  vector[J] y[N]; // observations
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
  }
  
  // likelihood
  for (j in 1:J)
    y[,j] ~ normal(alpha[j]+beta[j]*x, sigma[j]);
}
generated quantities {
  // Prediction for combusted materials
  real ypred_c = normal_rng(alpha[1] + beta[1]*xpred, sigma[1]); 
  // Prediction for recycled materials
  real ypred_r = normal_rng(alpha[2] + beta[2]*xpred, sigma[2]); 
  // Prediction for landfilled materials
  real ypred_l = normal_rng(alpha[3] + beta[3]*xpred, sigma[3]); 
}


#install.packages("readxl")
#nstall.packages("DescTools")
library(readxl)
library(tidyr)
library(DescTools)
library(plyr)
library(ggplot2)
library(reshape2)
library(rstan) 
#library(cmdstanr)
rstan_options(auto_write = TRUE)
options(mc.cores = 1)
# library(loo)
library(bayesplot)
library(posterior)

multiplesheets <- function(fname) {
  
  # getting info about all excel sheets
  sheets <- readxl::excel_sheets(fname)
  tibble <- lapply(sheets, function(x) readxl::read_excel(fname, sheet = x))
  data_frame <- lapply(tibble, as.data.frame)
  print(data_frame)
  
  # assigning names to data frames
  names(data_frame) <- sheets
  
  init_df <<- data_frame
}

# specifying the path name
path <- "/Users/vilmatiainen/Documents/Aalto bsc/Year 3/BDA/Project/Materials_Municipal_Waste_Stream_1960_2018.xlsx"
multiplesheets(path)

# Dataframe for storing the textile data
all_data <- data.frame(matrix(ncol = 0, nrow = 15))

# Add the data to the dataframe
for (name in names(init_df)) {
  df <- init_df[name][[1]]
  no_na <- drop_na(df)
  row_df <- data.frame(no_na[,-1], row.names=no_na[,1])
  new_df <- row_df[grep("Textiles", rownames(row_df)), ]
  t_df <- t(new_df)
  if (ncol(t_df) > 0) {
    colnames(t_df) <- c(name)
    all_data <<- cbind(all_data, t_df)
  }
}

# Clean up row names
rownames(all_data) <-gsub("X","",as.character(rownames(all_data)))

all_data['year'] <- as.numeric(as.character(rownames(all_data)))
all_data['Materials recycled-%'] <- (all_data['Materials recycled']/all_data['Materials generated'])*100
all_data['Material combusted-%'] <- (all_data['Material combusted']/all_data['Materials generated'])*100
all_data['Materials landfilled-%'] <- (all_data['Materials landfilled']/all_data['Materials generated'])*100

rownames(all_data) <- NULL

plot(x=all_data[['year']], y=all_data[['Material combusted']], type='l')

#Estimate intercept means:
recycled_intercept <- 680000*0.001 #US population in year 0  times 1kg (0.001 tonnes) for clothing waste in a yera per person
combusted_intercept <- 0
landfilled_intercept <- 0

#Estimate slope means:
summary_2 <- summary(lm(`Materials recycled` ~ year, data=all_data[(1:6),]))
recycled_slope <- summary_2$coefficients[2,1]
recycled_sd <- sd(all_data[1:6,'Materials recycled'])
summary_3 <- summary(lm(`Material combusted` ~ year, data=all_data[(1:6),]))
combusted_slope <- summary_3$coefficients[2,1]
combusted_sd <- sd(all_data[1:6,'Material combusted'])
summary_4 <- summary(lm(`Materials landfilled` ~ year, data=all_data[(1:6),]))
landfilled_slope <- summary_4$coefficients[2,1]
landfilled_sd <- sd(all_data[1:6,'Materials landfilled'])

hierarchical_slope_mean <- (recycled_slope + combusted_slope + landfilled_slope)/3
hierarchical_sd_mean <- (recycled_sd + combusted_sd + landfilled_sd)/3

data_list = list(
  N = nrow(all_data),
  J = ncol(all_data),
  x = all_data['year'],
  y = all_data[, 2:4],
  xpred = 2019,
  sd_mean = hierarchical_sd_mean,
  slope_mean = hierarchical_slope_mean
)

fit_hierarchical <- stan(file = "Hierarchical_project.stan", data = data_list)
monitor(fit_hierarchical)

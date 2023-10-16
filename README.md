# Predicting Textile Waste in Landfills - BDA Final Project

## Overview

This repository contains the code and report for our final project in the Bayesian Data Analysis course at Aalto University in the Fall of 2022. The project focuses on predicting the amount of textile waste in landfills in the United States. We aim to generate predictions on landfilling, recycling, and combustion of waste.

## Main Project Documents

- [Final_project.pdf](Final_project.pdf): This is the final project report, which provides a detailed overview of our project, including our motivation, methodology, results, and conclusions.

- [Project.rmd](Project.rmd): This file is the R Markdown version of the final project report. It contains all the code used in the project, presented as separate code chunks, making it easy for readers to review and run the code independently. Note: the Stan files in this repository are necessary for this file to run properly.

## Motivation

In light of the current global concerns about sustainability and environmental impact, we aimed to contribute to research on textile waste management. Our project's primary goal is to predict the amount of textile waste in landfills, focusing on the United States.

## Methodology

To achieve our goal, we followed these key steps:

1. **Data Selection:** We chose data on US landfills and consumption habits as it was the most reliable and accessible dataset for our analysis.

2. **Modeling:** We designed weakly informative priors and fit two models to predict textile waste in landfills.

3. **Model Comparison:** We compared the models using Leave-One-Out Cross-Validation (LOO-CV) to evaluate their performance.

4. **Posterior Predictive Checks:** We conducted posterior predictive checks to assess the model's predictive accuracy.

5. **Sensitivity Analyses:** We performed sensitivity analyses to understand the robustness of our results.

## Usage

To get started with the code and reproduce our results, follow these steps:

1. Clone the repository to your local machine:

   ```bash
   git clone https://github.com/yourusername/bda-final-project.git
   ```

2. Open the `Project.rmd` file in R or RStudio to access the code and run it. If you encounter the "Polygon edge not found" error when generating plots, it can often be resolved by restarting RStudio.

## Dependencies

Please note that the project was developed using specific versions of the following dependencies. While it may work with other versions, they have not been thoroughly tested.

- R (version 4.2.1)
- Stan (version 2.21.0)
- Other required R packages:

   - `readxl`
   - `tidyr`
   - `plyr`
   - `ggplot2`
   - `reshape2`
   - `rstan`
   - `bayesplot`
   - `posterior`
   - `knitr`
   - `cowplot`

## License

This project is licensed under the [MIT License](LICENSE). Feel free to use and modify the code as needed, but remember to give credit to the original authors.

## Contact

For any questions or inquiries about the project, please contact:

- Rajat Kaul (rajat.kaul@aalto.fi)
- Vilma Tiainen (vilma.tiainen@aalto.fi)

We hope you find our project informative and valuable. Thank you for your interest in our work!

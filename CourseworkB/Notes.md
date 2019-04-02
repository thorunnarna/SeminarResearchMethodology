## Exploration of the data

We first look at the distribution of the scores in general.
- > Show plots density 
We can see that there is a clear mixture of two distributions. In order to explain these mixture and where it comes from we decided to fit a linear model with every parameter involved. We then used Anova to see how much of this variance could be explained by these parameters. We obtained a R-squared value of 0.9487 which is very high.
We then try to see which parameter have the most influence on the model and it appears that a model fitted using only the test dataset have a R-squared value of 0.9159. So from what we tried, knowing the model or the training datasets help to explain only 3 more percent of variance.

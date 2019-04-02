## Exploration of the data

We first look at the distribution of the scores in general.
- > Show plots density 
We can see that there is a clear mixture of two distributions. In order to explain these mixture and where it comes from we decided to fit a linear model with every parameter involved. We then used Anova to see how much of this variance could be explained by these parameters. We obtained a R-squared value of 0.9487 which is very high.
We then try to see which parameter have the most influence on the model and it appears that a model fitted using only the test dataset have a R-squared value of 0.9159. So from what we tried, knowing the model or the training datasets help to explain only 3 more percent of variance.


FEEDBACK:

- Try to focus more on exploring the data than on statistical testing. Focus more on effect sizes than p-values. Do not let test assumptions restrict the kind of questions
	 you ask to the data.
	# I have added values for means and std for all models in RQ1


- One way to approach the problem is to fit a large preliminary model and see what factors have the largest effects, for instance by running ANOVA. Let this first analysis 
	guide the rest of your work. For example, consider how the data is distributed across different datasets and how we can control for it.
	# Nathan working on big model


- The experiment had a clear structure; try exploiting that structure in your models by including more factors or separating the analysis in groups. What do figures 1 and 2 
	suggest by their shape? You point to something related in page 5 and the boxplots thereafter.


- It could be interesting to transform the data, perhaps per dataset, in search for homogeneity. 
 	# Scores per model for each TrD?

- It could be interesting to consider other factors not explicit in the data, such as the number of training datasets. Another idea, suggested by your paragraph right before 
	RQ3, is to model the model as an *ordered* factor.
	#


- It could be interesting to check for interactions, for instance between training sets and test sets. Your figures 3 and 5 show very clear interaction effects, and you correctly 
	identify something with TrD2. What is it?
	# which interaction effect?

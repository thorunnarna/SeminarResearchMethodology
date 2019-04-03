

d <- read.csv("data.csv")
d$Type<-substr(d$model,1,1) #add one extra column to aggregate all B, and all M.
d$Type <- factor(d$Type)
str(d)

## Exploration of the data
bd = subset(d,model == 'B1' | model == 'B2' | model == 'B3')

mmd = subset(d,model == 'MN' | model == 'M1' | model == 'M2' | model == 'M3' | model == 'MF')

bmd = subset(d,Type == "B" | Type == "M")

t.test(bd$score,mmd$score)
mean(bd$score)
mean(mmd$score)

plot(density(bd$score))

modelBig <- lm(score ~ TeD + TrD1 + TrD2 + TrD3 + TrD4 + TrD5 + TrD6 + TrD7 + TrD8 + model,data=d)
modelTeD <- lm(score ~ TeD, data=d)

modelTeDbm <- lm(score ~ TeD, data=bmd)
modelTeDTypebm <- lm(score ~ TeD + Type, data=bmd)

anova(modelBig)
summary(modelBig)

anova(modelTeD)
summary(modelTeD)

anova(modelTeDbm,modelTeDTypebm)
summary(modelTeDType)

# Separate in three groups
dataClassification = subset(d, TeD == "TeD1" | TeD == "TeD2" | TeD == "TeD3" | TeD == "TeD4")
plot(density(dataClassification$score), main="Classification tasks scores")

dataRecommendation = subset(d, TeD == "TeD5")
plot(density(dataRecommendation$score), main="Recommendation tasks scores")

dataRegression = subset(d, TeD == "TeD6" | TeD == "TeD7")
plot(density(dataRegression$score), main="Regression tasks scores")


# Get all means for Baselines
mean(subset(d,Type=="B" & TeD=="TeD1")$score)
mean(subset(d,Type=="B" & TeD=="TeD2")$score)
mean(subset(d,Type=="B" & TeD=="TeD3")$score)
mean(subset(d,Type=="B" & TeD=="TeD4")$score)
mean(subset(d,Type=="B" & TeD=="TeD5")$score)
mean(subset(d,Type=="B" & TeD=="TeD6")$score)
mean(subset(d,Type=="B" & TeD=="TeD7")$score)

# get all means for models
mean(subset(d,Type=="M" & TeD=="TeD1")$score)
mean(subset(d,Type=="M" & TeD=="TeD2")$score)
mean(subset(d,Type=="M" & TeD=="TeD3")$score)
mean(subset(d,Type=="M" & TeD=="TeD4")$score)
mean(subset(d,Type=="M" & TeD=="TeD5")$score)
mean(subset(d,Type=="M" & TeD=="TeD6")$score)
mean(subset(d,Type=="M" & TeD=="TeD7")$score)


#calculate scores for each trainins set and each test set.

AggregateTrD1PertrainAndType<-aggregate(list(d$score), by =list(d$TrD1, d$Type) , mean)
AggregateTrD2PertrainAndType<-aggregate(list(d$score), by =list(d$TrD2, d$Type) , mean)
AggregateTrD3PertrainAndType<-aggregate(list(d$score), by =list(d$TrD3, d$Type) , mean)
AggregateTrD4PertrainAndType<-aggregate(list(d$score), by =list(d$TrD4, d$Type) , mean)
AggregateTrD5PertrainAndType<-aggregate(list(d$score), by =list(d$TrD5, d$Type) , mean)
AggregateTrD6PertrainAndType<-aggregate(list(d$score), by =list(d$TrD6, d$Type) , mean)
AggregateTrD7PertrainAndType<-aggregate(list(d$score), by =list(d$TrD7, d$Type) , mean)
AggregateTrD8PertrainAndType<-aggregate(list(d$score), by =list(d$TrD8, d$Type) , mean)

TrD1M<-AggregateTrD1PertrainAndType[3,3]
TrD2M<-AggregateTrD2PertrainAndType[3,3]
TrD3M<-AggregateTrD3PertrainAndType[3,3]
TrD4M<-AggregateTrD4PertrainAndType[3,3]
TrD5M<-AggregateTrD5PertrainAndType[3,3]
TrD6M<-AggregateTrD6PertrainAndType[3,3]
TrD7M<-AggregateTrD7PertrainAndType[3,3]
TrD8M<-AggregateTrD8PertrainAndType[3,3]

#aggregate on the values we need
AggregateTrD1PertrainTestAndType<-aggregate(list(d$score), by =list(d$TrD1, d$Type,d$TeD) , mean)
AggregateTrD2PertrainTestAndType<-aggregate(list(d$score), by =list(d$TrD2, d$Type,d$TeD) , mean)
AggregateTrD3PertrainTestAndType<-aggregate(list(d$score), by =list(d$TrD3, d$Type,d$TeD) , mean)
AggregateTrD4PertrainTestAndType<-aggregate(list(d$score), by =list(d$TrD4, d$Type,d$TeD) , mean)
AggregateTrD5PertrainTestAndType<-aggregate(list(d$score), by =list(d$TrD5, d$Type,d$TeD) , mean)
AggregateTrD6PertrainTestAndType<-aggregate(list(d$score), by =list(d$TrD6, d$Type,d$TeD) , mean)
AggregateTrD7PertrainTestAndType<-aggregate(list(d$score), by =list(d$TrD7, d$Type,d$TeD) , mean)
AggregateTrD8PertrainTestAndType<-aggregate(list(d$score), by =list(d$TrD8, d$Type,d$TeD) , mean)

#select the wvalues we want from that
subsetTr1 <- AggregateTrD1PertrainTestAndType[which(AggregateTrD1PertrainTestAndType$Group.1 == 1&AggregateTrD1PertrainTestAndType$Group.2 == 'M'),]
subsetTr2 <- AggregateTrD2PertrainTestAndType[which(AggregateTrD2PertrainTestAndType$Group.1 == 1&AggregateTrD2PertrainTestAndType$Group.2 == 'M'),]
subsetTr3 <- AggregateTrD3PertrainTestAndType[which(AggregateTrD3PertrainTestAndType$Group.1 == 1&AggregateTrD3PertrainTestAndType$Group.2 == 'M'),]
subsetTr4 <- AggregateTrD4PertrainTestAndType[which(AggregateTrD4PertrainTestAndType$Group.1 == 1&AggregateTrD4PertrainTestAndType$Group.2 == 'M'),]
subsetTr5 <- AggregateTrD5PertrainTestAndType[which(AggregateTrD5PertrainTestAndType$Group.1 == 1&AggregateTrD5PertrainTestAndType$Group.2 == 'M'),]
subsetTr6 <- AggregateTrD6PertrainTestAndType[which(AggregateTrD6PertrainTestAndType$Group.1 == 1&AggregateTrD6PertrainTestAndType$Group.2 == 'M'),]
subsetTr7 <- AggregateTrD7PertrainTestAndType[which(AggregateTrD7PertrainTestAndType$Group.1 == 1&AggregateTrD7PertrainTestAndType$Group.2 == 'M'),]
subsetTr8 <- AggregateTrD8PertrainTestAndType[which(AggregateTrD8PertrainTestAndType$Group.1 == 1&AggregateTrD8PertrainTestAndType$Group.2 == 'M'),]

#transform to array so we can plot efficiently
subTr1<-subsetTr1[(1:7), 4]
subTr2<-subsetTr2[(1:7), 4]
subTr3<-subsetTr3[(1:7), 4]
subTr4<-subsetTr4[(1:7), 4]
subTr5<-subsetTr5[(1:7), 4]
subTr6<-subsetTr6[(1:7), 4]
subTr7<-subsetTr7[(1:7), 4]
subTr8<-subsetTr8[(1:7), 4]

## RQ1

#each baseline
subsetB1 <-d[which(d$model == 'B1'),]
subsetB2 <-d[which(d$model == 'B2'),]
subsetB3 <-d[which(d$model == 'B3'),]
#each M model
subsetMN <-d[which(d$model == 'MN'),]
subsetM1 <-d[which(d$model == 'M1'),]
subsetM2 <-d[which(d$model == 'M2'),]
subsetM3 <-d[which(d$model == 'M3'),]
subsetMF <-d[which(d$model == 'MF'),]


subsetB<-d[which(d$model == 'B1'|d$model == 'B2'|d$model == 'B3'),]
subsetM<-d[which(d$model == 'MN'|d$model == 'M1'|d$model == 'M2'|d$model == 'M3'|d$model == 'MF'),]
subsetBM <-d[which(d$model != 'S'),]
subsetS <-d[which(d$model == 'S'),]


AggregateByModel<-aggregate(list(d$score), by =list(d$TeD, d$model) , mean)
AggregateByType<-aggregate(list(d$score), by =list(d$TeD, d$Type) , mean)

B<-AggregateByType[(1:7), 3]
M<-AggregateByType[(8:14), 3]



dev.new(width=6, height=6)
plot(subTr1,type = "profile",col = "red", xlab = "Testing set", ylab = "Mean score")
lines(subTr2, type = "o", col = "magenta")
lines(subTr3, type = "o", col = "green")
lines(subTr4, type = "o", col = "yellow")
lines(subTr5, type = "o", col = "orange")
lines(subTr6, type = "o", col = "pink")
lines(subTr7, type = "o", col = "purple")
lines(subTr8, type = "o", col = "black")


# take a closer look at the data.
hist(subsetB$score)
hist(subsetM$score)

#calculate all means
meanB1 <-mean(subsetB1$score)
meanB2 <-mean(subsetB2$score)
meanB3 <-mean(subsetB3$score)

meanMN <-mean(subsetMN$score)
meanM1 <-mean(subsetM1$score)
meanM2 <-mean(subsetM2$score)
meanM3 <-mean(subsetM3$score)
meanMF <-mean(subsetMF$score)

meanB <-mean(B)
meanM <-mean(M)
meanAll <-mean(d$score)


#calculate all standard deviation
stdB1 <-sd(subsetB1$score)
stdB2 <-sd(subsetB2$score)
stdB3 <-sd(subsetB3$score)

stdMN <-sd(subsetMN$score)
stdM1 <-sd(subsetM1$score)
stdM2 <-sd(subsetM2$score)
stdM3 <-sd(subsetM3$score)
stdMF <-sd(subsetMF$score)

stdB <-sd(B)
stdM <-sd(M)
stdAll <-sd(d$score)

#simple t-test on the means
t.test(subsetB$score,subsetM$score)
subsetBmean<-mean(subsetB$score)
subsetMmean<-mean(subsetM$score)

#paired t-test on the means for each testing dataset.
t.test(B, M, paired = TRUE, alternative = "two.sided")

# Plot paired data  
library(PairedData)
pd <- paired(B, M)
plot(pd, type = "profile") + theme_bw()

#tes tdistribution of the differences.
difference <- (M-B)
shapiro.test(difference)

## RQ2
data <- read.csv("data.csv")
dbase = subset(data,data$model=='MN' | data$model=='M1' | data$model=='M2' | data$model=='M3' | data$model=='MF' | data$model=='S')
d1 = subset(dbase,dbase$TeD=='TeD1')
d2 = subset(dbase,dbase$TeD=='TeD2')
d3 = subset(dbase,dbase$TeD=='TeD3')
d4 = subset(dbase,dbase$TeD=='TeD4')
d5 = subset(dbase,dbase$TeD=='TeD5')
d6 = subset(dbase,dbase$TeD=='TeD6')
d7 = subset(dbase,dbase$TeD=='TeD7')

install.packages("dplyr")

library(dplyr)
group_by(d, model) %>%
  summarise(
    count = n(),
    mean = mean(score, na.rm = TRUE),
    sd = sd(score, na.rm = TRUE)
  )

dn <- subset(d,d$model=='MN')
d1 <- subset(d,d$model=='M1')
d2 <- subset(d,d$model=='M2')
d3 <- subset(d,d$model=='M3')
df <- subset(d,d$model=='MF')


par(mfrow=c(7,1))
boxplot(d1$score ~ d1$model,main="TeD1")
boxplot(d2$score ~ d2$model,main="TeD2")
boxplot(d3$score ~ d3$model,main="TeD3")
boxplot(d4$score ~ d4$model,main="TeD4")
boxplot(d5$score ~ d5$model,main="TeD5")
boxplot(d6$score ~ d6$model,main="TeD6")
boxplot(d7$score ~ d7$model,main="TeD7")


res = aov(d$score ~ d$model)

summary(res)
TukeyHSD(res)



## RQ3
d = subset(data, data$model=='S')

d$TrD <- ifelse(d$TrD1==1,1,ifelse(d$TrD2==1,2,ifelse(d$TrD3==1,3,ifelse(d$TrD4==1,4,ifelse(d$TrD5==1,5,ifelse(d$TrD6==1,6,ifelse(d$TrD7==1,7,ifelse(d$TrD8==1,8,0))))))))

d1 = subset(d,d$TeD=='TeD1')
d2 = subset(d,d$TeD=='TeD2')
d3 = subset(d,d$TeD=='TeD3')
d4 = subset(d,d$TeD=='TeD4')
d5 = subset(d,d$TeD=='TeD5')
d6 = subset(d,d$TeD=='TeD6')
d7 = subset(d,d$TeD=='TeD7')


library(dplyr)
group_by(d, TrD) %>%
  summarise(
    count = n(),
    mean = mean(score, na.rm = TRUE),
    sd = sd(score, na.rm = TRUE)
  )

boxplot(d$score ~ factor(d1$TrD))

par(mfrow=c(4,2))
boxplot(d1$score ~ factor(d1$TrD),main="TeD1")
boxplot(d2$score ~ factor(d2$TrD),main="TeD2")
boxplot(d3$score ~ factor(d3$TrD),main="TeD3")
boxplot(d4$score ~ factor(d4$TrD),main="TeD4")
boxplot(d5$score ~ factor(d5$TrD),main="TeD5")
boxplot(d6$score ~ factor(d6$TrD),main="TeD6")
boxplot(d7$score ~ factor(d7$TrD),main="TeD7")

res = aov(d1$score ~ factor(d1$TrD))
summary(res)

TukeyHSD(res)


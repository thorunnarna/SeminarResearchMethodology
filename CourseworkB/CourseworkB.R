d <- read.csv("data.csv")
str(d)

## RQ1
d$Type<-substr(d$model,1,1) #add one extra column to aggregate all B, and all M.

subsetB1 <-d[which(d$model == 'B1'),]
subsetB2 <-d[which(d$model == 'B2'),]
subsetB3 <-d[which(d$model == 'B3'),]

subsetB<-d[which(d$model == 'B1'|d$model == 'B2'|d$model == 'B3'),]
subsetM<-d[which(d$model == 'MN'|d$model == 'M1'|d$model == 'M2'|d$model == 'M3'|d$model == 'MF'),]
subsetS <-d[which(d$model == 'S'),]


AggregateByModel<-aggregate(list(d$score), by =list(d$TeD, d$Model) , mean)
AggregateByType<-aggregate(list(d$score), by =list(d$TeD, d$Type) , mean)

B<-AggregateByType[(1:7), 3]
M<-AggregateByType[(8:14), 3]

# take a closer look at the data.
hist(subsetB$score)
hist(subsetM$score)

meanB <-mean(B)
meanM <-mean(M)
meanAll <-mean(d$score)

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


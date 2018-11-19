# Introduction to R
# R as calculator:
5*2
5**2
exp(10)
log(23)
log10(23)
sqrt(9)
prod(3:8)
pi

### more: http://courses.atlas.illinois.edu/fall2016/STAT/STAT200/RProgramming/RCalculator.html

#### basic comands
x <- c(1,2,4,8,16)   #create a data vector with specified elements
y <- c(1:10)          #create a data vector with elements 1-10
n <- 10
x1 <- c(rnorm(n))      #create a n item vector of random normal deviates
y1 <- c(runif(n))+n       #create another n item vector that has n added to each random uniform distribution
vect <- c(x,y)              #combine them into one vector of length 2n
mat <- cbind(x,y)             #combine them into a n x 2 matrix
mat[4,2]                      #display the 4th row and the 2nd column
mat[3,]                       #display the 3rd row
mat[,2]                        #display the 2nd column

# Set working directory to where csv file is located
setwd("/home/bruno/Área de Trabalho/Introducao ao R")

# Read the data
mydata<- read.csv("/home/bruno/Área de Trabalho/Introducao ao R/intro_auto.csv")
attach(mydata)

# List the variables
names(mydata)

# Show first lines of data
head(mydata)
mydata[1:10,]

# Descriptive statistics
summary(mpg)
sd(mpg)
length(mpg)
summary(price)
sd(price)

# Sort the data
sort(make)

# Frequency tables
table(make)
table (make, foreign)

# Correlation among variables
cor(price, mpg)

# T-test for mean of one group
t.test(mpg, mu=20)

# ANOVA for equality of means for two groups
anova(lm(mpg ~ factor(foreign)))

# OLS regression - mpg (dependent variable) and weight, length and foreign (independent variables)
olsreg <- lm(mpg ~ weight + length + foreign)
summary(olsreg)
# summary(lm(mpg ~ weight + length + foreign))

# Plotting data
plot (mpg ~ weight)
olsreg1 <- lm(mpg ~ weight)
abline(olsreg1)

# Redefining variables 
Y <- cbind(mpg)
X <- cbind(weight, length, foreign)
summary(Y)
summary(X)
olsreg <- lm(Y ~ X)
summary(olsreg) 

# install.packages("dplyr")
library(dplyr)
library(downloader)
url <- "https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/msleep_ggplot2.csv"
filename <- "msleep_ggplot2.csv"
if (!file.exists(filename)) download(url,filename)
msleep <- read.csv("msleep_ggplot2.csv")
head(msleep)

### using select
sleepData <- select(msleep, name, sleep_total)
head(sleepData)

### using filter
filter(msleep, sleep_total >= 16)
filter(msleep, sleep_total >= 16, bodywt >= 1)
filter(msleep, order %in% c("Perissodactyla", "Primates"))

### using Pipe operator: %>%
msleep %>% 
  select(name, sleep_total) %>% 
  head

## arrange
msleep %>% 
  select(name, order, sleep_total) %>%
  arrange(order, sleep_total) %>% 
  head

## mutate
msleep %>% 
  mutate(rem_proportion = sleep_rem / sleep_total) %>%
  head

## summarize
msleep %>% 
  summarise(avg_sleep = mean(sleep_total), 
            min_sleep = min(sleep_total),
            max_sleep = max(sleep_total),
            total = n())

## group_by
msleep %>% 
  group_by(order) %>%
  summarise(avg_sleep = mean(sleep_total), 
            min_sleep = min(sleep_total), 
            max_sleep = max(sleep_total),
            total = n())



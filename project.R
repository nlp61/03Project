rm(list = ls())

setwd('~/Dropbox/School/Data Science/JH/03. Getting and Cleaning Data/data/UCI HAR Dataset')

library(data.table)

test.x <- read.table('test/X_test.txt')
test.y <- read.table('test/y_test.txt')
test.sub <- read.table('test/subject_test.txt')

train.x <- read.table('train/X_train.txt')
train.y <- read.table('train/y_train.txt')
train.sub <- read.table('train/subject_train.txt')

features <- read.table('features.txt')
features. <- as.character(features[,2])

train.df <- data.frame(train.x, train.sub, rep('Train',nrow(train.x)),train.y)
names(train.df) <- c(features.,'Subject','Type', 'Y')

test.df <- data.frame(test.x, test.sub, rep('Test',nrow(test.x)),test.y)
names(test.df) <- c(features., 'Subject', 'Type', 'Y')

means <- grep('mean', features.)
stds <- grep('std', features.)
idx <- sort(c(means, stds))
vars <- names(test.df)[idx]
n <- ncol(test.df)

dat.df <- rbind(train.df[,c(idx, (n-2):n)],test.df[,c(idx, (n-2):n)])
head(dat.df)

dat.df$Activity <- dat.df$Y
dat.df$Activity[dat.df$Activity==1]  <- 'WALKING'
dat.df$Activity[dat.df$Activity==2]  <- 'WALKING_UPSTAIRS'
dat.df$Activity[dat.df$Activity==3]  <- 'WALKING_DOWNSTAIRS'
dat.df$Activity[dat.df$Activity==4]  <- 'SITTING'
dat.df$Activity[dat.df$Activity==5]  <- 'STANDING'
dat.df$Activity[dat.df$Activity==6]  <- 'LAYING'


uid <- paste0(dat.df$Subject, '-', dat.df$Activity)

tmp <- apply(dat.df[,vars], 2, by, uid, mean)
tmp.2 <- strsplit(rownames(tmp),'-')
Subject <- as.numeric(lapply(tmp.2,'[',1))
Activity <- as.character(lapply(tmp.2,'[',2))

result <- data.frame(tmp, Subject, Activity, row.names = 1:length(Subject))
names(result) <- c(vars, 'Subject','Activity')

write.table(result, file = '../../Project/step5.txt', row.name = FALSE, sep = '\t')

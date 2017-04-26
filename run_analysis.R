# Download and unzip the data folder

setwd("~/Coursera/Data Science/Getting and Cleaning Data")

filename <- "get_data.zip"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if (!file.exists(filename)) {
  download.file(url, destfile = filename, method="curl")
}

if (!file.exists("UCI HAR Dataset")) {
  unzip(filename)
}

# Load Activity and Features

ActivityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
ActivityLabels[,2] <- as.character(ActivityLabels[,2])

features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

featureswanted <- grep(".*mean().*|.*std().*", features[,2])
featureswanted_names <- features[featureswanted,2]

# Load the measurements for training data

train_data <- read.table("UCI HAR Dataset/train/X_train.txt")[featureswanted]
activity <- read.table("UCI HAR Dataset/train/Y_train.txt")
subject <- read.table("UCI HAR Dataset/train/subject_train.txt")

train <- cbind(subject, activity, train_data)

# Load the measurements for test data

test_data <- read.table("UCI HAR Dataset/test/X_test.txt")[featureswanted]
activity <- read.table("UCI HAR Dataset/test/Y_test.txt")
subject <- read.table("UCI HAR Dataset/test/subject_test.txt")

test <- cbind(subject, activity, test_data)

# Merge training and test datasets

alldata <- rbind(train, test)
colnames(alldata) <- c("Subject", "Activity", featureswanted_names)

# Convert subject and activity back to factors and label the activities

alldata$Subject <- as.factor(alldata$Subject)
alldata$Activity <- factor(alldata$Activity, levels = ActivityLabels[,1], labels = ActivityLabels[,2])

# Reshape the data and calculate mean for each subject and activity

alldata_melted <- melt(alldata, id=c("Subject", "Activity"))
alldata_mean <- dcast(alldata_melted, Subject + Activity ~ variable, mean)

write.table(alldata_mean, "tidydata.txt", row.names = FALSE, quote = FALSE)






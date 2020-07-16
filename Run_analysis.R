#load packages
library(dplyr)

setwd("C:/Users/gabri/Desktop/Coursera/")
#download and unzip dataset
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destFile <- "CourseDataset.zip"
if (!file.exists(destFile)){
  download.file(URL, destfile = destFile, mode='wb')
}
if (!file.exists("./UCI_HAR_Dataset")){
  unzip(destFile)
}
#create a path to the files
path = file.path("C:/Users/gabri/Desktop/Coursera", "UCI HAR Dataset")
files = list.files(path, recursive=TRUE)


##read train data
x_train = read.table(file.path(path, "train", "X_train.txt"),header = FALSE)
y_train = read.table(file.path(path, "train", "y_train.txt"),header = FALSE)
subject_train = read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)

##read test data
x_test = read.table(file.path(path, "test", "X_test.txt"), header = FALSE)
y_test = read.table(file.path(path, "test", "y_test.txt"),header = FALSE)
subject_test = read.table(file.path(path, "test", "subject_test.txt"),header = FALSE)

##read features and activity labels
features <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")


#Uses descriptive activity names to name the activities in the data set
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityID"
colnames(subject_train) <- "subjectID"

colnames(x_test) <- features[,2]
colnames(y_test) <- "activityID"
colnames(subject_test) <- "subjectID"

colnames(activity_labels) <- c('activityId','activityType')


#Merges the training and the test sets to create one data set
all_train <- cbind(x_train, y_train, subject_train)
all_test <- cbind(x_test, y_test, subject_test)
all_data <- rbind(all_train, all_test)


#Extracts only the measurements on the mean and standard deviation for each measurement.
colNames <- colnames(all_data)
mean_sd = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))
set_mean_sd <- all_data[ , mean_sd == TRUE]


#Appropriately label the data set with descriptive variable names.
set_activity_name = merge(set_mean_sd, activity_labels, by='activityId', all.x=TRUE)


#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidyset2 <- aggregate(. ~subjectId + activityId, set_activity_name, mean)
tidyset2 <- tidyset2[order(tidyset2$subjectId, tidyset2$activityId),]

##output to a .txt file
write.table(tidyset2, "tidydataset.txt", row.names = FALSE)
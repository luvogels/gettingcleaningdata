# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
#
# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(dplyr)
library(reshape2)

# Read in the datafiles
test_data       <- read.table("UCI HAR Dataset/test/X_test.txt")
test_labels     <- read.table("UCI HAR Dataset/test/y_test.txt")

train_data      <- read.table("UCI HAR Dataset/train/X_train.txt")
train_labels    <- read.table("UCI HAR Dataset/train/y_train.txt")

test_subject    <- read.table("UCI HAR Dataset/test/subject_test.txt")
train_subject   <- read.table("UCI HAR Dataset/train/subject_train.txt")

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features        <- read.table("UCI HAR Dataset/features.txt")

# Convert the feature colum with names to a vector
names <- as.vector(features$V2)

# adds colum name to the labeld data
colnames(test_labels)<-c("activity.name")
colnames(train_labels)<-c("activity.name")

colnames(test_subject)<-c("subject")
colnames(train_subject)<-c("subject")

# merges the datasets
data <- rbind(test_data, train_data)

# ads the names as colum headers
colnames(data) <- names


# adds the activity type and subject to the data by first combining the datalabels and then adding the column to the data data.frame
activity <- rbind(test_labels, train_labels)
data <- cbind(data, activity)

subjects <- rbind(test_subject, train_subject)
data <- cbind(data, subjects)


# Using descriptive activity names by replacing the numbers with appropriate text
data$activity.name[data$activity.name==1] <- as.character(activity_labels[1,2])
data$activity.name[data$activity.name==2] <- as.character(activity_labels[2,2])
data$activity.name[data$activity.name==3] <- as.character(activity_labels[3,2])
data$activity.name[data$activity.name==4] <- as.character(activity_labels[4,2])
data$activity.name[data$activity.name==5] <- as.character(activity_labels[5,2])
data$activity.name[data$activity.name==6] <- as.character(activity_labels[6,2])

# Creates a vector with all veriables that end with mean() or std()
vars <- c("tBodyAcc-std()-X","tBodyAcc-std()-Y","tBodyAcc-std()-Z","tGravityAcc-std()-X","tGravityAcc-std()-Y","tGravityAcc-std()-Z","tBodyAccJerk-std()-X","tBodyAccJerk-std()-Y","tBodyAccJerk-std()-Z","tBodyGyro-std()-X","tBodyGyro-std()-Y","tBodyGyro-std()-Z","tBodyGyroJerk-std()-X","tBodyGyroJerk-std()-Y","tBodyGyroJerk-std()-Z","tBodyAccMag-std()","tGravityAccMag-std()","tBodyAccJerkMag-std()","tBodyGyroMag-std()","tBodyGyroJerkMag-std()","fBodyAcc-std()-X","fBodyAcc-std()-Y","fBodyAcc-std()-Z","fBodyAccJerk-std()-X","fBodyAccJerk-std()-Y","fBodyAccJerk-std()-Z","fBodyGyro-std()-X","fBodyGyro-std()-Y","fBodyGyro-std()-Z","fBodyAccMag-std()","fBodyBodyAccJerkMag-std()","fBodyBodyGyroMag-std()","fBodyBodyGyroJerkMag-std()","tBodyAcc-mean()-X","tBodyAcc-mean()-Y","tBodyAcc-mean()-Z","tGravityAcc-mean()-X","tGravityAcc-mean()-Y","tGravityAcc-mean()-Z","tBodyAccJerk-mean()-X","tBodyAccJerk-mean()-Y","tBodyAccJerk-mean()-Z","tBodyGyro-mean()-X","tBodyGyro-mean()-Y","tBodyGyro-mean()-Z","tBodyGyroJerk-mean()-X","tBodyGyroJerk-mean()-Y","tBodyGyroJerk-mean()-Z","tBodyAccMag-mean()","tGravityAccMag-mean()","tBodyAccJerkMag-mean()","tBodyGyroMag-mean()","tBodyGyroJerkMag-mean()","fBodyAcc-mean()-X","fBodyAcc-mean()-Y","fBodyAcc-mean()-Z","fBodyAccJerk-mean()-X","fBodyAccJerk-mean()-Y","fBodyAccJerk-mean()-Z","fBodyGyro-mean()-X","fBodyGyro-mean()-Y","fBodyGyro-mean()-Z","fBodyAccMag-mean()","fBodyBodyAccJerkMag-mean()","fBodyBodyGyroMag-mean()","fBodyBodyGyroJerkMag-mean()")

dataMelt <- melt(data, id=c("activity.name", "subject"), measure.vars=vars)
act.data <- dcast(dataMelt, activity.name ~ variable,mean)
subject <- dcast(dataMelt, subject ~ variable,mean)

colnames(subject)[1]<- "id"
colnames(act.data)[1]<- "id"

tidy_data <- rbind(subject,act.data)

write.table(tidy_data, "tidy_data.txt") 

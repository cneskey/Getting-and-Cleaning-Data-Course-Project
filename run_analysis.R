#run_analysis.R
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## R script called run_analysis.R that does the following.
##1. Merges the training and the test sets to create one data set.
##2. Extracts only the measurements on the mean and standard deviation for each measurement.
##3. Uses descriptive activity names to name the activities in the data set
##4. Appropriately labels the data set with descriptive variable names.
##5. From the data set in step 4, creates a second, independent tidy data set with the
## average of each variable for each activity and each subject.

# Note: Assumes working directory is set to location of unzipped dataset.

# Install and load packages.
if (!require("data.table")) {
        install.packages("data.table")
}
if (!require("plyr")) {
        install.packages("plyr")
}

library("data.table")
library("plyr")

# Load activity and feature data into R. Using [,2] to exclude ordinal column.
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

# Load "test" sets and metadata into R.
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Load "train" sets and metadata into R.
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Name columns in sets before merging.
names(subject_train) <- "subject"
names(subject_test) <- "subject"
names(X_train) <- features
names(X_test) <- features
names(y_train) <- "activity"
names(y_test) <- "activity"


# Merges the training and the test sets to create one data set.
## Append the labels back onto the datasets.
### Merges x_test and y_test to "xy_test". i.e. Appends the labels(y_test) to the set(x_test).
xy_test <- cbind(subject_test, y_test, X_test)

### Merges x_train and y_train to "xy_train". i.e. Appends the labels(y_train) to the set(x_train).
xy_train <- cbind(subject_train, y_train, X_train)

## Merge xy_test and xy_train to "test_train". i.e. Recreates the original full dataset.
test_train <- rbind(xy_train, xy_test)

# Extracts only the measurements on the mean and standard deviation for each measurement.
## Creates index (T/F) of columns with mean/std and subject/activity.
features_mean_std <- grepl("mean|std|subject|activity", names(test_train))

## Creates new dataset with only cols containing subject,activity,mean or std.
test_train_mean_std <- test_train[, features_mean_std]

# Uses descriptive activity names to name the activities in the data set
## Converts "activity" column to factor then uses these strings in order as replacement.
test_train_mean_std$activity <- factor(test_train_mean_std$activity,
               labels=c("Walking","Walking Upstairs","Walking Downstairs",
                        "Sitting", "Standing", "Laying"))

# Appropriately labels the data set with descriptive variable names.
## Replace abbreviations in variable names with unnabreviations
names(test_train_mean_std) <- gsub("Acc", "Accelerator", names(test_train_mean_std))
names(test_train_mean_std) <- gsub("Mag", "Magnitude", names(test_train_mean_std))
names(test_train_mean_std) <- gsub("Gyro", "Gyroscope", names(test_train_mean_std))
names(test_train_mean_std) <- gsub("^t", "time", names(test_train_mean_std))
names(test_train_mean_std) <- gsub("^f", "frequency", names(test_train_mean_std))

# From the data set in step 4, creates a second, independent tidy data set with the
## average of each variable for each activity and each subject.
test_train_mean_std_AVGs = ddply(test_train_mean_std, c("subject","activity"), numcolwise(mean))
## add "Average" at end of each variable name to avoid confusion with other dataset.
names(test_train_mean_std_AVGs) <- gsub("-X", "-X Average", names(test_train_mean_std_AVGs))
names(test_train_mean_std_AVGs) <- gsub("-Y", "-Y Average", names(test_train_mean_std_AVGs))
names(test_train_mean_std_AVGs) <- gsub("-Z", "-Z Average", names(test_train_mean_std_AVGs))

write.table(test_train_mean_std_AVGs, file = "./tidy_data.txt")


Source of files: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
R script called run_analysis.R (the "analysis files") does the following.
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Note: Assumes working directory is set to location of unzipped dataset.

# Install and load packages.
# Load activity and feature data into R. Using [,2] to exclude ordinal column.
# Load "test" sets and metadata into R.
# Load "train" sets and metadata into R.
# Name columns in sets before merging.
# Merges the training and the test sets to create one data set.
## Append the labels back onto the datasets.
### Merges x_test and y_test to "xy_test". i.e. Appends the labels(y_test) to the set(x_test).
### Merges x_train and y_train to "xy_train". i.e. Appends the labels(y_train) to the set(x_train).
## Merge xy_test and xy_train to "test_train". i.e. Recreates the original full dataset.
# Extracts only the measurements on the mean and standard deviation for each measurement.
## Creates index (T/F) of columns with mean/std and subject/activity.
## Creates new dataset with only cols containing subject,activity,mean or std.
# Uses descriptive activity names to name the activities in the data set
## Converts "activity" column to factor then uses these strings in order as replacement.
# Appropriately labels the data set with descriptive variable names.
## Replace abbreviations in variable names with unnabreviations
# From the data set in step 4, creates a second, independent tidy data set with the
## average of each variable for each activity and each subject.
## add "Average" at end of each variable name to avoid confusion with other dataset.

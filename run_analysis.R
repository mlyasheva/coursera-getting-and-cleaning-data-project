## Read data.
subject_test <- read.table("./Desktop/UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("./Desktop/UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("./Desktop/UCI HAR Dataset/test/X_test.txt")
x_train <- read.table("./Desktop/UCI HAR Dataset/train/X_train.txt")
y_test <- read.table("./Desktop/UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("./Desktop/UCI HAR Dataset/train/y_train.txt")
activity_labels <- read.table("./Desktop/UCI HAR Dataset/activity_labels.txt")
features <- read.table("./Desktop/UCI HAR Dataset/features.txt")  


# 1. Merges the training and the test sets to create one data set.

# Create column values to the train data.
colnames(x_train) = features[,2]
colnames(y_train) = "activityId"
colnames(subject_train) = "subjectId"

# Create column values to the test data.
colnames(x_test) = features[,2]
colnames(y_test) = "activityId"
colnames(subject_test) = "subjectId"

# Create sanity check for the activity labels value.
colnames(activity_labels) <- c('activityId','activityType')

# Merge data.

mrg_train = cbind(y_train, subject_train, x_train)
mrg_test = cbind(y_test, subject_test, x_test)
AllInOne = rbind(mrg_train, mrg_test)


# 2. Extracts the mean and standard deviation for each measurement. 

# Read all the values that are available.
colNames = colnames(AllInOne)

# All the mean and standard deviation and the corresponding activityID and subjectID.
mean_and_std = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))

# A subtset created to get the required dataset.
MeanAndStd <- AllInOne[ , mean_and_std == TRUE]


# 3. Uses descriptive activity names to name the activities in the data set.

setWithActivityNames = merge(MeanAndStd, activity_labels, by='activityId', all.x=TRUE)


# 4. Appropriately labels the data set with descriptive activity names.

# New tidy set. 
TidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
TidySet <- TidySet[order(TidySet$subjectId, TidySet$activityId),]


# 5. Creates an independent tidy data set with the average of each variable for each activity and each subject (in txt format). 

write.table(TidySet, "TidySet.txt", row.name=FALSE)


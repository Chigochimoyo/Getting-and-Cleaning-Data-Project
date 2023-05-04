# Loading packages 

library(dplyr)

#Downloading files 

setwd("C:/Users/User/Desktop/Chigo/School/3 Getting and Cleaning/Course Project/Getting-and-Cleaning-Data-Project")

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(url,"zipped.zip")


unzip(wd,"zipped.zip")


      
# Reading datasets in R


activities <- read.table("C:/Users/User/Desktop/Chigo/School/3 Getting and Cleaning/Course Project/Getting-and-Cleaning-Data-Project/UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

features <- read.table("C:/Users/User/Desktop/Chigo/School/3 Getting and Cleaning/Course Project/Getting-and-Cleaning-Data-Project/UCI HAR Dataset/features.txt", col.names = c("n", "functions"))


subject_test <- read.table("C:/Users/User/Desktop/Chigo/School/3 Getting and Cleaning/Course Project/Getting-and-Cleaning-Data-Project/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

x_test <- read.table("C:/Users/User/Desktop/Chigo/School/3 Getting and Cleaning/Course Project/Getting-and-Cleaning-Data-Project/UCI HAR Dataset/test/X_test.txt", col.names = features$functions)

y_test <- read.table("C:/Users/User/Desktop/Chigo/School/3 Getting and Cleaning/Course Project/Getting-and-Cleaning-Data-Project/UCI HAR Dataset/test/y_test.txt", col.names = c("code"))


subject_train <- read.table("C:/Users/User/Desktop/Chigo/School/3 Getting and Cleaning/Course Project/Getting-and-Cleaning-Data-Project/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

x_train <- read.table("C:/Users/User/Desktop/Chigo/School/3 Getting and Cleaning/Course Project/Getting-and-Cleaning-Data-Project/UCI HAR Dataset/train/X_train.txt", col.names = features$functions)

y_train <- read.table("C:/Users/User/Desktop/Chigo/School/3 Getting and Cleaning/Course Project/Getting-and-Cleaning-Data-Project/UCI HAR Dataset/train/Y_train.txt", col.names = c("code"))



# 1. Merges the training and the test sets to create one data set.

x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)

subject <- rbind(subject_train, subject_test)

View(activities)

merged_data <- cbind(subject, y, x)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

data <- merged_data %>% 
        select(subject, code, contains("mean"), contains("std"))


# 3. Uses descriptive activity names to name the activities in the data setnames

data$code <- activities[data$code, "activity"]



# 4. Appropriately labels the data set with descriptive variable names. 

names(data)[1] <- "Subject"
names(data)[2] <- "Activity"

names(data) <- gsub("tBody", "TimeBody", names(data))
names(data) <- gsub("Acc", "Accelerometer", names(data))
names(data) <- gsub(".mean", "Mean", names(data))
names(data) <- gsub("^t", "Time", names(data))
names(data) <- gsub("Gyro", "Gyroscope", names(data))
names(data) <- gsub("Mag", "Magnitude", names(data))
names(data) <- gsub("^f", "Frequency", names(data))
names(data) <- gsub("angle", "Angle", names(data))
names(data) <- gsub("Freq//.", "Frequency.", names(data))
names(data) <- gsub("std", "STD", names(data))


# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

lapply(data, is.numeric)

tidydata <- data %>%  
            select(Subject, Activity, contains('mean')) %>% 
            group_by(Subject, Activity) %>% 
            summarise_all(list(mean = mean))

write.table(tidydata, "tidydata.txt")









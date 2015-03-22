---
title: "CodeBook.md"
author: "Chris Albee"
date: "Sunday, March 22, 2015"
output: html_document
---


CodeBook.md

The following codebook describes the data, the variables, and any transformations performed to clean up the data. It describes also how the R code fulfills the Course Project requirements.


#### The Data

There are several files containing records derived from data collected from sensors in the Samsung Galaxy S Smartphone. These records contain measurements of triaxial acceleration from an accelerometer (total acceleration) and the estimated body acceleration. The data and ancillary files are available at the following location: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip, and they shall be referred to collectively as the UCI HAR dataset.

According to "features_info.txt" in the UCI HAR Dataset, here is a description of the data and how they are labeled:

"The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

"Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

"Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

"These signals were used to estimate variables of the feature vector for each pattern: '-XYZ' is used to denote 3-axial signals in the X, Y and Z directions."


#### The Variables

The output that is written to file at the conclusion of run_analysis.R is named "tidy_dataset.csv", and it consists of the average or mean of each variable of only those labeled as "-mean()" (mean value) or "-std()" (standard deviation) from the data provided in the UCI HAR Dataset (see "features.txt"), grouped by each subject and activity. These then are the variables output in "tidy_dataset.csv":
 - timeBodyAccel_mean_X_avg
 - timeBodyAccel_mean_Y_avg
 - timeBodyAccel_mean_Z_avg
 - timeBodyAccel_std_X_avg
 - timeBodyAccel_std_Y_avg
 - timeBodyAccel_std_Z_avg
 - timeGravityAccel_mean_X_avg
 - timeGravityAccel_mean_Y_avg
 - timeGravityAccel_mean_Z_avg
 - timeGravityAccel_std_X_avg
 - timeGravityAccel_std_Y_avg
 - timeGravityAccel_std_Z_avg
 - timeBodyAccelJerk_mean_X_avg
 - timeBodyAccelJerk_mean_Y_avg
 - timeBodyAccelJerk_mean_Z_avg
 - timeBodyAccelJerk_std_X_avg
 - timeBodyAccelJerk_std_Y_avg
 - timeBodyAccelJerk_std_Z_avg
 - timeBodyGyro_mean_X_avg
 - timeBodyGyro_mean_Y_avg
 - timeBodyGyro_mean_Z_avg
 - timeBodyGyro_std_X_avg
 - timeBodyGyro_std_Y_avg
 - timeBodyGyro_std_Z_avg
 - timeBodyGyroJerk_mean_X_avg
 - timeBodyGyroJerk_mean_Y_avg
 - timeBodyGyroJerk_mean_Z_avg
 - timeBodyGyroJerk_std_X_avg
 - timeBodyGyroJerk_std_Y_avg
 - timeBodyGyroJerk_std_Z_avg
 - timeBodyAccelMag_mean_avg
 - timeBodyAccelMag_std_avg
 - timeGravityAccelMag_mean_avg
 - timeGravityAccelMag_std_avg
 - timeBodyAccelJerkMag_mean_avg
 - timeBodyAccelJerkMag_std_avg
 - timeBodyGyroMag_mean_avg
 - timeBodyGyroMag_std_avg
 - timeBodyGyroJerkMag_mean_avg
 - timeBodyGyroJerkMag_std_avg
 - freqBodyAccel_mean_X_avg
 - freqBodyAccel_mean_Y_avg
 - freqBodyAccel_mean_Z_avg
 - freqBodyAccel_std_X_avg
 - freqBodyAccel_std_Y_avg
 - freqBodyAccel_std_Z_avg
 - freqBodyAccelJerk_mean_X_avg
 - freqBodyAccelJerk_mean_Y_avg
 - freqBodyAccelJerk_mean_Z_avg
 - freqBodyAccelJerk_std_X_avg
 - freqBodyAccelJerk_std_Y_avg
 - freqBodyAccelJerk_std_Z_avg
 - freqBodyGyro_mean_X_avg
 - freqBodyGyro_mean_Y_avg
 - freqBodyGyro_mean_Z_avg
 - freqBodyGyro_std_X_avg
 - freqBodyGyro_std_Y_avg
 - freqBodyGyro_std_Z_avg
 - freqBodyAccelMag_mean_avg
 - freqBodyAccelMag_std_avg
 - freqBodyBodyAccelJerkMag_mean_avg
 - freqBodyBodyAccelJerkMag_std_avg
 - freqBodyBodyGyroMag_mean_avg
 - freqBodyBodyGyroMag_std_avg
 - freqBodyBodyGyroJerkMag_mean_avg
 - freqBodyBodyGyroJerkMag_std

I renamed these variables to be more readable and to remove illegal expressions when used in a plyr data transformation. The new variable names (listed above) represent 't-' and 'f-' as 'time-' and 'freq-', respectively; they have all parentheses removed; '-Acc-' is converted to 'Accel'; and all hyphens are converted to underscores. E.g.:

      before                  after
  ---------------        -----------------
 tBodyAcc-mean()-X      timeBodyAccel_mean_X
 fBodyAccJerk-mean()-Y  freqBodyAccelJerk_mean_Y
 tBodyGyro-mean()-Z     timeBodyGyro_mean_Z
 

#### Transformations

Here are the data transformation requirements for the Course Project:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Since the Train and Test data sets are somewhat large, I decided that I would perform Step 2 before Step 1. Looking at features.txt, I saw that each variable name is also indexed numerically. So I decided to use the numeric index to extract the -mean() and -std() columns I wanted. Here are the columns:
 - tBodyAcc-mean()-X
 - tBodyAcc-mean()-Y
 - tBodyAcc-mean()-Z
 - tBodyAcc-std()-X
 - tBodyAcc-std()-Y
 - tBodyAcc-std()-Z
 - tGravityAcc-mean()-X
 - tGravityAcc-mean()-Y
 - tGravityAcc-mean()-Z
 - tGravityAcc-std()-X
 - tGravityAcc-std()-Y
 - tGravityAcc-std()-Z
 - tBodyAccJerk-mean()-X
 - tBodyAccJerk-mean()-Y
 - tBodyAccJerk-mean()-Z
 - tBodyAccJerk-std()-X
 - tBodyAccJerk-std()-Y
 - tBodyAccJerk-std()-Z
 - tBodyGyro-mean()-X
 - tBodyGyro-mean()-Y
 - tBodyGyro-mean()-Z
 - tBodyGyro-std()-X
 - tBodyGyro-std()-Y
 - tBodyGyro-std()-Z
 - tBodyGyroJerk-mean()-X
 - tBodyGyroJerk-mean()-Y
 - tBodyGyroJerk-mean()-Z
 - tBodyGyroJerk-std()-X
 - tBodyGyroJerk-std()-Y
 - tBodyGyroJerk-std()-Z
 - tBodyAccMag-mean()
 - tBodyAccMag-std()
 - tGravityAccMag-mean()
 - tGravityAccMag-std()
 - tBodyAccJerkMag-mean()
 - tBodyAccJerkMag-std()
 - tBodyGyroMag-mean()
 - tBodyGyroMag-std()
 - tBodyGyroJerkMag-mean()
 - tBodyGyroJerkMag-std()
 - fBodyAcc-mean()-X
 - fBodyAcc-mean()-Y
 - fBodyAcc-mean()-Z
 - fBodyAcc-std()-X
 - fBodyAcc-std()-Y
 - fBodyAcc-std()-Z
 - fBodyAccJerk-mean()-X
 - fBodyAccJerk-mean()-Y
 - fBodyAccJerk-mean()-Z
 - fBodyAccJerk-std()-X
 - fBodyAccJerk-std()-Y
 - fBodyAccJerk-std()-Z
 - fBodyGyro-mean()-X
 - fBodyGyro-mean()-Y
 - fBodyGyro-mean()-Z
 - fBodyGyro-std()-X
 - fBodyGyro-std()-Y
 - fBodyGyro-std()-Z
 - fBodyAccMag-mean()
 - fBodyAccMag-std()
 - fBodyBodyAccJerkMag-mean()
 - fBodyBodyAccJerkMag-std()
 - fBodyBodyGyroMag-mean()
 - fBodyBodyGyroMag-std()
 - fBodyBodyGyroJerkMag-mean()
 - fBodyBodyGyroJerkMag-std()

Once I had extracted these variables from both the Train and Test files, I unioned them together to form a single, large data set of observation data. This fulfills Steps 1 and 2.

Renaming the fields as I described above fulfills Step 4.

I used activity_labels.txt as a lookup table to assign descriptive activity names to the activities, which fulfills Step 3.

I also unioned together the Subject ids from both the Train and Test data sets, as well as the Activity ids. I concatenated these to the observations to form a combined data set.

To fulfill Step 5, I transformed the combined data set using ddply to obtain the average or mean value for each measurement, for each group consisting of the Subject and Activity.

The R code in run_analysis.R is commented, and each Step is identified where it is fulfilled.

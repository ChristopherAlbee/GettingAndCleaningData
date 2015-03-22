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
<li>timeBodyAccel_mean_X_avg
<li>timeBodyAccel_mean_Y_avg
<li>timeBodyAccel_mean_Z_avg
<li>timeBodyAccel_std_X_avg
<li>timeBodyAccel_std_Y_avg
<li>timeBodyAccel_std_Z_avg
<li>timeGravityAccel_mean_X_avg
<li>timeGravityAccel_mean_Y_avg
<li>timeGravityAccel_mean_Z_avg
<li>timeGravityAccel_std_X_avg
<li>timeGravityAccel_std_Y_avg
<li>timeGravityAccel_std_Z_avg
<li>timeBodyAccelJerk_mean_X_avg
<li>timeBodyAccelJerk_mean_Y_avg
<li>timeBodyAccelJerk_mean_Z_avg
<li>timeBodyAccelJerk_std_X_avg
<li>timeBodyAccelJerk_std_Y_avg
<li>timeBodyAccelJerk_std_Z_avg
<li>timeBodyGyro_mean_X_avg
<li>timeBodyGyro_mean_Y_avg
<li>timeBodyGyro_mean_Z_avg
<li>timeBodyGyro_std_X_avg
<li>timeBodyGyro_std_Y_avg
<li>timeBodyGyro_std_Z_avg
<li>timeBodyGyroJerk_mean_X_avg
<li>timeBodyGyroJerk_mean_Y_avg
<li>timeBodyGyroJerk_mean_Z_avg
<li>timeBodyGyroJerk_std_X_avg
<li>timeBodyGyroJerk_std_Y_avg
<li>timeBodyGyroJerk_std_Z_avg
<li>timeBodyAccelMag_mean_avg
<li>timeBodyAccelMag_std_avg
<li>timeGravityAccelMag_mean_avg
<li>timeGravityAccelMag_std_avg
<li>timeBodyAccelJerkMag_mean_avg
<li>timeBodyAccelJerkMag_std_avg
<li>timeBodyGyroMag_mean_avg
<li>timeBodyGyroMag_std_avg
<li>timeBodyGyroJerkMag_mean_avg
<li>timeBodyGyroJerkMag_std_avg
<li>freqBodyAccel_mean_X_avg
<li>freqBodyAccel_mean_Y_avg
<li>freqBodyAccel_mean_Z_avg
<li>freqBodyAccel_std_X_avg
<li>freqBodyAccel_std_Y_avg
<li>freqBodyAccel_std_Z_avg
<li>freqBodyAccelJerk_mean_X_avg
<li>freqBodyAccelJerk_mean_Y_avg
<li>freqBodyAccelJerk_mean_Z_avg
<li>freqBodyAccelJerk_std_X_avg
<li>freqBodyAccelJerk_std_Y_avg
<li>freqBodyAccelJerk_std_Z_avg
<li>freqBodyGyro_mean_X_avg
<li>freqBodyGyro_mean_Y_avg
<li>freqBodyGyro_mean_Z_avg
<li>freqBodyGyro_std_X_avg
<li>freqBodyGyro_std_Y_avg
<li>freqBodyGyro_std_Z_avg
<li>freqBodyAccelMag_mean_avg
<li>freqBodyAccelMag_std_avg
<li>freqBodyBodyAccelJerkMag_mean_avg
<li>freqBodyBodyAccelJerkMag_std_avg
<li>freqBodyBodyGyroMag_mean_avg
<li>freqBodyBodyGyroMag_std_avg
<li>freqBodyBodyGyroJerkMag_mean_avg
<li>freqBodyBodyGyroJerkMag_std

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
<li>tBodyAcc-mean()-X
<li>tBodyAcc-mean()-Y
<li>tBodyAcc-mean()-Z
<li>tBodyAcc-std()-X
<li>tBodyAcc-std()-Y
<li>tBodyAcc-std()-Z
<li>tGravityAcc-mean()-X
<li>tGravityAcc-mean()-Y
<li>tGravityAcc-mean()-Z
<li>tGravityAcc-std()-X
<li>tGravityAcc-std()-Y
<li>tGravityAcc-std()-Z
<li>tBodyAccJerk-mean()-X
<li>tBodyAccJerk-mean()-Y
<li>tBodyAccJerk-mean()-Z
<li>tBodyAccJerk-std()-X
<li>tBodyAccJerk-std()-Y
<li>tBodyAccJerk-std()-Z
<li>tBodyGyro-mean()-X
<li>tBodyGyro-mean()-Y
<li>tBodyGyro-mean()-Z
<li>tBodyGyro-std()-X
<li>tBodyGyro-std()-Y
<li>tBodyGyro-std()-Z
<li>tBodyGyroJerk-mean()-X
<li>tBodyGyroJerk-mean()-Y
<li>tBodyGyroJerk-mean()-Z
<li>tBodyGyroJerk-std()-X
<li>tBodyGyroJerk-std()-Y
<li>tBodyGyroJerk-std()-Z
<li>tBodyAccMag-mean()
<li>tBodyAccMag-std()
<li>tGravityAccMag-mean()
<li>tGravityAccMag-std()
<li>tBodyAccJerkMag-mean()
<li>tBodyAccJerkMag-std()
<li>tBodyGyroMag-mean()
<li>tBodyGyroMag-std()
<li>tBodyGyroJerkMag-mean()
<li>tBodyGyroJerkMag-std()
<li>fBodyAcc-mean()-X
<li>fBodyAcc-mean()-Y
<li>fBodyAcc-mean()-Z
<li>fBodyAcc-std()-X
<li>fBodyAcc-std()-Y
<li>fBodyAcc-std()-Z
<li>fBodyAccJerk-mean()-X
<li>fBodyAccJerk-mean()-Y
<li>fBodyAccJerk-mean()-Z
<li>fBodyAccJerk-std()-X
<li>fBodyAccJerk-std()-Y
<li>fBodyAccJerk-std()-Z
<li>fBodyGyro-mean()-X
<li>fBodyGyro-mean()-Y
<li>fBodyGyro-mean()-Z
<li>fBodyGyro-std()-X
<li>fBodyGyro-std()-Y
<li>fBodyGyro-std()-Z
<li>fBodyAccMag-mean()
<li>fBodyAccMag-std()
<li>fBodyBodyAccJerkMag-mean()
<li>fBodyBodyAccJerkMag-std()
<li>fBodyBodyGyroMag-mean()
<li>fBodyBodyGyroMag-std()
<li>fBodyBodyGyroJerkMag-mean()
<li>fBodyBodyGyroJerkMag-std()

Once I had extracted these variables from both the Train and Test files, I unioned them together to form a single, large data set of observation data. This fulfills Steps 1 and 2.

Renaming the fields as I described above fulfills Step 4.

I used activity_labels.txt as a lookup table to assign descriptive activity names to the activities, which fulfills Step 3.

I also unioned together the Subject ids from both the Train and Test data sets, as well as the Activity ids. I concatenated these to the observations to form a combined data set.

To fulfill Step 5, I transformed the combined data set using ddply to obtain the average or mean value for each measurement, for each group consisting of the Subject and Activity.

The R code in run_analysis.R is commented, and each Step is identified where it is fulfilled.

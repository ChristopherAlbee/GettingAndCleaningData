
run <- function() {
    ## -------------[ Start ]---------------
    
    ## NOTE: by observing the data I saw there are no NA values, so I don't trap 
    ## for them in my code.
    library(plyr)
    
    ## Read in the training and test observations. 
    training_recs <- read.table("train/X_train.txt")
    test_recs     <- read.table("test/X_test.txt")
    
    ## Read in the activities for each training and test observation.
    training_activity_recs <- read.table("train/Y_train.txt")
    test_activity_recs     <- read.table("test/Y_test.txt")
    
    ## Finally, read in the subject ids for each training and test observation.
    training_subject_ids <- read.table("train/subject_train.txt")
    test_subject_ids     <- read.table("test/subject_test.txt")
    
    ## Since I want to conserve memory as much as possible, I am performing Step 2 
    ## before Step 1.
    
    ## Looking at features.txt, I see that each variable name is also indexed 
    ## numerically. So I decided to use the numeric index to extract the -mean() and 
    ## -std() columns I wanted.
    vecColumnNums <- 
        c(1, 2, 3, 4, 5, 6, 41, 42, 43, 44, 45, 46, 81, 82, 83, 84, 85, 
          86, 121, 122, 123, 124, 125, 126, 161, 162, 163, 164, 165, 166, 
          201, 202, 214, 215, 227, 228, 240, 241, 253, 254, 266, 267, 268, 
          269, 270, 271, 345, 346, 347, 348, 349, 350, 424, 425, 426, 427, 
          428, 429, 503, 504, 516, 517, 529, 530, 542, 543)
    
    training_recs_slim <- training_recs[vecColumnNums]
    test_recs_slim     <- test_recs[vecColumnNums]
    
    ## Note: test_recs_slim is now a dataframe and no longer a matrix.
    
    ## Union the two activity vectors, the two subject_id vectors; and the two slim, 
    ## observation dataframes.
    all_activities  <- rbind(training_activity_recs, test_activity_recs)
    all_subject_ids <- rbind(training_subject_ids, test_subject_ids)
    all_recs_slim   <- rbind(training_recs_slim, test_recs_slim)
    
    ## Convert the activity and subject_id vectors into dataframes and assigned 
    ## column names.
    activities            <- as.data.frame(all_activities)
    colnames(activities)  <- c("activity_id")
    
    subject_ids           <- as.data.frame(all_subject_ids)
    colnames(subject_ids) <- c("subject_id")
    
    ## Create a vector consisting of the variable names which are based on those obtained 
    ## from features.txt. These variable names correspond to the numbered columns listed 
    ## in vecColumnNums. The new variable names represent 't-' and 'f-' as 'time-' and 
    ## 'freq-', respectively; they have all parentheses removed; '-Acc-' is converted to 
    ## 'Accel'; and all hyphens are converted to underscores. E.g.:
    ## 
    ##       before                  after
    ##   ---------------        -----------------
    ##  tBodyAcc-mean()-X      timeBodyAccel_mean_X
    ##  fBodyAccJerk-mean()-Y  freqBodyAccelJerk_mean_Y
    ##  tBodyGyro-mean()-Z     timeBodyGyro_mean_Z
    ##  
    vColumnNames <- 
        c("timeBodyAccel_mean_X"    , "timeBodyAccel_mean_Y"     , "timeBodyAccel_mean_Z", 
          "timeBodyAccel_std_X"     , "timeBodyAccel_std_Y"      , "timeBodyAccel_std_Z", 
          "timeGravityAccel_mean_X" , "timeGravityAccel_mean_Y"  , "timeGravityAccel_mean_Z", 
          "timeGravityAccel_std_X"  , "timeGravityAccel_std_Y"   , "timeGravityAccel_std_Z", 
          "timeBodyAccelJerk_mean_X", "timeBodyAccelJerk_mean_Y" , "timeBodyAccelJerk_mean_Z", 
          "timeBodyAccelJerk_std_X" , "timeBodyAccelJerk_std_Y"  , "timeBodyAccelJerk_std_Z", 
          "timeBodyGyro_mean_X"     , "timeBodyGyro_mean_Y"      , "timeBodyGyro_mean_Z", 
          "timeBodyGyro_std_X"      , "timeBodyGyro_std_Y"       , "timeBodyGyro_std_Z", 
          "timeBodyGyroJerk_mean_X" , "timeBodyGyroJerk_mean_Y"  , "timeBodyGyroJerk_mean_Z", 
          "timeBodyGyroJerk_std_X"  , "timeBodyGyroJerk_std_Y"   , "timeBodyGyroJerk_std_Z", 
          "timeBodyAccelMag_mean"    , "timeBodyAccelMag_std", 
          "timeGravityAccelMag_mean" , "timeGravityAccelMag_std", 
          "timeBodyAccelJerkMag_mean", "timeBodyAccelJerkMag_std", 
          "timeBodyGyroMag_mean"    , "timeBodyGyroMag_std", 
          "timeBodyGyroJerkMag_mean", "timeBodyGyroJerkMag_std", 
          "freqBodyAccel_mean_X"    , "freqBodyAccel_mean_Y"    , "freqBodyAccel_mean_Z", 
          "freqBodyAccel_std_X"     , "freqBodyAccel_std_Y"     , "freqBodyAccel_std_Z", 
          "freqBodyAccelJerk_mean_X", "freqBodyAccelJerk_mean_Y", "freqBodyAccelJerk_mean_Z", 
          "freqBodyAccelJerk_std_X" , "freqBodyAccelJerk_std_Y" , "freqBodyAccelJerk_std_Z", 
          "freqBodyGyro_mean_X"     , "freqBodyGyro_mean_Y"     , "freqBodyGyro_mean_Z", 
          "freqBodyGyro_std_X"      , "freqBodyGyro_std_Y"      , "freqBodyGyro_std_Z", 
          "freqBodyAccelMag_mean"        , "freqBodyAccelMag_std", 
          "freqBodyBodyAccelJerkMag_mean", "freqBodyBodyAccelJerkMag_std", 
          "freqBodyBodyGyroMag_mean"     , "freqBodyBodyGyroMag_std", 
          "freqBodyBodyGyroJerkMag_mean" , "freqBodyBodyGyroJerkMag_std")
    
    ## Assign modified column names to the dataframe
    colnames(all_recs_slim) <- vColumnNames
    
    ## Use descriptive activity names to name the activities in the data set 
    ## (requirement 3): first convert all_activities to a dataframe so it can hold 
    ## another column called "activity_name". Then obtain the activity name from 
    ## activity_labels.txt using with(). 
    activity_labels = read.table("activity_labels.txt")
    
    activities$activity_name <- 
        with(
            activities, 
            activity_labels[activity_id,2]
        )
    
    ## Bind the subject_id, activity_names, and all_recs_slim together to form a 
    ## single dataframe. 
    subjectIds_activityNames <- cbind(subject_ids, activities)
    all_data                 <- cbind(subjectIds_activityNames, all_recs_slim)
    
    tidy_dataset <-
        ddply(
            all_data,
            .(subject_id, activity_name),
            summarize,
            timeBodyAccel_mean_X_avg = mean(timeBodyAccel_mean_X),
            timeBodyAccel_mean_Y_avg = mean(timeBodyAccel_mean_Y),
            timeBodyAccel_mean_Z_avg = mean(timeBodyAccel_mean_Z),
            timeBodyAccel_std_X_avg = mean(timeBodyAccel_std_X),
            timeBodyAccel_std_Y_avg = mean(timeBodyAccel_std_Y),
            timeBodyAccel_std_Z_avg = mean(timeBodyAccel_std_Z),
            timeGravityAccel_mean_X_avg = mean(timeGravityAccel_mean_X),
            timeGravityAccel_mean_Y_avg = mean(timeGravityAccel_mean_Y),
            timeGravityAccel_mean_Z_avg = mean(timeGravityAccel_mean_Z),
            timeGravityAccel_std_X_avg = mean(timeGravityAccel_std_X),
            timeGravityAccel_std_Y_avg = mean(timeGravityAccel_std_Y),
            timeGravityAccel_std_Z_avg = mean(timeGravityAccel_std_Z),
            timeBodyAccelJerk_mean_X_avg = mean(timeBodyAccelJerk_mean_X),
            timeBodyAccelJerk_mean_Y_avg = mean(timeBodyAccelJerk_mean_Y),
            timeBodyAccelJerk_mean_Z_avg = mean(timeBodyAccelJerk_mean_Z),
            timeBodyAccelJerk_std_X_avg = mean(timeBodyAccelJerk_std_X),
            timeBodyAccelJerk_std_Y_avg = mean(timeBodyAccelJerk_std_Y),
            timeBodyAccelJerk_std_Z_avg = mean(timeBodyAccelJerk_std_Z),
            timeBodyGyro_mean_X_avg = mean(timeBodyGyro_mean_X),
            timeBodyGyro_mean_Y_avg = mean(timeBodyGyro_mean_Y),
            timeBodyGyro_mean_Z_avg = mean(timeBodyGyro_mean_Z),
            timeBodyGyro_std_X_avg = mean(timeBodyGyro_std_X),
            timeBodyGyro_std_Y_avg = mean(timeBodyGyro_std_Y),
            timeBodyGyro_std_Z_avg = mean(timeBodyGyro_std_Z),
            timeBodyGyroJerk_mean_X_avg = mean(timeBodyGyroJerk_mean_X),
            timeBodyGyroJerk_mean_Y_avg = mean(timeBodyGyroJerk_mean_Y),
            timeBodyGyroJerk_mean_Z_avg = mean(timeBodyGyroJerk_mean_Z),
            timeBodyGyroJerk_std_X_avg = mean(timeBodyGyroJerk_std_X),
            timeBodyGyroJerk_std_Y_avg = mean(timeBodyGyroJerk_std_Y),
            timeBodyGyroJerk_std_Z_avg = mean(timeBodyGyroJerk_std_Z),
            timeBodyAccelMag_mean_avg = mean(timeBodyAccelMag_mean),
            timeBodyAccelMag_std_avg = mean(timeBodyAccelMag_std),
            timeGravityAccelMag_mean_avg = mean(timeGravityAccelMag_mean),
            timeGravityAccelMag_std_avg = mean(timeGravityAccelMag_std),
            timeBodyAccelJerkMag_mean_avg = mean(timeBodyAccelJerkMag_mean),
            timeBodyAccelJerkMag_std_avg = mean(timeBodyAccelJerkMag_std),
            timeBodyGyroMag_mean_avg = mean(timeBodyGyroMag_mean),
            timeBodyGyroMag_std_avg = mean(timeBodyGyroMag_std),
            timeBodyGyroJerkMag_mean_avg = mean(timeBodyGyroJerkMag_mean),
            timeBodyGyroJerkMag_std_avg = mean(timeBodyGyroJerkMag_std),
            freqBodyAccel_mean_X_avg = mean(freqBodyAccel_mean_X),
            freqBodyAccel_mean_Y_avg = mean(freqBodyAccel_mean_Y),
            freqBodyAccel_mean_Z_avg = mean(freqBodyAccel_mean_Z),
            freqBodyAccel_std_X_avg = mean(freqBodyAccel_std_X),
            freqBodyAccel_std_Y_avg = mean(freqBodyAccel_std_Y),
            freqBodyAccel_std_Z_avg = mean(freqBodyAccel_std_Z),
            freqBodyAccelJerk_mean_X_avg = mean(freqBodyAccelJerk_mean_X),
            freqBodyAccelJerk_mean_Y_avg = mean(freqBodyAccelJerk_mean_Y),
            freqBodyAccelJerk_mean_Z_avg = mean(freqBodyAccelJerk_mean_Z),
            freqBodyAccelJerk_std_X_avg = mean(freqBodyAccelJerk_std_X),
            freqBodyAccelJerk_std_Y_avg = mean(freqBodyAccelJerk_std_Y),
            freqBodyAccelJerk_std_Z_avg = mean(freqBodyAccelJerk_std_Z),
            freqBodyGyro_mean_X_avg = mean(freqBodyGyro_mean_X),
            freqBodyGyro_mean_Y_avg = mean(freqBodyGyro_mean_Y),
            freqBodyGyro_mean_Z_avg = mean(freqBodyGyro_mean_Z),
            freqBodyGyro_std_X_avg = mean(freqBodyGyro_std_X),
            freqBodyGyro_std_Y_avg = mean(freqBodyGyro_std_Y),
            freqBodyGyro_std_Z_avg = mean(freqBodyGyro_std_Z),
            freqBodyAccelMag_mean_avg = mean(freqBodyAccelMag_mean),
            freqBodyAccelMag_std_avg = mean(freqBodyAccelMag_std),
            freqBodyBodyAccelJerkMag_mean_avg = mean(freqBodyBodyAccelJerkMag_mean),
            freqBodyBodyAccelJerkMag_std_avg = mean(freqBodyBodyAccelJerkMag_std),
            freqBodyBodyGyroMag_mean_avg = mean(freqBodyBodyGyroMag_mean),
            freqBodyBodyGyroMag_std_avg = mean(freqBodyBodyGyroMag_std),
            freqBodyBodyGyroJerkMag_mean_avg = mean(freqBodyBodyGyroJerkMag_mean),
            freqBodyBodyGyroJerkMag_std_avg = mean(freqBodyBodyGyroJerkMag_std)
        )
    
    write.csv( tidy_dataset, file = "tidy_dataset.txt", row.names = TRUE)
    
    return(1)
}

setwd("C:/MY_DOCS/CSC/RWorkingDir/GettingAndCleaningDataCourse/Proj2/")

if(!file.exists("data.zip")) {
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
                , "data.zip")
}
unzip("data.zip")


# get the names of the features in order to name the columns
# , then make the names in vector form
featureNames <- read.table("UCI HAR Dataset/features.txt", header = FALSE)
featureNames <- featureNames[,2]

# read the test data, then change the names of the columns
samsungTest <- read.table("UCI HAR Dataset/test/X_test.txt", header=FALSE)
testActivities <- read.table("UCI HAR Dataset/test/y_test.txt", header=FALSE)

# STEP 4: label the variables
colnames(samsungTest) <- featureNames
colnames(testActivities) <- c("Activity")
samsungTest <- cbind(testActivties, samsungTest)

# read the test data, then change the names of the columns
samsungTrain <- read.table("UCI HAR Dataset/train/X_train.txt", header=FALSE)
trainActivities <- read.table("UCI HAR Dataset/train/y_train.txt", header=FALSE)

# STEP 4: label the variables
colnames(samsungTrain) <- featureNames
colnames(trainActivities) <- c("Activity")
samsungTrain <- cbind(trainActivities, samsungTrain)

# STEP 1: Join the test and training sets into one
samsungData <- rbind(samsungTest, samsungTrain)

# eliminate all data that is not mean or standard deviation
columnNames <- colnames(samsungData)

# STEP 2:
# grep for variable names with "mean" or "std" in their names, and make
# sure that the activity variable is included as well
meanAndStd <- c(1, grep("[*]*mean\\(\\)[*]*", columnNames)
                , grep("[*]*std\\(\\)[*]*", columnNames))
samsungData <- samsungData[, meanAndStd]

# STEP 3: change 1:6 to meaningful, descriptive names for activies variable
samsungData$Activity <- as.character(samsungData$Activity)
for (i in 1:nrow(samsungData)) {
  if (samsungData[i,1] == "1") {
    samsungData[i,1] <- c("Walking")
  }
  else if (samsungData[i,1] == "2") {
    samsungData[i,1] <- c("Walking Upstairs")
  }
  else if (samsungData[i,1] == "3") {
    samsungData[i,1] <- c("Walking Downstairs")
  }
  else if (samsungData[i,1] == "4") {
    samsungData[i,1] <- c("Sitting")
  }
  else if (samsungData[i,1] == "5") {
    samsungData[i,1] <- c("Standing")
  }
  else if (samsungData[i,1] == "6") {
    samsungData[i,1] <- c("Laying")
  }
  else {
    print("Error: number is not recognized as an activity")
  }
}

# STEP 5: create a second dataset with the average for each variable for
# each activity

# add the subjects data to the samsungData dataframe
samsungData <- cbind(c(read.table("UCI HAR Dataset/test/subject_test.txt"
                                  , header = FALSE)[,1]
                       , read.table("UCI HAR Dataset/train/subject_train.txt"
                                    , header = FALSE)[,1])
                     , samsungData)
colnames(samsungData) <- c("Subject" , colnames(samsungData)[2:length(colnames(samsungData))])

# a vector of all the different possible values for the activity performed
activitiesValues <- as.character(unique(samsungData[,2]))
subjectValues <- as.numeric(unique(samsungData[,1]))

# the matrix (soon to be data frame) that all the averaged data per activity
# will be stored in
samsungAvg <- NULL
length(activitiesValues)
length(subjectValues)
for(i in 1:length(activitiesValues)) {
  string <- activitiesValues[i]
  
  # a vector of the averages of all variables for this row
  for(j in 1:length(subjectValues)) {
    subject <- subjectValues[j]
    avgVec <- colMeans(samsungData[as.character(samsungData$Activity)==string
                                      & as.numeric(samsungData$Subject)==subject,3:ncol(samsungData)])
    # add the new row of averages onto the existing rows
    if(is.null(samsungAvg)) {
      samsungAvg <- avgVec
    }
    else {
      samsungAvg <- rbind(samsungAvg, avgVec)
    }
  }
}
i <- length(activitiesValues)
temp <- c(rep.int(activitiesValues[1], times=length(subjectValues))
          , rep.int(activitiesValues[2], times=length(subjectValues))
          , rep.int(activitiesValues[3], times=length(subjectValues))
          , rep.int(activitiesValues[4], times=length(subjectValues))
          , rep.int(activitiesValues[5], times=length(subjectValues))
          , rep.int(activitiesValues[6], times=length(subjectValues)))
activitiesValues <- temp
attributes(samsungAvg)
samsungAvg <- as.data.frame(samsungAvg, optional=FALSE)
samsungAvg <- cbind(activitiesValues, samsungAvg)
samsungAvg <- cbind(rep.int(subjectValues, times = i)
                    , samsungAvg)
colnames(samsungAvg) <- ifelse(colnames(samsungData)!="Subject" &
                                 colnames(samsungData)!="Activity"
                               , paste(colnames(samsungData)
                                       , "_MEAN", sep="")
                               , colnames(samsungData))


write.table(samsungAvg, "samsungAvg.txt", row.name=FALSE)


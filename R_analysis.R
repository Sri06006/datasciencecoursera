library(reshape2)
filename = "getdata_dataset.zip"


if(!file.exists(filename)){
  url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url, filename)
}

if(!file.exists("UCI HAR Dataset")){
  unzip(filename)
}

activity_labels = read.table("UCI HAR Dataset\\activity_labels.txt")
activity_labels[,2] = as.character(activity_labels[,2])

features = read.table("UCI HAR Dataset\\features.txt")
features[,2] = as.character(features[,2])

featuresWanted = grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names = features[featuresWanted,2]

featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names )
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)

featuresWanted.names = gsub('[-()]','',featuresWanted.names)

train = read.table("UCI HAR Dataset\\train\\X_train.txt")[featuresWanted]
trainActivities = read.table("UCI HAR Dataset\\train\\Y_train.txt")
trainSubject = read.table("UCI HAR Dataset\\train\\subject_train.txt")
train = cbind(trainSubject, trainActivities,train)

test = read.table("UCI HAR Dataset\\test\\X_test.txt")[featuresWanted]
testActivities = read.table("UCI HAR Dataset\\test\\Y_test.txt")
testSubject = read.table("UCI HAR Dataset\\test\\subject_test.txt")
test = cbind(testSubject, testActivities,test)


allData = rbind(train,test)

colnames(allData) = c("Subject", "Activity", "featureWanted.names")

allData$Activity = factor(allData$Activity, levels = activity_labels[,1], labels = activity_labels[,2])
allData$Subject = factor(allData$Subject)

allData.melted = melt(allData, id=c("Subject","Activity"))
allData.mean = dcast(allData.melted, Subject + Activity ~ variable, mean)

write.table(allData.mean, "UCI HAR Dataset\\tidy.txt", row.names = FALSE, quote = FALSE)



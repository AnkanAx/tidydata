xtrain<-read.table("./UCI HAR Dataset/train/X_train.txt")
xtest<-read.table("./UCI HAR Dataset/test/X_test.txt")
ytrain<-read.table("./UCI HAR Dataset/train/y_train.txt")
ytest<-read.table("./UCI HAR Dataset/test/y_test.txt")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
activity_lables<-read.table("./UCI HAR Dataset/activity_labels.txt")
features<-read.table("./UCI HAR Dataset/features.txt")

##Merges the training and the test sets to one.

xall<-rbind(xtrain,xtest)

##Labeling columns

colnames(xall) <- c(as.character(features[,2]))

##Extract the columns for mean and standard deviation.

names_mean<-grep("mean()",colnames(xall),fixed=TRUE)
names_sd<-grep("std()",colnames(xall),fixed=TRUE)
xall_meansd<-xall[,c(names_mean,names_sd)]

##Uses descriptive activity names to name the activities in the data set.

yall<-rbind(ytrain,ytest)
all_meansd<-cbind(yall,xall_meansd)
all_meansd=merge(activity_lables,all_meansd,by.x="V1",by.y="V1",all=TRUE)
colnames(all_meansd)[1] <- "ActivityRef"
colnames(all_meansd)[2] <- "ActivityName"

##Creates a new data set with the average of each variable for each activity and each subject.

subject_all<-rbind(subject_train,subject_test)
all<-cbind(subject_all,all_meansd)
colnames(all)[1] <- "Subject"
tidydata <- aggregate(all, by=list(all$Subject,all$ActivityRef), data = all, FUN= "mean")
write.table(tidydata, file = "tidydata.txt", row.name=FALSE)

#ensure working in directory that contains features.txt, subject_test.txt, subject_train.txt, X_test.txt, X_train.txt, y_test.txt, y_train.txt, 
#activity_lables.txt are loaded into

rm(list=ls())


featurenames<-read.table("features.txt",col.names=c("featureno","measurementname")) #contains list of 561 names of the measurements (1,561)
testcolnames<-featurenames$measurementname

#read in test and training data
testdata<-read.table("X_test.txt",col.names=testcolnames,dec="5",nrows=3000)
traindata<-read.table("X_train.txt",col.names=testcolnames,dec="5",nrows=7500)

#clean test and training data so only grabbing columns that are mean/stdev
look<-c("mean()","std()")
testdata<-testdata[,grep(paste(look,collapse="|"),colnames(testdata))]
traindata<-traindata[grep(paste(look,collapse="|"),colnames(traindata))]

#tidy the data files with labels
testsubject<-read.table("subject_test.txt",col.names="participant") #file with test participants
trainsubject<-read.table("subject_train.txt",col.names = "participant") #file with training participants


testactivity<-read.table("y_test.txt",col.names="activityno")#file with activities corresponding to test participants
trainactivity<-read.table("y_train.txt",col.names = "activityno") #file with activities corresponding to training participants

activitynames<-read.table("activity_labels.txt",col.names=c("activityno","activity")) #file that matches activity number with descriptive name

testactivity$activityno[testactivity$activityno==1]<-"walking"
testactivity$activityno[testactivity$activityno==2]<-"walking_upstairs"
testactivity$activityno[testactivity$activityno==3]<-"walking_downstairs"
testactivity$activityno[testactivity$activityno==4]<-"sitting"
testactivity$activityno[testactivity$activityno==5]<-"standing"
testactivity$activityno[testactivity$activityno==6]<-"laying"
actlist1<-testactivity$activityno

trainactivity$activityno[trainactivity$activityno==1]<-"walking"
trainactivity$activityno[trainactivity$activityno==2]<-"walking_upstairs"
trainactivity$activityno[trainactivity$activityno==3]<-"walking_downstairs"
trainactivity$activityno[trainactivity$activityno==4]<-"sitting"
trainactivity$activityno[trainactivity$activityno==5]<-"standing"
trainactivity$activityno[trainactivity$activityno==6]<-"laying"
actlist2<-trainactivity$activityno


#add the participants to respective data file
alltestdata<-cbind(testsubject,actlist1,testdata)
alltestdata<-rename(alltestdata,activity="actlist1")

alltraindata<-cbind(trainsubject,actlist2,traindata)
alltraindata<-rename(alltraindata,activity="actlist2")

cleantestdata<-distinct(alltestdata,participant,activity,.keep_all = TRUE) #assumes participants may have completed activities more than once - removes all but
#one instance 
cleantraindata<-distinct(alltraindata,participant,activity,.keep_all=TRUE)

mergeddata<-merge(cleantestdata,cleantraindata,all=TRUE) #combines the test and training data files together
mergeddata2<-select(mergeddata,-contains(c("Mag","Freq")))#keeps only pertinent time/frequency Body and Gravity acceleration measurements

c1<-c(".mean...",".std...","tBodyAcc","tGravityAcc","tBodyAccJerk","tBodyGyro","tBodyGyroJerk","fBodyAcc","fBodyAccJerk","fBodyGyro")
c2<-c("_mean_","_stdev_","body_time","gravity_time","bodyjerk_time","gyro_time","gyrojerk_time","body_frequency","bodyjerk_frequency","gyro_frequency")
mdata2<-stri_replace_all_regex(names(mergeddata2),c1,c2,vectorize=FALSE)
colnames(mergeddata2)<-mdata2 #assigns renamed columns from mdata2

write.csv(mergeddata2,file="alldata.csv")







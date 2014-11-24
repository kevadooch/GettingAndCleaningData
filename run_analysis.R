library(plyr)
library(dplyr)


# location of raw data
data_dir <- "UCIHAR"


# load feature label data
#   - manually assign column names
feature <- read.table( paste(data_dir,"/features.txt", sep="")
                        ,header=FALSE
                        ,sep=""
                        ,col.names=c("FeatureId","Feature")
                        ,colClasses=c("numeric", "character"))

# load activity label data
#   - manually assign column names
activity <- read.table( paste(data_dir,"/activity_labels.txt", sep="")
                        ,header=FALSE
                        ,sep=""
                        ,col.names=c("ActivityId","Activity")
                        ,colClasses=c("numeric","character"))


###### load TEST data #####

# subject
#   - manually assign column name
subject_test <- read.table( paste(data_dir,"/test/subject_test.txt", sep="")
                           ,header=FALSE
                           ,sep=""
                           ,col.names="SubjectId"
                           ,colClasses="numeric")
#activity
#   - manually assign column name
y_test <- read.table( paste(data_dir,"/test/y_test.txt", sep="")
                     ,header=FALSE
                     ,sep=""
                     ,col.names="ActivityId"
                     ,colClasses="numeric")

# use {plyr} join_all() to append a column containing the activity name
y_test <- join_all(list(y_test,activity)
                   ,type="inner")

# features
#   - pass in column names as vector from feature data.frame
x_test <- read.table( paste(data_dir,"/test/X_test.txt", sep="")
                     ,header=FALSE
                     ,sep=""
                     ,col.names=feature$Feature
                     ,colClasses="numeric")

# combine test columns into one data.frame
test <- cbind(subject_test
              ,y_test
              ,x_test)


##### load TRAINING data #####

# subject
#   - manually assign column name
subject_train <- read.table( paste(data_dir,"/train/subject_train.txt", sep="")
                            ,header=FALSE
                            ,sep=""
                            ,col.names="SubjectId"
                            ,colClasses="numeric")

# activity
#   - manually assign column name
y_train <- read.table( paste(data_dir,"/train/y_train.txt", sep="")
                      ,header=FALSE
                      ,sep=""
                      ,col.names="ActivityId"
                      ,colClasses="numeric")

# use {plyr} join_all() to append a column containing the activity name
y_train <- join_all(list(y_train,activity)
                    ,type="inner")

# features
#   - pass in column names as vector from feature data.frame
x_train <- read.table( paste(data_dir,"/train/X_train.txt", sep="")
                     ,header=FALSE
                     ,sep=""
                     ,col.names=feature$Feature
                     ,colClasses="numeric")


# combine training columns into one data.frame
train <- cbind(subject_train
               ,y_train
               ,x_train)


# merge the training and test datasets into one
# we currently have:        test       train
#                           A A A A    B B B B
#                           A A A A    B B B B
#                           A A A A    B B B B 
#
# this merge will create:   all_data
#                           A A A A
#                           A A A A
#                           A A A A
#                           B B B B
#                           B B B B 
#                           B B B B 
all_data <- rbind(test, train)


# clean up: remove variables/data frames no longer required
rm(subject_test
   ,x_test
   ,y_test
   ,subject_train
   ,x_train
   ,y_train
   ,test
   ,train
   ,feature
   ,activity)


# convert data frame to "data frame table" to enable use of {dplyr} functions
all_data <- tbl_df(all_data)


# Select a subset of columns, columns of interest:
#   - SubjectId
#   - ActivityId 
#   - columns with "std" in columns name
#   - Columns with "mean" in column name
all_data_mean_std <- select( all_data
                             ,SubjectId
                             ,ActivityId
                             ,Activity
                             ,contains("std")
                             ,contains("mean"))

# create summary groups, columns of interest:
#   - ActivityId
#   - Activity
#   - SubjectId
by_activity_subject <- group_by(all_data_mean_std
                                ,ActivityId
                                ,Activity
                                ,SubjectId)

# Use {dplyr} summarise_each to find the mean of all columns not contained in summary group
all_data_summarised <- summarise_each(by_activity_subject
                                        ,funs(mean))


# export summary data for upload
#write.table(all_data_summarised
#            ,file="tidy_data_set.txt"
#            ,row.name=FALSE)



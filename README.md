Getting And Cleaning Data
=========================

## Background

run_analysis.R is a relatively straight forward script that can be split into 4 sections.

- Read data
- Merge data
- Select columns of interest 
- Summarise data

## Methodology 

# Read data

The first task was to load in the feature and activity data. These two datasets contain lookup data that describe the contents of the feature data columns and the activities undertaken by the test subjects.  These files are read in first as the data they contain simplifies the loading of the analysis data files.


The next task was to load the test and training datasets. Although stored separately each of the datasets consisted of 3 files (subject, y and x). The subject file contained data on who undertook the activity, the y file contained what activity was undertaken and the x contained the technical readings taken from the mobile device. Each of the three files contained the same number rows as they were designed to be combined. As the activity file (y) only contained an activity code (eg. 1,2,3), once the data was loaded it was combined with the activity lookup data to provide a textual representation of the activity (eg. WALKING). The feature data (x) contained 561 columns of numeric data which contained no header information. To facilitate the management of this data the feature labels were passed into the read.table command to automatically name each column.


# Merge data

At this point we have two data frames sharing a consistent format. The two data frames can be merged using the rbind() function.
The resulting data frame has 10299 rows with 564 columns.

# Select columns of interest

We are only interested in the standard deviation and mean data so we can discard the rest of columns as these do not apply to our analysis.
This was achieved using the dplyr select function which has a handy short cut where columns can be selected using text in the column name.
This enabled the columns to be selected where the name contained "mean" or "std".
The resulting data frame has 10299 rows but now only 89 columns. 

# Summarise data

We wish to group the data by Activity and then Subject. This was achieved again using a dplyr function, in this case group_by().
Once the data has been grouped as required the dplyr summarise() verb can be utilised to perform the final task.
If we disregard the 3 grouping columns we are left with 86 columns of data to be summarised. As we are finding the mean of all columns, thankfully, we can use the summarise_each() function. This function avoids the need to specify all 86 columns and easily allows a specific statistical function to be called against all columns in the data set.

Once this function had been called the data was ready for export.


 




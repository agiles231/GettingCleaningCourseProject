
All variables can be decoded by the following rules:

Begins with 't': time-domain variable
Begins with 'f': frequency-domain variable

Contains 'Body': body acceleration signal
Contains 'Gravity': gravity acceleration signal
Contains 'Gyro': Gyroscopic accerlation signal (Angular acceleration)
Contains 'Acc': Linear acceleration signal
Contains 'Jerk': Jerk
Contains 'Mag': Magnitude of given base variable
Contains 'mean()': A computed mean value for the given measurement
Contains 'std()': A computed standard deviation for the given measurement
Contains 'X', 'Y', 'Z': Variable measured in respective direction or about respective axis
Contains '_MEAN': This is on the end of every variable (except 'Subject' and 'Activity') and indicates that each variable is a mean of the entire set of variables for that given activity-subject value pair. (read ReadMe for more elaboration on this)

One other variable exists that does not follow this code. Both 'samsungData' and 'samsungAvg' contain a variable called activity that is a description of what activity was being performed when the corresponding row of observations was collected. 


The 'samsungData' dataframe was created by merging the entire test and training data sets, then subsetting them for only the mean and standard deviation computations of every variable. Then another variable was added that contains the activity being performed at the time that observation was being performed. This added variable is a character vector and has 6 different possible values that are self explanatory:
"Standing"
"Sitting"
"Laying"
"Walking"
"Walking Upstairs"
"Walking Downstairs"
Then the subject variable was added (range=30) and identifies the subject the set of observations correspond to.
The values for these two variables in the test and training data sets were extracted from the y_test.txt, subject_test.txt, y_train.txt, and subject_train.txt files respectively.

The 'samsungAvg' dataframe was created by taking the mean of all variables (except the 'Activity' and 'Subject' variables) for each unique value pair of 'Activity' and 'Subject' where each row of observations corresponds to the average for all values of that variable that had that unique value pair for 'Activity' and 'Subject'. Each of these vectors of means was one row of the 'samsungAvg'. Since there are only 6 unique values for the 'Activity' variable and unique values for the 'Subject' variable, there are 180 rows in the 'samsungAvg' dataframe.
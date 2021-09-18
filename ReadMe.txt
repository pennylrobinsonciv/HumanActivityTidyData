ReadMe

run.analysis.R - script that reads in the variables from each data set; merges the subjects, and activities performed; tidys the data to remove columns and rows based on the following assumptions:
The only measurements of interest are the mean and standard deviations for each axis for the body acceleration time & frequency, gravity acceleration time, body acceleration jerk time & frequency, body gyroscope jerk time, and body gyroscope time & frequency. 
Participants conducted activities multiple times; the data was reduced to account for average time/frequency per participant per activity.

The output alldata.csv contains the participants, activities performed, and corresponding mean and standard deviation for the time and frequency domains from the body, gravity, gyroscope, and jerk measurements.






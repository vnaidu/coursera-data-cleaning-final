# Getting and Cleaning Data Course Project
## Project Overview
**Analysis that performs the following steps:**

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Repo Contents
- **run_analysis.R**
- **data_tools.R**
- **CodeBook.md**
- **Data/**

### run_analysis.R
R script that performs the aforementioned procedures (See ***Project Overview***).

### data_tools.R
Helper functions to facilitate downloading, validating and sourcing the necessary datasets.

### CodeBook.md
A codebook describing the variables, the data, and any transformations or work performed to clean up the data.

### Data/*
Directory containing the raw data used for analysis: Human Activity Recognition Using Smartphones Data Set (Source: UCI Machine Learning Repository).

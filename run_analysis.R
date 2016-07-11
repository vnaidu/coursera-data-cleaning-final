# Load necessary libraries
library(dplyr)
library(magrittr)

# Initalize 'init_data_tools.R' to help mangage the requiste data
source('./data_tools.R')

# If data is not present in './Data', download and extract it
fPaths <- checkDataOrDl()

# Read train_* and test_* datasets and assign their respective column names
x_var_ref <- read.table(fPaths$features, col.names = c("colNum", "feature"))

train_subject <- read.table(fPaths$subject_train, col.names = "subjectID")
train_x <- read.table(fPaths$X_train)
train_y <- read.table(fPaths$y_train, col.names = "activity")

test_subject <- read.table(fPaths$subject_test, col.names = "subjectID")
test_x <- read.table(fPaths$X_test)
test_y <- read.table(fPaths$y_test, col.names = "activity")

# Assign column names for train_x and test_x; derived from 'features.txt'
names(train_x) <- x_var_ref$feature
names(test_x) <- x_var_ref$feature

# Combine train and test to create combined
train <- cbind(train_subject, train_y, train_x)
test <- cbind(test_subject, test_y, test_x)
combined <- rbind(train, test)

# Convert activity variable ints to factor with specified levels
activity_levels <- c("walking", "walking_upstairs", "walking_downstairs",
                     "sitting", "standing", "laying")
combined$activity %<>% factor(labels = activity_levels)

# Select columns containing either mean or std readings

vars2select <- grepl('(subjectID)|(activity)|(mean\\(\\))|std\\(\\)', colnames(combined))
combined_mean_std <- combined[, vars2select]

# Group observations by subjectID and then by activity;
# Take the mean for each var in the resultant
subj_actvty_avgs <- combined_mean_std %>%
  group_by(subjectID, activity) %>%
  summarise_each(funs(mean))

# Output the avg activity mean and std measurement for each subject to a ".txt" file
write.table(subj_actvty_avgs, "subj_actvty_avgs.txt", row.names = FALSE)

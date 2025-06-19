# run_analysis.R

# Set working directory (optional)
# setwd("path/to/your/folder")

# Load necessary libraries
if (!require(dplyr)) install.packages("dplyr")
library(dplyr)

# Load data files
features <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Merge datasets
X <- rbind(X_train, X_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)

# Assign column names
colnames(X) <- features$V2
colnames(subject) <- "subject"
colnames(y) <- "activity"

# Extract mean and std columns
mean_std_cols <- grep("mean\\(\\)|std\\(\\)", features$V2)
X <- X[, mean_std_cols]

# Replace activity numbers with descriptive names
y$activity <- factor(y$activity, levels = activity_labels$V1, labels = activity_labels$V2)

# Combine all data
combined_data <- cbind(subject, y, X)

# Create tidy dataset with averages
tidy_data <- combined_data %>%
  group_by(subject, activity) %>%
  summarise_all(mean)

# Write tidy dataset to file
write.table(tidy_data, file = "tidydata.txt", row.name = FALSE)


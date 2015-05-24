# Install package data.table
install.packages("data.table")

# Install package reshape2
install.packages("reshape2")

# Loding the package
library("data.table")
library("reshape2")

# Readiing the activity_labels from txt file
activity_labels <- read.table("C:/Users/Umar Shuja Syed/Documents/Assignment/UCI HAR Dataset/activity_labels.txt")[,2]
# Reading features from txt file
features <- read.table("C:/Users/Umar Shuja Syed/Documents/Assignment/UCI HAR Dataset/features.txt")[,2]

extract_features <- grepl("mean|std", features)

# Load and process X_test & y_test data.

X_test <- read.table("C:/Users/Umar Shuja Syed/Documents/Assignment/UCI HAR Dataset/test/X_test.txt")

y_test <- read.table("C:/Users/Umar Shuja Syed/Documents/Assignment/UCI HAR Dataset/test/y_test.txt")

subject_test <- read.table("C:/Users/Umar Shuja Syed/Documents/Assignment/UCI HAR Dataset/test/subject_test.txt")

names(X_test) = features

X_test = X_test[,extract_features]

# Load activity labels

y_test[,2] = activity_labels[y_test[,1]]

names(y_test) = c("Activity_ID", "Activity_Label")

names(subject_test) = "subject"

test_data <- cbind(as.data.table(subject_test), y_test, X_test)

X_train <- read.table("C:/Users/Umar Shuja Syed/Documents/Assignment/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("C:/Users/Umar Shuja Syed/Documents/Assignment/UCI HAR Dataset/train/y_train.txt")

subject_train <- read.table("C:/Users/Umar Shuja Syed/Documents/Assignment/UCI HAR Dataset/train/subject_train.txt")

names(X_train) = features

X_train = X_train[,extract_features]

y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

train_data <- cbind(as.data.table(subject_train), y_train, X_train)

data = rbind(test_data, train_data)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)


tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "C:/Users/Umar Shuja Syed/Documents/tidy_data.txt")

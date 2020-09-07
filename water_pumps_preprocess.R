# download the data
library(tidyverse)


x_train_url = "https://drivendata-prod.s3.amazonaws.com/data/7/public/4910797b-ee55-40a7-8668-10efd5c1b960.csv?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIARVBOBDCY3EFSLNZR%2F20200907%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20200907T134912Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=host&X-Amz-Signature=cc4b3945d2dab4e2ed0eb69336ef0c72ae6b0c322253f8d4c9b2bf988ce52baf"
x_train_file = "x_data.csv"
y_train_url = "https://drivendata-prod.s3.amazonaws.com/data/7/public/0bf8bc6e-30d0-4c50-956a-603fc693d966.csv?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIARVBOBDCY3EFSLNZR%2F20200907%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20200907T134912Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=host&X-Amz-Signature=a1a91cd6bff8256e27d9fb25388e538de52987f6209c1e6a7e0e857f02c9f944"
y_train_file = "y_train.csv"
x_test_url= "https://drivendata-prod.s3.amazonaws.com/data/7/public/702ddfc5-68cd-4d1d-a0de-f5f566f76d91.csv?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIARVBOBDCY3EFSLNZR%2F20200907%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20200907T134912Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=host&X-Amz-Signature=25df6d17d82ec9d8ab1c3e7c2a3e5dcef091b5d380ee6027a919e3d2d8a27139"
x_test_file = "x_test.csv"
submission_url = "https://drivendata-prod.s3.amazonaws.com/data/7/public/SubmissionFormat.csv?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIARVBOBDCY3EFSLNZR%2F20200907%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20200907T134912Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=host&X-Amz-Signature=49234131d76a37636ad253669058d6b7b6eb91ecb5506cb20f00af8328a55c57"
submission_file = "submission.csv"
file2url = c(x_train_url, y_train_url, x_test_url, submission_url)
names(file2url) <- c(x_train_file, y_train_file, x_test_file, submission_file)
file2url
for (file_ in names(file2url)){
  print (file_)
  if (file.exists(file_)){
    print(paste(file_, "exists, no nothing to do"))
  } else {
    print(paste(file_, "not there , need to download")) 
    url = file2url[[file_]]
    download.file(url, destfile=file_, method="auto", quiet = FALSE, 
                  mode = "w",
                  cacheOK = TRUE,
                  extra = getOption("download.file.extra"),
                  headers = NULL)    
  }
}
getwd()
list.files()

x_train <- read_csv(x_train_file)
y_train <- read_csv(y_train_file)
x_test <- read_csv(x_test_file)
submission_sample <- read_csv(submission_file)

head(submission_sample)

length(unique(xdf[["id"]]))
sapply(xdf, typeof)
sapply(xdf, class)
sapply(xdf, function(x) length(unique(x)))
ggplot(xdf, aes(x = extraction_type_class)) + 
  geom_bar() + 
  coord_flip()

class(xdf[[colnames(xdf)[1]]])

numcols = c()
for (i in seq_along(colnames(xdf))){
  col = colnames(xdf)[i]
  nuni = length(unique(xdf[[col]]))
  class_ = class(xdf[[col]])
  if (class_ == "numeric"){
    numcols <- c(numcols, col)
  }
  print(paste(col, nuni, class_))
}
numcols
?xtabs
tbl <- xtabs(formula=~ region_code+district_code, xdf)
tbl
xtabs(formula=~ payment+payment_type, xdf)

num_vars <- c("date_recorded", "gps_height", "num_private",
              "region_code", "disgtrict_code")
cat_vars <- c("basin", "region", "public_meeting", 
              "scheme_management", "permit", 
              "extraction_type", "management",
              "payment", "water_quality", "quantity", 
              "source", "waterpoint_type")
numcols
chisq.test(tbl)
getwd()
list.files(getwd())
summary(xdf)

xtrain <- xdf %>% dplyr::sample_frac(.75)
xvalid  <- dplyr::anti_join(xdf, xtrain, by = 'id')

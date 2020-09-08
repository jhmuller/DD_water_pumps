# download the data
library(tidyverse)
library(forcats)
library(ggplot2)
library(dplyr)
source("water_pump_utils.R")


res <- download_data()
x_train <- read_csv("x_train.csv")
y_train <- read_csv("y_train.csv")
x_test <- read_csv("x_test.csv")


tests <- function(){

result = tryCatch(
  {
    destfile <- "junk"
    url = "https://drivendata-prod.s3.amazonaws.com/data/7/public/SubmissionFormat.csv?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIARVBOBDCY3EFSLNZR%2F20200907%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20200907T134912Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=host&X-Amz-Signature=49234131d76a37636ad253669058d6b7b6eb91ecb5506cb20f00af8328a55c57"
   res <- download.file("http://github.com/jhmuller/DD_water_pumps/x_values.csv", 
                destfile="junk", 
                method="auto", quiet = FALSE, 
                mode = "w",
                cacheOK = TRUE,
                extra = getOption("download.file.extra"),
                headers = NULL)
  }  , warning = function(w) {
  print(paste("Warning", w))
    print(paste("Deleting file ", destfile))
    file.remove(destfile)
    return (1)
}, error = function(e) {
  print("Error")
  print(e)
  print(paste("Deleting file ", destfile))
  file.remove(destfile)  
  return (-1)
}, finally = {
  if (file.exists(destfile)){
    print("Cleaning up")
    return (0)
  }
} # finally
)

downloader::download
url <- "http://en.wikipedia.org"
destfile <- "junk"
res <- download(url, destfile=destfile)
res
x <- httr::GET("http://en.wikipedia.org/nothing")
x
curl = getCurlHandle()
x = getURL("https://en.wikipedia.org/asdfasdfasdf", curl = curl)
getCurlInfo(curl)$response.code
options("warn")
result
file.exits("junk")
}





#submission_sample <- read_csv("submission.csv")
#head(submission_sample)

length(unique(x_train[["id"]]))
sapply(x_train, typeof)
sapply(x_train, class)
sapply(x_train, function(x) length(unique(x)))

# convert all char columns to factors
x_train[sapply(x_train, is.character)] <- lapply(x_train[sapply(x_train, is.character)], 
              as.factor)
# convert the _code columns to factors
code_cols <- colnames(x_train)[grep("_code", colnames(x_train))] 
x_train[code_cols] <- lapply(xtrain[code_cols], as.factor)

ggplot(x_train, aes(x = basin)) + 
  geom_histogram(stat="count") + 
  coord_flip()



ggplot(x_train, aes(x = amount_tsh)) + 
  geom_density() + 
  coord_flip()




str(xdf)
unique_vals(xdf)
make_factors <- function(tdf){
  for (i in seq_along(colnames(tdf))){
    col = colnames(tdf)[i]
    nunique = length(unique(tdf[[col]]))
    class_ = class(tdf[[col]])
    if (class_ == "character"){
      print(paste("making ", col, " a factor"))
      tdf[col] = factor(tdf[col])
    }
    print(paste(col, nunique, class_))
  }
  return (tdf)
}

sapply(x_train, class)
sapply(xdf, class)
xdf <- make_factors(x_train)
yvar <- "district_code"
xvars <- colnames(x_train)
xvars <- yvars[xvars != yvar]

library(StatMatch)
pw.assoc(region_code ~ district_code, xdf)
pw.assoc(district_code ~ region_code, xdf)
head(xdf)
colnames(xdf)
library(DescTools)
TheilU(x_train[["region_code"]], x_train[["region"]] )

xs <- chisq.test(x_train[["region_code"]], x_train[["district_code"]], correct=F)
xs <- xs$statistic / length(x_train[["region_code"]])
xs
length(x_train["district_code"])
formula_ <- as.formula(paste(yvar, " ~ ", paste(xvars, collapse="+")))
library(rpart)
rpart(formula_, x_train)
library(rpart)
colnames(x_train)
tbl <-  xtabs(~region+district_code, x_train)
chisq.test(tbl)
?chisq.test
?xtabs
 x_train["region_code"]
 unique_vals(x_train, cols=c("region", "region_code", "district_code", "lga", "ward"))

# variable notes
# id is unique
colnames(x_train)[1:10]
#length(
length( unique(x_train[["amount_tsh"]]))
dim(x_train)
group_by(x_train, ~ id)
colnames(x_train)

tbl <- xtabs(formula=~ region_code+district_code, xdf)
tbl
xtabs(formula=~ payment+payment_type, xdf)
summary(x_train["num_private"])
num_vars <- c("date_recorded", "gps_height", "num_private",
              "region_code", "disgtrict_code")
cat_vars <- c("basin", "region", "public_meeting", 
              "scheme_management", "permit", 
              "extraction_type", "management",
              "payment", "water_quality", "quantity", 
              "source", "waterpoint_type")


summary(x_train['date_recorded'])

x_train_t <- xdf %>% dplyr::sample_frac(.75)
x_train_v  <- dplyr::anti_join(xdf, xtrain, by = 'id')

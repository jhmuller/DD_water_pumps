#  rm(list=ls())
library(tidyverse)
library(forcats) # probably loaded by tidyverse
library(ggplot2) # probably loaded by tidyverse
library(dplyr) # probably loaded by tidyverse
library(StatMatch) # for pw.assoc, loads a lot of other libraries
library(arrow)
library(randomForest)
library(xgboost)
#library(DescTools)
source("water_pump_utils.R")


train <- read_parquet("train.parquet")
valid <- read_parquet("valid.parquet")

# Note on vars
# region_code -> region 
# payment <-> payment_type
num_vars <- c("date_recorded", "gps_height", )
cat_vars <- c("basin", "region_code", "district_code", 
              "public_meeting", 
              "scheme_management", 
              "permit", 
              "extraction_type", "management",
              "payment", "water_quality", "quantity", 
              "source", "waterpoint_type")
xvars <- c(num_vars, cat_vars)
yvar <- "status_group"

for (col in c("permit", "public_meeting", "scheme_management")){
  print(paste("Making ", col, "a factor with an NA level"))
  train[col] <- as.factor(train[[col]])
  levels(train[[col]]) <- c(levels(train[[col]]), "zz_other")
  train[is.na(train[[col]]), col] <- "zz_other"
}
levels(train[["permit"]])

sum(is.na(train[cat_vars]))
unique_vals(train, c("public_meeting", "scheme_management", "permit"))


colnames(train)
plot_col(train, "permit")
length(xvars)
# Random Forest
form_ <- as.formula(paste(yvar, " ~ ",paste(xvars, collapse=" + ")))
rfm <- randomForest(form_, data=train)
rfm

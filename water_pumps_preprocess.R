#  rm(list=ls())
library(tidyverse)
library(forcats) # probably loaded by tidyverse
library(ggplot2) # probably loaded by tidyverse
library(dplyr) # probably loaded by tidyverse
library(StatMatch) # for pw.assoc, loads a lot of other libraries
library(arrow)
#library(DescTools)
source("water_pump_utils.R")

make_factor_cols <- function(df){
  # convert all char columns to factors
  df[sapply(df, is.character)] <- lapply(df[sapply(df, is.character)], 
                                         as.factor)
  # convert the _code columns to factors
  code_cols <- colnames(df)[grep("_code", colnames(df))] 
  df[code_cols] <- lapply(df[code_cols], as.factor)
  df$construction_year <- as.factor(df$construction_year)
  return (df)
}


x_train_dd <- read_parquet("x_train_dd.parquet")
y_train_dd <- read_parquet("y_train_dd.parquet")
x_test_dd <- read_parquet("x_test_dd.parquet")

train_dd <- dplyr::inner_join(x_train_dd, y_train_dd, by="id")

set.seed(129)
train <- train_dd %>% dplyr::sample_frac(.75)
valid  <- dplyr::anti_join(x_train_dd, train, by = 'id')

train <- make_factor_cols(train)
valid <- make_factor_cols(valid)
test_x <- make_factor_cols(x_test_dd)

write_parquet(train, "train.parquet")
write_parquet(valid, "valid.parquet")
write_parquet(test_x, "test_x.parquet")

# 
#  look at column types
sapply(x_train_dd, function(x) {print( paste(typeof(x), class(x)))})
sapply(x_train_dd, function(x) length(unique(x)))


get_counts(x_train_dd, "basin")
get_counts(x_train_dd, "num_private")
get_counts(x_train_dd, "lga")
get_counts(x_train_dd, "scheme_management")
get_counts(x_train_dd, "scheme_name")
get_counts(x_train_dd, "permit")
assoc(x_train_dd, "extraction_type", "extraction_type_group") # don't use the group
assoc(x_train_dd, "management", "management_group") # use management
assoc(x_train_dd, "payment", "payment_type") # can use either
assoc(x_train_dd, "water_quality", "quality_group") # don't need the group
assoc(x_train_dd, "quantity", "quantity_group") # can use either, use quantity
assoc(x_train_dd, "source", "source_type") # don't need source_type
assoc(x_train_dd, "waterpoint_type", "waterpoint_type_group") # don't need th group

# Note on vars
# region_code -> region 
# payment <-> payment_type
num_vars <- c("date_recorded", "gps_height", "num_private")
cat_vars <- c("basin", "region_code", "district_code", 
              "public_meeting", 
              "scheme_management", "permit", 
              "extraction_type", "management",
              "payment", "water_quality", "quantity", 
              "source", "waterpoint_type")

ctab(x_train_dd, "basin", "region")



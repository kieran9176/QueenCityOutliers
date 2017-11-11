## Library packages
library(tidyverse)
library(stringr)
library(dummies)
library(devtools)
library(xgboost)
install_github("AppliedDataSciencePartners/xgboostExplainer")
library(xgboostExplainer)
library(caret)
library(lubridate)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(leaflet)


# Read in data from build
setwd('~/Projects/QueenCityOutliers/')
# df_full_DMatrix <- readRDS(file = 'df_full_DMatrix.RDS')
xgb_1 <- readRDS(file = 'xgb_1.RDS')
explainer <- readRDS(file = 'explainer.RDS')
df_full_matrix<- readRDS(file = 'df_full_matrix.RDS')
preds_DF <- readRDS(file = 'preds_DF.RDS')
allzips <- readRDS("preds_DF.RDS")
allzips$latitude <- jitter(allzips$latitude)
allzips$longitude <- jitter(allzips$longitude)
index <- 1
cleantable <- allzips %>%
  select(
    Preds = preds,
    Lat = Latitude,
    Long = Longitude
  )

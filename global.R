library(dplyr)

allzips <- readRDS("data/preds_DF.RDS")
allzips$latitude <- jitter(allzips$latitude)
allzips$longitude <- jitter(allzips$longitude)

cleantable <- allzips %>%
  select(
    Preds = preds,
    Lat = Latitude,
    Long = Longitude
  )

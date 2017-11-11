##################################
## Hackathon - Traffic Datasets ##
##################################

## Library packages
library(tidyverse)
library(stringr)
library(dummies)

## Read In Traffic Data
traffic_data <- read_csv('~/Downloads/dataset/Charlotte Traffic Incidents/traffic.csv')
three11_data <- read_csv('~/Downloads/RequestsforService.csv')

# Create Features from 311 Data
three11traffic_clean <- three11_data %>% 
  mutate(TITLE = str_to_lower(TITLE),
         potholes = ifelse(grepl('pothole', TITLE), 1, 0),
         road = ifelse(grepl('road', TITLE), 1, 0),
         bball = ifelse(grepl('basketball', TITLE), 1, 0),
         tree = ifelse(grepl('tree', TITLE), 1, 0), 
         rightOfWay = ifelse(grepl('right of way', TITLE), 1, 0),
         streetSign = ifelse(grepl('street sign', TITLE), 1, 0),
         traffic = ifelse(grepl('traffic', TITLE), 1, 0),
         streetLight = ifelse(grepl('streetlight', TITLE), 1, 0),
         Latitude = round(Latitude, 3),
         Longitude = round(Longitude,3)) %>% 
  select(Latitude, Longitude, potholes, road, bball, tree, rightOfWay, streetSign, traffic, streetLight) %>% 
  group_by(Latitude, Longitude) %>% 
  summarise_all(funs(sum)) 

traffic_data_clean <- traffic_data %>% 
        filter(!is.na(CRSH_LEVL)) %>% 
        mutate(date_val = mdy_hm(DATE_VAL),
               crash = ifelse(CRSH_LEVL < 4, 1, 0),
               Latitude = round(LATITUDE, 3),
               Longitude = round(LONGITUDE, 3),
               ToD = gsub('.{2}$', '', MILT_TIME),
               ToD = ifelse(ToD == '', 0, ToD)) %>% 
        rename(DoW = DAY_OF_WEEK_DESC) %>% 
        select(Latitude, Longitude, ToD, DoW, CRASH_TYPE, LIT, WTHR, PRIMARY_CAUSE, NUM_LNS, RD_COND, RD_SURF, TRFC_CTRL, crash) %>% 
        dummy.data.frame(names = c('ToD', 'DoW', 'CRASH_TYPE', 'LIT', 'WTHR', 'PRIMARY_CAUSE', 'NUM_LNS', 'RD_COND', 'RD_SURF', 'TRFC_CTRL'), drop = TRUE) %>% 
        group_by(Latitude, Longitude) %>% 
        summarise_all(funs(mean))



ggplot(traffic_months, aes(x = DAY_OF_WEEK_DESC, y = count)) + 
  geom_col()



ggplot(traffic_data_clean %>% 
         group_by(RD_COND) %>% 
         summarise(crash = mean(crash)) %>% ungroup(), aes(x = RD_COND, y = crash)) + geom_col()

ggplot(traffic_data_clean %>% 
         group_by(RD_SURF) %>% 
         summarise(crash = mean(crash)) %>% ungroup(), aes(x = RD_COND, y = crash)) + geom_col()

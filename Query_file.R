install.packages("tidyverse")
library(tidyverse)

str(m04_2021)
str(m12_2020)
str(m10_2020)
str(m5_2020)

m5_2020 <-  mutate(m5_2020, start_station_id = as.character(start_station_id), end_station_id = as.character(end_station_id))
m6_2020 <-  mutate(m6_2020, start_station_id = as.character(start_station_id), end_station_id = as.character(end_station_id))
m7_2020 <-  mutate(m7_2020, start_station_id = as.character(start_station_id), end_station_id = as.character(end_station_id))
m8_2020 <-  mutate(m8_2020, start_station_id = as.character(start_station_id), end_station_id = as.character(end_station_id))
m9_2020 <-  mutate(m9_2020, start_station_id = as.character(start_station_id), end_station_id = as.character(end_station_id))
m10_2020 <-  mutate(m10_2020, start_station_id = as.character(start_station_id), end_station_id = as.character(end_station_id))
m11_2020 <-  mutate(m11_2020, start_station_id = as.character(start_station_id), end_station_id = as.character(end_station_id))


all_trips <- bind_rows(m5_2020, m6_2020 , m7_2020, m8_2020, m9_2020, m10_2020, m11_2020, m12_2020, m01_2021, m02_2021, m03_2021, m04_2021)

colnames(all_trips) 
nrow(all_trips) 
dim(all_trips)
head(all_trips)  
str(all_trips)  
summary(all_trips) 

table(all_trips$member_casual)

all_trips$date <- as.Date(all_trips$started_at) 
all_trips$month <- format(as.Date(all_trips$date), "%m")
all_trips$day <- format(as.Date(all_trips$date), "%d")
all_trips$year <- format(as.Date(all_trips$date), "%Y")
all_trips$day_of_week <- format(as.Date(all_trips$date), "%A")

all_trips$ride_length <- difftime(all_trips$ended_at,all_trips$started_at)

str(all_trips)

is.factor(all_trips$ride_length)
all_trips$ride_length <- as.numeric(as.character(all_trips$ride_length))
is.numeric(all_trips$ride_length)



all_trips_v2 <- all_trips[!(all_trips$start_station_name == "HUBBARD ST BIKE CHECKING (LBS-WH-TEST)" | all_trips$start_station_name == "WATSON TESTING - DIVVY" | 	
                              all_trips$start_station_name == "hubbard_test_lws" | all_trips$ride_length<0),]
all_trips_v2 <- all_trips_v2 %>% drop_na(ride_length)

mean(all_trips_v2$ride_length)
median(all_trips_v2$ride_length) 
max(all_trips_v2$ride_length)
min(all_trips_v2$ride_length)

aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = mean)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = median)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = max)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = min)

all_trips_v2$day_of_week <- ordered(all_trips_v2$day_of_week, levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))

aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)

library(lubridate)
all_trips_v2 %>%
  mutate(weekday = wday(started_at, label = TRUE)) %>%
  group_by(member_casual, weekday) %>%
  summarise(number_of_rides = n()		
            ,average_duration = mean(ride_length)) %>%		
  arrange(member_casual, weekday) 


all_trips_v2 %>%
  mutate(weekday = wday(started_at, label = TRUE)) %>%
  group_by(member_casual, weekday) %>%
  summarise(number_of_rides = n()		
            ,average_duration = mean(ride_length)) %>%		
  arrange(member_casual, weekday) %>% 
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge") + labs(title= " Rides Per Weekday ", subtitle= "number of rides booked by different members over the week")


all_trips_v2 %>%
  mutate(weekday = wday(started_at, label = TRUE)) %>%
  group_by(member_casual, weekday) %>%
  summarise(number_of_rides = n()		
            ,average_duration = mean(ride_length)) %>%		
  arrange(member_casual, weekday) %>% 
  ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge") + labs(title= " Average Duration Per Weekday ", subtitle= "")

counts <- aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)
write.csv(counts, file = '~/Desktop/Cyclistic/avg_ride_length.csv')

all_trips_v2$month_name <- format(months(as.Date(all_trips_v2$date)))
all_trips_v2 %>%
  group_by(member_casual, month_name) %>%
  summarise(number_of_rides = n()		
            ,average_duration = mean(ride_length)) %>%		
  arrange(member_casual, month_name) %>% 
  ggplot(aes(x = month_name, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")

table(all_trips$rideable_type)

all_trips_v2 %>%
  group_by(member_casual, rideable_type) %>%
  summarise(number_of_rides = n()) %>%		
  arrange(member_casual) %>% 
  ggplot(aes(x = rideable_type, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")

round_trips <- all_trips_v2 %>%
  select(c(start_lat, start_lng, start_station_name, end_station_name, ride_length,member_casual)) %>%
  filter(start_station_name == end_station_name)

write.csv(round_trips, file = '~/Desktop/Cyclistic/round.csv')

table(all_trips_v2$month)

latlng_trips <- all_trips_v2 %>%
  select(c(start_lat, start_lng, start_station_name, end_station_name, ride_length,member_casual))

write.csv(latlng_trips, file = '~/Desktop/Cyclistic/ltln.csv')
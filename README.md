# Cyclistic_Data_Analysis
A bike-share program that features more than 5,800 bicycles and 600 docking stations. Cyclistic sets itself apart by also offering reclining bikes, hand tricycles, and cargo bikes, making bike-share more inclusive to people with disabilities.

Customers who purchase single-ride or full-day passes are referred to as casual riders. Customers who purchase annual memberships are Cyclistic members.
Rather than creating a marketing campaign that targets all-new customers, Cyclistic marketing team needs to design a marketing strategy to convert casual riders into annual members as it is believed that maximizing the number of annual members will be the key to future growth.

**As this is a public dataset**, won’t be able to connect pass purchases to credit card numbers to determine if casual riders live in the Cyclistic service area or if they have purchased multiple single passes.

Asking Questions:
How do annual members and casual riders use Cyclistic bikes differently?
Why would casual riders buy Cyclistic annual memberships? 
How can Cyclistic use digital media to influence casual riders to become members?

## Executive Summary

* **Cyclistic’s finance analysts** have concluded that annual members are much more profitable than casual riders
* Cyclistic experiences **more rides booked by their annual members rather than casual riders**
* However, **Average duration per ride** for a casual rider is almost **three times** of mean of ride duration for annual member every day

## Business Task

Cyclistic marketing team needs to design marketing strategy to convert casual riders into annual members as it is believed that maximizing the number of annual members will be the key to future growth

## Description about data sources

* This Public Data was collected from the given link <https://divvy-tripdata.s3.amazonaws.com/index.html>.
* Downloaded the **past 12 months data (May/2020 - April/2021)**
* Data is reliable, original, comprehensive, cited and current.
* Each monthly dataset have **13 variables** (ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, start_station_id, end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual)
* Defined other columns for weekday, month, year and ride_length (*ended_at-started_at*) to go ahead with the processing of the data.
* Converted data type of the column (start_station_id and end_station_id) **from Double to Character** to merge all the 12 months data.

## Cleaning and Manipulation of Data

* Dataframe includes a few hundred entries **when bikes were taken out of docks** and checked for quality by Divvy or **ride_length was negative**.
* Removed rows with **Start_station_name == HUBBARD ST BIKE CHECKING (LBS-WH-TEST)" | "WATSON TESTING - DIVVY" | "hubbard_test_lws"**
* Created a new version of the dataframe (v2) since data is being removed.

`
all_trips_v2 <- all_trips[!(all_trips$start_station_name == "HUBBARD ST BIKE CHECKING (LBS-WH-TEST)" | all_trips$start_station_name == "WATSON TESTING - DIVVY" | all_trips$start_station_name == "hubbard_test_lws" | all_trips$ride_length<0),]
`</br>
`
all_trips_v2 <- all_trips_v2 %>% drop_na(ride_length)
`

## Summary of Analysis

* **Casual riders average ride duration is way higher than the annual members**, same pattern being followed for median, max.
* Intensity of Casual riders increases at weekends which means **more of the casual riders prefer bicycles for leisure activities than making use of it to go to work** where annual members bookings don't encounter much change over the week.
* **Docked Bike** is the most preferred bike by all riders including annual and casual.
* **Casual riders perform twice as round trips as compared to annual member** (start_station_name == end_station_name)
* Summer fests **(mainly in July and August)** in chicago leads to increase in demand of rides for both type of the members.

`
all_trips_v2$day_of_week <- ordered(all_trips_v2$day_of_week, levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))
`</br>
`
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)
`</br>
`
table(all_trips_v2$month)
table(all_trips$rideable_type)
`</br>
`
round_trips <- all_trips_v2 %>%
  select(c(start_lat, start_lng, start_station_name, end_station_name, ride_length,member_casual)) %>%
  filter(start_station_name == end_station_name)
`
## Supporting Visualizations and key Findings

### **Weekend (Saturday and Sunday)** -> High turnup of casual riders as compared to week days


![](https://github.com/Kartik77/Cyclistic_Data_Analysis/blob/main/Plots/rides_weekday.png?raw=true)

### Average ride duration for casual members is **almost three times** of annual members


![](https://github.com/Kartik77/Cyclistic_Data_Analysis/blob/main/Plots/Average_Duration.png?raw=true)

### **Docked Bike** most preferred one among the all


![](https://github.com/Kartik77/Cyclistic_Data_Analysis/blob/main/Plots/ride_type_bike.png?raw=true)

### **July and August**, these two months experience high demand in bikes over the region

(may be because of summer fests)

![](https://github.com/Kartik77/Cyclistic_Data_Analysis/blob/main/Plots/monthly_ride.png?raw=true)

### **Station with round trip entries**, for testing bikes at these stations on regular time intervals


![](https://github.com/Kartik77/Cyclistic_Data_Analysis/blob/main/Plots/round_trip.png?raw=true)

### **Busiest Stations**, to keep a check on volume of bikes so that numbers satisfies the customer demands


![](https://github.com/Kartik77/Cyclistic_Data_Analysis/blob/main/Plots/busiest.png?raw=true)

## Recommendations

**Additional Data to be included** (Survey on happiness metric of annual members, are there any problems faced by casual riders, (if yes, what are those?) and also get to know the reason for not choosing annual membership program.

1. **Share Posts on different digital media platforms highlighting Cyclistic's finance analyst data** on how annual members are much more profitable than casual riders.
2. **Highlight the benefits of using bicycles to travel on daily basis** both financially and physically to casual riders, this will help to make them think of these bikes not only for leisure activities but also while going for work.
3. Share average duration insights to casual riders through visuals and **state the problems faced by different customers, especially on longer rides**(higher ride_length) and **respective solutions as well** (i.e. exchange bicycles at any other station, start ride without worrying about payment and free from the responsibility of taking care of bikes on your own)
4. **Examine the increase in demand for the months (July and August)**, team should see the particular reason behind it and work on the same. 

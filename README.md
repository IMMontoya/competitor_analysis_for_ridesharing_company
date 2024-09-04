
# Competitor Analysis for Ride Sharing Company

Zuber, a new ride-sharing company that's launching in Chicago, has gathered data on their competitors' and want to find patterns within that dataset. Specifically they are looking for passenger preferences and the impact of weather on rides.  

Working with the database, I have uncovered key insights into passenger behavior and tested the hypothesis "The duration of rides from the the Loop to
O'Hare International Airport changes on rainy Saturdays."  

## Table of Contents

[Notebook](EDA.ipynb)  
[Data Gathering](#data-gathering)  
[Website Parser](website_parser.py)  
[Observations and Insights](#observations-and-insights)  
[Conclusion](#conclusion)  

## Data Gathering

### 1. Website Parsing

[This script](/website_parser.py) gathers the weather information for Chicago Weather Records of November 2017 from [an open source data set](https://practicum-content.s3.us-west-1.amazonaws.com/data-analyst-eng/moved_chicago_weather_2017.html) and builds the `weather_records` table in the relational database.

### 2. PostgreSQL Database Queries

#### Table Scheme

[These queries](/SQL_queries/) retrieve and process data for various aspects of the ride sharing analysis.

![Table Scheme](/images/table_scheme.png)

#### 2.1 Query for Trips by Company

Retrieves data found in `project_sql_result_01.csv`.

```sql
--- Gets the number of trips for each company on 2017-11-15 and 2017-11-16
SELECT 
    cabs.company_name AS company_name,
    COUNT(trips.trip_id) AS trips_amount
FROM 
    cabs
    INNER JOIN trips ON trips.cab_id = cabs.cab_id
WHERE
    CAST(trips.start_ts AS date) BETWEEN '2017-11-15' AND '2017-11-16'
GROUP BY 
    company_name
ORDER BY 
    trips_amount DESC;
```

#### 2.2 Query for Trips by Neighborhood

Retrieves data found in `project_sql_result_04.csv`.

```sql
--- Gets the number of trips that ended in each neighborhood in November 2017, sorted in descending order
SELECT 
    neighborhoods.name AS dropoff_location_name,
    COUNT(trips.trip_id) AS trips
FROM trips 
    INNER JOIN
    neighborhoods 
    ON trips.dropoff_location_id = neighborhoods.neighborhood_id
WHERE 
    trips.end_ts::date BETWEEN '2017-11-01' AND '2017-11-30'
GROUP BY 
    dropoff_location_name
ORDER BY 
    trips DESC;
```

#### 2.3 Query for Specific Ride Conditions

Retrieves data found in `project_sql_result_07.csv`.

```sql
--- Gets all the rides that started in the Loop and ended at O'Hare on a Saturday, and the weather conditions for each ride.
SELECT 
    trips.start_ts,
    CASE 
        WHEN weather_records.description LIKE '%rain%' THEN 'Bad'
        WHEN weather_records.description LIKE '%storm%' THEN 'Bad'
        ELSE 'Good' END AS weather_conditions,
    trips.duration_seconds
FROM 
    trips 
    INNER JOIN 
    weather_records
    ON trips.start_ts = weather_records.ts
WHERE 
    EXTRACT(DOW FROM trips.start_ts) = 6
    AND trips.pickup_location_id = 50
    AND trips.dropoff_location_id = 63
ORDER BY 
    trips.trip_id;
```

## Observations and Insights

1. **Neighborhood Analysis**: The Loop neighborhood proves to be the most common destination for the month of November 2017. ![Top Ten Neighborhoods](/images/top_10_neighborhoods.png)
2. **Company Performance**: The Flash Cab company proves to be the most used cab services between November 15th and 16th, 2017, leading the second place by almost double. ![Top Ten Companies](/images/top_10_companies.png)
3. **Weather Conditions Effect on Ride Duration**: We can reject the null hypothesis that there is no difference in average duration of rides from Loop to O'Hare on rainy Saturdays compared to clear Saturdays with an alpha value as low as .01, providing strong evidence that this perceived difference is not due to statistical noise. Trips on clear Saturdays average significantly shorter durations than trips on Rainy Saturdays. The difference between durations for the two groups is about 8.93 minutes.

## Conclusion

This analysis offers  insights into Chicago's ride-sharing market during November 2017, focusing on neighborhood preferences, company performance, and the influence of weather on ride durations. By analyzing data from various sources, we've highlighted significant findings such as the Loop neighborhood's popularity, Flash Cab's dominant market performance, and the measurable impact of weather conditions on trip durations between specific locations. These insights are crucial for refining strategic decisions, enhancing service efficiency, and gaining a competitive edge in the ride-sharing industry.

## Libraries Used

Python 3.10.9  
pandas=2.0.3  
matplotlib=3.7.1  
scipy=1.13.0  
requests=2.31.0  
bs4=4.12.2  

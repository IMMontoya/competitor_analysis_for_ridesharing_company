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
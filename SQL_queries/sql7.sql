--- Gets all the rides that started in the Loop (neighborhood_id : 50) and ended at O'Hare (neighborhood_id : 63) on a Saturday, and the weather conditions for each ride.

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
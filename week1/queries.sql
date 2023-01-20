/* Question 3: How many trips were totally made on January 15
   Methodology: the trip has to start and end on the same date
   Approach: cast both timestamps to date (postgres understands YYYY-MM-DD) */
SELECT count(1)
FROM taxi_trips
WHERE lpep_pickup_datetime::date = '2019-01-15'
  and lpep_dropoff_datetime::date = '2019-01-15'


/* Question 4: Which was the day with the largest trip distance
   Methodology: fetch date with max travel distance
   Approach: there are two possible approaches here.
   The more consistent one that requires more computational power is sorting.
   Another one would be selecting map trip distance first and then getting the date for it */

--  2 fetches
SELECT lpep_pickup_datetime, lpep_dropoff_datetime
FROM taxi_trips
WHERE trip_distance = (SELECT max(trip_distance) from taxi_trips)

--  sorting
SELECT lpep_pickup_datetime, lpep_dropoff_datetime
FROM taxi_trips ORDER BY trip_distance DESC LIMIT 1

/* Question 5: In 2019-01-01 how many trips had 2 and 3 passengers?
   Methodology: since fetching the same dates (start and end) returns result that is not in the answers, explore start and end separately
   Approach: filter by passenger count and date, fetch count of start and end dates to make sure we are consistent */


-- Start and End
SELECT count(lpep_pickup_datetime), count(lpep_dropoff_datetime) FROM taxi_trips WHERE lpep_pickup_datetime::date = '2019-01-01' and lpep_dropoff_datetime::date = '2019-01-01' and passenger_count = 2
SELECT count(lpep_pickup_datetime), count(lpep_dropoff_datetime) FROM taxi_trips WHERE lpep_pickup_datetime::date = '2019-01-01' and lpep_dropoff_datetime::date = '2019-01-01' and passenger_count = 3

-- Start
SELECT count(lpep_pickup_datetime), count(lpep_dropoff_datetime)
FROM taxi_trips
WHERE lpep_pickup_datetime::date = '2019-01-01' and passenger_count = 2

SELECT count(lpep_pickup_datetime), count(lpep_dropoff_datetime)
FROM taxi_trips
WHERE lpep_pickup_datetime::date = '2019-01-01' and passenger_count = 3

-- End
SELECT count(lpep_pickup_datetime), count(lpep_dropoff_datetime)
FROM taxi_trips
WHERE lpep_dropoff_datetime::date = '2019-01-01' and passenger_count = 2

SELECT count(lpep_pickup_datetime), count(lpep_dropoff_datetime)
FROM taxi_trips
WHERE lpep_dropoff_datetime::date = '2019-01-01' and passenger_count = 3


/* Question 6: For the passengers picked up in the Astoria Zone which was the drop up zone that had the largest tip?
   Methodology: we could sql join the two tables, or take a multi-step approach. Since the column names are capitalized, we take it in ""
   Approach:
   Step 1: Fetch an ID for Astoria Zone
   Step 2: Fetch largest tip for Astoria Zone ID and drop off zone ID
   Step 3: Fetch drop off zone ID name */

-- Stepwise
SELECT "LocationID" FROM taxi_zones WHERE "Zone" = 'Astoria'
-- returns 7
SELECT max(tip_amount) FROM taxi_trips WHERE "PULocationID" = 7
-- returns 88
SELECT "DOLocationID" FROM taxi_trips WHERE tip_amount = 88.0
-- returns 146
SELECT "Zone" FROM taxi_zones WHERE "LocationID" = 146

-- Single query using subqueries

SELECT "Zone"
FROM (
    SELECT "DOLocationID", tip_amount
    FROM (
        SELECT tip_amount, "PULocationID", "Zone", "DOLocationID"
        FROM taxi_trips tt
        LEFT JOIN taxi_zones tz
        ON "PULocationID" = "LocationID"
        ) as pull_join
    WHERE "Zone" = 'Astoria'
    ORDER BY tip_amount DESC LIMIT 1
    ) top_tip_in_astoria
JOIN taxi_zones
ON "DOLocationID" = "LocationID"

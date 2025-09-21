
CREATE SCHEMA IF NOT EXISTS reporting;

DROP VIEW IF EXISTS reporting.vw_flight_report;

CREATE VIEW reporting.vw_flight_report AS
WITH t AS (
  SELECT
    f.flight_id,
    f.flight_date,
    f.airline_code,
    f.origin  AS dep_airport_code,
    f.dest    AS arr_airport_code,

    -- HHMM -> time (safe conversion)
    CASE
      WHEN f.crs_dep_time BETWEEN 0 AND 2359 AND (f.crs_dep_time % 100) BETWEEN 0 AND 59
        THEN make_time((f.crs_dep_time/100)::int, (f.crs_dep_time % 100)::int, 0)
      WHEN f.crs_dep_time = 2400 THEN make_time(0,0,0)
      ELSE NULL
    END AS crs_dep_time_local,

    CASE
      WHEN f.dep_time BETWEEN 0 AND 2359 AND (f.dep_time % 100) BETWEEN 0 AND 59
        THEN make_time((f.dep_time/100)::int, (f.dep_time % 100)::int, 0)
      WHEN f.dep_time = 2400 THEN make_time(0,0,0)
      ELSE NULL
    END AS dep_time_local,

    CASE
      WHEN f.crs_arr_time BETWEEN 0 AND 2359 AND (f.crs_arr_time % 100) BETWEEN 0 AND 59
        THEN make_time((f.crs_arr_time/100)::int, (f.crs_arr_time % 100)::int, 0)
      WHEN f.crs_arr_time = 2400 THEN make_time(0,0,0)
      ELSE NULL
    END AS crs_arr_time_local,

    CASE
      WHEN f.arr_time BETWEEN 0 AND 2359 AND (f.arr_time % 100) BETWEEN 0 AND 59
        THEN make_time((f.arr_time/100)::int, (f.arr_time % 100)::int, 0)
      WHEN f.arr_time = 2400 THEN make_time(0,0,0)
      ELSE NULL
    END AS arr_time_local,

    f.dep_delay_minutes,
    f.arr_delay_minutes,
    f.cancelled,
    f.cancellation_code,
    f.diverted,
    f.distance,
    f.carrier_delay,
    f.weather_delay,
    f.nas_delay,
    f.security_delay,
    f.late_aircraft_delay
  FROM fact_flight f
)
SELECT
  t.flight_id,
  t.flight_date,

  -- Airline
  al.airline_code,
  al.airline_name,

  -- Departure airport
  dep.airport_code  AS dep_airport_code,
  dep.airport_name  AS dep_airport_name,
  dep.city          AS dep_city,
  dep.country       AS dep_country,
  dep.latitude      AS dep_latitude,
  dep.longitude     AS dep_longitude,

  -- Arrival airport
  arr.airport_code  AS arr_airport_code,
  arr.airport_name  AS arr_airport_name,
  arr.city          AS arr_city,
  arr.country       AS arr_country,
  arr.latitude      AS arr_latitude,
  arr.longitude     AS arr_longitude,

  -- Local (reported) times
  t.crs_dep_time_local,
  t.dep_time_local,
  t.crs_arr_time_local,
  t.arr_time_local,

  -- Metrics
  t.dep_delay_minutes,
  t.arr_delay_minutes,
  t.cancelled,
  t.cancellation_code,
  t.diverted,
  t.distance,
  t.carrier_delay,
  t.weather_delay,
  t.nas_delay,
  t.security_delay,
  t.late_aircraft_delay

FROM t
JOIN dim_airline al  ON al.airline_code  = t.airline_code
JOIN dim_airport dep ON dep.airport_code = t.dep_airport_code
JOIN dim_airport arr ON arr.airport_code = t.arr_airport_code;

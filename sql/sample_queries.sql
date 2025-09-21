
-- Sanity checks after creating the view
SELECT COUNT(*) AS rows_in_view FROM reporting.vw_flight_report;

SELECT * FROM reporting.vw_flight_report LIMIT 10;

SELECT
  SUM(CASE WHEN dep_time_local IS NULL THEN 1 ELSE 0 END) AS null_dep_time,
  SUM(CASE WHEN arr_time_local IS NULL THEN 1 ELSE 0 END) AS null_arr_time
FROM reporting.vw_flight_report;

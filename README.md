✈️ **Flights SQL Reporting View**

In this project I built a single reporting view that makes flight data easy to explore and connect to BI tools.
The idea was to take raw tables (fact_flight, dim_airline, dim_airport) and turn them into one clean and ready-to-use table.

**What I did**

Converted flight times (like 700 or 2359) into proper SQL time values so they are safe and accurate.

Joined the flights with airline and airport details (names, city, country, coordinates).

Created a view under the reporting schema that can be connected directly to tools like Power BI.

**Why it’s useful**

Instead of juggling multiple tables and strange time formats, now there’s one clear dataset that shows:
Airline → Departure → Arrival → Times → Delays → Cancellations.

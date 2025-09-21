
-- Recommended indexes
CREATE INDEX IF NOT EXISTS ix_fact_airline_code ON fact_flight (airline_code);
CREATE INDEX IF NOT EXISTS ix_fact_origin       ON fact_flight (origin);
CREATE INDEX IF NOT EXISTS ix_fact_dest         ON fact_flight (dest);

CREATE INDEX IF NOT EXISTS ix_dim_airline_code  ON dim_airline (airline_code);
CREATE INDEX IF NOT EXISTS ix_dim_airport_code  ON dim_airport (airport_code);

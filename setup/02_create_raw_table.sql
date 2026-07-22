-- Create the raw transport data table
-- Database: sql_practice
-- Schema: tfl

CREATE TABLE tfl.raw_transport_data (
    period_financial_year TEXT,
    reporting_period INTEGER,
    days_in_period INTEGER,
    period_beginning TIMESTAMP,
    period_ending TIMESTAMP,
    bus_journeys_m NUMERIC,
    underground_journeys_m NUMERIC,
    dlr_journeys_m NUMERIC,
    tram_journeys_m NUMERIC,
    overground_journeys_m NUMERIC,
    london_cable_car_journeys_m NUMERIC,
    tfl_rail_journeys_m NUMERIC
);
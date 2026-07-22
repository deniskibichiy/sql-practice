-- SQL Basics Practice
-- Date: 2026-07-22
-- Dataset: Public Transport Journeys

-- Exercise 1
-- Select all columns from the raw transport dataset.

SELECT *
FROM tfl.raw_transport_data;


-- Exercise 2
-- Select the financial year, bus journeys,
-- and underground journeys.

SELECT
    period_financial_year,
    bus_journeys_m,
    underground_journeys_m
FROM tfl.raw_transport_data;


-- Exercise 3
-- Use AS to create readable column aliases.

SELECT
    period_financial_year AS financial_year,
    bus_journeys_m AS bus_journeys
FROM tfl.raw_transport_data;


-- Exercise 4
-- Find periods where bus journeys exceeded 200 million.

SELECT
    period_financial_year,
    bus_journeys_m
FROM tfl.raw_transport_data
WHERE bus_journeys_m > 200;


-- Exercise 5
-- Find periods where both bus journeys
-- exceeded 200 million and underground journeys
-- exceeded 100 million.

SELECT
    period_financial_year,
    bus_journeys_m,
    underground_journeys_m
FROM tfl.raw_transport_data
WHERE bus_journeys_m > 200
  AND underground_journeys_m > 100;
SELECT
    period_financial_year,
    reporting_period,
    bus_journeys_m,
    underground_journeys_m
FROM tfl.raw_transport_data
WHERE (bus_journeys_m > 200 OR underground_journeys_m > 100)
  AND (reporting_period = 1 OR reporting_period = 2);

SELECT
    period_financial_year,
    reporting_period,
    bus_journeys_m,
    underground_journeys_m
FROM tfl.raw_transport_data
WHERE reporting_period BETWEEN 1 AND 4;

SELECT
    period_financial_year,
    reporting_period,
    bus_journeys_m
FROM tfl.raw_transport_data
WHERE bus_journeys_m BETWEEN 150 AND 200;

/* 20_views.sql */

/* 3.1 Daily AQI by Site (with AQICategory) */
CREATE OR ALTER VIEW eng.vw_AQI_Daily_BySite AS
SELECT
    T1.SiteID,
    CONVERT(date, T1.[Timestamp])                       AS ObservationDate,
    AVG(CAST(T1.AQI AS DECIMAL(10,2)))                  AS AvgAQI,
    MIN(T1.AQI)                                         AS MinAQI,
    MAX(T1.AQI)                                         AS MaxAQI,
    AVG(CAST(T1.PM2_5 AS DECIMAL(10,2)))                AS AvgPM25,
    CASE
        WHEN AVG(CAST(T1.AQI AS DECIMAL(10,2))) <= 50 THEN 'Good'
        WHEN AVG(CAST(T1.AQI AS DECIMAL(10,2))) <= 100 THEN 'Moderate'
        WHEN AVG(CAST(T1.AQI AS DECIMAL(10,2))) <= 150 THEN 'Unhealthy'
        WHEN AVG(CAST(T1.AQI AS DECIMAL(10,2))) <= 200 THEN 'Very Unhealthy'
        ELSE 'Hazardous'
    END AS AQICategory
FROM eng.AirQuality T1
WHERE T1.[Timestamp] IS NOT NULL
  AND T1.AQI IS NOT NULL
GROUP BY
    T1.SiteID,
    CONVERT(date, T1.[Timestamp]);
GO
/* 3.2 Monthly AQI by Region (cast before formatting, with AQICategory) */
CREATE OR ALTER VIEW eng.vw_AQI_ByRegion_Monthly AS
WITH M AS (
    SELECT
        T1.SiteID,
        CAST(T1.[Timestamp] AS DATE)                                        AS ObsDate,
        DATEFROMPARTS(YEAR(T1.[Timestamp]), MONTH(T1.[Timestamp]), 1)       AS ObservationMonth,
        T1.AQI
    FROM eng.AirQuality T1
    WHERE T1.[Timestamp] IS NOT NULL
)
SELECT
    T2.Region,
    M.ObservationMonth,
    CONVERT(char(7), M.ObservationMonth, 120)            AS ObservationMonthYYYYMM, -- e.g., 2025-08
    AVG(CAST(M.AQI AS DECIMAL(10,2)))                    AS AvgAQI,
    CASE
        WHEN AVG(CAST(M.AQI AS DECIMAL(10,2))) <= 50 THEN 'Good'
        WHEN AVG(CAST(M.AQI AS DECIMAL(10,2))) <= 100 THEN 'Moderate'
        WHEN AVG(CAST(M.AQI AS DECIMAL(10,2))) <= 150 THEN 'Unhealthy'
        WHEN AVG(CAST(M.AQI AS DECIMAL(10,2))) <= 200 THEN 'Very Unhealthy'
        ELSE 'Hazardous'
    END AS AQICategory
FROM M
JOIN eng.Locations T2 ON M.SiteID = T2.SiteID
GROUP BY
    T2.Region,
    M.ObservationMonth;
GO
/* 3.3 Monthly Energy Usage by Region (kWh) */
CREATE OR ALTER VIEW eng.vw_Energy_ByRegion_Monthly AS
SELECT
    T1.Region,
    DATEFROMPARTS(YEAR(T1.UsageDate), MONTH(T1.UsageDate), 1) AS UsageMonth,
    CONVERT(char(7), DATEFROMPARTS(YEAR(T1.UsageDate), MONTH(T1.UsageDate), 1), 120) AS UsageMonthYYYYMM,
    SUM(T1.kWh) AS TotalKWh
FROM eng.EnergyUsage T1
GROUP BY
    T1.Region,
    DATEFROMPARTS(YEAR(T1.UsageDate), MONTH(T1.UsageDate), 1);
GO

/* 3.4 Wildlife Monthly Trends */
CREATE OR ALTER VIEW eng.vw_Wildlife_MonthlyTrends AS
SELECT
    T1.Species,
    DATEFROMPARTS(YEAR(T1.ObservationDate), MONTH(T1.ObservationDate), 1) AS ObservationMonth,
    CONVERT(char(7), DATEFROMPARTS(YEAR(T1.ObservationDate), MONTH(T1.ObservationDate), 1), 120) AS ObservationMonthYYYYMM,
    SUM(T1.[Count]) AS TotalSightings
FROM eng.WildlifeObservations T1
GROUP BY
    T1.Species,
    DATEFROMPARTS(YEAR(T1.ObservationDate), MONTH(T1.ObservationDate), 1);
GO

/* 3.5 Water Quality Trends */
CREATE OR ALTER VIEW eng.vw_WaterQuality_Trends AS
SELECT
    T1.SiteID,
    T2.Region,
    T1.ObservationDate,
    T1.pH,
    T1.ContaminantPPB
FROM eng.WaterQuality T1
JOIN eng.Locations   T2 ON T1.SiteID = T2.SiteID;
GO

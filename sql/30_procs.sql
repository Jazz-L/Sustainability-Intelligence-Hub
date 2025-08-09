/* 30_procs.sql */

CREATE OR ALTER PROCEDURE eng.usp_GetTopPollutedSites
    @TopN INT = 5,
    @FromDate DATE = NULL,
    @ToDate   DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@TopN)
        T2.SiteName,
        T2.Region,
        AVG(CAST(T1.AQI AS DECIMAL(10,2))) AS AvgAQI
    FROM eng.AirQuality T1
    JOIN eng.Locations  T2 ON T1.SiteID = T2.SiteID
    WHERE (@FromDate IS NULL OR CAST(T1.[Timestamp] AS DATE) >= @FromDate)
      AND (@ToDate   IS NULL OR CAST(T1.[Timestamp] AS DATE) <= @ToDate)
      AND T1.AQI IS NOT NULL
    GROUP BY T2.SiteName, T2.Region
    ORDER BY AvgAQI DESC;
END
GO

CREATE OR ALTER PROCEDURE eng.usp_WildlifeMonthlyTrends
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        T1.Species,
        DATEFROMPARTS(YEAR(T1.ObservationDate), MONTH(T1.ObservationDate), 1) AS ObservationMonth,
        CONVERT(char(7), DATEFROMPARTS(YEAR(T1.ObservationDate), MONTH(T1.ObservationDate), 1), 120) AS ObservationMonthYYYYMM,
        SUM(T1.[Count]) AS TotalSightings
    FROM eng.WildlifeObservations T1
    GROUP BY
        T1.Species,
        DATEFROMPARTS(YEAR(T1.ObservationDate), MONTH(T1.ObservationDate), 1);
END
GO

# Power BI Starter (Views Pre-Wired)

## Parameters
Create two Text parameters in Power BI Desktop:
- ServerName (e.g., your-sql-server.database.windows.net)
- DatabaseName (e.g., your-db-name)

## Queries (Power Query M)
For each query, go to Power Query Editor → New Source → Blank Query → Advanced Editor and paste.

-- vw_AQI_ByRegion_Monthly
let
  Source = Sql.Database(ServerName, DatabaseName),
  View = Source{[Schema="eng",Item="vw_AQI_ByRegion_Monthly"]}[Data]
in
  View

-- vw_AQI_Daily_BySite
let
  Source = Sql.Database(ServerName, DatabaseName),
  View = Source{[Schema="eng",Item="vw_AQI_Daily_BySite"]}[Data]
in
  View

-- vw_Energy_ByRegion_Monthly
let
  Source = Sql.Database(ServerName, DatabaseName),
  View = Source{[Schema="eng",Item="vw_Energy_ByRegion_Monthly"]}[Data]
in
  View

-- vw_Wildlife_MonthlyTrends
let
  Source = Sql.Database(ServerName, DatabaseName),
  View = Source{[Schema="eng",Item="vw_Wildlife_MonthlyTrends"]}[Data]
in
  View

-- vw_WaterQuality_Trends
let
  Source = Sql.Database(ServerName, DatabaseName),
  View = Source{[Schema="eng",Item="vw_WaterQuality_Trends"]}[Data]
in
  View

## Date Table (DAX)
Create a new table in Power BI with this DAX:

Dates =
VAR MinDate =
    DATE(2025, 1, 1)
VAR MaxDate =
    DATE(2026, 12, 31)
RETURN
    ADDCOLUMNS(
        CALENDAR(MinDate, MaxDate),
        "Year", YEAR([Date]),
        "MonthNumber", MONTH([Date]),
        "YearMonth", FORMAT([Date], "YYYY-MM")
    )

Relate:
- Dates[Date] → vw_AQI_Daily_BySite[ObservationDate]
- Dates[Date] → vw_AQI_ByRegion_Monthly[ObservationMonth]
- Dates[Date] → vw_Energy_ByRegion_Monthly[UsageMonth]
- Dates[Date] → vw_Wildlife_MonthlyTrends[ObservationMonth]

## Suggested Visuals
- Page: Air Quality → Line chart by Dates[Date], AvgAQI; Slicer: Region
- Page: Energy → Clustered column by UsageMonthYYYYMM, TotalKWh; Slicer: Region
- Page: Wildlife → Line by ObservationMonthYYYYMM, TotalSightings; Slicer: Species
- Page: Water → Table of Region, ObservationDate, pH, ContaminantPPB

Save this file next to your .pbix as a reference.

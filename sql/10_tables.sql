/* 10_tables.sql */

/* Locations */
IF OBJECT_ID('eng.Locations','U') IS NULL
BEGIN
    CREATE TABLE eng.Locations
    (
        SiteID         INT            NOT NULL PRIMARY KEY,
        SiteName       NVARCHAR(200)  NULL,
        Region         NVARCHAR(100)  NOT NULL,
        Latitude       DECIMAL(9,6)   NULL,
        Longitude      DECIMAL(9,6)   NULL,
        CreatedAt      DATETIME2(0)   NOT NULL DEFAULT SYSUTCDATETIME()
    );
END
GO

/* AirQuality */
IF OBJECT_ID('eng.AirQuality','U') IS NULL
BEGIN
    CREATE TABLE eng.AirQuality
    (
        AQID        BIGINT IDENTITY(1,1) PRIMARY KEY,
        SiteID      INT           NOT NULL,
        [Timestamp] DATETIME2(0)  NOT NULL,
        AQI         INT           NULL,
        PM2_5       DECIMAL(9,2)  NULL,
        SourceFile  NVARCHAR(260) NULL
    );
    ALTER TABLE eng.AirQuality
    ADD CONSTRAINT FK_AirQuality_Locations
        FOREIGN KEY (SiteID) REFERENCES eng.Locations(SiteID);
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = 'IX_AirQuality_Site_Ts' AND object_id = OBJECT_ID('eng.AirQuality')
)
BEGIN
    CREATE INDEX IX_AirQuality_Site_Ts ON eng.AirQuality (SiteID, [Timestamp]);
END
GO

/* WaterQuality */
IF OBJECT_ID('eng.WaterQuality','U') IS NULL
BEGIN
    CREATE TABLE eng.WaterQuality
    (
        WaterID        BIGINT IDENTITY(1,1) PRIMARY KEY,
        SiteID         INT           NOT NULL,
        ObservationDate DATE         NOT NULL,
        pH             DECIMAL(4,2)  NULL,
        ContaminantPPB DECIMAL(12,4) NULL,
        SourceFile     NVARCHAR(260) NULL
    );
    ALTER TABLE eng.WaterQuality
    ADD CONSTRAINT FK_WaterQuality_Locations
        FOREIGN KEY (SiteID) REFERENCES eng.Locations(SiteID);
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = 'IX_WaterQuality_Site_Date' AND object_id = OBJECT_ID('eng.WaterQuality')
)
BEGIN
    CREATE INDEX IX_WaterQuality_Site_Date ON eng.WaterQuality (SiteID, ObservationDate);
END
GO

/* WildlifeObservations */
IF OBJECT_ID('eng.WildlifeObservations','U') IS NULL
BEGIN
    CREATE TABLE eng.WildlifeObservations
    (
        WildlifeID      BIGINT IDENTITY(1,1) PRIMARY KEY,
        SiteID          INT           NULL,
        Species         NVARCHAR(150) NOT NULL,
        ObservationDate DATE          NOT NULL,
        [Count]         INT           NOT NULL,
        SourceFile      NVARCHAR(260) NULL
    );
    ALTER TABLE eng.WildlifeObservations
    ADD CONSTRAINT FK_Wildlife_Locations
        FOREIGN KEY (SiteID) REFERENCES eng.Locations(SiteID);
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = 'IX_Wildlife_Date_Species' AND object_id = OBJECT_ID('eng.WildlifeObservations')
)
BEGIN
    CREATE INDEX IX_Wildlife_Date_Species ON eng.WildlifeObservations (ObservationDate, Species);
END
GO

/* EnergyUsage */
IF OBJECT_ID('eng.EnergyUsage','U') IS NULL
BEGIN
    CREATE TABLE eng.EnergyUsage
    (
        EnergyID    BIGINT IDENTITY(1,1) PRIMARY KEY,
        Region      NVARCHAR(100) NOT NULL,
        UsageDate   DATE          NOT NULL,
        kWh         DECIMAL(18,2) NOT NULL,
        SourceFile  NVARCHAR(260) NULL
    );
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = 'IX_Energy_Region_Date' AND object_id = OBJECT_ID('eng.EnergyUsage')
)
BEGIN
    CREATE INDEX IX_Energy_Region_Date ON eng.EnergyUsage (Region, UsageDate);
END
GO

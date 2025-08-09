/* 00_schema.sql */
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'eng')
BEGIN
    EXEC('CREATE SCHEMA eng');
END
GO

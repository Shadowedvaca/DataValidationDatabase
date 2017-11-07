/****** Object:  Table [dv].[Targets]    Script Date: 11/6/2017 11:44:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dv].[Targets](
	[ID] [BIGINT] IDENTITY(1,1) NOT NULL,
	[ShortName] [NVARCHAR](50) NOT NULL,
	[Name] [NVARCHAR](255) NOT NULL,
	[Descr] [NVARCHAR](MAX) NOT NULL,
	[ValidationID] [BIGINT] NOT NULL,
	[TargetCatalog] [NVARCHAR](128) NOT NULL,
	[TargetSchema] [NVARCHAR](128) NOT NULL,
	[TargetTable] [NVARCHAR](128) NOT NULL,
	[DetailColumn] [NVARCHAR](128) NOT NULL,
	[TableNameNeedsBatchSuffix] [TINYINT] NULL,
	[CreateDate] [DATETIME] NULL,
	[UpdateDate] [DATETIME] NULL,
	[LastRun] [DATETIME] NULL,
	[IsActive] [TINYINT] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dv].[Targets] ADD  DEFAULT ((0)) FOR [TableNameNeedsBatchSuffix]
GO

ALTER TABLE [dv].[Targets] ADD  DEFAULT (GETDATE()) FOR [CreateDate]
GO

ALTER TABLE [dv].[Targets] ADD  DEFAULT (GETDATE()) FOR [UpdateDate]
GO

ALTER TABLE [dv].[Targets] ADD  DEFAULT ((1)) FOR [IsActive]
GO

CREATE TRIGGER [dv].[tD_Targets] ON [dv].[Targets]
	INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON

	UPDATE dv.Targets
	SET IsActive = 0
	WHERE ID IN ( SELECT ID FROM Deleted )

	RAISERROR( 'Record was flagged to IsActive = 0 instead of being deleted.', 0, 1 )

END

GO

ALTER TABLE [dv].[Targets] ENABLE TRIGGER [tD_Targets]
GO

CREATE TRIGGER [dv].[tI_Targets] ON [dv].[Targets]
	FOR INSERT
AS
BEGIN
    SET NOCOUNT ON

	DECLARE @DMLAction AS NVARCHAR(25)
	DECLARE @DMLDate AS DATETIME
	DECLARE @TableName AS NVARCHAR(128)

	SET @DMLAction = 'INSERT';
	SET @DMLDate = GETDATE();
	SET @TableName = 'Targets';

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'ShortName' AS FieldName
		,NULL
		,dvi.ShortName
	FROM Inserted dvi

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'Name' AS FieldName
		,NULL
		,dvi.Name
	FROM Inserted dvi

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'Descr' AS FieldName
		,NULL
		,CAST(LEFT(dvi.Descr,8000) AS VARCHAR(8000))
	FROM Inserted dvi

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'ValidationID' AS FieldName
		,NULL
		,dvi.ValidationID
	FROM Inserted dvi

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'TargetCatalog' AS FieldName
		,NULL
		,dvi.TargetCatalog
	FROM Inserted dvi

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'TargetSchema' AS FieldName
		,NULL
		,dvi.TargetSchema
	FROM Inserted dvi

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'TargetTable' AS FieldName
		,NULL
		,dvi.TargetTable
	FROM Inserted dvi

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'DetailColumn' AS FieldName
		,NULL
		,dvi.DetailColumn
	FROM Inserted dvi

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'TableNameNeedsBatchSuffix' AS FieldName
		,NULL
		,dvi.TableNameNeedsBatchSuffix
	FROM Inserted dvi

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'IsActive' AS FieldName
		,NULL
		,dvi.IsActive
	FROM Inserted dvi

END
GO

ALTER TABLE [dv].[Targets] ENABLE TRIGGER [tI_Targets]
GO

CREATE TRIGGER [dv].[tU_Targets] ON [dv].[Targets]
	FOR UPDATE
AS
BEGIN
    SET NOCOUNT ON

	DECLARE @DMLAction AS NVARCHAR(25)
	DECLARE @DMLDate AS DATETIME
	DECLARE @TableName AS NVARCHAR(128)

	SET @DMLAction = 'UPDATE';
	SET @DMLDate = GETDATE();
	SET @TableName = 'Targets';

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'ShortName' AS FieldName
		,dvd.ShortName
		,dvi.ShortName
	FROM Inserted dvi INNER JOIN Deleted dvd ON dvi.ID = dvd.ID	WHERE
		dvi.ShortName != dvd.ShortName

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'Name' AS FieldName
		,dvd.Name
		,dvi.Name
	FROM Inserted dvi INNER JOIN Deleted dvd ON dvi.ID = dvd.ID	WHERE
		dvi.Name != dvd.Name

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'Descr' AS FieldName
		,CAST(LEFT(dvd.Descr,8000) AS VARCHAR(8000))
		,CAST(LEFT(dvi.Descr,8000) AS VARCHAR(8000))
	FROM Inserted dvi INNER JOIN Deleted dvd ON dvi.ID = dvd.ID	WHERE
		dvi.Descr != dvd.Descr

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'ValidationID' AS FieldName
		,dvd.ValidationID
		,dvi.ValidationID
	FROM Inserted dvi INNER JOIN Deleted dvd ON dvi.ID = dvd.ID	WHERE
		dvi.ValidationID != dvd.ValidationID

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'TargetCatalog' AS FieldName
		,dvd.TargetCatalog
		,dvi.TargetCatalog
	FROM Inserted dvi INNER JOIN Deleted dvd ON dvi.ID = dvd.ID	WHERE
		dvi.TargetCatalog != dvd.TargetCatalog

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'TargetSchema' AS FieldName
		,dvd.TargetSchema
		,dvi.TargetSchema
	FROM Inserted dvi INNER JOIN Deleted dvd ON dvi.ID = dvd.ID	WHERE
		dvi.TargetSchema != dvd.TargetSchema

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'TargetTable' AS FieldName
		,dvd.TargetTable
		,dvi.TargetTable
	FROM Inserted dvi INNER JOIN Deleted dvd ON dvi.ID = dvd.ID	WHERE
		dvi.TargetTable != dvd.TargetTable

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'DetailColumn' AS FieldName
		,dvd.DetailColumn
		,dvi.DetailColumn
	FROM Inserted dvi INNER JOIN Deleted dvd ON dvi.ID = dvd.ID	WHERE
		dvi.DetailColumn != dvd.DetailColumn

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'TableNameNeedsBatchSuffix' AS FieldName
		,dvd.TableNameNeedsBatchSuffix
		,dvi.TableNameNeedsBatchSuffix
	FROM Inserted dvi INNER JOIN Deleted dvd ON dvi.ID = dvd.ID	WHERE
		dvi.TableNameNeedsBatchSuffix != dvd.TableNameNeedsBatchSuffix

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'IsActive' AS FieldName
		,dvd.IsActive
		,dvi.IsActive
	FROM Inserted dvi INNER JOIN Deleted dvd ON dvi.ID = dvd.ID	WHERE
		dvi.IsActive != dvd.IsActive

END
GO

ALTER TABLE [dv].[Targets] ENABLE TRIGGER [tU_Targets]
GO



/****** Object:  Table [dv].[TempTables]    Script Date: 11/7/2017 8:17:53 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dv].[TempTables](
	[ID] [INT] IDENTITY(1,1) NOT NULL,
	[LevelID] [INT] NOT NULL,
	[LinkID] [BIGINT] NOT NULL,
	[TempTableName] [NVARCHAR](128) NOT NULL,
	[CreateSQLCode] [NVARCHAR](MAX) NOT NULL,
	[InsertSQLCode] [NVARCHAR](MAX) NOT NULL,
	[CreateDate] [DATETIME] NULL,
	[UpdateDate] [DATETIME] NULL,
	[IsActive] [TINYINT] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dv].[TempTables] ADD  DEFAULT (GETDATE()) FOR [CreateDate]
GO

ALTER TABLE [dv].[TempTables] ADD  DEFAULT (GETDATE()) FOR [UpdateDate]
GO

ALTER TABLE [dv].[TempTables] ADD  DEFAULT ((1)) FOR [IsActive]
GO

CREATE TRIGGER [dv].[tD_TempTables] ON [dv].[TempTables]
	INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON

	UPDATE dv.TempTables
	SET IsActive = 0
	WHERE ID IN ( SELECT ID FROM Deleted )

	RAISERROR( 'Record was flagged to IsActive = 0 instead of being deleted.', 0, 1 )

END


GO

ALTER TABLE [dv].[TempTables] ENABLE TRIGGER [tD_TempTables]
GO

CREATE TRIGGER [dv].[tI_TempTables] ON [dv].[TempTables]
	FOR INSERT
AS
BEGIN
    SET NOCOUNT ON

	DECLARE @DMLAction AS NVARCHAR(25)
	DECLARE @DMLDate AS DATETIME
	DECLARE @TableName AS NVARCHAR(128)

	SET @DMLAction = 'INSERT';
	SET @DMLDate = GETDATE();
	SET @TableName = 'TempTables';

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'LevelID' AS FieldName
		,NULL
		,dvi.LevelID
	FROM Inserted dvi

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'LinkID' AS FieldName
		,NULL
		,dvi.LinkID
	FROM Inserted dvi

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'TempTableName' AS FieldName
		,NULL
		,dvi.TempTableName
	FROM Inserted dvi

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'CreateSQLCode' AS FieldName
		,NULL
		,CAST(LEFT(dvi.CreateSQLCode,8000) AS VARCHAR(8000))
	FROM Inserted dvi

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'InsertSQLCode' AS FieldName
		,NULL
		,CAST(LEFT(dvi.InsertSQLCode,8000) AS VARCHAR(8000))
	FROM Inserted dvi

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'InsertSQLCode_Contd' AS FieldName
		,NULL
		,CAST(SUBSTRING(dvi.InsertSQLCode,8001,16000) AS VARCHAR(8000))
	FROM Inserted dvi WHERE LEN(dvi.InsertSQLCode) > 8000

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'IsActive' AS FieldName
		,NULL
		,dvi.IsActive
	FROM Inserted dvi

END


GO

ALTER TABLE [dv].[TempTables] ENABLE TRIGGER [tI_TempTables]
GO

CREATE TRIGGER [dv].[tU_TempTables] ON [dv].[TempTables]
	FOR UPDATE
AS
BEGIN
    SET NOCOUNT ON

	DECLARE @DMLAction AS NVARCHAR(25)
	DECLARE @DMLDate AS DATETIME
	DECLARE @TableName AS NVARCHAR(128)

	SET @DMLAction = 'UPDATE';
	SET @DMLDate = GETDATE();
	SET @TableName = 'TempTables';

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'LevelID' AS FieldName
		,dvd.LevelID
		,dvi.LevelID
	FROM Inserted dvi INNER JOIN Deleted dvd ON dvi.ID = dvd.ID	WHERE
		dvi.LevelID != dvd.LevelID

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'LinkID' AS FieldName
		,dvd.LinkID
		,dvi.LinkID
	FROM Inserted dvi INNER JOIN Deleted dvd ON dvi.ID = dvd.ID	WHERE
		dvi.LinkID != dvd.LinkID

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'TempTableName' AS FieldName
		,dvd.TempTableName
		,dvi.TempTableName
	FROM Inserted dvi INNER JOIN Deleted dvd ON dvi.ID = dvd.ID	WHERE
		dvi.TempTableName != dvd.TempTableName

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'CreateSQLCode' AS FieldName
		,CAST(LEFT(dvd.CreateSQLCode,8000) AS VARCHAR(8000))
		,CAST(LEFT(dvi.CreateSQLCode,8000) AS VARCHAR(8000))
	FROM Inserted dvi INNER JOIN Deleted dvd ON dvi.ID = dvd.ID	WHERE
		dvi.CreateSQLCode != dvd.CreateSQLCode

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'InsertSQLCode' AS FieldName
		,CAST(LEFT(dvd.InsertSQLCode,8000) AS VARCHAR(8000))
		,CAST(LEFT(dvi.InsertSQLCode,8000) AS VARCHAR(8000))
	FROM Inserted dvi INNER JOIN Deleted dvd ON dvi.ID = dvd.ID	WHERE
		dvi.InsertSQLCode != dvd.InsertSQLCode

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'InsertSQLCode_Contd' AS FieldName
		,CAST(SUBSTRING(dvd.InsertSQLCode,8001,16000) AS VARCHAR(8000))
		,CAST(SUBSTRING(dvi.InsertSQLCode,8001,16000) AS VARCHAR(8000))
	FROM Inserted dvi INNER JOIN Deleted dvd ON dvi.ID = dvd.ID	WHERE
		dvi.InsertSQLCode != dvd.InsertSQLCode
		AND ( LEN(dvi.InsertSQLCode) > 8000 OR LEN(dvd.InsertSQLCode) > 8000 )

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'IsActive' AS FieldName
		,dvd.IsActive
		,dvi.IsActive
	FROM Inserted dvi INNER JOIN Deleted dvd ON dvi.ID = dvd.ID	WHERE
		dvi.IsActive != dvd.IsActive

END
GO

ALTER TABLE [dv].[TempTables] ENABLE TRIGGER [tU_TempTables]
GO

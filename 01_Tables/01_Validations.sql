/****** Object:  Table [dv].[Validations]    Script Date: 11/6/2017 11:42:12 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dv].[Validations](
	[ID] [BIGINT] IDENTITY(1,1) NOT NULL,
	[ShortName] [nvarchar](50) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Descr] [nvarchar](max) NOT NULL,
	[CreateDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
	[IsActive] [tinyint] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dv].[Validations] ADD  DEFAULT (getdate()) FOR [CreateDate]
GO

ALTER TABLE [dv].[Validations] ADD  DEFAULT (getdate()) FOR [UpdateDate]
GO

ALTER TABLE [dv].[Validations] ADD  DEFAULT ((1)) FOR [IsActive]
GO

CREATE TRIGGER [dv].[tD_Validations] ON [dv].[Validations]
	INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON

	UPDATE dv.Validations
	SET IsActive = 0
	WHERE ID IN ( SELECT ID FROM Deleted )

	RAISERROR( 'Record was flagged to IsActive = 0 instead of being deleted.', 0, 1 )

END


GO

ALTER TABLE [dv].[Validations] ENABLE TRIGGER [tD_Validations]
GO

CREATE TRIGGER [dv].[tI_Validations] ON [dv].[Validations]
	FOR INSERT
AS
BEGIN
    SET NOCOUNT ON

	DECLARE @DMLAction AS NVARCHAR(25)
	DECLARE @DMLDate AS DATETIME
	DECLARE @TableName AS NVARCHAR(128)

	SET @DMLAction = 'INSERT';
	SET @DMLDate = GETDATE();
	SET @TableName = 'Validations';

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
		,'IsActive' AS FieldName
		,NULL
		,dvi.IsActive
	FROM Inserted dvi

END


GO

ALTER TABLE [dv].[Validations] ENABLE TRIGGER [tI_Validations]
GO

CREATE TRIGGER [dv].[tU_Validations] ON [dv].[Validations]
	FOR UPDATE
AS
BEGIN
    SET NOCOUNT ON

	DECLARE @DMLAction AS NVARCHAR(25)
	DECLARE @DMLDate AS DATETIME
	DECLARE @TableName AS NVARCHAR(128)

	SET @DMLAction = 'UPDATE';
	SET @DMLDate = GETDATE();
	SET @TableName = 'Validations';

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
		,'IsActive' AS FieldName
		,dvd.IsActive
		,dvi.IsActive
	FROM Inserted dvi INNER JOIN Deleted dvd ON dvi.ID = dvd.ID	WHERE
		dvi.IsActive != dvd.IsActive

END


GO

ALTER TABLE [dv].[Validations] ENABLE TRIGGER [tU_Validations]
GO


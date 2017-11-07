/****** Object:  Table [dv].[QualityAssessmentCodes]    Script Date: 11/7/2017 7:01:48 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dv].[QualityAssessmentCodes](
	[ID] [INT] IDENTITY(1,1) NOT NULL,
	[ShortName] [NVARCHAR](50) NOT NULL,
	[Name] [NVARCHAR](255) NULL,
	[Descr] [NVARCHAR](MAX) NULL,
	[CreateDate] [DATETIME] NULL,
	[UpdateDate] [DATETIME] NULL,
	[IsActive] [TINYINT] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dv].[QualityAssessmentCodes] ADD  DEFAULT (GETDATE()) FOR [CreateDate]
GO

ALTER TABLE [dv].[QualityAssessmentCodes] ADD  DEFAULT (GETDATE()) FOR [UpdateDate]
GO

ALTER TABLE [dv].[QualityAssessmentCodes] ADD  DEFAULT ((1)) FOR [IsActive]
GO

CREATE TRIGGER [dv].[tD_QualityAssessmentCodes] ON [dv].[QualityAssessmentCodes]
	INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON

	UPDATE dv.QualityAssessmentCodes
	SET IsActive = 0
	WHERE ID IN ( SELECT ID FROM Deleted )

	RAISERROR( 'Record was flagged to IsActive = 0 instead of being deleted.', 0, 1 )

END


GO

ALTER TABLE [dv].[QualityAssessmentCodes] ENABLE TRIGGER [tD_QualityAssessmentCodes]
GO

CREATE TRIGGER [dv].[tI_QualityAssessmentCodes] ON [dv].[QualityAssessmentCodes]
	FOR INSERT
AS
BEGIN
    SET NOCOUNT ON

	DECLARE @DMLAction AS NVARCHAR(25)
	DECLARE @DMLDate AS DATETIME
	DECLARE @TableName AS NVARCHAR(128)

	SET @DMLAction = 'INSERT';
	SET @DMLDate = GETDATE();
	SET @TableName = 'QualityAssessmentCodes';

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

ALTER TABLE [dv].[QualityAssessmentCodes] ENABLE TRIGGER [tI_QualityAssessmentCodes]
GO

CREATE TRIGGER [dv].[tU_QualityAssessmentCodes] ON [dv].[QualityAssessmentCodes]
	FOR UPDATE
AS
BEGIN
    SET NOCOUNT ON

	DECLARE @DMLAction AS NVARCHAR(25)
	DECLARE @DMLDate AS DATETIME
	DECLARE @TableName AS NVARCHAR(128)

	SET @DMLAction = 'UPDATE';
	SET @DMLDate = GETDATE();
	SET @TableName = 'QualityAssessmentCodes';

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

ALTER TABLE [dv].[QualityAssessmentCodes] ENABLE TRIGGER [tU_QualityAssessmentCodes]
GO

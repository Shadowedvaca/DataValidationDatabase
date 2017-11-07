/****** Object:  Table [dv].[BusinessRuleGroups]    Script Date: 11/7/2017 6:56:26 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dv].[BusinessRuleGroups](
	[ID] [BIGINT] IDENTITY(1,1) NOT NULL,
	[TargetID] [BIGINT] NOT NULL,
	[ShortName] [NVARCHAR](50) NOT NULL,
	[Name] [NVARCHAR](255) NULL,
	[Descr] [NVARCHAR](MAX) NULL,
	[SubjectTypeID] [INT] NULL,
	[TargetColumn] [NVARCHAR](128) NULL,
	[SystemImpact] [NVARCHAR](MAX) NULL,
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

ALTER TABLE [dv].[BusinessRuleGroups] ADD  DEFAULT (GETDATE()) FOR [CreateDate]
GO

ALTER TABLE [dv].[BusinessRuleGroups] ADD  DEFAULT (GETDATE()) FOR [UpdateDate]
GO

ALTER TABLE [dv].[BusinessRuleGroups] ADD  DEFAULT ((1)) FOR [IsActive]
GO

CREATE TRIGGER [dv].[tD_BusinessRuleGroups] ON [dv].[BusinessRuleGroups]
	INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON

	UPDATE dv.BusinessRuleGroups
	SET IsActive = 0
	WHERE ID IN ( SELECT ID FROM Deleted )

	RAISERROR( 'Record was flagged to IsActive = 0 instead of being deleted.', 0, 1 )

END
GO

ALTER TABLE [dv].[BusinessRuleGroups] ENABLE TRIGGER [tD_BusinessRuleGroups]
GO

CREATE TRIGGER [dv].[tI_BusinessRuleGroups] ON [dv].[BusinessRuleGroups]
	FOR INSERT
AS
BEGIN
    SET NOCOUNT ON

	DECLARE @DMLAction AS NVARCHAR(25)
	DECLARE @DMLDate AS DATETIME
	DECLARE @TableName AS NVARCHAR(128)

	SET @DMLAction = 'INSERT';
	SET @DMLDate = GETDATE();
	SET @TableName = 'BusinessRuleGroups';

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'TargetID' AS FieldName
		,NULL
		,dvi.TargetID
	FROM Inserted dvi

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
		,'SubjectTypeID' AS FieldName
		,NULL
		,dvi.SubjectTypeID
	FROM Inserted dvi

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'TargetColumn' AS FieldName
		,NULL
		,dvi.TargetColumn
	FROM Inserted dvi

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'SystemImpact' AS FieldName
		,NULL
		,CAST(LEFT(dvi.SystemImpact,8000) AS VARCHAR(8000))
	FROM Inserted dvi

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'IsActive' AS FieldName
		,NULL
		,dvi.IsActive
	FROM Inserted dvi

END


GO

ALTER TABLE [dv].[BusinessRuleGroups] ENABLE TRIGGER [tI_BusinessRuleGroups]
GO

CREATE TRIGGER [dv].[tU_BusinessRuleGroups] ON [dv].[BusinessRuleGroups]
	FOR UPDATE
AS
BEGIN
    SET NOCOUNT ON

	DECLARE @DMLAction AS NVARCHAR(25)
	DECLARE @DMLDate AS DATETIME
	DECLARE @TableName AS NVARCHAR(128)

	SET @DMLAction = 'UPDATE';
	SET @DMLDate = GETDATE();
	SET @TableName = 'BusinessRuleGroups';

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'TargetID' AS FieldName
		,dvd.TargetID
		,dvi.TargetID
	FROM Inserted dvi INNER JOIN Deleted dvd ON dvi.ID = dvd.ID	WHERE
		dvi.TargetID != dvd.TargetID

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
		,'SubjectTypeID' AS FieldName
		,dvd.SubjectTypeID
		,dvi.SubjectTypeID
	FROM Inserted dvi INNER JOIN Deleted dvd ON dvi.ID = dvd.ID	WHERE
		dvi.SubjectTypeID != dvd.SubjectTypeID

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'TargetColumn' AS FieldName
		,dvd.TargetColumn
		,dvi.TargetColumn
	FROM Inserted dvi INNER JOIN Deleted dvd ON dvi.ID = dvd.ID	WHERE
		dvi.TargetColumn != dvd.TargetColumn

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'SystemImpact' AS FieldName
		,CAST(LEFT(dvd.SystemImpact,8000) AS VARCHAR(8000))
		,CAST(LEFT(dvi.SystemImpact,8000) AS VARCHAR(8000))
	FROM Inserted dvi INNER JOIN Deleted dvd ON dvi.ID = dvd.ID	WHERE
		dvi.SystemImpact != dvd.SystemImpact

	INSERT INTO dv.RuleChangeLog ( DMLAction, DMLDate, TableName, RowID, FieldName, OldValue, NewValue ) SELECT @DMLAction, @DMLDate, @TableName, dvi.ID
		,'IsActive' AS FieldName
		,dvd.IsActive
		,dvi.IsActive
	FROM Inserted dvi INNER JOIN Deleted dvd ON dvi.ID = dvd.ID	WHERE
		dvi.IsActive != dvd.IsActive

END


GO

ALTER TABLE [dv].[BusinessRuleGroups] ENABLE TRIGGER [tU_BusinessRuleGroups]
GO

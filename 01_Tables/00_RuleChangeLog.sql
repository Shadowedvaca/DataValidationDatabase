/****** Object:  Table [dv].[RuleChangeLog]    Script Date: 11/7/2017 7:02:16 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dv].[RuleChangeLog](
	[ID] [INT] IDENTITY(1,1) NOT NULL,
	[DMLAction] [NVARCHAR](25) NOT NULL,
	[DMLDate] [DATETIME] NOT NULL,
	[TableName] [NVARCHAR](128) NOT NULL,
	[RowID] [BIGINT] NOT NULL,
	[FieldName] [NVARCHAR](128) NOT NULL,
	[OldValue] [SQL_VARIANT] NULL,
	[NewValue] [SQL_VARIANT] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identity Column' , @level0type=N'SCHEMA',@level0name=N'dv', @level1type=N'TABLE',@level1name=N'RuleChangeLog', @level2type=N'COLUMN',@level2name=N'ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Action Triggered' , @level0type=N'SCHEMA',@level0name=N'dv', @level1type=N'TABLE',@level1name=N'RuleChangeLog', @level2type=N'COLUMN',@level2name=N'DMLAction'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Action Triggered' , @level0type=N'SCHEMA',@level0name=N'dv', @level1type=N'TABLE',@level1name=N'RuleChangeLog', @level2type=N'COLUMN',@level2name=N'DMLDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Table Impacted' , @level0type=N'SCHEMA',@level0name=N'dv', @level1type=N'TABLE',@level1name=N'RuleChangeLog', @level2type=N'COLUMN',@level2name=N'TableName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Row Impacted' , @level0type=N'SCHEMA',@level0name=N'dv', @level1type=N'TABLE',@level1name=N'RuleChangeLog', @level2type=N'COLUMN',@level2name=N'RowID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Field Modified' , @level0type=N'SCHEMA',@level0name=N'dv', @level1type=N'TABLE',@level1name=N'RuleChangeLog', @level2type=N'COLUMN',@level2name=N'FieldName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Old Value (NULL if new)' , @level0type=N'SCHEMA',@level0name=N'dv', @level1type=N'TABLE',@level1name=N'RuleChangeLog', @level2type=N'COLUMN',@level2name=N'OldValue'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'New Value (NULL if deleted)' , @level0type=N'SCHEMA',@level0name=N'dv', @level1type=N'TABLE',@level1name=N'RuleChangeLog', @level2type=N'COLUMN',@level2name=N'NewValue'
GO



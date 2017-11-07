/****** Object:  UserDefinedTableType [dv].[tt_ReadyRuleCheck]    Script Date: 11/7/2017 9:11:25 AM ******/
CREATE TYPE [dv].[tt_ReadyRuleCheck] AS TABLE(
	[TargetID] [BIGINT] NOT NULL,
	[BusinessRuleGroupID] [BIGINT] NOT NULL,
	[BusinessRuleID] [BIGINT] NOT NULL,
	[RuleCheckID] [BIGINT] NOT NULL,
	[LevelID] [INT] NOT NULL,
	[TargetCatalog] [NVARCHAR](128) NOT NULL,
	[TargetSchema] [NVARCHAR](128) NOT NULL,
	[TargetTable] [NVARCHAR](128) NOT NULL,
	[DetailColumn] [NVARCHAR](128) NOT NULL,
	[SQLCode] [NVARCHAR](MAX) NOT NULL,
	[ResultTypeID] [INT] NOT NULL,
	[ExcludeFromTotals] [TINYINT] NOT NULL,
	[QualityAssessmentCodeID] [INT] NOT NULL
)
GO



/****** Object:  StoredProcedure [dv].[usp_ResetDevEnvironment]    Script Date: 11/7/2017 9:27:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dv].[usp_ResetDevEnvironment] AS
BEGIN
	
	SET NOCOUNT ON

	-- Targets
	TRUNCATE TABLE [DevDB].dv.Targets;
	
	SET IDENTITY_INSERT [DevDB].dv.Targets ON

	INSERT INTO	[DevDB].dv.Targets (
		ID ,
        ShortName ,
        Name ,
        Descr ,
        ValidationID ,
        TargetCatalog ,
        TargetSchema ,
        TargetTable ,
        DetailColumn ,
        TableNameNeedsBatchSuffix ,
        CreateDate ,
        UpdateDate ,
        LastRun ,
        IsActive
	)
	SELECT
		*
	FROM
		[ProdDB].dv.Targets;

	SET IDENTITY_INSERT [DevDB].dv.Targets OFF

	-- BusinessRuleGroups
	TRUNCATE TABLE [DevDB].dv.BusinessRuleGroups
	
	SET IDENTITY_INSERT [DevDB].dv.BusinessRuleGroups ON

	INSERT INTO [DevDB].dv.BusinessRuleGroups (
		ID ,
        TargetID ,
        ShortName ,
        Name ,
        Descr ,
        SubjectTypeID ,
        TargetColumn ,
        SystemImpact ,
        CreateDate ,
        UpdateDate ,
        LastRun ,
        IsActive
	)
	SELECT
		*
	FROM
		[ProdDB].dv.BusinessRuleGroups

	SET IDENTITY_INSERT [DevDB].dv.BusinessRuleGroups OFF

	-- BusinessRules
	TRUNCATE TABLE [DevDB].dv.BusinessRules
	
	SET IDENTITY_INSERT [DevDB].dv.BusinessRules ON

	INSERT INTO [DevDB].dv.BusinessRules (
		ID ,
        BusinessRuleGroupID ,
        ShortName ,
        Name ,
        Descr ,
        CreateDate ,
        UpdateDate ,
        LastRun ,
        IsActive
	)
	SELECT
		*
	FROM
		[ProdDB].dv.BusinessRules

	SET IDENTITY_INSERT [DevDB].dv.BusinessRules OFF

	-- RuleChecks
	TRUNCATE TABLE [DevDB].dv.RuleChecks
	
	SET IDENTITY_INSERT [DevDB].dv.RuleChecks ON

	INSERT INTO [DevDB].dv.RuleChecks (
		ID ,
        BusinessRuleID ,
        ResultTypeID ,
        ExcludeFromTotals ,
        QualityAssessmentCodeID ,
        ShortName ,
        Name ,
        Descr ,
        SQLCode ,
        CreateDate ,
        UpdateDate ,
        LastRun ,
        IsActive
	)
	SELECT
		ID ,
        BusinessRuleID ,
        ResultTypeID ,
        ExcludeFromTotals ,
        QualityAssessmentCodeID ,
        ShortName ,
        Name ,
        Descr ,
        SQLCode ,
        CreateDate ,
        UpdateDate ,
        LastRun ,
        IsActive
	FROM
		[ProdDB].dv.RuleChecks

	SET IDENTITY_INSERT [DevDB].dv.RuleChecks OFF

	-- Dependencies
	TRUNCATE TABLE [DevDB].dv.Dependencies

	INSERT INTO [DevDB].dv.Dependencies (
		ID ,
        LevelID ,
        DependsOnID ,
        DependsOnLevelID ,
        IsActive
	)
	SELECT
		*
	FROM
		[ProdDB].dv.Dependencies

	-- TempTables
	TRUNCATE TABLE [DevDB].dv.TempTables
	
	SET IDENTITY_INSERT [DevDB].dv.TempTables ON

	INSERT INTO [DevDB].dv.TempTables (
		ID ,
        LevelID ,
        LinkID ,
        TempTableName ,
        CreateSQLCode ,
        InsertSQLCode ,
        CreateDate ,
        UpdateDate ,
        IsActive
	)
	SELECT
		*
	FROM
		[ProdDB].dv.TempTables

	SET IDENTITY_INSERT [DevDB].dv.TempTables OFF

	-- Validations
	TRUNCATE TABLE [DevDB].dv.Validations
	
	SET IDENTITY_INSERT [DevDB].dv.Validations ON

	INSERT INTO [DevDB].dv.Validations (
		ID ,
        ShortName ,
        Name ,
        Descr ,
        CreateDate ,
        UpdateDate ,
        IsActive
	)
	SELECT
		*
	FROM
		[ProdDB].dv.Validations

	SET IDENTITY_INSERT [DevDB].dv.Validations OFF

	-- SubjectTypes
	TRUNCATE TABLE [DevDB].dv.SubjectTypes
	
	SET IDENTITY_INSERT [DevDB].dv.SubjectTypes ON

	INSERT INTO [DevDB].dv.SubjectTypes (
		ID ,
        ShortName ,
        Name ,
        Descr ,
        CreateDate ,
        UpdateDate ,
        IsActive
	)
	SELECT
		*
	FROM
		[ProdDB].dv.SubjectTypes

	SET IDENTITY_INSERT [DevDB].dv.SubjectTypes OFF

	-- ResultTypes
	TRUNCATE TABLE [DevDB].dv.ResultTypes
	
	SET IDENTITY_INSERT [DevDB].dv.ResultTypes ON

	INSERT INTO [DevDB].dv.ResultTypes (
		ID ,
        ShortName ,
        Name ,
        Descr ,
        OverallFlag ,
        TotalFlag ,
        PassFlag ,
        FailFlag ,
        IgnoreFlag ,
        StopRecordFlowFlag ,
        CreateDate ,
        UpdateDate ,
        IsActive
	)
	SELECT
		*
	FROM
		[ProdDB].dv.ResultTypes

	SET IDENTITY_INSERT [DevDB].dv.ResultTypes OFF

	-- Levels
	TRUNCATE TABLE [DevDB].dv.Levels
	
	SET IDENTITY_INSERT [DevDB].dv.Levels ON

	INSERT INTO [DevDB].dv.Levels (
		ID ,
        ShortName ,
        Name ,
        Descr ,
        CreateDate ,
        UpdateDate ,
        IsActive
	)
	SELECT
		*
	FROM
		[ProdDB].dv.Levels

	SET IDENTITY_INSERT [DevDB].dv.Levels OFF

	-- ValidationSets

	TRUNCATE TABLE [DevDB].dv.ValidationSets

	-- ValidationRuns

	TRUNCATE TABLE [DevDB].dv.ValidationRuns

	-- ValidationRunLogs

	TRUNCATE TABLE [DevDB].dv.ValidationRunLog
	
	-- RuleCheckLastRunResults

	TRUNCATE TABLE [DevDB].dv.RuleCheckLastRunResults
	
	-- RuleCheckResults

	TRUNCATE TABLE [DevDB].dv.RuleCheckResults

	RETURN @@ERROR

END





GO



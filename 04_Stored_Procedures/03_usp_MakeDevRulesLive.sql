/****** Object:  StoredProcedure [dv].[usp_MakeDevRulesLive]    Script Date: 11/7/2017 9:21:32 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dv].[usp_MakeDevRulesLive] AS
BEGIN
	
	SET NOCOUNT ON
	DECLARE @DateStamp AS DATETIME

	SET @DateStamp = GETDATE()

	--Targets
	SET IDENTITY_INSERT [ProdDB].dv.Targets ON

	MERGE [ProdDB].dv.Targets AS T
	USING ( SELECT * FROM [DevDB].dv.Targets WHERE IsActive = 1 ) AS S
	ON ( T.ID = S.ID )
	WHEN NOT MATCHED BY TARGET THEN
		INSERT ( ID, ShortName, Name, Descr, ValidationID, TargetCatalog, TargetSchema, TargetTable, DetailColumn, TableNameNeedsBatchSuffix, IsActive ) VALUES ( S.ID, S.ShortName, S.Name, S.Descr, S.ValidationID, S.TargetCatalog, S.TargetSchema, S.TargetTable, S.DetailColumn, S.TableNameNeedsBatchSuffix, S.IsActive )
	WHEN MATCHED AND ( T.ShortName != S.ShortName OR T.Name != S.Name OR T.Descr != S.Descr OR T.ValidationID != s.ValidationID OR T.TargetCatalog != S.TargetCatalog OR T.TargetSchema != S.TargetSchema OR T.TargetTable != S.TargetTable OR T.DetailColumn != S.DetailColumn OR ISNULL(T.TableNameNeedsBatchSuffix,0) != ISNULL(S.TableNameNeedsBatchSuffix,0) OR ISNULL(T.IsActive,0) != ISNULL(S.IsActive,0) ) THEN
		UPDATE SET T.ShortName = S.ShortName, T.Name = S.Name, T.Descr = S.Descr, T.ValidationID = S.ValidationID, T.TargetCatalog = S.TargetCatalog, T.TargetSchema = S.TargetSchema, T.TargetTable = S.TargetTable, T.DetailColumn = S.DetailColumn, T.TableNameNeedsBatchSuffix = S.TableNameNeedsBatchSuffix, T.IsActive = S.IsActive, T.UpdateDate = @DateStamp
	WHEN NOT MATCHED BY SOURCE AND T.IsActive = 1 THEN
		UPDATE SET T.IsActive = 0;

	SET IDENTITY_INSERT [ProdDB].dv.Targets OFF

	-- BusinessRuleGroups
	SET IDENTITY_INSERT [ProdDB].dv.BusinessRuleGroups ON

	MERGE [ProdDB].dv.BusinessRuleGroups AS T
	USING ( SELECT * FROM [DevDB].dv.BusinessRuleGroups WHERE IsActive = 1 ) AS S
	ON ( T.ID = S.ID )
	WHEN NOT MATCHED BY TARGET THEN
		INSERT ( ID, TargetID, ShortName, Name, Descr, SystemImpact, SubjectTypeID, TargetColumn, IsActive ) VALUES ( S.ID, S.TargetID, S.ShortName, S.Name, S.Descr, S.SystemImpact, S.SubjectTypeID, S.TargetColumn, S.IsActive )
	WHEN MATCHED AND ( T.TargetID != S.TargetID OR T.ShortName != S.ShortName OR ISNULL(T.Name,'') != ISNULL(S.Name,'') OR ISNULL(T.Descr,'') != ISNULL(S.Descr,'') OR ISNULL(T.SystemImpact,'') != ISNULL(S.SystemImpact,'') OR ISNULL(T.SubjectTypeID,0) != ISNULL(S.SubjectTypeID,0) OR ISNULL(T.TargetColumn,'') != ISNULL(S.TargetColumn,'') OR ISNULL(T.IsActive,0) != ISNULL(S.IsActive,0) ) THEN
		UPDATE SET T.TargetID = S.TargetID, T.ShortName = S.ShortName, T.Name = S.Name, T.Descr = S.Descr, T.SystemImpact = S.SystemImpact, T.SubjectTypeID = S.SubjectTypeID, T.TargetColumn = S.TargetColumn, T.IsActive = S.IsActive, T.UpdateDate = @DateStamp
	WHEN NOT MATCHED BY SOURCE AND T.IsActive = 1 THEN
		UPDATE SET T.IsActive = 0;

	SET IDENTITY_INSERT [ProdDB].dv.BusinessRuleGroups OFF

	-- BusinessRules
	SET IDENTITY_INSERT [ProdDB].dv.BusinessRules ON

	MERGE [ProdDB].dv.BusinessRules AS T
	USING ( SELECT * FROM [DevDB].dv.BusinessRules WHERE IsActive = 1 ) AS S
	ON ( T.ID = S.ID )
	WHEN NOT MATCHED BY TARGET THEN
		INSERT ( ID, BusinessRuleGroupID, ShortName, Name, Descr, IsActive ) VALUES ( S.ID, S.BusinessRuleGroupID, S.ShortName, S.Name, S.Descr, S.IsActive )
	WHEN MATCHED AND ( T.BusinessRuleGroupID != S.BusinessRuleGroupID OR T.ShortName != S.ShortName OR ISNULL(T.Name,'') != ISNULL(S.Name,'') OR ISNULL(T.Descr,'') != ISNULL(S.Descr,'') OR ISNULL(T.IsActive,0) != ISNULL(S.IsActive,0) ) THEN
		UPDATE SET T.BusinessRuleGroupID = S.BusinessRuleGroupID, T.ShortName = S.ShortName, T.Name = S.Name, T.Descr = S.Descr, T.IsActive = S.IsActive, T.UpdateDate = @DateStamp
	WHEN NOT MATCHED BY SOURCE AND T.IsActive = 1 THEN
		UPDATE SET T.IsActive = 0;

	SET IDENTITY_INSERT [ProdDB].dv.BusinessRules OFF

	-- Rule Checks
	SET IDENTITY_INSERT [ProdDB].dv.RuleChecks ON

	MERGE [ProdDB].dv.RuleChecks AS T
	USING ( SELECT * FROM [DevDB].dv.RuleChecks WHERE IsActive = 1 ) AS S
	ON ( T.ID = S.ID )
	WHEN NOT MATCHED BY TARGET THEN
		INSERT ( ID, BusinessRuleID, ShortName, Name, Descr, ResultTypeID, ExcludeFromTotals, QualityAssessmentCodeID, SQLCode, IsActive ) VALUES ( S.ID, S.BusinessRuleID, S.ShortName, S.Name, S.Descr, S.ResultTypeID, S.ExcludeFromTotals, S.QualityAssessmentCodeID, S.SQLCode, S.IsActive )
	WHEN MATCHED AND ( T.BusinessRuleID != S.BusinessRuleID OR T.ShortName != S.ShortName OR ISNULL(T.Name,'') != ISNULL(S.Name,'') OR ISNULL(T.Descr,'') != ISNULL(S.Descr,'') OR T.ResultTypeID != S.ResultTypeID OR ISNULL(T.ExcludeFromTotals,0) != ISNULL(S.ExcludeFromTotals,0) OR T.QualityAssessmentCodeID != S.QualityAssessmentCodeID OR T.SQLCode != S.SQLCode OR ISNULL(T.IsActive,0) != ISNULL(S.IsActive,0) ) THEN
		UPDATE SET T.BusinessRuleID = S.BusinessRuleID, T.ShortName = S.ShortName, T.Name = S.Name, T.Descr = S.Descr, T.ResultTypeID = S.ResultTypeID, T.ExcludeFromTotals = S.ExcludeFromTotals, T.QualityAssessmentCodeID = S.QualityAssessmentCodeID, T.SQLCode = S.SQLCode, T.IsActive = S.IsActive, T.UpdateDate = @DateStamp
	WHEN NOT MATCHED BY SOURCE AND T.IsActive = 1 THEN
		UPDATE SET T.IsActive = 0;

	SET IDENTITY_INSERT [ProdDB].dv.RuleChecks OFF

	-- Dependencies
	MERGE [ProdDB].dv.Dependencies AS T
	USING ( SELECT * FROM [DevDB].dv.Dependencies WHERE IsActive = 1 ) AS S
	ON ( T.ID = S.ID AND T.LevelID = S.LevelID AND T.DependsOnID = S.DependsOnID AND T.DependsOnLevelID = S.DependsOnLevelID )
	WHEN NOT MATCHED BY TARGET THEN
		INSERT ( ID, LevelID, DependsOnID, DependsOnLevelID, IsActive ) VALUES ( S.ID, S.LevelID, S.DependsOnID, S.DependsOnLevelID, S.IsActive )
	WHEN MATCHED AND ISNULL(T.IsActive,0) != ISNULL(S.IsActive,0) THEN
		UPDATE SET T.IsActive = S.IsActive
	WHEN NOT MATCHED BY SOURCE AND T.IsActive = 1 THEN
		UPDATE SET T.IsActive = 0;

	-- Temp Tables
	SET IDENTITY_INSERT [ProdDB].dv.TempTables ON

	MERGE [ProdDB].dv.TempTables AS T
	USING ( SELECT * FROM [DevDB].dv.TempTables WHERE IsActive = 1 ) AS S
	ON ( T.ID = S.ID )
	WHEN NOT MATCHED BY TARGET THEN
		INSERT ( ID, LevelID, LinkID, TempTableName, CreateSQLCode, INSERTSQLCode, IsActive ) VALUES ( S.ID, S.LevelID, S.LinkID, S.TempTableName, S.CreateSQLCode, S.INSERTSQLCode, S.IsActive )
	WHEN MATCHED AND ( T.LevelID != S.LevelID OR T.LinkID != S.LinkID OR T.TempTableName != S.TempTableName OR T.CreateSQLCode != S.CreateSQLCode OR T.INSERTSQLCode != S.INSERTSQLCode OR ISNULL(T.IsActive,0) != ISNULL(S.IsActive,0) ) THEN
		UPDATE SET T.LevelID = S.LevelID, T.LinkID = S.LinkID, T.TempTableName = S.TempTableName, T.CreateSQLCode = S.CreateSQLCode, T.INSERTSQLCode = S.INSERTSQLCode, T.IsActive = S.IsActive
	WHEN NOT MATCHED BY SOURCE AND T.IsActive = 1 THEN
		UPDATE SET T.IsActive = 0;

	SET IDENTITY_INSERT [ProdDB].dv.TempTables OFF

	-- Validations
	SET IDENTITY_INSERT [ProdDB].dv.Validations ON

	MERGE [ProdDB].dv.Validations AS T
	USING ( SELECT * FROM [DevDB].dv.Validations WHERE IsActive = 1 ) AS S
	ON ( T.ID = S.ID )
	WHEN NOT MATCHED BY TARGET THEN
		INSERT ( ID, ShortName, Name, Descr, IsActive ) VALUES ( S.ID, S.ShortName, S.Name, S.Descr, S.IsActive )
	WHEN MATCHED AND ( T.ShortName != S.ShortName OR T.Name != S.Name OR T.Descr != S.Descr OR ISNULL(T.IsActive,0) != ISNULL(S.IsActive,0) ) THEN
		UPDATE SET T.ShortName = S.ShortName, T.Name = S.Name, T.Descr = S.Descr, T.IsActive = S.IsActive, T.UpdateDate = @DateStamp
	WHEN NOT MATCHED BY SOURCE AND T.IsActive = 1 THEN
		UPDATE SET T.IsActive = 0;

	SET IDENTITY_INSERT [ProdDB].dv.Validations OFF

	-- SubjectTypes
	SET IDENTITY_INSERT [ProdDB].dv.SubjectTypes ON

	MERGE [ProdDB].dv.SubjectTypes AS T
	USING ( SELECT * FROM [DevDB].dv.SubjectTypes WHERE IsActive = 1 ) AS S
	ON ( T.ID = S.ID )
	WHEN NOT MATCHED BY TARGET THEN
		INSERT ( ID, ShortName, Name, Descr, IsActive ) VALUES ( S.ID, S.ShortName, S.Name, S.Descr, S.IsActive )
	WHEN MATCHED AND ( T.ShortName != S.ShortName OR ISNULL(T.Name,'') != ISNULL(S.Name,'') OR ISNULL(T.Descr,'') != ISNULL(S.Descr,'') OR ISNULL(T.IsActive,0) != ISNULL(S.IsActive,0) ) THEN
		UPDATE SET T.ShortName = S.ShortName, T.Name = S.Name, T.Descr = S.Descr, T.IsActive = S.IsActive, T.UpdateDate = @DateStamp
	WHEN NOT MATCHED BY SOURCE AND T.IsActive = 1 THEN
		UPDATE SET T.IsActive = 0;

	SET IDENTITY_INSERT [ProdDB].dv.SubjectTypes OFF

	-- ResultTypes
	SET IDENTITY_INSERT [ProdDB].dv.ResultTypes ON

	MERGE [ProdDB].dv.ResultTypes AS T
	USING ( SELECT * FROM [DevDB].dv.ResultTypes WHERE IsActive = 1 ) AS S
	ON ( T.ID = S.ID )
	WHEN NOT MATCHED BY TARGET THEN
		INSERT ( ID, ShortName, Name, Descr, OverallFlag, TotalFlag, PassFlag, FailFlag, IgnoreFlag, StopRecordFlowFlag, IsActive ) VALUES ( S.ID, S.ShortName, S.Name, S.Descr, S.OverallFlag, S.TotalFlag, S.PassFlag, S.FailFlag, S.IgnoreFlag, S.StopRecordFlowFlag, S.IsActive )
	WHEN MATCHED AND ( T.ShortName != S.ShortName OR ISNULL(T.Name,'') != ISNULL(S.Name,'') OR ISNULL(T.Descr,'') != ISNULL(S.Descr,'') OR T.OverallFlag != S.OverallFlag OR T.TotalFlag != S.TotalFlag OR T.PassFlag != S.PassFlag OR T.FailFlag != S.FailFlag OR T.IgnoreFlag != S.IgnoreFlag OR T.StopRecordFlowFlag != S.StopRecordFlowFlag OR ISNULL(T.IsActive,0) != ISNULL(S.IsActive,0) ) THEN
		UPDATE SET T.ShortName = S.ShortName, T.Name = S.Name, T.Descr = S.Descr, T.IsActive = S.IsActive, T.OverallFlag = S.OverallFlag, T.TotalFlag = S.TotalFlag, T.PassFlag = S.PassFlag, T.FailFlag = S.FailFlag, T.IgnoreFlag = S.IgnoreFlag, T.StopRecordFlowFlag = S.StopRecordFlowFlag, T.UpdateDate = @DateStamp
	WHEN NOT MATCHED BY SOURCE AND T.IsActive = 1 THEN
		UPDATE SET T.IsActive = 0;

	SET IDENTITY_INSERT [ProdDB].dv.ResultTypes OFF

	-- Levels
	SET IDENTITY_INSERT [ProdDB].dv.Levels ON

	MERGE [ProdDB].dv.Levels AS T
	USING ( SELECT * FROM [DevDB].dv.Levels WHERE IsActive = 1 ) AS S
	ON ( T.ID = S.ID )
	WHEN NOT MATCHED BY TARGET THEN
		INSERT ( ID, ShortName, Name, Descr, IsActive ) VALUES ( S.ID, S.ShortName, S.Name, S.Descr, S.IsActive )
	WHEN MATCHED AND ( T.ShortName != S.ShortName OR ISNULL(T.Name,'') != ISNULL(S.Name,'') OR ISNULL(T.Descr,'') != ISNULL(S.Descr,'') OR ISNULL(T.IsActive,0) != ISNULL(S.IsActive,0) ) THEN
		UPDATE SET T.ShortName = S.ShortName, T.Name = S.Name, T.Descr = S.Descr, T.IsActive = S.IsActive, T.UpdateDate = @DateStamp
	WHEN NOT MATCHED BY SOURCE AND T.IsActive = 1 THEN
		UPDATE SET T.IsActive = 0;

	SET IDENTITY_INSERT [ProdDB].dv.Levels OFF

	-- QualityAssessmentCodes
	SET IDENTITY_INSERT [ProdDB].dv.QualityAssessmentCodes ON

	MERGE [ProdDB].dv.QualityAssessmentCodes AS T
	USING ( SELECT * FROM [DevDB].dv.QualityAssessmentCodes WHERE IsActive = 1 ) AS S
	ON ( T.ID = S.ID )
	WHEN NOT MATCHED BY TARGET THEN
		INSERT ( ID, ShortName, Name, Descr, IsActive ) VALUES ( S.ID, S.ShortName, S.Name, S.Descr, S.IsActive )
	WHEN MATCHED AND ( T.ShortName != S.ShortName OR ISNULL(T.Name,'') != ISNULL(S.Name,'') OR ISNULL(T.Descr,'') != ISNULL(S.Descr,'') OR ISNULL(T.IsActive,0) != ISNULL(S.IsActive,0) ) THEN
		UPDATE SET T.ShortName = S.ShortName, T.Name = S.Name, T.Descr = S.Descr, T.IsActive = S.IsActive, T.UpdateDate = @DateStamp
	WHEN NOT MATCHED BY SOURCE AND T.IsActive = 1 THEN
		UPDATE SET T.IsActive = 0;

	SET IDENTITY_INSERT [ProdDB].dv.QualityAssessmentCodes OFF

END


GO



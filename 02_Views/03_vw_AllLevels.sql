/****** Object:  View [dv].[vw_AllLevels]    Script Date: 11/7/2017 8:29:07 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dv].[vw_AllLevels] AS
	SELECT
		dvv.ID
		,ISNULL(dvlr.LastRun,'1900-01-01') AS LevelLastRun
		,dvl.ID AS LevelID
		,dvst.ShortName AS SubjectTypeShortName
		,dvrc.ID AS RuleCheckID
		,ISNULL(dvrc.LastRun,'1900-01-01') AS RuleCheckLastRun
	FROM
		dv.Validations dvv
		INNER JOIN (
			SELECT
				dvvs.ValidationID
				,MAX(dvvr.RunDate) AS LastRun
			FROM
				dv.ValidationSets dvvs
				INNER JOIN dv.ValidationRuns dvvr ON dvvs.ID = dvvr.ValidationSetID
			GROUP BY
				dvvs.ValidationID
        ) dvlr ON dvv.ID = dvlr.ValidationID
		INNER JOIN dv.Targets dvt ON dvv.ID = dvt.ValidationID
		INNER JOIN dv.BusinessRuleGroups dvbrg ON dvt.ID = dvbrg.TargetID
		INNER JOIN dv.SubjectTypes dvst ON dvbrg.SubjectTypeID = dvst.ID
		INNER JOIN dv.BusinessRules dvbr ON dvbrg.ID = dvbr.BusinessRuleGroupID
		INNER JOIN dv.RuleChecks dvrc ON dvbr.ID = dvrc.BusinessRuleID
		CROSS JOIN dv.Levels dvl
	WHERE
		dvl.ShortName = 'V'
		AND dvv.IsActive = 1
		AND dvt.IsActive = 1
		AND dvbrg.IsActive = 1
		AND dvst.IsActive = 1
		AND dvrc.IsActive = 1
		AND dvst.IsActive = 1
		AND dvl.IsActive = 1
	UNION ALL
	SELECT
		dvt.ID
		,ISNULL(dvt.LastRun,'1900-01-01') AS LevelLastRun
		,dvl.ID AS LevelID
		,dvst.ShortName AS SubjectTypeShortName
		,dvrc.ID AS RuleCheckID
		,ISNULL(dvrc.LastRun,'1900-01-01') AS RuleCheckLastRun
	FROM
		dv.Targets dvt
		INNER JOIN dv.BusinessRuleGroups dvbrg ON dvt.ID = dvbrg.TargetID
		INNER JOIN dv.SubjectTypes dvst ON dvbrg.SubjectTypeID = dvst.ID
		INNER JOIN dv.BusinessRules dvbr ON dvbrg.ID = dvbr.BusinessRuleGroupID
		INNER JOIN dv.RuleChecks dvrc ON dvbr.ID = dvrc.BusinessRuleID
		CROSS JOIN dv.Levels dvl
	WHERE
		dvl.ShortName = 'T'
		AND dvt.IsActive = 1
		AND dvbrg.IsActive = 1
		AND dvst.IsActive = 1
		AND dvrc.IsActive = 1
		AND dvst.IsActive = 1
		AND dvl.IsActive = 1
	UNION ALL
	SELECT
		dvbrg.ID
		,ISNULL(dvbrg.LastRun,'1900-01-01') AS LevelLastRun
		,dvl.ID AS LevelID
		,dvst.ShortName AS SubjectTypeShortName
		,dvrc.ID AS RuleCheckID
		,ISNULL(dvrc.LastRun,'1900-01-01') AS RuleCheckLastRun
	FROM
		dv.BusinessRuleGroups dvbrg
		INNER JOIN dv.SubjectTypes dvst ON dvbrg.SubjectTypeID = dvst.ID
		INNER JOIN dv.BusinessRules dvbr ON dvbrg.ID = dvbr.BusinessRuleGroupID
		INNER JOIN dv.RuleChecks dvrc ON dvbr.ID = dvrc.BusinessRuleID
		CROSS JOIN dv.Levels dvl
	WHERE
		dvl.ShortName = 'BRG'
		AND dvbrg.IsActive = 1
		AND dvst.IsActive = 1
		AND dvrc.IsActive = 1
		AND dvst.IsActive = 1
		AND dvl.IsActive = 1
	UNION ALL
	SELECT
		dvbr.ID
		,ISNULL(dvbr.LastRun,'1900-01-01') AS LevelLastRun
		,dvl.ID AS LevelID
		,dvst.ShortName AS SubjectTypeShortName
		,dvrc.ID AS RuleCheckID
		,ISNULL(dvrc.LastRun,'1900-01-01') AS RuleCheckLastRun
	FROM
		dv.BusinessRuleGroups dvbrg
		INNER JOIN dv.SubjectTypes dvst ON dvbrg.SubjectTypeID = dvst.ID
		INNER JOIN dv.BusinessRules dvbr ON dvbrg.ID = dvbr.BusinessRuleGroupID
		INNER JOIN dv.RuleChecks dvrc ON dvbr.ID = dvrc.BusinessRuleID
		CROSS JOIN dv.Levels dvl
	WHERE
		dvl.ShortName = 'BR'
		AND dvbrg.IsActive = 1
		AND dvst.IsActive = 1
		AND dvrc.IsActive = 1
		AND dvst.IsActive = 1
		AND dvl.IsActive = 1
	UNION ALL
	SELECT
		dvrc.ID
		,ISNULL(dvrc.LastRun,'1900-01-01') AS LevelLastRun
		,dvl.ID AS LevelID
		,dvst.ShortName AS SubjectTypeShortName
		,dvrc.ID AS RuleCheckID
		,ISNULL(dvrc.LastRun,'1900-01-01') AS RuleCheckLastRun
	FROM
		dv.BusinessRuleGroups dvbrg
		INNER JOIN dv.SubjectTypes dvst ON dvbrg.SubjectTypeID = dvst.ID
		INNER JOIN dv.BusinessRules dvbr ON dvbrg.ID = dvbr.BusinessRuleGroupID
		INNER JOIN dv.RuleChecks dvrc ON dvbr.ID = dvrc.BusinessRuleID
		CROSS JOIN dv.Levels dvl
	WHERE
		dvl.ShortName = 'RC'
		AND dvbrg.IsActive = 1
		AND dvst.IsActive = 1
		AND dvrc.IsActive = 1
		AND dvst.IsActive = 1
		AND dvl.IsActive = 1
GO



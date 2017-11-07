/****** Object:  StoredProcedure [dv].[usp_ReadyRuleChecks]    Script Date: 11/7/2017 9:10:18 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dv].[usp_ReadyRuleChecks]
	( @ValidationRunID BIGINT, @ValidChecks AS dv.tt_ValidChecks READONLY, @CBN NVARCHAR(53), @RunDate DATETIME )
AS
BEGIN
	
	SET NOCOUNT ON

	SELECT
		dvt.ID AS TargetID
		,dvbrg.ID AS BusinessRuleGroupID
		,dvbr.ID AS BusinessRuleID
		,dvrc.ID AS RuleCheckID
		,dvl.ID AS LevelID
		,dvt.TargetCatalog
		,dvt.TargetSchema
		,CASE
			WHEN dvt.TableNameNeedsBatchSuffix = 1 THEN dvt.TargetTable + @CBN
			ELSE dvt.TargetTable
		END AS TargetTable
		,dvt.DetailColumn
		,dvrc.SQLCode
		,dvrc.ResultTypeID
		,dvrc.ExcludeFromTotals
		,dvrc.QualityAssessmentCodeID
	FROM
		(
			SELECT
				dval.RuleCheckID
			FROM
				dv.vw_AllLevels dval
				INNER JOIN dv.vw_AllIDs dvaid ON dval.RuleCheckID = dvaid.RuleCheckID
				INNER JOIN @ValidChecks dvvc ON dvaid.TargetID = dvvc.TargetID
				CROSS JOIN dv.Levels dvl
				LEFT OUTER JOIN dv.Dependencies dvd ON (
					dval.ID = dvd.ID
					AND dval.LevelID = dvd.LevelID
				)
			WHERE
				dval.RuleCheckLastRun != @RunDate
				AND dvl.ShortName = 'RC'
				AND dval.SubjectTypeShortName = 'Column'
			GROUP BY
				dval.RuleCheckID
			HAVING
				COUNT(dvd.ID) = 0
			UNION
			SELECT
				dval1.RuleCheckID
			FROM
				dv.vw_AllLevels dval1
				INNER JOIN dv.vw_AllIDs dvaid ON dval1.RuleCheckID = dvaid.RuleCheckID
				INNER JOIN @ValidChecks dvvc ON dvaid.TargetID = dvvc.TargetID
				CROSS JOIN dv.Levels dvl
				INNER JOIN dv.Dependencies dvd ON (
					dval1.ID = dvd.ID
					AND dval1.LevelID = dvd.LevelID
				)
				INNER JOIN dv.vw_AllLevels dval2 ON (
					dvd.DependsOnID = dval2.ID
					AND dvd.DependsOnLevelID = dval2.LevelID
				)
			WHERE
				dval1.RuleCheckLastRun != @RunDate
				AND dvl.ShortName = 'RC'
				AND dval1.SubjectTypeShortName = 'Column'
			GROUP BY
				dval1.RuleCheckID
			HAVING
				COUNT(DISTINCT CASE WHEN dval2.LevelLastRun = @RunDate THEN dval2.ID ELSE NULL END) = COUNT(DISTINCT dval2.ID)
		) dvrcid
		CROSS JOIN dv.Levels dvl
		INNER JOIN dv.RuleChecks dvrc ON dvrcid.RuleCheckID = dvrc.ID
		INNER JOIN dv.BusinessRules dvbr ON dvrc.BusinessRuleID = dvbr.ID
		INNER JOIN dv.BusinessRuleGroups dvbrg ON dvbr.BusinessRuleGroupID = dvbrg.ID
		INNER JOIN dv.Targets dvt ON dvbrg.TargetID = dvt.ID
	WHERE
		dvl.ShortName = 'RC';
	
	RETURN @@ERROR;

END
GO



/****** Object:  View [dv].[vw_AllIDs]    Script Date: 11/7/2017 8:26:18 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dv].[vw_AllIDs] AS
	SELECT
		dvv.ID AS ValidationID
		,dvt.ID AS TargetID
		,dvbrg.ID AS BusinessRuleGroupID
		,dvbrg.SubjectTypeID
		,dvbr.ID AS BusinessRuleID
		,dvrc.ID AS RuleCheckID
	FROM
		dv.Validations dvv
		INNER JOIN dv.Targets dvt ON dvv.ID = dvt.ValidationID
		INNER JOIN dv.BusinessRuleGroups dvbrg ON dvt.ID = dvbrg.TargetID
		INNER JOIN dv.BusinessRules dvbr ON dvbrg.ID = dvbr.BusinessRuleGroupID
		INNER JOIN dv.RuleChecks dvrc ON dvbr.ID = dvrc.BusinessRuleID
	WHERE
		dvv.IsActive = 1
		AND dvt.IsActive = 1
		AND dvbrg.IsActive = 1
		AND dvbr.IsActive = 1
		AND dvrc.IsActive = 1
GO



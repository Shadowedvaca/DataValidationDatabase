/****** Object:  StoredProcedure [dv].[usp_CloneValidationForNewDB]    Script Date: 11/10/2017 9:32:59 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dv].[usp_CloneValidationForNewDB] (
	@ValidationShortName NVARCHAR(50) = ''
    ,@NewDB NVARCHAR(128) = ''
	,@NewShortNameSuffix NVARCHAR(128) = 'cln'
) AS
BEGIN

	SET NOCOUNT ON

	DECLARE @CloneDate AS DATETIME
	DECLARE @OldDB AS NVARCHAR(128)
	DECLARE @SQL AS NVARCHAR(MAX)
	DECLARE @Cursor AS CURSOR
	DECLARE @LevelID AS INT
	DECLARE @TableName AS NVARCHAR(128)
	DECLARE @ParentLevelID AS INT
	DECLARE @ParentTableName AS NVARCHAR(128)
	
	SET @CloneDate = GETDATE()
	SELECT TOP 1 @OldDB = t.TargetCatalog FROM dv.Targets t INNER JOIN dv.Validations v ON t.ValidationID = v.ID WHERE v.ShortName = @ValidationShortName AND t.IsActive = 1

	-- Handle passed variables
	IF ( ISNULL(@ValidationShortName,'') = '' )
	BEGIN
		RAISERROR('No Validation Short Name passed, can not continue cloning process.', 16, 1)
		RETURN @@ERROR
    END
	ELSE IF ( ISNULL(@NewDB,'') = '' )
	BEGIN
		RAISERROR('No New Database name passed, can not continue cloning process.', 16, 1)
		RETURN @@ERROR
    END

	---- Clone the Validation level for the passed ShortName
	INSERT INTO dv.Validations ( ShortName, Name, Descr, CreateDate, UpdateDate, IsActive )
	SELECT ShortName + @NewShortNameSuffix, Name, Descr, @CloneDate, @CloneDate, 1
	FROM dv.Validations WHERE ShortName = @ValidationShortName AND IsActive = 1

	---- Clone the Target level associated to the passed Validation ShortName
	INSERT INTO dv.Targets ( ShortName, Name, Descr, ValidationID, TargetCatalog, TargetSchema, TargetTable, DetailColumn, TableNameNeedsBatchSuffix, CreateDate, UpdateDate, LastRun, IsActive )
	SELECT t.ShortName + @NewShortNameSuffix ,t.Name ,t.Descr ,n_v.ID ,@NewDB ,t.TargetSchema ,t.TargetTable ,t.DetailColumn ,t.TableNameNeedsBatchSuffix ,@CloneDate ,@CloneDate ,NULL ,1
	FROM dv.Targets t INNER JOIN dv.Validations v ON t.ValidationID = v.ID INNER JOIN dv.Validations n_v ON ( v.ShortName + @NewShortNameSuffix ) = n_v.ShortName AND v.ID != n_v.ID AND n_v.IsActive = 1
	WHERE v.ShortName = @ValidationShortName AND t.IsActive = 1

	-- Clone the Business Rule Group level associated with the cloned Targets
	INSERT INTO dv.BusinessRuleGroups ( TargetID, ShortName, Name, Descr, SubjectTypeID, TargetColumn, SystemImpact, CreateDate, UpdateDate, LastRun, IsActive )
	SELECT n_t.ID ,brg.ShortName + @NewShortNameSuffix ,brg.Name ,brg.Descr ,brg.SubjectTypeID ,brg.TargetColumn ,brg.SystemImpact ,@CloneDate ,@CloneDate ,NULL ,1 
	FROM dv.BusinessRuleGroups brg INNER JOIN dv.Targets t ON brg.TargetID = t.ID INNER JOIN dv.Targets n_t ON ( t.ShortName + @NewShortNameSuffix ) = n_t.ShortName AND t.ID != n_t.ID AND n_t.IsActive = 1
	WHERE brg.IsActive = 1

	-- Clone the Business Rule level associated with the cloned Business Rule Groups
	INSERT INTO dv.BusinessRules ( BusinessRuleGroupID, ShortName, Name, Descr, CreateDate, UpdateDate, LastRun, IsActive )
	SELECT n_brg.ID, br.ShortName + @NewShortNameSuffix, br.Name, br.Descr, @CloneDate, @CloneDate, NULL, 1
	FROM dv.BusinessRules br INNER JOIN dv.BusinessRuleGroups brg ON br.BusinessRuleGroupID = brg.ID INNER JOIN dv.BusinessRuleGroups n_brg ON ( brg.ShortName + @NewShortNameSuffix ) = n_brg.ShortName AND brg.ID != n_brg.ID AND n_brg.IsActive = 1
	WHERE br.IsActive = 1

	-- Clone the Rule Check level associated with the cloned Business Rules
	INSERT INTO dv.RuleChecks ( BusinessRuleID, ResultTypeID, ExcludeFromTotals, QualityAssessmentCodeID, ShortName, Name, Descr, SQLCode, CreateDate, UpdateDate, LastRun, IsActive )
	SELECT n_br.ID, rc.ResultTypeID, rc.ExcludeFromTotals, rc.QualityAssessmentCodeID, rc.ShortName + @NewShortNameSuffix, rc.Name, rc.Descr, REPLACE(rc.SQLCode, @OldDB + '.', @NewDB + '.'), @CloneDate, @CloneDate, NULL, 1
	FROM dv.RuleChecks rc INNER JOIN dv.BusinessRules br ON rc.BusinessRuleID = br.ID INNER JOIN dv.BusinessRules n_br ON ( br.ShortName + @NewShortNameSuffix ) = n_br.ShortName AND br.ID != n_br.ID AND n_br.IsActive = 1
	WHERE rc.IsActive = 1

	-- Clone the Temp Tables required for the Validation that is being cloned
	SET @Cursor = CURSOR FOR
		SELECT DISTINCT l.ID, l.Name FROM dv.Levels l INNER JOIN dv.TempTables tt ON l.ID = tt.LevelID WHERE tt.IsActive = 1

	OPEN @Cursor
	FETCH NEXT FROM @Cursor INTO @LevelID, @TableName

	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		SET @SQL = 'INSERT INTO dv.TempTables ( LevelID, LinkID, TempTableName, CreateSQLCode, InsertSQLCode, CreateDate, UpdateDate, IsActive )
		SELECT tt.LevelID, b.ID, tt.TempTableName, tt.CreateSQLCode, REPLACE(tt.InsertSQLCode, ''' + @OldDB + '.' + ''', ''' + @NewDB + '.' + ''' ), ''' + CONVERT(NVARCHAR(100),@CloneDate) + ''', ''' + CONVERT(NVARCHAR(100),@CloneDate) + ''', 1
		FROM dv.TempTables tt INNER JOIN dv.' + @TableName + ' a ON tt.LinkID = a.ID INNER JOIN dv.' + @TableName + ' b ON ( a.ShortName + ''' + @NewShortNameSuffix + ''' ) = b.ShortName AND a.ID != b.ID AND b.IsActive = 1
		WHERE tt.IsActive = 1 AND tt.LevelID = 1'
	
		EXECUTE sp_executesql @SQL;

		FETCH NEXT FROM @Cursor INTO @LevelID, @TableName;
	END

	CLOSE @Cursor;
	DEALLOCATE @Cursor;

	-- Clone the Dependencies required for the Validation that is being cloned
	SET @Cursor = CURSOR FOR
		SELECT DISTINCT cl.ID, cl.Name, pl.ID AS ParentID, pl.Name AS ParentName FROM dv.Dependencies d INNER JOIN dv.Levels cl ON d.LevelID = cl.ID INNER JOIN dv.Levels pl ON d.DependsOnLevelID = pl.ID WHERE d.IsActive = 1

	OPEN @Cursor
	FETCH NEXT FROM @Cursor INTO @LevelID, @TableName, @ParentLevelID, @ParentTableName;

	WHILE @@FETCH_STATUS = 0
	BEGIN

		SET @SQL = 'INSERT INTO dv.Dependencies ( ID, LevelID, DependsOnID, DependsOnLevelID, IsActive )
		SELECT cb.ID, d.LevelID, pb.ID, d.DependsOnLevelID, 1
		FROM dv.Dependencies d
			INNER JOIN dv.' + @TableName + ' ca ON d.ID = ca.ID INNER JOIN dv.' + @TableName + ' cb ON ( ca.ShortName + ''' + @NewShortNameSuffix + ''' ) = cb.ShortName AND ca.ID != cb.ID AND cb.IsActive = 1
			INNER JOIN dv.' + @ParentTableName + ' pa ON d.ID = pa.ID INNER JOIN dv.' + @ParentTableName + ' pb ON ( pa.ShortName + ''' + @NewShortNameSuffix + ''' ) = pb.ShortName AND pa.ID != pb.ID AND pb.IsActive = 1
		WHERE d.IsActive = 1';

		EXECUTE sp_executesql @SQL;

		FETCH NEXT FROM @Cursor INTO @LevelID, @TableName, @ParentLevelID, @ParentTableName;
	END

	CLOSE @Cursor;
	DEALLOCATE @Cursor;

	-- Display summary compare
	SELECT
		v.ShortName
		,COUNT(DISTINCT v.ID) AS Validations
		,COUNT(DISTINCT t.ID) AS Targets
		,COUNT(DISTINCT brg.ID) AS BusinessRuleGroups
		,COUNT(DISTINCT br.ID) AS BusinessRules
		,COUNT(DISTINCT rc.ID) AS RuleChecks
	FROM
		dv.Validations v
		INNER JOIN dv.Targets t ON v.ID = t.ValidationID
		INNER JOIN dv.BusinessRuleGroups brg ON t.ID = brg.TargetID
		INNER JOIN dv.BusinessRules br ON brg.ID = br.BusinessRuleGroupID
		INNER JOIN dv.RuleChecks rc ON br.ID = rc.BusinessRuleID
	WHERE
		v.ShortName IN ( @ValidationShortName, @ValidationShortName + @NewShortNameSuffix )
		AND rc.IsActive = 1
	GROUP BY
		v.ShortName

	SELECT
		*
	FROM
		dv.TempTables
	WHERE
		CreateDate >= DATEADD(d,-1,@CloneDate)

	SELECT
		*
	FROM
		dv.Dependencies
	WHERE
		IsActive = 1

	RETURN @@ERROR;
END


GO



/****** Object:  StoredProcedure [dv].[usp_RunDataValidation]    Script Date: 11/7/2017 9:13:42 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dv].[usp_RunDataValidation]
	( @ValidationShortName NVARCHAR(MAX), @GenerateDailyBatchName TINYINT = 0, 
	@CycleName NVARCHAR(32) = '', @CycleTimestamp NVARCHAR(20) = '' )
AS
BEGIN	
	
	SET NOCOUNT ON

	DECLARE @BatchName AS NVARCHAR(53);
	DECLARE @BatchNamePrevious AS NVARCHAR(53);
	DECLARE @BusinessRuleGroupID AS BIGINT;
	DECLARE @BusinessRuleID AS BIGINT;
	DECLARE @Catalog AS NVARCHAR(128);
	DECLARE @CBN AS NVARCHAR(53);
	DECLARE @Column AS NVARCHAR(128);
	DECLARE @Cursor AS CURSOR;
	DECLARE @DateStamp AS DATETIME;
	DECLARE @ErrStr AS NVARCHAR(255);
	DECLARE @ExcludeFromTotals AS TINYINT;
	DECLARE @GUID AS NVARCHAR(40);
	DECLARE @GUID_NoMods AS UNIQUEIDENTIFIER;
	DECLARE @ID AS BIGINT;
	DECLARE @LevelID AS INT;
	DECLARE @ProcName AS NVARCHAR(128);
	DECLARE @QualityAssessmentCodeID AS INT;
	DECLARE @ReadyRuleCheck AS dv.tt_ReadyRuleCheck;
	DECLARE @ResultTypeID AS INT;
	DECLARE @RowCount AS INT;
	DECLARE @RowsLeft AS INT;
	DECLARE @RuleCheckID AS BIGINT;
	DECLARE @RunDate AS DATETIME;
	DECLARE @Schema AS NVARCHAR(128);
	DECLARE @SQL AS NVARCHAR(MAX);
	DECLARE @SQLFromCursor AS NVARCHAR(MAX);
	DECLARE @SQLCreateTT AS NVARCHAR(MAX);
	DECLARE @SQLInsertTT AS NVARCHAR(MAX);
	DECLARE @SQLDropTT AS NVARCHAR(MAX);
	DECLARE @StartTime AS DATETIME;
	DECLARE @Table AS NVARCHAR(128);
	DECLARE @Table2 AS NVARCHAR(128);
	DECLARE @TargetID AS BIGINT;
	DECLARE @TargetTableWithoutSuffix AS NVARCHAR(128);
	DECLARE @ValidationIDCheck AS BIGINT;
	DECLARE @ValidationRunID AS BIGINT;
	DECLARE @ValidChecks AS dv.tt_ValidChecks;

	SET @GUID_NoMods = NEWID();

	-- Handle passed variables
	IF ( ISNULL(@ValidationShortName,'') = '' )
	BEGIN
		RAISERROR('No Validation Short Name passed, can not continue Data Validation.', 16, 1)
		RETURN @@ERROR
    END

	-- Get list of validations by looking up the short names and store the found IDs for other places in sproc to use
	CREATE TABLE #ValidationSet ( ValidationID int NOT NULL );

	-- Number of validations passed equals number of commas plus one
	SET @ValidationIDCheck = LEN(@ValidationShortName) - LEN(REPLACE(@ValidationShortName,',','')) + 1;

	INSERT INTO #ValidationSet ( ValidationID )
	SELECT DISTINCT vr.ID FROM dv.Validations vr INNER JOIN ( SELECT value FROM STRING_SPLIT(@ValidationShortName,',') ) a ON vr.ShortName = a.value;
	
	IF ( @@ROWCOUNT < @ValidationIDCheck )
	BEGIN
		SET @ErrStr = 'One or more of the Validation Short Names provided ( ' + @ValidationShortName + ' ) can not be found.  Check passed value(s) against the dv.Validations table in the ShortName field.';
		RAISERROR(@ErrStr, 16, 1);
		RETURN @@ERROR
    END

	SET @DateStamp = GETDATE();

	SET @CycleName = ISNULL(@CycleName,'');
	SET @CycleTimestamp = ISNULL(@CycleTimestamp,'');
	SET @GenerateDailyBatchName = ISNULL(@GenerateDailyBatchName,0);

	-- Construct Batch Name
	IF ( @CycleName = '' and @CycleTimestamp = '' )
	BEGIN
		SET @CBN = '';
		IF ( @GenerateDailyBatchName = 1 )
		BEGIN
			IF ( @CycleName = '' ) SET @CycleName = 'Daily';
			IF ( @CycleTimestamp = '' ) SET @CycleTimestamp = FORMAT(@DateStamp, 'yyyyMMddhhmm');
		END
	END
	ELSE SET @CBN = '_' + @CycleName + '_' + @CycleTimestamp;

	IF ( @CBN = '' AND @GenerateDailyBatchName = 0 ) SET @BatchName = '';
	ELSE SET @BatchName = @CycleName + '_' + @CycleTimestamp;

	-- Log ValidationSet
	INSERT INTO dv.ValidationSets ( ID, ValidationID )
	SELECT @GUID_NoMods, ValidationID
	FROM #ValidationSet

	-- Log ValidationRun
	INSERT INTO dv.ValidationRuns ( ValidationSetID ,CycleName ,CycleTimestamp ,BatchName, RunDate )
	VALUES ( @GUID_NoMods, @CycleName, @CycleTimestamp, @BatchName, @DateStamp )

	SELECT TOP 1 @ValidationRunID = ID FROM dv.ValidationRuns WHERE ValidationSetID = @GUID_NoMods ORDER BY RunDate DESC

	-- Set up other variables
	SET @ProcName = 'RunDataValidation';
	SET @GUID = REPLACE(CAST(@GUID_NoMods AS NVARCHAR(40)),'-','');
	SET @RunDate = @DateStamp;

	-- Note Validation Run Log
	INSERT INTO dv.ValidationRunLog ( ValidationRunID ,LoggedBy ,Descr )
	VALUES ( @ValidationRunID, @ProcName, 'Beginning Validation run for ' + @ValidationShortName )

	-- Table Validity Check
	SET @Cursor = CURSOR FOR
		SELECT ID, TargetCatalog AS DBName, CASE WHEN TableNameNeedsBatchSuffix = 1 THEN TargetTable + @CBN ELSE TargetTable END AS TableName FROM dv.Targets t INNER JOIN #ValidationSet vs ON t.ValidationID = vs.ValidationID WHERE IsActive = 1;

	OPEN @Cursor
	FETCH NEXT FROM @Cursor INTO @ID, @Catalog, @Table;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @StartTime = GETDATE()

		SET @SQL = 'SELECT ' + CAST(@ID AS NVARCHAR(32)) + ' AS TargetID FROM ' + @Catalog + '.sys.tables WHERE [name] = ''' + @Table + ''' HAVING COUNT(ISNULL([name],'''')) > 0';
		INSERT INTO @ValidChecks ( TargetID )
			EXECUTE sp_executesql @SQL;

		INSERT INTO dv.ValidationRunLog ( ValidationRunID ,LoggedBy ,Descr, SQLCode, SQLResult, SQLRunSeconds )
		VALUES ( @ValidationRunID, @ProcName, 'Table Validity Check', @SQL, @@ROWCOUNT, DATEDIFF( SECOND, @StartTime, GETDATE() ) )

		FETCH NEXT FROM @Cursor INTO @ID, @Catalog, @Table;
	END

	CLOSE @Cursor;
	DEALLOCATE @Cursor;

	-- Look for temp tables required for the targets found in the table validity check
	SET @SQLDropTT = '';
	SET @Cursor = CURSOR FOR
		SELECT DISTINCT
			ttt.TempTableName
			,ttt.CreateSQLCode
			,ttt.InsertSQLCode
		FROM
			dv.vw_AllIDs ai
			INNER JOIN @ValidChecks vc ON ai.TargetID = vc.TargetID
			INNER JOIN dv.TempTables ttt ON ( ai.TargetID = ttt.LinkID AND ttt.LevelID = 1 AND ttt.IsActive = 1 )
		UNION SELECT DISTINCT
			ttbrg.TempTableName
			,ttbrg.CreateSQLCode
			,ttbrg.InsertSQLCode
		FROM
			dv.vw_AllIDs ai
			INNER JOIN @ValidChecks vc ON ai.TargetID = vc.TargetID
			INNER JOIN dv.TempTables ttbrg ON ( ai.BusinessRuleGroupID = ttbrg.LinkID AND ttbrg.LevelID = 2 AND ttbrg.IsActive = 1 )
		UNION SELECT DISTINCT
			ttbr.TempTableName
			,ttbr.CreateSQLCode
			,ttbr.InsertSQLCode
		FROM
			dv.vw_AllIDs ai
			INNER JOIN @ValidChecks vc ON ai.TargetID = vc.TargetID
			INNER JOIN dv.TempTables ttbr ON ( ai.BusinessRuleID = ttbr.LinkID AND ttbr.LevelID = 3 AND ttbr.IsActive = 1 )
		UNION SELECT DISTINCT
			ttrc.TempTableName
			,ttrc.CreateSQLCode
			,ttrc.InsertSQLCode
		FROM
			dv.vw_AllIDs ai
			INNER JOIN @ValidChecks vc ON ai.TargetID = vc.TargetID
			INNER JOIN dv.TempTables ttrc ON ( ai.RuleCheckID = ttrc.LinkID AND ttrc.LevelID = 4 AND ttrc.IsActive = 1 )
	
	OPEN @Cursor
	FETCH NEXT FROM @Cursor INTO @Table, @SQLCreateTT, @SQLInsertTT;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @StartTime = GETDATE()

		SET @SQLCreateTT = REPLACE(@SQLCreateTT, 'TEMPTABLEGUID', @GUID);
		SET @SQLInsertTT = REPLACE(@SQLInsertTT, 'TEMPTABLEGUID', @GUID);
		SET @SQLInsertTT = REPLACE(@SQLInsertTT, '_CurrentBatchName', @CBN);
		SET @SQLDropTT = @SQLDropTT + 'DROP TABLE ' + @Table + @GUID + '; '

		EXECUTE sp_executesql @SQLCreateTT;

		BEGIN TRY

			EXECUTE sp_executesql @SQLInsertTT;

			INSERT INTO dv.ValidationRunLog ( ValidationRunID ,LoggedBy ,Descr, SQLCode, SQLResult, SQLRunSeconds )
			VALUES ( @ValidationRunID, @ProcName, 'Temp Table Insert - ' + @Table, @SQLInsertTT, @@ROWCOUNT, DATEDIFF( SECOND, @StartTime, GETDATE() ) )

		END TRY
		BEGIN CATCH

			INSERT INTO dv.ValidationRunLog ( ValidationRunID ,LoggedBy ,Descr, SQLCode )
			VALUES ( @ValidationRunID, @ProcName, 'Error on Temp Table Insert - ' + @Table + ' - ' + ( SELECT ERROR_MESSAGE() ), @SQL )

        END CATCH

		FETCH NEXT FROM @Cursor INTO @Table, @SQLCreateTT, @SQLInsertTT;
	END

	CLOSE @Cursor;
	DEALLOCATE @Cursor;

	-- Truncate the temporary results storage
	TRUNCATE TABLE dv.RuleCheckLastRunResults

	INSERT INTO dv.ValidationRunLog ( ValidationRunID ,LoggedBy ,Descr )
	VALUES ( @ValidationRunID, @ProcName, 'RuleCheckLastRunResults Truncated' )

	-- Prep the initial rule check set ( filters out ones with dependencies )
	INSERT INTO @ReadyRuleCheck
		EXECUTE dv.usp_ReadyRuleChecks @ValidationRunID, @ValidChecks, @CBN, @RunDate;

	SET @RowsLeft = @@rowcount;

	INSERT INTO dv.ValidationRunLog ( ValidationRunID ,LoggedBy ,Descr, SQLResult )
	VALUES ( @ValidationRunID, @ProcName, 'Rules that are ready to be checked', @RowsLeft )

	-- Main Rule Check run
	WHILE (@RowsLeft > 0)
	BEGIN

		SET @Cursor = CURSOR FOR
			SELECT TargetID,  BusinessRuleGroupID,  BusinessRuleID,  RuleCheckID,  LevelID,  TargetCatalog,  TargetSchema,  TargetTable,  DetailColumn,  SQLCode,  ResultTypeID,  ExcludeFromTotals,  QualityAssessmentCodeID FROM @ReadyRuleCheck

		OPEN @Cursor
		FETCH NEXT FROM @Cursor INTO @TargetID, @BusinessRuleGroupID, @BusinessRuleID, @RuleCheckID, @LevelID, @Catalog, @Schema, @Table, @Column, @SQLFromCursor, @ResultTypeID, @ExcludeFromTotals, @QualityAssessmentCodeID

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @StartTime = getdate();
			
			-- If the check requires the previously run table
			IF ( SIGN(CHARINDEX('_CurrentBatchName', @SQLFromCursor)) = 1 ) SET @SQLFromCursor = REPLACE(@SQLFromCursor, '_CurrentBatchName', @CBN);

			-- If the check requires the previously run table
			IF ( SIGN(CHARINDEX('_PreviousBatchName', @SQLFromCursor)) = 1 )
			BEGIN
				SET @TargetTableWithoutSuffix = REPLACE(@Table, @CBN, '');
				-- Get Prior Batch Name for queries that compare the last two runs
				SET @SQL = N'SELECT @HC_param = count(*) FROM ' + @Catalog + '.INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = ''' + @Schema + ''' AND TABLE_NAME LIKE ''' + @TargetTableWithoutSuffix + '_' + @CycleName + '%''';
				EXECUTE sp_executesql @SQL, N'@HC_param INT OUTPUT', @HC_param = @RowCount OUTPUT
				IF ( @RowCount > 0 )
				BEGIN
					SET @SQL = N'SELECT TOP 1 @HT_param = TABLE_NAME FROM ( SELECT TOP 2 TABLE_NAME FROM ' + @Catalog + '.INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = ''' + @Schema + ''' AND TABLE_NAME LIKE ''' + @TargetTableWithoutSuffix + '_' + @CycleName + '%'' ORDER BY TABLE_NAME DESC ) ORDER BY TABLE_NAME ASC';
					EXECUTE sp_executesql @SQL, N'@HT_param nvarchar(128) OUTPUT', @HT_param = @Table2 OUTPUT
					SET @BatchNamePrevious = REPLACE(@Table2, @Table + '_', '')
				END
				SET @SQLFromCursor = REPLACE(@SQLFromCursor, 'PreviousBatchName', @BatchNamePrevious);
			END
            
			-- All other replacements
			IF ( SIGN(CHARINDEX('##BATCHNAME##', @SQLFromCursor)) = 1 ) SET @SQLFromCursor = REPLACE(@SQLFromCursor, '##BATCHNAME##', @BatchName);
			IF ( SIGN(CHARINDEX('##VALIDATIONRUNID##', @SQLFromCursor)) = 1 ) SET @SQLFromCursor = REPLACE(@SQLFromCursor, '##VALIDATIONRUNID##', CAST(@ValidationRunID AS NVARCHAR(32)));
			IF ( SIGN(CHARINDEX('##TARGETID##', @SQLFromCursor)) = 1 ) SET @SQLFromCursor = REPLACE(@SQLFromCursor, '##TARGETID##', CAST(@TargetID AS NVARCHAR(32)));
			IF ( SIGN(CHARINDEX('##BUSINESSRULEGROUPID##', @SQLFromCursor)) = 1 ) SET @SQLFromCursor = REPLACE(@SQLFromCursor, '##BUSINESSRULEGROUPID##', CAST(@BusinessRuleGroupID AS NVARCHAR(32)));
			IF ( SIGN(CHARINDEX('##BUSINESSRULEID##', @SQLFromCursor)) = 1 ) SET @SQLFromCursor = REPLACE(@SQLFromCursor, '##BUSINESSRULEID##', CAST(@BusinessRuleID AS NVARCHAR(32)));
			IF ( SIGN(CHARINDEX('##RULECHECKID##', @SQLFromCursor)) = 1 ) SET @SQLFromCursor = REPLACE(@SQLFromCursor, '##RULECHECKID##', CAST(@RuleCheckID AS NVARCHAR(32)));
			IF ( SIGN(CHARINDEX('TEMPTABLEGUID', @SQLFromCursor)) = 1 ) SET @SQLFromCursor = REPLACE(@SQLFromCursor, 'TEMPTABLEGUID', @GUID);

			-- Run SQL and insert results into temp storage area
			SET @SQL = 'SELECT ' + CAST( @ValidationRunID AS NVARCHAR(32) ) + ' AS ValidationRunID, cast(' + @Column + ' as nvarchar(255)) AS RowIdentifier, ' + CAST( @RuleCheckID AS NVARCHAR(32) ) + ' AS RuleCheckID FROM ( ' + @SQLFromCursor + ' ) a'
			
			BEGIN TRY

				INSERT INTO dv.RuleCheckLastRunResults ( ValidationRunID, RowIdentifier, RuleCheckID )
					EXECUTE sp_executesql @SQL;

				INSERT INTO dv.ValidationRunLog ( ValidationRunID ,LoggedBy ,Descr, SQLCode, SQLResult, SQLRunSeconds )
				VALUES ( @ValidationRunID, @ProcName, 'Rule Check # ' + CAST( @RuleCheckID AS NVARCHAR(32) ), @SQL, @@ROWCOUNT, DATEDIFF( SECOND, @StartTime, GETDATE() ) )

			END TRY
			BEGIN CATCH

				INSERT INTO dv.ValidationRunLog ( ValidationRunID ,LoggedBy ,Descr, SQLCode )
				VALUES ( @ValidationRunID, @ProcName, 'Error on Rule Check # ' + CAST( @RuleCheckID AS NVARCHAR(32) ) + ' - ' + ( SELECT ERROR_MESSAGE() ), @SQL )

            END CATCH

			UPDATE dv.RuleChecks SET LastRun = @RunDate WHERE ISNULL(LastRun,'1900-01-01') < @RunDate AND ID = @RuleCheckID;
			UPDATE dv.BusinessRules SET LastRun = @RunDate WHERE ISNULL(LastRun,'1900-01-01') < @RunDate AND ID = @BusinessRuleID;
			UPDATE dv.BusinessRuleGroups SET LastRun = @RunDate WHERE ISNULL(LastRun,'1900-01-01') < @RunDate AND ID = @BusinessRuleGroupID;
			UPDATE dv.Targets SET LastRun = @RunDate WHERE ISNULL(LastRun,'1900-01-01') < @RunDate AND ID = @TargetID;

			FETCH NEXT FROM @Cursor INTO @TargetID, @BusinessRuleGroupID, @BusinessRuleID, @RuleCheckID, @LevelID, @Catalog, @Schema, @Table, @Column, @SQLFromCursor, @ResultTypeID, @ExcludeFromTotals, @QualityAssessmentCodeID
		END

		CLOSE @Cursor
		DEALLOCATE @Cursor

		DELETE FROM @ReadyRuleCheck;

		-- Redo rule check set ( include any with dependencies that now have what they need )
		INSERT INTO @ReadyRuleCheck
			EXECUTE dv.usp_ReadyRuleChecks @ValidationRunID, @ValidChecks, @CBN, @RunDate;

		SET @RowsLeft = @@rowcount;

		INSERT INTO dv.ValidationRunLog ( ValidationRunID ,LoggedBy ,Descr, SQLResult )
		VALUES ( @ValidationRunID, @ProcName, 'Rules that are ready to be checked', @RowsLeft )

	END

	-- Temp Tables
	EXECUTE sp_executesql @SQLDropTT;

	-- Merge temp results into overall results table
	MERGE dv.RuleCheckResults AS T
	USING ( SELECT DISTINCT ValidationRunID, RowIdentifier, RuleCheckID FROM dv.RuleCheckLastRunResults ) AS S
	ON ( T.RuleCheckID = S.RuleCheckID AND T.RowIdentifier = S.RowIdentifier AND T.IsActive = 1 )
	WHEN MATCHED THEN
		UPDATE SET T.EndDate = @DateStamp
	WHEN NOT MATCHED BY SOURCE AND T.IsActive = 1 THEN 
		UPDATE SET T.IsActive = 0
	WHEN NOT MATCHED BY TARGET THEN 
		INSERT ( RowIdentifier, RuleCheckID, StartDate, EndDate, IsActive ) VALUES ( S.RowIdentifier, S.RuleCheckID, @DateStamp, @DateStamp, 1 );

	INSERT INTO dv.ValidationRunLog ( ValidationRunID ,LoggedBy ,Descr, SQLResult )
	VALUES ( @ValidationRunID, @ProcName, 'Rule Results Merged', @@ROWCOUNT )

	DROP TABLE #ValidationSet;

	RETURN @@ERROR

END








GO



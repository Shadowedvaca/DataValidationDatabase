INSERT INTO dv.ResultTypes
(
    ShortName,
    Name,
    Descr,
    OverallFlag,
    TotalFlag,
    PassFlag,
    FailFlag,
    IgnoreFlag,
    StopRecordFlowFlag,
    CreateDate,
    UpdateDate,
    IsActive
)
VALUES
(   N'Ignore',
    N'Ignored Result',
    N'This result indicates rows which are ignored by the Business Rule.  This result type is used when there is a requirement to account for all rows in the table with each Business Rule.',
    0,0,0,0,1,0,GETDATE(),GETDATE(),1
),(   N'Expected',
    N'Expected Result',
    N'This result indicates rows which follow the expected condition of the Business Rule.',
    0,0,1,0,0,0,GETDATE(),GETDATE(),1 
),(   N'Non-Optimal',
    N'Non-Optimal Results',
    N'This result indicates rows which do not follow the expected condition of the Business Rule.  Although these results are not optimal or expected, they are not detrimental to the downstream processes.',
    0,0,0,1,0,0,GETDATE(),GETDATE(),1 
),(   N'Fail',
    N'Failed Results',
    N'This result indicates rows which do not follow the expected condition of the Business Rule.  The results will have a downstream impact and should be withheld or fixed before continuing the processing.',
    0,0,0,1,0,1,GETDATE(),GETDATE(),1 
)
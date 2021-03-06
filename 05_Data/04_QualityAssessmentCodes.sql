INSERT INTO dv.QualityAssessmentCodes
(
    ShortName,
    Name,
    Descr,
    CreateDate,
    UpdateDate,
    IsActive
)
VALUES
(   N'N/A',
    N'Not Applicable',
    N'This field does not apply to this result.',
    GETDATE(),GETDATE(),1
),(   N'Correct',
    N'No Known Issue',
    N'This check will result in a pass.',
    GETDATE(),GETDATE(),1
),(   N'Completeness',
    N'Missing / Unusable Data',
    N'What data is missing or unusable?',
    GETDATE(),GETDATE(),1
),(   N'Conformity',
    N'Non-Standard Data',
    N'What data is stored in a non-standard format?',
    GETDATE(),GETDATE(),1
),(   N'Consistency',
    N'Conflicting Data',
    N'What data values give conflicting information?',
    GETDATE(),GETDATE(),1
),(   N'Accuracy',
    N'Incorrect Data',
    N'What data is incorrect or out of date?',
    GETDATE(),GETDATE(),1
),(   N'Duplicates',
    N'Repeated Data',
    N'What data records or attributes are repeated?',
    GETDATE(),GETDATE(),1
),(   N'Integrity',
    N'Not Referenced Data',
    N'What data is missing or not referenced?',
    GETDATE(),GETDATE(),1
)
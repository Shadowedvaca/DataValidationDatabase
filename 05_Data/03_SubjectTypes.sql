INSERT INTO dv.SubjectTypes
(
    ShortName,
    Name,
    Descr,
    CreateDate,
    UpdateDate,
    IsActive
)
VALUES
(   N'Column',
    N'Column Level Validation',
    N'Groups a set of business rules together intended to validate all rows for a single column.  Each row within the column should only be returned by one result.',
    GETDATE(),GETDATE(),1
)
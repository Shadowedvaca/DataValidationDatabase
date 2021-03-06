INSERT INTO dv.Levels
(
    ShortName,
    Name,
    Descr,
    CreateDate,
    UpdateDate,
    IsActive
)
VALUES
(   N'V',
    N'Validations',
    N'This is a set of validations, may contain multiple Targets (tables).',
    GETDATE(),GETDATE(),1
),(   N'T',
    N'Targets',
    N'This is a single table to validate, may contain multiple Business Rule Groups (columns).',
    GETDATE(),GETDATE(),1
),(   N'BRG',
    N'BusinessRuleGroups',
    N'This is a single column to validate, may contain multiple Business Rules (different rules to validate).',
    GETDATE(),GETDATE(),1
),(   N'BR',
    N'BusinessRules',
    N'This is a single rule the which needs to be validated, most Business Rules contain at least two Rule Checks, one for a Pass and another for a Fail.',
    GETDATE(),GETDATE(),1
),(   N'RC',
    N'RuleChecks',
    N'This is a single condition of the business rules ( pass / fail / etc ).',
    GETDATE(),GETDATE(),1
)
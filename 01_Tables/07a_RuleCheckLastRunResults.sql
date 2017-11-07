/****** Object:  Table [dv].[RuleCheckLastRunResults]    Script Date: 11/7/2017 8:16:16 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dv].[RuleCheckLastRunResults](
	[ValidationRunID] [BIGINT] NOT NULL,
	[RowIdentifier] [NVARCHAR](255) NOT NULL,
	[RuleCheckID] [BIGINT] NOT NULL
) ON [PRIMARY]

GO



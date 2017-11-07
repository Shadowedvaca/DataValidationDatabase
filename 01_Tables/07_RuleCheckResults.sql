/****** Object:  Table [dv].[RuleCheckResults]    Script Date: 11/7/2017 8:17:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dv].[RuleCheckResults](
	[ID] [BIGINT] IDENTITY(1,1) NOT NULL,
	[RowIdentifier] [NVARCHAR](255) NOT NULL,
	[RuleCheckID] [BIGINT] NOT NULL,
	[StartDate] [DATETIME] NOT NULL,
	[EndDate] [DATETIME] NULL,
	[IsActive] [TINYINT] NOT NULL
) ON [PRIMARY]

GO



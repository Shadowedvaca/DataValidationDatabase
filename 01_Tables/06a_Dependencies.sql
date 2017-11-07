/****** Object:  Table [dv].[Dependencies]    Script Date: 11/7/2017 9:09:20 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dv].[Dependencies](
	[ID] [BIGINT] NOT NULL,
	[LevelID] [INT] NOT NULL,
	[DependsOnID] [BIGINT] NOT NULL,
	[DependsOnLevelID] [INT] NOT NULL,
	[IsActive] [TINYINT] NULL
) ON [PRIMARY]

GO

ALTER TABLE [dv].[Dependencies] ADD  DEFAULT ((1)) FOR [IsActive]
GO



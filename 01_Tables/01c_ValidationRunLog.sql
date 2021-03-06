/****** Object:  Table [dv].[ValidationRunLog]    Script Date: 11/7/2017 8:24:50 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dv].[ValidationRunLog](
	[ID] [BIGINT] IDENTITY(1,1) NOT NULL,
	[ValidationRunID] [BIGINT] NOT NULL,
	[LoggedBy] [NVARCHAR](128) NOT NULL,
	[Descr] [NVARCHAR](MAX) NOT NULL,
	[SQLCode] [NVARCHAR](MAX) NULL,
	[SQLResult] [BIGINT] NULL,
	[SQLRunSeconds] [BIGINT] NULL,
	[LogTime] [DATETIME] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dv].[ValidationRunLog] ADD  DEFAULT (GETDATE()) FOR [LogTime]
GO



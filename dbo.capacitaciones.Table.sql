USE [bd_sima]
GO
/****** Object:  Table [dbo].[capacitaciones]    Script Date: 9/02/2018 10:08:19 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[capacitaciones](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[periodo] [varchar](6) NOT NULL,
	[encargado] [varchar](80) NOT NULL,
	[tema] [varchar](200) NOT NULL,
	[comentarios] [varchar](400) NULL,
	[fecha] [date] NOT NULL,
	[nom_File] [varchar](40) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[capacitaciones] ADD  DEFAULT (NULL) FOR [comentarios]
GO

USE [bd_sima]
GO
/****** Object:  Table [dbo].[clases_sima]    Script Date: 9/02/2018 10:08:19 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[clases_sima](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[fecha_registro] [date] NOT NULL,
	[periodo] [varchar](6) NOT NULL,
	[tema] [varchar](200) NOT NULL,
	[comentario] [varchar](400) NULL,
	[cursos_id] [int] NOT NULL,
	[usuarios_id] [varchar](12) NOT NULL,
	[evidencia] [varchar](40) NOT NULL,
	[fecha_realizada] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[clases_sima] ADD  DEFAULT (NULL) FOR [comentario]
GO
ALTER TABLE [dbo].[clases_sima]  WITH CHECK ADD  CONSTRAINT [FK_clases_sima_cursos] FOREIGN KEY([cursos_id])
REFERENCES [dbo].[cursos] ([id])
GO
ALTER TABLE [dbo].[clases_sima] CHECK CONSTRAINT [FK_clases_sima_cursos]
GO
ALTER TABLE [dbo].[clases_sima]  WITH CHECK ADD  CONSTRAINT [FK_clases_sima_usuarios] FOREIGN KEY([usuarios_id])
REFERENCES [dbo].[usuarios] ([id])
GO
ALTER TABLE [dbo].[clases_sima] CHECK CONSTRAINT [FK_clases_sima_usuarios]
GO

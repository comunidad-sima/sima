USE [bd_sima]
GO
/****** Object:  Table [dbo].[cursos]    Script Date: 9/02/2018 10:08:19 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cursos](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[periodo] [varchar](6) NOT NULL,
	[nombre_materia] [varchar](90) NOT NULL,
	[estado] [tinyint] NOT NULL,
	[fecha_finalizacion] [date] NOT NULL,
	[idUsuario] [varchar](12) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[cursos]  WITH CHECK ADD  CONSTRAINT [FK_cursos_materias] FOREIGN KEY([nombre_materia])
REFERENCES [dbo].[materias] ([nombre])
GO
ALTER TABLE [dbo].[cursos] CHECK CONSTRAINT [FK_cursos_materias]
GO
ALTER TABLE [dbo].[cursos]  WITH CHECK ADD  CONSTRAINT [FK_cursos_usuarios] FOREIGN KEY([idUsuario])
REFERENCES [dbo].[usuarios] ([id])
GO
ALTER TABLE [dbo].[cursos] CHECK CONSTRAINT [FK_cursos_usuarios]
GO

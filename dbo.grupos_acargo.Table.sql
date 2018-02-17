USE [bd_sima]
GO
/****** Object:  Table [dbo].[grupos_acargo]    Script Date: 9/02/2018 10:08:19 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[grupos_acargo](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idUsuario] [varchar](12) NOT NULL,
	[materia] [varchar](90) NOT NULL,
	[periodo] [varchar](6) NOT NULL,
	[id_grupo] [varchar](10) NOT NULL,
	[id_curso] [int] NOT NULL,
	[programa] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[grupos_acargo]  WITH CHECK ADD  CONSTRAINT [FK_grupos_acargo_cursos] FOREIGN KEY([id_curso])
REFERENCES [dbo].[cursos] ([id])
GO
ALTER TABLE [dbo].[grupos_acargo] CHECK CONSTRAINT [FK_grupos_acargo_cursos]
GO
ALTER TABLE [dbo].[grupos_acargo]  WITH CHECK ADD  CONSTRAINT [FK_grupos_acargo_materias] FOREIGN KEY([materia])
REFERENCES [dbo].[materias] ([nombre])
GO
ALTER TABLE [dbo].[grupos_acargo] CHECK CONSTRAINT [FK_grupos_acargo_materias]
GO
ALTER TABLE [dbo].[grupos_acargo]  WITH CHECK ADD  CONSTRAINT [FK_grupos_acargo_usuarios] FOREIGN KEY([idUsuario])
REFERENCES [dbo].[usuarios] ([id])
GO
ALTER TABLE [dbo].[grupos_acargo] CHECK CONSTRAINT [FK_grupos_acargo_usuarios]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'grupos_acargo', @level2type=N'COLUMN',@level2name=N'id_grupo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'grupos_acargo', @level2type=N'COLUMN',@level2name=N'programa'
GO

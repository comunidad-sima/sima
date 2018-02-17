USE [bd_sima]
GO
/****** Object:  Table [dbo].[estudiantes_asistentes]    Script Date: 9/02/2018 10:08:19 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[estudiantes_asistentes](
	[estudiante_id] [varchar](12) NOT NULL,
	[clase_id] [int] NOT NULL,
	[id] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[estudiantes_asistentes]  WITH CHECK ADD  CONSTRAINT [FK_estudiantes_asistentes_clases_sima] FOREIGN KEY([clase_id])
REFERENCES [dbo].[clases_sima] ([id])
GO
ALTER TABLE [dbo].[estudiantes_asistentes] CHECK CONSTRAINT [FK_estudiantes_asistentes_clases_sima]
GO

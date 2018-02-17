USE [bd_sima]
GO
/****** Object:  Table [dbo].[usuarios]    Script Date: 9/02/2018 10:08:19 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[usuarios](
	[id] [varchar](12) NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[apellidos] [varchar](60) NOT NULL,
	[correo] [varchar](50) NOT NULL,
	[celular] [varchar](12) NULL,
	[tipo] [varchar](15) NULL,
	[contrasena] [varchar](100) NOT NULL,
	[fecha_registro] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[usuarios] ADD  DEFAULT (NULL) FOR [celular]
GO
ALTER TABLE [dbo].[usuarios] ADD  DEFAULT (NULL) FOR [tipo]
GO

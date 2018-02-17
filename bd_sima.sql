USE [master]
GO
/****** Object:  Database [bd_sima]    Script Date: 4/02/2018 1:17:14 p.m. ******/
CREATE DATABASE [bd_sima]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'bd_sima', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\bd_sima.mdf' , SIZE = 4160KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'bd_sima_log', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\bd_sima_log.ldf' , SIZE = 1040KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [bd_sima] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [bd_sima].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [bd_sima] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [bd_sima] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [bd_sima] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [bd_sima] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [bd_sima] SET ARITHABORT OFF 
GO
ALTER DATABASE [bd_sima] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [bd_sima] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [bd_sima] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [bd_sima] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [bd_sima] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [bd_sima] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [bd_sima] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [bd_sima] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [bd_sima] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [bd_sima] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [bd_sima] SET  ENABLE_BROKER 
GO
ALTER DATABASE [bd_sima] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [bd_sima] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [bd_sima] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [bd_sima] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [bd_sima] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [bd_sima] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [bd_sima] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [bd_sima] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [bd_sima] SET  MULTI_USER 
GO
ALTER DATABASE [bd_sima] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [bd_sima] SET DB_CHAINING OFF 
GO
ALTER DATABASE [bd_sima] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [bd_sima] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [bd_sima]
GO
/****** Object:  Table [dbo].[capacitaciones]    Script Date: 4/02/2018 1:17:14 p.m. ******/
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
/****** Object:  Table [dbo].[clases_sima]    Script Date: 4/02/2018 1:17:14 p.m. ******/
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
/****** Object:  Table [dbo].[configuraciones]    Script Date: 4/02/2018 1:17:14 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[configuraciones](
	[periodo_actual] [nchar](6) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cursos]    Script Date: 4/02/2018 1:17:14 p.m. ******/
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
/****** Object:  Table [dbo].[estudiantes_asistentes]    Script Date: 4/02/2018 1:17:14 p.m. ******/
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
/****** Object:  Table [dbo].[grupos_acargo]    Script Date: 4/02/2018 1:17:14 p.m. ******/
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
	[id_grupo] [int] NOT NULL,
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
/****** Object:  Table [dbo].[materias]    Script Date: 4/02/2018 1:17:14 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[materias](
	[nombre] [varchar](90) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[usuarios]    Script Date: 4/02/2018 1:17:14 p.m. ******/
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
SET IDENTITY_INSERT [dbo].[capacitaciones] ON 

INSERT [dbo].[capacitaciones] ([id], [periodo], [encargado], [tema], [comentarios], [fecha], [nom_File]) VALUES (6, N'2017-2', N'pedro tovar', N'dsff', N'sefewr', CAST(0xA33D0B00 AS Date), N'evid_2017-12-15 11-37-35-99.jpg')
INSERT [dbo].[capacitaciones] ([id], [periodo], [encargado], [tema], [comentarios], [fecha], [nom_File]) VALUES (7, N'2017-2', N'pedro tovar', N'dsff', N'sefewr', CAST(0xA33D0B00 AS Date), N'evid_2017-12-15 11-37-36-65.jpg')
SET IDENTITY_INSERT [dbo].[capacitaciones] OFF
SET IDENTITY_INSERT [dbo].[clases_sima] ON 

INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (1, CAST(0xA63D0B00 AS Date), N'2017-2', N'23', NULL, 2, N'1102232026', N'-', CAST(0xAB3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (2, CAST(0xA63D0B00 AS Date), N'2017-2', N'4454', N'55', 2, N'1102232026', N'evid_2017-12-16 13-22-07-32.jpg', CAST(0xE53C0B00 AS Date))
SET IDENTITY_INSERT [dbo].[clases_sima] OFF
SET IDENTITY_INSERT [dbo].[cursos] ON 

INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario]) VALUES (2, N'2017-2', N'MATEMATICA BASICA', 1, CAST(0xB43D0B00 AS Date), N'1234')
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario]) VALUES (7, N'2017-2', N'TALLER DE LENGUA I', 1, CAST(0xB43D0B00 AS Date), N'1234')
SET IDENTITY_INSERT [dbo].[cursos] OFF
INSERT [dbo].[materias] ([nombre]) VALUES (N'LOGICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MATEMATICA BASICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TALLER DE LENGUA I')
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro]) VALUES (N'1102232026', N'fredy', N'frt', N'343', N'2324', N'Administrador', N'QwBlAGMAYQByADEAMgAzAA==', CAST(0x493C0B00 AS Date))
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro]) VALUES (N'1232344', N'DDFDFDF', N'TERT', N'FREDYS.VERGARA@CECAR.EDU', N'3042457611', N'Monitor', N'QwBlAGMAYQByADEAMgAzAA==', CAST(0xA83D0B00 AS Date))
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro]) VALUES (N'1234', N'PEDRO', N'MARTINEZ', N'VVV@GMAIL.CO', N'1123', N'Monitor', N'QwBlAGMAYQByADEAMgAzAA==', CAST(0x493C0B00 AS Date))
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro]) VALUES (N'35345', N'34535', N'345345', N'FREDYS.VERGARA@CECAR.EDU.CO', N'3042457611', N'Monitor', N'QwBlAGMAYQByADEAMgAzAA==', CAST(0xA83D0B00 AS Date))
ALTER TABLE [dbo].[capacitaciones] ADD  DEFAULT (NULL) FOR [comentarios]
GO
ALTER TABLE [dbo].[clases_sima] ADD  DEFAULT (NULL) FOR [comentario]
GO
ALTER TABLE [dbo].[usuarios] ADD  DEFAULT (NULL) FOR [celular]
GO
ALTER TABLE [dbo].[usuarios] ADD  DEFAULT (NULL) FOR [tipo]
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
ALTER TABLE [dbo].[estudiantes_asistentes]  WITH CHECK ADD  CONSTRAINT [FK_estudiantes_asistentes_clases_sima] FOREIGN KEY([clase_id])
REFERENCES [dbo].[clases_sima] ([id])
GO
ALTER TABLE [dbo].[estudiantes_asistentes] CHECK CONSTRAINT [FK_estudiantes_asistentes_clases_sima]
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
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'grupos_acargo', @level2type=N'COLUMN',@level2name=N'programa'
GO
USE [master]
GO
ALTER DATABASE [bd_sima] SET  READ_WRITE 
GO

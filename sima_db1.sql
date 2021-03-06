USE [bd_sima]
GO
/****** Object:  StoredProcedure [dbo].[SP_Cantida_Uasuario_Responden_Test]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fredys Vergara
-- Create date: 25/04/2018
-- Description:	consulta la canidad de usurios que han respondido un test si curso es negativo se consulta el test en general, de lo contrario solo se filtra por el curso
-- =============================================
CREATE  PROCEDURE [dbo].[SP_Cantida_Uasuario_Responden_Test] 	
	@id_curso int, 
	@id_test int
	
AS

BEGIN

	if (@id_curso > 0)
			BEGIN
             SELECT count( DISTINCT( r.id_persona)) as cantidad from (Test as t
			  join  pregunta_test_responder as p on t.id=p.id_test)
               join respuestas as r on p.id=r.id_preguntas_test_respustas
			   join preguntas_test as pt on  p.id_pregunta_test =pt.id
			   where(t.id= @id_test  and r.id_curso= @id_curso)
           END
     else
			BEGIN
                select  count( DISTINCT( r.id_persona)) as cantidad from (Test as t
			  join  pregunta_test_responder as p on t.id=p.id_test)
               join respuestas as r on p.id=r.id_preguntas_test_respustas
			   join preguntas_test as pt on  p.id_pregunta_test =pt.id
			    where(t.id= @id_test)
			END   
END
GO
/****** Object:  StoredProcedure [dbo].[SP_cantidad_asistencia]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fredys Vergara
-- Create date: 
-- Description:	Consulta la cantidad de asitencia que tiene un estudiante en un periodo
-- =============================================
CREATE PROCEDURE [dbo].[SP_cantidad_asistencia] 	
	@id_estudiante varchar(12),
	@periodo varchar(6)
	
AS
BEGIN
	

	SELECT COUNT(c.id) as cantidad FROM  clases_sima c INNER JOIN  estudiantes_asistentes e on c.id = e.clase_id                         
                         where (c.periodo = @periodo AND e.estudiante_id =@id_estudiante)
	
            
END
GO
/****** Object:  StoredProcedure [dbo].[SP_cantidad_asistencia_curso]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fredys Vergara
-- Create date: 
-- Description:	Consulta la cantidad de asitencia que tiene un estudiante en un periodo
-- =============================================
create PROCEDURE [dbo].[SP_cantidad_asistencia_curso] 	
	@id_estudiante varchar(12),
	@id_curso int
	
AS
BEGIN
	

	SELECT COUNT(c.id) as cantidad FROM  clases_sima c INNER JOIN  estudiantes_asistentes e on c.id = e.clase_id                         
                            where (c.cursos_id=@id_curso and e.estudiante_id=@id_estudiante)
            
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Clase_sima_id]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fredys Vergara
-- Create date: 25/04/2018
-- Description:	consulta una clase
-- =============================================
create  PROCEDURE [dbo].[SP_Clase_sima_id] 	
	@id int
	
AS

BEGIN
	SELECT* FROM	clases_sima
	WHERE id=@id
            
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Clases_Monitor_Periodo]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fredys Vergara
-- Create date: 25/04/2018
-- Description:	consulta solo los datos de las clases de un monitor en un periodo
-- =============================================
CREATE  PROCEDURE [dbo].[SP_Clases_Monitor_Periodo] 	
	
	@id_usuario varchar(12),
	@periodo varchar(12),
	@materia varchar(90),
	@topoFiltro int
	
AS

BEGIN
--- se selecciona lo grupos el nombre y la materia inicien por los paramtros
if(@topoFiltro=0)
	select * from clases_sima c join cursos cu on c.cursos_id=cu.id 

                         where c.periodo = @periodo AND c.usuarios_id like @id_usuario+'%' and
						  cu.nombre_materia like @materia+'%'
if(@topoFiltro=1)
            select * from clases_sima c join cursos cu on c.cursos_id=cu.id 

                         where c.periodo = @periodo AND c.usuarios_id like @id_usuario+'%' and
						  cu.nombre_materia = @materia
if(@topoFiltro=2)
            select * from clases_sima c join cursos cu on c.cursos_id=cu.id 

                         where c.periodo = @periodo AND c.usuarios_id = @id_usuario and
						  cu.nombre_materia = @materia
if(@topoFiltro=3)
            select * from clases_sima c join cursos cu on c.cursos_id=cu.id 

                         where c.periodo = @periodo AND c.usuarios_id = @id_usuario and
						  cu.nombre_materia like @materia+'%'
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Cometarios_Preguntas_Abierta_Test]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fredys Vergara
-- Create date: 25/04/2018
-- Description:	Consulta las preguntas de tipo abierta con sus cometarios de un test
-- =============================================
CREATE  PROCEDURE [dbo].[SP_Cometarios_Preguntas_Abierta_Test] 	
	@id_curso int, 
	@id_test int
	
AS

BEGIN

	if (@id_curso > 0)
			BEGIN

             SELECT p.id_pregunta_test,  r.observacion  FROM (Test as t
			  join  pregunta_test_responder as p on t.id=p.id_test)
               join respuestas as r on p.id=r.id_preguntas_test_respustas
			   join preguntas_test as pt on  p.id_pregunta_test =pt.id
			   WHERE(t.id= @id_test  and r.id_curso= @id_curso and pt.tipo='Abierta')
           END
     else
			BEGIN
                SELECT  p.id_pregunta_test,  r.observacion FROM (Test as t
			  join  pregunta_test_responder as p on t.id=p.id_test)
               join respuestas as r on p.id=r.id_preguntas_test_respustas
			   join preguntas_test as pt on  p.id_pregunta_test =pt.id
			    WHERE(t.id= @id_test and pt.tipo='Abierta')
			END   
END
GO
/****** Object:  StoredProcedure [dbo].[SP_ConsultarAsistencia]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		fredys
-- Create date: 20/04/2018
-- Description:	consulta las asistencias de los estudinates en una asignatura en un periodo
-- =============================================
create PROCEDURE [dbo].[SP_ConsultarAsistencia] 	
										@periodo varchar(6),
										@materia varchar(90)
AS
BEGIN
	SELECT	COUNT(e.estudiante_id) as cantidad,
			e.estudiante_id
    FROM	cursos as c, 
			clases_sima as cl, 
			estudiantes_asistentes as e 
	WHERE 
            c.id=cl.cursos_id and cl.id=e.clase_id and  c.periodo =@periodo and  
            c.nombre_materia= @materia GROUP BY e.estudiante_id
END


GO
/****** Object:  StoredProcedure [dbo].[SP_Curso_acargo_activos]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fredys Vergara
-- Create date: 25/04/2018
-- Description:	consulta los cursos que tiene un monitor activos(1) en un periodo
-- =============================================
CREATE  PROCEDURE [dbo].[SP_Curso_acargo_activos] 	
	@periodo varchar(6), 
	@id_monitor varchar(12)
	
AS

BEGIN
	SELECT* FROM	cursos
	WHERE periodo=@periodo and idUsuario = @id_monitor and eliminado=0 and estado=1
            
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Curso_id]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fredys Vergara
-- Create date: 
-- Description:	cosulta un curso por el id
-- =============================================


CREATE  PROCEDURE [dbo].[SP_Curso_id] 	
	
	@id int
	
	
AS

BEGIN
SELECT * FROM	cursos
			WHERE id=@id           
	
            
END

GO
/****** Object:  StoredProcedure [dbo].[SP_Curso_materia]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fredys Vergara
-- Create date: 25/04/2018
-- Description:	Esta funcion consulta los grupos exactos de un perido y una meteria
-- =============================================
create  PROCEDURE [dbo].[SP_Curso_materia] 	
	@periodo varchar(6), 
	@materia varchar(90)
	
AS

BEGIN
	SELECT* FROM	cursos
	where (nombre_materia = @materia AND periodo =@periodo AND eliminado = 0)
            
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Curso_por_materia_periodo_idusuario]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fredys Vergara
-- Create date: 
-- Description:	Esta funcion consulta el id de un curso a partir de la materia, periodo e id del monito
-- =============================================

CREATE  PROCEDURE [dbo].[SP_Curso_por_materia_periodo_idusuario] 	
	@periodo varchar(6), 
	@id_monitor varchar(12),
	@materia varchar(90)
	
AS

BEGIN
	SELECT top(1) cursos.id  FROM	cursos
	WHERE periodo=@periodo and idUsuario = @id_monitor and nombre_materia=@materia
            
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Cursos]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fredys Vergara
-- Create date: 25/04/2018
-- Description:	consulta un los grupos que de un periodo q la materia por un nombre 
-- =============================================
create  PROCEDURE [dbo].[SP_Cursos] 	
	@periodo varchar(6), 
	@materia varchar(90)
	
AS

BEGIN
	SELECT* FROM	cursos
	 where (nombre_materia LIKE @materia+'%' AND periodo =periodo AND eliminado=0)
            
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Cursos_por_clase]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fredys Vergara
-- Create date: 
-- Description:	Consulta los curso donde el estudiante ha asitido a monitoria, es decir donde tiene una clase registrada 
-- =============================================
CREATE PROCEDURE [dbo].[SP_Cursos_por_clase] 	
	@periodo varchar(6),
	@id_estudiante varchar(12)
	
AS
BEGIN
	

	SELECT Distinct(cu.id) as id, cu.eliminado,cu.estado,cu.fecha_finalizacion,cu.idUsuario,cu.nombre_materia
	,cu.periodo  FROM  clases_sima c
                              join cursos cu on c.cursos_id = cu.id
                              join estudiantes_asistentes e on c.id = e.clase_id

                              where (c.periodo = @periodo and e.estudiante_id = @id_estudiante)
                             
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Estudiantes_asistentes]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fredys Vergara
-- Create date: 25/04/2018
-- Description:	consulta una los estudiantes que asisten a una clase
-- =============================================
create  PROCEDURE [dbo].[SP_Estudiantes_asistentes] 	
	@clase_id int
	
AS

BEGIN
	SELECT * FROM	estudiantes_asistentes
	WHERE clase_id=@clase_id
            
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Materia_monitor_cargo]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fredys Vergara
-- Create date: 
-- Description:	Esta funcion consulta los nombres de las materia que se le a asignado a un monitor en un periodo ,si todo es 0 retorna todas las materias 
-- si todo es 1 solo retorna las materias que el grupo este abierto
-- =============================================


CREATE  PROCEDURE [dbo].[SP_Materia_monitor_cargo] 	
	@periodo varchar(6), 
	@id_monitor varchar(12),
	@todo int
	
	
AS

BEGIN
	if(@todo=0)
		BEGIN
			SELECT  nombre_materia  FROM	cursos
			WHERE periodo=@periodo and idUsuario = @id_monitor and estado=1 and eliminado=0
            
		END
	else
		  BEGIN
			SELECT  nombre_materia  FROM	cursos
			WHERE periodo=@periodo and idUsuario = @id_monitor and eliminado=0
            
		END
            
END

GO
/****** Object:  StoredProcedure [dbo].[SP_materioa_por_id_curso]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fredys Vergara
-- Create date: 25/04/2018
-- Description:	consulta una los estudiantes que asisten a una clase
-- =============================================
create  PROCEDURE [dbo].[SP_materioa_por_id_curso] 	
	@curso_id int
	
AS

BEGIN
	SELECT cursos.nombre_materia FROM	cursos
	WHERE id=@curso_id
            
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Monitores]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fredys Vergara
-- Create date: 
-- Description:	consulta los datos de los monitores por el nombre o id
-- =============================================
CREATE PROCEDURE [dbo].[SP_Monitores] 	
	@filtro varchar(100),
	@tipo varchar(15)
	
AS
BEGIN
	SELECT TOP(20)	* FROM	usuarios
	WHERE  (((CONCAT(nombre,'',apellidos) LIKE '%'+@filtro+'%') OR  (CONCAT(apellidos,'',nombre) LIKE '%'+@filtro+'%') 
	OR  (nombre LIKE @filtro+'%') OR  (apellidos LIKE @filtro+'%') OR  (id LIKE @filtro+'%'))
	AND eliminado=0 AND tipo=@tipo)
	
            
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Monitores_de_materia]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fredys Vergara
-- Create date: 
-- Description:	consulta los datos de los monitores por el nombre o id
-- =============================================
CREATE PROCEDURE [dbo].[SP_Monitores_de_materia] 	
	@materia varchar(90),
	@periodo varchar(6)
AS
BEGIN
	SELECT u.id, u.apellidos ,u.celular, u.contrasena, u.correo, u.eliminado,
	 u.fecha_registro, u.nombre, u.tipo  FROM	usuarios as u  INNER JOIN cursos as c ON c.idUsuario = u.id 
	WHERE  c.nombre_materia=@materia and c.periodo=@periodo and u.eliminado=0
	
            
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Pregunta_Puntos_Total]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fredys Vergar
-- Create date: 
-- Description:	Se consulta las preguntas de un test con los puntos obtenidos por los votantes. solo las preguntas de tipo cerrada
-- =============================================
CREATE   PROCEDURE [dbo].[SP_Pregunta_Puntos_Total] 	
	@id_curso int  , 
	@id_test int
	
AS

BEGIN
	if(@id_curso>0)
		BEGIN
			select  p.id_pregunta_test,  SUM(r.punto) as puntos from Test as t, 
                pregunta_test_responder as p, respuestas as r ,preguntas_test as pt 
                where(t.id=p.id_test and p.id = r.id_preguntas_test_respustas and 
                 p.id_pregunta_test =pt.id and t.id= @id_test and r.id_curso= @id_curso and pt.tipo= 'Cerrada' ) 
                GROUP BY  p.id_pregunta_test
		END
		else
		  BEGIN
			select  p.id_pregunta_test,  SUM(r.punto)  as puntos from Test as t, 
                pregunta_test_responder as p, respuestas as r , preguntas_test as pt
                where(t.id=p.id_test and p.id = r.id_preguntas_test_respustas and
                 p.id_pregunta_test =pt.id and t.id= @id_test  and pt.tipo= 'Cerrada' )
                 GROUP BY  p.id_pregunta_test
			
			END
            
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Pregunta_Test]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fredys Vergara
-- Create date: 25/04/2018
-- Description:	Consulta las preguntas de un test
-- =============================================
CREATE  PROCEDURE [dbo].[SP_Pregunta_Test] 	
	 
	@id_test int
	
AS

BEGIN
SELECT  p.eliminado,p.id,p.Pregunata,p.tipo from Test t join pregunta_test_responder pr on t.id = pr.id_test
                         join preguntas_test p on pr.id_pregunta_test = p.id
                         where (t.id = @id_test )
                         order by (p.tipo) 
        
END
GO
/****** Object:  StoredProcedure [dbo].[SP_preguntas]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fredys Vergara
-- Create date: 25/04/2018
-- Description:	consulta las preguntas registradas que se pueden asignar a un test
-- =============================================
create  PROCEDURE [dbo].[SP_preguntas] 	
	
	@eliminado tinyint
	
AS

BEGIN
	select* from preguntas_test
                where eliminado = @eliminado
            
END
GO
/****** Object:  StoredProcedure [dbo].[SP_preguntas_por_id]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fredys Vergara
-- Create date: 25/04/2018
-- Description:	consulta una pregunta por el id
-- =============================================
CREATE  PROCEDURE [dbo].[SP_preguntas_por_id] 	
	
	@id_pregunta int
	
AS

BEGIN
	select * from preguntas_test
                where id = @id_pregunta
            
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Respondio_test]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fredys Vergar
-- Create date: 
-- Description:	Consulta  la cantidad de preguntas respondida por un ususrio a test
-- =============================================
CREATE   PROCEDURE [dbo].[SP_Respondio_test] 	
	@id_curso int  , 
	@id_test int,
	@id_usuario varchar(12)
	
AS

BEGIN
	SELECT 1 FROM ((Test t INNER JOIN  pregunta_test_responder p  on t.id = p.id_test )
                            INNER JOIN  respuestas r  on p.id = r.id_preguntas_test_respustas)
	WHERE (t.id =@id_test and r.id_persona=@id_usuario and r.id_curso=@id_curso)    

	
            
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Test]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fredys Vergara
-- Create date: 25/04/2018
-- Description:	Consulta un tes por el id
-- =============================================
create  PROCEDURE [dbo].[SP_Test] 	
	 
	@id_test int
	
AS

BEGIN
SELECT  *from Test where(id=@id_test) 
        
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Test_periodo]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fredys Vergara
-- Create date: 25/04/2018
-- Description:	consulta los test de un periodo
-- =============================================
CREATE  PROCEDURE [dbo].[SP_Test_periodo] 	
	 
	@periodo varchar(6),
	@estado_cierre tinyint ,
	@eliminado tinyint
	
AS

BEGIN
SELECT  *from Test 
where (periodo LIKE @periodo+'%' and eliminado = @eliminado and estado_cierre = @estado_cierre)
        
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Tiene_curso]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fredys Vergara
-- Create date: 25/04/2018
-- Description:	cosulta los curoso que tiene un monitor filtrado por materia y perido y/o estado
-- =============================================
CREATE  PROCEDURE [dbo].[SP_Tiene_curso] 	
	@periodo varchar(6), 
	@materia varchar(90),
	@id_usuario varchar(12)
	
AS

BEGIN
	SELECT* FROM	cursos
	 where (nombre_materia = @materia AND periodo =@periodo AND idUsuario= @id_usuario AND eliminado=0 )
                              OR (nombre_materia =@materia AND  idUsuario =@id_usuario AND estado = 1 AND eliminado = 0)
            
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Tiene_curso_activo]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fredys Vergara
-- Create date: 25/04/2018
-- Description:	cosulta si un curoso que tiene un monitor activos
-- =============================================
create  PROCEDURE [dbo].[SP_Tiene_curso_activo] 	
	
	@id_usuario varchar(12)
	
AS

BEGIN
	SELECT 1 FROM	cursos
	 where ( idUsuario =@id_usuario AND estado = 1 AND eliminado = 0)
            
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Usuario_id]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fredys
-- Create date: 
-- Description:	Consulta los datos de un ususrio por el id
-- =============================================
CREATE PROCEDURE [dbo].[SP_Usuario_id] 	
	@id varchar(12)
	
AS
BEGIN
	SELECT * FROM	usuarios
	WHERE id=@id
	
            
END

GO
/****** Object:  StoredProcedure [dbo].[SP_Usuarios]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fredys vergara
-- Create date: 20/04/2018
-- Description:	Consulta los datos de los ususrios filtrados por nombre o  id que no esten eliminado
-- =============================================
CREATE PROCEDURE [dbo].[SP_Usuarios] 	
	@filtro varchar(100)
	
AS
BEGIN
	SELECT TOP(20)	* FROM	usuarios
	WHERE  (((CONCAT(nombre,'',apellidos) LIKE '%'+@filtro+'%') OR  (CONCAT(apellidos,'',nombre) LIKE '%'+@filtro+'%') 
	OR  (nombre LIKE @filtro+'%') OR  (apellidos LIKE @filtro+'%') OR  (id LIKE @filtro+'%'))
	AND eliminado=0)
	
            
END



GO
/****** Object:  StoredProcedure [dbo].[SP_Usuarios_eliminado]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create  PROCEDURE [dbo].[SP_Usuarios_eliminado] 	
	@eliminado tinyint
	
AS

BEGIN
	SELECT* FROM	usuarios
	WHERE eliminado=@eliminado
            
END
GO
/****** Object:  Table [dbo].[Alertas]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Alertas](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[vista] [tinyint] NOT NULL,
	[eliminada] [tinyint] NOT NULL,
	[mensaje] [varchar](300) NOT NULL,
	[tipo_alerta] [varchar](50) NOT NULL,
	[fecha_creada] [datetime] NOT NULL,
	[creador] [varchar](20) NOT NULL,
	[perfil_ver] [varchar](20) NOT NULL,
	[titulo] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Alertas] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[calificaciones_periodo]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[calificaciones_periodo](
	[id_docente] [varchar](12) NOT NULL,
	[corte] [int] NOT NULL,
	[periodo] [varchar](6) NOT NULL,
	[fecha_registro] [datetime] NOT NULL,
	[asignatura] [varchar](90) NOT NULL,
	[grupo] [nchar](10) NOT NULL,
	[programa] [nchar](90) NOT NULL,
	[id] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[capacitaciones]    Script Date: 20/05/2018 3:00:04 p.m. ******/
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
/****** Object:  Table [dbo].[clases_sima]    Script Date: 20/05/2018 3:00:04 p.m. ******/
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
/****** Object:  Table [dbo].[configuracion_app]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[configuracion_app](
	[id] [int] NOT NULL,
	[periodo_actual] [varchar](6) NOT NULL,
	[contrasena_defecto_usuario] [varchar](40) NOT NULL,
	[alertas] [tinyint] NOT NULL,
 CONSTRAINT [PK_configuracion_app] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[cursos]    Script Date: 20/05/2018 3:00:04 p.m. ******/
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
	[eliminado] [tinyint] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[estudiantes_asistentes]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[estudiantes_asistentes](
	[estudiante_id] [varchar](12) NOT NULL,
	[clase_id] [int] NOT NULL,
 CONSTRAINT [PK_estudiantes_asistentes] PRIMARY KEY CLUSTERED 
(
	[estudiante_id] ASC,
	[clase_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[grupos_acargo]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[grupos_acargo](
	[idUsuario] [varchar](12) NOT NULL,
	[materia] [varchar](90) NOT NULL,
	[periodo] [varchar](6) NOT NULL,
	[id_grupo] [varchar](10) NOT NULL,
	[id_curso] [int] NOT NULL,
	[programa] [varchar](100) NOT NULL,
 CONSTRAINT [PK_grupos_acargo] PRIMARY KEY CLUSTERED 
(
	[idUsuario] ASC,
	[materia] ASC,
	[periodo] ASC,
	[id_grupo] ASC,
	[id_curso] ASC,
	[programa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[materias]    Script Date: 20/05/2018 3:00:04 p.m. ******/
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
/****** Object:  Table [dbo].[Notas]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Notas](
	[valor] [float] NOT NULL,
	[id_calificaciones_periodo] [int] NOT NULL,
	[tipo] [varchar](50) NOT NULL,
	[id_estudiante] [varchar](12) NOT NULL,
	[id] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_Notas] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[pregunta_test_responder]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pregunta_test_responder](
	[id_test] [int] NOT NULL,
	[id_pregunta_test] [int] NOT NULL,
	[id] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_pregunta_test_responder] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[preguntas_test]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[preguntas_test](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Pregunata] [varchar](700) NOT NULL,
	[eliminado] [tinyint] NOT NULL,
	[tipo] [varchar](20) NOT NULL,
 CONSTRAINT [PK_preguntas_test] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[respuestas]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[respuestas](
	[id_preguntas_test_respustas] [int] NOT NULL,
	[id_persona] [varchar](12) NOT NULL,
	[punto] [int] NOT NULL,
	[observacion] [nchar](180) NULL,
	[id_curso] [int] NOT NULL,
 CONSTRAINT [PK_respuestas] PRIMARY KEY CLUSTERED 
(
	[id_preguntas_test_respustas] ASC,
	[id_persona] ASC,
	[id_curso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Test]    Script Date: 20/05/2018 3:00:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Test](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[fecha_fin] [date] NOT NULL,
	[fecha_inicio] [date] NOT NULL,
	[ferfil_usuario] [varchar](30) NOT NULL,
	[eliminado] [tinyint] NOT NULL,
	[estado_cierre] [tinyint] NOT NULL,
	[id_usuario_creado] [varchar](12) NOT NULL,
	[periodo] [varchar](7) NOT NULL,
 CONSTRAINT [PK_Test] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[usuarios]    Script Date: 20/05/2018 3:00:04 p.m. ******/
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
	[eliminado] [tinyint] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[Alertas] ON 

INSERT [dbo].[Alertas] ([id], [vista], [eliminada], [mensaje], [tipo_alerta], [fecha_creada], [creador], [perfil_ver], [titulo]) VALUES (2, 0, 0, N'prueba mensaje', N'NUEVA NOTA               ', CAST(0x0000A8B00110B2F0 AS DateTime), N'1102232026          ', N'Docente', N'registro de nota')
INSERT [dbo].[Alertas] ([id], [vista], [eliminada], [mensaje], [tipo_alerta], [fecha_creada], [creador], [perfil_ver], [titulo]) VALUES (3, 0, 0, N'prueba mensaje', N'NUEVA NOTA               ', CAST(0x0000A8B00110B2F0 AS DateTime), N'1102232026          ', N'Docente', N'registro de nota')
INSERT [dbo].[Alertas] ([id], [vista], [eliminada], [mensaje], [tipo_alerta], [fecha_creada], [creador], [perfil_ver], [titulo]) VALUES (4, 0, 0, N'prueba mensaje', N'NUEVA NOTA               ', CAST(0x0000A8B00110B2F0 AS DateTime), N'1102232026          ', N'Docente', N'registro de nota')
INSERT [dbo].[Alertas] ([id], [vista], [eliminada], [mensaje], [tipo_alerta], [fecha_creada], [creador], [perfil_ver], [titulo]) VALUES (5, 0, 0, N'prueba mensaje', N'NUEVA NOTA               ', CAST(0x0000A8B00110B2F0 AS DateTime), N'1102232026          ', N'Administrador', N'registro de nota')
INSERT [dbo].[Alertas] ([id], [vista], [eliminada], [mensaje], [tipo_alerta], [fecha_creada], [creador], [perfil_ver], [titulo]) VALUES (6, 0, 0, N'prueba mensaje', N'NUEVA NOTA               ', CAST(0x0000A8B00110B2F0 AS DateTime), N'1102232026          ', N'Estudiante', N'registro de nota')
INSERT [dbo].[Alertas] ([id], [vista], [eliminada], [mensaje], [tipo_alerta], [fecha_creada], [creador], [perfil_ver], [titulo]) VALUES (8, 0, 0, N'Actualización de calificaciones del estudiante ', N'Notas', CAST(0x0000A8B0012A5D19 AS DateTime), N'SIMA', N'Administrador', N'CALIFICACIONES MATEMATICA BASICA')
INSERT [dbo].[Alertas] ([id], [vista], [eliminada], [mensaje], [tipo_alerta], [fecha_creada], [creador], [perfil_ver], [titulo]) VALUES (9, 0, 0, N'Actualización de calificaciones del estudiante ', N'Notas', CAST(0x0000A8B0012B3959 AS DateTime), N'SIMA', N'Administrador', N'CALIFICACIONES MATEMATICA BASICA')
INSERT [dbo].[Alertas] ([id], [vista], [eliminada], [mensaje], [tipo_alerta], [fecha_creada], [creador], [perfil_ver], [titulo]) VALUES (10, 0, 0, N'Actualización de calificaciones del estudiante ', N'Notas', CAST(0x0000A8B0012B44A2 AS DateTime), N'SIMA', N'Administrador', N'CALIFICACIONES MATEMATICA BASICA')
INSERT [dbo].[Alertas] ([id], [vista], [eliminada], [mensaje], [tipo_alerta], [fecha_creada], [creador], [perfil_ver], [titulo]) VALUES (11, 0, 0, N'Actualización de calificaciones del estudiante ', N'Notas', CAST(0x0000A8B100EF6CDC AS DateTime), N'SIMA', N'Administrador', N'CALIFICACIONES MATEMATICA BASICA')
INSERT [dbo].[Alertas] ([id], [vista], [eliminada], [mensaje], [tipo_alerta], [fecha_creada], [creador], [perfil_ver], [titulo]) VALUES (12, 0, 0, N'Actualización de calificaciones del estudiante ', N'Notas', CAST(0x0000A8B100FB38B7 AS DateTime), N'SIMA', N'Administrador', N'CALIFICACIONES MATEMATICA BASICA')
INSERT [dbo].[Alertas] ([id], [vista], [eliminada], [mensaje], [tipo_alerta], [fecha_creada], [creador], [perfil_ver], [titulo]) VALUES (13, 0, 0, N'Actualización de calificaciones del estudiante ', N'Notas', CAST(0x0000A8B100FB48EA AS DateTime), N'SIMA', N'Administrador', N'CALIFICACIONES MATEMATICA BASICA')
INSERT [dbo].[Alertas] ([id], [vista], [eliminada], [mensaje], [tipo_alerta], [fecha_creada], [creador], [perfil_ver], [titulo]) VALUES (14, 0, 0, N'Actualización de calificaciones del estudiante ', N'Notas', CAST(0x0000A8B100FB6C5F AS DateTime), N'SIMA', N'Administrador', N'CALIFICACIONES MATEMATICA BASICA')
INSERT [dbo].[Alertas] ([id], [vista], [eliminada], [mensaje], [tipo_alerta], [fecha_creada], [creador], [perfil_ver], [titulo]) VALUES (15, 0, 0, N'Actualización de calificaciones del estudiante ', N'Notas', CAST(0x0000A8B100FBB31C AS DateTime), N'SIMA', N'Administrador', N'CALIFICACIONES MATEMATICA BASICA')
INSERT [dbo].[Alertas] ([id], [vista], [eliminada], [mensaje], [tipo_alerta], [fecha_creada], [creador], [perfil_ver], [titulo]) VALUES (16, 0, 0, N'Actualización de calificaciones del estudiante ', N'Notas', CAST(0x0000A8B10102BA3F AS DateTime), N'SIMA', N'Administrador', N'CALIFICACIONES MATEMATICA BASICA')
INSERT [dbo].[Alertas] ([id], [vista], [eliminada], [mensaje], [tipo_alerta], [fecha_creada], [creador], [perfil_ver], [titulo]) VALUES (17, 0, 0, N'Actualización de calificaciones del estudiante ', N'Notas', CAST(0x0000A8B10102DE89 AS DateTime), N'SIMA', N'Administrador', N'CALIFICACIONES MATEMATICA BASICA')
INSERT [dbo].[Alertas] ([id], [vista], [eliminada], [mensaje], [tipo_alerta], [fecha_creada], [creador], [perfil_ver], [titulo]) VALUES (18, 0, 0, N'Actualización de calificaciones del estudiante ', N'Notas', CAST(0x0000A8B101034AFB AS DateTime), N'SIMA', N'Administrador', N'CALIFICACIONES MATEMATICA BASICA')
INSERT [dbo].[Alertas] ([id], [vista], [eliminada], [mensaje], [tipo_alerta], [fecha_creada], [creador], [perfil_ver], [titulo]) VALUES (19, 0, 0, N'Actualización de calificaciones del estudiante ', N'Notas', CAST(0x0000A8B101046413 AS DateTime), N'SIMA', N'Administrador', N'CALIFICACIONES MATEMATICA BASICA')
INSERT [dbo].[Alertas] ([id], [vista], [eliminada], [mensaje], [tipo_alerta], [fecha_creada], [creador], [perfil_ver], [titulo]) VALUES (20, 0, 0, N'Actualización de calificaciones del estudiante ', N'Notas', CAST(0x0000A8B10112E4A0 AS DateTime), N'SIMA', N'Administrador', N'CALIFICACIONES MATEMATICA BASICA')
INSERT [dbo].[Alertas] ([id], [vista], [eliminada], [mensaje], [tipo_alerta], [fecha_creada], [creador], [perfil_ver], [titulo]) VALUES (21, 0, 0, N'Actualización de calificaciones del estudiante ', N'Notas', CAST(0x0000A8B10113BDD9 AS DateTime), N'SIMA', N'Administrador', N'CALIFICACIONES MATEMATICA BASICA')
INSERT [dbo].[Alertas] ([id], [vista], [eliminada], [mensaje], [tipo_alerta], [fecha_creada], [creador], [perfil_ver], [titulo]) VALUES (22, 0, 0, N'Actualización de calificaciones del estudiante ', N'Notas', CAST(0x0000A8B1011A1A90 AS DateTime), N'SIMA', N'Administrador', N'CALIFICACIONES MATEMATICA BASICA')
INSERT [dbo].[Alertas] ([id], [vista], [eliminada], [mensaje], [tipo_alerta], [fecha_creada], [creador], [perfil_ver], [titulo]) VALUES (23, 0, 0, N'Actualización de calificaciones del estudiante ', N'Notas', CAST(0x0000A8B1011F9D1A AS DateTime), N'SIMA', N'Administrador', N'CALIFICACIONES MATEMATICA BASICA')
INSERT [dbo].[Alertas] ([id], [vista], [eliminada], [mensaje], [tipo_alerta], [fecha_creada], [creador], [perfil_ver], [titulo]) VALUES (24, 0, 0, N'Actualización de calificaciones del estudiante ', N'Notas', CAST(0x0000A8B101201E31 AS DateTime), N'SIMA', N'Administrador', N'CALIFICACIONES MATEMATICA BASICA')
INSERT [dbo].[Alertas] ([id], [vista], [eliminada], [mensaje], [tipo_alerta], [fecha_creada], [creador], [perfil_ver], [titulo]) VALUES (25, 0, 0, N'Actualización de calificaciones del estudiante ', N'Notas', CAST(0x0000A8B1012035F6 AS DateTime), N'SIMA', N'Administrador', N'CALIFICACIONES MATEMATICA BASICA')
INSERT [dbo].[Alertas] ([id], [vista], [eliminada], [mensaje], [tipo_alerta], [fecha_creada], [creador], [perfil_ver], [titulo]) VALUES (26, 0, 0, N'Actualización de calificaciones del estudiante ', N'Notas', CAST(0x0000A8DA0126501E AS DateTime), N'SIMA', N'Administrador', N'CALIFICACIONES MATEMATICA BASICA')
SET IDENTITY_INSERT [dbo].[Alertas] OFF
SET IDENTITY_INSERT [dbo].[calificaciones_periodo] ON 

INSERT [dbo].[calificaciones_periodo] ([id_docente], [corte], [periodo], [fecha_registro], [asignatura], [grupo], [programa], [id]) VALUES (N'1005575218', 1, N'2017-2', CAST(0x0000A8DA012646CF AS DateTime), N'MATEMATICA BASICA', N'1         ', N'INGENIERIA DE SISTEMAS                                                                    ', 89)
SET IDENTITY_INSERT [dbo].[calificaciones_periodo] OFF
SET IDENTITY_INSERT [dbo].[capacitaciones] ON 

INSERT [dbo].[capacitaciones] ([id], [periodo], [encargado], [tema], [comentarios], [fecha], [nom_File]) VALUES (2, N'2017-2', N'Reunión con monitores académicas', N'Reunión de Monitores académicos (Socialización de funciones del monitor académico, deberes, presentación de profesionales TAE, cualificación en Sistema Integral de monitorías académica- SIMA)', N'', CAST(0x1D3D0B00 AS Date), N'')
INSERT [dbo].[capacitaciones] ([id], [periodo], [encargado], [tema], [comentarios], [fecha], [nom_File]) VALUES (3, N'2017-2', N'Coordinación TAE', N'Capacitación en estrategias de enseñanza -aprendizaje, software SIMA y plataforma MOODLE', N'La capacitación fue realizada por Ivan Barbosa (asistente de virtualidad), Fredys Vergara (Creador de SIMA) y Amanda verbel (Directora de gestión académica)', CAST(0x2E3D0B00 AS Date), N'evid_.pdf')
INSERT [dbo].[capacitaciones] ([id], [periodo], [encargado], [tema], [comentarios], [fecha], [nom_File]) VALUES (4, N'2018-1', N'fredy', N'gggg', N'iiiii', CAST(0xFD3D0B00 AS Date), N'evid_2018-03-23 10-57-38-99.pdf')
INSERT [dbo].[capacitaciones] ([id], [periodo], [encargado], [tema], [comentarios], [fecha], [nom_File]) VALUES (5, N'2018-1', N'456456', N'45y6456', N'iii', CAST(0x053E0B00 AS Date), N'evid_2018-03-23 11-18-13-61.rar')
INSERT [dbo].[capacitaciones] ([id], [periodo], [encargado], [tema], [comentarios], [fecha], [nom_File]) VALUES (6, N'2018-1', N'34747487', N'kdfkdkgfd', N'jkkkk', CAST(0x0A3E0B00 AS Date), N'evid_2018-03-26 14-43-06-74.jpg')
INSERT [dbo].[capacitaciones] ([id], [periodo], [encargado], [tema], [comentarios], [fecha], [nom_File]) VALUES (7, N'2017-2', N'9oooo', N'kkkk', N'kkkkkk', CAST(0x453E0B00 AS Date), N'-')
INSERT [dbo].[capacitaciones] ([id], [periodo], [encargado], [tema], [comentarios], [fecha], [nom_File]) VALUES (8, N'2017-2', N'eeed', N'ddddd', N'nnnn', CAST(0x523E0B00 AS Date), N'-')
INSERT [dbo].[capacitaciones] ([id], [periodo], [encargado], [tema], [comentarios], [fecha], [nom_File]) VALUES (9, N'2017-2', N'3434', N'455454', N'4554', CAST(0x353E0B00 AS Date), N'-')
INSERT [dbo].[capacitaciones] ([id], [periodo], [encargado], [tema], [comentarios], [fecha], [nom_File]) VALUES (10, N'2017-2', N'3434', N'455454', N'4554', CAST(0x353E0B00 AS Date), N'-')
INSERT [dbo].[capacitaciones] ([id], [periodo], [encargado], [tema], [comentarios], [fecha], [nom_File]) VALUES (11, N'2017-2', N'3434', N'455454', N'4554', CAST(0x353E0B00 AS Date), N'-')
INSERT [dbo].[capacitaciones] ([id], [periodo], [encargado], [tema], [comentarios], [fecha], [nom_File]) VALUES (12, N'2017-2', N'3434', N'455454', N'4554', CAST(0x353E0B00 AS Date), N'-')
INSERT [dbo].[capacitaciones] ([id], [periodo], [encargado], [tema], [comentarios], [fecha], [nom_File]) VALUES (13, N'2017-2', N'4444', N'yyy', N'tyyy', CAST(0x613E0B00 AS Date), N'-')
INSERT [dbo].[capacitaciones] ([id], [periodo], [encargado], [tema], [comentarios], [fecha], [nom_File]) VALUES (14, N'2017-2', N'hhhhh', N'lsdldsld', N'ññsdñds', CAST(0x433E0B00 AS Date), N'evid_2018-05-20 10-17-30-98.jpg')
SET IDENTITY_INSERT [dbo].[capacitaciones] OFF
SET IDENTITY_INSERT [dbo].[clases_sima] ON 

INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (9, CAST(0x263D0B00 AS Date), N'2017-2', N'Desarrollo urbano de ciudades', N'En la clase del día de hoy se realizó la socialización de distintas exposiciones sobre ciudades en el mundo y su historia en cuanto a su organización urbana, fue mi primera clase como monitoria en est', 64, N'1102887140', N'evid_9.jpeg', CAST(0x263D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (10, CAST(0x2A3D0B00 AS Date), N'2017-2', N'Visita al polígono de estudio Parque La Ford - Parque Mochila', N'Hoy nos reunimos a las 8 am con 10 estudiantes del grupo 2 de Diseño III en el parque La Ford con el motivo de que el profesor Guillermo explicara todo lo que se va a analizar en el polígono de tal lu', 64, N'1102887140', N'evid_10.jpg', CAST(0x2A3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (11, CAST(0x2B3D0B00 AS Date), N'2017-2', N'Propiedades de la potenciacion y radiación ', N'', 84, N'1096223217', N'evid_11.jpg', CAST(0x2B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (12, CAST(0x2B3D0B00 AS Date), N'2017-2', N'INTEGRALES DIRECTAS', N'', 82, N'1052998935', N'evid_12.jpg', CAST(0x2B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (13, CAST(0x2B3D0B00 AS Date), N'2017-2', N'Limites algebraicos', N'', 81, N'1102859256', N'', CAST(0x2B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (15, CAST(0x2B3D0B00 AS Date), N'2017-2', N'La persona, tipos de personas, capacidad de goce y capacidad de ejercicio, teoría de la anticipación de la personalidad, teorías de viabilidad.', N'Los estudiantes estuvieron muy participativos, mostraron gran interés en la temática y resolvieron muchas dudas, por otro lado, contamos con un aula para dar la clase de forma más fructífera ', 68, N'1131110675', N'evid_15.jpg', CAST(0x2B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (16, CAST(0x2B3D0B00 AS Date), N'2017-2', N'Avances de la bitácora de forma espacio, y orden.', N'Durante la clase, se estuvo resolviendo dudas y hablando un poco sobre diagramación y letra arquitectónica para la presentación de las bitácoras las cuales, se revisarían el día lunes 13 de agosto.', 63, N'1102876420', N'evid_16.rar', CAST(0x253D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (17, CAST(0x2B3D0B00 AS Date), N'2017-2', N'MULTIPLICACIÓN, SUMA Y RESTA DE POLINOMIOS.', N'La temática se orientó por medio de conceptos, ejemplos y ejercicios. En la monitoria también asistió el joven Juan Felipe Martinez, el cual no aparece en lista.', 87, N'99112906300', N'', CAST(0x2B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (18, CAST(0x2C3D0B00 AS Date), N'2017-2', N'Introducción a la Lógica, proposiciones simples y compuestas, Métodos inductivo, deductivo e inserción a la simbolizan y conectivos lógicos. ', N'Es la primera sesión de monitorias académicas,  asistió solamentun estudiante, se seguirá motivando al resto de alumnos , sin embargo se espera que incremente el numero de asistentes a las monitorias.', 71, N'1102878423', N'evid_18.jpg', CAST(0x2A3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (19, CAST(0x2C3D0B00 AS Date), N'2018-2', N'Elaboración de bitácora de trabajo', N'Los estudiantes estuvieron elaborando los aspectos del medio físico-naturale del sitio de trabajo, como monitora les estuve orientando en algunos puntos que no entendían de la bitácora. ', 64, N'1102887140', N'evid_19.rar', CAST(0x2C3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (20, CAST(0x2C3D0B00 AS Date), N'2017-2', N'INTEGRALES DIRECTAS', N'NO ASISTIERON ALUMNOS', 82, N'1052998935', N'', CAST(0x2C3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (21, CAST(0x2D3D0B00 AS Date), N'2017-2', N'EXPRESIONES ALGEBRAICAS', N'Se realizaron ejercicios sobre la temática, logrando aclarar pequeñas dudas sobre el tema.', 87, N'99112906300', N'evid_21.jpg', CAST(0x2D3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (22, CAST(0x2E3D0B00 AS Date), N'2017-2', N'planta arquitectónica ', N'siendo la primera clase en donde me presente pude apreciar que es un grupo muy atento a las monitorias en donde a todos se les vio el interés, por lo cual me siento muy cómodo con este grupo. ', 65, N'1102880103', N'evid_22.rar', CAST(0x253D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (26, CAST(0x303D0B00 AS Date), N'2017-2', N'sistema nervioso central ', N'ninguno ', 72, N'1102581878', N'evid_26.jpg', CAST(0x2D3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (27, CAST(0x303D0B00 AS Date), N'2017-2', N'Distribución Binomial', N'la clase se realizo de manera exitosa, aunque se presento un inconveniente  porque el aula asignada a la monitora de trabajo social también se le asigno a otro monitor.', 79, N'1102232208', N'evid_27.rar', CAST(0x2E3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (28, CAST(0x313D0B00 AS Date), N'2017-2', N'PLANTA ARQUITECTÓNICA ', N'se tuvo un buen manejo en el aula de clase ', 65, N'1102880103', N'evid_28.rar', CAST(0x2C3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (29, CAST(0x323D0B00 AS Date), N'2017-2', N'FACTORIZACION', N'Explicación de los 3 primeros casos de factorización, repasando por medios de ejemplos.', 87, N'99112906300', N'evid_29.jpg', CAST(0x323D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (30, CAST(0x323D0B00 AS Date), N'2017-2', N'Operación de fracciones algebraicas', N'', 84, N'1096223217', N'evid_30.jpg', CAST(0x323D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (31, CAST(0x333D0B00 AS Date), N'2017-2', N'Primera revisión de bitácora de trabajo', N'La dinámica consistió en que como monitora revisara previamente a cada estudiante antes de que el profesor les revisara par agilizar, hoy adelanté 2 hrs por una clase que tenia atrasada (09/08/17)', 64, N'1102887140', N'evid_31.rar', CAST(0x333D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (32, CAST(0x343D0B00 AS Date), N'2017-2', N'FACTORIZACION (Caso 5)', N'Explicacion de la tematica por medio de ejemplos, propiedades de signos, factor comun, etc.', 87, N'99112906300', N'evid_32.rar', CAST(0x343D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (33, CAST(0x343D0B00 AS Date), N'2017-2', N'SISTEMA DE GAUSS Y GAUSS JORDAN ', N'DESARROLLO DE EJERCICIOS DE LA TEMATICA VISTA GAUSS Y GAUSS JORDAN', 83, N'1102873967', N'evid_33.rar', CAST(0x343D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (34, CAST(0x343D0B00 AS Date), N'2017-2', N'Revisión bitácora de trabajo', N'Como monitora estuve acompañando al profesor en la retroalimentación de la revisión de bitácora sobre los aspectos urbanos del sitio de trabajo que deben hacerse en la bitácora.', 64, N'1102887140', N'evid_34.rar', CAST(0x343D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (35, CAST(0x353D0B00 AS Date), N'2017-2', N'SISTEMA GAUS JORDAN Y GAUSS', N'SE DESARROLLO RESPECTIVAMENTE EJERCICIOS CON LA TEMÁTICA VISTA DURANTE LA CLASE (GAUSS Y GAUSS JORDAN).', 83, N'1102873967', N'evid_35.rar', CAST(0x353D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (36, CAST(0x353D0B00 AS Date), N'2017-2', N'Potenciacion, radiación y suma y resta de fracciones ', N'', 84, N'1096223217', N'evid_36.jpg', CAST(0x353D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (37, CAST(0x353D0B00 AS Date), N'2017-2', N'Matrices, sistema de ecuaciones matriciales, matriz inversa, Adjunta de una matriz', N'se realizo la monitoria en completa calma, con pocos alumnos pero se resolvieron todas las dudas que los estudiantes tenian.', 74, N'1102869404', N'evid_37.pdf', CAST(0x353D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (38, CAST(0x353D0B00 AS Date), N'2017-2', N'INTEGRALES DIRECTAS', N'', 82, N'1052998935', N'evid_38.jpg', CAST(0x2B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (39, CAST(0x363D0B00 AS Date), N'2017-2', N'Socialización guía de trabajo', N'El profesor hizo explicación de los puntos que se tomaran en el polígono de estudio, como monitoria le hable a los estudiantes de como realicé algunos puntos cuando vi la asignatura.', 64, N'1102887140', N'evid_39.rar', CAST(0x253D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (40, CAST(0x363D0B00 AS Date), N'2017-2', N'INTEGRALES DIRECTAS Y POR SIMPLE SUSTITUCION', N'', 82, N'1052998935', N'evid_40.rar', CAST(0xA63C0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (41, CAST(0x363D0B00 AS Date), N'2017-2', N'sustancia gris , blanca y pares craneales ', N'no se como adjuntar mas de un documento', 72, N'1102581878', N'evid_41.jpg', CAST(0x343D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (42, CAST(0x373D0B00 AS Date), N'2017-2', N'Bitácora del libro forma, espacio y orden.', N'En la monitoria,  se estuvo contestando pregunta sobre las temáticas resumidas en la bitácora en cuanto a información y diagramación. La mayoría presento problemas de diagramación y estética. ', 63, N'1102876420', N'evid_42.rar', CAST(0x253D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (43, CAST(0x373D0B00 AS Date), N'2017-2', N'Socialización guía de trabajo', N'El profesorexplicó la guía de trabajo correspondiente a análisis de datos para el lote de trabajo, como monitoria comenté mi experiencia cuando realicé tales análisis. ', 64, N'1102887140', N'evid_43.rar', CAST(0x2D3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (44, CAST(0x383D0B00 AS Date), N'2017-2', N'TÉCNICAS DE INTEGRACIÓN, POR SUSTITUCION', N'', 82, N'1052998935', N'evid_44.zip', CAST(0x323D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (45, CAST(0x383D0B00 AS Date), N'2017-2', N'Simbolizacion de Proposiciones y tablas de verdad. ', N'Se realizó la clase de forma dinámica y participativa, se realizaron ejercicios y se socializaron a nivel grupal, exponiendo a los compañeros el procedimiento y los pasos que utilizaron. ', 71, N'1102878423', N'evid_45.jpg', CAST(0x313D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (46, CAST(0x383D0B00 AS Date), N'2017-2', N'Distribución normal estándar', N'Solo asistió una estudiante a la monitoria, pero se cumplió con el objetivo, porque se logró transmitir los conocimientos y sacar a adelante la monitoria.', 79, N'1102232208', N'evid_46.jpeg', CAST(0x353D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (47, CAST(0x383D0B00 AS Date), N'2017-2', N'Revisión de bitácora-explicación de análisis urbanos', N'Como monitora explique a los estudiantes en puntos de la bitácora que no sabían como realizar.', 64, N'1102887140', N'evid_47.rar', CAST(0x383D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (48, CAST(0x393D0B00 AS Date), N'2017-2', N'Estadística Descriptiva, Variables (Cualitativa y Cuantitativa)', N'Solo asistió una estudiante a la asesoría, la cual mostró entendimiento con los temas tratados. Cabe resaltar que fueron citados todos los estudiantes del grupo 3.', 80, N'1104015178', N'evid_48.rar', CAST(0x2E3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (49, CAST(0x393D0B00 AS Date), N'2017-2', N'INTEGRALES TRIGONOMETRICAS ', N'', 82, N'1052998935', N'evid_49.rar', CAST(0xA63C0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (50, CAST(0x393D0B00 AS Date), N'2017-2', N'Factorizacion ', N'', 84, N'1096223217', N'evid_50.jpg', CAST(0x393D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (51, CAST(0x393D0B00 AS Date), N'2017-2', N'Exposiciones y juego "quien quiere ser arquitecto" ', N'Durante la clase, los distintos grupos conformados expusieron los principios ordenadores. Cabe resaltar que dichas exposiciones les faltó profundidad, manejo del tema y creatividad. ', 63, N'1102876420', N'evid_51.rar', CAST(0x2C3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (52, CAST(0x393D0B00 AS Date), N'2017-2', N'Oferta y demanda ', N'La monitoria se desarrollo en el aula A125 de 2-4 PM, a la cual asistieron 9 estudiantes, durante la clase se desarrollo un taller practico el cual contaba con 36 ejercicios tomados del texto guía. ', 101, N'98103070783', N'evid_52.zip', CAST(0x393D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (53, CAST(0x3A3D0B00 AS Date), N'2017-2', N'matrices', N'', 74, N'1102869404', N'', CAST(0x393D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (54, CAST(0x3A3D0B00 AS Date), N'2017-2', N'FACTORIZACION', N'Realizacion de ejemplos de la tematica y respuesta de dudas de los estudiantes.', 87, N'99112906300', N'evid_54.jpg', CAST(0x393D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (55, CAST(0x3A3D0B00 AS Date), N'2017-2', N'Integrales teigonometricas', N'No hubo asistencia', 82, N'1052998935', N'evid_55.jpg', CAST(0x3A3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (56, CAST(0x3A3D0B00 AS Date), N'2017-2', N'Sensación y Percepción ', N'El encuentro estuvo agradable, puesto que los estudiantes se mostraron muy atentos a las debidas explicaciones expuestas por mi persona. Ademas hubo dinamismo y participación activa. ', 73, N'1051829595', N'evid_56.jpg', CAST(0x273D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (57, CAST(0x3A3D0B00 AS Date), N'2017-2', N'Explicación puntos para la escogencia de lote de trabajo', N'Como monitoria me acerque a cada uno de los estudiantes para ayudarlos a resolver dudas que tuviesen con el ejercicio de la bitácora de trabajo', 64, N'1102887140', N'evid_57.rar', CAST(0x3A3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (58, CAST(0x3B3D0B00 AS Date), N'2017-2', N'SUMA DE POLINOMIOS (REPASO)', N'Realización de ejemplos de esta temática, las cuales se permitía responder algunas dudas de los estudiantes.', 87, N'99112906300', N'evid_58.jpg', CAST(0x3B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (59, CAST(0x3C3D0B00 AS Date), N'2017-2', N'Situacion problema acerca de matrices y aplicaciones de matrices.', N'se realizo la monitoria y se resolvieron las dudas acerca el tema de problemas de matrices.', 74, N'1102869404', N'evid_59.jpg', CAST(0x3A3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (60, CAST(0x3C3D0B00 AS Date), N'2017-2', N'Gauss Jordan ', N'Ejercicios relacionado con la temática.\r\n', 83, N'1102873967', N'evid_60.rar', CAST(0x3C3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (61, CAST(0x3C3D0B00 AS Date), N'2017-2', N'INTEGRALES POR SUSTITUCION TRIGONOMETRICA', N'', 82, N'1052998935', N'evid_61.rar', CAST(0xA63C0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (62, CAST(0x3D3D0B00 AS Date), N'2017-2', N'metodo de crammer, metodo de reduccion aplicado a situacion problema.', N'se realizo la monitoria con mayor numero de alumnos, resolviendo dudas y practicando ejercicios del taller.', 74, N'1102869404', N'evid_62.jpg', CAST(0x3C3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (63, CAST(0x3E3D0B00 AS Date), N'2017-2', N'Metodo de Reduccion de matrices, Matriz adjunta, determinante nxn', N'se realizo la monitoria con un gran numero de alumnos de contaduría y administracion de empresas sobre los temas de matrices y aplicaciones de ejercicios.', 74, N'1102869404', N'evid_63.jpg', CAST(0x383D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (64, CAST(0x3E3D0B00 AS Date), N'2017-2', N'Algoritmos en pseudocodigo y DFD', N'', 88, N'1102880538', N'', CAST(0x353D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (65, CAST(0x3F3D0B00 AS Date), N'2017-2', N'ejercicios de matriz inversa, matriz adjunta y solucion de situacion problema por diferentes metodos.', N'se resolvieron todas las dudas que tenian los alumnos antes de presentar el examen parcial del primer corte.', 74, N'1102869404', N'evid_65.jpg', CAST(0x3F3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (66, CAST(0x3F3D0B00 AS Date), N'2017-2', N'Análisis biofisico y urbano: Revisión de bitácora', N'El profesor en la clase de hoy reviso en puesta en común todas las bitácoras de trabajo completas.', 64, N'1102887140', N'evid_66.rar', CAST(0x3F3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (67, CAST(0x403D0B00 AS Date), N'2017-2', N'Proposiciones simples y compuestas (Profundización). Tablas de verdad (Tautología, Falacia, contingencia).', N'El numero de asistentes a la monitoria va incrementando considerablemente. Las expectativas crecen, con mucha motivación. ', 71, N'1102878423', N'evid_67.jpg', CAST(0x343D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (68, CAST(0x403D0B00 AS Date), N'2017-2', N'Tecnicas de integracion', N'', 82, N'1052998935', N'evid_68.rar', CAST(0xA63C0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (69, CAST(0x403D0B00 AS Date), N'2017-2', N'DESIGUALDADES', N'Se realizaron ejemplos sobre el tema, explicando inquietudes de los estudiantes sobre esta.', 87, N'99112906300', N'evid_69.jpg', CAST(0x403D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (70, CAST(0x413D0B00 AS Date), N'2017-2', N'Tecnicas de Integrales', N'No asistieron alumnos', 82, N'1052998935', N'evid_70.jpg', CAST(0x413D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (71, CAST(0x413D0B00 AS Date), N'2017-2', N'SENSACIÓN Y PERCEPCIÓN- SIMULACRO ', N'Los encuentros pedagógicos con respecto a las monitorias de Procesos Psicológicos Básicos son muy amenos, puesto que los estudiantes muestran mucho interés y participación activa durante la clase.', 73, N'1051829595', N'evid_71.zip', CAST(0x2E3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (72, CAST(0x413D0B00 AS Date), N'2017-2', N'corte arquitectónico ', N'se desarrollo la monitoria  en presencia de el docente en donde los alumnos tuvieron muchas dudas y de aclararon junto al docente. ', 65, N'1102880103', N'evid_72.rar', CAST(0x2B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (73, CAST(0x413D0B00 AS Date), N'2017-2', N'Tablas de Frecuencias.', N'Se convoco todos los estudiantes de los tres grupos de Estadística Descriptiva, sin embargo no asistió nadie. Mediante la colaboración del docente le hice un llamado de motivación para asistir.', 80, N'1104015178', N'evid_73.rar', CAST(0x543D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (74, CAST(0x423D0B00 AS Date), N'2017-2', N'ley de gases y soluciones', N'', 85, N'1102877863', N'', CAST(0x413D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (75, CAST(0x423D0B00 AS Date), N'2017-2', N'se trabajó sobre la historia de las obligaciones y su concepción moderna de las mismas y se empezó con su clasificación.', N'se mostró interés en los estudiantes por los temas tocados y manifestaron que en su clase estos temas fueron expuestos y no quedaron claros en las exposiciones.', 69, N'1102881228', N'evid_75.pdf', CAST(0x333D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (76, CAST(0x423D0B00 AS Date), N'2017-2', N'Composición de 3 espacios de un solo nivel.', N'Esta fue la primera vez que se comenzó a usar el teatrino por lo cual un 95% estaba teniendo dificultades. A medida que transcurrían las horas, fueron mejorando. Solo unos 2 no lograron comprender.', 63, N'1102876420', N'evid_76.rar', CAST(0x333D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (77, CAST(0x423D0B00 AS Date), N'2017-2', N'corte arquitectónico ', N'', 65, N'1102880103', N'evid_77.rar', CAST(0x2D3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (78, CAST(0x423D0B00 AS Date), N'2017-2', N'DESIGUALDADES', N'Se realizaron ejemplos y algunas propiedades de la temática respondiendo así inquietudes de los estudiantes.', 87, N'99112906300', N'evid_78.jpg', CAST(0x423D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (79, CAST(0x423D0B00 AS Date), N'2017-2', N'Costos', N'La monitoria se desarrollo en el aula A128 de 4-5 PM, con la participación de 4 alumnos de curso de micro II y dos alumnos de otros semestres que quisieron entrar al aula para repasar temas ya vistos.', 102, N'98103070783', N'', CAST(0x423D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (80, CAST(0x423D0B00 AS Date), N'2017-2', N'Socialización y explicación general de bitácora de trabajo', N'Como monitora junto al profesor, hablamos sobre las conclusiones que deben sacarse a partir e los análisis e información recolectada en la bitácora como determinantes para el proceso de diseño.', 64, N'1102887140', N'evid_80.rar', CAST(0x423D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (81, CAST(0x423D0B00 AS Date), N'2017-2', N'PSICOFISICA', N'El rendimiento academico de los estudiantes ha mostrado cambios eficientes en cuanto a la construccion de conocimientos se refiere. ', 73, N'1051829595', N'evid_81.jpg', CAST(0x353D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (82, CAST(0x433D0B00 AS Date), N'2017-2', N'Algoritmos resueltos en pseudocodigo y diagrama de Flujos(Estructuras Condicionales)', N'', 88, N'1102880538', N'', CAST(0x393D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (83, CAST(0x433D0B00 AS Date), N'2017-2', N'Medidas de tendencia central, parados agrupados y no agrupados. cuartiles.', N'Los estudiante que asistieron se mostraron muy atentos y  compresivos en la explicación de ejercicios. todos participaron pasando al tablero a resolver los ejercicios de clase.', 80, N'1104015178', N'evid_83.rar', CAST(0x3C3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (84, CAST(0x433D0B00 AS Date), N'2017-2', N'Distribucion muestral\r\nDistribucion Binomial\r\nDistribucion normal estandar', N'clase realizada el dia viernes 1 de septiembre\r\nel mismo dia asistieron otras estudiantes del grupo 2', 79, N'1102232208', N'evid_84.jpg', CAST(0x3C3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (85, CAST(0x433D0B00 AS Date), N'2017-2', N'resolver dudas acerca del parcial realizado sobre matrices y aplicacion de matrices', N'se realizo la monitoria con un solo estudiante donde se resolvieron dudas acerca del parcial que llevaran acabo en matematicas aplicadas.', 74, N'1102869404', N'evid_85.jpg', CAST(0x433D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (86, CAST(0x433D0B00 AS Date), N'2017-2', N'Explicación rubrica de evaluación para primer parcial de diseño III', N'En la clase como monitora estuve dando sugerencias a los estudiantes sobre como diagramar sus presentaciones para el parcial.', 64, N'1102887140', N'evid_86.rar', CAST(0x413D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (87, CAST(0x443D0B00 AS Date), N'2017-2', N'Revisión general de bitácora: componentes urbanos', N'Como monitora me acerqué a los estudiantes para aclarar dudas respecto a como se debe presentar el componente urbano y aspectos que deberían mejorarse.', 64, N'1102887140', N'evid_87.rar', CAST(0x3B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (88, CAST(0x453D0B00 AS Date), N'2017-2', N'distribucion muestral, distribucion binomial', N'monitoria realizada el dia 8 de septiembre de manera exitosa aunque solo asistierieron 3 estudiantes', 79, N'1102232208', N'evid_88.png', CAST(0x433D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (89, CAST(0x453D0B00 AS Date), N'2017-2', N'Continuación del tema de Tablas de verdad. ', N'Realización de talleres a nivel individual y participación en grupo. ', 71, N'1102878423', N'evid_89.jpg', CAST(0x383D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (90, CAST(0x463D0B00 AS Date), N'2017-2', N'Repaso de los temas vistos en primer corte: Proposiciones simples y compuestas, tablas de verdad, tautologia, falacia y contingencia. ', N'Se realizó el repaso de los temas vistos de forma dinámica y participativa, tomando como referencia el modelo social cognitivo. ', 71, N'1102878423', N'evid_90.rar', CAST(0x3B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (91, CAST(0x463D0B00 AS Date), N'2017-2', N'solucion del examen parcial sobre matrices y aplicaciones de problemas resueltos por metodos matriciales y producto de matrices.', N'se realizo la monitoria con pocos alumnos, donde se resolvieron los puntos del parcial realizado por los estudiantes de matematicas aplicadas.', 74, N'1102869404', N'evid_91.jpg', CAST(0x463D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (92, CAST(0x473D0B00 AS Date), N'2017-2', N'indicaciones para el primer parcial y comienzo del mismo. ', N'En la clase se estuvo realizando el diseño del primer parcial el cual consta de 6 espacios y dos niveles. Tuvieron problemas al hacer la escalera y algunos para entender la repartición de espacios.', 63, N'1102876420', N'evid_92.rar', CAST(0x413D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (93, CAST(0x473D0B00 AS Date), N'2017-2', N'DESIGUALDADES', N'Se realizaron ejemplos y se respondió las dudas de algunos estudiantes.', 87, N'99112906300', N'evid_93.jpg', CAST(0x473D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (94, CAST(0x473D0B00 AS Date), N'2017-2', N'PARCIAL PRIMER CORTE DISEÑO III', N'Como monitora estuve como jurado en el primer parcial de diseño y metodología III con el profesor Guillermo Ghysais', 64, N'1102887140', N'', CAST(0x463D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (95, CAST(0x483D0B00 AS Date), N'2017-2', N'clases de prestaciones ', N'los estudiantes han estado atentos acerca de las temáticas manejadas durante las monitoria ', 70, N'1103120601', N'evid_95.rar', CAST(0x2E3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (96, CAST(0x483D0B00 AS Date), N'2017-2', N'Integrales definidas', N'No hubo asistencia', 82, N'1052998935', N'evid_96.jpg', CAST(0x483D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (97, CAST(0x483D0B00 AS Date), N'2017-2', N'PSICOFISICA ', N'Los temas expuestos durante el desarrollo de las monitorias fueron de gran interes para los estudiantes, los cuales siempre demostraron buen dominio de cada uno de los temas. ', 73, N'1051829595', N'evid_97.jpg', CAST(0x3C3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (98, CAST(0x493D0B00 AS Date), N'2017-2', N'Estructuras Condicionales en Solución de Algoritmos', N'', 88, N'1102880538', N'', CAST(0x3C3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (99, CAST(0x493D0B00 AS Date), N'2017-2', N'DESIGUALDADES', N'Nuevamente se explica la temática acompañada de ejemplos y respondiendo inquietudes de los estudiantes.', 87, N'99112906300', N'evid_99.jpg', CAST(0x493D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (100, CAST(0x493D0B00 AS Date), N'2017-2', N'Etimología, origen, concepto, y función social del derecho.', N'los estudiantes han participado de manera y manejado muy bien los temas.', 70, N'1103120601', N'evid_100.rar', CAST(0x333D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (101, CAST(0x493D0B00 AS Date), N'2017-2', N'Composición de 6 espacios con pauta.', N'El principio ordenador pauta genero muchas dudas en todo el corte por lo que la docente exigió el uso de esta en la nueva composición. Después de explicarles, entendieron y lograron el objetivo', 63, N'1102876420', N'evid_101.rar', CAST(0x483D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (102, CAST(0x493D0B00 AS Date), N'2017-2', N'SIMULACRO GENERAL: SENSACION/PERCEPCION Y PSICOFISICA. ', N'Los estudiantes mostraron actitud positiva y buen desempeño durante el desarrollo del simulacro. ', 73, N'1051829595', N'evid_102.jpg', CAST(0x433D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (103, CAST(0x493D0B00 AS Date), N'2017-2', N'PARCIAL PRIMER CORTE DISEÑO Y METODOLOGIA III', N' Como monitora acompañe al profesor en la revisión del parcial correspondiente al primer corte de la asignatura.', 64, N'1102887140', N'evid_103.rar', CAST(0x493D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (104, CAST(0x4A3D0B00 AS Date), N'2017-2', N'Solución y explicación de algoritmos con estructuras condicionales', N'', 88, N'1102880538', N'', CAST(0x403D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (105, CAST(0x4A3D0B00 AS Date), N'2017-2', N'grupo 2: teorías acerca del origen del derecho\r\ngrupo 3: objeto del derecho, clasificación de los derechos subjetivos.  ', N'los estudiantes de ambos cursos han estado atento acerca  de los temas correspondiente. Los cursos han tenido buen desempeño respecto a las monitorias.  ', 70, N'1103120601', N'evid_105.rar', CAST(0x343D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (106, CAST(0x4A3D0B00 AS Date), N'2017-2', N'Gases ideales y disoluciones ', N'por problemas con mi ordenador no pude registrar la asistencia virtual el mismo dia de las monitorias', 85, N'1102877863', N'', CAST(0x483D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (107, CAST(0x4A3D0B00 AS Date), N'2017-2', N'inversa por el metodo de reduccion, Limite de F(x), ejercicios de limite', N'se realizo la monitoria de forma normal, resolviendo ejercicios sobre los temas abordados', 74, N'1102869404', N'evid_107.jpg', CAST(0x4A3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (108, CAST(0x4A3D0B00 AS Date), N'2017-2', N'Conversion de Unidades\r\nVectores\r\nCinematica (Movimiento Uniforme y Acelerado)', N'Estudiantes que asistieron:\r\nDiego Andres Mayoriano\r\nMateo Alvarez Polo\r\nJuan Alberto Gil\r\nKendry Morelo\r\nJesus Anaya', 90, N'1140845621', N'evid_108.jpg', CAST(0xA63C0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (109, CAST(0x4B3D0B00 AS Date), N'2017-2', N'grupo 2: análisis teórico practico  durante todo lo visto en monitorias. grupo 3: clases de prestaciones- teorías acerca del origen del derecho. ', N'con respecto al grupo numero 2 me he visto en la obligación de orientar los en el rancho de los espejos los días miércoles durante dos horas, ya que solicite el salón pero aun no se me ha otorgado-  ', 70, N'1103120601', N'evid_109.rar', CAST(0x3B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (110, CAST(0x4D3D0B00 AS Date), N'2017-2', N'Socialización de notas de parcial - explicación hipótesis de diseño', N'El día de hoy se socializo las notas delk parcial y como monitora oriente a estudiantes en sus análisis de referentes, anexo evidencias de hoy y de la clase del parcial de primer corte.', 64, N'1102887140', N'evid_110.rar', CAST(0x4D3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (111, CAST(0x4D3D0B00 AS Date), N'2017-2', N'funcion limite, grafico de limites, aplicaciones de limites', N'se realizo la monitoria en completa calma y se resolvieron dudas acerca el tema abordado', 74, N'1102869404', N'evid_111.jpg', CAST(0x4D3D0B00 AS Date))
GO
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (112, CAST(0x4E3D0B00 AS Date), N'2017-2', N'Estructura de costos', N'La monitoria se desarrollo en el aula A128 de 4-6PM. Con 6 estudiantes, cinco de ellos del curso de Microeconomia II. ', 102, N'98103070783', N'', CAST(0x3B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (113, CAST(0x4E3D0B00 AS Date), N'2017-2', N'Elasticidad ', N'A petición de los estudiantes esta monitoria se desarrollo en horas de la mañana, pues era urgente ya que al día siguiente presentaban su parcial. ', 101, N'98103070783', N'', CAST(0x473D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (114, CAST(0x4E3D0B00 AS Date), N'2017-2', N'Ninguno.', N'En la monitoria del dia lunes 14-08-2017 de 10:00 am - 1:00 pm los estudiantes no asistieron.', 89, N'1103118992', N'evid_114.jpg', CAST(0x2A3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (115, CAST(0x4F3D0B00 AS Date), N'2017-2', N'Estructura de un programa en c++.', N'En la monitoria del dia lunes 14-08-2017 de 1:00 pm - 2:00 pm con el compañero Elkin se trabajó la estructuración de un programa en c++.', 89, N'1103118992', N'evid_115.jpg', CAST(0x2A3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (116, CAST(0x4F3D0B00 AS Date), N'2017-2', N'planta arquitectónica detallada ', N'', 65, N'1102880103', N'evid_116.rar', CAST(0x423D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (117, CAST(0x4F3D0B00 AS Date), N'2017-2', N'Hipótesis de diseño ', N'En la clase de hoy el profesor y yo como monitora resolvimos dudas a los estudiantes sobre comenzar a elaborar la hipótesis del diseño de la composición en el lote escogido para trabajar,', 64, N'1102887140', N'evid_117.rar', CAST(0x4F3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (118, CAST(0x503D0B00 AS Date), N'2017-2', N'Integrales defiidadas', N'No asistieron alumnos', 82, N'1052998935', N'', CAST(0x4F3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (119, CAST(0x503D0B00 AS Date), N'2017-2', N'acotado arquitectónico. ', N'el docente llevo acabo una clase teórica, pero se llevo acabo la realización  de un ejercicio el cual se dio la monitoria.', 65, N'1102880103', N'evid_119.rar', CAST(0x503D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (120, CAST(0x503D0B00 AS Date), N'2017-2', N'Desarrollo del diseño de espacios en la hipótesis de diseño', N'En la clase de hoy, como monitoria junto al profesor se hizo explicación de las cualidades que poseen algunos de los espacios requeridos para la solución del diseño de un centro cultural.', 64, N'1102887140', N'evid_120.rar', CAST(0x503D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (121, CAST(0x503D0B00 AS Date), N'2017-2', N'Ninguno.', N'En la monitoria del dia viernes 18-08-2017 de 2:00 pm - 4:00 pm los estudiantes no asistieron.', 89, N'1103118992', N'evid_121.jpg', CAST(0x2E3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (122, CAST(0x513D0B00 AS Date), N'2017-2', N'propiedades de limites, clases de limites, ejercicios de limites', N'se realizo la monitoria en completa calma, se resolvieron dudas sobre el tema de limites', 74, N'1102869404', N'evid_122.jpg', CAST(0x513D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (123, CAST(0x513D0B00 AS Date), N'2017-2', N'Ninguno.', N'No se realizó la monitoria académica (festivo).\r\n', 89, N'1103118992', N'evid_123.jpg', CAST(0x313D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (124, CAST(0x523D0B00 AS Date), N'2017-2', N'Estructura de un programa.', N'En la monitoria del dia viernes 25-08-2017 de 2:00 pm - 4:00 pm se trabajó la estructuración de un programa.', 89, N'1103118992', N'evid_124.jpg', CAST(0x353D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (125, CAST(0x523D0B00 AS Date), N'2017-2', N'planta arquitectónica detallada ', N'se realizo la monitoria aclarando dudas con un ejercicio asignado por docente clases anteriores con el fin de afianzar y aplicar los temas aplicados por el docente. ', 65, N'1102880103', N'evid_125.rar', CAST(0x423D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (126, CAST(0x533D0B00 AS Date), N'2017-2', N'planta arquitectónica detallada ', N'', 65, N'1102880103', N'evid_126.rar', CAST(0x423D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (127, CAST(0x533D0B00 AS Date), N'2017-2', N'Ciclos y Ejercicios.', N'En la monitoria del dia lunes 28-08-2017 de 10:00 am - 2:00 pm se trabajaron los ciclos: for, while y do while. Además se realizaron ejercicios de los mismos. ', 89, N'1103118992', N'evid_127.jpg', CAST(0x383D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (128, CAST(0x543D0B00 AS Date), N'2017-2', N'DESIGUALDADES CON VALOR ABSOLUTO', N'Se realizaron ejercicios, respondiendo dudas de los alumnos.', 87, N'99112906300', N'evid_128.jpg', CAST(0x503D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (129, CAST(0x543D0B00 AS Date), N'2017-2', N'desarrollo de taller de limites, limites infinitos y grafica de limites', N'se realizo en completa calma la monitoria', 74, N'1102869404', N'evid_129.jpg', CAST(0x543D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (130, CAST(0x543D0B00 AS Date), N'2017-2', N'Hipótesis de diseño: evolución forma y distribución de parque y plaza', N'En la clase como monitora explique a varios estudiantes acerca de cómo debe realizarse la distribución de las zonas previstas en las necesidades del parque y la plaza en conjunto con la composición', 64, N'1102887140', N'evid_130.rar', CAST(0x543D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (131, CAST(0x553D0B00 AS Date), N'2017-2', N'DESIGUALDADES CON VALOR ABSOLUTO', N'Realización de ejercicios, explicación y respuesta de inquietudes de los alumnos.', 87, N'99112906300', N'evid_131.jpg', CAST(0x553D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (132, CAST(0x553D0B00 AS Date), N'2017-2', N'Estructuras de Control.', N'En la monitoria del dia viernes 01-09-2017 de 2:00 am - 4:00 pm se trabajaron las estructuras de control (condicionales if y switch).', 89, N'1103118992', N'evid_132.jpg', CAST(0x3C3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (133, CAST(0x563D0B00 AS Date), N'2017-2', N'plantas arquitectónicas, vistas laterales y corte longitudinal de una escalera  ', N'la monitoria se llevo acabo a través de un ejercicio asignado por el docente a cargo en donde los estudiantes aclararon muchas dudas.', 65, N'1102880103', N'evid_133.jpg', CAST(0x563D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (134, CAST(0x563D0B00 AS Date), N'2017-2', N'Funciones.', N'En la monitoria del dia lunes 04-09-2017 de 10:00 am - 2:00 pm se trabajaron funciones.', 89, N'1103118992', N'evid_134.rar', CAST(0x3F3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (135, CAST(0x573D0B00 AS Date), N'2017-2', N'DESIGUALDADES CON VALOR ABSOLUTO', N'Ejemplos sobre la temática y la participación de estudiantes.', 87, N'99112906300', N'evid_135.jpg', CAST(0x573D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (136, CAST(0x573D0B00 AS Date), N'2017-2', N'Gauss, Gauss jordan, Regla cramer, Determinante, ', N'ejercicios de repaso con todos los temas ', 83, N'1102873967', N'evid_136.rar', CAST(0x573D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (137, CAST(0x573D0B00 AS Date), N'2017-2', N'plantas arquitectónicas de primer y segundo piso, vistas laterales, y frontales, y corte longitudinal de una escalera.', N'la monitoria se desarrollo a partir de un ejercicio asignado por el docente a los estudiantes donde se presentaron algunas dudas en algunos estudiantes que fueron aclaradas en el trascurso de la clase', 65, N'1102880103', N'evid_137.rar', CAST(0x573D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (138, CAST(0x583D0B00 AS Date), N'2017-2', N' la tematica de distribucion normal estandar ', N'No se pudo Realizar la monitoria debido a  que ningún estudiante asistió', 79, N'1102232208', N'evid_138.jpg', CAST(0x4A3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (139, CAST(0x583D0B00 AS Date), N'2017-2', N'Desarrollo propuesta parque y plaza en lote de diseño', N'En la clase estuve orientando junto al profesor a los estudiantes acerca de los conceptos que deben tenerse en cuenta para desarrolla runa propuesta de diseño de parque y plaza.', 64, N'1102887140', N'evid_139.rar', CAST(0x563D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (140, CAST(0x593D0B00 AS Date), N'2017-2', N'Derivada de una funcion, dudas sobre limites infinitos', N'se realizo la monitoria normalmente donde se resolvieron dudas con la participacion de los estudiantes', 74, N'1102869404', N'evid_140.jpg', CAST(0x583D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (141, CAST(0x5B3D0B00 AS Date), N'2017-2', N'Derivada por definición, propiedades de la derivada', N'se realizo en completo calma la monitoria', 74, N'1102869404', N'evid_141.jpg', CAST(0x5B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (142, CAST(0x5B3D0B00 AS Date), N'2017-2', N'Evolución de la forma: parque y plaza', N'El profesor y yo como monitora hicimos revisión  la propuesta del parque y la plaza a cada uno de lo estudiantes, estos a su vez también elaboraron maquetas conceptuales de sus propuestas.', 64, N'1102887140', N'evid_142.rar', CAST(0x5B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (143, CAST(0x5C3D0B00 AS Date), N'2017-2', N'COMPOSICIÓN ARQUITECTÓNICA ', N'En el aula de clase junto al docente se realizaron diferentes correcciones y aclaraciones a los estudiantes respecto a temas de composición y aspectos a tener en cuenta dentro de su propuesta. ', 62, N'1102878542', N'', CAST(0x583D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (144, CAST(0x5C3D0B00 AS Date), N'2017-2', N'Integrales Trigonometricas ', N'', 82, N'1052998935', N'evid_144.rar', CAST(0xA63C0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (145, CAST(0x5D3D0B00 AS Date), N'2017-2', N'CORRECCIONES- COMPOSICIÓN ARQUITECTÓNICA EN UN MEDIO NATURAL.', N'Durante el desarrollo de la clase y la monitorias, como estrategia de aprendizaje el docente titular y yo como monitor recreamos a través de explicaciones didácticas el proceso de diseño. ', 62, N'1102878542', N'', CAST(0x513D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (146, CAST(0x5D3D0B00 AS Date), N'2017-2', N'taller de planetaria arquitectónica técnico constructivo ', N'se tuvo un buen manejo en la monitoria, donde los estudiantes han avanzado y se estuvieron aclarando dudas.', 65, N'1102880103', N'evid_146.rar', CAST(0x5D3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (147, CAST(0x5D3D0B00 AS Date), N'2017-2', N'el tema de la monitoria realizada el dia 22 de sep 2017\r\nfue prueba de hipotesis para la media poblacional', N'la monitoria se realizo de manera exitosa, quiero agregar que la Joven gissela herrara del grupo A tambien me asistio a la monitoria.', 79, N'1102232208', N'evid_147.rar', CAST(0x513D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (148, CAST(0x5D3D0B00 AS Date), N'2017-2', N'La persona, concepto de la persona, clasificación y teorías. \r\n', N'', 68, N'1131110675', N'evid_148.rar', CAST(0x2B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (149, CAST(0x5D3D0B00 AS Date), N'2017-2', N'Integrales definidas o por partes', N'No hubo asistencia', 82, N'1052998935', N'evid_149.jpg', CAST(0x5D3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (150, CAST(0x5D3D0B00 AS Date), N'2017-2', N'sustancia blanca gris y blanca ', N'', 72, N'1102581878', N'evid_150.PNG', CAST(0x343D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (151, CAST(0x5D3D0B00 AS Date), N'2017-2', N'MATRIZ ADJUNTA, MATRIZ INVERSA, MENOS ICOFACTORES', N'EJERCICIOS PRACTICOS', 83, N'1102873967', N'evid_151.jpg', CAST(0x493D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (152, CAST(0x5E3D0B00 AS Date), N'2017-2', N'Cuartiles en datos agrupados', N'se realizaron ejercicios que permitía la participación de las estudiantes, las cuales mostraron entendimiento', 80, N'1104015178', N'evid_152.rar', CAST(0x513D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (153, CAST(0x5E3D0B00 AS Date), N'2017-2', N'SOLUCIÓN DE VECTORES: SUMA, RESTA, MULTIPLICACIÓN, VECTOR UNITARIO', N'EJERCICIOS PROPUESTOS.', 83, N'1102873967', N'evid_153.rar', CAST(0x5E3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (154, CAST(0x5E3D0B00 AS Date), N'2017-2', N'MODALIDADES SENSORIALES ', N'El encuentro fue muy satisfactorio puesto que la didactica viva y la participacion activa fueron piezas claves para el aprendizaje. ', 73, N'1051829595', N'evid_154.jpg', CAST(0x513D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (155, CAST(0x5E3D0B00 AS Date), N'2017-2', N'PARCIAL PRIMER CORTE', N'Dentro de la metodología del parcial se realizó una encuesta a los estudiantes respecto a mi desempeño en el primer corte como monitor académico.', 62, N'1102878542', N'', CAST(0x4A3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (156, CAST(0x5E3D0B00 AS Date), N'2017-2', N'prueba de hipótesis para la media poblaciónal', N'la monitoria se llevo acabo el día miércoles 27 de septiembre \r\ncomo aun nos e me ha asignado salón para este día, ya que es un horario nuevo, pero si se están realizando.', 79, N'1102232208', N'evid_156.jpg', CAST(0x563D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (157, CAST(0x5F3D0B00 AS Date), N'2017-2', N'UNIDAD FORMAL ESPACIAL ', N'', 62, N'1102878542', N'', CAST(0x623D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (158, CAST(0x5F3D0B00 AS Date), N'2017-2', N'Ejercicios Propuestos del Ciclo Mientras', N'', 88, N'1102880538', N'evid_158.jpg', CAST(0x5C3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (159, CAST(0x5F3D0B00 AS Date), N'2017-2', N'No Hubo Asistencia de Estudiantes', N'', 88, N'1102880538', N'evid_159.jpg', CAST(0x4E3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (160, CAST(0x5F3D0B00 AS Date), N'2017-2', N'No Hubo Asistencia de Estudiantes', N'Los estudiantes de este grupo no asistieron en el día de hoy', 88, N'1102880538', N'evid_160.jpg', CAST(0x513D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (161, CAST(0x5F3D0B00 AS Date), N'2017-2', N'No Asistieron ', N'Este es el grupo 2 de Ingeniería Industrial', 88, N'1102880538', N'evid_161.jpg', CAST(0x553D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (162, CAST(0x5F3D0B00 AS Date), N'2017-2', N'clasificacion de las obligaciones en cuanto a los sujetos que intervienen', N'los estudiantes presentan dificultades al momento de realizar los cálculos matemáticos que implican las obligaciones conjuntas y solidarias ', 69, N'1102881228', N'evid_162.jpg', CAST(0x343D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (163, CAST(0x5F3D0B00 AS Date), N'2017-2', N'Varianza y Desviación Estándar (para datos agrupados y no agrupados) ', N'Se utilizo una metodología participativa donde los estudiante mostraron entendimiento, se resolvieron dudas y se empleo ejemplos claros para interpretar la función de esta medida de dispersión.', 80, N'1104015178', N'evid_163.rar', CAST(0x583D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (164, CAST(0x603D0B00 AS Date), N'2017-2', N'Evolución de la forma del proyecto: revisión', N'Como monitoria orienté a los estudiantes de manera personalizada acerca del proceso que han llevado en la evolución de sus proyectos mientras el profesor les hacía revisión del mismo.', 64, N'1102887140', N'evid_164.rar', CAST(0x5F3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (165, CAST(0x603D0B00 AS Date), N'2017-2', N'Hipótesis de diseño: evolución de la forma', N'En clase del día de hoy se hizo revisión a los estudiantes en sus ideas de diseño las cuales han ido evolucionando clase tras clase, como monitora respondí dudas de los estudiantes sobre dicho proceso', 64, N'1102887140', N'evid_165.rar', CAST(0x573D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (166, CAST(0x603D0B00 AS Date), N'2017-2', N'Tectonica, revision de plantas arquitectonicas teniendo en cuenta la funcionalidad y relación de cada espacio. ', N'No asistieron 5 alumnos. en el transcurso de la semana se habló con ellos para hacer la respectiva revisión en horarios diferentes de la clase de monitorias.', 66, N'1102861529', N'', CAST(0x353D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (167, CAST(0x603D0B00 AS Date), N'2017-2', N'teorías relacionadas sobre el surgimiento de la palabra arquitectura,desde su etimología.\r\n seminarios por cada estudiante. ', N'esta clase se realizó con el fin de evaluar a cada estudiante, su nivel de comprensión con respecto a el dialecto arquitectónico. ', 66, N'1102861529', N'evid_167.jpeg', CAST(0x273D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (168, CAST(0x603D0B00 AS Date), N'2017-2', N'el espacio en la arquitectura, teorías relacionadas desde la filosofía, hasta llegar a teóricos arquitectónicos. "la fenomenología del espacio" ', N'no asistieron 5 estudiantes. daniela pico, se cambio de grupo. \r\nla clase consistió en una mesa redonda, donde obligatoriamente cada estudiante debía aportar lo entendido en las lecturas. ', 66, N'1102861529', N'', CAST(0x8A3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (169, CAST(0x603D0B00 AS Date), N'2017-2', N'revision de imagen (fachadas de los objetos arquitectonicos por cada estudiante)\r\nseminario, tecnica y tectónica en la arquitectura. ', N'no asistieron 4 estudiantes. ', 66, N'1102861529', N'', CAST(0x3C3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (170, CAST(0x603D0B00 AS Date), N'2017-2', N'Revisión de plantas arquitectónicas, funcionalidad e imagen\r\nExplicación de protocolo de puntos a sustentar en el parcial del primer corte.', N'no asistieron 3 estudiantes. ', 66, N'1102861529', N'', CAST(0x433D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (171, CAST(0x603D0B00 AS Date), N'2017-2', N'Revisión de esquema básico - plantas tipo 1,2 y 3. \r\nRevisión de primeros acercamientos de la imagen final del proyecto', N'No asistieron 3 estudiantes. ', 66, N'1102861529', N'', CAST(0x583D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (172, CAST(0x603D0B00 AS Date), N'2017-2', N'Revisión de esquema básico\r\nImágenes proyectadas a mano alzada en isométricos, perspectivas y Skechts. ', N'No asistieron 6 estudiantes.\r\nSe acordó con el profesor revisar las actividades de estos estudiantes en el transcurso de la semana, para así, poder seguir en el proceso adecuado de entrega acorde. ', 66, N'1102861529', N'', CAST(0x5F3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (173, CAST(0x603D0B00 AS Date), N'2017-2', N'CORRECCIONES DE MATERIAL DE INVESTIGACIÓN, BITÁCORAS ', N'De manera personalizada se realizó correcciones de los diferentes temas correspondidos a MEDIO FÍSICO Y NATURAL, a través de estrategias que ayudarían a obtener la información de una manera mas precis', 62, N'1102878542', N'', CAST(0x433D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (174, CAST(0x613D0B00 AS Date), N'2017-2', N'ejercicios sobre Derivada, aplicacion de las propiedades de las derivadas', N'transcurrio en completa normalidad', 74, N'1102869404', N'evid_174.jpg', CAST(0x5F3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (175, CAST(0x613D0B00 AS Date), N'2017-2', N'La persona, conceptos, teorías y clasificación, curso C ', N'', 68, N'1131110675', N'evid_175.rar', CAST(0x2E3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (176, CAST(0x613D0B00 AS Date), N'2017-2', N'Análisis de sentencia. ¿Cómo analizar una sentencia? ', N'', 68, N'1131110675', N'evid_176.jpg', CAST(0x323D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (177, CAST(0x613D0B00 AS Date), N'2017-2', N'Atributos de la personalidad, el nombre. ', N'', 68, N'1131110675', N'evid_177.rar', CAST(0x393D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (178, CAST(0x613D0B00 AS Date), N'2017-2', N'Análisis de sentencia, atributos de la personalidad y el nombre ', N'', 68, N'1131110675', N'evid_178.rar', CAST(0x3A3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (179, CAST(0x613D0B00 AS Date), N'2017-2', N'Atributos de la personalidad: El domicilio ', N'', 68, N'1131110675', N'evid_179.jpg', CAST(0x403D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (180, CAST(0x613D0B00 AS Date), N'2017-2', N'Atributos de la personalidad: El estado civil de las personas curso B yC ', N'Se suspendieron las monitorias por 2 semanas debido a los parciales de primer corte, y se retoman de nuevo el día 27 de septiembre de 2017. ', 68, N'1131110675', N'evid_180.rar', CAST(0x563D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (181, CAST(0x613D0B00 AS Date), N'2017-2', N'PARABOLA', N'Ejercicio sobre el tema y respuesta a preguntas e inquietudes de los estudiantes.', 87, N'99112906300', N'evid_181.jpg', CAST(0x5C3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (182, CAST(0x613D0B00 AS Date), N'2017-2', N'PARABOLA', N'Nuevamente ejercicios sobre la temática, explicación y respuesta a incógnitas de los estudiantes.', 87, N'99112906300', N'evid_182.jpg', CAST(0x5E3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (183, CAST(0x623D0B00 AS Date), N'2017-2', N'Arquitectura y Clima', N'', 61, N'1066185095', N'', CAST(0x253D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (184, CAST(0x623D0B00 AS Date), N'2017-2', N'Metodología y guía de recolección de datos. ', N'', 61, N'1066185095', N'', CAST(0x2C3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (185, CAST(0x623D0B00 AS Date), N'2017-2', N'Plano topográfico ', N'', 61, N'1066185095', N'', CAST(0x333D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (186, CAST(0x623D0B00 AS Date), N'2017-2', N'El arte del espacio ', N'', 61, N'1066185095', N'', CAST(0x3A3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (187, CAST(0x623D0B00 AS Date), N'2017-2', N'Analisis del lote ', N'', 61, N'1066185095', N'', CAST(0x413D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (188, CAST(0x623D0B00 AS Date), N'2017-2', N'Revisión de Bitácoras y análisis del lote ', N'', 61, N'1066185095', N'', CAST(0x483D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (189, CAST(0x623D0B00 AS Date), N'2017-2', N'Marco Conceptual ', N'', 61, N'1066185095', N'', CAST(0x4F3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (190, CAST(0x623D0B00 AS Date), N'2017-2', N'La importancia de la tectónica ', N'', 61, N'1066185095', N'', CAST(0x5D3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (191, CAST(0x623D0B00 AS Date), N'2017-2', N'Revisión de diseño ', N'', 61, N'1066185095', N'', CAST(0x5D3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (192, CAST(0x623D0B00 AS Date), N'2017-2', N'Diseño y entorno', N'', 61, N'1066185095', N'', CAST(0x553D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (193, CAST(0x623D0B00 AS Date), N'2017-2', N'perfil topografico ', N'', 61, N'1066185095', N'', CAST(0x4E3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (194, CAST(0x623D0B00 AS Date), N'2017-2', N'aplicaciones de derivadas, ejercicios sobre derivadas aplicadas a situaciones problema', N'se realizo en completa normalidad, se resolvieron dudas sobre derivadas', 74, N'1102869404', N'evid_194.jpg', CAST(0x623D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (195, CAST(0x623D0B00 AS Date), N'2017-2', N'Evolución de la composición del parque y la plaza', N'En la clase de hoy se hizo revisión por parte del profesor y mía a los estudiantes sobre sus proyectos de diseño.', 64, N'1102887140', N'evid_195.rar', CAST(0x623D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (196, CAST(0x623D0B00 AS Date), N'2017-2', N'Evolución del proyecto de diseño', N'En la clase asesoré junto al profesor a estudiantes con dudas respecto al proceso de diseño de sus composiciones.', 64, N'1102887140', N'evid_196.rar', CAST(0x5D3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (197, CAST(0x633D0B00 AS Date), N'2017-2', N'Derivadas logarítmicas y exponenciales', N'Asistió del grupo B la estudiante Maria Luisa Castro Sanchez', 81, N'1102859256', N'evid_197.jpg', CAST(0x633D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (198, CAST(0x633D0B00 AS Date), N'2017-2', N'Estructura Repetitiva PARA', N'Los estudiantes en el día de hoy, no asistieron a las debida Monitorias.\r\nSe eles espero media hora De acuerdo al Horario Asignado.', 88, N'1102880538', N'evid_198.jpg', CAST(0x633D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (199, CAST(0x633D0B00 AS Date), N'2017-2', N'ATENCION ', N'Los estudiantes mostraron mucho interes durante el desarrollo de la clase. Fueron dinamicos y coherentes al momento de afianzar sus aprendizajes. ', 73, N'1051829595', N'evid_199.jpg', CAST(0x583D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (200, CAST(0x633D0B00 AS Date), N'2017-2', N'Ejercicios de la Estructura de Control PARA', N'Los estudiantes del Grupo I de Ingeniería de Sistemas No asistieron en el día de Hoy.', 88, N'1102880538', N'', CAST(0x633D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (201, CAST(0x633D0B00 AS Date), N'2017-2', N'No asistieron los estudiantes', N'No asistieron los estudiantes', 84, N'1096223217', N'evid_201.jpeg', CAST(0x633D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (202, CAST(0x633D0B00 AS Date), N'2017-2', N'Revisión de Maqueta y planetaria ', N'Los estudiantes llevan los materiales asignados para la clase y cada uno recibe una asesoría individual  ', 61, N'1066185095', N'', CAST(0x633D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (203, CAST(0x633D0B00 AS Date), N'2017-2', N'Estado civil de las personas, registro civil, funcionarios competentes, cómo se  llena un registro civil y causales de anulación del Registro civil', N'Falta anexar otras planillas del día de hoy, pero, por invonvenientes con el internet sólo me permite subir una, estaré subiendo el resto el día de mañana.', 68, N'1131110675', N'evid_203.jpg', CAST(0x633D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (204, CAST(0x633D0B00 AS Date), N'2017-2', N'taller sobre derivadas, aplicaciones de Derivadas', N'se realizo en completa calma y se resolvieron las dudas acerca del tema con participación activa de los estudiantes', 74, N'1102869404', N'evid_204.jpg', CAST(0x633D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (205, CAST(0x633D0B00 AS Date), N'2017-2', N'resumen 1 corte', N'', 72, N'1102581878', N'evid_205.PNG', CAST(0x3B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (206, CAST(0x633D0B00 AS Date), N'2017-2', N'Prueba de hipotesis para la media muestral.', N'La monitoria no se pudo relizar en el horario acordado y en el aula asignada que es la A206\r\nPor cuestiones de practicas pero se realizo en otro salon y se llevo acabo de manera satisfactoria con dos ', 79, N'1102232208', N'evid_206.jpg', CAST(0xCC3E0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (207, CAST(0x643D0B00 AS Date), N'2017-2', N'Teoría del consumidor. ', N'La clase se desarrollo con total normalidad, empezamos desarrollando el tema y posteriormente la explicación de dos ejercicios practico. Se desarrollo en el Aula A125 de 2PM-4PM. ', 101, N'98103070783', N'', CAST(0x633D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (208, CAST(0x643D0B00 AS Date), N'2017-2', N'historia romana sobre algunas obligaciones y clasificación de las obligaciones ', N'presentan inconformismo algunos estudiantes por que los temas son tratados por otros estudiantes mediante exposiciones y no lo exponen con claridad lo cual genera muchas dudas ', 69, N'1102881228', N'evid_208.jpg', CAST(0x333D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (209, CAST(0x643D0B00 AS Date), N'2017-2', N'Revisión de evolución del proyecto de diseño', N'En la clase de hoy ese revisó el proceso que llevan los estudiantes sus proyectos de diseño en lo referente a organización espacial de la composición', 64, N'1102887140', N'evid_209.rar', CAST(0x643D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (210, CAST(0x653D0B00 AS Date), N'2017-2', N'prueba de hipótesis para la media muestral', N'el dia miercoles 11 de octubre se relizo la monitoria de manera satisfactoria con 3 estudiantes del grupo 2-B de trabajo social VI semestre.', 79, N'1102232208', N'evid_210.jpeg', CAST(0x643D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (211, CAST(0x653D0B00 AS Date), N'2017-2', N'clasificación de las obligaciones en cuanto a la pluralidad de sujetos que intervienen en ella', N'manifestaron interés en esta clasificación de las obligaciones puesto que presentan vital importancia en la vida practica en lo teniente a los procesos ejecutivos', 69, N'1102881228', N'evid_211.jpg', CAST(0x3B3D0B00 AS Date))
GO
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (212, CAST(0x653D0B00 AS Date), N'2017-2', N'Evolución de la propuesta de diseño', N'Como monitora me acerqué a cada uno  de los estudiantes para resolver dudas que tenían acerca del avance formal de diseño para sus propuestas. ', 64, N'1102887140', N'evid_212.rar', CAST(0x653D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (213, CAST(0x663D0B00 AS Date), N'2017-2', N'Probabilidad, probabilidad de un evento, probabilidad condicional, distribución de probabilidad.', N'Pese a los llamados o invitaciones constates a las monitorias académicas en articulación con el docente siguen asistiendo pocos, sin embargo los que asisten muestran gran entendimiento y despejan duda', 80, N'1104015178', N'evid_213.rar', CAST(0x5F3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (214, CAST(0x663D0B00 AS Date), N'2017-2', N'PARABOLA', N'Si realizaron ejercicios y se respondieron dudas de los alumnos con participación de los mismo pasando al tablero.', 87, N'99112906300', N'evid_214.JPG', CAST(0x653D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (215, CAST(0x663D0B00 AS Date), N'2017-2', N'Prueba de hipotesis para la media y para la proporcion ', N'La clase se realizo de manera exitosa gracias a la articulacion entre la monitora y el docente de la asignatura...tambien asistio una estudiante de contaduria que ve la materia con el mismo docente.', 79, N'1102232208', N'evid_215.jpeg', CAST(0x663D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (216, CAST(0x663D0B00 AS Date), N'2017-2', N'Factorizacion LU', N'Desarrollo practico de ejercicios referentes al tema', 83, N'1102873967', N'evid_216.rar', CAST(0x653D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (217, CAST(0x663D0B00 AS Date), N'2017-2', N'Factorizacion  LU', N'Desarrollo de ejercicios sobre el tema pertinente ', 83, N'1102873967', N'evid_217.rar', CAST(0x663D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (218, CAST(0x663D0B00 AS Date), N'2017-2', N'VECTORES EN EL PLANO, SUMA VECTORIAL, VECTOR UNITARIO, MULTIPLICACIÓN ESCALAR, ÁNGULOS DE DOS VECTORES.', N'DESARROLLO DE EJERCICIOS ', 83, N'1102873967', N'evid_218.rar', CAST(0x5E3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (219, CAST(0x683D0B00 AS Date), N'2017-2', N'CORTES ARQUITECTÓNICOS- LONGITUDINAL Y TRANSVERSAL  DEL PROYECTO COPIA DE 2 NIVELES. ', N'LA CLASE SE DESARROLLO DE LA MEJOR MANERA DONDE LOS ESTUDIANTES DIERON LO MEJOR DE SI UNA DE LAS MEJORES MONITORIAS DADAS HASTA EL MOMENTO YA QUE SE DESARROLLO CON LA MEJOR DISCIPLINA ACLARANDO DUDAS.', 65, N'1102880103', N'evid_219.rar', CAST(0x643D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (220, CAST(0x683D0B00 AS Date), N'2017-2', N'corte arquitectónico- longitudinal y trasversal del proyecto copia  ', N'la monitoria se desarrollo de al margen de dudas que algunos estudiantes tenían, y la explicación general para desarrollar un corte arquitectónico. ', 65, N'1102880103', N'evid_220.jpg', CAST(0x653D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (221, CAST(0x683D0B00 AS Date), N'2017-2', N'acotado y ejercicio de planta arquitectónica de cafetería ', N'la monitoria se desarrollo después de la clase teórica expuesta por el docente, aclarando todas las dudas de los estudiantes. ', 65, N'1102880103', N'evid_221.rar', CAST(0x503D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (222, CAST(0x693D0B00 AS Date), N'2017-2', N'clasificación de las normas jurídicas primera parte', N'las clases se han desarrollado de manera participativa, donde ellos exponen sus puntos de vista a partir de la doctrina y las normas consultadas. ', 70, N'1103120601', N'evid_222.jpg', CAST(0x313D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (223, CAST(0x693D0B00 AS Date), N'2017-2', N'repaso sobre las clases de prestaciones ', N'las orientadas me solicitaron que les explicara nuevamente las clases de prestaciones porque no estaban claras en ello.', 70, N'1103120601', N'evid_223.jpg', CAST(0x2E3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (224, CAST(0x693D0B00 AS Date), N'2017-2', N'conflicto de las normas jurídicas ', N'explicación sobre el tema de los conflictos de  las normas jurídicas a la luz de la doctrina. ', 70, N'1103120601', N'evid_224.jpg', CAST(0x383D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (225, CAST(0x693D0B00 AS Date), N'2017-2', N'conflicto de las normas jurídicas desde el espacio y tiempo.', N'los estudiantes no están estudiando de manera idónea, ya que hacemos talleres en monitorias y han sabido como responder ante ciertos cuestionamientos. ', 70, N'1103120601', N'evid_225.rar', CAST(0x403D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (226, CAST(0x693D0B00 AS Date), N'2017-2', N'antinomia de las normas jurídicas ', N'realice un tipo de taller durante las monitorias y he quedado desconcertado por  que los orientados no están estudiando lo necesario para desarrollar los temas en el área de introductor al derecho   ', 70, N'1103120601', N'evid_226.rar', CAST(0x473D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (227, CAST(0x693D0B00 AS Date), N'2017-2', N'resumen ', N'', 72, N'1102581878', N'evid_227.PNG', CAST(0x3B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (228, CAST(0x693D0B00 AS Date), N'2017-2', N'clasificación de las obligaciones según la pluralidad de objetos ', N'los estudiantes presentan inconformidad sobre esa tematica porque en su curso lo han venido tratando con exposiciones y manifiestan que sus compañeros no exponen con claridad la temática ', 69, N'1102881228', N'', CAST(0x3A3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (229, CAST(0x693D0B00 AS Date), N'2017-2', N'Movimiento Uniforme, Movimiento Acelerado, Caida Libre, Vectores y Conversion de Unidades', N'', 90, N'1140845621', N'evid_229.jpg', CAST(0xA63C0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (230, CAST(0x693D0B00 AS Date), N'2017-2', N'Vectores, Conversion de Unidades, Movimiento Uniforme', N'', 90, N'1140845621', N'evid_230.jpg', CAST(0xA63C0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (231, CAST(0x693D0B00 AS Date), N'2017-2', N'Conversion de Unidades, Vectores, Ley del Seno y del Coseno', N'', 90, N'1140845621', N'evid_231.jpg', CAST(0xA63C0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (232, CAST(0x693D0B00 AS Date), N'2017-2', N'Vectores, Conversion de Unidades, Graficas y Movimientos (Cinematica)', N'', 90, N'1140845621', N'evid_232.jpg', CAST(0xA63C0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (233, CAST(0x693D0B00 AS Date), N'2017-2', N'Movimiento Uniforme y Movimiento Acelerado', N'', 90, N'1140845621', N'evid_233.jpg', CAST(0xA63C0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (234, CAST(0x693D0B00 AS Date), N'2017-2', N'Vectores, Conversion de Unidades y Movimiento Acelerado', N'', 90, N'1140845621', N'evid_234.jpg', CAST(0xA63C0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (235, CAST(0x693D0B00 AS Date), N'2017-2', N'Movimiento Uniforme y Acelerado', N'', 90, N'1140845621', N'evid_235.jpg', CAST(0xA63C0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (236, CAST(0x6A3D0B00 AS Date), N'2017-2', N'Lugares geométricos ', N'Ninguno ', 84, N'1096223217', N'evid_236.jpg', CAST(0x6A3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (237, CAST(0x6B3D0B00 AS Date), N'2017-2', N'cesión de derechos de derechos herenciales, litigiosos y de créditos y finalizacion de la clasificacion de las obligaciones', N'', 69, N'1102881228', N'evid_237.jpg', CAST(0x413D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (238, CAST(0x6B3D0B00 AS Date), N'2017-2', N'Integralea definidas', N'', 82, N'1052998935', N'', CAST(0x6B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (239, CAST(0x6B3D0B00 AS Date), N'2017-2', N'TANGENTE DE UN TRIÁNGULO', N'Explicación del tema por medio de ejemplos y participación de los alumnos en el pizarrón.', 87, N'99112906300', N'evid_239.jpg', CAST(0x6B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (240, CAST(0x6B3D0B00 AS Date), N'2017-2', N'Probabilidad de la unión de dos conjuntos, de igual forma se reforzó en el tema de identificar cuando los datos tienen distribución simétrica.  ', N'se puede observar que los estudiantes presentan dificultad de compresión, pues les cuesta mucho analizar lo que les pide un ejercicio. Nota: Se reforzara este problema en la próxima asesoría.', 80, N'1104015178', N'evid_240.jpeg', CAST(0x663D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (241, CAST(0x6C3D0B00 AS Date), N'2017-2', N'Presunciones. concepto, tipos, diferencias y ejemplos. Negocio Jurídico', N'', 68, N'1131110675', N'evid_241.jpg', CAST(0x6B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (242, CAST(0x6C3D0B00 AS Date), N'2017-2', N'vias afecrente y eferentes', N'', 72, N'1102581878', N'evid_242.PNG', CAST(0x263D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (243, CAST(0x6C3D0B00 AS Date), N'2017-2', N'MEMORIA Y OLVIDO', N'El encuentro pedagogico fue muy satisfactorio y efucaz, puesto que los estudiantes asumieron un rol mas autonomo y metacognitivo.', 73, N'1051829595', N'evid_243.jpg', CAST(0x5F3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (244, CAST(0x6D3D0B00 AS Date), N'2017-2', N'No asistieron los estudiantes. ', N'No asistieron los estudiantes ', 84, N'1096223217', N'evid_244.jpg', CAST(0x6D3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (245, CAST(0x6D3D0B00 AS Date), N'2017-2', N'Integrales definidas', N'No hubo asistencia por semana cultura ', 82, N'1052998935', N'', CAST(0x6D3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (246, CAST(0x6E3D0B00 AS Date), N'2017-2', N'INFORME MONITORIAS PRIMER CORTE', N'', 64, N'1102887140', N'evid_246.rar', CAST(0x4A3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (247, CAST(0x6E3D0B00 AS Date), N'2017-2', N'INFORME PRIMER CORTE MONITORIAS DISEÑO Y METODOLOGÍA III 2017-II', N'Contiene informe de monitorias para el primer corte de 2017-II', 64, N'1102887140', N'evid_247.rar', CAST(0x4A3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (248, CAST(0x6F3D0B00 AS Date), N'2017-2', N'ORGANIZACION DEL CONOCIMIENTO ', N'Muy buen manejo del tema. Los estudiantes demostraron dominio conceptual y seguridad a la hora de exponer el tema. ', 73, N'1051829595', N'evid_248.jpg', CAST(0x663D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (249, CAST(0x703D0B00 AS Date), N'2017-2', N'Equilibrio del consumidor. ', N'La clase se realizo en el Aula A125 de 2 PM- 3:30 PM, con la participación de 9 alumnos. Se desarrollo un taller de 3 ejercicios con previa explicación por parte del monitor.  ', 101, N'98103070783', N'', CAST(0x6A3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (250, CAST(0x703D0B00 AS Date), N'2017-2', N'Competencia en industrias fragmentadas.', N'', 102, N'98103070783', N'', CAST(0x653D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (251, CAST(0x703D0B00 AS Date), N'2017-2', N'costo marginal de una funcion, funcion derivada de problemas economicos, utilidad e ingreso marginal', N'se realizo en completa normalidad, donde se resolvieron las dudas acerca el tema', 74, N'1102869404', N'evid_251.jpg', CAST(0x703D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (252, CAST(0x703D0B00 AS Date), N'2017-2', N'Entrega de planimetrìa y maqueta de trabajo', N'Junto al profesor de seguimiento como monitora estuve presente en la entrega de la planimetrìa y maqueta correspondiente al proceso de diseño de este semestre', 64, N'1102887140', N'evid_252.rar', CAST(0x6B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (253, CAST(0x703D0B00 AS Date), N'2017-2', N'Revisión de planimetrìa y maqueta de trabajo', N'Como monitora asesore a los estudiante en dudas que tuviesen con respecto a la planimetria y el diseño como tal que están llevando a cabo', 64, N'1102887140', N'evid_253.rar', CAST(0x703D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (254, CAST(0x713D0B00 AS Date), N'2017-2', N'Ciclo para y condicionales', N'Ninguno de los dos grupos en el dia de hoy, se presento en las monitorias. Es decir, ni el de 10-12 de Ingenieria Industrial, ni de 1-3pm de Ingenieria de Sistemas ', 88, N'1102880538', N'evid_254.jpg', CAST(0x6A3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (255, CAST(0x713D0B00 AS Date), N'2017-2', N'Ciclos repetitivos con Condicionales', N'Este grupo de Industrial no asisitio en el dia de hoy. ', 88, N'1102880538', N'evid_255.jpg', CAST(0x663D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (256, CAST(0x713D0B00 AS Date), N'2017-2', N'Ninguno ', N'No asistieron los estudiantes ', 84, N'1096223217', N'evid_256.png', CAST(0x713D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (257, CAST(0x713D0B00 AS Date), N'2017-2', N'Tablas termodinámica ', N'', 85, N'1102877863', N'', CAST(0x703D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (258, CAST(0x713D0B00 AS Date), N'2017-2', N'Primera hipótesis de diseño ', N'', 61, N'1066185095', N'', CAST(0x6B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (259, CAST(0x713D0B00 AS Date), N'2017-2', N'Esquema de diseño ', N'', 61, N'1066185095', N'', CAST(0x643D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (260, CAST(0x713D0B00 AS Date), N'2017-2', N'Regresion lineal simple', N'La monitoria se realizo en un aula que\r\nSe encontraba disponible y las estufiantes entendieron bien el tema.', 79, N'1102232208', N'evid_260.jpg', CAST(0x713D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (261, CAST(0x723D0B00 AS Date), N'2017-2', N'SUMA DE SENO, COSE Y TANGENTE', N'Realización de ejercicios sobre la temática, práctica de los estudiantes al tablero y prevenciones que tienen que tener en cuenta en base al tema.', 87, N'99112906300', N'evid_261.jpg', CAST(0x713D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (262, CAST(0x723D0B00 AS Date), N'2017-2', N'Regresion lineal simple,fueron estudiantes de los dos cursos.La adistencia a las monitorias no es tan alta debido a que los cursos no son tan grandes', N'La clase de llevo acabo con pocas estudiantes pero la retroalimrntacion fue muy significativa.', 79, N'1102232208', N'evid_262.jpeg', CAST(0x6D3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (263, CAST(0x723D0B00 AS Date), N'2017-2', N'planta de cubierta del proyecto copia 2 pisos ', N'la monitoria  se desarrollo al margen de la clase en donde los estudiantes aclararon sus dudas y adquirieron los conocimientos brindados por el docente. ', 65, N'1102880103', N'evid_263.rar', CAST(0x723D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (264, CAST(0x723D0B00 AS Date), N'2017-2', N'ANGULO DOBLE', N'Explicación del tema y respuesta de inquietudes de los estudiantes.', 87, N'99112906300', N'evid_264.jpg', CAST(0x723D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (265, CAST(0x723D0B00 AS Date), N'2017-2', N'Distribución de Probabilidad', N'Se explico las característica de un districicón binomial para que pueda iidentificar cuando se encuentren a un ejercicio de este tipo, identificando que representa un éxito y un fracaso.', 80, N'1104015178', N'evid_265.rar', CAST(0x6D3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (266, CAST(0x733D0B00 AS Date), N'2017-2', N'resumen 1 corte', N'', 72, N'1102581878', N'evid_266.PNG', CAST(0x423D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (267, CAST(0x733D0B00 AS Date), N'2017-2', N'Derivadas trigonométricas, derivadas exponenciales y logarítmicas. ', N'Se hizo la monitoria hoy jueves para recuperar clases perdidas anteriormente debido a incapacidad medica.', 81, N'1102859256', N'', CAST(0x733D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (268, CAST(0x733D0B00 AS Date), N'2017-2', N'planta de cubierta ', N'la monitoria se desarrollo al margen de la clase con un ejercicio de aplicación asignado por el docente dando paso  a la monitoria, posterior  de la teoría explicada.', 65, N'1102880103', N'evid_268.rar', CAST(0x733D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (269, CAST(0x733D0B00 AS Date), N'2017-2', N'Tablas de termodinamica', N'', 85, N'1102877863', N'', CAST(0x723D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (270, CAST(0x733D0B00 AS Date), N'2017-2', N'Distribución de Distribución Binomial (Tablas y Gráficos)', N'Durante el desarrollo de la asesoría se logro que los estudiantes mediante la utilización de formula binomial construyan una tabla de distribución y a partir de esta hacer su respectiva grafico, media', 80, N'1104015178', N'evid_270.rar', CAST(0x713D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (271, CAST(0x743D0B00 AS Date), N'2017-2', N'PIB nominal y PIB real. ', N'', 106, N'98103070783', N'', CAST(0x733D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (272, CAST(0x743D0B00 AS Date), N'2017-2', N'Suma y resta de ángulos', N'Se preparó a los estudiantes para una exposición, aunque no fueron los estudiantes del grupo asignado, se tomó el espacio para el aprovechamiento de la monitoria. ', 84, N'1096223217', N'', CAST(0x743D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (273, CAST(0x743D0B00 AS Date), N'2017-2', N'Regresion lineal simple, Prueba de hipotesis', N'La monitoria se llevo acabo en el Aula\r\nDe manera efectiva pero desafortunadamente se me borraron las evidencias de el dia de hoy, por lo que adjunto agrego fotos de la asistencia', 79, N'1102232208', N'evid_273.jpeg', CAST(0x743D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (274, CAST(0x743D0B00 AS Date), N'2017-2', N'Distribución de Probabilidad Binomial', N'se trabajo con alianza con el docente de la asignatura donde se asesoró en un taller asignado por este acerca del tema, se mostró mucho entendimiento en estudiantes y asistieron más de lo normal, teni', 80, N'1104015178', N'evid_274.rar', CAST(0x723D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (275, CAST(0x743D0B00 AS Date), N'2017-2', N'coeficiente de simetría, diagrama de caja y bigote.', N'se explico como se puede realizar un diagrama de caja y bigote mediante cuartiles y poder identificar cuando hay simetría en una distribución de frecuencia y diagrama ce barra.', 80, N'1104015178', N'', CAST(0x583D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (276, CAST(0x753D0B00 AS Date), N'2017-2', N'Evolución formal del proyecto', N'En la clase estuve acercándome a los estudiantes para llenar algunos vacios que tenían respecto a sus proyectos con el fin de que pusieran adelantar más.', 64, N'1102887140', N'evid_276.rar', CAST(0x733D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (277, CAST(0x753D0B00 AS Date), N'2017-2', N'PRE- ENTREGA DE LA COMPOSICIÓN ARQUITECTÓNICA QUE RESPONDA AL MEDIO FÍSICO-NATURAL ', N'Dentro de la clase, fue posible corregir la expresión de los planos y algunas sugerencias para la presentación del Parcial Final ', 62, N'1102878542', N'', CAST(0x743D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (278, CAST(0x763D0B00 AS Date), N'2017-2', N'Vectores', N'Dinamica grafica ', 83, N'1102873967', N'evid_278.rar', CAST(0x6C3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (279, CAST(0x763D0B00 AS Date), N'2017-2', N'PROYECCION VECTORIAL', N'SOLUCION DE EJERCICIOS PRACTICOS', 83, N'1102873967', N'evid_279.rar', CAST(0x733D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (280, CAST(0x763D0B00 AS Date), N'2017-2', N'VECTOR UNITARIO, ANGULOS DE VECTORES, ', N'EJERCICIOS APLICATIVOS', 83, N'1102873967', N'evid_280.rar', CAST(0x6D3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (281, CAST(0x763D0B00 AS Date), N'2017-2', N'PROYECCIÓN VECTORIAL, PRODUCTO CRUZ', N'EXPLICACIÓN DE LA TEMÁTICA Y APLICACIÓN DE EJERCICIOS.', 83, N'1102873967', N'evid_281.rar', CAST(0x743D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (282, CAST(0x773D0B00 AS Date), N'2017-2', N'Integrales, problemas de integrales, propiedades de las integrales', N'se realizo en completa normalidad, se resolvieron todas las dudas acerca del tema', 74, N'1102869404', N'evid_282.jpg', CAST(0x773D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (283, CAST(0x783D0B00 AS Date), N'2017-2', N'Suma y diferencia de ángulos ', N'Se demostró la fórmula de tangente partiendo de seno y coseno. Y se trabajaron ejercicios ', 84, N'1096223217', N'evid_283.jpg', CAST(0x783D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (284, CAST(0x783D0B00 AS Date), N'2017-2', N'Industrias concentradas: Maximizacion de beneficios. ', N'', 102, N'98103070783', N'', CAST(0x783D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (285, CAST(0x783D0B00 AS Date), N'2017-2', N'Efecto sustitución.', N'', 101, N'98103070783', N'', CAST(0x713D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (286, CAST(0x793D0B00 AS Date), N'2017-2', N'ejercicio de aplicación de cubierta arquitectónica, diagramacion de planchas explicativas.', N'la clase se desarrollo de la mejor manera, junto al docente. ', 65, N'1102880103', N'evid_286.rar', CAST(0x793D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (287, CAST(0x793D0B00 AS Date), N'2017-2', N'Operaciones en Conjuntos', N'Se realizó trabajo a nivel individual, realización de ejercicios y profundización en la temática. ', 71, N'1102878423', N'evid_287.jpg', CAST(0x543D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (288, CAST(0x793D0B00 AS Date), N'2017-2', N'Operaciones en Conjuntos', N'Explicación de las generalidades de la temática, realización de taller y profundización en subtemas. ', 71, N'1102878423', N'evid_288.jpg', CAST(0x543D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (289, CAST(0x793D0B00 AS Date), N'2017-2', N'obligaciones solidarias y obligaciones de medio y resultado', N'', 69, N'1102881228', N'evid_289.jpg', CAST(0x8D3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (290, CAST(0x7B3D0B00 AS Date), N'2017-2', N'Revisión de proyectos', N'En clase estuve junto al profesor revisando y asesorando a los estudiantes sobre dudas que tuvieses sobre el desarrollo de sus proyectos. ', 64, N'1102887140', N'evid_290.rar', CAST(0x773D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (291, CAST(0x7B3D0B00 AS Date), N'2017-2', N'Revisión de planimetria y maquetas', N'En la clase asesoré a los estudiantes sobre tenias para representar planimetrias y maqueta en sus parciales', 64, N'1102887140', N'evid_291.rar', CAST(0x723D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (292, CAST(0x7B3D0B00 AS Date), N'2017-2', N'Revisión adelantos para parcial', N'Estuve asesorando a los estudiante sobre dudas que tuviesen sobre sus proyectos y les di algunas recomendaciones', 64, N'1102887140', N'evid_292.rar', CAST(0x773D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (293, CAST(0x7B3D0B00 AS Date), N'2017-2', N'PRE entrega de parcial', N'Estuve revisando finalmente los proyectos finales y haciendo recomendaciones para los requerimientos que tendrán que cumplir en el parcial', 64, N'1102887140', N'evid_293.rar', CAST(0x793D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (294, CAST(0x7C3D0B00 AS Date), N'2017-2', N'obligaciones solidarias ( pluralidad de sujetos) y ficcion juridica de la subrogacion ', N'', 69, N'1102881228', N'evid_294.jpg', CAST(0x5C3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (295, CAST(0x7C3D0B00 AS Date), N'2017-2', N'transmisión de las obligaciones', N'', 69, N'1102881228', N'evid_295.jpg', CAST(0x643D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (296, CAST(0x7C3D0B00 AS Date), N'2017-2', N'Transmisión de las obligaciones y la clausula de reserva o aceptación con reserva', N'', 69, N'1102881228', N'evid_296.jpg', CAST(0x653D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (297, CAST(0x7C3D0B00 AS Date), N'2017-2', N'Extinción de las obligaciones', N'los estudiantes manifestaron la poca claridad en el tema', 69, N'1102881228', N'evid_297.jpg', CAST(0x6B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (298, CAST(0x7C3D0B00 AS Date), N'2017-2', N'No se realizo la monitoria por el Simulacro de evacuación a nivel nacional y por conferencia en el aula múltiple, con el compromiso de recuperarla', N'', 69, N'1102881228', N'evid_298.jpg', CAST(0x723D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (299, CAST(0x7C3D0B00 AS Date), N'2017-2', N'Regresion Lineal Simple', N'El dia de ayer no asistio nadie a la ultima monitoria del semestre.. pero la monitora espero en el aula A206 hasta el ultimo momento.', 79, N'1102232208', N'evid_299.jpeg', CAST(0x7B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (300, CAST(0x7C3D0B00 AS Date), N'2017-2', N'Regresion Lineal Simple y prueba de hipotesis', N'No asistio ningun estudiante a la monitoria del dia 3 de noviembre, la monitora espero hasta el ultimo momento en el aula A206', 79, N'1102232208', N'evid_300.jpeg', CAST(0x7B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (301, CAST(0x7C3D0B00 AS Date), N'2017-2', N'Regresion lineal simple, tema final \r\n', N'Se realizo la respectiva citacion y no asistio ningun estudiante debido a que la mayoria de los alumnos del grupo 1 de  t.s estan en practicas', 79, N'1102232208', N'evid_301.jpeg', CAST(0x793D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (302, CAST(0x7C3D0B00 AS Date), N'2017-2', N'Revision de la propuesta final del proyecto: \r\ncortes, alzados, diseño de la cubierta , plantas arquitectonicas y planta de emplazamiento', N'el desarrollo de la clase se dio entorno a los errores que cometieron los estudiantes en el momento de plasmar sus ideas en la bitácora, en compañia del docente y mi persona se corrigieron uno a uno. ', 66, N'1102861529', N'evid_302.jpeg', CAST(0x4F3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (303, CAST(0x7C3D0B00 AS Date), N'2017-2', N'Revision de imagenes del proyecto, incluido el marco conceptual del proyecto final. ', N'Se corrigieron las falencias que tiene los estudiantes en el marco conceptual, el docente les dio una clase sobre el dibujo arquitectonico, a pesar de no ser docente de esa asignatura. ', 66, N'1102861529', N'', CAST(0x483D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (304, CAST(0x7C3D0B00 AS Date), N'2017-2', N'Preentrega de la propuesta final a nivel de esquema básico, ', N'las revisiones de hicieron uno a uno con el fin de potencializar las debilidades de cada estudiante, el docente se tome las dos ultimas horas para realizar una clase de dibujo arquitectonico', 66, N'1102861529', N'evid_304.jpeg', CAST(0x583D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (305, CAST(0x7C3D0B00 AS Date), N'2017-2', N'Extinción de la personalidad jurídica y rescisión de la sentencia que declara la muerte por desaparición presunta. ', N'25/Octubre/2017 ', 68, N'1131110675', N'evid_305.jpg', CAST(0x723D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (306, CAST(0x7C3D0B00 AS Date), N'2017-2', N'Proyección vectorial\r\nEcuaciones en el plano tridimensional\r\n   *Ecuación paramètrica\r\n   *Ecuación simétrica\r\n   *Ecuación cartesiana', N'Ejercicios prácticos para el desarrollado y comprensión de los temas a evaluar.', 83, N'1102873967', N'evid_306.rar', CAST(0x7A3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (307, CAST(0x7C3D0B00 AS Date), N'2017-2', N'Proyección vectorial\r\nEcuaciones en el plano tridimensional\r\n   *Ecuación paramètrica\r\n   *Ecuación simétrica\r\n   *Ecuación cartesiana', N'Desarrollos de ejercicios prácticos sobre temas a evaluar.', 83, N'1102873967', N'evid_307.rar', CAST(0x7B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (308, CAST(0x7D3D0B00 AS Date), N'2017-2', N'Composición con Rampa', N'En la clase se estuvo viendo las dimensiones de las rampas y se comenzó con una pequeña composición con el uso de está; el grupo se desenvolvió de buena forma, tomaron rápido la idea.', 63, N'1102876420', N'evid_308.rar', CAST(0x563D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (309, CAST(0x7D3D0B00 AS Date), N'2017-2', N'Escaleras y lineamientos para el parcial final.', N'En esta etapa el grupo fue dividido en dos, por ende solo unos cuantos asistían los miércoles a la clase. Se comenzó con el empleo y realización de una escalera para luego explicar el parcial final. ', 63, N'1102876420', N'evid_309.rar', CAST(0x833D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (310, CAST(0x7D3D0B00 AS Date), N'2017-2', N'Primera idea de diseño para el parcial y correcciones.', N'En la clase se estuvo detallando mucho mas la composición y respondiendo dudas acerca de la memoria explicativa y cerramiento del diseño.', 63, N'1102876420', N'evid_310.rar', CAST(0x8A3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (311, CAST(0x7D3D0B00 AS Date), N'2017-2', N'Continuación de la revisión del parcial y detalles planimetricos.', N'En la clase se estuvo pasando puesto por puesto para ver como iba los avances de la maqueta y del parcial en general, se resolvieron dudas de los planos, fachadas, cortes y perspectivas. ', 63, N'1102876420', N'evid_311.rar', CAST(0x723D0B00 AS Date))
GO
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (312, CAST(0x7D3D0B00 AS Date), N'2017-2', N'Segunda Preentrega, revisión de propuesta a esquema basico. ', N'Los estudiantes se preparan para dar ultimatun a sus ultimas correcciones para presentar la propuesta final en el dia del parcial. ', 66, N'1102861529', N'evid_312.jpeg', CAST(0x5F3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (313, CAST(0x7D3D0B00 AS Date), N'2017-2', N'Correcciones finales ', N'Esta fue la ultima clase con el grupo 2, solo unos cuantos mostraron avances de memorias explicativas finales. Por motivos de salud, la docente no fue pero se  mantuvo la monitoria de igual forma. ', 63, N'1102876420', N'evid_313.rar', CAST(0x793D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (314, CAST(0x7E3D0B00 AS Date), N'2017-2', N'Tablas de termodinamica', N'', 85, N'1102877863', N'', CAST(0x793D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (315, CAST(0x7E3D0B00 AS Date), N'2017-2', N'Teoría y equilibrio del consumidor. ', N'Esta clase se realizo un miércoles, a pesar que en ese día no esta mi horario de monitoria, se hizo lo posible por organizar esta clase a petición del docente. ', 101, N'98103070783', N'', CAST(0x6B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (316, CAST(0x7E3D0B00 AS Date), N'2017-2', N'T.I y anexo de PIB', N'', 106, N'98103070783', N'', CAST(0x733D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (317, CAST(0x7E3D0B00 AS Date), N'2017-2', N'Teoría de juegos y modelos oligopólicos. ', N'', 102, N'98103070783', N'', CAST(0x6C3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (318, CAST(0x7F3D0B00 AS Date), N'2017-2', N'diseño del proyecto', N'', 61, N'1066185095', N'', CAST(0x783D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (319, CAST(0x7F3D0B00 AS Date), N'2017-2', N'diseño del proyecto', N'', 61, N'1066185095', N'', CAST(0x793D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (320, CAST(0x7F3D0B00 AS Date), N'2017-2', N'Tablas de termodinamica', N'', 85, N'1102877863', N'', CAST(0x7B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (321, CAST(0x7F3D0B00 AS Date), N'2017-2', N'DESIGUALDADES', N'Clase realizada ', 87, N'99112906300', N'', CAST(0x583D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (322, CAST(0x7F3D0B00 AS Date), N'2017-2', N'DESIGUALDADES', N'', 87, N'99112906300', N'', CAST(0x5B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (324, CAST(0x7F3D0B00 AS Date), N'2017-2', N'Parabola', N'Explicación del tema y participación de los alumnos.', 87, N'99112906300', N'', CAST(0x5C3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (325, CAST(0x7F3D0B00 AS Date), N'2017-2', N'Factorización (repaso)', N'Repaso del tema por petición del alumno.\r\n\r\nPDT: Evidencia presentada en informe al fina, la plataforma no me deja subirla', 87, N'99112906300', N'', CAST(0x5D3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (327, CAST(0x7F3D0B00 AS Date), N'2017-2', N'Parábola', N'Explicación del tema y ejemplos', 87, N'99112906300', N'', CAST(0x5E3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (328, CAST(0x7F3D0B00 AS Date), N'2017-2', N'Parábola', N'Explicación del tema y ejemplos', 87, N'99112906300', N'', CAST(0x5F3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (329, CAST(0x7F3D0B00 AS Date), N'2017-2', N'Parábola', N'Ejemplos y ejercicios', 87, N'99112906300', N'', CAST(0x623D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (330, CAST(0x803D0B00 AS Date), N'2017-2', N'PARÁBOLA', N'Ejercicios y explicación de los mismos', 87, N'99112906300', N'', CAST(0x633D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (331, CAST(0x803D0B00 AS Date), N'2017-2', N'Parábola', N'Nuevamente explicación del tema al alumnos y respuesta de algunas dudas', 87, N'99112906300', N'', CAST(0x643D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (332, CAST(0x803D0B00 AS Date), N'2017-2', N'PARÁBOLA', N'Ejercicios y explicación de cómo se hacen.', 87, N'99112906300', N'', CAST(0x663D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (333, CAST(0x803D0B00 AS Date), N'2017-2', N'PARÁBOLA', N'', 87, N'99112906300', N'', CAST(0x693D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (334, CAST(0x803D0B00 AS Date), N'2017-2', N'TANGENTE DE UN ÁNGULO', N'Explicación y ejemplos del tema', 87, N'99112906300', N'', CAST(0x6A3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (335, CAST(0x803D0B00 AS Date), N'2017-2', N'Tangente de un triángulo y parábola', N'Explicación de temas y ejemplos', 87, N'99112906300', N'', CAST(0x6B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (336, CAST(0x803D0B00 AS Date), N'2017-2', N'TANGENTE DE UN TRIÁNGULO', N'Explicación y ejemplos', 87, N'99112906300', N'', CAST(0x6C3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (337, CAST(0x803D0B00 AS Date), N'2017-2', N'TANGENTE DE UN TRIÁNGULO', N'Ejercicios y como hacerlos, respondiendo así duda de los alumnos.', 87, N'99112906300', N'', CAST(0x6D3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (338, CAST(0x803D0B00 AS Date), N'2017-2', N'tangente de un triangulo', N'explicacion y ejemplos', 87, N'99112906300', N'', CAST(0x703D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (339, CAST(0x803D0B00 AS Date), N'2017-2', N'tangente de un triangulo', N'participacion del alumno en ejercicios', 87, N'99112906300', N'', CAST(0x713D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (340, CAST(0x803D0B00 AS Date), N'2017-2', N'angulo doble', N'explicacion y ejemplos', 87, N'99112906300', N'', CAST(0x723D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (341, CAST(0x803D0B00 AS Date), N'2017-2', N'angulo doble', N'ejemplos y como debe realizarlo', 87, N'99112906300', N'', CAST(0x733D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (342, CAST(0x803D0B00 AS Date), N'2017-2', N'suma y resta de productos', N'explicacion del tema y puntos importantes', 87, N'99112906300', N'', CAST(0x743D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (343, CAST(0x803D0B00 AS Date), N'2017-2', N'suma y resta de productos', N'repaso del tema con ejercicios', 87, N'99112906300', N'', CAST(0x773D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (344, CAST(0x803D0B00 AS Date), N'2017-2', N'SUMA Y RESTA DE PRODUCTOS', N'Nuevamente ejemplos y puntos importantes que hay que tener en cuenta.', 87, N'99112906300', N'', CAST(0x783D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (345, CAST(0x803D0B00 AS Date), N'2017-2', N'CORRECCIÓN MEMORIA EXPLICATIVA ', N'', 62, N'1102878542', N'', CAST(0x7B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (346, CAST(0x813D0B00 AS Date), N'2017-2', N'Operaciones con conjuntos', N'Se realizó explicación sobre la temática abordada y se realizaron ejercicios de taller con su respectiva socializacion individual y luego a los compañeros. ', 71, N'1102878423', N'evid_346.jpg', CAST(0x543D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (347, CAST(0x823D0B00 AS Date), N'2017-2', N'INFORME SEGUNDO CORTE DE MONITORIAS DISEÑO Y METODOLOGÍA III', N'', 64, N'1102887140', N'evid_347.rar', CAST(0x823D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (348, CAST(0x853D0B00 AS Date), N'2017-2', N'EMOCION Y MOTIVACION ', N'El encuentro dio resltados satisfactorios. Los estudiantes mostraron un desempeño de calidad ', 73, N'1051829595', N'evid_348.jpg', CAST(0x6D3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (349, CAST(0x863D0B00 AS Date), N'2017-2', N'Diagramas de Cuerpo libre', N'Baja Asistencia de los estudiantes', 90, N'1140845621', N'evid_349.jpg', CAST(0xA63C0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (350, CAST(0x863D0B00 AS Date), N'2017-2', N'Leyes de Newton y Diagramas de Cuerpo Libre', N'Muy poca asistencia de los estudiantes', 90, N'1140845621', N'evid_350.jpg', CAST(0xA63C0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (351, CAST(0x863D0B00 AS Date), N'2017-2', N'Leyes de Newton y Diagramas de Cuerpo Libre', N'Poca Asistencia', 90, N'1140845621', N'evid_351.jpg', CAST(0xA63C0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (352, CAST(0x863D0B00 AS Date), N'2017-2', N'Diagramas de Cuerpo Libre y Plano Inclinado', N'Poca Asistencia', 90, N'1140845621', N'evid_352.jpg', CAST(0xA63C0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (353, CAST(0x863D0B00 AS Date), N'2017-2', N'Sistemas de Energia, Balance de Energia y Trabajo', N'Poca Asistencia', 90, N'1140845621', N'evid_353.jpg', CAST(0xA63C0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (354, CAST(0x863D0B00 AS Date), N'2017-2', N'Ecuaciones de Energia', N'Poca Asistencia', 90, N'1140845621', N'evid_354.jpg', CAST(0xA63C0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (355, CAST(0x863D0B00 AS Date), N'2017-2', N'Repaso general temáticas primer corte', N'Se realizó repaso general sobre primer corte y temáticas iniciales para segundo corte, por medio de trabajo a nivel individual y grupal. ', 71, N'1102878423', N'evid_355.jpg', CAST(0x573D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (356, CAST(0x863D0B00 AS Date), N'2017-2', N'Introduccion a tematicas de segundo corte', N'Realizacion de ejercicios y participacion activa de los estudiantes, con el finde poner en practica el modelo social cognitivo', 71, N'1102878423', N'evid_356.jpg', CAST(0x5E3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (357, CAST(0x863D0B00 AS Date), N'2017-2', N'Temáticas de segundo corte', N'Explicación de temáticas y Realización de ejercicios de forma individual ', 71, N'1102878423', N'evid_357.jpg', CAST(0x623D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (358, CAST(0x863D0B00 AS Date), N'2017-2', N'Operaciones con conjuntos y diagrama de Veen', N'Explicacion general y realizacion de ejercicios de forma individual en el tablero, con su posterior explicacion a los compañeros', 71, N'1102878423', N'evid_358.jpg', CAST(0x663D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (359, CAST(0x863D0B00 AS Date), N'2017-2', N'Realización de taller de conjuntos ', N'Taller y ejercicios de conjuntos bajo la dinámica del papel dentro de la bolsa, donde de forma aleatoria los estudiantes escogen un ejercicio lo realizan y lo exponen a sus compañeros', 71, N'1102878423', N'evid_359.jpg', CAST(0x6C3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (360, CAST(0x863D0B00 AS Date), N'2017-2', N'Simulacro de Parcial de Segundo Corte', N'Se realizo el simulacro de parcial de segundo corte con su posterior retroalimentacion, resolución de dudas e inquietudes. ', 71, N'1102878423', N'evid_360.jpg', CAST(0x733D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (361, CAST(0x863D0B00 AS Date), N'2017-2', N'Explicación general sobre Operaciones en conjunto, diagrama de Veen y Silogismo ', N'Asesoría sobre las temáticas de segundo corte, específicamente sobre operaciones en conjunto, diagrama de Veen y silogismo con su respectiva ejemplificacion.', 71, N'1102878423', N'evid_361.jpg', CAST(0x773D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (362, CAST(0x863D0B00 AS Date), N'2017-2', N'EXPOSICIONES ', N'Los estudiantes demostraron un buen desempeño de todos los temas, se expresaron con propiedad y con seguridad.', 73, N'1051829595', N'evid_362.jpg', CAST(0x7B3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (363, CAST(0x863D0B00 AS Date), N'2017-2', N'SITUACIÓN ABSTRACTA Y SITUACIÓN CONCRETA EN DERECHO.', N'LOS ESTUDIANTES HAN ESTADO ATENTOS A LAS ASESORÍAS ACADÉMICAS ', 70, N'1103120601', N'evid_363.jpg', CAST(0x523D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (364, CAST(0x873D0B00 AS Date), N'2017-2', N'Derecho General, Clasificación del Derecho, Conceptos básicos de Derecho. ', N'Los estudiantes han atendido la monitoria de buena manera, aparte de asistir puntualmente y hacer preguntas relevantes. ', 67, N'1102836723', N'evid_364.rar', CAST(0x333D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (365, CAST(0x873D0B00 AS Date), N'2017-2', N'Persona natural y persona jurídica', N'Aumentan la asistencia de los estudiantes a la monitoria. ', 67, N'1102836723', N'evid_365.rar', CAST(0x3A3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (366, CAST(0x873D0B00 AS Date), N'2017-2', N'Presunción de la concepción, impugnación de la paternidad en materia civil.', N'No asistieron todos los estudiantes porque se cambió constantemente el lugar donde se realizaban las monitorias y no estaban seguros de donde llegar. ', 67, N'1102836723', N'evid_366.rar', CAST(0x223D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (367, CAST(0x873D0B00 AS Date), N'2017-2', N'Atributos de la personalidad ', N'Aumenta el número de estudiantes, ya se cuenta con un lugar específico para impartir la monitoria con la comodidad y necesidades requeridas. ', 67, N'1102836723', N'evid_367.rar', CAST(0x563D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (368, CAST(0x873D0B00 AS Date), N'2017-2', N'Análisis jurisprudencial y conceptos básicos de jurisprudencias. ', N'Los estudiantes asisten con dudas sobre un trabajo dejado en clase, además se les explica de manera conceptual y práctica para que tengan el adecuado manejo del tema. ', 67, N'1102836723', N'evid_368.rar', CAST(0x643D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (369, CAST(0x873D0B00 AS Date), N'2017-2', N'Se realizó un repaso general de toda la asignatura para reforzar los conocimientos y ayudar con la preparación de los estudiantes para el parcial.', N'Los estudiantes se sienten preparados para el examen parcial. Se realizaron monitorias en horarios extra académicos de las cuales no se tiene constancia, se realizaron tanto en la universidad y fuera.', 67, N'1102836723', N'evid_369.rar', CAST(0x793D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (370, CAST(0x873D0B00 AS Date), N'2017-2', N'REFERENTES TEXTUALES.\r\nMACROESTRUCTURA TEXTUAL.', N'FUE UNA ASESORÍA AMENA Y PARTICIPATIVA.', 95, N'1007621090', N'evid_370.jpg', CAST(0x5E3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (371, CAST(0x8C3D0B00 AS Date), N'2017-2', N'Derivadas Trigonometricas', N'', 81, N'1102859256', N'', CAST(0x693D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (372, CAST(0x8C3D0B00 AS Date), N'2017-2', N'Derivadas trigonometricas', N'Asistio la joven Maria Luisa Castro, la cual no aparece en esta lista', 81, N'1102859256', N'', CAST(0x6D3D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (373, CAST(0x8E3D0B00 AS Date), N'2017-2', N'Derivadas exponenciales y logarítmicas', N'', 81, N'1102859256', N'', CAST(0x713D0B00 AS Date))
INSERT [dbo].[clases_sima] ([id], [fecha_registro], [periodo], [tema], [comentario], [cursos_id], [usuarios_id], [evidencia], [fecha_realizada]) VALUES (374, CAST(0xF23D0B00 AS Date), N'2018-1', N'gsdhsdsdjs', N'hjeuiewiueriu', 114, N'1005575218', N'-', CAST(0xFE3D0B00 AS Date))
SET IDENTITY_INSERT [dbo].[clases_sima] OFF
INSERT [dbo].[configuracion_app] ([id], [periodo_actual], [contrasena_defecto_usuario], [alertas]) VALUES (1, N'2017-2', N'Cecar123', 1)
SET IDENTITY_INSERT [dbo].[cursos] ON 

INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (61, N'2017-2', N'DISENO Y METODOLOGIA II', 0, CAST(0xA03D0B00 AS Date), N'1066185095', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (62, N'2017-2', N'DISENO Y METODOLOGIA II', 0, CAST(0xA03D0B00 AS Date), N'1102878542', 1)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (63, N'2017-2', N'DISENO Y METODOLOGIA I', 0, CAST(0xA03D0B00 AS Date), N'1102876420', 1)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (64, N'2017-2', N'DISENO Y METODOLOGIA  III', 0, CAST(0xA03D0B00 AS Date), N'1102887140', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (65, N'2017-2', N'EXPRESION III', 0, CAST(0xA03D0B00 AS Date), N'1102880103', 1)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (66, N'2017-2', N'DISENO Y METODOLOGIA IV', 0, CAST(0xA03D0B00 AS Date), N'1102861529', 1)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (67, N'2017-2', N'DERECHO CIVIL PERSONAS', 0, CAST(0xA03D0B00 AS Date), N'1102836723', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (68, N'2017-2', N'DERECHO CIVIL PERSONAS', 0, CAST(0xA03D0B00 AS Date), N'1131110675', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (69, N'2017-2', N'DERECHO CIVIL OBLIGACIONES', 0, CAST(0xA03D0B00 AS Date), N'1102881228', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (70, N'2017-2', N'INTRODUCCION AL DERECHO', 0, CAST(0xA03D0B00 AS Date), N'1103120601', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (71, N'2017-2', N'LOGICA', 1, CAST(0x0D3F0B00 AS Date), N'1067902413', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (72, N'2017-2', N'NEUROPSICOFISIOLOGIA', 0, CAST(0xA03D0B00 AS Date), N'1102581878', 1)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (73, N'2017-2', N'PROCESOS PSICOLOGICOS BASICOS Y LABORATORIO', 0, CAST(0xA03D0B00 AS Date), N'1051829595', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (74, N'2017-2', N'MATEMATICAS APLICADAS', 0, CAST(0xA03D0B00 AS Date), N'1102869404', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (75, N'2017-2', N'MATEMATICA BASICA', 0, CAST(0xA03D0B00 AS Date), N'98103070783', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (76, N'2017-2', N'MICROECONOMIA', 0, CAST(0xA03D0B00 AS Date), N'98103070783', 1)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (77, N'2017-2', N'MORFOLOGIA DEL DEPORTE', 0, CAST(0xA03D0B00 AS Date), N'1100628669', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (78, N'2017-2', N'BIOMECANICA', 0, CAST(0xA03D0B00 AS Date), N'99100611143', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (79, N'2017-2', N'ESTADISTICA INFERENCIAL', 0, CAST(0xA03D0B00 AS Date), N'1102232208', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (80, N'2017-2', N'ESTADISTICA DESCRIPTIVA', 0, CAST(0xA03D0B00 AS Date), N'1104015178', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (81, N'2017-2', N'CALCULO I', 1, CAST(0x0D3F0B00 AS Date), N'1102859256', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (82, N'2017-2', N'CALCULO II', 0, CAST(0xA03D0B00 AS Date), N'1052998935', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (83, N'2017-2', N'ALGEBRA LINEAL', 0, CAST(0xA03D0B00 AS Date), N'1102873967', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (84, N'2017-2', N'MATEMATICA BASICA', 0, CAST(0xA03D0B00 AS Date), N'1096223217', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (85, N'2017-2', N'TERMODINAMICA', 1, CAST(0x0D3F0B00 AS Date), N'1067902413', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (86, N'2017-2', N'CALCULO III', 0, CAST(0xA03D0B00 AS Date), N'1102875307', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (87, N'2017-2', N'MATEMATICA BASICA', 0, CAST(0xA03D0B00 AS Date), N'99112906300', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (88, N'2017-2', N'FUNDAMENTOS DE PROGRAMACION I', 0, CAST(0xA03D0B00 AS Date), N'1102880538', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (89, N'2017-2', N'FUNDAMENTOS DE PROGRAMACION II', 0, CAST(0xA03D0B00 AS Date), N'1103118992', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (90, N'2017-2', N'FISICA I Y LABORATORIO', 0, CAST(0xA03D0B00 AS Date), N'1140845621', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (91, N'2017-2', N'ESTADISTICA DESCRIPTIVA', 0, CAST(0xA03D0B00 AS Date), N'1102884746', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (92, N'2017-2', N'CONTABILIDAD GENERAL', 0, CAST(0xA03D0B00 AS Date), N'98083171146', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (93, N'2017-2', N'ESTADISTICA INFERENCIAL', 0, CAST(0xA03D0B00 AS Date), N'1102883800', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (94, N'2017-2', N'INGLES I', 0, CAST(0xA03D0B00 AS Date), N'98101513629', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (95, N'2017-2', N'TALLER DE LENGUA I', 0, CAST(0xA03D0B00 AS Date), N'1007621090', 1)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (101, N'2017-2', N'MICROECONOMIA I', 0, CAST(0xB53D0B00 AS Date), N'98103070783', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (102, N'2017-2', N'MICROECONOMIA II', 0, CAST(0xB53D0B00 AS Date), N'98103070783', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (103, N'2017-2', N'TOPICOS ESPECIALES DE INGENIERIA DE SISTEMAS I', 0, CAST(0xA03D0B00 AS Date), N'1005575218', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (104, N'2018-1', N'TOPICOS ESPECIALES DE INGENIERIA DE SISTEMAS II', 1, CAST(0x0D3F0B00 AS Date), N'1005575218', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (105, N'2017-2', N'ESTADISTICA INFERENCIAL', 0, CAST(0x963D0B00 AS Date), N'1005575218', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (106, N'2017-2', N'INTRODUCION ALA ECONOMIA', 0, CAST(0xA03D0B00 AS Date), N'98103070783', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (107, N'2018-1', N'CALCULO II', 0, CAST(0xEB3D0B00 AS Date), N'1005575218', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (108, N'2018-1', N'ESCUELA DE CIUDADANIA', 1, CAST(0x6F3E0B00 AS Date), N'1102875394', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (109, N'2018-1', N'ESCUELA DE INGLES', 1, CAST(0x6F3E0B00 AS Date), N'1102878159', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (110, N'2018-1', N'ESCUELA DE LECTOESCRITURA', 1, CAST(0x6F3E0B00 AS Date), N'1005675603', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (111, N'2018-1', N'ESCUELA DE LECTOESCRITURA', 1, CAST(0x6F3E0B00 AS Date), N'1103115711', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (112, N'2017-2', N'DISENO Y METODOLOGIA IV', 1, CAST(0x603E0B00 AS Date), N'1102232026', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (113, N'2017-2', N'LOGICA MATEMATICA', 1, CAST(0x593E0B00 AS Date), N'1067902413', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (114, N'2018-1', N'TALLER DE LENGUA I', 1, CAST(0xA13E0B00 AS Date), N'1005575218', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (115, N'2017-2', N'ACTIVOS FIJOS', 0, CAST(0x0F3E0B00 AS Date), N'1005675603', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (116, N'2018-1', N'CALCULO I', 1, CAST(0x203F0B00 AS Date), N'1005675603', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (117, N'2018-1', N'CALCULO I', 0, CAST(0x2D3E0B00 AS Date), N'1102232026', 1)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (118, N'2018-1', N'CALCULO I', 0, CAST(0x2E3E0B00 AS Date), N'1102232026', 1)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (119, N'2018-1', N'CALCULO I', 0, CAST(0x2E3E0B00 AS Date), N'1102232026', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (120, N'2017-2', N'CALCULO I', 1, CAST(0x893E0B00 AS Date), N'1005575218', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (121, N'2017-2', N'CALCULO II', 1, CAST(0x453E0B00 AS Date), N'1005575218', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (122, N'2017-2', N'ACCIONES CONSTITUCIONALES', 0, CAST(0x373E0B00 AS Date), N'1102836723', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (123, N'2017-2', N'ACTIVIDAD FISICA EN DISCAPACIDAD', 0, CAST(0x3F3E0B00 AS Date), N'1102836723', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (124, N'2017-2', N'ACTIVIDAD FISICA EN DISCAPACIDAD', 0, CAST(0x373E0B00 AS Date), N'1052998935', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (125, N'2017-2', N'ACTIVIDAD FISICA Y REHABILITACION', 0, CAST(0x3C3E0B00 AS Date), N'1102869404', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (126, N'2017-2', N'ACTIVIDAD FISICA Y SALUD', 1, CAST(0x4A3E0B00 AS Date), N'1102859256', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (127, N'2017-2', N'ACTIVIDAD FISICA Y SALUD', 1, CAST(0x443E0B00 AS Date), N'1005675603', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (128, N'2017-2', N'ACTIVIDAD FISICA Y REHABILITACION', 0, CAST(0x373E0B00 AS Date), N'1005675603', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (129, N'2017-2', N'ACTIVOS FIJOS', 1, CAST(0x433E0B00 AS Date), N'1066185095', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (130, N'2017-2', N'ACTIVIDAD FISICA Y REHABILITACION', 1, CAST(0x443E0B00 AS Date), N'1102861529', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (131, N'2017-2', N'ACTIVIDAD FISICA Y REHABILITACION', 1, CAST(0x443E0B00 AS Date), N'1102878159', 0)
INSERT [dbo].[cursos] ([id], [periodo], [nombre_materia], [estado], [fecha_finalizacion], [idUsuario], [eliminado]) VALUES (132, N'2017-2', N'DISENO Y METODOLOGIA V', 0, CAST(0x373E0B00 AS Date), N'1005675603', 0)
SET IDENTITY_INSERT [dbo].[cursos] OFF
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'00011203884', 141)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'00011203884', 194)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'00011405479', 109)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'00011502130', 52)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'00011502130', 113)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'00011803687', 136)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'00011803687', 216)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'00011803687', 278)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'00011803687', 279)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'00011803687', 306)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1000248961', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1000248961', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1000248961', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1000248961', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1000248961', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1000248961', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1000248961', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'10003196955', 52)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'10003196955', 113)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'10003196955', 207)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'10003196955', 249)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1001866278', 153)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1001866278', 216)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1001866278', 218)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1001866278', 278)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1001866278', 279)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1001866278', 281)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1001866278', 306)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1001940038', 63)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1001971567', 364)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1001971567', 365)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1001971567', 366)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1001971567', 367)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1001971567', 368)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1001971567', 369)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1001999582', 92)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002029378', 235)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002200958', 11)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002200958', 30)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002200958', 50)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002200958', 64)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002200958', 236)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002200958', 272)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002200958', 283)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002302718', 13)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002362871', 318)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002487123', 100)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002487123', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002487123', 109)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002487437', 42)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002487437', 51)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002487437', 76)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002487437', 101)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002487437', 308)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002487745', 50)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002487745', 64)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002488158', 33)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002488158', 124)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002488158', 127)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002488158', 136)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002488158', 153)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002488158', 278)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002488158', 279)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002488158', 281)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002488158', 306)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002488158', 307)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002490697', 216)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002492886', 50)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002492886', 64)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002495425', 364)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002495425', 365)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002495425', 367)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002497147', 37)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002497147', 59)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002497147', 62)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002497147', 63)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002497147', 65)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002497147', 91)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002497147', 111)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002497147', 194)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002497147', 204)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002497147', 251)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002497147', 282)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002498117', 61)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002498736', 109)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1002498736', 222)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003061542', 100)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003061542', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003061542', 109)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003206448', 153)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003262969', 56)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003262969', 71)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003262969', 97)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003262969', 102)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003262969', 154)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003262969', 248)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003262976', 28)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003262976', 77)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003262976', 116)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003262976', 119)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003262976', 125)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003262976', 137)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003262976', 220)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003262976', 221)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003262976', 268)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003310251', 355)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003405774', 52)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003405774', 113)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003405774', 207)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003405774', 249)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003504404', 32)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003504814', 233)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003504814', 235)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003504814', 354)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003643844', 364)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003645531', 33)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003645531', 136)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003645531', 151)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003645531', 153)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003645531', 216)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003645531', 218)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003645531', 278)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003645531', 279)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1003645531', 306)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1004094612', 364)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1004094612', 365)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1004094612', 366)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1004094612', 367)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1004094612', 368)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1004094612', 369)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1004283188', 56)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1004283188', 67)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1004283188', 97)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1004283188', 102)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005387944', 56)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005387944', 67)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005387944', 71)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005387944', 97)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005387944', 102)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005387944', 199)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005389750', 11)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005389750', 50)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005414815', 92)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005418012', 82)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005418040', 82)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005418730', 92)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005435050', 65)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005435050', 107)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005435050', 111)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005435050', 122)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005435050', 174)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005440473', 36)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005440473', 82)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005440473', 158)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005440678', 17)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005440678', 29)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005440678', 54)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005440678', 58)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005440905', 235)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005457096', 33)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005457096', 136)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005457096', 151)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005457096', 153)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005457096', 216)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005457096', 218)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005457096', 278)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005457096', 279)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005457096', 281)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005457096', 306)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005457115', 59)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005457115', 111)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005457115', 251)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005457115', 282)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005457460', 251)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005469817', 37)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005469817', 62)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005469817', 63)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005469817', 65)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005469817', 129)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005469817', 140)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005469817', 251)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005486161', 271)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005486161', 316)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005486439', 271)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005486439', 316)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005486440', 167)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005486440', 168)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005486440', 170)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005486440', 172)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005486440', 303)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005486440', 312)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005486514', 271)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005486514', 316)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005488160', 364)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005488544', 62)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005524166', 32)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005524166', 135)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005524390', 62)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005524390', 63)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525376', 13)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525376', 35)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525376', 60)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525376', 132)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525376', 217)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525376', 280)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525376', 281)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525376', 307)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525376', 373)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525385', 45)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525385', 89)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525385', 90)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525385', 355)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525385', 356)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525385', 357)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525385', 359)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525385', 360)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525564', 52)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525564', 113)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525564', 207)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525564', 285)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525620', 61)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525620', 233)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525620', 354)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525624', 13)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525624', 216)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525624', 372)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525624', 373)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525750', 10)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525750', 19)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525750', 47)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525750', 66)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525750', 94)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525750', 110)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525750', 117)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525750', 130)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525750', 139)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525750', 142)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525750', 195)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525750', 196)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525750', 209)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525750', 252)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525750', 253)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525750', 290)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525750', 291)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525750', 292)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005525750', 293)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005550603', 183)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005550603', 184)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005550603', 185)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005550603', 186)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005550603', 188)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005550603', 189)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005550603', 190)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005550603', 259)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005552547', 9)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005552547', 22)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005552547', 34)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005552547', 43)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005552547', 72)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005552547', 87)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005552547', 103)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005552547', 120)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005552547', 133)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005552547', 146)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005552547', 212)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005552547', 219)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005552547', 263)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005552547', 276)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005552547', 286)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005566461', 141)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005566461', 194)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005566539', 42)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005566539', 51)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005566539', 76)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005566539', 101)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005566539', 308)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005566630', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005566630', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005566630', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005566630', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005566630', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005566630', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005566630', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005567096', 67)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005567096', 81)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005567096', 90)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005567096', 356)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005567096', 358)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005567101', 355)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005567146', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005567146', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005567146', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005567146', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005567146', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005567146', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005567146', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005567972', 34)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005567972', 43)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005567972', 80)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005567972', 87)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005568129', 42)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005568129', 51)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005568129', 76)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005568129', 101)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005568129', 308)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005568129', 310)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005568129', 311)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005568129', 313)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005568593', 42)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005568593', 51)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005568593', 76)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005568593', 101)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005568593', 308)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005568593', 309)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005568593', 310)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005568593', 311)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005575590', 111)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005575590', 129)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005575590', 141)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005575590', 194)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005575590', 251)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005575590', 282)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005575608', 35)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005575626', 279)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005575672', 89)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005575672', 356)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005575672', 357)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005575672', 359)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005575802', 35)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005575802', 60)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005575802', 132)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005575802', 217)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005575900', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005575900', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005575900', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005575900', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005575900', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005575900', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005575900', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005576060', 109)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005576060', 222)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005576060', 225)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005576060', 370)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005576088', 136)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005576088', 151)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005576088', 153)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005576088', 216)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005576088', 218)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005576088', 278)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005576088', 306)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005576116', 364)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005576116', 365)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005576116', 366)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005576116', 367)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005576116', 368)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005576232', 82)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005576239', 22)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005576239', 72)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005576239', 133)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005576239', 146)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005576239', 219)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005576239', 263)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005576239', 286)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005576322', 92)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005576523', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005581064', 32)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005581196', 42)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005581196', 51)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005581196', 76)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005581196', 101)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005581196', 308)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005581329', 11)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005581329', 30)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005581329', 50)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005581329', 236)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005581329', 272)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005581329', 283)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005581528', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005581528', 226)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005581899', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005581899', 222)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005581983', 100)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005581984', 50)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005582682', 100)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005584119', 92)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005584905', 92)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005584987', 213)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005603592', 364)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005603592', 365)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005603592', 366)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005603592', 367)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005603592', 368)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005603721', 364)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005603721', 365)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005603721', 366)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005603721', 367)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005603738', 90)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005603738', 356)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604056', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604056', 145)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604056', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604056', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604056', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604056', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604056', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604120', 67)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604120', 356)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604120', 358)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604120', 360)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604170', 13)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604170', 267)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604170', 307)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604170', 371)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604170', 372)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604170', 373)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604399', 100)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604399', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604399', 109)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604972', 37)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604972', 59)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604972', 62)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604972', 63)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604972', 65)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604972', 91)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604972', 107)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604972', 111)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604972', 140)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604972', 194)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604972', 204)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604972', 251)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005604972', 282)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005605157', 193)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005605157', 202)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005605175', 97)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005605175', 102)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005605175', 248)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005605175', 348)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005605175', 362)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005624888', 56)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005624888', 81)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005624888', 97)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005624888', 102)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005624888', 243)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005625104', 52)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005625162', 232)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005625162', 233)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005625675', 82)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005625675', 158)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005625888', 183)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005625888', 184)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005625888', 185)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005625888', 186)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005625888', 187)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005625888', 188)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005625888', 189)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005625888', 190)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005625888', 258)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005625888', 259)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005625909', 42)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005625909', 51)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005625909', 76)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005625909', 101)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005625909', 308)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005626596', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005626596', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005626596', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005626596', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005626596', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005626596', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005626596', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005639808', 32)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005639808', 54)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005639808', 58)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005639808', 93)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005639808', 135)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005639808', 182)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005639808', 239)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005639808', 261)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005639808', 327)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005639808', 330)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005639808', 334)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005639808', 335)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005639808', 336)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005639808', 337)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005639808', 338)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005639808', 340)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005639808', 342)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005639808', 343)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005639808', 344)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005639883', 365)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005639883', 366)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005639883', 367)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005647037', 92)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005650318', 56)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005659579', 364)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005659579', 365)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005659579', 367)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005659664', 63)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005659785', 166)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005659785', 167)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005659785', 168)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005659785', 169)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005659785', 170)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005659785', 171)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005659785', 302)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005659785', 303)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005659785', 304)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005659785', 312)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005659979', 92)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005660170', 366)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005660170', 367)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005660170', 368)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005660170', 369)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005660366', 32)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005660366', 54)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005660366', 58)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005660366', 93)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005660366', 99)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005660366', 128)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005660366', 131)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005660366', 135)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005660366', 181)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005660366', 182)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005660366', 214)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005660366', 239)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005660366', 261)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005660366', 264)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005660366', 324)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005660366', 327)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005660366', 330)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005660366', 332)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005660366', 334)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005660366', 335)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005660366', 338)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005664339', 364)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005664339', 365)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005664339', 366)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005664339', 367)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005664339', 368)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005664339', 369)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005677445', 95)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005677445', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005677445', 225)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005677445', 370)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005708328', 63)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005709956', 45)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005709956', 67)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005709956', 89)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005710250', 35)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005710250', 60)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005710250', 124)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005710250', 132)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005710250', 217)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005710250', 279)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005710250', 280)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005710250', 281)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005710250', 307)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1005991345', 50)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1006888276', 56)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1006888276', 71)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1006888276', 81)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1006888276', 97)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1006888276', 102)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1006888276', 154)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1006888276', 199)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1006888276', 248)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1006888276', 348)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1006888276', 362)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183321', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183321', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183321', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183321', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183321', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183321', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183321', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183571', 50)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183571', 64)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183623', 364)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183623', 365)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183623', 367)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183769', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183769', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183769', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183769', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183769', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183769', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183782', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183878', 364)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183878', 365)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183878', 366)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183878', 367)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183878', 368)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183892', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183892', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183892', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183892', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183892', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183892', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183892', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183900', 92)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183902', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183902', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183902', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183902', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183902', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183902', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183902', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183925', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007183925', 226)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007256602', 61)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007256602', 127)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007256602', 134)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007357116', 100)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007357116', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007357116', 109)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007370399', 18)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007370399', 45)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007370399', 56)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007370399', 67)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007370399', 71)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007370399', 81)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007370399', 90)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007370399', 102)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007370399', 199)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007370399', 243)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007370399', 287)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007370399', 288)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007370399', 346)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007370399', 348)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007370399', 362)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007506188', 13)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007506188', 35)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007506188', 267)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007506188', 280)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007506188', 281)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007506188', 371)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007506188', 372)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007506188', 373)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007553535', 250)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007553535', 284)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007553535', 317)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007611887', 89)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007611887', 359)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007611887', 360)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007611961', 191)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007612257', 56)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007612257', 71)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007612257', 97)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007612257', 154)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007612257', 243)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007612257', 348)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007612257', 362)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007649619', 35)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007649757', 33)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007649757', 136)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007649757', 151)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007649757', 153)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007649757', 216)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007649757', 278)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007649757', 279)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007649757', 281)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007649757', 306)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007660273', 167)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007660273', 168)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007660273', 169)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007660273', 171)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007660273', 302)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007660273', 304)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007661845', 63)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007669575', 35)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007669575', 60)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007669575', 124)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007669575', 132)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007669575', 134)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007669575', 153)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007669575', 216)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007669575', 218)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007669575', 267)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007669575', 371)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007706133', 364)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007706133', 366)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007706133', 368)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007706133', 369)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007765671', 366)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007765671', 367)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007765671', 368)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007765671', 369)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007767433', 92)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007792486', 183)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007792486', 184)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007792486', 186)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007792486', 188)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007792486', 189)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007801566', 71)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007801566', 81)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007801566', 97)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007801566', 102)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007801566', 199)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007801566', 248)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007801566', 348)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007801566', 362)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007838296', 56)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007838296', 71)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007838296', 97)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007838296', 154)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007838296', 199)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007838296', 243)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007838296', 248)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007838296', 348)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007838296', 362)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007963266', 28)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007963266', 77)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007963266', 116)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007963266', 119)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007963266', 125)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007963266', 167)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007963266', 171)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007963266', 220)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007963266', 221)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007963266', 268)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007963266', 302)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007963266', 303)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1007963266', 304)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010002345', 42)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010002345', 51)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010002345', 76)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010002345', 101)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010002345', 308)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010065033', 92)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010068483', 33)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010068483', 134)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010068483', 136)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010068483', 153)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010068483', 216)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010068483', 218)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010068483', 278)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010068483', 279)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010068483', 281)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010068483', 306)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010085241', 62)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010085241', 63)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010096016', 100)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010102304', 278)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010102304', 279)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010102304', 281)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010102304', 306)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010102304', 307)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010103656', 61)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010103656', 68)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010103656', 230)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010103656', 234)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010104075', 95)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010104075', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010104075', 109)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010104075', 222)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010104075', 225)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010104075', 226)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010104075', 370)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010111396', 63)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010111396', 65)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010111396', 194)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010111396', 204)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010130375', 153)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010130375', 218)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010130375', 278)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010130375', 279)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010130375', 281)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010130375', 306)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1010130375', 307)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1018504400', 42)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1018504400', 51)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1018504400', 76)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1018504400', 101)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1018504400', 308)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1018504400', 310)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1019079503', 10)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1019079503', 19)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1019079503', 31)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1019079503', 39)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1019079503', 57)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1019079503', 94)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1019079503', 110)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1019079503', 117)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1019079503', 130)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1019079503', 139)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1019079503', 142)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1019079503', 195)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1019079503', 196)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1019079503', 209)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1019079503', 252)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1019079503', 253)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1019079503', 290)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1019079503', 291)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1019079503', 292)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1019079503', 293)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1023943851', 113)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1023943851', 315)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1026590790', 100)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1040365451', 10)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1040365451', 19)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1040365451', 31)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1040365451', 39)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1040365451', 47)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1040365451', 66)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1040365451', 86)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1040365451', 94)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1040365451', 110)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1040365451', 117)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1040365451', 130)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1040365451', 142)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1040365451', 195)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1040365451', 196)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1040365451', 253)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1040365451', 290)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1040365451', 291)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1040365451', 292)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1040365451', 293)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1046405358', 63)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1047506366', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1047506366', 226)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1049454962', 83)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1049454962', 152)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1049454962', 163)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1049454962', 274)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1049454962', 275)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1051821966', 95)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1051821966', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1051821966', 109)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1051821966', 223)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1051821966', 226)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1052095051', 364)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1052095051', 365)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1052095051', 367)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1052989644', 207)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1052989644', 249)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1052991194', 63)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1053001059', 102)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1053001059', 199)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1053001059', 243)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1053001059', 348)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1053001059', 355)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1053001059', 356)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1053001059', 357)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1053001059', 359)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1053001059', 360)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1053001059', 362)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1053003105', 365)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1053003105', 366)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1053003105', 369)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1053006077', 243)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1053006077', 348)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1053006077', 362)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1055274394', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1055274394', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1055274394', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1055274394', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1055274394', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1055274394', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1055274394', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1063305333', 71)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1063305333', 360)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1065378575', 37)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1065378575', 62)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1065378575', 65)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066177943', 153)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066177943', 279)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066177943', 306)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066184130', 79)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066184130', 112)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066184130', 250)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066184130', 284)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066184130', 317)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066187653', 197)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066187653', 371)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066187653', 372)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188098', 270)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188216', 42)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188216', 51)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188216', 76)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188216', 101)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188216', 308)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188216', 313)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188234', 257)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188239', 61)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188416', 364)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188416', 365)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188416', 367)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188661', 9)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188661', 22)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188661', 34)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188661', 43)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188661', 72)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188661', 80)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188661', 87)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188661', 103)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188661', 120)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188661', 133)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188661', 146)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188661', 164)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188661', 165)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188661', 212)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188661', 263)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188661', 276)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188661', 286)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188970', 17)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188970', 21)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188970', 29)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188970', 54)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188970', 58)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188970', 69)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188988', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188988', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188988', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188988', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188988', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188988', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066188988', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066747583', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066747583', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066747583', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066747583', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066747583', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066747583', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1066747583', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1067891111', 230)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1067891111', 234)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1067961459', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1069491357', 112)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1069491357', 250)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1069491357', 284)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1069491357', 317)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1069494265', 230)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1069494265', 234)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1069494265', 351)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1069495121', 271)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1069495121', 316)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1069502035', 270)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1069502550', 74)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1069502550', 106)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1069502550', 257)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1069502550', 269)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1069502550', 314)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1069502550', 320)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1069503688', 52)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1069504225', 82)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1069504383', 12)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1069504383', 38)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1069504383', 49)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1069504383', 68)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1071428754', 36)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1071428754', 104)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1072252510', 104)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1072262344', 30)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1072262344', 50)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1072262344', 64)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1072262344', 98)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1072262344', 236)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1072262344', 272)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1072262344', 283)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1072263532', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1072263532', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1072263532', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1072263532', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1072263532', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1072263532', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1072263532', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1072263847', 166)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1072263847', 167)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1072263847', 168)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1072263847', 169)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1072263847', 170)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1072263847', 171)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1072263847', 172)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1072263847', 302)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1072263847', 304)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1072263847', 312)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1072527893', 62)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1072527893', 63)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1083038937', 365)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1085229278', 109)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'10967607', 207)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'10967607', 249)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'10967607', 285)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1099993396', 183)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1099993396', 184)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1099993396', 185)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1099993396', 186)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1099993396', 187)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1099993396', 188)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1099993396', 189)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1099993396', 190)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1099993396', 258)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1099993396', 259)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1099993396', 319)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100014225', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100014225', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100014225', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100014225', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100014225', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100014225', 277)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100014225', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100250997', 36)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100335611', 183)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100335611', 184)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100335611', 185)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100335611', 186)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100335611', 188)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100335611', 189)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100335611', 258)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100399847', 271)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100399847', 316)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100402434', 12)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100402434', 38)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100402434', 44)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100402434', 49)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100402574', 106)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100402574', 257)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100402574', 269)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100402574', 314)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100402574', 320)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100403444', 56)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100403444', 71)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100403444', 81)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100403444', 102)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100403444', 154)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100403444', 199)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100403444', 243)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100403444', 348)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100403444', 362)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100549570', 9)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100549570', 34)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100549570', 43)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100549570', 80)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100549570', 87)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100549570', 103)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100549570', 120)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100549570', 165)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100549570', 212)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100549570', 276)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100551222', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629298', 65)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629298', 91)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629298', 111)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629298', 129)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629298', 141)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629298', 194)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629298', 251)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629661', 83)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629661', 163)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629661', 213)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629661', 240)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629661', 265)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629661', 274)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629661', 275)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629742', 17)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629742', 21)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629742', 29)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629742', 32)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629742', 54)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629742', 58)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629742', 78)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629742', 93)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629742', 99)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629742', 135)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629742', 182)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629742', 214)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629742', 239)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629742', 327)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629742', 332)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629742', 334)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629742', 335)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629858', 22)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629858', 72)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629858', 133)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629858', 146)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629858', 219)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629858', 263)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100629858', 286)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100630140', 22)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100630140', 72)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100630140', 133)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100630140', 146)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100630140', 219)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100630140', 263)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100630140', 286)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100691716', 48)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100695314', 74)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100695314', 106)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100695314', 269)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100695902', 106)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100695902', 229)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100695902', 231)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100695902', 257)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100696041', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100696041', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100696041', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100696041', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100696041', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100696041', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100696041', 345)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100696293', 17)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100696293', 29)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100696293', 32)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100696293', 54)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100696293', 78)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100696293', 93)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100696293', 131)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1100696293', 135)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101380528', 95)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101380528', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101380528', 222)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101380528', 224)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101380528', 225)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101380528', 226)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101380528', 370)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101380622', 136)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101380622', 279)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101381466', 92)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101390250', 22)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101390250', 34)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101390250', 43)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101390250', 72)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101390250', 80)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101390250', 87)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101390250', 103)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101390250', 120)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101390250', 133)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101390250', 164)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101390250', 165)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101390250', 219)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101390250', 286)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101454745', 22)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101454745', 72)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101454745', 133)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101458743', 10)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101458743', 19)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101458743', 28)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101458743', 31)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101458743', 39)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101458743', 47)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101458743', 66)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101458743', 86)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101458743', 94)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101458743', 110)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101462601', 243)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101462601', 248)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101462601', 287)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101462601', 288)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101462601', 346)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101462601', 348)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101462601', 356)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101462601', 357)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101462601', 359)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101462601', 360)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101462601', 362)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101785028', 271)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101785028', 316)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101785201', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101785201', 109)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101785201', 223)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101785201', 225)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101785201', 370)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101785464', 271)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101785464', 316)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101819914', 42)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101819914', 51)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101819914', 76)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101819914', 101)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101819914', 308)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101819914', 311)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101820452', 71)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101820452', 154)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101820506', 271)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101820506', 316)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101820628', 28)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101820628', 116)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101820628', 125)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101820628', 126)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101820628', 137)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101820628', 221)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101820628', 268)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101820781', 213)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101877852', 284)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1101877852', 317)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102123392', 11)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102123392', 50)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102123392', 283)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102149142', 9)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102149142', 34)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102149142', 43)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102149142', 80)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102149142', 87)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102149142', 103)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102149142', 120)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102149142', 212)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102149142', 276)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102233339', 235)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102233680', 75)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102233680', 162)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102234165', 144)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102574339', 271)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102574339', 316)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102582821', 46)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102582821', 156)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102582821', 215)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102584172', 12)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102584172', 38)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102584172', 44)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102584172', 49)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102584172', 68)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102584172', 144)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102584172', 349)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796014', 82)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 10)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 19)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 28)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 31)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 39)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 47)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 57)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 66)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 86)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 94)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 110)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 116)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 117)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 119)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 125)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 126)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 130)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 137)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 139)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 142)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 195)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 196)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 221)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 252)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 253)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 268)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 290)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 291)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 292)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102796224', 293)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102812822', 27)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102812822', 84)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 10)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 19)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 28)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 31)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 39)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 47)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 57)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 66)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 86)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 94)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 110)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 116)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 117)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 119)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 125)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 126)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 130)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 137)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 139)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 142)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 220)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 221)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 252)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 253)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 268)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 290)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 291)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 292)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102824269', 293)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 10)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 19)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 28)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 31)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 47)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 57)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 66)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 77)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 86)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 94)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 110)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 116)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 117)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 119)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 125)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 126)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 130)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 139)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 142)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 195)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 196)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 221)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 252)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 253)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 268)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 290)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 291)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 292)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102828816', 293)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102833310', 44)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102833310', 49)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102833310', 68)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102833310', 144)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102833310', 235)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102835889', 374)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102843379', 215)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102843379', 273)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102843866', 75)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102843866', 289)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102847943', 79)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102847943', 112)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102847943', 250)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102847943', 284)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102847943', 317)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102848255', 22)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102848255', 72)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102848255', 133)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102848255', 146)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102848255', 263)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102850660', 88)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102850660', 147)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102850660', 156)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102850660', 210)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102850660', 215)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102850660', 260)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102850660', 273)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102850971', 215)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102851499', 10)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102851499', 19)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102851499', 47)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102851499', 57)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102851499', 66)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102851499', 94)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102851499', 117)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102851499', 139)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102851499', 142)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102851499', 195)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102851499', 196)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102851499', 253)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102851499', 290)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102851499', 291)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102851499', 292)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102851499', 293)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102854521', 9)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102854521', 34)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102854521', 43)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102854521', 80)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102854521', 87)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102854521', 103)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102854521', 120)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102854521', 164)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102854521', 165)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102854521', 212)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102854521', 276)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102856436', 250)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102857451', 22)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102858000', 115)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102858000', 127)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102858000', 134)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102858000', 216)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102858879', 28)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102858879', 116)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102858879', 125)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102858879', 126)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102858879', 221)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102858879', 268)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102859364', 166)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102859364', 167)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102859364', 168)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102859364', 169)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102859364', 170)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102859364', 171)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102859364', 172)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102859364', 302)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102859364', 303)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102859364', 304)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102859364', 312)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102861160', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102861160', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102861160', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102861160', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102861160', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102861160', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102861160', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102862290', 366)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102862290', 368)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102862290', 369)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102863003', 350)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102863095', 9)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102863095', 22)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102863095', 43)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102863095', 72)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102863095', 103)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102863095', 120)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102863095', 133)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102863095', 146)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102863095', 219)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102863095', 263)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102863095', 286)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102863099', 28)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102863099', 116)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102863099', 119)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102863099', 125)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102863099', 126)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102863099', 137)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102863099', 220)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102863099', 221)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102863099', 268)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102864406', 215)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102864452', 68)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102866277', 370)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102867292', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102867292', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102867292', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102867292', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102867292', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102867292', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102867292', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868352', 56)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868352', 67)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868352', 71)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868352', 97)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868352', 102)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868352', 154)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868352', 243)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868473', 9)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868473', 22)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868473', 34)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868473', 43)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868473', 72)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868473', 80)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868473', 87)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868473', 103)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868473', 120)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868473', 133)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868473', 146)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868473', 164)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868473', 165)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868804', 166)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868804', 167)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868804', 168)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868804', 169)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868804', 170)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868804', 171)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868804', 172)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868804', 302)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868804', 304)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868804', 312)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868904', 27)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868904', 84)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868948', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868948', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868948', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868948', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868948', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868948', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102868948', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102869189', 90)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102869189', 355)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102869696', 42)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102869696', 51)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102869696', 76)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102869696', 101)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102869696', 308)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102870530', 9)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102870530', 22)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102870530', 34)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102870530', 43)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102870530', 72)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102870530', 103)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102870530', 120)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102870530', 133)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102870530', 146)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102870530', 263)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102870530', 276)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102870530', 286)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102870555', 92)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102870837', 33)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102870837', 60)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102870837', 136)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102870837', 151)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102870837', 153)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102870837', 216)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102870837', 218)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102870837', 278)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102870837', 279)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102870837', 306)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102871651', 13)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102871742', 355)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102872169', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102872169', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102872169', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102872169', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102872169', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102872169', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102873394', 249)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102873394', 315)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102873835', 28)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102873835', 77)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102873835', 116)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102873835', 119)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102873835', 125)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102873835', 126)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102873835', 137)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102873835', 220)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102873835', 221)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102873835', 268)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874690', 28)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874690', 77)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874690', 116)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874690', 119)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874690', 125)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874690', 126)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874690', 220)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874690', 221)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874690', 268)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874849', 191)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874849', 192)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874849', 193)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874849', 202)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874852', 183)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874852', 184)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874852', 185)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874852', 186)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874852', 187)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874852', 188)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874852', 189)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874852', 190)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874852', 258)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874852', 259)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874852', 319)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874863', 27)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874863', 84)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874863', 215)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874863', 262)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102874863', 273)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875126', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875126', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875126', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875126', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875126', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875126', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875126', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875226', 183)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875226', 184)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875226', 185)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875226', 186)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875226', 187)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875226', 188)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875226', 189)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875226', 190)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875226', 258)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875226', 259)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875226', 319)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875693', 207)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875693', 249)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875744', 9)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875744', 34)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875744', 43)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875744', 80)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875744', 87)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875744', 103)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875744', 120)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875744', 212)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875744', 276)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875823', 21)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875823', 32)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875823', 54)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875823', 58)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875823', 69)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875823', 78)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875823', 99)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875823', 128)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875823', 135)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875823', 214)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875823', 239)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875823', 332)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875823', 335)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875870', 353)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875890', 17)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875890', 21)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875890', 29)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875890', 32)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875890', 54)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875890', 69)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102875890', 181)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876314', 132)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876394', 10)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876394', 19)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876394', 31)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876394', 39)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876394', 47)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876394', 57)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876394', 66)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876394', 94)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876394', 117)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876394', 130)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876394', 139)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876394', 142)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876394', 195)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876394', 196)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876394', 252)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876394', 253)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876394', 290)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876394', 291)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876394', 292)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876394', 293)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876473', 88)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876473', 147)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876473', 156)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876473', 206)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876473', 210)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876473', 215)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876473', 260)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876473', 262)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876473', 273)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102876883', 240)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877075', 109)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877408', 22)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877408', 72)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877408', 133)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877408', 146)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877408', 219)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877408', 263)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877408', 286)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877511', 9)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877517', 183)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877517', 184)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877517', 185)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877517', 186)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877517', 187)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877517', 188)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877517', 189)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877517', 190)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877517', 258)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877517', 259)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877517', 318)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877517', 319)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877529', 33)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877529', 60)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877529', 124)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877529', 132)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877529', 134)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877529', 136)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877529', 151)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877529', 153)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877529', 216)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877529', 218)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877529', 278)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877529', 279)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877529', 281)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102877529', 306)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102878133', 35)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102878133', 197)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102878133', 267)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102878133', 371)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102878133', 372)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102878133', 373)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102878246', 353)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102878446', 9)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102878446', 34)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102878446', 43)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102878446', 103)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102878446', 120)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102878446', 164)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102878446', 165)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102878446', 212)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102878640', 191)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102878640', 193)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102878640', 318)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102878670', 33)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102878782', 235)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879191', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879191', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879191', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879191', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879191', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879191', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879191', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879284', 67)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879491', 68)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879491', 144)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879491', 232)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879491', 233)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879491', 349)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879559', 9)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879559', 22)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879559', 34)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879559', 43)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879559', 72)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879559', 80)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879559', 87)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879559', 120)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879559', 133)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879559', 146)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879559', 219)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879559', 263)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879559', 286)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879612', 10)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879612', 19)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879612', 47)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879612', 57)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879612', 66)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879612', 94)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879612', 117)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879612', 139)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879612', 142)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879612', 195)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879612', 196)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879612', 209)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879612', 252)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879612', 253)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879612', 290)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879612', 291)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879612', 292)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879612', 293)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879927', 213)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879927', 265)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102879927', 270)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880030', 9)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880030', 22)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880030', 34)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880030', 43)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880030', 72)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880030', 87)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880030', 103)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880030', 120)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880030', 133)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880030', 146)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880030', 219)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880030', 263)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880030', 286)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880107', 88)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880107', 147)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880107', 156)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880107', 206)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880107', 210)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880107', 215)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880107', 260)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880139', 216)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880139', 217)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880139', 278)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880139', 279)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880139', 280)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880139', 281)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880139', 306)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880139', 307)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880260', 13)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880264', 92)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880358', 232)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880525', 271)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880525', 316)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880709', 42)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880709', 51)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880709', 76)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880709', 101)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880709', 308)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880709', 309)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880709', 313)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880759', 9)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880759', 22)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880759', 72)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880759', 80)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880759', 120)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880759', 133)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880759', 146)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880759', 219)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880759', 263)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880759', 286)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880812', 56)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880812', 97)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880812', 199)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102880812', 361)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102881167', 22)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102881167', 72)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102881167', 133)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102881167', 146)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102881167', 219)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102881167', 263)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102881167', 286)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102881540', 353)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102881884', 215)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102881913', 63)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102881913', 65)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102881913', 194)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102881913', 204)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102881987', 75)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102881987', 228)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102881987', 237)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102881987', 289)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102881987', 294)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102881987', 295)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102881987', 297)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882105', 95)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882105', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882105', 109)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882105', 225)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882105', 226)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882105', 363)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882115', 289)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882202', 22)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882202', 34)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882202', 43)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882202', 72)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882202', 80)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882202', 87)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882202', 103)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882202', 120)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882202', 133)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882202', 146)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882202', 219)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882202', 286)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882311', 9)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882311', 22)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882311', 34)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882311', 43)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882311', 72)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882311', 80)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882311', 87)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882311', 103)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882311', 120)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882311', 133)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882311', 146)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882311', 164)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882311', 165)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882311', 212)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882311', 219)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882311', 263)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882311', 276)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882311', 286)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882373', 183)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882373', 184)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882373', 185)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882373', 186)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882373', 187)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882373', 188)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882373', 189)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882373', 190)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882373', 258)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882373', 259)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882373', 319)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882394', 106)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882460', 136)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882460', 153)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882460', 216)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882460', 278)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882460', 279)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882460', 281)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882460', 306)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882603', 28)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882603', 77)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882603', 125)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882603', 126)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882603', 137)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882603', 220)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882603', 221)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102882603', 268)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883009', 320)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883023', 13)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883023', 216)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883023', 217)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883023', 267)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883023', 278)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883023', 279)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883023', 306)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883023', 307)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883023', 373)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883432', 10)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883432', 19)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883432', 31)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883432', 39)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883432', 47)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883432', 57)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883432', 66)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883432', 94)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883432', 110)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883432', 117)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883432', 130)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883432', 139)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883432', 142)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883432', 195)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883432', 196)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883432', 209)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883432', 252)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883432', 253)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883432', 290)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883432', 291)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883432', 292)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883432', 293)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883458', 270)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883705', 28)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883705', 77)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883705', 116)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883705', 119)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883705', 125)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883705', 126)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883705', 137)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883705', 220)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883705', 221)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102883705', 268)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884253', 136)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884253', 216)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884253', 278)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884253', 279)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884253', 306)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884360', 90)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884539', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884539', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884539', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884539', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884539', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884539', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884539', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884541', 33)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884632', 109)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884643', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884643', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884643', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884643', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884643', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884643', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884643', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884668', 365)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884668', 367)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884668', 369)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884722', 365)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884722', 366)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884722', 369)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884780', 281)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884789', 42)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884789', 51)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884789', 76)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884789', 101)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884789', 308)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884820', 74)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884820', 257)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884820', 269)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884836', 265)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102884836', 270)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102885712', 274)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102886093', 32)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102886184', 12)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102886184', 38)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102886184', 68)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102886233', 287)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102886233', 288)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102886233', 346)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102886358', 100)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102886487', 364)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102886487', 366)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102886487', 367)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102886487', 368)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102886871', 92)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102886975', 166)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102886975', 167)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102886975', 168)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102886975', 169)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102886975', 170)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887037', 364)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887037', 365)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887037', 367)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887037', 369)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887171', 364)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887171', 365)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887171', 366)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887171', 367)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887257', 92)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887303', 64)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887426', 44)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887426', 68)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887506', 95)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887506', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887506', 109)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887506', 225)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887506', 226)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887610', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887610', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887610', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887610', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887610', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887610', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887788', 42)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887788', 51)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887788', 76)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887788', 101)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887815', 95)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887815', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887815', 109)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887815', 222)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887815', 225)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887815', 226)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887871', 51)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887871', 76)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887871', 101)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887871', 308)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887871', 309)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887873', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887873', 109)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887873', 222)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887873', 224)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887873', 225)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887873', 226)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102887873', 363)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102888265', 32)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102888265', 54)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102888265', 58)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102888265', 69)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102888265', 93)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102888265', 135)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102888265', 264)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102888797', 308)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102888797', 309)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102888797', 310)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102888797', 311)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1102888797', 313)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103110051', 92)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103111220', 136)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103111220', 151)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103111220', 153)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103111220', 216)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103111220', 218)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103111220', 278)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103111220', 279)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103111220', 306)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103115466', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103115466', 109)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103115488', 27)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103115488', 84)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103115488', 215)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103115488', 262)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103118449', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103118449', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103118449', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103118449', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103118449', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103118449', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103118449', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103119725', 68)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103120174', 49)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103120567', 75)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103120567', 162)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103120567', 237)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103120892', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103120892', 225)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103120892', 226)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103120986', 166)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103120986', 167)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103120986', 172)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103120986', 312)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121256', 166)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121256', 167)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121256', 168)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121256', 169)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121256', 170)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121256', 171)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121256', 302)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121256', 303)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121256', 304)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121314', 12)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121314', 38)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121314', 44)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121314', 49)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121314', 68)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121314', 144)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121439', 229)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121439', 231)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121439', 351)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121921', 32)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121921', 54)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121921', 58)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121921', 93)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121921', 135)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121921', 182)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121921', 214)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121921', 239)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121921', 327)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121921', 332)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121921', 334)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121921', 335)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103121922', 250)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122176', 364)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122176', 365)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122176', 366)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122176', 367)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122228', 13)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122228', 60)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122228', 216)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122228', 307)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122228', 371)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122228', 372)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122228', 373)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122500', 56)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122500', 71)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122500', 81)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122500', 97)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122500', 102)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122500', 154)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122500', 199)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122500', 248)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122632', 371)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122732', 68)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122732', 232)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122732', 235)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122732', 349)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122732', 352)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 58)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 93)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 99)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 128)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 131)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 181)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 214)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 261)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 264)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 321)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 322)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 324)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 325)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 328)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 329)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 330)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 331)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 332)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 333)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 334)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 336)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 337)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 338)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 339)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 340)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 341)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 342)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 343)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122799', 344)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122812', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122878', 100)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122935', 32)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122935', 54)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122935', 58)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122935', 78)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122935', 93)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103122935', 135)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103123392', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103123392', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103220999', 22)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103220999', 72)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103220999', 133)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103220999', 146)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103220999', 219)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103220999', 263)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103220999', 286)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221222', 166)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221222', 167)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221222', 169)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221222', 170)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221222', 171)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221222', 172)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221222', 302)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221222', 303)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221222', 304)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221222', 312)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221378', 228)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221378', 295)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221378', 297)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221503', 92)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221824', 17)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221824', 21)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221824', 29)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221824', 32)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221824', 54)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221824', 58)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221824', 78)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221824', 93)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221824', 182)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221824', 214)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221824', 239)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221824', 327)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221824', 332)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221824', 334)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221824', 335)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103221894', 228)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103498219', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103950305', 355)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103950305', 356)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103951441', 183)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103951441', 184)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103951441', 186)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103951441', 188)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103951441', 189)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103951441', 190)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103979621', 92)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103980678', 167)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103980678', 169)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103980678', 170)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103980678', 171)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103980678', 172)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103980678', 302)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103980678', 303)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103980678', 304)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103980678', 312)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103981005', 228)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103981091', 95)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103981091', 222)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103981091', 223)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103981111', 59)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103981111', 62)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1103981111', 63)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1104014950', 52)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1104014950', 113)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1104014950', 129)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1104014950', 207)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1104014950', 249)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1104014950', 285)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1104017426', 257)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1104382896', 168)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1104382896', 170)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1104382896', 171)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1104382896', 172)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1104382896', 302)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1104382896', 303)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1104382896', 304)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1104382896', 312)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1104384014', 89)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1104433274', 320)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1104433420', 230)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1104433420', 234)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1104435179', 71)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1104435179', 81)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1104435179', 97)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1104435484', 226)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1104435484', 370)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1104869965', 100)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1104869965', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108765893', 351)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766013', 35)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766013', 60)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766013', 124)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766013', 132)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766013', 153)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766013', 217)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766013', 218)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766013', 280)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766013', 281)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766013', 307)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766013', 372)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766448', 75)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766448', 228)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766448', 237)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766448', 289)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766448', 294)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766448', 295)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766448', 296)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766448', 297)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 10)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 19)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 28)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 31)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 39)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 47)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 57)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 66)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 77)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 86)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 94)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 110)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 116)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 117)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 119)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 125)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 126)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 130)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 137)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 139)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 142)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 195)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 196)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 209)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 221)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 252)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 253)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 268)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 290)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 291)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 292)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766517', 293)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1108766993', 153)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1124070096', 106)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1143154335', 95)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1143154335', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1143162372', 11)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1143162372', 30)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1143162372', 50)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1143162372', 64)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1143162372', 98)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1143162372', 236)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1143162372', 272)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1143162372', 283)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1143966465', 34)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1143966465', 43)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1143966465', 80)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1143966465', 87)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1143966465', 103)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1143966465', 120)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1151460086', 12)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1151460086', 38)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1151460086', 44)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1152450980', 10)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1152450980', 19)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1152450980', 31)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1152450980', 47)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1152450980', 57)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1152450980', 66)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1152450980', 86)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1152450980', 94)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1152450980', 110)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1152450980', 117)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1152450980', 130)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1152450980', 139)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1152450980', 142)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1152450980', 195)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1152450980', 196)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1152450980', 209)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1152450980', 252)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1152450980', 253)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1152450980', 290)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1152450980', 291)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1152450980', 292)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1152450980', 293)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192771291', 42)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192771291', 51)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192771291', 76)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192771291', 101)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192771291', 308)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192775810', 83)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192775810', 270)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192775833', 183)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192775833', 185)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192775833', 186)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192775833', 187)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192775833', 188)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192775833', 189)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192775833', 190)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192775833', 258)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192775833', 259)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192775833', 319)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192777710', 13)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192777710', 35)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192777710', 60)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192777710', 124)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192777710', 132)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192777710', 153)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192777710', 217)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192777710', 218)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192777710', 280)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192777710', 307)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192781238', 267)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192781238', 306)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192781238', 373)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192799932', 364)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192799932', 365)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192799932', 366)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192799932', 367)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1192804261', 158)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193033370', 289)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193098415', 127)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193098415', 136)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193098415', 153)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193098415', 216)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193098415', 218)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193098415', 278)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193098415', 279)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193098415', 281)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193098415', 306)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193112470', 374)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193146875', 63)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193148898', 229)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193148898', 231)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193148898', 269)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193152448', 63)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193201337', 49)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193201337', 127)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193201337', 144)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193233686', 92)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193263435', 56)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193280265', 56)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193280265', 81)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193290390', 235)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193390568', 100)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193416035', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193416035', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193416035', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193416035', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193416035', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193416035', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193416035', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193419536', 105)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193423769', 32)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193444474', 33)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193444474', 216)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193444474', 279)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193449629', 44)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193449629', 230)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193449629', 234)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193451912', 28)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193451912', 77)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193451912', 116)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193451912', 119)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193451912', 125)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193451912', 126)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193451912', 220)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193451912', 221)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193451912', 268)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193516489', 21)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193516489', 32)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193524195', 42)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193524195', 51)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193524195', 76)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193524195', 101)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193524195', 308)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193524195', 310)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193524195', 311)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193524195', 313)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193535666', 35)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193535666', 60)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193535666', 124)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193535666', 132)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193535666', 134)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193535666', 153)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193535666', 216)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193535666', 218)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193535666', 267)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1193535666', 371)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1234091164', 9)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1234091164', 34)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1234091164', 43)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1234091164', 80)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1234091164', 87)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1234091164', 103)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1234091164', 120)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1234091164', 212)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1234091164', 276)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'1235239674', 82)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'3829866', 52)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'3829866', 207)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'3829866', 249)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'3829866', 285)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'3839249', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'3839249', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'3839249', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'3839249', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'3839249', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'3839249', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'55157366', 28)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'55157366', 116)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'55157366', 125)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'55157366', 126)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'55157366', 221)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'55157366', 268)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'64680184', 357)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'64680184', 359)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'64680184', 360)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'78304944', 63)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'92524422', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'92524422', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'92524422', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'92524422', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'92524422', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'92524422', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'92524422', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'92548735', 9)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'92548735', 22)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'92548735', 34)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'92548735', 43)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'92548735', 72)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'92548735', 80)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'92548735', 87)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'92548735', 103)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'92548735', 120)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'92548735', 133)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'92548735', 146)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'92548735', 219)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'92548735', 263)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'92548735', 286)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'97123024501', 28)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'97123024501', 77)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'97123024501', 116)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'97123024501', 119)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'97123024501', 125)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'97123024501', 126)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'97123024501', 137)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'97123024501', 220)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'97123024501', 221)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'97123024501', 268)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98040256148', 10)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98040256148', 19)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98040256148', 31)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98040256148', 39)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98040256148', 47)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98040256148', 57)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98040256148', 66)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98040256148', 86)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98040256148', 94)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98040256148', 110)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98040256148', 117)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98040256148', 130)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98040256148', 139)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98040256148', 142)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98040256148', 195)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98040256148', 196)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98040256148', 209)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98040256148', 252)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98040256148', 253)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98040256148', 290)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98040256148', 291)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98040256148', 292)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98040256148', 293)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98052271991', 270)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98073064236', 61)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080564589', 233)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 10)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 19)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 28)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 47)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 57)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 66)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 77)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 86)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 94)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 110)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 116)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 117)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 119)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 125)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 126)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 130)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 137)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 139)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 195)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 196)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 209)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 221)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 252)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 253)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 268)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 290)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 291)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 292)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98080665644', 293)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 10)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 19)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 28)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 31)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 39)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 47)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 57)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 66)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 77)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 94)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 110)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 116)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 117)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 119)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 125)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 126)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 137)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 139)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 142)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 195)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 196)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 220)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 221)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 252)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 253)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 268)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 290)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 291)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 292)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082465715', 293)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98082961801', 353)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98091675366', 75)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98091675366', 228)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98091675366', 289)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98091675366', 294)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98091675366', 295)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98091675366', 296)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98091675366', 297)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98091871777', 83)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98091871777', 152)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98091871777', 163)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98091871777', 274)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98091871777', 275)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98100274272', 240)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98100367335', 28)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98100367335', 77)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98100367335', 116)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98100367335', 119)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98100367335', 125)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98100367335', 126)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98100367335', 137)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98100367335', 220)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98100367335', 221)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98100367335', 268)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98100770946', 274)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98101868761', 44)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98101868761', 49)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98101868761', 68)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102071166', 10)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102071166', 19)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102071166', 31)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102071166', 39)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102071166', 47)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102071166', 57)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102071166', 66)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102071166', 86)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102071166', 94)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102071166', 110)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102071166', 117)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102071166', 130)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102071166', 139)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102071166', 142)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102071166', 195)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102071166', 196)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102071166', 209)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102071166', 252)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102071166', 253)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102071166', 290)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102071166', 291)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102071166', 292)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102071166', 293)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102762762', 10)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102762762', 19)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102762762', 31)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102762762', 39)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102762762', 47)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102762762', 57)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102762762', 66)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102762762', 94)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102762762', 110)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102762762', 130)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102762762', 139)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102762762', 142)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102762762', 195)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102762762', 196)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102762762', 209)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102762762', 252)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102762762', 253)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102762762', 290)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102762762', 291)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102762762', 292)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102762762', 293)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102866002', 228)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102866002', 237)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102912624', 44)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102912624', 49)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102912624', 68)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98102912624', 144)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98111458014', 79)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98111458014', 112)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98111458014', 250)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98111458014', 284)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98111458014', 317)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98111817758', 83)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98111817758', 163)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98111817758', 270)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98121015382', 43)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98123011252', 81)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98123011252', 97)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98123011252', 154)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'98123011252', 199)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99011310008', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99011310008', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99011310008', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99011310008', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99011310008', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99011310008', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99011914973', 270)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99012815022', 183)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99012815022', 184)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99012815022', 185)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99012815022', 186)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99012815022', 187)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99012815022', 188)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99012815022', 189)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99012815022', 190)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99012815022', 258)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99012815022', 259)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99020600728', 75)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99020600728', 228)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99020600728', 237)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99020600728', 294)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99020600728', 295)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99020600728', 297)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99021016094', 28)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99021016094', 116)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99021016094', 119)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99021016094', 125)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99021016094', 126)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99021016094', 137)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99021016094', 220)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99021016094', 221)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99021016094', 268)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99021405210', 230)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99021405210', 234)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 10)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 19)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 28)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 31)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 39)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 47)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 57)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 66)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 77)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 94)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 110)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 117)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 119)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 125)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 126)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 137)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 139)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 142)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 195)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 196)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 220)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 221)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 252)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 253)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 268)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 290)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 291)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 292)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022104779', 293)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022211850', 166)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022211850', 167)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022211850', 168)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022211850', 169)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022211850', 170)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022211850', 171)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022211850', 302)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022211850', 303)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022211850', 304)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022405035', 75)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022405035', 228)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022405035', 237)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022405035', 289)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022405035', 294)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99022405035', 295)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99030205363', 10)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99030205363', 19)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99030205363', 47)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99030205363', 57)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99030205363', 66)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99030205363', 86)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99030205363', 94)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99030205363', 110)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99030205363', 117)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99030205363', 142)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99030205363', 195)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99030205363', 196)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99030205363', 209)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99030205363', 252)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99030205363', 253)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99030205363', 290)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99030205363', 291)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99030205363', 292)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99030205363', 293)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99030414507', 106)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99031512146', 183)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99031512146', 184)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99031512146', 186)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99031512146', 187)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99031512146', 188)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99031512146', 189)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99031512146', 190)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99031512146', 258)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99031512146', 259)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99031512146', 318)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99031512146', 319)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99032003920', 75)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99032003920', 162)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99032309000', 49)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99040314314', 45)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99040314314', 71)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99040314314', 81)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99040314314', 89)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99040314314', 90)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99040314314', 97)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99040314314', 102)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99040314314', 154)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99040314314', 199)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99041004351', 10)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99041004351', 19)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99041004351', 57)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99041004351', 86)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99041004351', 94)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99041004351', 110)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99041915290', 35)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99050417553', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99050417553', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99050417553', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99050417553', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99050417553', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99050417553', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99050417553', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99050712156', 62)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99050712156', 65)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99050712156', 91)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99050712156', 107)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99050712156', 111)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99050712156', 122)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99050712156', 129)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99050712156', 141)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99050712156', 194)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99051016927', 364)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99051511367', 9)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99051511367', 22)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99051511367', 34)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99051511367', 43)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99051511367', 72)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99051511367', 80)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99051511367', 87)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99051511367', 103)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99051511367', 120)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99051511367', 133)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99051511367', 146)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99051511367', 164)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99051511367', 165)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99051511367', 212)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99051511367', 219)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99051511367', 263)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99051511367', 276)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99051511367', 286)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99051517551', 269)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99051517551', 320)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99052209605', 37)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99052209605', 62)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99052209605', 63)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99052209605', 85)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99052209605', 122)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99052309731', 100)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99052817494', 90)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99052817494', 355)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99052817494', 356)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99052910079', 75)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99052910079', 162)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99052910079', 228)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99052910079', 237)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99052910079', 289)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99052910079', 295)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99052910079', 297)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99060118732', 62)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99060118732', 63)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99060209657', 270)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99060213956', 166)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99060213956', 167)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99060213956', 169)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99060213956', 170)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99060213956', 171)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99060213956', 172)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99060213956', 302)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99060213956', 303)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99060213956', 304)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99060213956', 312)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99060712162', 183)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99060712162', 184)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99060712162', 185)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99060712162', 186)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99060712162', 187)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99060712162', 188)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99060712162', 189)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99060712162', 190)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99060712162', 258)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99060712162', 259)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99060712162', 319)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99061310840', 136)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99061310840', 216)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99061310840', 279)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99062407090', 364)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99062407090', 365)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99062407090', 367)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99062407090', 369)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99070309820', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99070309820', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99070309820', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99070309820', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99070309820', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99070309820', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99070309820', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99070515888', 36)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99070515888', 158)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99071213290', 67)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99071213290', 356)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99071213290', 358)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99071213290', 360)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99071311291', 92)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99072014681', 79)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99072014681', 112)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99072014681', 250)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99072014681', 284)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99072014681', 317)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99072310736', 274)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99073011597', 17)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99073011597', 21)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99073011597', 29)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99080110037', 40)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99080110037', 68)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99080110037', 232)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99080110037', 235)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99080110037', 352)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99080214029', 42)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99080214029', 51)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99080214029', 76)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99080214029', 101)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99080214029', 308)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99080214029', 310)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99080214029', 311)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99080214029', 313)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99080709354', 270)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99080802427', 28)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99080802427', 116)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99080802427', 119)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99080802427', 125)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99080802427', 126)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99080802427', 137)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99080802427', 221)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99080802427', 268)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99081509936', 365)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99081509936', 367)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99081509936', 368)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99082110000', 61)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99082110000', 127)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99082110000', 134)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99082213879', 62)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99082213879', 141)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99082213879', 194)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99082316341', 42)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99082316341', 51)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99082316341', 76)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99082316341', 101)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99082417946', 32)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99083109005', 136)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99083109005', 216)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99083109005', 278)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99083109005', 279)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99083109005', 306)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99090109843', 37)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99090109843', 63)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99090109843', 129)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99090109843', 140)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99090111791', 191)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99090111791', 192)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99090111791', 193)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99090111791', 202)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99090111791', 318)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99090509892', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99090509892', 222)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99090509892', 225)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99090509892', 370)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99090608254', 364)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99090608254', 365)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99090608254', 366)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99090608254', 368)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99090608254', 369)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99090611069', 17)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99090611069', 29)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99090611069', 54)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99090611069', 58)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99091309579', 22)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99091309579', 72)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99091309579', 133)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99091309579', 146)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99091309579', 219)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99091309579', 263)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99091309579', 286)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99091613316', 229)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99091613316', 231)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99091706039', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99091706039', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99091706039', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99091706039', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99091706039', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99092601826', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99092717530', 100)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99092815150', 67)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99092906600', 17)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99092906600', 54)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99092906600', 58)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99092906600', 78)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99092906600', 93)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99092906600', 131)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99092906600', 135)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99100313916', 62)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99100313916', 65)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99100715968', 50)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99100804472', 274)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99100806181', 202)
GO
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99101006618', 90)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99101105233', 40)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99101415682', 100)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99101501724', 32)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99101501724', 64)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99101711958', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99101711958', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99101711958', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99101711958', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99101711958', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99101711958', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99101711958', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99101914913', 192)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99101914913', 193)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99101914913', 202)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99102512533', 29)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99102512533', 54)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99102512533', 93)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99102512533', 214)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99102512533', 332)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99102915549', 68)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99103108485', 127)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99103108485', 134)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99110314970', 42)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99110314970', 51)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99110314970', 76)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99110314970', 101)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99110314970', 308)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99110314970', 311)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99110813291', 13)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99110813291', 267)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99110813291', 371)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99110813291', 372)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99110813291', 373)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99111112963', 267)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99111112963', 373)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99112208310', 36)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99112208310', 82)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99112208310', 104)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99112208310', 158)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99112408157', 265)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99112408157', 270)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99112709238', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99112709238', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99112709238', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99112709238', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99112709238', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99112709238', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99112709238', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99120106712', 42)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99120106712', 51)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99120106712', 76)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99120106712', 101)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99120106712', 308)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99120109258', 52)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99120109258', 207)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99120109258', 249)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99120109258', 285)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99120804070', 136)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121304992', 95)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121304992', 105)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121304992', 109)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121304992', 222)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121304992', 224)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121304992', 225)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121304992', 226)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121304992', 370)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121310810', 90)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121310810', 355)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121404415', 143)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121404415', 145)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121404415', 155)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121404415', 157)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121404415', 173)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121404415', 277)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121404415', 345)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121708236', 364)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121708236', 365)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121708236', 366)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121708236', 368)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121802801', 42)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121802801', 51)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121802801', 76)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121802801', 101)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121802801', 308)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121802801', 309)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121802801', 310)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121802801', 311)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99121802801', 313)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99122303531', 92)
INSERT [dbo].[estudiantes_asistentes] ([estudiante_id], [clase_id]) VALUES (N'99122502933', 92)
INSERT [dbo].[grupos_acargo] ([idUsuario], [materia], [periodo], [id_grupo], [id_curso], [programa]) VALUES (N'1005575218', N'CALCULO I', N'2017-2', N'1', -1, N'INGENIERIA DE SISTEMAS')
INSERT [dbo].[grupos_acargo] ([idUsuario], [materia], [periodo], [id_grupo], [id_curso], [programa]) VALUES (N'1005575218', N'CALCULO II', N'2017-2', N'1', -1, N'INGENIERIA DE SISTEMAS')
INSERT [dbo].[grupos_acargo] ([idUsuario], [materia], [periodo], [id_grupo], [id_curso], [programa]) VALUES (N'1005575218', N'CALCULO II', N'2017-2', N'1', -1, N'INGENIERIA INDUSTRIAL')
INSERT [dbo].[grupos_acargo] ([idUsuario], [materia], [periodo], [id_grupo], [id_curso], [programa]) VALUES (N'1005575218', N'TALLER DE LENGUA I', N'2018-1', N'1', 114, N'ADMINISTRACION DE EMPRESAS')
INSERT [dbo].[grupos_acargo] ([idUsuario], [materia], [periodo], [id_grupo], [id_curso], [programa]) VALUES (N'1005575218', N'TALLER DE LENGUA I', N'2018-1', N'1', 114, N'ARQUITECTURA')
INSERT [dbo].[grupos_acargo] ([idUsuario], [materia], [periodo], [id_grupo], [id_curso], [programa]) VALUES (N'1102859256', N'CALCULO I', N'2017-2', N'1', -1, N'INGENIERIA DE SISTEMAS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ACCIONES CONSTITUCIONALES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ACTIVIDAD FISICA EN DISCAPACIDAD')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ACTIVIDAD FISICA Y REHABILITACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ACTIVIDAD FISICA Y SALUD')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ACTIVOS FIJOS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ACTIVOS LIQUIDOS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ACTUALIZACION TECNOLOGICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ADMINISTRACION DEPORTIVA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ADMINISTRACION EDUCATIVA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ADMINISTRACION GENERAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ADMINISTRACION Y PLANEACION SOCIAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ADOPCION POR PRIMERA VEZ')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ALGEBRA LINEAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ANALISIS DE ALGORITMOS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ANALISIS DE CASOS DEL SECTOR PORTUARIO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ANALISIS DE RIESGO. Y ESPECULACION EN EL MERCADO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ANALISIS FINANCIERO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ANALISIS NUMERICO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ANALISIS Y DISENO I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ANALISIS Y DISENO II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ANALISIS Y SISTEMATIZACION DE INFORMACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ANTROPOLOGIA CULTURAL Y SOCIAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ANTROPOLOGIA SOCIAL Y CULTURA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ARQUITECTURA DE LOS COMPUTADORES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ARQUITECTURA LATINOAMERICANA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ARQUITECTURA SIGLO V II - XV')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ARQUITECTURA Y GESTION DE LA INFORMACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ARQUITECTURA Y GESTION DE PROCESOS DE NEGOCIO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ARTE Y CREATIVIDAD')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ARTE Y CULTURA NACIONAL,REGIONAL Y LOCAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ARTE Y LUDICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ARTE,CREATIVIDAD Y EDUCACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ARTESANIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ASEGURAMIENTO I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ASEGURAMIENTO II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ASESORIA DE PRODUCTOS DE INVESTIGACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ASESORIA DEL PRODUCTO FINAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ASESORIAS DEL PROYECTO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ATLETISMO DE CAMPO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ATLETISMO DE PISTA Y CALLE')
INSERT [dbo].[materias] ([nombre]) VALUES (N'AUDITORIA AD/TIVA FINANCIERA Y OPERACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'AUDITORIA DE IPS Y EPS PAPELES DE TRABAJ')
INSERT [dbo].[materias] ([nombre]) VALUES (N'AUDITORIA MEDICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'AUDITORIA ODONTOLOGICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'AUTOMATAS Y COMPILADORES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'AYUDAS EDUCATIVAS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'B1 INTERMEDIO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'BASE DE DATOS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'BEISBOL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'BIENESTAR SOCIAL Y LABORAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'BIOMECANICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'BIOQUIMICA DEL DEPORTE')
INSERT [dbo].[materias] ([nombre]) VALUES (N'BOXEO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CALCULO I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CALCULO II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CALCULO III')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CANTOS Y RONDAS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CATEDRA DE GENERO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CERTIF DE PROCESOS DE CONSTRUCCION SUSTENTABLES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CIENCIA, TECNOLOGIA Y SOCIEDAD')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CIVILIZACIONES ANTIGUAS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'COMERCIO EXTERIOR')
INSERT [dbo].[materias] ([nombre]) VALUES (N'COMERCIO INTERNACIONAL PORTUARIO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'COMPETENCIAS EN LAS TIC')
INSERT [dbo].[materias] ([nombre]) VALUES (N'COMPORTAMIENTO ORGANIZACIONAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONSTITUCION POLITICA Y SEG.SOCIAL EN S.')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONSTITUCION Y SOCIEDAD')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONSTITUCIONALIZACION DEL DERECHO LABORAL Y DE LA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONSTITUCIONALIZACION DEL DERECHO PRIVADO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONSTRUCCION I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONSTRUCCION II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONSTRUCCION III')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONSTRUCCION IV')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONSTRUCCION V')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONSULTORIO JURIDICO I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONSULTORIO JURIDICO II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONSULTORIO JURIDICO III')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONSULTORIO JURIDICO IV')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONTABILIDAD DE PASIVO Y PATRIMONIO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONTABILIDAD DEL ACTIVO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONTABILIDAD FINANCIERA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONTABILIDAD GENERAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONTABILIDAD GERENCIAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONTABILIDAD PUBLICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONTABILIDADES ESPECIALES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONTRATACION ESTATAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONTRATACION PUBLICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONTRATOS CIVILES Y COMERCIALES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONTRATOS ESTATALES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONTROL DE CALIDAD')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONTROL DE GESTION-CONTROL INTERNO-MECI')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONTROL FINANCIERO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONTROL Y SUPERVISION DE OBRA EN CONST SUSTAB')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONTROLES DE LA ADMINISTRACION PUBLICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CONVERSATION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'COSTOS EN SALUD')
INSERT [dbo].[materias] ([nombre]) VALUES (N'COSTOS I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'COSTOS II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'COSTOS Y PRESUPUESTO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'COSTOS Y PRESUPUESTOS')
GO
INSERT [dbo].[materias] ([nombre]) VALUES (N'CREACION DE EMPRESAS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CREATIVIDAD')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CRIMINOLOGIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CULTURA CALIDAD Y GERENCIA ESTRATEG.CALI')
INSERT [dbo].[materias] ([nombre]) VALUES (N'CURICULO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DEPORTES ACICLICOS I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DEPORTES ACICLICOS II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DEPORTES CICLICOS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO ADMINISTRATIVO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO ADMINISTRATIVO COLOMBIANO I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO ADMINISTRATIVO COLOMBIANO II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO ADMINISTRATIVO GENERAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO ADMINISTRATIVO LABORAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO CIVIL BIENES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO CIVIL OBLIGACIONES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO CIVIL PERSONAS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO COMERCIAL I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO COMERCIAL II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO COMERCIAL Y SOCIEDADES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO CONSTITUCIONAL COLOMBIANO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO CONSTITUCIONAL COLOMBIANO I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO CONSTITUCIONAL COLOMBIANO II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO CONSTITUCIONAL GENERAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO DE FAMILIA Y DEL MENOR')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO DE LA INFANCIA Y DE LA ADOLESCENCIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO DE LA SEGURIDAD SOCIAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO FINANCIERO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO FUNDAMENTAL Y ACCIONES CONSTITUCIONALES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO INTERNACIONAL PUBLICO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO INTERNACIONAL Y DERECHOS FUNDAMENTALES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO LABORAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO LABORAL COLECTIVO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO LABORAL INDIVIDUAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO PENAL ESPECIAL I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO PENAL ESPECIAL II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO PENAL GENERAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO PENAL INTERNACIONAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO PROBATORIO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO PROCESAL ADMINISTRATIVO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO PROCESAL CIVIL I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO PROCESAL CIVIL II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO PROCESAL LABORAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO PROCESAL PENAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHO TRIBUTARIO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DERECHOS HUMANOS Y DIH')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DESARROLLO DEL LENGUAJE')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DESARROLLO DEL PENSAMIENTO CREATIVO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DESARROLLO EN LA ADULTEZ Y LA VEJEZ')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DESARROLLO EN LA NINEZ Y LA ADOLESCENCIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DESARROLLO PERSONAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DESARROLLO PERSONAL Y CONVIVENCIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DESARROLLO SOCIOEMOCIONAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DIAGNOSTICO FINANCIERA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DIAGNOSTICO FINANCIERO ESTRATEGICO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DIBUJO DE INGENIERIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DIDACTICA DE LA DANZA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DIDACTICA DE LA EXPRESION PLASTICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DIDACTICA DE LA LECTOESCRITURA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DIDACTICA DE LA LENGUA INGLESA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DIDACTICA DE LA LITERATURA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DIDACTICA DE LA MUSICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DIDACTICA DE LA PEDAGOGIA CORPORAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DIDACTICA DE LA PEDAGOGIA DE LA LITERATURA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DIDACTICA GENERAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DIDACTIVA DE LA LENGUA CASTELLANA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DISENO DE INVESTIGACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DISENO INFORMATICO I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DISENO INFORMATICO II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DISENO INFORMATICO III')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DISENO Y EVALUACION DE PROYECTOS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DISENO Y METODOLOGIA  III')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DISENO Y METODOLOGIA I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DISENO Y METODOLOGIA II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DISENO Y METODOLOGIA IV')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DISENO Y METODOLOGIA IX')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DISENO Y METODOLOGIA V')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DISENO Y METODOLOGIA VI')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DISENO Y METODOLOGIA VII')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DISENO Y METODOLOGIA VIII')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DISENO Y METODOLOGIA X')
INSERT [dbo].[materias] ([nombre]) VALUES (N'DISTRIBUCION EN PLANTA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ECOLOGIA HUMANA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ECONOMETRIA I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ECONOMETRIA II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ECONOMIA AMBIENTAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ECONOMIA INTERNACIONAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ECONOMIA POLITICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ECONOMIA POLITICA Y COLOMBIANA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ECONOMIA PUBLICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ECONOMIA SOCIAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ECOURBANISMO I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ECOURBANISMO II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ECOURBANISMO III')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ECOURBANISMO IV')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ECOURBANISMO V')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ECOURBANISMO VI')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ECOURBANISMO VII')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ECUACIONES DIFERENCIALES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'EDUCACION AMBIENTAL')
GO
INSERT [dbo].[materias] ([nombre]) VALUES (N'EDUCACION EN COLOMBIA Y REGION CARIBE')
INSERT [dbo].[materias] ([nombre]) VALUES (N'EDUCACION INCLUSIVA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'EDUCACION Y DESAROLLO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'EDUCACION Y SOCIEDAD')
INSERT [dbo].[materias] ([nombre]) VALUES (N'EDUCACION, CIENCIA Y TECNOLOGIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'EL JUEGO DRAMATICO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'EL NEGOCIO JURIDICO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ELAB. Y EVALUACION DE PROYECTOS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ELECTIVA DE CONTEXTO I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ELECTIVA DE CONTEXTO II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ELECTIVA DE CONTEXTO III')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ELECTIVA FORMACION INTEGRAL I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ELECTIVA FORMACION INTEGRAL II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ELECTIVA I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ELECTIVA II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ELECTIVA III')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ELECTIVA III FORM S-J')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ELECTIVA IV FORM. PROFESIONAL (MASC)')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ELECTIVA PROFESIONAL I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ELECTIVA PROFESIONAL I:PSICOLOGIA SOCIAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ELECTIVA PROFESIONAL II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ELECTIVA PROFESIONAL II:PSICOLOGIA EDUCATIVA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ELECTIVA PROFESIONAL III')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ELECTIVA PROFESIONAL III:PSICOLOGIA ORGANIZACIONAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ELECTIVA PROFESIONAL IV')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ELECTIVA V (REGI. SERVI. PUBLICO)')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ELECTIVA VI (CONTRATOS INFORMAT. Y TELEMAT.)')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ELECTRONICA BASICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ELECTROTECNIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'EMPRENDIMIENTO I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ENFOQUE COGNITIVO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ENFOQUE COMPORTAMENTAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ENFOQUE HUMANISTA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ENFOQUE PSICODINAMICO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ENFOQUE SISTEMICO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ENFOQUES CONTEMPORANEOS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ENTORNO ECONOMICO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ENTRENAMIENTO DEPORTIVO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ENTRENAMIENTO FITNESS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ENTREVISTA Y EVALUACION PSICOLOGICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'EPISTEMOLOGIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'EPISTEMOLOGIA DE LA EDUCACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'EPISTEMOLOGIA DE LA PEDAGOGIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'EPISTEMOLOGIA DEL LENGUAJE')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ESCRITURA DE TEXTOS INVESTIGATIVOS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ESCUELA DE CIUDADANIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ESCUELA DE INGLES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ESCUELA DE LECTOESCRITURA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ESCUELA TIC')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ESCUELA, FAMILIA Y COMUNIDAD')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ESPIRITU EMPRENDEDOR')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ESPIRITU EMPRESARIAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ESTADISTICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ESTADISTICA APLICADA A LOS SERVICIO DE SALUD')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ESTADISTICA DESCRIPTIVA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ESTADISTICA I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ESTADISTICA II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ESTADISTICA INFERENCIAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ESTADO DE DES.DE LA CONSTRUCCION SUSTENTABLE')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ESTADOS FINANCIEROS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ESTRATEGIAS DE ENSENANZA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ESTRUCTURA DE DATOS I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ESTRUCTURA DE DATOS II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ESTRUCTURA DE PORTAFOLIOS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ESTRUCTURA DEL PROC PENAL Y SIST DE AUD EN EL PROC')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ESTRUCTURA II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ESTRUCTURA Y FUNCIONAMIENTO DEL ESTADO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ESTRUCTURAS III')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ESTUDIO DEL TRABAJO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ETICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ETICA PROFESIONAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ETICA PUBLICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ETICA Y CULTURA DE LA PROFESION DOCENTE')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ETICA Y RESPONSABILIDAD MEDICO LEGAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ETICA Y RESPONSABILIDAD SOCIAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'EVALUACION DE DESEMPENO POR COMPETENCIAS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'EVALUACION DEL IMPACTO  AMBIENTAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'EXCEL FINANCIERO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'EXPRESION CORPORAL Y DANZA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'EXPRESION I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'EXPRESION II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'EXPRESION III')
INSERT [dbo].[materias] ([nombre]) VALUES (N'EXPRESION IV')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FILOSOFIA DE VALORES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FILOSOFIA DE VALORES Y DESARROLLO HUMANO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FILOSOFIA DEL DERECHO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FINANZAS DE CORTO PLAZO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FINANZAS DE LARGO PLAZO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FINANZAS INTERNACIONALES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FINANZAS PUBLICAS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FINANZAS Y VALOR ECONOMICO AGREGADO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FISICA I Y LABORATORIO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FISICA II Y LABORATORIO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FISICA III Y LABORATORIO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FISICA/BIOCLIMATICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FISIOLOGIA DEL EJERCICIO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FONETICA DEL CASTELLANO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FORMACION INVESTIGATIVA I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FORMACION INVESTIGATIVA II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FORMACIÓN PARA LA INVESTIGACIÓN I')
GO
INSERT [dbo].[materias] ([nombre]) VALUES (N'FORMACION PARA LA INVESTIGACION II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FORMAS DE CONTRATACION EN EL SGSSS EN CO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FORMULACION Y EVALUACION DE PROYECTO SOCIALES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FUND CONCEPTUALES Y EL SOGC EN COLOMBIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FUNDAMENTACION TEORICA DEL DERECHO LABORAL Y DE LA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FUNDAMENTO DE PENSAMIENTO ADMINISTRATIVO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FUNDAMENTO DEL PENSAMIENTO ECONOMICO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FUNDAMENTOS BIOLOGICOS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FUNDAMENTOS BIOLOGICOS DEL COMPORTAMIENTO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FUNDAMENTOS DE ADMINISTRACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FUNDAMENTOS DE ADMNISTRACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FUNDAMENTOS DE CONTABILIDAD')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FUNDAMENTOS DE ECONOMIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FUNDAMENTOS DE MERCADEO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FUNDAMENTOS DE PROGRAMACION I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FUNDAMENTOS DE PROGRAMACION II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FUNDAMENTOS DE TECNOLOGIAS DE LA INFORMACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FUNDAMENTOS Y CONTEXTO PARA LA INVESTIGACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'FUNDAMENTOS Y CONTEXTOS PARA LA INVESTIGACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'GENERACION Y SUSTENTACION DE PRODUCTO DE INVESTIGACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'GENERACION-ASESORIA-SUSTENT PRODUCTOS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'GERENCIA  DE PROYECTOS DE INVERSION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'GERENCIA DE LA PRODUCCION Y CONTROL DE CALIDAD')
INSERT [dbo].[materias] ([nombre]) VALUES (N'GERENCIA DE PROCESO ESTRATEGICO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'GERENCIA DE TALENTO HUMANO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'GERENCIA ESTRATEGICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'GERENCIA Y GESTION DE PROYECTO SOCILAES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'GESTION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'GESTION AMBIENTAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'GESTION DE LA CALIDAD')
INSERT [dbo].[materias] ([nombre]) VALUES (N'GESTION DE LA PRODUCCION I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'GESTION DE LA PRODUCCION II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'GESTION DEL CONOCIMIENTO ORGANIZACIONAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'GESTION DEL TALENTO HUMANO I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'GESTION DEL TALENTO HUMANO II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'GESTION ETICA Y DESICIONES EN HABILITACI')
INSERT [dbo].[materias] ([nombre]) VALUES (N'GESTION FINANCIERA Y PRESUPUESTAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'GIMNASIA BASICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'GRAMATICA DEL INGLES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'GRUPO Y COMUNIDAD I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'GRUPO Y COMUNIDAD II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'HABILIDADES GERENCIALES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'HABILIDADES GERENCIALES EN LAS ORG.PUBL.')
INSERT [dbo].[materias] ([nombre]) VALUES (N'HERMENEUTICA Y ARGUMENTACION JURIDICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'HERRAMIENTAS FINANCIERAS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'HERRAMIENTAS TECNOLOGICAS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'HISTORIA DE LA PEDAGOGIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'HISTORIA DE LAS IDEAS POLITICAS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'HISTORIA DEL ARTE IV')
INSERT [dbo].[materias] ([nombre]) VALUES (N'HISTORIA DEL DERECHO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'HISTORIA EMPRESARIAL COLOMBIANA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'HISTORIA SOCIO-POLITICA DE COLOMBIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'HISTORIA Y FILOSOFIA DE LA PEDAGOGIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'IDENTIDAD Y ROL DEL PSICOLOGO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INCUBACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INDICADORES Y COSTOS EN LA GESTION PORTUARIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INDIVIDUO Y FAMILIA I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INDIVIDUO Y FAMILIA II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INFORMATICA EDUCATIVA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INGENIERIA DEL SOFTWARE')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INGLES BASICO I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INGLES BASICO II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INGLES BASICO III')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INGLES I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INGLES II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INGLES III')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INGLES INTERMEDIO I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INGLES INTERMEDIO II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INGLES IV')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INGLES PREINTERMEDIO I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INGLES PREINTERMEDIO II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INGLES PREINTERMEDIO III')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INGRESO DE ACTIVIDADES ORDINARIAS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INNOVACION TECNOLOGICA I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INNOVACION TECNOLOGICA II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INNOVACION Y CREATIVIDAD')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INNOVACION Y DESARROLLO PARA LA CONST SUSTENTABLE')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INST Y REDES EN LA CONTRUC SUST (IMANEJO DEL AGUA)')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INST Y REDES EN LA CONTRUC SUST (INST ELE SUSTENT)')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INSTRUMENTOS FINANCIEROS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INTELIGENCIA EMOCIONAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INTELIGENCIA Y APRENDIZAJE')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INTRODUCCION A LA ADMINISTRACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INTRODUCCION A LA CONTADURIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INTRODUCCION A LA INGENIERIA DE SISTEMAS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INTRODUCCION A LA INGENIERIA INDUSTRIAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INTRODUCCION A LA PSICOLOGIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INTRODUCCION A LAS CIENCIAS DEL DEPORTE')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INTRODUCCION AL DERECHO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INTRODUCCION AL TRABAJO SOCIAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INTRODUCION ALA ECONOMIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INVESTIGACION DE MERCADOS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INVESTIGACION DE OPERACIONES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INVESTIGACION DE OPERACIONES I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INVESTIGACION DE OPERACIONES II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INVESTIGACION EDUCATIVA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INVESTIGACION EN EL AULA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INVESTIGACION I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INVESTIGACION II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'INVESTIGACION SOCIOJURIDICA I')
GO
INSERT [dbo].[materias] ([nombre]) VALUES (N'INVESTIGACION SOCIO-JURIDICA II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'JUSTICIA CONTENCIOSA ADMINISTRATIVA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'JUSTICIA TRANSICIONAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LA LUDICA COMO HERRAMIENTA DINAMIZADORA DEL ARTE Y')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LA RESTRICCION DE LA LIBERTAD EN EL NUEVO MODELO D')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LA SEMIOLOGIA, EL LENGUAJE Y LA LECTURA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LA VICTIMA Y SU PARTICIPACION DENTRO DEL PROCESO P')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LABORATORIO CONTABLE I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LABORATORIO CONTABLE II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LAS ORGANIZACIONES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LEGISLACION AMBIENTAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LEGISLACION DEPORTIVA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LEGISLACION SOCIAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LEGISLACION SOCIAL Y POLITICAS PUBLICAS DE FAMILIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LEGISLACION TRIBUTARIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LEGISLACION TRIBUTARIA I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LEGISLACION TRIBUTARIA II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LENGUA EXTRANJERA A1')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LENGUA EXTRANJERA A2')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LENGUA EXTRANJERA B1')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LENGUA EXTRANJERA PORTUGUES A1')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LENGUA EXTRANJERA PORTUGUES A2')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LENGUA EXTRANJERA PORTUGUES B1')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LENGUAJES DE PROGRAMACION I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LENGUAJES DE PROGRAMACION II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LINGUISTICA DEL DISCURSO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LINGUISTICA GENERAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LITERATURA COLOMBIANA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LITERATURA HISPANOAMERICANA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LITERATURA INFANTIL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LITERATURA REGIONAL COSTENA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LOGICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LOGICA MATEMATICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LOGISTICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LOGISTICA INTERNACIONAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'LOGISTICA PORTUARIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MACROECONOMIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MACROECONOMIA I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MACROECONOMIA II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MANEJO DE RESIDUOS EN LA CONSTRUCCION SUSTENTABLE')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MARCO CONCEPTUAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MARCO LEGAL Y JURISPRUDENCIA,FUNCIONES Y OBLIG')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MARKETING INTERNACIONAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MASAJE DEPORTIVO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MATEMATICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MATEMATICA BASICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MATEMATICA FINANCIERA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MATEMATICA Y EXCEL  FINANCIERO PARA LA TOMA DE DEC')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MATEMATICA Y GEOMETRIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MATEMATICAS APLICADAS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MATEMATICAS DISCRETAS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MATEMATICAS FINANCIERA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MATERIALES DE INGENIERIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MECANISMOS ALT. DE SOLUCION DE CONFLICTOS (MASC)')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MEDICINA DEPORTIVA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MEDICION Y EVALUACION PSICOLOGICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MERCADO DE DERIVADOS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MERCADOS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'METODOLOGIA DE LA INVESTIGACION SOCIOJUR')
INSERT [dbo].[materias] ([nombre]) VALUES (N'METODOS DE INTERVENCION EN TRABAJO SOCIAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MICROECONOMIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MICROECONOMIA I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MICROECONOMIA II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MODALIDADES DE ATENCION DIRECTA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MODELO DE GESTION POR COMPETENCIAS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MODELOS PEDAGOGICOS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MODERNIDAD  EN EUROPA Y AMERICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MODERNIZACION DEL ESTADO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MORFOLOGIA DEL DEPORTE')
INSERT [dbo].[materias] ([nombre]) VALUES (N'MORFOSINTAXIS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'NEGOCIACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'NEGOCIACION EN LOS SISTEMAS DE SALUD')
INSERT [dbo].[materias] ([nombre]) VALUES (N'NEGOCIACION ESTRATEGICA INTERNACIONAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'NEGOCIOS INTERNACIONALES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'NEUROPSICOFISIOLOGIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'NEUROPSICOLOGIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'NOTARIADO Y REGISTRO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'NUTRICION DEPORTIVA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'OPERACIONES DE RENTA FIJA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'OPTATIVA I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'OPTATIVA II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'OPTATIVA III')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ORALIDAD Y PROCESO CIVIL.')
INSERT [dbo].[materias] ([nombre]) VALUES (N'ORDENAMIENTO TERRITORIAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PADDLE SURF')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PAISAJISMO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PARADIGMAS DE INVESTIGACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PEDAGOGIA INFANTIL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PENSAMIENTO ECONOMICO CONTEMPORANEO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PLAN EXPORTADOR')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PLANEACION DEL DESARROLLO TERRITORIAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PLANEACION FINANCIERA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PLANES DE DESARROLLO EDUCATIVO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PLANIFICACION ECONOMICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PLANIFICIACION DEL DESARROLLO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'POLITICA SOCIAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PRACTICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PRACTICA ESTUDIANTIL I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PRACTICA I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PRACTICA II')
GO
INSERT [dbo].[materias] ([nombre]) VALUES (N'PRACTICA III')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PRACTICA INTEGRAL (ADMINISTRACION DEPORTIVA)')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PRACTICA INTEGRAL (ENTRENAMIENTO DEPORTIVO)')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PRACTICA INTEGRAL I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PRACTICA INTEGRAL II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PRACTICA INTEGRAL Y SOCIAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PRACTICA IV')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PRACTICA PROFESIONAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PRACTICA PROFESIONAL I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PRACTICA PROFESIONAL II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PRACTICA PROFESIONAL III')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PRACTICA V')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PREPARACION FISICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PREPARACION Y FORMULACION DE PROYECTOS AMBIENTALES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PRESUPUESTO Y PROGRAMACION DE OBRAS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PRESUPUESTOS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PRINCIPIOS RECTORES DE LA LEY 906 DEL 2004 DEL C.P')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PRINCIPIOS Y TENDENCIAS CONSTITUCIONALES Y LEGALES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PROBLEMAS Y ESTRATEGIAS DE APRENDIZAJE Y DE ENSENA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PROBLEMAS Y ESTRATEGIAS DE ENSENANZA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PROBLEMATICA REGIONAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PROBLEMATICA SOCIAL REGIONAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PROBLEMATICAS SOCIALES CONTEMPORANEAS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PROCEDIMIENTO CIVIL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PROCEDIMIENTO TRIBUTARIO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PROCEDIMIENTO Y ACTO ADMINISTRATIVO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PROCESAL CONSTITUCIONAL Y PROCED/TO ADMINISTRATIVO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PROCESO ADMINISTRATIVO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PROCESO DE EVALUACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PROCESO DE MANUFACTURA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PROCESOS ANTE LA JURISDICCION ORDINARIA LABORAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PROCESOS COGNITIVOS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PROCESOS DECLARATIVOS ESPECIALES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PROCESOS PSICOLOGICOS BASICOS Y LABORATORIO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PROCESOS PSICOLOGICOS SUPERIORES Y LABORATORIO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PRODUCTO FINAL DE LA INVESTIGACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PROGRAMACION LINEAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PROGRAMACION Y TECNOLOGIAS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PROYECTO DE INVESTIGACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PROYECTO INTEGRADOR I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PRUEBAS JUDICIALES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PSICOLINGUISTICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PSICOLOGIA CLINICA Y DE LA SALUD')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PSICOLOGIA COGNITIVA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PSICOLOGIA DEPORTIVA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PSICOLOGIA EDUCATIVA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PSICOLOGIA GENERAL Y EVOLUTIVA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PSICOLOGIA INFANTIL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PSICOLOGIA JURIDICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PSICOLOGIA ORGANIZACIONAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PSICOLOGIA SOCIAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PSICOMOTRICIDAD')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PSICOMOTRICIDAD Y JUEGO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PSICOPATOLOGIA - PSICOLOGIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'PSICOPATOLOGIA TRABAJO SOCIAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'RECREACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'RECURSO HUMANO EN LA CONSTRUCCION SUSTENTABLE')
INSERT [dbo].[materias] ([nombre]) VALUES (N'REDES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'REGIMEN ADMINISTRATIVO Y CONSTITUCIONAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'REGIMEN ADMINISTRATIVO Y CONSTITUCIONAL-')
INSERT [dbo].[materias] ([nombre]) VALUES (N'REGIMEN DE FAMILIA Y SUCESIONES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'REGIMEN DE SEGURIDAD SOCIAL EN PENSIONES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'REGIMEN DE SEGURIDAD SOCIAL EN SALUD')
INSERT [dbo].[materias] ([nombre]) VALUES (N'REGIMEN DE SOCIEDADES Y TT.VALORES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'REGIMEN JURIDICO DE ENTIDADES TERRITORIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'REGIMEN SEGURIDAD SOCIAL EN RIESGOS LABORALES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'RELACION ENTRE COMPANIAS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'RELACIONES LAB Y LEGAL DE LA GEST DEL TALENT HUMAN')
INSERT [dbo].[materias] ([nombre]) VALUES (N'RELACIONES LABORALES INDIVIDUALES Y COLECTIVAS DEL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'RENTA VARIABLE: ACCIONES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'RESISTENCIA DE MATERIALES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'RESPONSABILIDAD ADMINISTRATIVA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'REVELACIONES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'REVISORIA FISCAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SALUD OCUPACIONAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SECUENCIAS DIDACTICAS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SEGURIDAD SOCIAL EN PENSIONES ( VEJEZ, INVALIDEZ,')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SEGURIDAD SOCIAL EN SALUD')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SEGURIDAD Y SALUD EN EL TRABAJO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SELECCION POR COMPETENCIA Y ADMINISTRACION DE LA C')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SEMANTICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SEMINARIO DE ACTUALIZACIONEN TRABAJO SOCIAL I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SEMINARIO DE ACTUALIZACIONEN TRABAJO SOCIAL II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SEMINARIO DE ATENCION A VICTIMA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SEMINARIO DE ETICA Y FILOSOFIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SEMINARIO DE INVESTIGACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SEMINARIO DE INVESTIGACION I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SEMINARIO DE INVESTIGACION II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SEMINARIO DE PRACTICA EMPRESARIAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SEMINARIO ELECTIVA I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SEMINARIO ELECTIVA II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SEMINARIO ELECTIVO I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SEMINARIO ELECTIVO I:DIAGNOSTICO SOCIAL E INTERVEC')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SEMINARIO ELECTIVO II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SEMINARIO ESTUDIO DE CASOS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SEMINARIO TALLER DE INVESTIGACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SEMINARIO TALLER DE INVESTIGACION II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SEMINARIO TALLER DE INVESTIGACION III')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SEMINARIO TALLER DE INVESTIGACION IV')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SEMINARIO TECNICO')
GO
INSERT [dbo].[materias] ([nombre]) VALUES (N'SEMIOTICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SERVICIOS COMPLEMENTARIOS EN EL SISTEMA PORTUARIO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SEXUALIDAD INFANTIL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SEXUALIDAD Y VALORES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SIMULACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SIMULACION DE PROCESOS Y OPERACIONES PORTUARIAS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SIST ALT PARA LA CONST SUSTENT (CONST EN MADERA)')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SIST ALT PARA LA CONST SUSTENT (CONST EN TIERRA)')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SIST ALT PARA LA CONST SUSTENT (CUBIERTAS VERDES)')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SIST ALT PARA LA CONST SUSTENT (REC Y REU DE MATE)')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SIST.OBLIGATORIO DE GARAN.CALIDAD ATEN.S')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SISTEMA DE RIESGOS LABORALES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SISTEMA NACIONAL DE PROTECCION DE LOS DERECHOS HUM')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SISTEMA PROBATORIO DE LA LEY 906: INDAGACION-INVES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SISTEMA UNICO DE HABIL Y ACREDITACION EN SALUD')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SISTEMAS DE COSTEO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SISTEMAS DE INFORMACION EN SALUD')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SISTEMAS DE INFORMACION GERENCIAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SISTEMAS DE SALUD-SGSSS EN COLOMBIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SISTEMAS DIGITALES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SISTEMAS DINAMICOS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SISTEMAS DISTRIBUIDOS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SISTEMAS ECOLOGICOS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SISTEMAS OPERATIVOS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SISTEMAS WEB Y TECNOLOGIAS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SISTEMATIZACION DE PROYECTO SOCIALES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SOCIEDAD Y CONFLICTO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SOCIO ANTROPOLOGIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SOCIO-ANTROPOLOGIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SOCIOLINGUISTICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SOCIOLOGIA DEPORTIVA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SOCIOLOGIA JURIDICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SOCIOLOGIA URBANA Y REGIONAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SOCIOLOGIA/FILOSOFIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'STARTER A')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SUCESIONES')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SUSTENTACION DEL PRODUCTO FINAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'SUSTENTACION PROYECTO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TALLER DE ARTES PLASTICAS I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TALLER DE ARTES PLASTICAS II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TALLER DE DANZAS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TALLER DE EXPRESION CORPORAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TALLER DE INTEGRACION ESTUDIO DE CASOS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TALLER DE INVESTIGACION I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TALLER DE INVESTIGACION II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TALLER DE INVESTIGACION III')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TALLER DE INVESTIGACION IV')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TALLER DE LENGUA I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TALLER DE LENGUA II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TALLER DE LITERATURA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TALLER DE MUSICA II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TALLER DE TEATRO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TALLER ELECTIVA I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TALLER ELECTIVA II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TALLER ELECTIVA III')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TALLER I:FUNDAMENTOS TEORICOS Y METODOLOGICOS DE I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TARIFAS Y FACTURACION DE CUENTAS MEDICAS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TECNICA DE ORALIDAD PROCESAL I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TECNICAS DE APRENDIZAJE')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TECNICAS DE INDAGACION E INVESTIGACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TECNICAS E INSTRUMENTOS DE INVESTIGACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TEORIA CONTABLE')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TEORIA DE LA ARQUITECTURA I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TEORIA DE LA ARQUITECTURA II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TEORIA DE LA ARQUITECTURA III')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TEORIA DE SISTEMAS')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TEORIA DEL ACTO ADMINISTRATIVO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TEORIA DEL APRENDIZAJE')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TEORIA DEL DESARROLLO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TEORIA GENERAL DEL CONTRATO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TEORIA GENERAL DEL PROCESO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TEORIA LITERARIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TEORIA Y POLITICA FISCAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TEORIA Y POLITICA MONETARIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TEORIAS Y ENFOQUES DEL DESARROLLO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TEORIAS, PARADIGMAS Y ENFOQUES DE LA COMUNIDAD')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TEORIAS, PARADIGMAS Y ENFOQUES DE LA FAMILIA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TERMODINAMICA')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TIC')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TIPOS DE INVESTIGACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TOPICOS ESPECIALES DE INGENIERIA DE SISTEMAS I')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TOPICOS ESPECIALES DE INGENIERIA DE SISTEMAS II')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TRABAJO DE GRADO')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TRABAJO DE GRADO O SEMINARIO DE PROFUNDIZACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TRABAJO DE INVESTIGACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TRABAJO FINAL')
INSERT [dbo].[materias] ([nombre]) VALUES (N'TRABAJO FINAL DE INVESTIGACION')
INSERT [dbo].[materias] ([nombre]) VALUES (N'VERIF DE LOS ESTANDARES Y COND DE LA HAB')
INSERT [dbo].[materias] ([nombre]) VALUES (N'VICTIMOLOGIA Y D.D.H Y D.I.H')
INSERT [dbo].[materias] ([nombre]) VALUES (N'VIDA UNIVERSITARIA')
SET IDENTITY_INSERT [dbo].[Notas] ON 

INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (5, 89, N'Nota 1', N'1002488158', 447)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (5, 89, N'Nota 2', N'1002488158', 448)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (5, 89, N'Definitiva', N'1002488158', 449)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Nota 1', N'1007770637', 450)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Nota 2', N'1007770637', 451)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Definitiva', N'1007770637', 452)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4.7, 89, N'Nota 1', N'1007649757', 453)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.4, 89, N'Nota 2', N'1007649757', 454)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.9, 89, N'Definitiva', N'1007649757', 455)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.1, 89, N'Nota 1', N'1005604364', 456)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4, 89, N'Nota 2', N'1005604364', 457)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.6, 89, N'Definitiva', N'1005604364', 458)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Nota 1', N'1005640103', 459)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.7, 89, N'Nota 2', N'1005640103', 460)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.4, 89, N'Definitiva', N'1005640103', 461)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.8, 89, N'Nota 1', N'1005576280', 462)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.4, 89, N'Nota 2', N'1005576280', 463)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.6, 89, N'Definitiva', N'1005576280', 464)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (0, 89, N'Nota 1', N'1103110982', 465)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (0, 89, N'Nota 2', N'1103110982', 466)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (1, 89, N'Definitiva', N'1103110982', 467)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.2, 89, N'Nota 1', N'1005575626', 468)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (2.8, 89, N'Nota 2', N'1005575626', 469)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Definitiva', N'1005575626', 470)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.8, 89, N'Nota 1', N'99120804070', 471)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4.3, 89, N'Nota 2', N'99120804070', 472)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4.1, 89, N'Definitiva', N'99120804070', 473)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Nota 1', N'1102884541', 474)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Nota 2', N'1102884541', 475)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Definitiva', N'1102884541', 476)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4, 89, N'Nota 1', N'99091311700', 477)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4, 89, N'Nota 2', N'99091311700', 478)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4, 89, N'Definitiva', N'99091311700', 479)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (2.5, 89, N'Nota 1', N'99080413234', 480)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.5, 89, N'Nota 2', N'99080413234', 481)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.1, 89, N'Definitiva', N'99080413234', 482)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.1, 89, N'Nota 1', N'1010152086', 483)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.8, 89, N'Nota 2', N'1010152086', 484)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.5, 89, N'Definitiva', N'1010152086', 485)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4.7, 89, N'Nota 1', N'1193444474', 486)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (5, 89, N'Nota 2', N'1193444474', 487)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4.9, 89, N'Definitiva', N'1193444474', 488)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (2.4, 89, N'Nota 1', N'1102875167', 489)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.7, 89, N'Nota 2', N'1102875167', 490)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.2, 89, N'Definitiva', N'1102875167', 491)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (2.8, 89, N'Nota 1', N'1101380622', 492)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.5, 89, N'Nota 2', N'1101380622', 493)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.2, 89, N'Definitiva', N'1101380622', 494)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Nota 1', N'99042211423', 495)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Nota 2', N'99042211423', 496)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Definitiva', N'99042211423', 497)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (2.7, 89, N'Nota 1', N'1003206448', 498)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4.1, 89, N'Nota 2', N'1003206448', 499)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.5, 89, N'Definitiva', N'1003206448', 500)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (2.8, 89, N'Nota 1', N'1002490697', 501)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (2.7, 89, N'Nota 2', N'1002490697', 502)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (2.7, 89, N'Definitiva', N'1002490697', 503)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Nota 1', N'1005457096', 504)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.4, 89, N'Nota 2', N'1005457096', 505)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.2, 89, N'Definitiva', N'1005457096', 506)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (2.8, 89, N'Nota 1', N'1100307383', 507)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.8, 89, N'Nota 2', N'1100307383', 508)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.4, 89, N'Definitiva', N'1100307383', 509)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4.5, 89, N'Nota 1', N'1010068483', 510)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Nota 2', N'1010068483', 511)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.6, 89, N'Definitiva', N'1010068483', 512)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.8, 89, N'Nota 1', N'99061310840', 513)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.5, 89, N'Nota 2', N'99061310840', 514)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.6, 89, N'Definitiva', N'99061310840', 515)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Nota 1', N'98101469565', 516)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Nota 2', N'98101469565', 517)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Definitiva', N'98101469565', 518)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (2.6, 89, N'Nota 1', N'1102871214', 519)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.4, 89, N'Nota 2', N'1102871214', 520)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.1, 89, N'Definitiva', N'1102871214', 521)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Nota 1', N'1003645531', 522)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.8, 89, N'Nota 2', N'1003645531', 523)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.5, 89, N'Definitiva', N'1003645531', 524)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.6, 89, N'Nota 1', N'1072261597', 525)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4, 89, N'Nota 2', N'1072261597', 526)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.8, 89, N'Definitiva', N'1072261597', 527)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Nota 1', N'1001866278', 528)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Nota 2', N'1001866278', 529)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Definitiva', N'1001866278', 530)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.4, 89, N'Nota 1', N'1193098415', 531)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Nota 2', N'1193098415', 532)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.2, 89, N'Definitiva', N'1193098415', 533)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Nota 1', N'1102883545', 534)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Nota 2', N'1102883545', 535)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Definitiva', N'1102883545', 536)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (2.5, 89, N'Nota 1', N'1102882518', 537)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.8, 89, N'Nota 2', N'1102882518', 538)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.3, 89, N'Definitiva', N'1102882518', 539)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (2.7, 89, N'Nota 1', N'97061600454', 540)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (2.5, 89, N'Nota 2', N'97061600454', 541)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (2.6, 89, N'Definitiva', N'97061600454', 542)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.9, 89, N'Nota 1', N'1010044966', 543)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.8, 89, N'Nota 2', N'1010044966', 544)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.8, 89, N'Definitiva', N'1010044966', 545)
GO
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4.4, 89, N'Nota 1', N'1099990266', 546)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4.5, 89, N'Nota 2', N'1099990266', 547)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4.5, 89, N'Definitiva', N'1099990266', 548)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.2, 89, N'Nota 1', N'1103122632', 549)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.8, 89, N'Nota 2', N'1103122632', 550)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.6, 89, N'Definitiva', N'1103122632', 551)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.5, 89, N'Nota 1', N'1005604170', 552)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.6, 89, N'Nota 2', N'1005604170', 553)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.6, 89, N'Definitiva', N'1005604170', 554)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4, 89, N'Nota 1', N'1102889653', 555)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4, 89, N'Nota 2', N'1102889653', 556)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4, 89, N'Definitiva', N'1102889653', 557)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.6, 89, N'Nota 1', N'1005710250', 558)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.7, 89, N'Nota 2', N'1005710250', 559)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.7, 89, N'Definitiva', N'1005710250', 560)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4.3, 89, N'Nota 1', N'1192777710', 561)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4.6, 89, N'Nota 2', N'1192777710', 562)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4.5, 89, N'Definitiva', N'1192777710', 563)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.4, 89, N'Nota 1', N'99092118319', 564)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.4, 89, N'Nota 2', N'99092118319', 565)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.4, 89, N'Definitiva', N'99092118319', 566)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4.5, 89, N'Nota 1', N'1102887099', 567)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.6, 89, N'Nota 2', N'1102887099', 568)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4, 89, N'Definitiva', N'1102887099', 569)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.4, 89, N'Nota 1', N'1102883023', 570)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.4, 89, N'Nota 2', N'1102883023', 571)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.4, 89, N'Definitiva', N'1102883023', 572)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4, 89, N'Nota 1', N'1007506188', 573)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4, 89, N'Nota 2', N'1007506188', 574)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4, 89, N'Definitiva', N'1007506188', 575)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4.3, 89, N'Nota 1', N'1102878133', 576)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Nota 2', N'1102878133', 577)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.5, 89, N'Definitiva', N'1102878133', 578)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.3, 89, N'Nota 1', N'99111112963', 579)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.3, 89, N'Nota 2', N'99111112963', 580)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.3, 89, N'Definitiva', N'99111112963', 581)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (2.9, 89, N'Nota 1', N'1102884791', 582)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.8, 89, N'Nota 2', N'1102884791', 583)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.4, 89, N'Definitiva', N'1102884791', 584)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.3, 89, N'Nota 1', N'1005575608', 585)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Nota 2', N'1005575608', 586)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.1, 89, N'Definitiva', N'1005575608', 587)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.1, 89, N'Nota 1', N'1007649619', 588)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.7, 89, N'Nota 2', N'1007649619', 589)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.5, 89, N'Definitiva', N'1007649619', 590)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.3, 89, N'Nota 1', N'1196970069', 591)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (2.7, 89, N'Nota 2', N'1196970069', 592)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (2.9, 89, N'Definitiva', N'1196970069', 593)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4, 89, N'Nota 1', N'1108766013', 594)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.8, 89, N'Nota 2', N'1108766013', 595)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.9, 89, N'Definitiva', N'1108766013', 596)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.5, 89, N'Nota 1', N'1007669575', 597)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4.1, 89, N'Nota 2', N'1007669575', 598)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.9, 89, N'Definitiva', N'1007669575', 599)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4.6, 89, N'Nota 1', N'1001673107', 600)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4.5, 89, N'Nota 2', N'1001673107', 601)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4.5, 89, N'Definitiva', N'1001673107', 602)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4.2, 89, N'Nota 1', N'1192781238', 603)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4.5, 89, N'Nota 2', N'1192781238', 604)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4.4, 89, N'Definitiva', N'1192781238', 605)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4.1, 89, N'Nota 1', N'1102880260', 606)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4, 89, N'Nota 2', N'1102880260', 607)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4, 89, N'Definitiva', N'1102880260', 608)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.5, 89, N'Nota 1', N'1193535666', 609)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4, 89, N'Nota 2', N'1193535666', 610)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.8, 89, N'Definitiva', N'1193535666', 611)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.2, 89, N'Nota 1', N'1005525624', 612)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.8, 89, N'Nota 2', N'1005525624', 613)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.6, 89, N'Definitiva', N'1005525624', 614)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.5, 89, N'Nota 1', N'1102880139', 615)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.5, 89, N'Nota 2', N'1102880139', 616)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.5, 89, N'Definitiva', N'1102880139', 617)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.3, 89, N'Nota 1', N'1005575802', 618)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4, 89, N'Nota 2', N'1005575802', 619)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.7, 89, N'Definitiva', N'1005575802', 620)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (2.7, 89, N'Nota 1', N'99102805344', 621)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.3, 89, N'Nota 2', N'99102805344', 622)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.1, 89, N'Definitiva', N'99102805344', 623)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.4, 89, N'Nota 1', N'1066187653', 624)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.8, 89, N'Nota 2', N'1066187653', 625)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.6, 89, N'Definitiva', N'1066187653', 626)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4.6, 89, N'Nota 1', N'1103122228', 627)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4.8, 89, N'Nota 2', N'1103122228', 628)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4.7, 89, N'Definitiva', N'1103122228', 629)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (2.5, 89, N'Nota 1', N'1102871651', 630)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (4, 89, N'Nota 2', N'1102871651', 631)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.4, 89, N'Definitiva', N'1102871651', 632)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.8, 89, N'Nota 1', N'1005571343', 633)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Nota 2', N'1005571343', 634)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.3, 89, N'Definitiva', N'1005571343', 635)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Nota 1', N'98092271323', 636)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Nota 2', N'98092271323', 637)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3, 89, N'Definitiva', N'98092271323', 638)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.2, 89, N'Nota 1', N'1102884780', 639)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.4, 89, N'Nota 2', N'1102884780', 640)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.3, 89, N'Definitiva', N'1102884780', 641)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (0, 89, N'Nota 1', N'1102881262', 642)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (0, 89, N'Nota 2', N'1102881262', 643)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (0, 89, N'Definitiva', N'1102881262', 644)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.9, 89, N'Nota 1', N'1005525376', 645)
GO
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.8, 89, N'Nota 2', N'1005525376', 646)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.8, 89, N'Definitiva', N'1005525376', 647)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (2.5, 89, N'Nota 1', N'1002302718', 648)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.8, 89, N'Nota 2', N'1002302718', 649)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.3, 89, N'Definitiva', N'1002302718', 650)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (2.5, 89, N'Nota 1', N'1102874616', 651)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.7, 89, N'Nota 2', N'1102874616', 652)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (3.2, 89, N'Definitiva', N'1102874616', 653)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (0, 89, N'Nota 1', N'99110813291', 654)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (0, 89, N'Nota 2', N'99110813291', 655)
INSERT [dbo].[Notas] ([valor], [id_calificaciones_periodo], [tipo], [id_estudiante], [id]) VALUES (0, 89, N'Definitiva', N'99110813291', 656)
SET IDENTITY_INSERT [dbo].[Notas] OFF
SET IDENTITY_INSERT [dbo].[pregunta_test_responder] ON 

INSERT [dbo].[pregunta_test_responder] ([id_test], [id_pregunta_test], [id]) VALUES (1004, 1025, 1022)
INSERT [dbo].[pregunta_test_responder] ([id_test], [id_pregunta_test], [id]) VALUES (1004, 1026, 1023)
INSERT [dbo].[pregunta_test_responder] ([id_test], [id_pregunta_test], [id]) VALUES (1004, 1027, 1024)
INSERT [dbo].[pregunta_test_responder] ([id_test], [id_pregunta_test], [id]) VALUES (1004, 1028, 1025)
INSERT [dbo].[pregunta_test_responder] ([id_test], [id_pregunta_test], [id]) VALUES (1005, 1024, 1026)
INSERT [dbo].[pregunta_test_responder] ([id_test], [id_pregunta_test], [id]) VALUES (1005, 1025, 1027)
INSERT [dbo].[pregunta_test_responder] ([id_test], [id_pregunta_test], [id]) VALUES (1005, 1027, 1028)
INSERT [dbo].[pregunta_test_responder] ([id_test], [id_pregunta_test], [id]) VALUES (1005, 1026, 1029)
INSERT [dbo].[pregunta_test_responder] ([id_test], [id_pregunta_test], [id]) VALUES (1006, 1024, 1038)
INSERT [dbo].[pregunta_test_responder] ([id_test], [id_pregunta_test], [id]) VALUES (1006, 1025, 1039)
INSERT [dbo].[pregunta_test_responder] ([id_test], [id_pregunta_test], [id]) VALUES (1006, 1026, 1040)
INSERT [dbo].[pregunta_test_responder] ([id_test], [id_pregunta_test], [id]) VALUES (1006, 1028, 1041)
INSERT [dbo].[pregunta_test_responder] ([id_test], [id_pregunta_test], [id]) VALUES (1007, 1024, 1047)
INSERT [dbo].[pregunta_test_responder] ([id_test], [id_pregunta_test], [id]) VALUES (1007, 1025, 1048)
INSERT [dbo].[pregunta_test_responder] ([id_test], [id_pregunta_test], [id]) VALUES (1007, 1026, 1049)
INSERT [dbo].[pregunta_test_responder] ([id_test], [id_pregunta_test], [id]) VALUES (1007, 1027, 1050)
INSERT [dbo].[pregunta_test_responder] ([id_test], [id_pregunta_test], [id]) VALUES (1007, 1028, 1051)
SET IDENTITY_INSERT [dbo].[pregunta_test_responder] OFF
SET IDENTITY_INSERT [dbo].[preguntas_test] ON 

INSERT [dbo].[preguntas_test] ([id], [Pregunata], [eliminado], [tipo]) VALUES (1024, N'¿En mi trabajo puedo hacer lo que mejor hago todos los días. ?', 0, N'Cerrada')
INSERT [dbo].[preguntas_test] ([id], [Pregunata], [eliminado], [tipo]) VALUES (1025, N'¿En los últimos siete días he recibido reconocimiento o elogios por hacer un buen trabajo?', 0, N'Cerrada')
INSERT [dbo].[preguntas_test] ([id], [Pregunata], [eliminado], [tipo]) VALUES (1026, N'¿Alguien en el trabajo estimula mi desarrollo??', 0, N'Abierta')
INSERT [dbo].[preguntas_test] ([id], [Pregunata], [eliminado], [tipo]) VALUES (1027, N'¿La misión o propósito de mi compañía me hacen sentir que mi trabajo es importante?', 0, N'Cerrada')
INSERT [dbo].[preguntas_test] ([id], [Pregunata], [eliminado], [tipo]) VALUES (1028, N'¿Mis compañeros de trabajos están comprometidos a hacer un trabajo de calidad?', 0, N'Abierta')
SET IDENTITY_INSERT [dbo].[preguntas_test] OFF
INSERT [dbo].[respuestas] ([id_preguntas_test_respustas], [id_persona], [punto], [observacion], [id_curso]) VALUES (1026, N'1000248961', 2, NULL, 62)
INSERT [dbo].[respuestas] ([id_preguntas_test_respustas], [id_persona], [punto], [observacion], [id_curso]) VALUES (1026, N'1005575218', 6, NULL, 75)
INSERT [dbo].[respuestas] ([id_preguntas_test_respustas], [id_persona], [punto], [observacion], [id_curso]) VALUES (1026, N'1005575218', 3, NULL, 84)
INSERT [dbo].[respuestas] ([id_preguntas_test_respustas], [id_persona], [punto], [observacion], [id_curso]) VALUES (1027, N'1000248961', 1, NULL, 62)
INSERT [dbo].[respuestas] ([id_preguntas_test_respustas], [id_persona], [punto], [observacion], [id_curso]) VALUES (1027, N'1005575218', 7, NULL, 75)
INSERT [dbo].[respuestas] ([id_preguntas_test_respustas], [id_persona], [punto], [observacion], [id_curso]) VALUES (1027, N'1005575218', 6, NULL, 84)
INSERT [dbo].[respuestas] ([id_preguntas_test_respustas], [id_persona], [punto], [observacion], [id_curso]) VALUES (1028, N'1000248961', 2, NULL, 62)
INSERT [dbo].[respuestas] ([id_preguntas_test_respustas], [id_persona], [punto], [observacion], [id_curso]) VALUES (1028, N'1005575218', 4, NULL, 75)
INSERT [dbo].[respuestas] ([id_preguntas_test_respustas], [id_persona], [punto], [observacion], [id_curso]) VALUES (1028, N'1005575218', 10, NULL, 84)
INSERT [dbo].[respuestas] ([id_preguntas_test_respustas], [id_persona], [punto], [observacion], [id_curso]) VALUES (1029, N'1000248961', 0, N'yytyt  tyty                                                                                                                                                                         ', 62)
INSERT [dbo].[respuestas] ([id_preguntas_test_respustas], [id_persona], [punto], [observacion], [id_curso]) VALUES (1029, N'1005575218', 0, N'9988                                                                                                                                                                                ', 75)
INSERT [dbo].[respuestas] ([id_preguntas_test_respustas], [id_persona], [punto], [observacion], [id_curso]) VALUES (1029, N'1005575218', 0, N'0009                                                                                                                                                                                ', 84)
INSERT [dbo].[respuestas] ([id_preguntas_test_respustas], [id_persona], [punto], [observacion], [id_curso]) VALUES (1047, N'1067902413', 6, NULL, 71)
INSERT [dbo].[respuestas] ([id_preguntas_test_respustas], [id_persona], [punto], [observacion], [id_curso]) VALUES (1048, N'1067902413', 10, NULL, 71)
INSERT [dbo].[respuestas] ([id_preguntas_test_respustas], [id_persona], [punto], [observacion], [id_curso]) VALUES (1049, N'1067902413', 0, N'esto es una prueba de test              dfe lo que se puede hacer con una prueba de tes con caracteres
                                                                            ', 71)
INSERT [dbo].[respuestas] ([id_preguntas_test_respustas], [id_persona], [punto], [observacion], [id_curso]) VALUES (1050, N'1067902413', 5, NULL, 71)
INSERT [dbo].[respuestas] ([id_preguntas_test_respustas], [id_persona], [punto], [observacion], [id_curso]) VALUES (1051, N'1067902413', 0, N'esto es otra prueba
                                                                                                                                                               ', 71)
SET IDENTITY_INSERT [dbo].[Test] ON 

INSERT [dbo].[Test] ([id], [fecha_fin], [fecha_inicio], [ferfil_usuario], [eliminado], [estado_cierre], [id_usuario_creado], [periodo]) VALUES (1004, CAST(0x0F3E0B00 AS Date), CAST(0x013E0B00 AS Date), N'Estudiante', 0, 1, N'1007621090', N'2018-1')
INSERT [dbo].[Test] ([id], [fecha_fin], [fecha_inicio], [ferfil_usuario], [eliminado], [estado_cierre], [id_usuario_creado], [periodo]) VALUES (1005, CAST(0x4C3E0B00 AS Date), CAST(0x383E0B00 AS Date), N'Docente', 0, 0, N'1005575218', N'2017-2')
INSERT [dbo].[Test] ([id], [fecha_fin], [fecha_inicio], [ferfil_usuario], [eliminado], [estado_cierre], [id_usuario_creado], [periodo]) VALUES (1006, CAST(0x323E0B00 AS Date), CAST(0x2C3E0B00 AS Date), N'Estudiante', 0, 1, N'1005575218', N'2017-2')
INSERT [dbo].[Test] ([id], [fecha_fin], [fecha_inicio], [ferfil_usuario], [eliminado], [estado_cierre], [id_usuario_creado], [periodo]) VALUES (1007, CAST(0x4D3E0B00 AS Date), CAST(0x303E0B00 AS Date), N'Docente', 0, 0, N'1005575218', N'2017-2')
SET IDENTITY_INSERT [dbo].[Test] OFF
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1005575218', N'OSNAIDER ', N'DIAZ BAQUERO', N'OSNAIDER.DIAZ@CECAR.EDU.CO', N'123', N'Administrador', N'QwBlAGMAYQByADEAMgAzAA==', CAST(0x2D3D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1005675603', N'DANIELA ROSA', N'PEREZ OSORIO', N'DANIELA.PEREZO@CECAR.EDU.CO', N'', N'Monitor', N'QwBlAGMAYQByADEAMgAzAA==', CAST(0xE93D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1007621090', N'MIRIAM ISABEL', N'PAZ ROJAS', N'MIRIAM.PAZ@CECAR.EDU.CO', N'3234655811', N'Administrador', N'QwBlAGMAYQByADEAMgAzAA==', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1051829595', N'MARIA ALEJANDRA', N'PAZ ROJAS', N'MARIA.PAZ@CECAR.EDU.CO', N'3024684209', N'Monitor', N'$2y$10$WCXtWRytTZ5XB0fZ2gB8feCyP3RQBQ/aqAaKkYW.fzPLD2Rqfr.My', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1052998935', N'FERNANDO ', N'MORALES BOTERO', N'FERNANDO.MORALESB@CECAR.EDU.CO', N'301694779', N'Monitor', N'$2y$10$rp1tcKjEbkmHREHGfoOwA.2c1C9B25Z1tXv3K7AGEObaReM8DmOJO', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1066185095', N'ANDRES FELIPE', N'TESILLO BULA', N'ANDRES.TESILLO@CECAR.EDU.CO', N'3013773515', N'Monitor', N'$2y$10$eFt2sEEv4JgUHwoUFNijX.JijF.oRKnmPfFhTzeujZ08QJ/kNIYCK', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1067902413', N'Ingrid', N'DIAZ BAQUERO', N'OSNAIDER.DIAZ@CECAR.EDU.CO', N'123', N'Administrador', N'QwBlAGMAYQByADEAMgAzAA==', CAST(0x2D3D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1096223217', N'CAMILO ANDRES', N'ALVIS BENAVIDEZ', N'CAMILO.ALVIS@CECAR.EDU.CO', N'3004503119', N'Monitor', N'$2y$10$rdltBF3RUERvI6KTFG4BHuVORSRrJbJXaeiMsbPFZWwu/lHvtwW9.', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'11', N'HHH', N'II', N'FREDYJRDENAS@GMAIL.COM', N'889', N'Monitor', N'QwBlAGMAYQByADEAMgAzAA==', CAST(0x2C3E0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1100628669', N'YORK FRED', N'SANTOS QUIROZ', N'YORK.SANTOS@CECAR.EDU.CO', N'3137821969', N'Monitor', N'$2y$10$AihSfSzwziiYrhsxRUQnVOcIPBZO44z6ZyHFnRkx2uEEwgwmOG0Zq', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1102232026', N'OSNAIDER ', N'DIAZ BAQUERO', N'OSNAIDER.DIAZ@CECAR.EDU.CO', N'123', N'Monitor', N'QwBlAGMAYQByADEAMgAzAA==', CAST(0x2D3D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1102232208', N'YULEIDYS PAOLA', N'ZUÑIGA QUIROZ', N'YULEIDYS.ZUNIGA@CECAR.EDU.CO', N'3164718915', N'Monitor', N'$2y$10$S0s8mx4USpxISbmD/RfdHO7p.v/0XZZHg9vuDDJmyv9ky3h3UM81G', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1102581878', N'LORENA', N'REQUENA MARTINEZ', N'LORENA.REQUENA@CECAR.EDU.CO', N'3008505921', N'Monitor', N'$2y$10$eFt2sEEv4JgUHwoUFNijX.JijF.oRKnmPfFhTzeujZ08QJ/kNIYCK', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1102836723', N'GEOVANNY', N'SALAZAR DE LA ESPRIELLA', N'GEOVANNY.SALAZAR@CECAR.EDU.CO', N'3012334171', N'Monitor', N'$2y$10$VAouOdljDE87D5cCKENhFeyu72NtxdaxJOnWkxyBtc/PYpf1hGoK2', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1102859256', N'DANOVIS ', N'MORA TORRES', N'DANOVIS.MORA@CECAR.EDU.CO', N'3216070824', N'Monitor', N'QwBlAGMAYQByADEAMgAzAA==', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1102861529', N'ANDRES', N'IDARRAGA NAVARRO', N'ANDRES.IDARRAGA@CECAR.EDU.CO', N'3052281540', N'Monitor', N'$2y$10$eFt2sEEv4JgUHwoUFNijX.JijF.oRKnmPfFhTzeujZ08QJ/kNIYCK', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1102869404', N'ANDRES ANTONIO', N'ALVAREZ ALIAN', N'ANDRES.ALVAREZAL@CECAR.EDU.CO', N'3042106466', N'Monitor', N'$2y$10$6rLp7rFvIkolLOhsd3svYeAveqURLGUltdRK25cGkoSuYZ.PXnvNy', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1102873967', N'SARANYELA', N'ALTAMIRANDA ARREGOCES', N'SARANYELA.ALTAMIRANDA@CECAR.EDU.CO', N'3017997120', N'Monitor', N'$2y$10$z9.d5UwZSbQ/pGq/Cz0GFu5v3iO0RmslFWQCMoapUT458YVBDinP2', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'110287397', N'SARANYELA', N'ALTAMIRANDA ARREGOCES', N'SARANYELA.ALTAMIRANDA@CECAR.EDU.CO', N'3017997120', N'Monitor', N'$2y$10$dY9fNZ1jwKp.bmf43n4xI.6KAkt1IDXh8ovTLVjG1ixxO7ebBmLF.', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1102875307', N'MAURICIO JAVIER', N'FONTALVO IBARRA', N'MAURICIO.FONTALVO@CECAR.EDU.CO', N'3117270754', N'Monitor', N'$2y$10$YFjGTCH.OIJ2xwTBk6hQA.QNTTC4a4.pbCilSkJQ0zl9.WyMCCNKG', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1102875394', N'MARIA MARGARITA', N'CONTRERAS CEBALLOS', N'MARIA.CONTRERASCE@CECAR.EDU.CO', N'', N'Monitor', N'$2y$10$kULa5h/7wqJlrvr6YPPGVefO24PjmD7NIHrUkopP/NcI7H/qpAY4e', CAST(0xE93D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1102876420', N'DANIELA', N'LYONS BARCENAS', N'DANIELA.LYONS@CECAR.EDU.CO', N'3014706862', N'Monitor', N'$2y$10$SHuh.lwdHueCdPdHDq0cBOf2zoJOkeuguM3Q8ldMXArnuQT9pbn.u', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1102877863', N'ALVARO JAVIER', N'DIAZ OVIEDO', N'ALVARO.DIAZ@CECAR.EDU.CO', N'3226145206', N'Monitor', N'$2y$10$38WLKSzySNgWYDH0kZXYA.CAicuNjU5AY/MDGCqd9t4c5VI8YNC..', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1102878159', N'FRANCESCA LUCIA', N'MARTINEZ BUELVAS', N'FRANCESCA.MARTINEZ@CECAR.EDU.CO', N'', N'Monitor', N'$2y$10$C6cuYpF3qWpvGMsoDVhFW.iTLJbqVx7TTLTrdX1gvneJAS/iykudy', CAST(0xE93D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1102878423', N'MARIA LAURA', N'VERGARA ALVAREZ', N'MARIA.VERGARAA@CECAR.EDU.CO', N'3128495872', N'Monitor', N'$2y$10$cuSLSt21MlzpH5XPcKK8Buf2ue1wGRISMlfRw4LcSa1MQiA57ZiW6', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1102878542', N'ALVARO JOSE', N'BENITEZ MENDOZA', N'ALVARO.BENITEZ@CECAR.EDU.CO', N'3007946473', N'Monitor', N'$2y$10$EaHAIRXeE/SMcCTQt2FjLe40caAfBRRHImtw.G6pwftoQgibcOBqS', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1102880103', N'ANDRES FELIPE', N'TAMARA MONTES', N'ANDRES.TAMARA@CECAR.EDU.CO', N'3007456189', N'Monitor', N'$2y$10$uGCDxJzy7VsapjZ3NYO7duPs51mVenmyJSgsENQSZsZVkKJ5vaq6O', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1102880538', N'HELEN ', N'MONTES DAGOBETH', N'HELEN.MONTES@CECAR.EDU.CO', N'3045950842', N'Monitor', N'$2y$10$S7RT1GAEaosc.vEqhuZgvuZX8WDGvBzQYQcHjnWIEev8xITXjmZxC', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1102881228', N'ANDRES', N'VELEZ CORRALES', N'ANDRES.VELEZC@CECAR.EDU.CO', N'3016100276', N'Monitor', N'$2y$10$KuzVeTHjzj8LW5CMZXMgI.hUISvF8AETdlqOt6gS8gtaFJHb.IucS', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1102883800', N'CRISTIAN DAVID', N'ALVAREZ YEPEZ', N'CRISTIAN.ALVAREZY@CECAR.EDU.CO', N'3015113916', N'Monitor', N'$2y$10$KIK0isnGPzyDojAvaKzcHuqXCFnyDZ2G7jqZvIFXv4N/RYPVaPo8W', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1102884746', N'ANDREA CAROLINA', N'RODRIGUEZ ALVAREZ', N'ANDREA.RODRIGUEZ@CECAR.EDU.CO', N'3043770205', N'Monitor', N'$2y$10$eFt2sEEv4JgUHwoUFNijX.JijF.oRKnmPfFhTzeujZ08QJ/kNIYCK', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1102887140', N'MARTHA', N'UPARELA JARAVA', N'MARTHA.UPARELA@CECAR.EDU.CO', N'3205142765', N'Monitor', N'$2y$10$0QNKQqgqOc01JxS4DC5R6.cfeNTvcU8deBg0Dlbmeedvr3nMBWubC', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1103115711', N'YOJAN SEBASTIAN', N'MARTINEZ ARRIETA', N'YOJAN.MARTINEZ@CECAR.EDU.CO', N'', N'Monitor', N'$2y$10$rVS0cvYrEUBz9QDg8ywD4e4DE2GhLfudVYCv7wh.Qr5ngV5CUTZhy', CAST(0xE93D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1103118992', N'FABIO ANDRES', N'LOPEZ PEREZ', N'FABIO.LOPEZ@CECCAR.EDU.CO', N'3002805283', N'Monitor', N'$2y$10$/GR3Z.NkR4FdYW2OT275hOI2EfdAY3R.FJny4heJasCcFJeA3qR8q', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1103119937', N'ANDREA CAROLINA', N'BENITEZ ARROYO', N'ANDREA.BENITEZA@CECAR.EDU.CO', N'3147945581', N'Administrador', N'$2y$10$LkW3Q0UDlaWhkxFvqexIpeTkzi5kBa/TWxDJmPcurLcyHT0csyMz.', CAST(0x5E3D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1103120601', N'JESUS DAVID', N'ALDANA MARTINEZ', N'JESUS.ALDANA@CECAR.EDU.CO', N'3009291910', N'Monitor', N'$2y$10$0lLy2kDksB4wQ1eceyQO3uuBOVkjJ41m/nySiKYRB4sabqVYqUy5e', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1104015178', N'LAURA VANESSA', N'ROMERO FLOREZ', N'LAURA.ROMEROF@CECAR.EDU.CO', N'3017351377', N'Monitor', N'$2y$10$rFc5z9gSdSKgLlaSYIX4fevfKRW8vpwpsQuCFlCbZochEgJeCCFF2', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1131110675', N'OLGA LUCY', N'OLASCOAGA FURNIELES', N'OLGA.OLASCOAGA@CECAR.EDU.CO', N'3012335712', N'Monitor', N'$2y$10$Qtb7OjUtc1gBm0mqHMpskOsgkXmFtQa4pw3VLEW/9./iqHr3EE8A.', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'1140845621', N'ROY ANIBAL', N'D''LUYS GAZABON', N'ROY.DLUYS@CECAR.EDU.CO', N'3004999018', N'Monitor', N'$2y$10$WUNlB6FZ53CfBP1TLS1TYOPMwpqivoXcbZb/krNQdl6MzfTgRcTwK', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'123', N'SPORTE', N'SPORTE', N'SOPORTE@CECAR.EDU.CO', N'0000', N'Administrador', N'$2y$10$IHNy3f1TtUGaLerSO8NDsuTk/VWhrKi0yvXTDjmdg9vrQG3m/SSkK', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'34941432', N'CLARA IBETH', N'ALVAREZ ARRIETA', N'CLARA.ALVAREZ@CECAR.EDU.CO', N'3163288990', N'Administrador', N'$2y$10$DM3..SOVPsY444q1dBAVH.QDZPbXVNTI6OsPsrzChtEelVFqEczam', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'3836667', N'FABER FRANCISCO', N'MARIO MERLANO', N'FABER.MARIO@CECAR.EDU.CO', N'3014168454', N'Administrador', N'$2y$10$qk4MzgtJYNgUhwXvpzTAKeVz1CspwUjJJ2QRWChthNZKyd1ysXhay', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'64698094', N'BESSY KARINA', N'FLOREZ ACOSTA', N'BESSY.FLOREZ@CECAR.EDU.CO', N'3114315233', N'Administrador', N'$2y$10$DYz0vUZGz.q0cT5LfhF01eOUBSKMuHbjcZAe/yX39QNupZYVi0THO', CAST(0xEF3C0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'64919147', N'LIA MARGARITA ', N'JARABA ORTIZ', N'LIA.JARABA@CECAR.EDU.CO', N'3015017145', N'Administrador', N'$2y$10$PPubQhxkr4Bcvwv1TKpfFOyXFmx0eNGlzo2IG.OZJOPWEZwOnpf1a', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'92256496', N'JORGE ELIECER', N'MARTINEZ GARCIA', N'JORGE.EMARTINEZG@CECAR.EDU.CO', N'3004108654', N'Administrador', N'$2y$10$WeJbXPsWm4M3xrd0i8qtFexmEtQfRctkhJEfvDzFXJ0.GQfm2bdO6', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'98083171146', N'JOSE MANUEL', N'ROJAS MARTINEZ', N'JOSE.ROJAS@CECAR.EDU.CO', N'3145590990', N'Monitor', N'$2y$10$p0t0rxR1Z9CUpdm6zD/HoueVN5IoTiB6N6GoQvPEYJ6qjKrTYtTOy', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'98101513629', N'GERMAN', N'TAMARA NUÑEZ', N'GERMAN.TAMARA@CECAR.EDU.CO', N'3013827506', N'Monitor', N'$2y$10$NIP/5.UBX27OjuiJeTT4Ae0tk3aBOJVLw43fUsAqOKTTS7cFYDqD.', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'98103070783', N'ALAVARO JOSE', N'SIERRA GAMARRA', N'ALVARO.SIERRA@CECAR.EDU.CO', N'3225128784', N'Monitor', N'$2y$10$.LaE5niPy7fJAG2G43GVh.7zH/zHoiMRXBYWIJWnZ1boDhv3Ley0K', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'99100611143', N'ESTEBAN GABRIEL', N'RESTREPO ANGULO', N'ESTEBAN.RESTREPO@CECAR.EDU.CO', N'3125080626', N'Monitor', N'$2y$10$7zeZZOSizoMHeFDVoNdUZOinEpZUsofE9Pnu6WyuLsDeAJS0Efo4C', CAST(0x193D0B00 AS Date), 0)
INSERT [dbo].[usuarios] ([id], [nombre], [apellidos], [correo], [celular], [tipo], [contrasena], [fecha_registro], [eliminado]) VALUES (N'99112906300', N'ALDAIR JOSE', N'VILLALBA SANABRIA', N'ALDAIR.VILLALBA@CECAR.EDU.CO', N'3043345969', N'Monitor', N'$2y$10$eFt2sEEv4JgUHwoUFNijX.JijF.oRKnmPfFhTzeujZ08QJ/kNIYCK', CAST(0x193D0B00 AS Date), 0)
ALTER TABLE [dbo].[capacitaciones] ADD  DEFAULT (NULL) FOR [comentarios]
GO
ALTER TABLE [dbo].[clases_sima] ADD  DEFAULT (NULL) FOR [comentario]
GO
ALTER TABLE [dbo].[configuracion_app] ADD  DEFAULT ('Cecar123') FOR [contrasena_defecto_usuario]
GO
ALTER TABLE [dbo].[usuarios] ADD  DEFAULT (NULL) FOR [celular]
GO
ALTER TABLE [dbo].[usuarios] ADD  DEFAULT (NULL) FOR [tipo]
GO
ALTER TABLE [dbo].[calificaciones_periodo]  WITH CHECK ADD  CONSTRAINT [FK_calificaciones_periodo_materias] FOREIGN KEY([asignatura])
REFERENCES [dbo].[materias] ([nombre])
GO
ALTER TABLE [dbo].[calificaciones_periodo] CHECK CONSTRAINT [FK_calificaciones_periodo_materias]
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
ALTER TABLE [dbo].[Notas]  WITH CHECK ADD  CONSTRAINT [FK_Notas_calificaciones_periodo] FOREIGN KEY([id_calificaciones_periodo])
REFERENCES [dbo].[calificaciones_periodo] ([id])
GO
ALTER TABLE [dbo].[Notas] CHECK CONSTRAINT [FK_Notas_calificaciones_periodo]
GO
ALTER TABLE [dbo].[pregunta_test_responder]  WITH CHECK ADD  CONSTRAINT [FK_pregunta_test_responder_preguntas_test] FOREIGN KEY([id_pregunta_test])
REFERENCES [dbo].[preguntas_test] ([id])
GO
ALTER TABLE [dbo].[pregunta_test_responder] CHECK CONSTRAINT [FK_pregunta_test_responder_preguntas_test]
GO
ALTER TABLE [dbo].[pregunta_test_responder]  WITH CHECK ADD  CONSTRAINT [FK_pregunta_test_responder_Test] FOREIGN KEY([id_test])
REFERENCES [dbo].[Test] ([id])
GO
ALTER TABLE [dbo].[pregunta_test_responder] CHECK CONSTRAINT [FK_pregunta_test_responder_Test]
GO
ALTER TABLE [dbo].[respuestas]  WITH CHECK ADD  CONSTRAINT [FK_respuestas_cursos1] FOREIGN KEY([id_curso])
REFERENCES [dbo].[cursos] ([id])
GO
ALTER TABLE [dbo].[respuestas] CHECK CONSTRAINT [FK_respuestas_cursos1]
GO
ALTER TABLE [dbo].[respuestas]  WITH CHECK ADD  CONSTRAINT [FK_respuestas_pregunta_test_responder] FOREIGN KEY([id_preguntas_test_respustas])
REFERENCES [dbo].[pregunta_test_responder] ([id])
GO
ALTER TABLE [dbo].[respuestas] CHECK CONSTRAINT [FK_respuestas_pregunta_test_responder]
GO
ALTER TABLE [dbo].[Test]  WITH CHECK ADD  CONSTRAINT [FK_Test_usuarios] FOREIGN KEY([id_usuario_creado])
REFERENCES [dbo].[usuarios] ([id])
GO
ALTER TABLE [dbo].[Test] CHECK CONSTRAINT [FK_Test_usuarios]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Alertas', @level2type=N'COLUMN',@level2name=N'mensaje'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Alertas', @level2type=N'COLUMN',@level2name=N'tipo_alerta'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Alertas', @level2type=N'COLUMN',@level2name=N'creador'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Alertas', @level2type=N'COLUMN',@level2name=N'perfil_ver'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Alertas', @level2type=N'COLUMN',@level2name=N'titulo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'calificaciones_periodo', @level2type=N'COLUMN',@level2name=N'fecha_registro'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'calificaciones_periodo', @level2type=N'COLUMN',@level2name=N'programa'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'calificaciones_periodo', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'configuracion_app', @level2type=N'COLUMN',@level2name=N'contrasena_defecto_usuario'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'configuracion_app', @level2type=N'COLUMN',@level2name=N'alertas'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'grupos_acargo', @level2type=N'COLUMN',@level2name=N'id_grupo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'grupos_acargo', @level2type=N'COLUMN',@level2name=N'programa'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Notas', @level2type=N'COLUMN',@level2name=N'valor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Notas', @level2type=N'COLUMN',@level2name=N'tipo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Notas', @level2type=N'COLUMN',@level2name=N'id_estudiante'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indica si la pregunata se responde con un un numero(cerrada) o con un texto(abierta)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'preguntas_test', @level2type=N'COLUMN',@level2name=N'tipo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'indica si el tipo de pregunta es abierta o cerrada(1,2,3,4..)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'preguntas_test'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identificacion de quien responde la pregunta ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'respuestas', @level2type=N'COLUMN',@level2name=N'id_persona'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Para cuanodo la pregunta es cerrada es decir cuano se responde con un numero' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'respuestas', @level2type=N'COLUMN',@level2name=N'punto'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Este campo se llena cuano el tipo de pregunta es abierto' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'respuestas', @level2type=N'COLUMN',@level2name=N'observacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'respuestas', @level2type=N'COLUMN',@level2name=N'id_curso'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Test', @level2type=N'COLUMN',@level2name=N'fecha_fin'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Test', @level2type=N'COLUMN',@level2name=N'fecha_inicio'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'que tipo de usuario respondera el test. docente o estudiante' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Test', @level2type=N'COLUMN',@level2name=N'ferfil_usuario'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indica si el test esta cerrado o esta abiertoto' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Test', @level2type=N'COLUMN',@level2name=N'estado_cierre'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Test', @level2type=N'COLUMN',@level2name=N'periodo'
GO

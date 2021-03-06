USE [bd_sima]
GO
/****** Object:  StoredProcedure [dbo].[ProcedimientoPrueba]    Script Date: 20/04/2018 12:25:34 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ProcedimientoPrueba] 	
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

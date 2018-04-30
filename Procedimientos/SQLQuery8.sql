-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		fredys
-- Create date: 20/04/2018
-- Description:	consulta las asistencias de los estudinates en una asignatura en un periodo
-- =============================================
CREATE PROCEDURE [dbo].[PS_ConsultarAsistencia] 	
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


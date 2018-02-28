using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using WebSima.Models;
using WebSima.Models.WebApi;

namespace WebSima.clases
{
    public class Excel_informe
    {
        /// <summary>
        /// Crear el excel de las asistencia de los estudiantes a monitoria de una materia en un periodo
        /// </summary>
        /// <returns></returns>
        public DataTable getExceAsistenciaMonitoria()
        {
            Sesion session = new Sesion();
            String materia= session.getMateriaReporteAsistencia();
            String periodo = session.getperiodoReporteAsistencia(); ;
            List<String> idEstudiantes = new List<string>();
            List<EstudianteMateria> datos_2 = new List<EstudianteMateria>();
            MInforme info = new MInforme();
            List<String[]> datos = info.consultarAsistencia(materia);
            if (datos.Count() > 0)
            {
                // seleccionamaos todas las id de los estudiantes 
                idEstudiantes = datos.Select(m => m[1]).ToList();
                datos_2 = ConsumidorAppi.getDatosEstudiantesMateria(periodo, materia, idEstudiantes);
            }
            // se  crea la cabecera
            DataTable dt = new DataTable("reporte_asistencia_sima");
            dt.Columns.AddRange(
                new DataColumn[4] {
                        new DataColumn("Identificación"),                                            
                        new DataColumn("Nombre"),
                        new DataColumn("Programa"),
                        new DataColumn("Asistencias")
                });
         //  cargamos los datos
            foreach (var dato in datos)
            {
            var estudiante = datos_2.Where(e => e.num_identificacion.Equals(dato[1])).Select(e => new { e.nom_largo, e.nom_prog_matricula_estudiante }).Distinct().ToArray();

                if(estudiante.Count()>0)
                 dt.Rows.Add(dato[1], estudiante[0].nom_largo, estudiante[0].nom_prog_matricula_estudiante, dato[0]);
                else
                    dt.Rows.Add(dato[1], "No identificado", "No identificado", dato[0]);

                
            }
            return dt;
        }
    }
}
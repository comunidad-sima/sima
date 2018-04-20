using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
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
            List<ComportamientoNotaEstudiente> datos_2 = new List<ComportamientoNotaEstudiente>();
            MInforme info = new MInforme();
            List<String[]> datos = info.ProcedimientoPrueba(materia, periodo);
            if (datos.Count() > 0)
            {
                // seleccionamaos todas las id de los estudiantes 
                idEstudiantes = datos.Select(m => m[1]).ToList();
                datos_2 = ConsumidorAppi.getNotaEstudianteMateria(periodo, materia, idEstudiantes);
            }
            // se  crea la cabecera
            DataTable dt = new DataTable("reporte_asistencia_sima");
            dt.Columns.AddRange(
                new DataColumn[7] {
                        new DataColumn("Identificación"),                                            
                        new DataColumn("Nombre"),
                        new DataColumn("Programa"),
                         new DataColumn("Nota 1"),
                          new DataColumn("Nota 2"),
                           new DataColumn("Definitiva"),
                        new DataColumn("Asistencias")
                });
            NumberFormatInfo provider = new NumberFormatInfo();
         //  cargamos los datos
            foreach (var dato in datos)
            {
               var estudiante=(from e in datos_2 where (e.num_identificacion.Equals(dato[1])) select (e)).ToList();

               if (estudiante.Count() > 0)
               {
                   // es nota no se toma como nota principal porque
                   String nota1Redondeada = Double.Parse(estudiante[0].nota, provider).ToString("#.##");
                   String nota2Redondeada = Double.Parse(estudiante[1].nota, provider).ToString("#.##");
                   provider.NumberDecimalSeparator = ".";
                   double nota1Porcentaje = Double.Parse(estudiante[0].nota, provider) * (0.4);
                   double nota2Porcentaje = Double.Parse(estudiante[1].nota, provider) * (0.6);
                   double notaFin = nota1Porcentaje + nota2Porcentaje;
                   


                   double nota1 = Double.Parse(estudiante[0].nota, provider);//)
                   dt.Rows.Add(dato[1],
                       estudiante[0].nom_largo,
                       estudiante[0].nom_prog_matricula_estudiante, 
                       nota1Redondeada,
                       nota2Redondeada,
                      Math.Round(notaFin, 1),
                       dato[0]);
               }
               else
                   dt.Rows.Add(dato[1], "No identificado", "No identificado", "0", "0", "0", dato[0]);

                
            }
            return dt;
        }
    }
}
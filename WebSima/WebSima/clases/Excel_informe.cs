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
            string materia = session.getMateriaReporteAsistencia();
            string periodo = session.getperiodoReporteAsistencia();
            string programa = session.getProgramaReporteAsistencia();

            List<ComportamientoNotaEstudiente> datos_2 = new List<ComportamientoNotaEstudiente>();
            MInforme info = new MInforme();
            List<String[]> asistencia = info.consultarAsistencia(materia, periodo);


            datos_2 = ConsumidorAppi.getNotaEstudianteMateriaAll(periodo, materia);
            if (datos_2 != null)
            {

                // se filtra por el programa
                if (!programa.Equals("Todos"))
                {
                    datos_2 = (from d in datos_2 where (d.nom_prog_matricula_estudiante.Equals(programa)) select d).ToList();
                }
            }

            // se  crea la cabecera
            DataTable dt = new DataTable("reporte_asistencia_sima");
            dt.Columns.AddRange(
                new DataColumn[8] {
                        new DataColumn("Identificación"),                                            
                        new DataColumn("Nombre"),
                        new DataColumn("Programa"),
                        new DataColumn("Nota corte 1"),
                        new DataColumn("Nota corte 2"),
                        new DataColumn("Definitiva"),
                        new DataColumn("Asistencias a monitoria"),
                          new DataColumn("Inasistencias a clase")

                });
            NumberFormatInfo provider = new NumberFormatInfo();
            //  cargamos los datos

            if (datos_2 != null)
            {

                List<string> ides = (from e in datos_2 select (e.num_identificacion)).Distinct().ToList();
               // List<string> id_asistencia = (from a in asistencia select (a[1])).ToList();
               // ides = ides.Union(id_asistencia).ToList();
                string canti_asistencia;
                foreach (var id in ides)
                {
                    string string_nota1 = "0";
                    string string_nota2 = "0";
                    canti_asistencia = "0";
                    string nombre;
                    string programa_unidad;
                    string nota1Redondeada;
                    string nota2Redondeada;
                    string notaFin_;
                    string fallas_clase="0";
                    var estudiante = (from e in datos_2 where (e.num_identificacion.Equals(id)) select (e)).ToList();
                    var tem = (from a in asistencia where (a[1].Equals(id)) select (a[0])).ToList();
                    if (tem.Count() > 0)
                    {
                        ///asistencia a monitorias
                        canti_asistencia = tem.First();
                    }
                    if (estudiante.Count() > 0)
                    {
                        string_nota1 = (from n in estudiante where (n.num_nota.Equals("1")) select (n.nota)).First();
                        string_nota2 = (from n in estudiante where (n.num_nota.Equals("2")) select (n.nota)).First();
                        nombre = estudiante[0].nom_largo;
                        programa_unidad = estudiante[0].nom_unidad;
                        if (string_nota2.Equals("0") || string_nota2.Equals("0.0"))
                        {
                            nota1Redondeada = "0,0";
                        }
                        else
                        {
                            nota1Redondeada = (Double.Parse(string_nota1, provider).ToString("#.##"));
                        }
                        if (string_nota2.Equals("0") || string_nota2.Equals("0.0"))
                        {
                            nota2Redondeada = "0,0";
                        }
                        else
                        {
                            nota2Redondeada = (Double.Parse(string_nota2, provider).ToString("#.##"));
                        }
                        provider.NumberDecimalSeparator = ".";
                        double nota1 = Double.Parse(string_nota1, provider) * (0.4);
                        double nota2 = Double.Parse(string_nota2, provider) * (0.6);
                        double notaFin = nota1 + nota2;
                        notaFin_ = "" + (Math.Round(notaFin, 1));
                        fallas_clase = estudiante[1].num_fallas;
                    }
                    else
                    {
                        nombre = "Nombre no identificado";
                        programa_unidad = "Programa no identificado";
                        nota1Redondeada = "0,0";
                        nota2Redondeada = "0,0";
                        notaFin_ = "0,0";
                        fallas_clase = "0";
                    }
                    dt.Rows.Add(id,
                            nombre,
                            programa_unidad,
                            nota1Redondeada,
                            nota2Redondeada,
                            notaFin_,
                            canti_asistencia,
                            fallas_clase
                            );
                }
            }
            return dt;
        }
    }
}
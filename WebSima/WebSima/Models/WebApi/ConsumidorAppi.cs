﻿using Newtonsoft.Json;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Web;

namespace WebSima.Models.WebApi
{
    /// <summary>
    /// Clase encargada de consultar los datos a CECAR
    /// </summary>
    public class ConsumidorAppi
    {
        private static string  url_base="https://webapi.cecar.edu.co/IntegracionOtrosPortales/";
        
        private static RestRequest preparaRestRequest()
        {                   
              var request = new RestRequest(Method.POST);
              request.AddHeader("cache-control", "no-cache");
              request.AddHeader("content-type", "application/x-www-form-urlencoded");
              request.AddHeader("accesstoken", "IWzG2B3Tq9wj+YnjE6y68S7M4GyweIn9w6rRbOZipdQ=");             
              return request;

        }
        /// <summary>
        /// Funcion encargada de consultar todos los estudiantes matriculado en una materia.
        /// </summary>
        /// <param name="periodo">Periodo en el que se desea consultar </param>
        /// <param name="materia">Materia la que se quiere consultar los estudiantes</param>
        /// <returns>retorna un List con los estudiantes que cursan la materia pasada por parametro, si hay un error retorna una List null</returns>
        [MethodImpl(MethodImplOptions.Synchronized)]
        public static  List<EstudianteMateria> getEstudiantesMateria(String periodo, String materia)
        {
            //List<EstudianteMateria> estudiantes = getPruebaEstudinates();
             List<EstudianteMateria> estudiantes=null;
             try
             {
                 // se convierte el periodo al formato de cecar. Ejemplo 2017-2 a 20172
                 periodo = periodo.Replace("-", "");
                 String url = url_base+"api/v1/Bienestar/GetDatosEstudiante";
                 var client = new RestClient(url);
                 var request = preparaRestRequest();
                 // se agregan los parametros de la consulta
                 request.AddParameter("periodo", periodo);
                 request.AddParameter("nom_materia", materia);
                 // se hace y la peticion y se reciben los datos
                 IRestResponse respuetaDatos = client.Execute(request);
                 // se  Deserializan los datos a EstudianteMateria para un mejor tratamiento con linq
                 estudiantes = JsonConvert.DeserializeObject<List<EstudianteMateria>>(respuetaDatos.Content) as List<EstudianteMateria>;
             }catch(Exception){

             }
            return estudiantes;
        }
        /// <summary>
        /// Consulta los datos de un estudiante
        /// </summary>
        /// <param name="periodo"></param>
        /// <param name="id">Identificacón del estudinate</param>
        /// <returns></returns>
        
        [MethodImpl(MethodImplOptions.Synchronized)]
        public static EstudianteMateria getEstudiantePorID(String periodo,String id)
        {
            //List<EstudianteMateria> estudiantes = getPruebaEstudinates();
            EstudianteMateria estudiante = null;
            try
            {
                // se convierte el periodo al formato de cecar. Ejemplo 2017-2 a 20172
                periodo = periodo.Replace("-", "");
                String url = url_base + "api/v1/Bienestar/GetDatosEstudiante";
                var client = new RestClient(url);
                var request = preparaRestRequest();
                // se agregan los parametros de la consulta
                request.AddParameter("periodo", periodo);
                request.AddParameter("num_identificacion", id);
                // se hace y la peticion y se reciben los datos
                IRestResponse respuetaDatos = client.Execute(request);
                // se  Deserializan los datos a EstudianteMateria para un mejor tratamiento con linq
                List<EstudianteMateria> dato = JsonConvert.DeserializeObject<List<EstudianteMateria>>(respuetaDatos.Content) as List<EstudianteMateria>;
                estudiante = dato[0];
            }
            catch (Exception)
            {

            }
            return estudiante;
        }
        /// <summary>
        /// Consulta los datos de un grupo de estudiantes matriculados en una materia en un periodo.
        /// </summary>
        /// <param name="periodo"> perido en el que se desea consultar</param>
        /// <param name="materia">Asignatura a consultar los estudinates </param>
        /// <param name="idEstudiantes"> Lista de las Id de los estudiantes a consultar</param>           
        /// <returns>retorna un List<EstudianteMateria> con los datos de los estudinates, si hay un error retorna List<EstudianteMateria> null  </returns>
        [MethodImpl(MethodImplOptions.Synchronized)]
        public static List<EstudianteMateria> getDatosEstudiantesMateria(String periodo, String materia,List<String> idEstudiantes)
        {
            List<EstudianteMateria> estudiantes = null;
            try
            {
                // se convierte el periodo al formato de cecar. Ejemplo 2017-2 a 20172
                periodo = periodo.Replace("-", "");
                String url = url_base + "api/v1/Bienestar/GetDatosEstudiante";
                var client = new RestClient(url);
                var request = preparaRestRequest();
                // se agregan los parametros de la consulta
                request.AddParameter("periodo", periodo);
                request.AddParameter("nom_materia", materia);

                foreach (var id in idEstudiantes)
                {
                    request.AddParameter("num_identificacion", id);
                }
                // se hace  la peticion y se reciben los datos
                IRestResponse respuetaDatos = client.Execute(request);
                // se  Deserializan los datos a EstudianteMateria para un mejor tratamiento con linq
                estudiantes = JsonConvert.DeserializeObject<List<EstudianteMateria>>(respuetaDatos.Content) as List<EstudianteMateria>;
            }
            catch (Exception)
            {

            }
            return estudiantes;
        }

        ///// <summary>
        ///// Consulta los grupos que tiene una asigantura en un periodo
        ///// </summary>
        ///// <param name="periodo">Perido a consultar</param>
        ///// <param name="materia">Asignatura para consultar los grupos</param>
        ///// <returns>Array con los grupos de la asignatura</returns>
        // [MethodImpl(MethodImplOptions.Synchronized)]
        //public static List<Grupo>  getGruposMaterias(String periodo, String materia)
        //{
        //    List<Grupo> estudiantes = null;
        //    try
        //    {
        //     // se convierte el periodo al formato de cecar. Ejemplo 2017-2 a 20172
        //        periodo = periodo.Replace("-", "");
        //        String url = url_base + "api/v1/Bienestar/GetGrupo";
        //        var client = new RestClient(url);
        //        var request = preparaRestRequest();
        //        // se agregan los parametros de la consulta
        //        request.AddParameter("periodo", periodo);
        //        request.AddParameter("nom_materia", materia);
                
        //        // se hace y la peticion y se reciben los datos
        //        IRestResponse respuetaDatos = client.Execute(request);
        //        // se  Deserializan los datos a EstudianteMateria para un mejor tratamiento con linq
        //        estudiantes = JsonConvert.DeserializeObject<List<Grupo>>(respuetaDatos.Content) as List<AsignaturaGrupo>;
        //    }
        //    catch (Exception)
        //    {

        //    }
        //    return estudiantes;

        //}
        /// <summary>
        /// se utiliza para realizar pruebas sin tener q hacer peticiones a la api
        /// </summary>
        /// <returns></returns>
         public static List<EstudianteMateria> getPruebaEstudinates()
         {
             List<EstudianteMateria> p = new List<EstudianteMateria>();

             p.Add(new EstudianteMateria
             {

                 id_grupo = "7310",
                 num_identificacion = "1002488635",
                 nom_largo = "ARRAUT AMARIS LAURA MARCELA",
                 dir_email = "laura.arraut@cecar.edu.co",
                 cod_periodo = "20172",
                 fec_matricula = "2017-08-14T13:37:34",
                 cod_materia = "00964",
                 nom_materia = "MATEMATICA BASICA",
                 semestre = "1",
                 num_grupo = "1",
                 cod_sede = "3",
                 nom_sede = "SINCELEJO                     ",
                 cod_unidad = "18",
                 nom_unidad = "INGENIERIA DE SISTEMAS",
                 programa_matricula_estudiante = "18",
                 nom_prog_matricula_estudiante = "INGENIERIA DE SISTEMAS"
             });
             p.Add(new EstudianteMateria
              {

                  id_grupo = "7310",
                  num_identificacion = "1072263553",
                  nom_largo = "ARRAUT  LAURA MARCELA",
                  dir_email = "laura.arraut@cecar.edu.co",
                  cod_periodo = "20172",
                  fec_matricula = "2017-08-14T13:37:34",
                  cod_materia = "00964",
                  nom_materia = "MATEMATICA BASICA",
                  semestre = "1",
                  num_grupo = "1",
                  cod_sede = "3",
                  nom_sede = "SINCELEJO                     ",
                  cod_unidad = "18",
                  nom_unidad = "INGENIERIA DE SISTEMAS",
                  programa_matricula_estudiante = "18",
                  nom_prog_matricula_estudiante = "INGENIERIA DE SISTEMAS"
              });
             p.Add(new EstudianteMateria
             {

                 id_grupo = "7310",
                 num_identificacion = "1072263550",
                 nom_largo = "ARRAUT  LAURA MARCELA",
                 dir_email = "laura.arraut@cecar.edu.co",
                 cod_periodo = "20172",
                 fec_matricula = "2017-08-14T13:37:34",
                 cod_materia = "00964",
                 nom_materia = "MATEMATICA BASICA",
                 semestre = "1",
                 num_grupo = "1",
                 cod_sede = "3",
                 nom_sede = "SINCELEJO                     ",
                 cod_unidad = "18",
                 nom_unidad = "INGENIERIA DE SISTEMAS",
                 programa_matricula_estudiante = "18",
                 nom_prog_matricula_estudiante = "INGENIERIA DE SISTEMAS"
             });
             p.Add(new EstudianteMateria
             {

                 id_grupo = "7095",
                 num_identificacion = "1072263520",
                 nom_largo = "ARRAUT  LAURA MARCELA",
                 dir_email = "laura.arraut@cecar.edu.co",
                 cod_periodo = "20172",
                 fec_matricula = "2017-08-14T13:37:34",
                 cod_materia = "00964",
                 nom_materia = "MATEMATICA BASICA",
                 semestre = "1",
                 num_grupo = "1",
                 cod_sede = "3",
                 nom_sede = "SINCELEJO                     ",
                 cod_unidad = "18",
                 nom_unidad = "INGENIERIA DE INDUSTRIAL",
                 programa_matricula_estudiante = "18",
                 nom_prog_matricula_estudiante = "INGENIERIA DE INDUSTRIAL"
             });



             return p;
         }
         public static List<HorarioEstudiante> getHorarioEstudiante(String periodo, String materia)
         {
             List<HorarioEstudiante> horarios = null;
             try
             {
                 // se convierte el periodo al formato de cecar. Ejemplo 2017-2 a 20172
                 periodo = periodo.Replace("-", "");
                 String url = url_base + "api/v1/Bienestar/GetHorario";
                 var client = new RestClient(url);
                 var request = preparaRestRequest();
                 // se agregan los parametros de la consulta
                 request.AddParameter("periodo", periodo);
                 request.AddParameter("nom_materia", materia);
                 // se hace y la peticion y se reciben los datos
                 IRestResponse respuetaDatos = client.Execute(request);
                 // se  Deserializan los datos a EstudianteMateria para un mejor tratamiento con linq
                 horarios = JsonConvert.DeserializeObject<List<HorarioEstudiante>>(respuetaDatos.Content) as List<HorarioEstudiante>;
             }
             catch (Exception)
             {

             }
             return horarios;
         }
        /// <summary>
        /// Consulta las notas de un grupo de estudiantes en una materia
        /// </summary>
        /// <param name="periodo"></param>
        /// <param name="materia"></param>
        /// <returns></returns>
         public static List<ComportamientoNotaEstudiente> getNotaEstudianteMateria(string periodo, string materia, List<string> idEstudiantes)
         {
             List<ComportamientoNotaEstudiente> notas = null;
             try
             {
                 // se convierte el periodo al formato de cecar. Ejemplo 2017-2 a 20172
                 periodo = periodo.Replace("-", "");
                 String url = url_base + "api/v1/Bienestar/GetComportamientoNotas";
                 var client = new RestClient(url);
                 var request = preparaRestRequest();
                 // se agregan los parametros de la consulta
                 request.AddParameter("periodo", periodo);
                 request.AddParameter("nom_materia", materia);
                 foreach (var id in idEstudiantes)
                 {
                     request.AddParameter("num_identificacion", id);
                 }
                 // se hace y la peticion y se reciben los datos
                 IRestResponse respuetaDatos = client.Execute(request);
                 // se  Deserializan los datos a EstudianteMateria para un mejor tratamiento con linq
                 notas = JsonConvert.DeserializeObject<List<ComportamientoNotaEstudiente>>(respuetaDatos.Content) as List<ComportamientoNotaEstudiente>;
             }
             catch (Exception)
             {

             }
             return notas;
         }
         /// <summary>
         /// Consulta las notas de todos los estudisnte en una materia
         /// </summary>
         /// <param name="periodo"></param>
         /// <param name="materia"></param>
         /// <returns></returns>
         public static List<ComportamientoNotaEstudiente> getNotaEstudianteMateriaAll(string periodo, string materia)
         {
             List<ComportamientoNotaEstudiente> notas = null;
             try
             {
                 // se convierte el periodo al formato de cecar. Ejemplo 2017-2 a 20172
                 periodo = periodo.Replace("-", "");
                 String url = url_base + "api/v1/Bienestar/GetComportamientoNotas";
                 var client = new RestClient(url);
                 var request = preparaRestRequest();
                 // se agregan los parametros de la consulta
                 request.AddParameter("periodo", periodo);
                 request.AddParameter("nom_materia", materia);
                 
                 // se hace y la peticion y se reciben los datos
                 IRestResponse respuetaDatos = client.Execute(request);
                 // se  Deserializan los datos a EstudianteMateria para un mejor tratamiento con linq
                 notas = JsonConvert.DeserializeObject<List<ComportamientoNotaEstudiente>>(respuetaDatos.Content) as List<ComportamientoNotaEstudiente>;
             }
             catch (Exception)
             {

             }
             return notas;
         }
         /// <summary>
         /// consulta los programa y grupos filtrado por materia
         /// </summary>
         /// <param name="periodo"></param>
         /// <param name="materia"></param>
         /// <returns></returns>
         public static List<Grupo> getProgramaMateria(string periodo, string materia)
         {
             List<Grupo> notas = null;
             try
             {
                 // se convierte el periodo al formato de cecar. Ejemplo 2017-2 a 20172
                 periodo = periodo.Replace("-", "");
                 String url = url_base + "api/v1/Bienestar/GetGrupo";
                 var client = new RestClient(url);
                 var request = preparaRestRequest();
                 // se agregan los parametros de la consulta
                 request.AddParameter("periodo", periodo);
                 request.AddParameter("nom_materia", materia);

                 // se hace y la peticion y se reciben los datos
                 IRestResponse respuetaDatos = client.Execute(request);
                 // se  Deserializan los datos a EstudianteMateria para un mejor tratamiento con linq
                 notas = JsonConvert.DeserializeObject<List<Grupo>>(respuetaDatos.Content) as List<Grupo>;
             }
             catch (Exception)
             {

             }
             return notas;
         }
        /// <summary>
        /// consulta todos los grupos(programa, grupos, carga academica docentes...)
        /// </summary>
        /// <param name="periodo"></param>
        /// <returns></returns>
         public static List<Grupo> getGrupos(string periodo)
         {
             List<Grupo> grupos = null;
             try
             {
                 // se convierte el periodo al formato de cecar. Ejemplo 2017-2 a 20172
                 periodo = periodo.Replace("-", "");
                 String url = url_base + "api/v1/Bienestar/GetGrupo";
                 var client = new RestClient(url);
                 var request = preparaRestRequest();
                 // se agregan los parametros de la consulta
                 request.AddParameter("periodo", periodo);

                 // se hace y la peticion y se reciben los datos
                 IRestResponse respuetaDatos = client.Execute(request);
                 // se  Deserializan los datos a EstudianteMateria para un mejor tratamiento con linq
                 grupos = JsonConvert.DeserializeObject<List<Grupo>>(respuetaDatos.Content) as List<Grupo>;
             }
             catch (Exception)
             {

             }
             return grupos;
         }

        
    }
    
}
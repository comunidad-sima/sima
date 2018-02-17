using Newtonsoft.Json;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Web;

namespace WebSima.Models.WebApi
{
    public class ConsumidorAppi
    {
        
        private static RestRequest preparaRestRequest()
        {                   
              var request = new RestRequest(Method.POST);
              //request.AddHeader("postman-token", "3e202979-97d1-7174-01f4-a2e151cd7b64");
              request.AddHeader("cache-control", "no-cache");
              request.AddHeader("content-type", "application/x-www-form-urlencoded");
              request.AddHeader("accesstoken", "IWzG2B3Tq9wj+YnjE6y68S7M4GyweIn9w6rRbOZipdQ=");             
              return request;

        }
        /// <summary>
        /// Función encargada de consultar todos los estudiantes matriculado en una materia.
        /// </summary>
        /// <param name="periodo">Periodo en el que se desea consultar </param>
        /// <param name="materia">Materia la que se quiere consultar los estudiantes</param>
        /// <returns>retorna un List<EstudianteMateria> con los estudiantes que cursan la materia pasada por parametro, si hay un error retorna una List null</returns>
        [MethodImpl(MethodImplOptions.Synchronized)]
        public static  List<EstudianteMateria> getEstudiantesMateria(String periodo, String materia)
        {
            //List<EstudianteMateria> estudiantes = getPruebaEstudinates();
             List<EstudianteMateria> estudiantes=null;
             try
             {
                 // se convierte el periodo al formato de cecar. Ejemplo 2017-2 a 20172
                 periodo = periodo.Replace("-", "");
                 String url = "https://webapi.cecar.edu.co/IntegracionOtrosPortales/api/v1/Bienestar/GetDatosEstudiante";
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
                // se convierte el perido al formato de cecar. Ejemplo 2017-2 a 20172
                periodo = periodo.Replace("-", "");
                String url = "https://webapi.cecar.edu.co/IntegracionOtrosPortales/api/v1/Bienestar/GetDatosEstudiante";
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
                estudiantes = JsonConvert.DeserializeObject<List<EstudianteMateria>>(respuetaDatos.Content) as List<EstudianteMateria>;
            }
            catch (Exception)
            {

            }
            return estudiantes;
        }


        public static List<EstudianteMateria> getPruebaEstudinates()
        {
            List<EstudianteMateria> p = new List<EstudianteMateria>();
            
            p.Add(new EstudianteMateria
            {
            
        id_grupo="7310",
        num_identificacion="1002488635",
        nom_largo="ARRAUT AMARIS LAURA MARCELA",
        dir_email= "laura.arraut@cecar.edu.co",
        cod_periodo= "20172",
        fec_matricula="2017-08-14T13:37:34",
        cod_materia= "00964",
        nom_materia ="MATEMATICA BASICA",
        semestre= "1",
        num_grupo= "2",
        cod_sede="3",
        nom_sede="SINCELEJO                     ",
        cod_unidad="18",
        nom_unidad="CONTADURIA PUBLICA",
        programa_matricula_estudiante="18",
        nom_prog_matricula_estudiante= "CONTADURIA PUBLICA"
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
                nom_unidad = "CONTADURIA PUBLICA",
                programa_matricula_estudiante = "18",
                nom_prog_matricula_estudiante = "CONTADURIA PUBLICA"
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
                num_grupo = "2",
                cod_sede = "3",
                nom_sede = "SINCELEJO                     ",
                cod_unidad = "18",
                nom_unidad = "INGENIERIA DE INDUSTRIAL",
                programa_matricula_estudiante = "18",
                nom_prog_matricula_estudiante = "INGENIERIA DE INDUSTRIAL"
            });

          
          
            return p;
        }

        
    }
    
}
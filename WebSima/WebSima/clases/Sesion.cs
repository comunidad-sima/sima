using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebSima.Models
{
    public class Sesion
    {
       private String sesion;

        /// <summary>
        /// consulta el nombre del ususrio login
        /// </summary>
        /// <returns></returns>
       public String getNombreUsuario()
       {
           this.sesion = Convert.ToString(HttpContext.Current.Session["nombre_usuario"]);
           return sesion;
       }

        /// <summary>
        /// edita el nombre del ususrio login
        /// </summary>
        /// <param name="dato"></param>
       public void setINombreUsuario(String dato)
       {
           HttpContext.Current.Session["nombre_usuario"] = dato;

       }
        /// <summary>
        /// consulta el id del usuario que esta loguiado 
        /// </summary>
        /// <returns></returns>
       public String getIdUsuario()
       {
           this.sesion = Convert.ToString(HttpContext.Current.Session["id_usuario"]);
           return sesion;
       }
        /// <summary>
        /// edita el id del usuario loguiado
        /// </summary>
        /// <param name="dato"></param>
        public void  setIdUsurio(String dato){
            HttpContext.Current.Session["id_usuario"] = dato;

        }
        /// <summary>
        /// consulta el perfil del usuario logiado
        /// </summary>
        /// <returns></returns>
        public String getIPerfilUsusrio()
        {
            this.sesion = Convert.ToString(HttpContext.Current.Session["ferfil_usuario"]);
            return sesion;
        }
        /// <summary>
        /// Edita el perfil del ususrio loguiado
        /// </summary>
        /// <param name="dato"></param>
        public void setIPerfilUsusrio(String dato)
        {
            HttpContext.Current.Session["ferfil_usuario"] = dato;

        }
        /// <summary>
        /// edita la materia para registar las clase
        /// </summary>
        /// <param name="dato"></param>
        public void setMateria(String dato)
        {
            HttpContext.Current.Session["Materia"] = dato;

        }
        /// <summary>
        /// consulta la mataria seleccionada para el registro de asistencia
        /// </summary>
        /// <returns></returns>
        public String getMateria()
        {
            this.sesion = Convert.ToString(HttpContext.Current.Session["Materia"]);
            return sesion;
        }
        /// <summary>
        /// edita el id del curso al que se va a evaluar en un test 
        /// </summary>
        /// <param name="dato"></param>
        public void setIdCurso_test(int dato)
        {
            HttpContext.Current.Session["IdCurso_test"] = dato;

        }
        /// <summary>
        /// devuelve el id del curso que se esta evaluando 
        /// </summary>
        /// <returns></returns>
        public int getIdCurso_test()
        {           
            return Convert.ToInt32(HttpContext.Current.Session["IdCurso_test"]);
        }
        /// <summary>
        /// edita la materia para la generacion de reporte de asistencia
        /// </summary>
        /// <param name="dato"></param>
        public void setMateriaReporteAsistencia(String dato)
        {
            HttpContext.Current.Session["materia_reporte_asistencia"] = dato;

        }
        /// <summary>
        /// consulta la materia para generar el reporte de asistencia
        /// </summary>
        /// <returns></returns>
        public String getMateriaReporteAsistencia()
        {
            this.sesion = Convert.ToString(HttpContext.Current.Session["materia_reporte_asistencia"]);
            return sesion;
        }
        /// <summary>
        /// Edita el periodo para generar el reporte de asistencia 
        /// </summary>
        /// <param name="dato"></param>
        public void setPeridoReporteAsistencia(String dato)
        {
            HttpContext.Current.Session["perido_reporte_asistencia"] = dato;

        }
        /// <summary>
        /// consulta el periodo para generar reporte de asistencia 
        /// </summary>
        /// <returns></returns>
        public String getperiodoReporteAsistencia()
        {
            this.sesion = Convert.ToString(HttpContext.Current.Session["perido_reporte_asistencia"]);
            return sesion;
        }
        /// <summary>
        /// edita el id del tets que se va a responder
        /// </summary>
        /// <param name="dato"></param>
        public void setId_test_responder(int dato)
        {
            HttpContext.Current.Session["Id_test_responder"] = dato;

        }
        /// <summary>
        /// consulta el id del test que se va a responder
        /// </summary>
        /// <returns></returns>
        public String getId_test_responder()
        {
            this.sesion = Convert.ToString(HttpContext.Current.Session["Id_test_responder"]);
            return sesion;
        }


        public void destruirSesion(){
            HttpContext.Current.Session.Abandon();
        }
        /// <summary>
        /// valida que usuario loguiado se estudiante
        /// </summary>
        /// <param name="db"></param>
        /// <returns></returns>
        public bool esMonitor(bd_simaEntitie db)
        {
            return esUsuarioValido(db,"Monitor");
        }
        /// <summary>
        /// valida que el usuario se administrador
        /// </summary>
        /// <param name="db"></param>
        /// <returns></returns>
        public bool esAdministrador(bd_simaEntitie db)
        {
            return esUsuarioValido(db, "Administrador");
        }
        /// <summary>
        /// valida q el ususrio loguiado se docente
        /// </summary>
        /// <param name="db"></param>
        /// <returns></returns>
        public bool esDocente(bd_simaEntitie db)
        {
            return esUsuarioValido(db, "Docente");
        }
        /// <summary>
        /// valida q el ususrio loguiado se estudiante
        /// </summary>
        /// <returns></returns>
        public bool esEstudiante()
        {
            return(getIPerfilUsusrio().Equals("Estudiante"));
        }

        public bool esAdministradorOrMonitor(bd_simaEntitie db)
        {
            bool valido = false;
            String idUsuario = getIdUsuario();
            if (!idUsuario.Equals(""))
            {
                usuarios u = db.usuarios.Find(idUsuario);
                if (u != null)
                {
                    if (u.tipo.Equals("Administrador") || u.tipo.Equals("Monitor"))
                    {
                        valido = true;
                    }
                }
            }
            if (!valido)
            {
                destruirSesion();
            }
            return valido;
        }

        private bool esUsuarioValido(bd_simaEntitie db, String perfil)
        {
            bool valido = false;
            String idUsuario=getIdUsuario();
            if (!idUsuario.Equals(""))
            {
                usuarios u = db.usuarios.Find(idUsuario);
                if(u!=null){
                    if (u.tipo.Equals(perfil))
                    {
                        valido = true;
                    }  
                }
            }
            if (!valido)
            {
                destruirSesion();
            }
            return valido;
        }

    }
}
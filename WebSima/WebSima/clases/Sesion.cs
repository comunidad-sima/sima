using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebSima.Models
{
    public class Sesion
    {
       private String sesion;

       public String getNombreUsuario()
       {
           this.sesion = Convert.ToString(HttpContext.Current.Session["nombre_usuario"]);
           return sesion;
       }

       public void setINombreUsuario(String dato)
       {
           HttpContext.Current.Session["nombre_usuario"] = dato;

       }
       public String getIdUsuario()
       {
           this.sesion = Convert.ToString(HttpContext.Current.Session["id_usuario"]);
           return sesion;
       }

        public void  setIdUsurio(String dato){
            HttpContext.Current.Session["id_usuario"] = dato;

        }
        public String getIPerfilUsusrio()
        {
            this.sesion = Convert.ToString(HttpContext.Current.Session["ferfil_usuario"]);
            return sesion;
        }

        public void setIPerfilUsusrio(String dato)
        {
            HttpContext.Current.Session["ferfil_usuario"] = dato;

        }
        public void setMateria(String dato)
        {
            HttpContext.Current.Session["Materia"] = dato;

        }
        public String getMateria()
        {
            this.sesion = Convert.ToString(HttpContext.Current.Session["Materia"]);
            return sesion;
        }

        public void setMateriaReporteAsistencia(String dato)
        {
            HttpContext.Current.Session["materia_reporte_asistencia"] = dato;

        }
        public String getMateriaReporteAsistencia()
        {
            this.sesion = Convert.ToString(HttpContext.Current.Session["materia_reporte_asistencia"]);
            return sesion;
        }
        public void setPeridoReporteAsistencia(String dato)
        {
            HttpContext.Current.Session["perido_reporte_asistencia"] = dato;

        }
        public String getperiodoReporteAsistencia()
        {
            this.sesion = Convert.ToString(HttpContext.Current.Session["perido_reporte_asistencia"]);
            return sesion;
        }
        public void setId_test_responder(int dato)
        {
            HttpContext.Current.Session["Id_test_responder"] = dato;

        }
        public String getId_test_responder()
        {
            this.sesion = Convert.ToString(HttpContext.Current.Session["Id_test_responder"]);
            return sesion;
        }


        public void destruirSesion(){
            HttpContext.Current.Session.Abandon();
        }

        public bool esMonitor(bd_simaEntitie db)
        {
            return esUsuarioValido(db,"Monitor");
        }
        public bool esAdministrador(bd_simaEntitie db)
        {
            return esUsuarioValido(db, "Administrador");
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
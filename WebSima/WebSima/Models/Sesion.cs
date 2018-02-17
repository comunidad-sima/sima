using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebSima.Models
{
    public class Sesion
    {
       private String sesion;

       public String getSesion(String nombre)
       {
           this.sesion = Convert.ToString(HttpContext.Current.Session[nombre]);
           return sesion;
       }

        public void  setSesion(String dato, String nombre){
            HttpContext.Current.Session[nombre] = dato;

        }
        public void destruirSesion(){
            HttpContext.Current.Session.Abandon();
        }

        public bool esUsuarioValido(bd_simaEntitie db, String perfil)
        {
            bool valido = false;
            String idUsuario=getSesion("id_usuario");
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
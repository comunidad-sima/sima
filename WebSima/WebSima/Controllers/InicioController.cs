using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using System.Diagnostics;
using Newtonsoft.Json.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Runtime.Serialization.Json;
using RestSharp;
using WebSima.Models.WebApi;
using Newtonsoft.Json;
using RestSharp.Deserializers;
using WebSima.Models;
using WebSima.clases;

namespace WebSima.Controllers
{
    public class InicioController : Controller
    {
        //
        // GET: /Inicio/
        bd_simaEntitie db = new bd_simaEntitie();
        Sesion sesion = new Sesion();
        public ActionResult MenuAdministrador()
        {

            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Login(String contrasena, String id)
        {
            try
            {
                usuarios u = db.usuarios.Find(id);
                //String co = Seguridad.Encriptar("Cecar123");
                if (u != null)
                {
                    String contra = Seguridad.DesEncriptar(u.contrasena);
                    if (contra.Equals(contrasena))
                    {
                        sesion.setSesion(id, "id_usuario");
                        sesion.setSesion(u.tipo, "tipo_usuario");
                        if (u.tipo.Equals("Administrador"))
                        {
                            return Redirect("~/Capacitacion/Home");
                        }
                        else if (u.tipo.Equals("Monitor"))
                        {
                            if (MCurso.tieneCursosAcargo(db, id))
                            {
                                return Redirect("~/Clase/Index");
                            }
                            else
                            {
                                sesion.destruirSesion();
                                ViewBag.mensajeError = "No tiene grupo a cargo.";
                            }
                        }
                        else
                        {
                            ViewBag.mensajeError = "Perfil " + u.tipo + " No existe!!";
                        }

                    }
                    else
                    {
                        ViewBag.mensajeError = "Contraseña incorrecta";
                    }

                }
                else
                {
                    ViewBag.mensajeError = "Usuario no registrado.";
                }
            }
            catch (Exception e)
            {
                ViewBag.mensajeError = e.Message;
            }
            return View();
        }
        public ActionResult Login()
        {
            if (!sesion.getSesion("id_usuario").Equals(""))
            {
                String tipo_usuario = sesion.getSesion("tipo_usuario");
                if (tipo_usuario.Equals("Administrador"))
                {
                    return Redirect("~/Capacitacion/Home");
                }
                else if (tipo_usuario.Equals("Monitor"))
                {
                    return Redirect("~/Clase/Index");
                }
                
            }

            return View();
        }

        public ActionResult MenuMonitor()
        {          
           
            return View();
        }

    }
}


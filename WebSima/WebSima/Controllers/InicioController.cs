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

        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult Login_test(String id="")
        {
            Respuesta respuesta = new Respuesta();
            if (!id.Equals(""))
            {
                Rutina.Rutinas();
                List<MTest> mtest_disponibles = (new MTest()).getTestPeriodo("", 0, 0);
                mtest_disponibles = (from mt in mtest_disponibles
                                     where (DateTime.Compare(DateTime.Now, mt.fecha_inicio) >= 0 && mt.ferfil_usuario.Equals("Estudiante"))
                                    select mt).ToList();
                if (mtest_disponibles.Count() > 0)
                {
                    String periodo = MConfiguracionApp.getPeridoActual(db);
                    Mclase mclase = new Mclase();
                    int asistencia = mclase.getCantidadClaseAsistidaEstudianteId(periodo, id);
                    if (asistencia > 0)
                    {
                        EstudianteMateria estudiante = ConsumidorAppi.getEstudiantePorID(periodo, id);
                        if (estudiante == null)
                        {
                            respuesta.RESPUESTA = "ERROR";
                            respuesta.MENSAJE = "Usuario no encontrado.";
                        }
                        else
                        {
                            sesion.setIPerfilUsusrio("Estudiante");
                            sesion.setIdUsurio(estudiante.num_identificacion);
                            sesion.setINombreUsuario(estudiante.nom_largo);
                            respuesta.RESPUESTA = "OK";
                        }
                    }
                    else
                    {
                        respuesta.RESPUESTA = "NO_ASISTE";
                        respuesta.MENSAJE = "Usted no está apto para realizar el test porque  no ha asistido a monitorias en el periodo actual.";
                    }
                }
                else
                {
                    respuesta.RESPUESTA = "ERROR";
                    respuesta.MENSAJE = "😞 No hay Tests disponibles en este momento 😞.";
                }
            }
            else
            {
                respuesta.RESPUESTA = "ERROR";
                respuesta.MENSAJE = "Identificación no valida.";

            }
            return Json(respuesta);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Login(String contrasena, String id)
        {
            try
            {
                Rutina.Rutinas();
                MUsuario u = new MUsuario().getUsuarioId(id);
                //String co = Seguridad.Encriptar("Cecar123");
                if (u != null)
                {
                    String contra = Seguridad.DesEncriptar(u.contrasena);
                    if (contra.Equals(contrasena))
                    {
                        sesion.setIdUsurio(id);
                        sesion.setIPerfilUsusrio(u.tipo);
                        sesion.setINombreUsuario(u.nombre + " " + u.apellidos);
                        if (u.tipo.Equals("Administrador"))
                        {
                            return Redirect("~/Capacitacion/Home");
                        }
                        else if (u.tipo.Equals("Monitor"))
                        {
                            if (new MCurso().tieneCurso_activo(id))
                            {
                                return Redirect("~/Clase/Index");
                            }
                            else
                            {
                                sesion.destruirSesion();
                                ViewBag.mensajeError = "No tiene grupo a cargo.";
                            }
                        }
                        else if (u.tipo.Equals("Docente"))
                        {
                            return Redirect("~/Calificaciones/Home");
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
           
            if (!sesion.getIdUsuario().Equals(""))
            {
                Rutina.Rutinas();
                String tipo_usuario = sesion.getIPerfilUsusrio();
                if (tipo_usuario.Equals("Administrador"))
                {
                    return Redirect("~/Capacitacion/Home");
                }
                else if (tipo_usuario.Equals("Monitor"))
                {
                    return Redirect("~/Clase/Index");
                }
                else if (tipo_usuario.Equals("Docente"))
                {
                    return Redirect("~/Calificaciones/Home");
                }
                
            }

            return View();
        }

        
        public ActionResult Salir()
        {
            sesion.destruirSesion();

            return Redirect("~/Inicio/Login");
        }
        [HttpPost]
        public JsonResult sesion_activa()
        {            
            return Json(!sesion.getIdUsuario().Equals(""));
        }


    }
}


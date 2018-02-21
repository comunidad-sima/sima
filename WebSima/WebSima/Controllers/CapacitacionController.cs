using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebSima.Models;
using WebSima.clases;

namespace WebSima.Controllers
{
    public class CapacitacionController : Controller
    {
        private bd_simaEntitie db = new bd_simaEntitie();
        String nombreCarpeta = "~/Uploads";
        Sesion sesion = new Sesion();

        //
        // GET: /Capacitacion/

        public ActionResult Listar(String periodo="2017-2"){
            if (sesion.esAdministrador(db))
            {               
                return View(MCapacitacion.getCapacitacionesPeriodo(db, periodo));
            }
            return null;
        }

        public ActionResult Home(String periodo = "2017-2")
        {
            if (sesion.esAdministrador(db))
            {
                ViewBag.periodos = MCapacitacion.getPeriodos(db);
                return View();
            }
            else
            {
                return Redirect("~/Inicio/Login");
            }
        }

        //
        // GET: /Capacitacion/Details/5

        public ActionResult Details(int id = 0){
            if (sesion.esAdministrador(db))
            {

                MCapacitacion mCapacitacion = MCapacitacion.getCapacitacionId(db, id);
                if (mCapacitacion == null)
                {
                    return HttpNotFound();
                }
                return View(mCapacitacion);
            }
            else
            {
                return Redirect("~/Inicio/Login");
            }
        }
        public FileResult Descargar(String archivoNombre)
        {
            if (sesion.esAdministrador(db))
            {

                string ruta = Server.MapPath(nombreCarpeta + "/" + archivoNombre);
                if (Archivo.existeFile(ruta))
                {
                    var file = File(ruta, "application/octet-stream", archivoNombre);
                    return file;
                }
                else
                    return null;
            }
            else
            {
                return null;
            }
        }


        //
        // GET: /Capacitacion/Create
        [HttpGet]
        public ActionResult Create()
        {
         
                return View();            
        }

        //
        // POST: /Capacitacion/Create

        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult Create(MCapacitacion Mcapacitacion){
            Respusta respuesta = new Respusta();
            if (sesion.esAdministrador(db))
            {
               
                string ruta = Server.MapPath(nombreCarpeta);
                if (ModelState.IsValid)
                {
                    capacitaciones c = new capacitaciones();
                    c.comentarios = Mcapacitacion.comentarios;
                    c.fecha = Mcapacitacion.fecha;
                    c.encargado = Mcapacitacion.encargado;
                    c.nom_File = Mcapacitacion.File;
                    c.periodo = Mcapacitacion.periodo;
                    c.tema = Mcapacitacion.tema;
                    // se guardan los ficheros
                    String[] resultado = Archivo.subir(Request.Files, ruta);
                    // si se guarda el fichero en el servidor, se guarda el registro en la BD
                    if (resultado[0].Equals("ok"))
                    {
                        // se asigna el nombre 
                        c.nom_File = resultado[1];
                        // se guarda en la BD
                        String guardar = Mcapacitacion.guardar(c, db);
                        // se comprueba si se gusrdó
                        if (guardar != null)
                        {
                            respuesta.RESPUESTA = "OK";                 
                        }
                        else{
                            respuesta.RESPUESTA = "ERROR";
                            respuesta.MENSAJE = "Error al registrar la capacitación.";
                            Archivo.elimiarFichero(ruta, resultado[1]); 
                        }
                    }
                    else{
                        respuesta.RESPUESTA = "ERROR";
                        respuesta.MENSAJE = resultado[1];
                    }
                }
                else{
                    respuesta.RESPUESTA = "ERROR";
                    respuesta.MENSAJE = "Los datos ingresados son incorrecotos.";
                    //respuesta.DATOS = (from x in ModelState where ModelState[x.Key].Errors.Count > 0 select (x.Value)).ToArray();                  
                }               
            }
            else            {
                respuesta.RESPUESTA = "LOGIN";
            }
            return Json(respuesta);

        }

      

        [HttpPost]
        //[ValidateAntiForgeryToken]
        public JsonResult Delete(int id=0){
            Respusta respuesta = new Respusta();
            if (sesion.esAdministrador(db))
            {            
                    capacitaciones capacitaciones = db.capacitaciones.Find(id);
                    if (capacitaciones != null)
                    {
                        db.capacitaciones.Remove(capacitaciones);
                        db.SaveChanges();
                        Archivo.elimiarFichero(Server.MapPath(nombreCarpeta), capacitaciones.nom_File);
                        respuesta.RESPUESTA = "OK";
                        
                    }else{
                         respuesta.RESPUESTA = "ERROR";
                         respuesta.MENSAJE = "Capacitación no exite.";
                        
                    }
                } 
            else
            {
                respuesta.RESPUESTA = "LOGIN";
               
            }
            return Json(respuesta);
        }
        protected override void Dispose(bool disposing)
        {
            db.Dispose();
            base.Dispose(disposing);
        }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebSima.Models;

namespace WebSima.Controllers
{
    public class CalificacionesController : Controller
    {
        private bd_simaEntitie db = new bd_simaEntitie();
        //
        // GET: /Asistencia/

        public ActionResult home()
        {
            return View();
        }

        //
        // GET: /Asistencia/Details/5

        public ActionResult Details(int id)
        {
            return View();
        }

        //
        // GET: /Asistencia/Create

        public ActionResult Registrar()
        {
            return View();
        }

        //
        // POST: /Asistencia/Create

        [HttpPost]
        public JsonResult Guardar(FormCollection datos_notas)
        {
          //  var notas = Request.Form[0];
                      
            Respuesta respuesta = new Respuesta();
          
                //se piden las keys 
                MCalificaciones_periodo aux = new MCalificaciones_periodo();

                String guardado=aux.guardar(db, datos_notas);
                if (!guardado.Equals("OK"))
                {
                    respuesta.RESPUESTA = "ERROR";
                    respuesta.MENSAJE = guardado;
                }
                else
                {
                    respuesta.RESPUESTA = "OK";
                    respuesta.MENSAJE = "Calificaciones guardadas.";
                }

               
            

            return Json(respuesta);
        }

        //
        // GET: /Asistencia/Edit/5

        public ActionResult Edit(int id)
        {
            return View();
        }

        //
        // POST: /Asistencia/Edit/5

        [HttpPost]
        public ActionResult Edit(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add update logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        //
        // GET: /Asistencia/Delete/5

        public ActionResult Delete(int id)
        {
            return View();
        }

        //
        // POST: /Asistencia/Delete/5

        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}

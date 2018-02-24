using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebSima.Models;
using WebSima.Models.WebApi;

namespace WebSima.Controllers
{
   
    public class InformeController : Controller
    {
        String periodo = "2017-2";
        private bd_simaEntitie db = new bd_simaEntitie();
        //
        // GET: /Informe/

        public ActionResult Home()
        {
            return View();
        }
        //
        // GET: /Informe/Details/5

        public ActionResult Modal_ferfil_estudiante()
        {
            return View("modal_informe");
        }
        //
        // GET: /Informe/Details/5

        public ActionResult Details(int id)
        {
            return View();
        }

        public ActionResult Reporte_asistencia(String materia = "TALLER DE LENGUA I")
        {
            List<String> idEstudiantes = null;

            MInforme info = new MInforme();            
            List<String[]> datos= info.consultarAsistencia( materia);
            idEstudiantes = datos.Select(m => m[1]).ToList();
            List<EstudianteMateria> datos_2 = ConsumidorAppi.getDatosEstudiantesMateria(periodo, materia, idEstudiantes);
            ViewBag.materias = new SelectList(MMateria.getMaterias(db), "Value", "Text");
            ViewBag.asistencia = datos;
            ViewBag.datos_estudiante = datos_2;

            return View("Reporte_asistencia");
        }
        //
        // GET: /Informe/Create

        public ActionResult Create()
        {
            return View();
        }

        //
        // POST: /Informe/Create

        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            try
            {
                // TODO: Add insert logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        //
        // GET: /Informe/Edit/5

        public ActionResult Edit(int id)
        {
            return View();
        }

        //
        // POST: /Informe/Edit/5

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
        // GET: /Informe/Delete/5

        public ActionResult Delete(int id)
        {
            return View();
        }

        //
        // POST: /Informe/Delete/5

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

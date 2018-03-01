using ClosedXML.Excel;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Web;
using System.Web.Mvc;
using WebSima.clases;
using WebSima.Models;
using WebSima.Models.WebApi;

namespace WebSima.Controllers
{
   
    public class InformeController : Controller
    {
        //String periodo = "2017-2";
        private bd_simaEntitie db = new bd_simaEntitie();
        Sesion session = new Sesion();
        //
        // GET: /Informe/

        public ActionResult Home()
        {
            return View();
        }


        public ActionResult Test_aprobacion()
        {
            return View("Test_aprobacion");
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

        public ActionResult Reporte_asistencia(String periodo="-",String materia = "Seleccione asignatura")
        {
            if (periodo.Equals("-"))
                periodo  = MConfiguracionApp.getPeridoActual(db);;
            List<String> idEstudiantes = new List<string>();
            List<EstudianteMateria> datos_2 = new List<EstudianteMateria>();
            MInforme info = new MInforme();
             List<String[]> datos= new List<string[]>();
             if (!materia.Equals("Seleccione asignatura"))
             {
                 datos = info.consultarAsistencia(materia);

                 if (datos.Count() > 0)
                 {
                     // seleccionamaos todas las id de los estudiantes 
                     idEstudiantes = datos.Select(m => m[1]).ToList();
                     datos_2 = ConsumidorAppi.getDatosEstudiantesMateria(periodo, materia, idEstudiantes);
                 }
             }
            ViewBag.periodos = Mclase.getPeriodosRegistradosDeClase(db);
            ViewBag.materias = new SelectList(MMateria.getMaterias_registro_grupos( db,periodo), "Value", "Text");
            ViewBag.asistencia = datos;
            ViewBag.datos_estudiante = datos_2;
            ViewBag.asignatura = materia;
            ViewBag.peridoSeleccionado = periodo;
            session.setMateriaReporteAsistencia(materia);
            session.setPeridoReporteAsistencia(periodo);
            return View("Reporte_asistencia");
        }
        //
        // GET: /Informe/Create

        public ActionResult Create()
        {
            return View();
        }
        public FileResult Download_reporte_asistencia()
        {
            
            DataTable dt = new Excel_informe().getExceAsistenciaMonitoria(); ;
          
            using (XLWorkbook wb = new XLWorkbook())
            {
                wb.Worksheets.Add(dt);
                using (MemoryStream stream = new MemoryStream())
                {
                    wb.SaveAs(stream);
                    var file = File(stream.ToArray(), "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "reporte_asistencia_sima.xlsx");
                    stream.Dispose();
                    stream.Close();
                    return file;

                }
            }
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

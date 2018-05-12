using ClosedXML.Excel;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
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

        public JsonResult getPorcentaje(string periodo ,string materia, string programa, int nota)
        {
            List<ComportamientoNotaEstudiente> datos_2;

            datos_2 = ConsumidorAppi.getNotaEstudianteMateriaAll(periodo, materia);
            NumberFormatInfo provider = new NumberFormatInfo();
           
            return null;
        }
        public ActionResult Reporte_asistencia(string periodo = "-", string materia = "Seleccione asignatura", string programa = "Todos")
        {
            if (periodo.Equals("-"))
                periodo  = MConfiguracionApp.getPeridoActual(db);
            //List<String> idEstudiantes = new List<string>();
            List<ComportamientoNotaEstudiente> datos_2 = new List<ComportamientoNotaEstudiente>();
            MInforme info = new MInforme();
            SelectList programas ;
             List<String[]> datos= new List<string[]>();
             if (!materia.Equals("Seleccione asignatura"))
             {
                 datos=info.consultarAsistencia(materia, periodo);
                 //datos = info.consultarAsistencia(materia,periodo);
                 
                 datos_2 = ConsumidorAppi.getNotaEstudianteMateriaAll(periodo, materia);
                 if (datos_2 != null)
                 {       
                     // se filtra por el programa
                     if (!programa.Equals("Todos"))
                     {
                         datos_2 = (from d in datos_2 where (d.nom_prog_matricula_estudiante.Equals(programa)) select d).ToList();
                     }
                 }

             }
             programas = new SelectList((new MMateria()).getProgramasDeMateria(periodo, materia), "Value", "Text");
          /// getProgramas(periodo,  materia);

            
            ViewBag.periodos = new Mclase().getPeriodosRegistradosDeClase(db);
            ViewBag.materias = new SelectList(new MMateria().getMaterias_registro_grupos( db,periodo), "Value", "Text");
            ViewBag.asistencia = datos;
            ViewBag.datos_estudiante = datos_2;
            ViewBag.asignatura = materia;
            ViewBag.programa = programa;
            ViewBag.programas = programas;
            ViewBag.periodo = periodo;
            ViewBag.peridoSeleccionado = periodo;
            session.setMateriaReporteAsistencia(materia);
            session.setPeridoReporteAsistencia(periodo);
            session.setProgramaReporteAsistencia(programa);
            return View("Reporte_asistencia");
        }
        //
        // GET: /Informe/Create

        public JsonResult getProgramas(string periodo, string materia)
        {
            List<string> programas= new List<string>();
            var programas_tem = (new MMateria()).getProgramasDeMateria(periodo, materia);
                foreach(var p in programas_tem)
                    programas.Add(p.Value);

            return Json(programas);

        }
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

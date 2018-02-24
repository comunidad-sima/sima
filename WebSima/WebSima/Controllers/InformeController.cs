using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Web;
using System.Web.Mvc;
using WebSima.Models;
using WebSima.Models.WebApi;

namespace WebSima.Controllers
{
   
    public class InformeController : Controller
    {String nombreCarpeta = "~/Uploads";
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

        public ActionResult Reporte_asistencia(String materia = "Seleccione asignatura")
        {
            List<String> idEstudiantes = new List<string>();
            List<EstudianteMateria> datos_2 = new List<EstudianteMateria>();
            MInforme info = new MInforme();            
            List<String[]> datos= info.consultarAsistencia( materia);
            if (datos.Count() > 0)
            {
                // seleccionamaos todas las id de los estudiantes 
                idEstudiantes = datos.Select(m => m[1]).ToList();
                datos_2 = ConsumidorAppi.getDatosEstudiantesMateria(periodo, materia, idEstudiantes);
            }
            ViewBag.materias = new SelectList(MMateria.getMaterias(db), "Value", "Text");
            ViewBag.asistencia = datos;
            ViewBag.datos_estudiante = datos_2;
            ViewBag.asignatura = materia;
            return View("Reporte_asistencia");
        }
        //
        // GET: /Informe/Create

        public ActionResult Create()
        {
            return View();
        }
        public FileResult Download()
        {
            Microsoft.Office.Interop.Excel.Application xlApp = new Microsoft.Office.Interop.Excel.Application();

            Microsoft.Office.Interop.Excel.Workbook xlWorkBook;
            Microsoft.Office.Interop.Excel.Worksheet xlWorkSheet;

            object misValue = System.Reflection.Missing.Value;

            xlWorkBook = xlApp.Workbooks.Add(misValue);
            xlWorkSheet = (Microsoft.Office.Interop.Excel.Worksheet)xlWorkBook.Worksheets.get_Item(1);

            xlWorkSheet.Cells[1, 1] = "ID";
            xlWorkSheet.Cells[1, 2] = "Name";
            xlWorkSheet.Cells[2, 1] = "1";
            xlWorkSheet.Cells[2, 2] = "One";
            xlWorkSheet.Cells[3, 1] = "2";
            xlWorkSheet.Cells[3, 2] = "Two";


            var path = nombreCarpeta + "/ WidgetData.xlsx";
            xlWorkBook.SaveAs(path);
            xlWorkBook.Close(true, misValue, misValue);
            xlApp.Quit();

            Marshal.ReleaseComObject(xlWorkSheet);
            Marshal.ReleaseComObject(xlWorkBook);
            Marshal.ReleaseComObject(xlApp);
            var f = File(path, "application/vnd.ms-excel", "WidgetData.xlsx");
            return f;
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

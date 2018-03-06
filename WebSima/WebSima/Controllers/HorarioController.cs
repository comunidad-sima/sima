using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Transactions;
using System.Web;
using System.Web.Mvc;
using WebSima.Models;
using WebSima.Models.WebApi;


namespace WebSima.Controllers
{
    public class HorarioController : Controller
    {
        //
        // GET: /Horario/

        public ActionResult Index()
        {
            return View();
        }




        //
        // GET: /Horario/Details/5

        public ActionResult Details(int id)
        {
            return View();
        }

        public ActionResult consultar_horario()
        {
           


            return View("select_administrador");
        }

        public ActionResult consultar_horario_monitor()
        {


            return View("select_monitor");
        }

       public ActionResult registrar_horario()
        {
            List<HorarioEstudiante> horario = null;
            horario = ConsumidorAppi.getHorarioEstudiante("2018-1", "CALCULO II");

            ViewBag.horarios = horario;
           

           







            return View("create_monitor");
        }

        //
        // GET: /Horario/Create

        public ActionResult Create()
        {
            return View();
        }

        //
        // POST: /Horario/Create

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
        // GET: /Horario/Edit/5

        public ActionResult Edit(int id)
        {
            return View();
        }

        //
        // POST: /Horario/Edit/5

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
        // GET: /Horario/Delete/5

        public ActionResult Delete(int id)
        {
            return View();
        }

        //
        // POST: /Horario/Delete/5

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

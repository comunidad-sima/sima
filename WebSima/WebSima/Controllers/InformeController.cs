using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace WebSima.Controllers
{
    public class InformeController : Controller
    {
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

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace WebSima.Controllers
{
    public class modalImformeController : Controller
    {
        //
        // GET: /detalles/

        public ActionResult Index()
        {
            return View();
        }

        //
        // GET: /detalles/Details/5

        public ActionResult Details(int id)
        {
            return View("../Views/informe/modal_informe.cshtml");
        }

        //
        // GET: /detalles/Create

        public ActionResult Create()
        {
            return View();
        }

        //
        // POST: /detalles/Create

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
        // GET: /detalles/Edit/5

        public ActionResult Edit(int id)
        {
            return View();
        }

        //
        // POST: /detalles/Edit/5

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
        // GET: /detalles/Delete/5

        public ActionResult Delete(int id)
        {
            return View();
        }

        //
        // POST: /detalles/Delete/5

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

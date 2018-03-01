using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebSima.Models;

namespace WebSima.Controllers
{
    public class ConfigAppController : Controller
    {
        private bd_simaEntitie db = new bd_simaEntitie();

        //
        // GET: /ConfigApp/

        public ActionResult Index()
        {
            return View(db.configuracion_app.ToList());
        }

        //
        // GET: /ConfigApp/Details/5

        public ActionResult Details(int id = 0)
        {
            configuracion_app configuracion_app = db.configuracion_app.Find(id);
            if (configuracion_app == null)
            {
                return HttpNotFound();
            }
            return View(configuracion_app);
        }

        //
        // GET: /ConfigApp/Create

        public ActionResult Create()
        {
            return View();
        }

        //
        // POST: /ConfigApp/Create

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(configuracion_app configuracion_app)
        {
            if (ModelState.IsValid)
            {
                db.configuracion_app.Add(configuracion_app);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(configuracion_app);
        }

        //
        // GET: /ConfigApp/Edit/5

        public ActionResult Edit(int id = 0)
        {
            configuracion_app configuracion_app = db.configuracion_app.Find(id);
            if (configuracion_app == null)
            {
                return HttpNotFound();
            }
            return View(configuracion_app);
        }

        //
        // POST: /ConfigApp/Edit/5

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(configuracion_app configuracion_app)
        {
            if (ModelState.IsValid)
            {
                db.Entry(configuracion_app).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(configuracion_app);
        }

        //
        // GET: /ConfigApp/Delete/5

        public ActionResult Delete(int id = 0)
        {
            configuracion_app configuracion_app = db.configuracion_app.Find(id);
            if (configuracion_app == null)
            {
                return HttpNotFound();
            }
            return View(configuracion_app);
        }

        //
        // POST: /ConfigApp/Delete/5

        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            configuracion_app configuracion_app = db.configuracion_app.Find(id);
            db.configuracion_app.Remove(configuracion_app);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            db.Dispose();
            base.Dispose(disposing);
        }
    }
}
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebSima.Models;

namespace WebSima.Controllers
{
    public class TestController : Controller
    {
        Sesion sesion = new Sesion();
        private bd_simaEntitie db = new bd_simaEntitie();
        //
        // GET: /Test/

        public ActionResult Index()
        {
            return View();
        }
        public ActionResult Home()
        {
            return View();
        }
        public ActionResult Listar()
        {
            if (sesion.esAdministrador(db))
            { 
                MPreguntas_test pre= new MPreguntas_test();
                return View(pre.getCapacitacionesPeriodo( db ,0));
            }
            return null;
        }
        public ActionResult add_pregunta()
        {
            if (sesion.esAdministrador(db))
            {

                return View();
            }else
            {
                return Redirect("~/Inicio/Login");
            }
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult add_pregunta(MPreguntas_test Mpregunta)
        {

            Respusta respuesta = new Respusta();
            if (sesion.esAdministrador(db))
            {
                if (ModelState.IsValid)
                {
                    preguntas_test pregunta = new preguntas_test();
                    pregunta.eliminado = 0;
                    pregunta.Pregunata = Mpregunta.Pregunata;
                    pregunta.tipo = Mpregunta.tipo;
                   bool respuesta_guardado= Mpregunta.guardar_pregunta(db, pregunta);
                   if (respuesta_guardado)
                   {
                       respuesta.RESPUESTA = "OK";
                       respuesta.MENSAJE = "Pregunta guardada correctamente.";
                   }
                   else
                   {
                       respuesta.RESPUESTA = "ERROR";
                       respuesta.MENSAJE = "Error al registrar la pregunta.";
                       
                   }
                }
                else
                {
                    respuesta.RESPUESTA = "ERROR";
                    respuesta.MENSAJE = "Los datos ingresados son incorrecotos.";
                }
            }
            else
            {
                respuesta.RESPUESTA = "LOGIN";
            }
            return Json(respuesta);
        }
        public ActionResult Crear()
        {
            if (sesion.esAdministrador(db))
            {
                List<MPreguntas_test> preguntas = (new MPreguntas_test()).getPreguntas_test(db, 0);
                ViewBag.preguntas = preguntas;
                return View("Crear_test");
            }
            else
            {
                return Redirect("~/Inicio/Login");
            }
           
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Crear(MTest Mtest, int[] id_preguntas=null)
        {
            Respusta respuesta = new Respusta();
            if( id_preguntas==null){
                respuesta.RESPUESTA = "ERROR";
                respuesta.MENSAJE = "Debe seleccionar al menos 1 pregunta.";
            }
            else if (sesion.esAdministrador(db))
            {
                if (ModelState.IsValid)
                {
                    Test test_ = new Test();
                    test_.eliminado = 0;
                    test_.estado_cierre = 0;
                    test_.id_usuario_creado = sesion.getIdUsuario();
                    test_.fecha_fin=Mtest.fecha_fin;
                    test_.fecha_inicio = Mtest.fecha_inicio;
                    test_.periodo = MConfiguracionApp.getPeridoActual(db);
                    test_.ferfil_usuario = Mtest.ferfil_usuario;


                    bool respuesta_guardado = Mtest.guardar_Test(db,test_, id_preguntas);
                    if (respuesta_guardado)
                    {
                        respuesta.RESPUESTA = "OK";
                        respuesta.MENSAJE = "Test guardada correctamente.";
                    }
                    else
                    {
                        respuesta.RESPUESTA = "ERROR";
                        respuesta.MENSAJE = "Error al registrar al Test.";

                    }
                }
                else
                {
                    respuesta.RESPUESTA = "ERROR";
                    respuesta.MENSAJE = "Los datos ingresados son incorrecotos.";
                }
            }
            else
            {
                respuesta.RESPUESTA = "LOGIN";
            }
            return Json(respuesta);
        }
        //
        // GET: /Test/Details/5

        public ActionResult Details(int id)
        {
            return View();
        }

        //
        // GET: /Test/Create

       
            public ActionResult crear_pregunta()
        {
            return View("add_pregunta");
        }

            public ActionResult Responder_test()
            {
                return View ("Responder_test");
            }

        public ActionResult Create()
        {
            return View();
        }

        //
        // POST: /Test/Create

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
        // POST: /Test/Delete/5
        [HttpPost]
        public JsonResult Delete(int id)
        {
            Respusta respuesta = new Respusta();

            if (sesion.esAdministrador(db))
            {
                preguntas_test pregnta = db.preguntas_test.Find(id);
                if (pregnta != null)
                {                    
                    pregnta.eliminado = 1;                    
                    db.Entry(pregnta).State = EntityState.Modified;
                    db.SaveChanges();
                    respuesta.RESPUESTA = "OK";
                    respuesta.MENSAJE = "Pregunta eliminada exite.";

                }
                else
                {
                    respuesta.RESPUESTA = "ERROR";
                    respuesta.MENSAJE = "Pregunta no exite.";
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

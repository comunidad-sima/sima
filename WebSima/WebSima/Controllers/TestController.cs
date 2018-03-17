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

       
        public ActionResult Home()
        {
            if (sesion.esAdministrador(db))
            {
                return View();
            }
            return Redirect("~/Inicio/Login");
        }
        public ActionResult Tests_responder()
        {
            if (!sesion.getIdUsuario().Equals("") && sesion.getIPerfilUsusrio().Equals("Estudiante"))
            {
                return View();
            }
            return Redirect("~/Inicio/Login");
        }
        public ActionResult Listar_test(String periodo ="")
        {
            if (sesion.esAdministrador(db))
            {
               

                List<MTest> tests = new List<MTest>();
                if (periodo.Equals("-1"))
                    tests = (new MTest().getTest_abiertos(db, 0, 0));
                else
                {
                    if (periodo.Equals(""))
                        periodo = MConfiguracionApp.getPeridoActual(db);
                    tests = (new MTest().getTestPeriodo(db, periodo, 1, 0));
                }
               
                return View("Listar_test", tests);
            }
            return null;
        }
        /// <summary>
        /// Lista las preguntas que estan registrdas en la db
        /// </summary>
        /// <returns></returns>
        public ActionResult Listar()
        {
            if (sesion.esAdministrador(db))
            { 
                MPreguntas_test pre= new MPreguntas_test();
                return View(pre.getCapacitacionesPeriodo( db ,0));
            }
            return null;
        }
        // formulario pregunta
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
        // agrega las preguntas de un test
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
        /// <summary>
        /// crear formulario crear test
        /// </summary>
        /// <returns></returns>
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
            if (sesion.esAdministrador(db))
            {
                return View("add_pregunta");
            }
            else
            {
                return Redirect("~/Inicio/Login");
            }
        }
        public ActionResult Historial_test()
        {

            if (sesion.esAdministrador(db))
            {
                List<SelectListItem> periodos = (db.cursos.Select(c => new SelectListItem
                {
                    Value = c.periodo,
                    Text = c.periodo
                }).Distinct()).ToList();
                ViewBag.periodos = periodos;
                return View("Historial_test");
            }
            return Redirect("~/Inicio/Login");

        }
            public JsonResult Guardar_respuesta()
            {
                Respusta respuesta = new Respusta();
                bool error = false;
                List<respuestas> respuestas=new List<respuestas>();
                List<MPreguntas_test> preguntas = null;
                MTest test = new MTest();
                //  se consultas las pregunta asignadas al test 
                preguntas = (test).getPreguntas_test_a_resonder(db, Convert.ToInt32(sesion.getId_test_responder()));
                if (preguntas.Count() == Request.Form.Count)
                {
                    foreach (MPreguntas_test mpreguta in preguntas)
                    {
                        // se consulta id de la relacion de las preguntas con el test
                        pregunta_test_responder pre_responder = test.getPregunta_test_responder(db,
                          Convert.ToInt32(sesion.getId_test_responder()), mpreguta.id);
                        String observacion = null;
                        int punto = 0;
                        if (mpreguta.tipo.Equals("Abierta"))
                        {
                            //los nombre de los inputs es el  id de la pregunta 
                            observacion = Request.Form["" + mpreguta.id];
                            if(observacion.Count()<=3){
                                respuesta.RESPUESTA = "ERROR";
                                respuesta.MENSAJE = "Las preguntas abiertas deben tener minimo tres caracteres en la respuesta.";
                                error = true;
                            }
                        }

                        else if (mpreguta.tipo.Equals("Cerrada"))
                        {
                            punto = Convert.ToInt32(Request.Form["" + mpreguta.id]);
                            if (punto < 1 || punto > 10)
                            {
                                error = true;
                                respuesta.RESPUESTA = "ERROR";
                                respuesta.MENSAJE = "Error en la respuesta de '" + mpreguta.Pregunata + "'.";
                            }

                        }

                        respuestas.Add(new respuestas
                        {
                            id_persona = sesion.getIdUsuario(),
                            observacion = observacion,
                            punto = punto,
                            id_preguntas_test_respustas = pre_responder.id,
                            id_curso=sesion.getIdCurso_test()


                        });
                       

                    }
                    if (!error)
                    {
                        bool respusta_ = test.guardar_respuestas_test(db, respuestas);
                        if (!respusta_)
                        {
                            respuesta.RESPUESTA = "ERROR";
                            respuesta.MENSAJE = "Error al guardar.";
                        }
                        else
                        {
                            respuesta.RESPUESTA = "OK";
                            respuesta.MENSAJE = "Su respuesta fue guardada con exito. Gracias por participar.";
                        }
                    }
                }
                else
                {
                    respuesta.RESPUESTA = "ERROR";
                    respuesta.MENSAJE = "Responda todas las preguntas antes de guardar.";
                }
               
                return Json(respuesta);
            }


            public ActionResult Responder_test()
            {
                //String periodo = MConfiguracionApp.getPeridoActual(db);
                if (sesion.esAdministrador(db))
                {
                    MTest mtest = (new MTest().getTestPorId(db, 4));
                    sesion.setId_test_responder(4);
                    sesion.setIdCurso_test(101);
                    List<MPreguntas_test> preguntas = null;
                    if (mtest != null)
                    {
                        preguntas = mtest.getPreguntas_test_a_resonder(db, mtest.id);
                    }
                    ViewBag.test = mtest;
                    ViewBag.preguntas = preguntas;
                    return View("Responder_test");
                }
                else
                {
                    return Redirect("~/Inicio/Login");
                }
            }

              

        

        //Elimina una pregunta de un test 
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

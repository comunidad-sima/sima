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

        public ActionResult Detalles(int id)
        {
            if (sesion.esAdministrador(db))
            {
                MTest mtAuxiliar =new MTest();
                MTest mtest = (mtAuxiliar.getTestPorId(db, id));
                if (mtest == null)
                    return Historial_test();

                List<MPreguntas_test> preguntas_test = mtAuxiliar.getPreguntas_test(db,id);
                ViewBag.preguntas=preguntas_test;
                return View(mtest);

            }
            return Redirect("~/Inicio/Login");
        }
        public ActionResult Home()
        {
            if (sesion.esAdministrador(db))
            {
                return View();
            }
            return Redirect("~/Inicio/Login");
        }

        public JsonResult Delete_test(int id)
        {

            Respuesta respuesta = new Respuesta();
            if (sesion.esAdministrador(db))
            {
                Test test = db.Test.Find(id);
                if (test != null)
                {
                    //if (cursos.clases_sima.Count() == 0)
                    //{
                    //db.cursos.Remove(cursos);
                    test.eliminado = 1;
                    test.estado_cierre = 1;
                    db.Entry(test).State = EntityState.Modified;
                    db.SaveChanges();
                    respuesta.RESPUESTA = "OK";

                }
                else
                {
                    respuesta.RESPUESTA = "ERROR";
                    respuesta.MENSAJE = "Test no exite.";
                }
            }
            else
            {
                respuesta.RESPUESTA = "LOGIN";
            }
            return Json(respuesta);

        }
        public ActionResult Tests(String mensaje = null)
        {
            if (!sesion.getIdUsuario().Equals("") && 
               (sesion.getIPerfilUsusrio().Equals("Estudiante")
               || sesion.getIPerfilUsusrio().Equals("Docente")))
            {
                Mclase mclase = new Mclase();
                List<MCurso> mcursos=null;  
                String periodo = MConfiguracionApp.getPeridoActual(db);
                // se consulta los grupos donde el estudiante a dado clase
                if(sesion.getIPerfilUsusrio().Equals("Estudiante"))
                         mcursos = mclase.getCursos_por_clase(db, periodo, sesion.getIdUsuario());
                else
                {
                    List<String> materiasDocente = new List<string>();
                    materiasDocente.Add("MATEMATICA BASICA");
                    materiasDocente.Add("CALCULO I");
                    mcursos= new List<MCurso> ();
                    foreach (String item in materiasDocente)
                    {
                       mcursos = mcursos.Union(MCurso.getCursoMateria(db, item, periodo)).ToList();
                    }
                }
                // DateTime.Now.ToString("yyyy-MM-dd HH-mm-ss-ff")
                DateTime fechaHoya = DateTime.Now;
                List<MTest> mtests = new MTest().getTest_abiertos(db, 0, 0);
                // se consultan solo los test de los monitores 
                mtests = (from c in mtests
                          where (DateTime.Compare(DateTime.Now, c.fecha_inicio)>=0 && c.periodo == periodo && c.eliminado == 0 && c.ferfil_usuario == sesion.getIPerfilUsusrio())
                          select c).ToList();
                // 1 se consultas la materias docentes 
                // 2 se consultas los grupos q tienen de cada materia 
                // 3 se 
                ViewBag.mtests = mtests;
                ViewBag.mcursos = mcursos;
                ViewBag.mensaje = mensaje;
                ViewBag.perfil = sesion.getIPerfilUsusrio();
                return View();
            }
            return Redirect("~/Inicio/Login");
        }
        public ActionResult Listar_test(String periodo = "")
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
                MPreguntas_test pre = new MPreguntas_test();
                return View(pre.getPreguntas(db, 0));
            }
            return null;
        }
        // formulario pregunta
        public ActionResult add_pregunta()
        {
            if (sesion.esAdministrador(db))
            {

                return View();
            }
            else
            {
                return Redirect("~/Inicio/Login");
            }
        }
        // agrega las preguntas de un test
        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult add_pregunta(MPreguntas_test Mpregunta)
        {

            Respuesta respuesta = new Respuesta();
            if (sesion.esAdministrador(db))
            {
                if (ModelState.IsValid)
                {
                    preguntas_test pregunta = new preguntas_test();
                    pregunta.eliminado = 0;
                    pregunta.Pregunata = Mpregunta.Pregunata;
                    pregunta.tipo = Mpregunta.tipo;
                    bool respuesta_guardado = Mpregunta.guardar_pregunta(db, pregunta);
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
        public ActionResult Crear(MTest Mtest, int[] id_preguntas = null)
        {
            Respuesta respuesta = new Respuesta();
            if (id_preguntas == null)
            {
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
                    test_.fecha_fin = Mtest.fecha_fin;
                    test_.fecha_inicio = Mtest.fecha_inicio;
                    test_.periodo = MConfiguracionApp.getPeridoActual(db);
                    test_.ferfil_usuario = Mtest.ferfil_usuario;


                    bool respuesta_guardado = Mtest.guardar_Test(db, test_, id_preguntas);
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

        public ActionResult Edit_test(int id)
        {
            if (sesion.esAdministrador(db))
            {
                MTest mtstAux = new MTest();
                 List<MPreguntas_test> preguntas = (new MPreguntas_test()).getPreguntas_test(db, 0);
                ViewBag.preguntas = preguntas;
                MTest mtst = (mtstAux.getTestPorId(db, id));
               List<MPreguntas_test> preguntaTest= mtstAux.getPreguntas_test(db, id);
               ViewBag.preguntas = preguntas;
               ViewBag.preguntaTest = preguntaTest;
                return View(mtst);
            }
            else
            {
                return Redirect("~/Inicio/Login");
            }
        }

        public ActionResult Evaluacion_test(int id, int grupo=-1)
        {

            try
            {

                if (sesion.esAdministradorOrMonitor(db))
                {
                    cursos c = db.cursos.Find(grupo);
                    if (sesion.esEstudiante())
                    {
                        c = (from c2 in db.cursos where (c2.id == grupo) select c2).First();
                    }
                    String titleBar = " - GENERAL";
                    if (grupo > 0)
                        titleBar = " - " + c.usuarios.nombre + " " + c.usuarios.apellidos + " - " + c.nombre_materia;
                    MTest mtAux = new MTest();
                    // es una lista[idPregunta, puntos]
                    List<String[]> puntosAll = mtAux.getPreguntaPuntosTotal(id, grupo);
                    List<String[]> comentarioPregunta = mtAux.getCometariosPreguntasAbiertaTest(id, grupo);
                    List<MPreguntas_test> preguntasAll = mtAux.getPreguntas_test(db, id).OrderBy(x => x.id).ToList();
                    int cantidad = mtAux.ContarCantidaUasuarioRespondenTest(id, grupo);
                    Test test = db.Test.Find(id);
                    List<MCurso> mcursos = MCurso.getCursos(db, "", test.periodo);
                    ViewBag.preguntasTest = preguntasAll;
                    ViewBag.puntoPreguntas = puntosAll;
                    ViewBag.comentarioPreguntas = comentarioPregunta;
                    ViewBag.id = id;
                    ViewBag.perfil = sesion.getIPerfilUsusrio();
                    ViewBag.cantidad = cantidad;
                    ViewBag.curos = mcursos;
                    ViewBag.id_curso = grupo;

                    ViewBag.titleBar = titleBar;
                    return View();

                }
                else
                {
                    return Redirect("~/Inicio/Login");
                }
            }
            catch (Exception)
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
        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult Guardar_respuesta()
        {
            Respuesta respuesta = new Respuesta();
            bool error = false;
            List<respuestas> respuestas = new List<respuestas>();
            List<MPreguntas_test> preguntas = null;
            MTest test = new MTest();
            //  se consultas las pregunta asignadas al test 
            preguntas = (test).getPreguntas_test_a_resonder(db, Convert.ToInt32(sesion.getId_test_responder()));
            // se resta uno por el toke de validacion
            if (preguntas.Count() == Request.Form.Count-1)
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
                        if (observacion.Count() <= 3)
                        {
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
                        id_curso = sesion.getIdCurso_test()


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

        public ActionResult Responder_test_docente(String test = "", String curso = "")
        {
            /// falta por verificar q el docente tiene esa signatura a partir del curso
            String mensaje = null;
            if (sesion.esDocente(db))
            {
                try
                {

                    int id_test = Convert.ToInt32(test);
                    int id_curso = Convert.ToInt32(curso);
                    String peridio = MConfiguracionApp.getPeridoActual(db);
                    MTest mtestAux = new MTest();
                    MTest testResponder = mtestAux.getTestPorId(db, id_test);

                    // se verifica q el perfil es el correcto y que el teste no este cerrado
                    if (testResponder.ferfil_usuario.Equals(sesion.getIPerfilUsusrio()) &&
                        testResponder.estado_cierre == 0 && testResponder.eliminado == 0 &&
                        testResponder.periodo.Equals(peridio))
                    {
                        
                            // se verfica si ya el docente ha respondeido el test
                            bool respondio = mtestAux.isRespondioTest(id_curso, id_test);
                            if (!respondio)
                            {
                                MTest mtest = (mtestAux.getTestPorId(db, id_test));
                                if (DateTime.Compare(DateTime.Now, mtest.fecha_inicio) >= 0)
                                {
                                    sesion.setId_test_responder(id_test);
                                    sesion.setIdCurso_test(id_curso);
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
                                    mensaje = "Test no está disponible.";
                                }
                            }
                            else
                            {
                                mensaje = "Usted ya respondió el test seleccionado.";
                            }
                        }
                        
                    else
                    {
                        mensaje = "Usted no está seleccionado para responder este test o el test está finalizado";
                    }
                }
                catch (Exception)
                {

                    mensaje = "Datos de entrada incorrectos";
                }

                return Redirect("~/Test/Tests/?mensaje=" + mensaje);
            }
            else
            {
                return Redirect("~/Inicio/Login");
            }
        }
        public ActionResult Responder_test(String test = "", String curso = "")
        {
            String mensaje = null;
            if (sesion.esEstudiante())
            {
                try
                {

                    int id_test = Convert.ToInt32(test);
                    int id_curso = Convert.ToInt32(curso);
                    String peridio = MConfiguracionApp.getPeridoActual(db);
                    MTest mtestAux = new MTest();
                    MTest testResponder = mtestAux.getTestPorId(db, id_test);

                    // se verifica q el perfil se el correcto y que el teste no este cerrado
                    if (testResponder.ferfil_usuario.Equals(sesion.getIPerfilUsusrio()) && 
                        testResponder.estado_cierre == 0 && testResponder.eliminado == 0&&
                        testResponder.periodo.Equals(peridio))
                    {
                        // se verifica q haya asistido al menos a una calse del curso
                        if (new Mclase().getClaseAsistedaEstudianteEnGrupo(db, id_curso, sesion.getIdUsuario()) > 0)
                        {
                            // se verfica si ya el estudiante ha respondeido el test
                            bool respondio = mtestAux.isRespondioTest(id_curso, id_test);
                            if (!respondio)
                            {
                                //DateTime.Compare(DateTime.Now, c.fecha_inicio)>=0 &&
                                MTest mtest = (mtestAux.getTestPorId(db, id_test));
                                if (DateTime.Compare(DateTime.Now, mtest.fecha_inicio) >= 0)
                                {
                                    sesion.setId_test_responder(id_test);
                                    sesion.setIdCurso_test(id_curso);
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
                                    mensaje = "Test no esta disponible.";
                                }
                            }
                            else
                            {
                                mensaje = "Usted ya respondió el test seleccionado.";
                            }
                        }
                        else
                        {
                            mensaje = "usted no está apto para responder el test.";
                        }
                    }
                    else
                    {
                        mensaje = "Usted no está seleccionado para responder este test o el test está finalizado";
                    }
                }
                catch (Exception)
                {

                    mensaje = "Datos de entrada incorrectos";
                }

                return Redirect("~/Test/Tests/?mensaje=" + mensaje);
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
            Respuesta respuesta = new Respuesta();

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
        public ActionResult Test_monitor()
        {
            if (sesion.esMonitor(db))
            {
                List<MTest> tests = new List<MTest>();
                List<MCurso> cursos = MCurso.getCursoAcargoActivos(db, MConfiguracionApp.getPeridoActual(db), sesion.getIdUsuario());

                tests = tests.Union((new MTest().getTest_abiertos(db, 0, 0))).ToList();
                tests = tests.Union((new MTest().getTest_abiertos(db, 1, 0))).ToList();
                tests = (from t in tests where (DateTime.Compare(DateTime.Now, t.fecha_inicio) >= 0 && t.periodo == MConfiguracionApp.getPeridoActual(db)) select t).ToList();



                ViewBag.cursos = cursos;
                return View(tests);
            }
            else return Redirect("~/Inicio/Login");
        }

        public ActionResult Edit_Pregunta(int id)
        {
            if (sesion.esAdministrador(db))
            {
                MPreguntas_test pregunta = (new MPreguntas_test()).getPreguntaId(db, id);
                if (pregunta == null)
                {
                    return HttpNotFound();
                }
                return View(pregunta);
            }
            else
            {
                return Redirect("~/Inicio/Login");
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult Edit_Pregunta(MPreguntas_test pregunta)
        {
            Respuesta respuesta = new Respuesta();
            if (sesion.esAdministrador(db))
            {
               
                if (ModelState.IsValid)
                {
                   bool actualizado= new MPreguntas_test().actualizar_pregunta(db, pregunta);
                   if (!actualizado)
                   {
                       respuesta.RESPUESTA = "ERROR";
                       respuesta.MENSAJE = "Error en la actualización.";
                   }
                   else
                   {
                       respuesta.RESPUESTA = "OK";
                       respuesta.MENSAJE = "Pregunta actualizada";
                   }
                }
                else
                {
                    respuesta.RESPUESTA = "ERROR";
                    respuesta.MENSAJE = "Datos incorrectos.";
                }
            }
            else
            {
                respuesta.RESPUESTA = "LOGIN";
            }
            return Json(respuesta);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult Edit_test(MTest Mtest, int[] id_preguntas = null)
        {
            Respuesta respuesta = new Respuesta();
            if (id_preguntas == null)
            {
                respuesta.RESPUESTA = "ERROR";
                respuesta.MENSAJE = "Debe seleccionar al menos 1 pregunta.";
            }
            else if (sesion.esAdministrador(db))
            {
                if (ModelState.IsValid)
                {
                    
                    


                    bool respuesta_guardado = Mtest.actualizar_test(db, Mtest);
                    if (respuesta_guardado)
                    {
                        respuesta.RESPUESTA = "OK";
                        respuesta.MENSAJE = "Test actualizado correctamente.";
                        bool pregunta_save = Mtest.guardar_Test(db, null, id_preguntas, Mtest.id);
                        if (!pregunta_save)
                        {
                            respuesta.RESPUESTA = "NO_PREGUNTA";
                            respuesta.MENSAJE = "Los datos principales del test se actualizaron.<br>"+
                            "Las preguntas no fueron editadas porque los ususrios comezarón a responder el test.";
                        }
                    }
                    else
                    {
                        respuesta.RESPUESTA = "ERROR";
                        respuesta.MENSAJE = "Error al actualizar al Test.";

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
        protected override void Dispose(bool disposing)
        {
            db.Dispose();
            base.Dispose(disposing);
        }
    }
}

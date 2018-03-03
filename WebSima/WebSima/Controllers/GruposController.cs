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
    public class GruposController : Controller
    {
        private bd_simaEntitie db = new bd_simaEntitie();
        Sesion sesion = new Sesion();
      

        //
        // GET: /Grupos/

        public ActionResult Index()
        {
            String periodo = MConfiguracionApp.getPeridoActual(db);
            String idUsuario=sesion.getIdUsuario();
            List<List<AsignaturaGrupo>> datos = new List<List<AsignaturaGrupo>>();
            List<String> materias_ = MCurso.getNombreMateriaMonitorDeCursos(db, idUsuario, periodo, 1);

            List<AsignaturaGrupo> datos_2 = null;
            // se consultan los grupos de cada materia
            foreach (String materia_ in materias_)
            {
                if (!materia_.Equals(""))
                {
                    datos_2 = ConsumidorAppi.getGruposMaterias(periodo, materia_);
                    if (datos_2 == null)
                        ViewBag.mensajeError = "Error al cargar los datos, compruebe su conexión a internet.";
                    else
                    {
                        datos.Add(datos_2);
                    }
                }
            }
            List<grupos_acargo> grupos_acargo = (new MGrupos_acargo().getGrupuposPerido(db,idUsuario,periodo));
            
            ViewBag.datos = datos;
            ViewBag.grupos_acargo = grupos_acargo;
            ViewBag.materiasMonitor = materias_;

            return View(new grupos_acargo());
        }


        [HttpPost]
        public JsonResult SetGrupos(String[] idGrupo = null)
        {
            String periodo = MConfiguracionApp.getPeridoActual(db);
            String idMonitor = sesion.getIdUsuario();

            string[] carrera_idCurso;
            // se obtien el id del grupo a partir de la materia y el id del monitor  y perido 
            int idCuro;

            bool error = false;
            Respusta respuesta = new Respusta();

            using (var transaccion = new TransactionScope())
            {
                using (var contestTransaccion = new bd_simaEntitie())
                {
                    try
                    {
                        if (idGrupo != null)
                        {
                            List<String> materias = new List<string>();


                            // Se seleccionan las asinaturas
                            String[] grupo;
                            foreach (String element in idGrupo)
                            {
                                grupo = element.Split('|');
                                materias.Add(grupo[2]);
                            }
                            materias = ((from d in materias select d).Distinct()).ToList();

                            //foreach (String materia in materias)
                            //{
                                //idCuro = MCurso.getIdCurso(db, materia, periodo, idMonitor);

                                //se consulta los grupos registradas de una asinatura y se leiminamos 
                                List<grupos_acargo> consulta = (
                                          from p in contestTransaccion.grupos_acargo
                                          where p.idUsuario == idMonitor  && p.periodo == periodo 
                                          select p
                                         ).ToList();

                                foreach (grupos_acargo element in consulta)
                                {
                                    contestTransaccion.grupos_acargo.Remove(element);
                                    contestTransaccion.SaveChanges();
                                }
                            //}


                            foreach (String element in idGrupo)
                            {
                                carrera_idCurso = element.Split('|');
                                String materiatem = carrera_idCurso[2];
                                idCuro = MCurso.getIdCurso(db, materiatem, periodo, idMonitor);

                                grupos_acargo gruposAcargos = new grupos_acargo();
                                gruposAcargos.idUsuario = idMonitor;
                                gruposAcargos.materia = materiatem;
                                gruposAcargos.periodo = periodo;
                                gruposAcargos.id_grupo = carrera_idCurso[1];
                                gruposAcargos.programa = carrera_idCurso[0];
                                gruposAcargos.id_curso = idCuro;
                                contestTransaccion.grupos_acargo.Add(gruposAcargos);
                                contestTransaccion.SaveChanges();
                            }
                        }
                        else
                        {
                            error = true;
                            respuesta.RESPUESTA = "ERROR";
                            respuesta.MENSAJE = "Debe seleccionar al menos un grupo.";
                        }
                    }
                    catch (Exception)
                    {
                        error = true;
                        respuesta.RESPUESTA = "ERROR";
                        respuesta.MENSAJE = "No se pudo actualizar los grupos.";
                    }
                    if (!error)
                    {
                        transaccion.Complete();
                        respuesta.RESPUESTA = "OK";
                        respuesta.MENSAJE = "Grupos actualizados.";
                    }
                }
            }
            return Json(respuesta);
        }
        //
        // GET: /Grupos/Details/5

        public ActionResult Details(int id = 0)
        {
            grupos_acargo grupos_acargo = db.grupos_acargo.Find(id);
            if (grupos_acargo == null)
            {
                return HttpNotFound();
            }
            return View(grupos_acargo);
        }

        //
        // GET: /Grupos/Create

        public ActionResult Create()
        {
            ViewBag.id_curso = new SelectList(db.cursos, "id", "periodo");
            ViewBag.materia = new SelectList(db.materias, "nombre", "nombre");
            ViewBag.idUsuario = new SelectList(db.usuarios, "id", "nombre");
            return View();
        }

        //
        // POST: /Grupos/Create

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(grupos_acargo grupos_acargo)
        {
            if (ModelState.IsValid)
            {
                db.grupos_acargo.Add(grupos_acargo);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.id_curso = new SelectList(db.cursos, "id", "periodo", grupos_acargo.id_curso);
            ViewBag.materia = new SelectList(db.materias, "nombre", "nombre", grupos_acargo.materia);
            ViewBag.idUsuario = new SelectList(db.usuarios, "id", "nombre", grupos_acargo.idUsuario);
            return View(grupos_acargo);
        }

        //
        // GET: /Grupos/Edit/5

        public ActionResult Edit(int id = 0)
        {
            grupos_acargo grupos_acargo = db.grupos_acargo.Find(id);
            if (grupos_acargo == null)
            {
                return HttpNotFound();
            }
            ViewBag.id_curso = new SelectList(db.cursos, "id", "periodo", grupos_acargo.id_curso);
            ViewBag.materia = new SelectList(db.materias, "nombre", "nombre", grupos_acargo.materia);
            ViewBag.idUsuario = new SelectList(db.usuarios, "id", "nombre", grupos_acargo.idUsuario);
            return View(grupos_acargo);
        }

        //
        // POST: /Grupos/Edit/5

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(grupos_acargo grupos_acargo)
        {
            if (ModelState.IsValid)
            {
                db.Entry(grupos_acargo).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.id_curso = new SelectList(db.cursos, "id", "periodo", grupos_acargo.id_curso);
            ViewBag.materia = new SelectList(db.materias, "nombre", "nombre", grupos_acargo.materia);
            ViewBag.idUsuario = new SelectList(db.usuarios, "id", "nombre", grupos_acargo.idUsuario);
            return View(grupos_acargo);
        }

        //
        // GET: /Grupos/Delete/5

        public ActionResult Delete(int id = 0)
        {
            grupos_acargo grupos_acargo = db.grupos_acargo.Find(id);
            if (grupos_acargo == null)
            {
                return HttpNotFound();
            }
            return View(grupos_acargo);
        }

        //
        // POST: /Grupos/Delete/5

        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            grupos_acargo grupos_acargo = db.grupos_acargo.Find(id);
            db.grupos_acargo.Remove(grupos_acargo);
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
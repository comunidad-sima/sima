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
    public class CursoController : Controller
    {
        
        Sesion sesion = new Sesion();
        private bd_simaEntitie db = new bd_simaEntitie();
       // String periodo = MConfiguracionApp.getPeridoActual(db);

        public ActionResult Home()
        {
            if (sesion.esAdministrador(db))
            {
                IEnumerable<SelectListItem> periodos = null;
                IEnumerable<SelectListItem> materias = null;
               
                    // ViewBag.materias = MMateria.getMaterias(db);
                   
                    periodos = db.cursos.Select(c => new SelectListItem
                    {
                        Value = c.periodo,
                        Text = c.periodo
                    }).Distinct();

                    materias = db.cursos.Select(c => new SelectListItem
                    {
                        Value = c.nombre_materia,
                        Text = c.nombre_materia
                    }).Distinct();
                    ViewBag.periodos = periodos;
                    ViewBag.materias = materias;
                
                return View();
            }
            else
            {
                return Redirect("~/Inicio/Login");
            }
        }

        //
        // GET: /Curso/

        public ActionResult Listar(String materiaBuscar = "", String periodoBuscar = "2017-2")
        {


            if (sesion.esAdministrador(db))
            {

                List<MCurso> cursos = new List<MCurso>();
                try
                {
                    cursos =new  MCurso().getCursos(materiaBuscar, periodoBuscar);
                }
                catch (Exception)
                {

                }              
                return View(cursos);
            }
            else
            {
                return null;
                //return Redirect("~/Inicio");
            }
        }

        //
        // GET: /Curso/Details/5

        public ActionResult Details(int id = 0)
        {

            if (sesion.esAdministrador(db))
            {
                MCurso cursos = new MCurso().getCursoId(id);
                if (cursos == null)
                {
                    return HttpNotFound();
                }
                ViewBag.usuario = new MUsuario().getUsuarioId(cursos.idUsuario);
                return View(cursos);
            }
            else
            {
                return Redirect("~/Inicio");
            }
        }


        //
        // GET: /Curso/Create

        public ActionResult Create()
        {

            if (sesion.esAdministrador(db))
            {

                ViewBag.materias = new SelectList(new MMateria().getMaterias(db), "Value", "Text"); 
                return View();
            }
            else
            {
                return Redirect("~/Inicio");
            }
        }


        //
        // POST: /Curso/Create

        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult Create(MCurso curso)
        {
           String periodo = MConfiguracionApp.getPeridoActual(db);
            Respuesta respuesta = new Respuesta();
            if (sesion.esAdministrador(db))
            {

                if (ModelState.IsValid)
                {

                    materias materia = db.materias.Find(curso.nombre_materia);
                    MUsuario usuario = new MUsuario().getUsuarioId(curso.idUsuario);
                    bool tieneCurso = curso.tieneCurso(curso.idUsuario, curso.nombre_materia, periodo);
                    if (!tieneCurso)
                    {
                        if (materia != null)
                        {
                            if (usuario != null)
                            {
                                cursos cur = new cursos
                                {
                                    estado = curso.estado,
                                    fecha_finalizacion = curso.fecha_finalizacion,
                                    idUsuario = curso.idUsuario,
                                    nombre_materia = curso.nombre_materia.ToUpper(),
                                    periodo = periodo,
                                    eliminado=0
                                };
                                db.cursos.Add(cur);
                                db.SaveChanges();
                                respuesta.RESPUESTA = "OK";
                                respuesta.MENSAJE = "Grupo guardado.";
                            }
                            else
                            {
                                respuesta.RESPUESTA = "ERROR";
                                respuesta.MENSAJE = "Usuario " + curso.idUsuario + " no existe ";
                            }
                        }
                        else
                        {
                            respuesta.RESPUESTA = "ERROR";
                            respuesta.MENSAJE = "La Asignatura '" + curso.nombre_materia + "' no existe";
                        }
                    }
                    else
                    {
                        respuesta.RESPUESTA = "ERROR";
                        respuesta.MENSAJE = "Él Monitor " + curso.idUsuario + " tiene a cargo " + curso.nombre_materia + ".";
                    }
                }
                else
                {
                    respuesta.RESPUESTA = "ERROR";
                    respuesta.MENSAJE = "Datos incorrecto.";

                }   
            }
            else
            {
                respuesta.RESPUESTA = "LOGIN";    
            }
            return Json(respuesta);
        }

        //
        // GET: /Curso/Edit/5

        public ActionResult Edit(int id = 0)
        {

            if (sesion.esAdministrador(db))
            {
                MCurso cursos =new MCurso().getCursoId(id);
                if (cursos == null)
                {
                    return HttpNotFound();
                }
                ViewBag.materias = new SelectList(new MMateria().getMaterias(db), "Value", "Text"); ;
                //   ViewBag.cur_idUsuario = new SelectList(db.usuarios, "usu_id", "usu_nombre", cursos.cur_idUsuario);
                return View(cursos);
            }
            else
            {
                return Redirect("~/Inicio");
            }
        }

        //
        // POST: /Curso/Edit/5

        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult Edit(MCurso curso)
        {
            String periodo = MConfiguracionApp.getPeridoActual(db);
            Respuesta respuesta = new Respuesta();

            if (sesion.esAdministrador(db))
            {
                try
                {
                    if (ModelState.IsValid)
                    {
                        String materiaAntigua;
                        MMateria materia =new MMateria().getMateriaId(db,curso.nombre_materia);
                        MUsuario usuario = new MUsuario().getUsuarioId(curso.idUsuario);
                        bool tieneCurso = curso.tieneCurso(curso.idUsuario, curso.nombre_materia, periodo);
                        MCurso c = curso.getCursoId(curso.id);
                        materiaAntigua = c.nombre_materia;

                        if (materiaAntigua.Equals(curso.nombre_materia) || !tieneCurso)
                        {
                            if (materia != null)
                            {
                                if (usuario != null)
                                {
                                    if (curso.actualizar(db, curso) > 0)
                                    {

                                        respuesta.RESPUESTA = "OK";
                                        respuesta.MENSAJE = "Grupo actualizado.";
                                    }
                                    else
                                    {
                                        respuesta.RESPUESTA = "ERROR";
                                        respuesta.MENSAJE = "Grupo no actualizado.";
                                    }
                                }
                                else
                                {
                                    respuesta.RESPUESTA = "ERROR";
                                    respuesta.MENSAJE = "Usuario " + curso.idUsuario + " no existe ";
                                }

                            }

                            else
                            {
                                respuesta.RESPUESTA = "ERROR";
                                respuesta.MENSAJE = "La Asignatura '" + curso.nombre_materia + "' no existe";
                            }
                        }

                        else
                        {
                            respuesta.RESPUESTA = "ERROR";
                            respuesta.MENSAJE = "Él Monitor " + curso.idUsuario + " tiene a cargo " + curso.nombre_materia + ".";
                        }
                    }
                    else
                    {
                        respuesta.RESPUESTA = "ERROR";
                        respuesta.MENSAJE = "Datos incorrectos.";
                    }

                }
                catch (Exception e)
                {
                    respuesta.RESPUESTA = "ERROR";
                    respuesta.MENSAJE = "Error! " + e.Message + ".";
                }               
            }
            else
            {
                respuesta.RESPUESTA = "LOGIN";
            }
            return Json(respuesta);
        }

        //
        // GET: /Curso/Delete/5

      /*  public ActionResult Delete(int id = 0)
        {

            if (sesion.esUsuarioValido(db, "Administrador"))
            {
                MCurso curso = MCurso.getCursoId(db, id);
                if (curso == null)
                {
                    return HttpNotFound();
                }
                return View(curso);
            }
            else
            {
                return Redirect("~/Inicio");
            }
        }
        */
        //
        // POST: /Curso/Delete/5

        [HttpPost]
       
        public JsonResult Delete(int id)
        {
            Respuesta respuesta = new Respuesta();
            if (sesion.esAdministrador(db))
            {

                if (new MCurso().eliminar(db, id) > 0)
                {
                    respuesta.RESPUESTA = "OK";
                    respuesta.RESPUESTA = "Grupo eliminado.";
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
        [HttpPost]
        public JsonResult Monitores(String buscar)
        {
            List<MUsuario> ususriosMonitores = new MUsuario().getMonitores(buscar);
            return Json(ususriosMonitores);
        }
        [HttpPost]
        public JsonResult GetUsuario(String id)
        {
            
            MUsuario usuario = new MUsuario().getUsuarioId(id);
            if (usuario != null  )
            {
                if (usuario.eliminado == 0)
                     usuario=null;
                else
                    usuario.contrasena = "";
            }
            return Json(usuario);
        }
    }
}
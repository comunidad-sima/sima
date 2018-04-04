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
                    cursos = MCurso.getCursos(db, materiaBuscar, periodoBuscar);
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
                MCurso cursos = MCurso.getCursoId(db, id);
                if (cursos == null)
                {
                    return HttpNotFound();
                }
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

                ViewBag.materias = new SelectList(MMateria.getMaterias(db), "Value", "Text"); 
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
                    usuarios usuario = db.usuarios.Find(curso.idUsuario);
                    bool tieneCurso = MCurso.tieneCurso(db, curso.nombre_materia, periodo, curso.idUsuario);
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
                                    eliminado=0,
                                    usuarios = usuario
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
                MCurso cursos = MCurso.getCursoId(db, id);
                if (cursos == null)
                {
                    return HttpNotFound();
                }
                ViewBag.materias = new SelectList(MMateria.getMaterias(db), "Value", "Text"); ;
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
                        materias materia = db.materias.Find(curso.nombre_materia);
                        usuarios usuario = db.usuarios.Find(curso.idUsuario);
                        bool tieneCurso = MCurso.tieneCurso(db, curso.nombre_materia, periodo, curso.idUsuario);
                        cursos c = db.cursos.Find(curso.id);
                        materiaAntigua = c.nombre_materia;

                        if (materiaAntigua.Equals(curso.nombre_materia) || !tieneCurso)
                        {
                            if (materia != null)
                            {
                                if (usuario != null)
                                {
                                    c.estado = curso.estado;
                                    c.fecha_finalizacion = curso.fecha_finalizacion;
                                    c.idUsuario = curso.idUsuario;
                                    c.nombre_materia = curso.nombre_materia.ToUpper();

                                    db.Entry(c).State = EntityState.Modified;
                                    db.SaveChanges();

                                    respuesta.RESPUESTA = "OK";
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
                cursos cursos = db.cursos.Find(id);
                if (cursos != null)
                {
                    //if (cursos.clases_sima.Count() == 0)
                    //{
                        //db.cursos.Remove(cursos);
                        cursos.eliminado = 1;
                        cursos.estado = 0;
                        db.Entry(cursos).State = EntityState.Modified;
                        db.SaveChanges();
                        respuesta.RESPUESTA = "OK";

                    //}
                    if (cursos.clases_sima.Count() > 0) // else
                    {
                        respuesta.RESPUESTA = "ERROR";
                        respuesta.MENSAJE = "Grupo no se puede eliminar por completo porque tiene clases registradas, solo se marcara como eliminado";
                    }
                }
                else
                {
                    respuesta.RESPUESTA = "ERROR";
                    respuesta.MENSAJE = "Curso no exite.";
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
            List<MUsuario> ususriosMonitores = MUsuario.getMonitores(db, buscar);
            return Json(ususriosMonitores);
        }
        [HttpPost]
        public JsonResult GetUsuario(String id)
        {
            MUsuario usuario = null;
            usuarios user = db.usuarios.Find(id);
            if (user != null && user.eliminado == 0)
            {
                usuario = new MUsuario
                {
                    id = user.id,
                    nombre = user.nombre,
                    apellidos = user.apellidos,
                    correo = user.correo,
                    celular = user.celular,
                    tipo = user.tipo,
                    contrasena = user.contrasena,
                    fecha_registro = user.fecha_registro
                };
            }


            return Json(usuario);
        }
    }
}
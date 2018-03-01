﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebSima.Models;
using WebSima.Models.WebApi;
using System.Transactions;
using WebSima.clases;
namespace WebSima.Controllers
{
    public class ClaseController : Controller
    {
       
        //String tipo_usuario = "Monitor";
         String nombreCarpeta = "~/Uploads";
        private bd_simaEntitie db = new bd_simaEntitie();
        private Sesion sesion = new Sesion();

        //
        // GET: /Clase/

        public ActionResult Index(String materia="")
        {
            String periodo = MConfiguracionApp.getPeridoActual(db);
            if (sesion.esMonitor(db))
            {

                ViewBag.materiaSeleccionada = materia;
                // var clases_sima = db.clases_sima.Include(c => c.cursos).Include(c => c.usuarios);
                ViewBag.materiasMonitor = MCurso.getNombreMateriaMonitorDeCursos(db, sesion.getIdUsuario(), periodo, 1);
                return View(Mclase.getClasesMonitorPerido(db, periodo, sesion.getIdUsuario(), materia));
            }
            else
            {
                return Redirect("~/Inicio/Login");
            }
        }
        public ActionResult Avance(String materia = "", String periodoBuscar = "2017-2", String idMonitor = "")
        {
            String periodo = MConfiguracionApp.getPeridoActual(db);
            if (sesion.esAdministrador(db))
            {
                if (idMonitor.Equals("")) materia = "";

                ViewBag.materiaSeleccionada = materia;
                ViewBag.periodoSeleccionada = periodoBuscar;
                ViewBag.idMonitorSeleccionado = idMonitor;
                ViewBag.periodos = Mclase.getPeriodosRegistradosDeClase(db);
                ViewBag.datosMoniotres = MUsuario.getDatosMonitoresPeriodo(db, periodoBuscar);

                ViewBag.materiasMonitor = MCurso.getMateriasMonitorAcargo(db, idMonitor, periodo);

                ViewBag.peridoSeleccionado = periodoBuscar;
                ViewBag.monitorSeleccionado = idMonitor;

                return View(Mclase.getClasesMonitorPerido(db, periodo, idMonitor, materia));
            }
            else
            {
                return Redirect("~/Inicio/Login");
            }
        }

        public ActionResult Registros(String materia = "",String periodoBuscar="2017-2",String idMonitor="")
        {
            String periodo = MConfiguracionApp.getPeridoActual(db);
            if (sesion.esAdministrador(db))
            {
                if (idMonitor.Equals("")) materia = "";

                ViewBag.materiaSeleccionada = materia;
                ViewBag.periodoSeleccionada = periodoBuscar;
                ViewBag.idMonitorSeleccionado = idMonitor;
                ViewBag.periodos = Mclase.getPeriodosRegistradosDeClase(db);
                ViewBag.datosMoniotres = MUsuario.getDatosMonitoresPeriodo(db, periodoBuscar);

                ViewBag.materiasMonitor = MCurso.getMateriasMonitorAcargo(db, idMonitor, periodo);

                ViewBag.peridoSeleccionado = periodoBuscar;
                ViewBag.monitorSeleccionado = idMonitor;

                return View(Mclase.getClasesMonitorPerido(db, periodo, idMonitor, materia));
            }
            else
            {
                return Redirect("~/Inicio/Login");
            }
        }

        //
        // GET: /Clase/Details/5

        public ActionResult Details(int id = 0)
        {
            String periodo = MConfiguracionApp.getPeridoActual(db);
            if (!sesion.getIdUsuario().Equals(""))
            {
                ViewBag.perfil = sesion.getIPerfilUsusrio();
                clases_sima clases_sima = db.clases_sima.Find(id);
                if (clases_sima == null)
                {
                    return HttpNotFound();
                }
                List<String> idEstudiantes = clases_sima.estudiantes_asistentes.Select(x => x.estudiante_id).ToList();
                
                List<EstudianteMateria> estudiantes = null;
                if (idEstudiantes.Count() > 0)
                {
                   estudiantes= ConsumidorAppi.getDatosEstudiantesMateria(periodo, clases_sima.cursos.nombre_materia, idEstudiantes);
                }
                ViewBag.estudiantes = estudiantes;
                return View(clases_sima);
            }
            else
            {
                return Redirect("~/Inicio/Login");
            }
        }

        //
        // GET: /Clase/Create

        public ActionResult Create(String materia="")
        {
            String periodo = MConfiguracionApp.getPeridoActual(db);
            if (sesion.esMonitor(db))
            {

                ViewBag.materiasMonitor = null;
                
                    String id_usuario = sesion.getIdUsuario();
                    var tienMateria = MCurso.tieneCurso(db, materia, periodo, id_usuario);
                    if (tienMateria)
                    {
                        List<grupos_acargo> grupos_acargo = (new MGrupos_acargo().getGrupuposPeridoMateria(db, id_usuario, periodo, materia));
                        sesion.setMateria(materia);
                        List<EstudianteMateria> estudiantes = null;
                        if (!materia.Equals(""))
                        {
                            estudiantes = ConsumidorAppi.getEstudiantesMateria(periodo, materia);
                            if (estudiantes == null)
                                ViewBag.mensajeError = "Error al cargar los datos, compruebe su conexión a internet.";
                        }

                        ViewBag.estudiantes = estudiantes;
                        ViewBag.grupos_acargo = grupos_acargo;
                    }
                    else if (!materia.Equals(""))
                    {
                        ViewBag.mensajeError = "Asignatura '" + materia + "' No válida";
                        materia = "";
                    }
                    // ViewBag.cla_cursos_id = new SelectList(db.cursos, "cur_id", "cur_periodo");
                    // ViewBag.cla_usuarios_id = new SelectList(db.usuarios, "usu_id", "usu_nombre");
                    ViewBag.materiasMonitor = MCurso.getNombreMateriaMonitorDeCursos(db, id_usuario, periodo, 1);
                    ViewBag.materiaSeleccionada = materia;
                    return View();
                
               
            }
            else
            {
                return Redirect("~/Inicio/Login");
            }
        }

        //
        // POST: /Clase/Create

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(Mclase clase,String[]asistentes=null)
        {
            String periodo = MConfiguracionApp.getPeridoActual(db);
            if (sesion.esMonitor(db))
            {
                try
                {
                    

                        if (ModelState.IsValid)
                        {
                            string ruta = Server.MapPath(nombreCarpeta);
                            String materia = sesion.getMateria();
                            String idMonitor = sesion.getIdUsuario();
                            // se verifica que tenga la materia a cargo para evitar que se cambie el monbre de la materia en el select
                            var tienMateria = MCurso.tieneCurso(db, materia, periodo, idMonitor);
                            if (tienMateria)
                            {
                                // se guardan los ficheros
                                String[] resultado = Archivo.subir(Request.Files, ruta);
                                // si se guarda el fichero en el servidor, se guarda el registro en la BD
                                if (resultado[0].Equals("ok"))
                                {
                                    using (var transaccion = new TransactionScope())
                                    {
                                        using (var contestTransaccion = new bd_simaEntitie())
                                        {

                                            // se obtien la fecha actual
                                            DateTime fechaRegistro = DateTime.Now;
                                            // se obtien el id del grupo a partir de la materia y el id del monitor  y perido 
                                            int idCuro = MCurso.getIdCurso(contestTransaccion, materia, periodo, idMonitor);
                                            if (idCuro != -1)
                                            {
                                                clases_sima clase_ = new clases_sima
                                                {
                                                    comentario = clase.comentario,
                                                    fecha_realizada = clase.fecha_realizada,
                                                    periodo = periodo,
                                                    tema = clase.tema,
                                                    evidencia = resultado[1],
                                                    cursos_id = idCuro,
                                                    usuarios_id = idMonitor,
                                                    fecha_registro = fechaRegistro

                                                };
                                                contestTransaccion.clases_sima.Add(clase_);
                                                contestTransaccion.SaveChanges();

                                                // se agregan los estudiantes asistentes 
                                                if (clase.guardarAsistentes(contestTransaccion, clase_, asistentes))
                                                {
                                                    // si los asistentes se registras se guardan los cambisos en bd 
                                                    transaccion.Complete();
                                                    sesion.setMateria("");
                                                }
                                                return RedirectToAction("Index");
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    ViewBag.mensajeError = resultado[1];
                                }
                            }
                            else
                            {
                                ViewBag.mensajeError = "Asignatura " + materia + " No valida";
                                sesion.setMateria("");
                            }
                        }
                        ViewBag.materiaSeleccionada = sesion.getMateria();
                        return View(clase);
                    
                }
                catch (Exception e)
                {
                    ViewBag.mensajeError = "Error!!. " + e.Message;
                }
                return RedirectToAction("Index");
            }
            else
            {
                return Redirect("~/Inicio/Login");
            }
        }

        
       

        protected override void Dispose(bool disposing)
        {
            db.Dispose();
            base.Dispose(disposing);
        }
    }
}
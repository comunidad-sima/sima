using System;
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
         String dir_clases = Direccion.getDirClases();
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
                ViewBag.materiasMonitor = new MCurso().getNombreMateriaMonitorCursos(sesion.getIdUsuario(), periodo, 0);
                return View(new Mclase().getClasesMonitorPerido(db, periodo, sesion.getIdUsuario(), materia));
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
                Mclase auxClase = new Mclase();
                ViewBag.materiaSeleccionada = materia;
                ViewBag.periodoSeleccionada = periodoBuscar;
                ViewBag.idMonitorSeleccionado = idMonitor;
                ViewBag.periodos = auxClase.getPeriodosRegistradosDeClase(db);
                ViewBag.datosMoniotres = new MUsuario().getDatosMonitoresPeriodo(periodoBuscar);

                ViewBag.materiasMonitor = new MCurso().getNombreMateriaMonitorCursos( idMonitor, periodo, 1);

                ViewBag.peridoSeleccionado = periodoBuscar;
                ViewBag.monitorSeleccionado = idMonitor;

                return View(auxClase.getClasesMonitorPerido(db, periodo, idMonitor, materia));
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
                Mclase auxClase = new Mclase();
                ViewBag.materiaSeleccionada = materia;
                ViewBag.periodoSeleccionada = periodoBuscar;
                ViewBag.idMonitorSeleccionado = idMonitor;
                ViewBag.periodos = auxClase.getPeriodosRegistradosDeClase(db);
                ViewBag.datosMoniotres = new MUsuario().getDatosMonitoresPeriodo(periodoBuscar);

                ViewBag.materiasMonitor = new MCurso().getNombreMateriaMonitorCursos(idMonitor, periodo,1);

                ViewBag.peridoSeleccionado = periodoBuscar;
                ViewBag.monitorSeleccionado = idMonitor;

                return View(auxClase.getClasesMonitorPerido(db, periodo, idMonitor, materia));
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
                Mclase aux = new Mclase();
                ViewBag.perfil = sesion.getIPerfilUsusrio();
                Mclase clase =aux.getClasePorId(id);
                if (clase == null)
                {
                    return HttpNotFound();
                }
                List<estudiantes_asistentes> estudiantesAsistentes = aux.getEstudiantesAsistentes(id);
                List<String> idEstudiantes = estudiantesAsistentes.Select(x => x.estudiante_id).ToList();
                
                List<EstudianteMateria> estudiantes = null;
                if (idEstudiantes.Count() > 0)
                {
                    estudiantes = ConsumidorAppi.getDatosEstudiantesMateria(periodo, new  MMateria().getNombreMateriaPorIDCurso(clase.cursos_id), idEstudiantes);
                }
                ViewBag.estudiantes = estudiantes;
                ViewBag.estudiantesAsistentes = estudiantesAsistentes;
                ViewBag.usuario = new MUsuario().getUsuarioId(clase.usuarios_id);
                return View(clase);
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
                MCurso auxCurso = new MCurso();
                    String id_usuario = sesion.getIdUsuario();
                    var tienMateria = auxCurso.tieneCurso(id_usuario,materia, periodo);
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

                    ViewBag.materiasMonitor = auxCurso.getNombreMateriaMonitorCursos(id_usuario, periodo, 0);
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
                    MCurso auxCurso = new MCurso();

                        if (ModelState.IsValid)
                        {
                            string ruta = Server.MapPath(dir_clases);
                            String materia = sesion.getMateria();
                            String idMonitor = sesion.getIdUsuario();
                            // se verifica que tenga la materia a cargo para evitar que se cambie el monbre de la materia en el select
                            var tienMateria = auxCurso.tieneCurso(idMonitor,materia, periodo);
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
                                            int idCuro = auxCurso.getIdCurso(materia, periodo, idMonitor);
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
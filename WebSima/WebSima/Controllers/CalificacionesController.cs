using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebSima.Models;
using WebSima.Models.WebApi;

namespace WebSima.Controllers
{
    public class CalificacionesController : Controller
    {
        private bd_simaEntitie db = new bd_simaEntitie();
        Sesion sesion = new Sesion();
        //
        // GET: /Asistencia/

        public ActionResult Home()
        {
            if (sesion.esDocente(db))
            {
                return View();
            }
            else
            {
                return Redirect("~/Inicio/Login");
            }
        }
        public ActionResult Grupos()
        {
            if (sesion.esDocente(db))
            {
                return View();
            }
            else
            {
                return Redirect("~/Inicio/Login");
            }
        }
        //
        // GET: /Asistencia/Create

        public ActionResult Registrar(String id)
        {
            try
            {
                String[] datos = id.Split('|');
                sesion.setIPrograma_notas(datos[0]);
                sesion.setMateria_nota(datos[1]);
                sesion.setGrupo_nota(datos[2]);
                if (sesion.esDocente(db))
                {
                    return View();
                }
                else
                {
                    return Redirect("~/Inicio/Login");
                }
            }catch(Exception){
                return View("Grupos");
                //return Redirect("~/Calificaciones/Grupos");
            }
        }
        [HttpPost]
        public JsonResult CaligicacionesRegistro()
        {
            List<String[]> calificaciones = new List<String[]>();
          
            String asignatura = sesion.getMateria_nota();
            String programa = sesion.getPrgrama_notas();
            String grupo = sesion.getGrupo_nota();
            String id_docente = sesion.getIdUsuario();
            int id_calificacion = new MCalificaciones_periodo().getIdCalificacion(db, id_docente, programa, grupo, asignatura);
            calificaciones_periodo calificaciones_periodo = db.calificaciones_periodo.Find(id_calificacion);
            List<String> cabeza= new List<string>();
            cabeza.Add("Identificación");
            cabeza.Add("Nombre"); 
            String[] notas ;   
            List<EstudianteMateria> estudiantes= ConsumidorAppi.getEstudiantesMateria(MConfiguracionApp.getPeridoActual(db),asignatura);
            try
            {
                if (calificaciones_periodo != null)
                {
                    List<Notas> notas_registro = calificaciones_periodo.Notas.ToList();
                    List<String> cabeza_tem = (from n in notas_registro select (n.tipo)).Distinct().ToList();
                    List<String> idEstudiante_tem = (from n in notas_registro select (n.id_estudiante)).Distinct().ToList();
                    idEstudiante_tem = idEstudiante_tem.Union(
                        (from e in estudiantes
                         where (e.nom_materia == asignatura && e.num_grupo == grupo && e.nom_unidad == programa)
                         select (e.num_identificacion)).ToList()

                        ).Distinct().ToList();


                    cabeza = cabeza.Union(cabeza_tem).ToList();
                    calificaciones.Add(cabeza.ToArray());
                    double valorNota = 0;


                    foreach (String id_ in idEstudiante_tem)
                    {
                        notas = new String[cabeza.Count()];
                        notas[0] = id_;
                        String nombre = "Nombre no disponible";
                        var nom_estudiante=(from e in estudiantes
                                         where (e.num_identificacion == id_)
                                         select (e.nom_largo));
                        if(nom_estudiante.Count()>0)
                          nombre = (nom_estudiante).First();

                        notas[1] = nombre;

                        for (int i = 0; i < cabeza_tem.Count(); i++)
                        {
                            valorNota = 0;
                            try
                            {
                                valorNota = (from n in notas_registro where (n.id_estudiante == id_ && n.tipo == cabeza_tem[i]) select (n.valor)).First();
                            }
                            catch (Exception) { }
                            notas[i + 2] = "" + valorNota;
                        }
                        calificaciones.Add(notas);

                    }
                }
                else
                {
                    calificaciones.Add(cabeza.ToArray());
                    var estudiantesTemporal = (from e in estudiantes
                                              where (e.nom_materia == asignatura && e.num_grupo == grupo && e.nom_unidad == programa)
                                              select (e)).ToList();
                    foreach (var e in estudiantesTemporal)
                    {
                        calificaciones.Add(new String[] { e.num_identificacion, e.nom_largo });

                    }

                    //se consultan los estudiantes
                }
            }
            catch (Exception)
            {
                calificaciones.Add(cabeza.ToArray());
                
            }
            return Json(calificaciones);
        }

        //
        // POST: /Asistencia/Create

        [HttpPost]
        public JsonResult Guardar(FormCollection datos_notas)
        {
          //  var notas = Request.Form[0];
                      
            Respuesta respuesta = new Respuesta();
          
                //se piden las keys 
                MCalificaciones_periodo aux = new MCalificaciones_periodo();

                String guardado=aux.guardar(db, datos_notas);
                if (!guardado.Equals("OK"))
                {
                    respuesta.RESPUESTA = "ERROR";
                    respuesta.MENSAJE = guardado;
                }
                else
                {
                    respuesta.RESPUESTA = "OK";
                    respuesta.MENSAJE = "Calificaciones guardadas.";
                }

               
            

            return Json(respuesta);
        }

       
        //
        // POST: /Asistencia/Edit/5

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
        // GET: /Asistencia/Delete/5

        public ActionResult Delete(int id)
        {
            return View();
        }

        //
        // POST: /Asistencia/Delete/5

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

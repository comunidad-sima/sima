using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace WebSima.Models
{
    public class Mclase
    {
         [Display(Name = "Código")]
        public int id { get; set; }
         [Display(Name = "Fecha de registro")]
        public System.DateTime fecha_registro { get; set; }
        public string periodo { get; set; }
        [Display(Name = "Tema")]
        [Required]
        public string tema { get; set; }
         [Display(Name = "Comentarios")]
        public string comentario { get; set; }
        public int cursos_id { get; set; }
        public string usuarios_id { get; set; }
        public string evidencia { get; set; }
        [Required]
        [Display(Name = "Fecha realizada")]
        public System.DateTime fecha_realizada { get; set; }
        public virtual cursos cursos { get; set; }
        public virtual usuarios usuarios { get; set; }
        public virtual ICollection<estudiantes_asistentes> estudisntes_asistentes { get; set; }

        public String guardar(clases_sima clase, bd_simaEntitie db)
        {
            String resultado = null;
            try
            {                
                db.clases_sima.Add(clase);
                db.SaveChanges();
                return "ok";
            }
            catch (Exception )
            {
                resultado = null;
            }
            return resultado;
        }
        /// <summary>
        /// Esta funcion consulta solo los datos de las clases de un monitor en un periodo
        /// </summary>
        /// <param name="db"></param>
        /// <param name="periodo"></param>
        /// <param name="idMonitor"></param>
        /// <returns></returns>
        public static List<Mclase> getClasesMonitorPerido(bd_simaEntitie db,String periodo, String idMonitor, String materia){
          //  var clases_sima = db.clases_sima.Include(c => c.cursos).Include(c => c.usuarios);
            var clases =(from c in db.clases_sima
                         where c.periodo == periodo && c.usuarios_id.StartsWith(idMonitor) && c.cursos.nombre_materia.StartsWith(materia)
                select new Mclase
                {
                    id=c.id,
                    fecha_registro=c.fecha_registro,
                    comentario=c.comentario,
                    cursos = c.cursos,
                    estudisntes_asistentes=c.estudiantes_asistentes,
                    evidencia=c.evidencia,
                    fecha_realizada=c.fecha_realizada,
                    periodo=c.periodo,
                    tema=c.tema,
                    usuarios=c.usuarios,
                    usuarios_id=c.usuarios_id,
                    cursos_id=c.cursos_id
                    
                }).ToList();
            return clases;
        }
        /*// <summary>
        /// esta clase consulta todas  las clases de un monitor,  con los id de los estudinates asistentes, los datos del monitor y del curso 
        /// </summary>
        /// <param name="db"></param>
        /// <param name="periodo"> perido en el que se desea consultar </param>
        /// <param name="idMonitor"></param>
        /// <returns></returns>
        public static List<Mclase> getClasesMonitorPeriodoCompleta(bd_simaEntities db, String periodo, String idMonitor, String materia)
        {
            //  var clases_sima = db.clases_sima.Include(c => c.cursos).Include(c => c.usuarios);
            var clases = (from c in db.clases_sima
                          where c.cla_periodo == periodo && c.cla_usuarios_id == idMonitor && c.cursos.cur_materia.StartsWith(materia)
                          select new Mclase
                          {
                              cla_id = c.cla_id,
                              cla_fecha_registro = c.cla_fecha_registro,
                              comentario = c.cla_comentario,
                              cursos = c.cursos,
                              estudisntes_asistentes=c.estudiantes_asistentes,
                              evidencia = c.clas_evidencia,
                              fecha_realizada = c.cla_fecha_realizada,
                              periodo = c.cla_periodo,
                              tema = c.cla_tema,
                              usuarios=c.usuarios,
                              usuarios_id = c.cla_usuarios_id,
                              cursos_id = c.cla_cursos_id

                          }).ToList();
            return clases;
        }*/
        public bool guardarAsistentes(bd_simaEntitie db, clases_sima clsase,String[]idAsistentes)           
        {
            bool exito=true;
            try{
                if(idAsistentes!=null){
                    estudiantes_asistentes estudiante=null;
                    foreach(String id in  idAsistentes){
                        estudiante= new estudiantes_asistentes{
                            clase_id = clsase.id,
                            estudiante_id=id,
                            clases_sima = clsase
                        };
                        db.estudiantes_asistentes.Add(estudiante);                     
                    }
                    db.SaveChanges();
                }               
            }
            catch(Exception){
                exito=false;
            }
            return exito; 
        }
        /// <summary>
        /// Esta funcion consuta todos los periodos donde se registro clase
        /// </summary>
        /// <param name="db"></param>
        /// <returns></returns>
        public static List<String> getPeriodosRegistradosDeClase(bd_simaEntitie db)
        {
            return db.Database.SqlQuery<String>("select DISTINCT periodo from clases_sima").ToList();
        }
        /// <summary>
        /// Consulta la cantidad de asitencia que tiene un estudiante 
        /// </summary>
        /// <param name="db"></param>
        /// <param name="periodo"></param>
        /// <param name="id_estudiante"></param>
        /// <returns></returns>
        public int getCantidadClaseAsistidaEstudianteId(bd_simaEntitie db, String periodo , String id_estudiante)
        {
            int  cantidadAsistencia  = 0;
            cantidadAsistencia = (from c in db.clases_sima
                         join e in db.estudiantes_asistentes on c.id equals e.clase_id                         
                         where (c.periodo == periodo && e.estudiante_id==id_estudiante)                         
                         select c ).Count();
            return cantidadAsistencia;
        }

        /// <summary>
        /// Consulta la cantidad de case asistida que tiene un estudinate en un curso
        /// </summary>
        /// <param name="db"></param>
        /// <param name="id_curso"></param>
        /// <param name="id_estudiante"></param>
        /// <returns></returns>
        public int getClaseAsistedaEstudianteEnGrupo(bd_simaEntitie db, int id_curso, String id_estudiante)
        {
            int cantidadAsistencia = 0;
            cantidadAsistencia = (from c in db.clases_sima
                                  join e in db.estudiantes_asistentes on c.id equals e.clase_id
                                  where (c.cursos_id==id_curso && e.estudiante_id.Equals(id_estudiante))
                                  select c).Count();
            return cantidadAsistencia;
        }
        /// <summary>
        /// Consulta los curso donde el estudiante ha asitido a monitoria, es decir donde tiene una clase registrada 
        /// </summary>
        /// <param name="db"></param>
        /// <param name="periodo"></param>
        /// <param name="id_estudiante"></param>
        /// <returns></returns>
        public List<MCurso> getCursos_por_clase(bd_simaEntitie db, String periodo, String id_estudiante)
        {
            List<MCurso> cursos = null;
            /// se consultan los cursos donde asistio al mnos una vez a calse
            List<cursos> cuerso_tem = (from c in db.clases_sima
                              join cu in db.cursos on c.cursos_id equals cu.id
                              join e in db.estudiantes_asistentes on c.id equals e.clase_id

                              where (c.periodo == periodo && e.estudiante_id == id_estudiante)
                              select (cu)).Distinct().ToList();
            // se convierten a Mcurso
            cursos = (from cu in cuerso_tem
                     select new MCurso
                         {
                             id = cu.id,
                             periodo = cu.periodo,
                             nombre_materia = cu.nombre_materia,
                             estado = cu.estado,
                             fecha_finalizacion = cu.fecha_finalizacion,
                             idUsuario = cu.idUsuario,
                             eliminado = cu.eliminado,
                             clases_sima = cu.clases_sima,
                             materias = cu.materias,
                             usuarios = cu.usuarios

                         }).ToList();
            
            return cursos  ;
        }

       
    }
}
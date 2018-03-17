using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data.SqlClient;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Web;
using System.Web.Mvc;

namespace WebSima.Models
{
    public class MCurso
    {




        [Display(Name = "Código")]
       
        public int id { get; set; }

        [Display(Name = "Período")]      
        public string periodo { get; set; }
        [Display(Name = "Asignatura")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Se requiere la asignatura")]  
        public string nombre_materia { get; set; }
        [Display(Name = "Estado")]
        [Required]
        public byte estado { get; set; }
        [Display(Name = "Fecha de cierre")]
        [Required]
        public System.DateTime fecha_finalizacion { get; set; }
        [Display(Name = "Identificación  monitor")]
        [Required]
        public string idUsuario { get; set; }
          [Display(Name = "Monitor")]
        public Nullable<byte> eliminado { get; set; }
        public virtual ICollection<clases_sima> clases_sima { get; set; }
          public virtual materias materias { get; set; }
          public virtual usuarios usuarios { get; set; }

        /// <summary>
        /// Esta funcion consulta los curso de un periodo y que el nombre inicie con el pramatro materia
        /// </summary>
        /// <param name="db"></param>
        /// <param name="materia"></param>
        /// <param name="periodo"></param>
        /// <returns></returns>
         [MethodImpl(MethodImplOptions.Synchronized)]
        public static  List<MCurso> getCursos(bd_simaEntitie db, String materia, String periodo) 
        {
            try
            {
                var curos = (from cur in db.cursos
                             where (cur.nombre_materia.StartsWith(materia)) && cur.periodo == periodo && cur.eliminado==0
                             select new MCurso
                             {
                                 id = cur.id,
                                 estado = cur.estado,
                                 fecha_finalizacion = cur.fecha_finalizacion,
                                 idUsuario = cur.idUsuario,
                                 nombre_materia = cur.nombre_materia,
                                 periodo = cur.periodo,
                                 usuarios = cur.usuarios

                             });
                return curos.ToList();
            }
            catch (Exception)
            {
                throw new System.InvalidOperationException("Error al cargar los grupos.");
            }         

        }
        /// <summary>
        /// Esta funcion consulta los grupos exactos de un perido y una meteria
        /// </summary>
        /// <param name="db"></param>
        /// <param name="materia"></param>
        /// <param name="periodo"></param>
        /// <returns></returns>
         [MethodImpl(MethodImplOptions.Synchronized)]
         public static List<MCurso> getCursoMateria(bd_simaEntitie db, String materia, String periodo)
         {
             try
             {
                 var curos = (from cur in db.cursos
                              where (cur.nombre_materia == materia && cur.periodo == periodo && cur.eliminado == 0)
                              select new MCurso
                              {
                                  id = cur.id,
                                  estado = cur.estado,
                                  fecha_finalizacion = cur.fecha_finalizacion,
                                  idUsuario = cur.idUsuario,
                                  nombre_materia = cur.nombre_materia,
                                  periodo = cur.periodo,
                                  usuarios = cur.usuarios

                              });
                 return curos.ToList();
             }
             catch (Exception)
             {
                 throw new System.InvalidOperationException("Error al cargar los grupos.");
             }

         }
        /// <summary>
        /// Esta funcion consulta un curso por el id
        /// </summary>
        /// <param name="db"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        [MethodImpl(MethodImplOptions.Synchronized)]
        public static MCurso getCursoId(bd_simaEntitie db, int id)
        {
            cursos cur = db.cursos.Find(id);
            MCurso curso = null;
            if (cur != null)
            {
                curso = new MCurso
                {
                    estado= cur.estado,
                    fecha_finalizacion=cur.fecha_finalizacion,
                    id=cur.id,
                    idUsuario=cur.idUsuario,
                    nombre_materia= cur.nombre_materia,
                    periodo= cur.periodo,
                    usuarios= cur.usuarios                   

                };
            }
            return curso;

        }
        /// <summary>
        /// Esta funcion verifica si un monitor tiene un curso a cargo y est esta activo en cualquier periodo
        /// </summary>
        /// <param name="db"></param>
        /// <param name="materia"></param>
        /// <param name="periodo"></param>
        /// <param name="idMonitor"></param>
        /// <returns></returns>
        [MethodImpl(MethodImplOptions.Synchronized)]
        public static bool tieneCurso(bd_simaEntitie db, String materia, String periodo, String idMonitor){
            bool tieneCurso = false;

            var cursos = (from cur in db.cursos
                          where (cur.nombre_materia == materia && cur.periodo == periodo && cur.idUsuario == idMonitor )
                              ||(cur.nombre_materia == materia && cur.idUsuario == idMonitor && cur.estado==1 )
                           select cur).Select(c => c.id);
            if (cursos.ToList().Count() > 0)
                tieneCurso = true;
                              
            return tieneCurso;
        }
        /*// <summary>
        /// este método verifica si un monitor tiene una materia a cargo
        /// </summary>
        /// <param name="db"></param>
        /// <param name="materia"></param>
        /// <param name="periodo"></param>
        /// <param name="idMonitor"></param>
        /// <returns></returns>
        [MethodImpl(MethodImplOptions.Synchronized)]
        public static bool tieneMateriam(bd_simaEntities db, String materia, String periodo, String idMonitor,int estato=1)
        {
            bool tieneCurso = false;

            var cursos = (from cur in db.cursos
                          where (cur.cur_materia == materia && cur.cur_estado == estato && cur.cur_periodo == periodo && cur.cur_idUsuario == idMonitor)
                          select cur).Select(c => c.cur_materia).ToList();

            if (cursos.Count() > 0)
                tieneCurso = true;

            return tieneCurso;
        }*/
        /// <summary>
        /// Esta funcion consulta si un monitor tiene  cursos acargo activo
        /// </summary>
        /// <param name="db"></param>
        /// <param name="idMonitor"></param>
        /// <returns></returns>
        [MethodImpl(MethodImplOptions.Synchronized)]
        public static bool tieneCursosAcargo(bd_simaEntitie db,  String idMonitor)
        {
            bool tieneCurso = false;

            var cursos = (from cur in db.cursos
                          where (cur.estado == 1 && cur.idUsuario == idMonitor && cur.eliminado==0)
                          select cur).Select(c => c.nombre_materia).ToList();

            if (cursos.Count() > 0)
                tieneCurso = true;

            return tieneCurso;
        }
        /// <summary>
        /// Esta funcion consulta el id de un curso a partir de la materia, periodo e id del monito
        /// </summary>
        /// <param name="db"></param>
        /// <param name="materia"></param>
        /// <param name="periodo"></param>
        /// <param name="idMonitor"></param>
        /// <returns></returns>

        [MethodImpl(MethodImplOptions.Synchronized)]
        public static int getIdCurso(bd_simaEntitie db,String materia,String periodo, String idMonitor)
        {
            int id = -1;
            List<cursos> curso = db.cursos.Where(c => c.nombre_materia == materia && c.periodo == periodo && c.idUsuario == idMonitor).ToList();
            if(curso.Count()>0)
              id = curso.ElementAt(0).id;
            return id;
        
        }
        /// <summary>
        /// Esta funcion busca los nombre de las materias que tien un monitor acargo en un periodo mientras que el curso esté abierto
        /// </summary>
        /// <param name="db"></param>
        /// <param name="id_usuario"></param>
        /// <param name="periodo"></param>
        /// <param name="estado"></param>
        /// <returns></returns>
         [MethodImpl(MethodImplOptions.Synchronized)]
        public static List<String> getNombreMateriaMonitorDeCursos(bd_simaEntitie db, String id_usuario, String periodo, int estado = 1)
        {
            List<String> materias = db.cursos.Where(x => x.idUsuario == id_usuario && x.periodo == periodo && x.estado == estado && x.eliminado==0).Select(x => x.nombre_materia).ToList();
            return materias;
        }
        /// <summary>
        /// Esta funcion consulta los nombres de las materia que se le a asigado a un monitor en un periodo
        /// </summary>
        /// <param name="db"></param>
        /// <param name="id_usuario"></param>
        /// <param name="periodo"></param>
        /// <returns></returns>
         public static List<String> getMateriasMonitorAcargo(bd_simaEntitie db, String id_usuario, String periodo)
         {
             List<String> materias = db.cursos.Where(x => x.idUsuario == id_usuario && x.periodo == periodo && x.eliminado==0).Select(x => x.nombre_materia).ToList();
             return materias;
         }

        
    }
}
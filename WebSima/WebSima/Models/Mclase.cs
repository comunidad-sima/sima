using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
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
        public  List<Mclase> getClasesMonitorPerido(bd_simaEntitie db,String periodo, String idMonitor, String materia){
          //  var clases_sima = db.clases_sima.Include(c => c.cursos).Include(c => c.usuarios);





            ///SP_Clases_Monitor_Periodo
            ///




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
        public  List<String> getPeriodosRegistradosDeClase(bd_simaEntitie db)
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
        public int getCantidadClaseAsistidaEstudianteId(string periodo , string id_estudiante)
        {
            int  cantidadAsistencia  = 0;
            var dtr = new DataSet();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
            {
                try
                {
                    // procedimiento almacenado 
                    var cmd = new SqlCommand("SP_cantidad_asistencia", conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    cmd.Parameters.AddWithValue("@id_estudiante", id_estudiante);
                    cmd.Parameters.AddWithValue("@periodo", periodo);
                    conn.Open();
                    var da = new SqlDataAdapter(cmd);
                    da.Fill(dtr);
                    if ((dtr.Tables[0].Rows).Count >= 1)
                    {
                        DataRow row = dtr.Tables[0].Rows[0];
                        cantidadAsistencia = Convert.ToInt32(row["cantidad"]);                        
                    }
                }
                catch (Exception ex)
                {
                    string msg = ex.Message;

                }
                finally
                {
                    conn.Close();
                }
            }

            return cantidadAsistencia;
        }

        /// <summary>
        /// Consulta la cantidad de clase asistida que tiene un estudinate en un curso
        /// </summary>
        /// <param name="db"></param>
        /// <param name="id_curso"></param>
        /// <param name="id_estudiante"></param>
        /// <returns></returns>
        public int getClaseAsistedaEstudianteEnGrupo( int id_curso, string id_estudiante)
        {
            int cantidadAsistencia = 0;

            var dtr = new DataSet();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
            {
                try
                {
                    // procedimiento almacenado 
                    var cmd = new SqlCommand("SP_cantidad_asistencia_curso", conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    cmd.Parameters.AddWithValue("@id_estudiante", id_estudiante);
                    cmd.Parameters.AddWithValue("@id_curso", id_curso);
                    conn.Open();
                    var da = new SqlDataAdapter(cmd);
                    da.Fill(dtr);
                    if ((dtr.Tables[0].Rows).Count >= 1)
                    {
                        DataRow row = dtr.Tables[0].Rows[0];
                        cantidadAsistencia = Convert.ToInt32(row["cantidad"]);
                    }
                }
                catch (Exception ex)
                {
                    string msg = ex.Message;

                }
                finally
                {
                    conn.Close();
                }
            }

            return cantidadAsistencia;
        }
        /// <summary>
        /// Consulta los curso donde el estudiante ha asitido a monitoria, es decir donde tiene una clase registrada 
        /// </summary>
        /// <param name="db"></param>
        /// <param name="periodo"></param>
        /// <param name="id_estudiante"></param>
        /// <returns></returns>
        public List<MCurso> getCursos_por_clase(string periodo, string id_estudiante)
        {
            List<MCurso> cursos = new List<MCurso>();
            var dtr = new DataSet();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
            {
                try
                {
                    // procedimiento almacenado 
                    var cmd = new SqlCommand("SP_Cursos_por_clase", conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    cmd.Parameters.AddWithValue("@id_estudiante", id_estudiante);
                    cmd.Parameters.AddWithValue("@periodo", periodo);
                    conn.Open();
                    var da = new SqlDataAdapter(cmd);
                    da.Fill(dtr);
                    foreach (DataRow row in dtr.Tables[0].Rows)
                    {
                        MCurso c = new MCurso
                        {
                            id = Convert.ToInt32(row["id"].ToString()),
                            estado = Convert.ToByte(row["estado"]),
                            fecha_finalizacion = DateTime.Parse(row["fecha_finalizacion"].ToString()),
                            idUsuario = row["idUsuario"].ToString(),
                            nombre_materia = row["nombre_materia"].ToString(),
                            periodo = row["periodo"].ToString()

                        };
                        cursos.Add(c);
                    }
                }
                catch (Exception ex)
                {
                    string msg = ex.Message;

                }
                finally
                {
                    conn.Close();
                }
            }           
            return cursos  ;
        }
        public Mclase getClasePorId(int id)
        {

            Mclase clase = null;
            var dtr = new DataSet();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
            {
                try
                {
                    // procedimiento almacenado 
                    var cmd = new SqlCommand("SP_Clase_sima_id", conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    //cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@id", id);
                    conn.Open();
                    var da = new SqlDataAdapter(cmd);
                    //cmd.ExecuteNonQuery();
                    da.Fill(dtr);
                    if ((dtr.Tables[0].Rows).Count >= 1)
                    {
                        DataRow row = dtr.Tables[0].Rows[0];
                        clase = new Mclase
                        {
                            id = Convert.ToInt32(row["id"].ToString()),
                            comentario = row["comentario"].ToString(),
                            cursos_id = Convert.ToInt32(row["cursos_id"].ToString()),
                            evidencia = row["evidencia"].ToString(),
                            fecha_realizada = DateTime.Parse(row["fecha_realizada"].ToString()),
                            fecha_registro = DateTime.Parse(row["fecha_registro"].ToString()),
                            periodo = row["periodo"].ToString(),
                            tema = row["tema"].ToString(),
                            usuarios_id = row["usuarios_id"].ToString()

                        };
                    }
                }
                catch (Exception ex)
                {
                    string msg = ex.Message;

                }
                finally
                {
                    conn.Close();
                }
            }

            return clase;
        }
        public  List< estudiantes_asistentes> getEstudiantesAsistentes(int id_clase)
        {

            List<estudiantes_asistentes> estudiantes = new List<estudiantes_asistentes>();
            var dtr = new DataSet();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
            {
                try
                {
                    // procedimiento almacenado 
                    var cmd = new SqlCommand("SP_Estudiantes_asistentes", conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    //cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@clase_id", id_clase);
                    conn.Open();
                    var da = new SqlDataAdapter(cmd);
                    //cmd.ExecuteNonQuery();
                    da.Fill(dtr);
                    foreach ( DataRow row in dtr.Tables[0].Rows)
                    {                        
                       estudiantes_asistentes estudiante = new estudiantes_asistentes
                        {
                            clase_id = Convert.ToInt32(row["clase_id"].ToString()),
                            estudiante_id = row["estudiante_id"].ToString()                            

                        };
                        estudiantes.Add(estudiante);
                    }
                }
                catch (Exception ex)
                {
                    string msg = ex.Message;

                }
                finally
                {
                    conn.Close();
                }

            }

            return estudiantes;
        }
       
    }
}
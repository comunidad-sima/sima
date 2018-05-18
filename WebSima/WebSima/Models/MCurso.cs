using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Configuration;
using System.Data;
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
        //[DataType(DataType.Date)]
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
        /// Consulta los curso acargo de un monitor q esten activos
        /// </summary>
        /// <param name="db"></param>
        /// <param name="periodo"></param>
        /// <param name="id_monitor"></param>
        /// <returns></returns>
          public  List<MCurso> getCursoAcargoActivos(String periodo, String  id_monitor)
          {
              List<MCurso> lista = new List<MCurso>();
              var dtr = new DataSet();
              using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
              {
                  try
                  {
                      // procedimiento almacenado 
                      var cmd = new SqlCommand("SP_Curso_acargo_activos", conn)
                      {
                          CommandType = CommandType.StoredProcedure
                      };
                      //cmd.CommandType = CommandType.StoredProcedure;
                      cmd.Parameters.AddWithValue("@periodo", periodo);
                      cmd.Parameters.AddWithValue("@id_monitor", id_monitor);
                      conn.Open();
                      var da = new SqlDataAdapter(cmd);
                      //cmd.ExecuteNonQuery();
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

                          lista.Add(c);
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
              return lista;
             

          }
        /// <summary>
        /// Esta funcion consulta los curso de un periodo  que el nombre inicie con el paramatro materia
        /// </summary>
        /// <param name="db"></param>
        /// <param name="materia"></param>
        /// <param name="periodo"></param>
        /// <returns></returns>
        public   List<MCurso> getCursos(string materia, string periodo) 
        {
            List<MCurso> cursos = new List<MCurso>();
            var dtr = new DataSet();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
            {
                try
                {
                    // procedimiento almacenado 
                    var cmd = new SqlCommand("SP_Cursos", conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    cmd.Parameters.AddWithValue("@materia", materia);
                    cmd.Parameters.AddWithValue("@periodo", periodo);
                    conn.Open();
                    var da = new SqlDataAdapter(cmd);
                    //cmd.ExecuteNonQuery();
                    da.Fill(dtr);
                    foreach (DataRow row in dtr.Tables[0].Rows)
                    {

                        MCurso curso = new MCurso
                        {
                            id = Convert.ToInt32(row["id"].ToString()),
                            estado = Convert.ToByte(row["estado"]),
                            fecha_finalizacion = DateTime.Parse(row["fecha_finalizacion"].ToString()),
                            idUsuario = row["idUsuario"].ToString(),
                            nombre_materia = row["nombre_materia"].ToString(),
                            periodo = row["periodo"].ToString()

                        };
                        cursos.Add(curso);
                    }
                }
                catch (Exception ex)
                {
                    string msg = ex.Message;
                    throw new System.InvalidOperationException("Error al cargar los grupos. " + msg);

                }
                finally
                {
                    conn.Close();
                }
            }
            return cursos;



        }
        /// <summary>
        /// Esta funcion consulta los grupos exactos de un perido y una meteria
        /// </summary>
        /// <param name="db"></param>
        /// <param name="materia"></param>
        /// <param name="periodo"></param>
        /// <returns></returns>
         public  List<MCurso> getCursoMateria(string materia, string periodo)
         {

             List<MCurso> cursos = new List<MCurso>();
             var dtr = new DataSet();
             using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
             {
                 try
                 {
                     // procedimiento almacenado 
                     var cmd = new SqlCommand("SP_Curso_materia", conn)
                     {
                         CommandType = CommandType.StoredProcedure
                     };
                     cmd.Parameters.AddWithValue("@materia", materia);
                     cmd.Parameters.AddWithValue("@periodo", periodo);
                     conn.Open();
                     var da = new SqlDataAdapter(cmd);
                     //cmd.ExecuteNonQuery();
                     da.Fill(dtr);
                     foreach (DataRow row in dtr.Tables[0].Rows)                    
                     {

                        MCurso curso = new MCurso
                         {
                             id = Convert.ToInt32(row["id"].ToString()),
                             estado = Convert.ToByte(row["estado"]),
                             fecha_finalizacion = DateTime.Parse(row["fecha_finalizacion"].ToString()),
                             idUsuario = row["idUsuario"].ToString(),
                             nombre_materia = row["nombre_materia"].ToString(),
                             periodo = row["periodo"].ToString()

                         };
                        cursos.Add(curso);
                     }
                 }
                 catch (Exception ex)
                 {
                     string msg = ex.Message;
                     throw new System.InvalidOperationException("Error al cargar los grupos. "+msg);

                 }
                 finally
                 {
                     conn.Close();
                 }
             }
             return cursos ;


         }
        /// <summary>
        /// Esta funcion consulta un curso por el id
        /// </summary>
        /// <param name="db"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public  MCurso getCursoId(int id)
        {
           
            MCurso curso = null;
            var dtr = new DataSet();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
            {
                try
                {
                    // procedimiento almacenado 
                    var cmd = new SqlCommand("SP_Curso_id", conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    cmd.Parameters.AddWithValue("@id", id);

                    conn.Open();
                    var da = new SqlDataAdapter(cmd);
                    //cmd.ExecuteNonQuery();
                    da.Fill(dtr);
                    if ((dtr.Tables[0].Rows).Count >= 1)
                    {
                        DataRow row = dtr.Tables[0].Rows[0];
                        curso = new MCurso
                        {
                            id = Convert.ToInt32(row["id"].ToString()),
                            estado = Convert.ToByte(row["estado"]),
                            fecha_finalizacion = DateTime.Parse(row["fecha_finalizacion"].ToString()),
                            idUsuario = row["idUsuario"].ToString(),
                            nombre_materia = row["nombre_materia"].ToString(),
                            periodo = row["periodo"].ToString()

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
        public  bool tieneCurso(string idMonitor,string materia="", string periodo=""){
            bool tieneCurso = false;
            var dtr = new DataSet();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
            {
                try
                {
                    // procedimiento almacenado 
                    var cmd = new SqlCommand("SP_Tiene_curso", conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    cmd.Parameters.AddWithValue("@periodo", periodo);
                    cmd.Parameters.AddWithValue("@materia", materia);
                    cmd.Parameters.AddWithValue("@id_usuario", idMonitor);

                    conn.Open();
                    var da = new SqlDataAdapter(cmd);
                    //cmd.ExecuteNonQuery();
                    da.Fill(dtr);
                    if ((dtr.Tables[0].Rows).Count >= 1)
                    {
                        tieneCurso = true;
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


                              
            return tieneCurso;
        }

        /// <summary>
        /// esta funcion consulta si un monitor tiene cursos activos
        /// </summary>
        /// <param name="db"></param>
        /// <param name="materia"></param>
        /// <param name="periodo"></param>
        /// <param name="idMonitor"></param>
        /// <returns></returns>
        public bool tieneCurso_activo(String idMonitor)
        {
            bool tieneCurso = false;
            var dtr = new DataSet();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
            {
                try
                {
                    // procedimiento almacenado 
                    var cmd = new SqlCommand("SP_Tiene_curso_activo", conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    
                    cmd.Parameters.AddWithValue("@id_usuario", idMonitor);

                    conn.Open();
                    var da = new SqlDataAdapter(cmd);
                    //cmd.ExecuteNonQuery();
                    da.Fill(dtr);
                    if ((dtr.Tables[0].Rows).Count >= 1)
                    {
                        tieneCurso = true;
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
        public  int getIdCurso(String materia,String periodo, String idMonitor)
        {


            int id = -1;          
            var dtr = new DataSet();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
            {
                try
                {
                    // procedimiento almacenado 
                    var cmd = new SqlCommand("SP_Curso_por_materia_periodo_idusuario", conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    cmd.Parameters.AddWithValue("@materia", materia);
                    cmd.Parameters.AddWithValue("@periodo", periodo);
                    cmd.Parameters.AddWithValue("@id_monitor", idMonitor);
                    conn.Open();
                    var da = new SqlDataAdapter(cmd);
                    //cmd.ExecuteNonQuery();
                    da.Fill(dtr);
                    if ((dtr.Tables[0].Rows).Count >= 1)
                    {
                        DataRow row = dtr.Tables[0].Rows[0];
                        id = Convert.ToInt32(row["id"].ToString());                        
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
            return id;
        
        }
        /// <summary>
        /// Esta funcion busca los nombre de las materias que tien un monitor acargo en un periodo, si todo es 1 retorna todos los nombre de las asignaturas de lo contrario(0) retorna  el nombre de las asignaturas que el grupo este abierto
        /// </summary>
        /// <param name="db"></param>
        /// <param name="id_usuario"></param>
        /// <param name="periodo"></param>
        /// <param name="todo">indica si se retornan todas los nombre de las materia o solo los de los curso abiertos </param>
        /// <returns></returns>
        public  List<String> getNombreMateriaMonitorCursos(string id_usuario, string periodo,int todo)
        {


            List<string> materias = new List<string>();
            var dtr = new DataSet();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
            {
                try
                {
                    // procedimiento almacenado 
                    var cmd = new SqlCommand("SP_Materia_monitor_cargo", conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    //cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@periodo", periodo);
                    cmd.Parameters.AddWithValue("@id_monitor", id_usuario);
                    cmd.Parameters.AddWithValue("@todo", todo);
                    conn.Open();
                    var da = new SqlDataAdapter(cmd);
                    //cmd.ExecuteNonQuery();
                    da.Fill(dtr);
                    foreach (DataRow row in dtr.Tables[0].Rows)
                    {
                        string u = row["nombre_materia"].ToString();
                        materias.Add(u);
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
            return materias;
          
        }
        /// <summary>
        /// Esta funcion consulta los nombres de las materia que se le a asignado a un monitor en un periodo
        /// </summary>
        /// <param name="db"></param>
        /// <param name="id_usuario"></param>
        /// <param name="periodo"></param>
        /// <returns></returns>
         //public  List<String> getMateriasMonitorAcargo(bd_simaEntitie db, String id_usuario, String periodo)
         //{
         //    List<String> materias = db.cursos.Where(x => x.idUsuario == id_usuario && x.periodo == periodo && x.eliminado==0).Select(x => x.nombre_materia).ToList();
         //    return materias;
         //}
         public int cerrarCursoPorIdUsuario(bd_simaEntitie db,string id)
         {
             String sql = "UPDATE cursos SET estado = 0 WHERE  idUsuario= @id";
            int  eliminado = db.Database.ExecuteSqlCommand(sql,
                   new SqlParameter("@id", id)
                    );

            return eliminado;
         }
         public int eliminar(bd_simaEntitie db, int id_curso)
         {
             String sql = "UPDATE cursos SET estado = 0,eliminado = 1 WHERE  id= @id";
             int eliminado = db.Database.ExecuteSqlCommand(sql,
                    new SqlParameter("@id", id_curso)
                     );

             return eliminado;
         }
         public int actualizar(bd_simaEntitie db, MCurso curso)
         {
             String sql = "UPDATE cursos SET estado = @estado,fecha_finalizacion=@fecha_finalizacion " +
                 ",idUsuario=@idUsuario ,nombre_materia=@nombre_materia WHERE  id= @id";
             int eliminado = db.Database.ExecuteSqlCommand(sql,
                    new SqlParameter("@estado", curso.estado),
                    new SqlParameter("@fecha_finalizacion", curso.fecha_finalizacion),
                    new SqlParameter("@idUsuario", curso.idUsuario),
                    new SqlParameter("@nombre_materia", curso.nombre_materia),
                    new SqlParameter("@id", curso.id)
                     );
             

             return eliminado;
         }
         
        
    }
}
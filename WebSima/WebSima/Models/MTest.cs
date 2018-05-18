using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Data.EntityClient;
using System.Data.SqlClient;
using System.Linq;
using System.Transactions;
using System.Web;

namespace WebSima.Models
{
    public class MTest
    {
        [Display(Name = "Código")]
        public int id { get; set; }
        [Display(Name = "Fecha de finalización")]
       // [DataType(DataType.Date), DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}", ApplyFormatInEditMode = true)]

        [Required]
        public System.DateTime fecha_fin { get; set; }
        [Display(Name = "Fecha de inicio")]
        //[DataType(DataType.Date), DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}", ApplyFormatInEditMode = true)]

        [Required]
        public System.DateTime fecha_inicio { get; set; }
        [Display(Name = "¿Quién responde?")]
        [Required]
        public string ferfil_usuario { get; set; }
        [Display(Name = "Eliminado")]        
        public byte eliminado { get; set; }
        [Display(Name = "Estado")]        
        public byte estado_cierre { get; set; }
        [Display(Name = "Creado")]        
        public string id_usuario_creado { get; set; }
        [Display(Name = "Período")]        
        public string periodo { get; set; }

        public virtual ICollection<pregunta_test_responder> pregunta_test_responder { get; set; }
        public virtual usuarios usuarios { get; set; }

        /// <summary>
        /// Registra un nuevo test en la bd
        /// </summary>
        /// <param name="db"></param>
        /// <param name="test"> obj con los datos del test </param>
        /// <param name="id_preguntas">yds de las preguntas asignadas al test</param>
        /// <returns></returns>
        public bool guardar_Test(Test test, int[] id_preguntas, int id_test_actualizar=-1)
        {
            bool guardado = true;
            try
            {
                using (var transaccion = new TransactionScope())
                {
                    using (var contestTransaccion = new bd_simaEntitie())
                    {
                        if (id_test_actualizar==-1)
                        {
                            contestTransaccion.Test.Add(test);
                            contestTransaccion.SaveChanges();
                            add_pregunta_test(contestTransaccion, id_preguntas, test.id);
                        }
                        else
                        {

                            int respo = eliminarPreguntaResponder(contestTransaccion, id_test_actualizar);
                            add_pregunta_test(contestTransaccion, id_preguntas, id_test_actualizar);
                            
                            
                        }
                        contestTransaccion.SaveChanges();
                       transaccion.Complete();
                    }
                }

            }
            catch (Exception)
            {
                guardado = false;
            }
            return guardado;
        }
        /// <summary>
        /// agrega las preguntas de un test
        /// </summary>
        /// <param name="db"></param>
        /// <param name="id_preguntas"></param>
        /// <param name="id_test"></param>
        private void add_pregunta_test(bd_simaEntitie db,int[] id_preguntas, int id_test)
        {
            pregunta_test_responder pregunta;
            foreach (int id in id_preguntas)
            {
                pregunta = new pregunta_test_responder
                {
                    id_pregunta_test = id,
                    id_test = id_test

                };
                db.pregunta_test_responder.Add(pregunta);

            }
        }
        /// <summary>
        /// guarda las respuesta de un test
        /// </summary>
        /// <param name="db"></param>
        /// <param name="respuestas"> Lista de objeto </param>
        /// <returns></returns>
        public bool guardar_respuestas_test(bd_simaEntitie db,  List<respuestas> respuestas)
        {
            bool guardado = true;
            try
            {
                using (var transaccion = new TransactionScope())
                {
                    using (var contestTransaccion = new bd_simaEntitie())
                    {
                                              
                        
                        foreach (respuestas respuesta in respuestas)
                        {
                            db.respuestas.Add(respuesta);
                            
                        }
                        db.SaveChanges();
                        transaccion.Complete();
                    }
                }

            }
            catch (Exception)
            {
                guardado = false;
            }
            return guardado;
        }
        /// <summary>
        /// Consulta los test en un periodo
        /// </summary>
        /// <param name="db"></param>
        /// <param name="periodo">Perido a consultar </param>
        /// <param name="estado_cierre"> el estado del test cerrado o abierto 0 o 1</param>
        /// <param name="eliminado"> el estado de eliminacion del test eliminado o no ,0 o 1</param>
        /// <returns></returns>
        public List<MTest> getTestPeriodo(string periodo, int estado_cierre=0, int eliminado =0){
            List<MTest> tests = new List<MTest>();

            var dtr = new DataSet();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
            {
                try
                {
                    // procedimiento almacenado 
                    var cmd = new SqlCommand("SP_Test_periodo", conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    //cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@periodo", periodo);
                    cmd.Parameters.AddWithValue("@estado_cierre", estado_cierre);
                    cmd.Parameters.AddWithValue("@eliminado", eliminado);
                    conn.Open();
                    var da = new SqlDataAdapter(cmd);
                    //cmd.ExecuteNonQuery();
                    da.Fill(dtr);
                    foreach (DataRow row in dtr.Tables[0].Rows)
                    {
                       
                        MTest t = new MTest
                        {
                            id = Convert.ToInt32(row["id"].ToString()),
                            eliminado = Convert.ToByte(row["eliminado"].ToString()),
                            estado_cierre = Convert.ToByte(row["estado_cierre"].ToString()),
                            fecha_fin = DateTime.Parse(row["fecha_fin"].ToString()),
                            fecha_inicio = DateTime.Parse(row["fecha_inicio"].ToString()),
                            ferfil_usuario = row["ferfil_usuario"].ToString(),
                            id_usuario_creado = row["id_usuario_creado"].ToString(),
                            periodo = row["periodo"].ToString()

                        };
                        tests.Add(t);
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
            return tests;

        }
        /// <summary>
        /// Consulta un test por el id
        /// </summary>
        /// <param name="db"></param>
        /// <param name="id_test">id del test a consultar </param>
        /// <returns></returns>

        public MTest getTestPorId(int id_test)
        {
            MTest Mtest = null;
            var dtr = new DataSet();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
            {
                try
                {
                    // procedimiento almacenado 
                    var cmd = new SqlCommand("SP_Test", conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    //cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@id_test", id_test);
                    conn.Open();
                    var da = new SqlDataAdapter(cmd);
                    //cmd.ExecuteNonQuery();
                    da.Fill(dtr);
                    if ((dtr.Tables[0].Rows).Count >= 1)
                    {
                        DataRow row = dtr.Tables[0].Rows[0];
                        Mtest = new MTest
                        {
                            id = Convert.ToInt32(row["id"].ToString()),
                            eliminado= Convert.ToByte(row["eliminado"].ToString()),
                            estado_cierre = Convert.ToByte(row["estado_cierre"].ToString()),
                            fecha_fin= DateTime.Parse(row["fecha_fin"].ToString()),
                            fecha_inicio= DateTime.Parse(row["fecha_inicio"].ToString()),
                            ferfil_usuario= row["ferfil_usuario"].ToString(),
                            id_usuario_creado=row["id_usuario_creado"].ToString(),
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
            return Mtest;        
        }
        
        /// <summary>
        /// se consulta id de la relacion entre la preguntas y el rest 
        /// </summary>
        /// <param name="db"></param>
        /// <param name="id_test"></param>
        /// <returns></returns>
        public pregunta_test_responder getPregunta_test_responder(bd_simaEntitie db, int id_test, int id_pregunta)
        {
            pregunta_test_responder preguntas = null;

            preguntas = (from pre in db.pregunta_test_responder
                        
                         where(pre.id_test==id_test && pre.id_pregunta_test==id_pregunta)
                         
                         select  pre).First();
  
            return preguntas;
        }
        /// <summary>
        /// Se consulta las preguntas de un test segun el estado  no esten eliminado(0) 
        /// </summary>
        /// <param name="db"></param>
        /// <param name="id_test"></param>
        /// <returns></returns>
        public List<MPreguntas_test> getPreguntas_test_a_responder(bd_simaEntitie db, int id_test)
        {
            List<MPreguntas_test> preguntas = new List<MPreguntas_test>();

            preguntas = getPreguntas_test(id_test);
            preguntas = (from p in preguntas where (p.eliminado == 0) select p).ToList();

            return preguntas.OrderByDescending(x=>x.tipo).ToList();
        }

        /// <summary>
        /// Consulta todas las preguntas de un test, si la pregunta esta eliminada tambien se mostrará 
        /// </summary>
        /// <param name="db"></param>
        /// <param name="id_test"></param>
        /// <returns></returns>
        public List<MPreguntas_test> getPreguntas_test(int id_test)
        {
            List<MPreguntas_test> preguntas = new List<MPreguntas_test>();
            var dtr = new DataSet();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
            {
                try
                {
                    // procedimiento almacenado consultarAsistencia
                    var cmd = new SqlCommand("SP_Pregunta_Test", conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    //cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@id_test", id_test);
                    conn.Open();
                    var da = new SqlDataAdapter(cmd);
                    //cmd.ExecuteNonQuery();
                    da.Fill(dtr);
                    foreach (DataRow row in dtr.Tables[0].Rows)
                    {

                        MPreguntas_test p = new MPreguntas_test
                        {
                            eliminado = Convert.ToByte(row["eliminado"].ToString()),
                            id = Convert.ToInt32(row["id"].ToString()),
                            Pregunata = row["Pregunata"].ToString(),
                            tipo = row["tipo"].ToString()
                        };                      
                        preguntas.Add(p);
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


            return preguntas.OrderByDescending(m => m.tipo).ToList(); ;
        }
        /// <summary>
        /// consulta si el ususrio ya respondio el test de un curso o monitor
        /// </summary>
        /// <param name="id_curso"></param>
        /// <param name="id_test"></param>
        /// <returns></returns>
        public  bool isRespondioTest( int id_curso, int id_test )
        {


            Sesion sesion = new Sesion();
            String id_usuario_ = sesion.getIdUsuario();
            bool respuesta = false;
            var dtr = new DataSet();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
            {
                try
                {
                    // procedimiento almacenado 
                    var cmd = new SqlCommand("SP_Respondio_test", conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    cmd.Parameters.AddWithValue("@id_usuario", id_usuario_);
                    cmd.Parameters.AddWithValue("@id_curso", id_curso);
                    cmd.Parameters.AddWithValue("@id_test", id_test);
                    conn.Open();
                    var da = new SqlDataAdapter(cmd);
                    //cmd.ExecuteNonQuery();
                    da.Fill(dtr);
                    if ((dtr.Tables[0].Rows).Count >= 1)
                        respuesta = true;
                    
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
            return respuesta;
            
       
        }
        
        /// <summary>
        /// Se consulta las preguntas de un test con los puntos obtenidos por los votantes de tipo cerrada
        /// </summary>
        /// <param name="id_test"></param>
        /// <returns></returns>
        public List<String[]> getPreguntaPuntosTotal(int id_test, int id_curso=-1)
        {

            List<String[]> puntos = new List<String[]>();
            var dtr = new DataSet();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
            {
                try
                {
                    // procedimiento almacenado consultarAsistencia
                    var cmd = new SqlCommand("SP_Pregunta_Puntos_Total", conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    //cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@id_curso", id_curso);
                    cmd.Parameters.AddWithValue("@id_test", id_test);
                    conn.Open();
                    var da = new SqlDataAdapter(cmd);
                    //cmd.ExecuteNonQuery();
                    da.Fill(dtr);
                    foreach (DataRow row in dtr.Tables[0].Rows)
                    {
                       
                        String[] dato = new String[2];
                        dato[0] = row["id_pregunta_test"].ToString();
                        dato[1] = row["puntos"].ToString();
                        puntos.Add(dato);
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
            return puntos.OrderBy(m => m[0]).ToList();
        
        }
        /// <summary>
        /// Consulta las preguntas de tipo abierta con sus cometarios de un test
        /// </summary>
        /// <param name="id_test"></param>
        /// <returns></returns>
        public List<String[]> getCometariosPreguntasAbiertaTest(int id_test, int id_curso=-1)
        {

            var dtr = new DataSet();
            List<String[]> puntos = new List<String[]>();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
            {
                try
                {
                    // procedimiento almacenado 
                    var cmd = new SqlCommand("SP_Cometarios_Preguntas_Abierta_Test", conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    // si id curso es negagativo  se consulta en general, si es diferente de 0 se filtra por el curso

                    cmd.Parameters.AddWithValue("@id_test", id_test);
                    cmd.Parameters.AddWithValue("@id_curso", id_curso);
                    conn.Open();
                    var da = new SqlDataAdapter(cmd);
                    //cmd.ExecuteNonQuery();
                    da.Fill(dtr);
                    foreach (DataRow row in dtr.Tables[0].Rows)
                    {
                        String[] dato = new String[2];
                        dato[0] = row["id_pregunta_test"].ToString();
                        try
                        {
                            dato[1] = row["observacion"].ToString();
                        }
                        catch (Exception)
                        {
                            dato[1] = "";
                        }
                        puntos.Add(dato);
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
            
            return puntos.OrderBy(m => m[0]).ToList();

        }
        /// <summary>
        /// Cuenta la cantidad de susrios que han realizado un test
        /// </summary>
        /// <param name="id_test"></param>
        /// <param name="id_curso"></param>
        /// <returns></returns>
        public int ContarCantidaUasuarioRespondenTest(int id_test, int id_curso = -1)
        {
            var dtr = new DataSet();
            int cantidad = 0;
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
            {
                try
                {
                    // procedimiento almacenado 
                    var cmd = new SqlCommand("SP_Cantida_Uasuario_Responden_Test", conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    // si id curso es negagativo  se consulta en general, si es diferente de 0 se filtra por el curso

                    cmd.Parameters.AddWithValue("@id_test", id_test);
                    cmd.Parameters.AddWithValue("@id_curso", id_curso);
                    conn.Open();
                    var da = new SqlDataAdapter(cmd);
                    //cmd.ExecuteNonQuery();
                    da.Fill(dtr);
                    if ((dtr.Tables[0].Rows).Count >= 1){
                         DataRow row = dtr.Tables[0].Rows[0];
                         cantidad = Convert.ToByte(row["cantidad"]);
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
            return cantidad;

        }
        public int eliminar_test(bd_simaEntitie db, int id_test)
        {
            int eliminado = 0;
           
            String sql = "UPDATE Test SET estado_cierre = 1,eliminado = 1 WHERE  id= @id";
            eliminado = db.Database.ExecuteSqlCommand(sql,
                   new SqlParameter("@id", id_test)
                    );
            return eliminado;
        }
        public int actualizar_test(bd_simaEntitie db,MTest test)
        {
           
            String sql = "UPDATE Test SET eliminado=@eliminado,estado_cierre=@estado_cierre,"
            +"fecha_fin=@fecha_fin ,fecha_inicio=@fecha_inicio ,periodo=@periodo,"+
            "ferfil_usuario=@ferfil_usuario WHERE  id= @id";
            int eliminado = db.Database.ExecuteSqlCommand(sql,
                   new SqlParameter("@eliminado", false),
                   new SqlParameter("@estado_cierre", false),
                   new SqlParameter("@fecha_fin", test.fecha_fin),
                   new SqlParameter("@fecha_inicio", test.fecha_inicio),
                   new SqlParameter("@periodo", MConfiguracionApp.getPeridoActual(db)),
                   new SqlParameter("@ferfil_usuario", test.ferfil_usuario),
                   new SqlParameter("@id", test.id)
                    );        
            
            return eliminado;

        }
        public int eliminarPreguntaResponder(bd_simaEntitie db, int id_test)
        {

            String sql = "DELETE FROM pregunta_test_responder WHERE  id_test=@id_test";
            int eliminado = db.Database.ExecuteSqlCommand(sql,
                   new SqlParameter("@id_test", id_test)
                    );

            return eliminado;

        }
        public int eliminarPregunta(bd_simaEntitie db, int id_pregunta)
        {
            String sql = "UPDATE preguntas_test SET eliminado=1 WHERE  id=@id_test";
            int eliminado = db.Database.ExecuteSqlCommand(sql,
                   new SqlParameter("@id_test", id_pregunta)
                    );

            return eliminado;

        }

    }
}
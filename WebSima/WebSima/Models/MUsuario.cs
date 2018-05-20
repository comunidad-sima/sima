using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Transactions;
using System.Web;
using System.Web.WebPages.Html;

namespace WebSima.Models
{
    public class MUsuario
    {
        [Range(0, Int64.MaxValue, ErrorMessage = "Identificación no válida")]
        [StringLength(12, ErrorMessage = "Máximo 12 aracteres")]
        [Display(Name = "Identificación")]
        [Required]
        public String id { get; set; }

        [Display(Name = "Nombres")]
        [Required]
        [StringLength(50, ErrorMessage = "Máximo 50 caracteres")]
        public string nombre { get; set; }

        [Display(Name = "Apellidos")]
        [Required]
        [StringLength(60, ErrorMessage = "Máximo 60 caracteres")]
        public string apellidos { get; set; }
        [Display(Name = "Correo")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Se requiere un correo electrónico")]      
        [StringLength(60, ErrorMessage = "Máximo 60 caracteres")]
        [DataType(DataType.EmailAddress)]
        [RegularExpression(@"^(([\w-]+\.)+[\w-]+|([a-zA-Z]{1}|[\w-]{2,}))@((([0-1]?[0-9]{1,2}|25[0-5]|
        2[0-4][0-9])\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\.
        ([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])){1}|([a-zA-Z]+[\w-]+\.)+[a-zA-Z]{2,4})$",
            ErrorMessage = "No es un email válido.")]

        public string correo { get; set; }
        [Display(Name = "Celular")]
        [DataType(DataType.PhoneNumber)]
        [Range(0, 9999999999, ErrorMessage = "celular no válida")]
        [StringLength(12, ErrorMessage = "Máximo 12 caracteres")]
        public string celular { get; set; }

        [Display(Name = "Tipo")]
        [Required]
        [StringLength(15, ErrorMessage = "Máximo 15 caracteres")]
        public string tipo { get; set; }

        [Display(Name = "Contraseña")]        
        [StringLength(12, ErrorMessage = "Máximo 12 caracteres")]
        public string contrasena { get; set; }
        //[DataType(DataType.Date)]
        //[DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}", ApplyFormatInEditMode = true)]
        [Display(Name = "Facha de registro")]
        public System.DateTime fecha_registro { get; set; }
        public virtual ICollection<clases_sima> clases_sima { get; set; }
        public virtual ICollection<cursos> cursos { get; set; }
        public Nullable<byte> eliminado { get; set; }


        public int eliminarUsuario(string id){
           
            int resultado = 0;
            try
            {
                using (var transaccion = new TransactionScope())
                {
                    using (var contestTransaccion = new bd_simaEntitie())
                    {
                        String sql = "UPDATE usuarios SET eliminado = 1 WHERE  id= @id";
                        resultado = contestTransaccion.Database.ExecuteSqlCommand(sql,
                              new SqlParameter("@id", id)
                               );
                        if (resultado > 0)
                        {
                            resultado = new MCurso().cerrarCursoPorIdUsuario(contestTransaccion, id);
                        }

                        contestTransaccion.SaveChanges();
                        transaccion.Complete();
                    }
                }

            }
            catch (Exception)
            {

            }
            return resultado;

        }
        public String guardar(usuarios usuario, bd_simaEntitie db)
        {
            String resultado = null;
            try
            {                
                db.usuarios.Add(usuario);
                db.SaveChanges();
                return "Usuario registrado.";
            }
            catch (Exception )
            {
                resultado = null;
            }
            return resultado;
        
        }
        /// <summary>
        /// Esta funcion actua los datos de un usuario, ecepto la contraseña
        /// </summary>
        /// <param name="db"></param>
        /// <param name="u"></param>
        /// <param name="idAntiguo"></param>
        /// <returns></returns>

        public  int actualizar(bd_simaEntitie db, MUsuario u, String idAntiguo)
        {
            String sql = "UPDATE usuarios SET id= @id, nombre= @nombres, apellidos= @apellidos," +
            "correo= @correo, celular= @celular, tipo= @tipo WHERE  id= @idAntiguo";
            var resultado = db.Database.ExecuteSqlCommand(sql,
                   new SqlParameter("@id", u.id),
                   new SqlParameter("@nombres", u.nombre.ToUpper()),
                   new SqlParameter("@apellidos", u.apellidos.ToUpper()),
                   new SqlParameter("@correo", u.correo.ToUpper()),
                   new SqlParameter("@celular", u.celular),
                   new SqlParameter("@tipo", u.tipo),
                   new SqlParameter("@idAntiguo", idAntiguo)
                    );
            return resultado;
           
        }
        /// <summary>
        /// Esta funcion actualiza la contraseña de un usuario
        /// </summary>
        /// <param name="db"></param>
        /// <param name="nuevaContrasena"></param>
        /// <param name="id"></param>
        public  void actualizarContrasena(bd_simaEntitie db, string nuevaContrasena , string id)
        {
            String sql = "UPDATE usuarios SET contrasena = @contrasena WHERE  id= @id";
            var resultado = db.Database.ExecuteSqlCommand(sql,
                   new SqlParameter("@id", id),
                   new SqlParameter("@contrasena", nuevaContrasena)                   
                    );

        }
        /// <summary>
        /// Esta funcion constlta los usurios regitrsdos que el nombre largo contengan la cadena a buacar o su id inicie con la cadena a buscar
        /// </summary>
        /// <param name="db"> conexión BD</param>
        /// <param name="buscar"> cadena por la que se desea buscar</param>
        /// <returns></returns>
        public  List<MUsuario> getUsuarios(string buscar)
        {
            List<MUsuario> listausuarios = new List<MUsuario>();
            var dtr = new DataSet();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
            {
                try
                {
                    // procedimiento almacenado 
                    var cmd = new SqlCommand("SP_Usuarios", conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    //cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@filtro", buscar.ToUpper());
                    conn.Open();
                    var da = new SqlDataAdapter(cmd);
                    //cmd.ExecuteNonQuery();
                    da.Fill(dtr);
                    foreach (DataRow row in dtr.Tables[0].Rows)
                    {
                        MUsuario u = new MUsuario
                        {
                            id = row["id"].ToString(),
                            nombre = row["nombre"].ToString(),
                            tipo = row["tipo"].ToString(),
                            apellidos =row["apellidos"].ToString(), 
                            celular= row["celular"].ToString(),
                            contrasena= row["contrasena"].ToString(),
                            correo= row["correo"].ToString(),
                            eliminado = Convert.ToByte(row["eliminado"]),
                            fecha_registro = DateTime.Parse(row["fecha_registro"].ToString())

                        };
                        
                        listausuarios.Add(u);
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
           
           
            return listausuarios;

        }

        public List<MUsuario> getMonitores_de_materia(string materia, string periodo)
        {
            List<MUsuario> listausuarios = new List<MUsuario>();
            var dtr = new DataSet();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
            {
                try
                {
                    // procedimiento almacenado 
                    var cmd = new SqlCommand("SP_Monitores_de_materia", conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    //cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@materia", materia);
                    cmd.Parameters.AddWithValue("@periodo", periodo);
                    conn.Open();
                    var da = new SqlDataAdapter(cmd);
                    //cmd.ExecuteNonQuery();
                    da.Fill(dtr);
                    foreach (DataRow row in dtr.Tables[0].Rows)
                    {
                        MUsuario u = new MUsuario
                        {
                            id = row["id"].ToString(),
                            nombre = row["nombre"].ToString(),
                            tipo = row["tipo"].ToString(),
                            apellidos = row["apellidos"].ToString(),
                            celular = row["celular"].ToString(),
                            contrasena = row["contrasena"].ToString(),
                            correo = row["correo"].ToString(),
                            eliminado = Convert.ToByte(row["eliminado"]),
                            fecha_registro = DateTime.Parse(row["fecha_registro"].ToString())

                        };

                        listausuarios.Add(u);
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


            return listausuarios;

        }
        /// <summary>
        /// consulta los usurios segun el estado de eliminado
        /// </summary>
        /// <param name="db"> conexión BD</param>
        /// <param name="buscar"> cadena por la que se desea buscar</param>
        /// <returns></returns>
        public  List<MUsuario> getUsuariosEliminados(int eliminado)
        {
            List<MUsuario> listausuarios = new List<MUsuario>();
            var dtr = new DataSet();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
            {
                try
                {
                    // procedimiento almacenado 
                    var cmd = new SqlCommand("SP_Usuarios_eliminado", conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    //cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@eliminado", eliminado);
                    conn.Open();
                    var da = new SqlDataAdapter(cmd);
                    //cmd.ExecuteNonQuery();
                    da.Fill(dtr);
                    foreach (DataRow row in dtr.Tables[0].Rows)
                    {
                        MUsuario u = new MUsuario
                        {
                            id = row["id"].ToString(),
                            nombre = row["nombre"].ToString(),
                            tipo = row["tipo"].ToString(),
                            apellidos = row["apellidos"].ToString(),
                            celular = row["celular"].ToString(),
                            contrasena = row["contrasena"].ToString(),
                            correo = row["correo"].ToString(),
                            eliminado = Convert.ToByte(row["eliminado"]),
                            fecha_registro = DateTime.Parse(row["fecha_registro"].ToString())

                        };

                        listausuarios.Add(u);
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
            return listausuarios;

        }
        /// <summary>
        /// Esta funcion consulta todos los monitores regitrsdos que el nombre largo contengan la cadena a buacar o su id inicie con la cadena a buscar
        /// </summary>
        /// <param name="db"></param>
        /// <param name="buscar"> cadena a buscar</param>
        /// <returns></returns>
        public  List<MUsuario> getMonitores(string buscar)
        {

            List<MUsuario> listausuarios = new List<MUsuario>();
            var dtr = new DataSet();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
            {
                try
                {
                    // procedimiento almacenado 
                    var cmd = new SqlCommand("SP_Monitores", conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    //cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@filtro", buscar.ToUpper());
                    cmd.Parameters.AddWithValue("@tipo", "Monitor");
                    conn.Open();
                    var da = new SqlDataAdapter(cmd);
                    //cmd.ExecuteNonQuery();
                    da.Fill(dtr);
                    foreach (DataRow row in dtr.Tables[0].Rows)
                    {
                        MUsuario u = new MUsuario
                        {
                            id = row["id"].ToString(),
                            nombre = row["nombre"].ToString(),
                            tipo = row["tipo"].ToString(),
                            apellidos = row["apellidos"].ToString(),
                            celular = row["celular"].ToString(),
                            contrasena = row["contrasena"].ToString(),
                            correo = row["correo"].ToString(),
                            eliminado = Convert.ToByte(row["eliminado"]),
                            fecha_registro = DateTime.Parse(row["fecha_registro"].ToString())

                        };

                        listausuarios.Add(u);
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
            return listausuarios;
        }
        /// <summary>
        /// Esta funcion consulta un usuario por el id
        /// </summary>
        /// <param name="db"></param>
        /// <param name="id"></param>
        /// <returns></returns>
       
        public  MUsuario getUsuarioId(String id)
        {
            MUsuario usuario =null;
            var dtr = new DataSet();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
            {
                try
                {
                    // procedimiento almacenado 
                    var cmd = new SqlCommand("SP_Usuario_id", conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };                    
                    cmd.Parameters.AddWithValue("@id", id);
                    conn.Open();
                    var da = new SqlDataAdapter(cmd);
                    //cmd.ExecuteNonQuery();
                    da.Fill(dtr);
                    if((dtr.Tables[0].Rows).Count>=1)
                    {
                        DataRow row = dtr.Tables[0].Rows[0];
                        usuario = new MUsuario
                        {
                            id = row["id"].ToString(),
                            nombre = row["nombre"].ToString(),
                            tipo = row["tipo"].ToString(),
                            apellidos = row["apellidos"].ToString(),
                            celular = row["celular"].ToString(),
                            contrasena = row["contrasena"].ToString(),
                            correo = row["correo"].ToString(),
                            eliminado = Convert.ToByte(row["eliminado"]),
                            fecha_registro = DateTime.Parse(row["fecha_registro"].ToString())

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
            return usuario;

        }
        /// <summary>
        /// Esta funcion consulta los datos (nombre largo e id ) de los monitores que tienen  curso a cargo en un periodo
        /// </summary>
        /// <param name="db"></param>
        /// <returns></returns>
        //public  List<MUsuario> getDatosMonitoresPeriodok(string periodo)
        //{

        //    List<MUsuario> listausuarios = new List<MUsuario>();
        //    var dtr = new DataSet();
        //    using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
        //    {
        //        try
        //        {
        //            // procedimiento almacenado 
        //            var cmd = new SqlCommand("SP_Dato_monitores_perido", conn)
        //            {
        //                CommandType = CommandType.StoredProcedure
        //            };
        //            //cmd.CommandType = CommandType.StoredProcedure;
        //            cmd.Parameters.AddWithValue("@periodo", periodo);
        //            conn.Open();
        //            var da = new SqlDataAdapter(cmd);
        //            //cmd.ExecuteNonQuery();
        //            da.Fill(dtr);
        //            foreach (DataRow row in dtr.Tables[0].Rows)
        //            {
        //                MUsuario u = new MUsuario
        //                {
        //                    id = row["id"].ToString(),
        //                    nombre = row["nombre"].ToString(),                            
        //                    apellidos = row["apellidos"].ToString()

        //                };

        //                listausuarios.Add(u);
        //            }
        //        }
        //        catch (Exception ex)
        //        {
        //            string msg = ex.Message;
        //        }
        //        finally
        //        {
        //            conn.Close();
        //        }
        //    }
        //    return listausuarios;
          
        //}
    }
}
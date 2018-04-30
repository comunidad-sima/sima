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
    public class MPreguntas_test
    {
        [Display(Name = "Código")]
        public int id { get; set; }
        [StringLength(700, ErrorMessage = "Máximo 700 aracteres")]
        [Display(Name = "Pregunta")]
        [Required]
        public string Pregunata { get; set; }
        [Display(Name = "Estado")]
        public byte eliminado { get; set; }
         [Display(Name = "Tipo")]
         [Required]
        public string tipo { get; set; }

        public virtual ICollection<pregunta_test_responder> pregunta_test_responder { get; set; }


        /// <summary>
        /// Consulta una pregunta por el id
        /// </summary>
        /// <param name="db"></param>
        /// <param name="id">id de la pregunta</param>
        /// <returns></returns>
        public MPreguntas_test getPreguntaId(int id)
        {

            MPreguntas_test pregunta = null;
            var dtr = new DataSet();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
            {
                try
                {
                    // procedimiento almacenado 
                    var cmd = new SqlCommand("SP_preguntas_por_id", conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    //cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@id_pregunta", id);
                    conn.Open();
                    var da = new SqlDataAdapter(cmd);
                    //cmd.ExecuteNonQuery();
                    da.Fill(dtr);
                    foreach (DataRow row in dtr.Tables[0].Rows)
                    {
                        pregunta = new MPreguntas_test
                        {
                            id = Convert.ToInt32(row["id"].ToString()),
                            Pregunata = row["Pregunata"].ToString(),
                            tipo = row["tipo"].ToString(),
                            eliminado = Convert.ToByte(row["eliminado"]),
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


            return pregunta;
        }

        public int actualizar_pregunta(bd_simaEntitie db,MPreguntas_test pregunta){
            String sql = "UPDATE preguntas_test SET  Pregunata= @Pregunata WHERE  id= @id";

            var resultado = db.Database.ExecuteSqlCommand(sql,
                   new SqlParameter("@id", pregunta.id),
                   new SqlParameter("@Pregunata", pregunta.Pregunata)                   
                    );
            return resultado;
            

        }

        /// <summary>
        /// Consulta las preguntas registradas segun el estado de liminado
        /// </summary>
        /// <param name="db"></param>
        /// <param name="eliminado">Estado de la pregunta</param>
        /// <returns></returns>
        public  List<MPreguntas_test> getPreguntas(int eliminado=0)
        {

            List<MPreguntas_test> listapregunta = new List<MPreguntas_test>();
            var dtr = new DataSet();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
            {
                try
                {
                    // procedimiento almacenado 
                    var cmd = new SqlCommand("SP_preguntas", conn)
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
                        MPreguntas_test p = new MPreguntas_test
                        {
                            id = Convert.ToInt32( row["id"].ToString()),
                            Pregunata = row["Pregunata"].ToString(),
                            tipo = row["tipo"].ToString(),
                            eliminado = Convert.ToByte(row["eliminado"]),
                        };

                        listapregunta.Add(p);
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


            return listapregunta;
        }
        /// <summary>
        /// Registra un nueva pregunta 
        /// </summary>
        /// <param name="db"></param>
        /// <param name="pregunta"></param>
        /// <returns></returns>
        public bool guardar_pregunta(bd_simaEntitie db, preguntas_test pregunta)
        {
            bool guardado = true;
            try
            {

                db.preguntas_test.Add(pregunta);
                db.SaveChanges();

            }
            catch (Exception)
            {
                guardado = false;
            }
            return guardado;
        }
        ///// <summary>
        ///// Consulta las preguntas registradas para la creacion de los test
        ///// </summary>
        ///// <param name="db"></param>
        ///// <param name="eliminado"></param>
        ///// <returns></returns>
        //public List<MPreguntas_test> getPreguntas_test(bd_simaEntitie db, int eliminado=0)
        //{
        //    List<MPreguntas_test> preguntas = null;

            
        //    preguntas = (from p in db.preguntas_test
        //                where (p.eliminado == 0)
        //                select new MPreguntas_test
        //                {
        //                    eliminado = p.eliminado,
        //                    id = p.id,
        //                    Pregunata = p.Pregunata,
        //                    pregunta_test_responder = p.pregunta_test_responder,
        //                    tipo = p.tipo
        //                }).ToList();
        //    return preguntas;
        //}
    }
}
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Web;
using System.Web.WebPages.Html;

namespace WebSima.Models
{
    public class MMateria
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Se requiere una Asignatura")]  

        public string nombre { get; set; }
        /// <summary>
        /// consulta las materias registrada en sima
        /// </summary>
        /// <param name="db"></param>
        /// <returns></returns>
        public  List<SelectListItem> getMaterias(bd_simaEntitie db)
        {
            var materias = (from m in db.materias
                           select new SelectListItem
                               {
                                   Value = m.nombre,
                                   Text = m.nombre
                               });
            return materias.ToList();

        }
        public MMateria getMateriaId(bd_simaEntitie db, string nomMateria)
        {
            var materia = db.materias.Find(nomMateria);
            MMateria m = new MMateria
            {
                nombre = materia.nombre
            };
            return m;

        }
        /// <summary>
        /// consulta el nombre de las materias que se le ha creado un curso en un perido
        /// </summary>
        /// <param name="db"></param>
        /// <returns></returns>
        public  List<SelectListItem> getMaterias_registro_grupos(bd_simaEntitie db, String periodo )
        {
            //List<cursos> materia = ((from m in db.cursos
            //                where(m.periodo.Equals(periodo))
            //                          select m)).ToList();

            var k = (from mm in db.cursos
                     where (mm.periodo.Equals(periodo))
                group mm by mm.nombre_materia into temp
                select new SelectListItem
                        {
                            Value = temp.Key,
                            Text = temp.Key
                        }).ToList();
   
            return k;

        }
        /// <summary>
        /// Consulta el nombre de la asignatura por el id de un grupo
        /// </summary>
        /// <param name="id_curso"></param>
        /// <returns></returns>
        public  string getNombreMateriaPorIDCurso(int id_curso)
        {

            string materia = null;
            var dtr = new DataSet();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
            {
                try
                {
                    // procedimiento almacenado 
                    var cmd = new SqlCommand("SP_materioa_por_id_curso", conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    //cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@curso_id", id_curso);
                    conn.Open();
                    var da = new SqlDataAdapter(cmd);
                    //cmd.ExecuteNonQuery();
                    da.Fill(dtr);
                    if ((dtr.Tables[0].Rows).Count >= 1)
                    {
                        DataRow row = dtr.Tables[0].Rows[0];
                        materia = row["nombre_materia"].ToString();
                    }
                }
                catch (Exception ex)
                {
                    string msg = ex.Message;

                }

            }

            return materia;
        }

    }
    
}
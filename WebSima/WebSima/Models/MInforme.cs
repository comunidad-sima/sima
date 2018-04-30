using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Data.EntityClient;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace WebSima.Models
{
    public class MInforme
    {
        /// <summary>
        /// Consulta las asistencia de los de los estundintes a monitoria  a partir de una materia, retorna una list(String[]) donde String[0] es la cantidad de asistencia y String[1] la id , 
        /// </summary>
        /// <param name="materia"> materia a consultar las asistencia</param>
        /// <returns>retorna un liasta con la cantidad de asistencia y la id del estudiante</returns>
        

        public List<string[]> consultarAsistencia(string materia, string periodo) 
        {
            List<string[]> lista = new List<string[]>();
            var dtr = new DataSet();
            using (var conn = new SqlConnection( ConfigurationManager.ConnectionStrings["bd_simaConexion"].ConnectionString))
            {
                try 
                {
                    // procedimiento almacenado consultarAsistencia
                    var cmd = new SqlCommand("SP_ConsultarAsistencia", conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    //cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@periodo", periodo);
                    cmd.Parameters.AddWithValue("@materia", materia);
                    conn.Open();
                    var da = new SqlDataAdapter(cmd);
                    //cmd.ExecuteNonQuery();
                    da.Fill(dtr);
                    foreach (DataRow row in dtr.Tables[0].Rows)
                    {
                        String[] dato = new String[2];
                        dato[0] = row["cantidad"].ToString();
                        dato[1] = row["estudiante_id"].ToString();
                        lista.Add(dato);
                    }
                }
                catch (Exception ex)
                {
                    string msg = ex.Message;
                    lista = new List<string[]>();
                }

            }
            return   lista.OrderByDescending(m => m[0]).ToList(); ;
        }
    }
}
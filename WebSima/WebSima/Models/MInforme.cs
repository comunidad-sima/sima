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
        //public List<String[]> consultarAsistencia(String materia,String periodo)
        //{
        //    String sql = @"SELECT COUNT(e.estudiante_id) as cantidad ,e.estudiante_id" +
        //       " FROM bd_simaEntitie.cursos as c, bd_simaEntitie.clases_sima as cl, bd_simaEntitie.estudiantes_asistentes as e WHERE " +
        //       "c.id=cl.cursos_id and cl.id=e.clase_id and  c.periodo =@periodo and  " +
        //       "c.nombre_materia= @materia GROUP BY e.estudiante_id";

        //    List<String[]> datos = new List<String[]>();
        //    using (EntityConnection conn = new EntityConnection("name=bd_simaEntitie"))
        //    {
        //        conn.Open();                

        //        using (EntityCommand cmd = new EntityCommand(sql, conn))
        //        {
        //            // Create two parameters and add them to 
        //            // the EntityCommand's Parameters collection 
        //            EntityParameter param1 = new EntityParameter();
        //            param1.ParameterName = "materia";
        //            param1.Value = materia;
        //            cmd.Parameters.Add(param1);

        //            EntityParameter param2 = new EntityParameter();
        //            param2.ParameterName = "periodo";
        //            param2.Value = periodo;
        //            cmd.Parameters.Add(param2); ;
        //            using (DbDataReader rdr = cmd.ExecuteReader(CommandBehavior.SequentialAccess))
        //            {                 
                        
        //                while (rdr.Read())
        //                {
        //                     String[] dato = new String[2];
        //                     dato [0]= ""+rdr.GetInt32(0);
        //                     dato[1] = rdr.GetString(1);                          
        //                    datos.Add(dato);                           

        //                }
        //            }
        //        }
        //        conn.Close();
        //    }
        //    //List<String> f = datos.Select(m => m[1]).ToList();

        //    return datos.OrderByDescending(m => m[0]).ToList();
        //}

        public List<string[]> ProcedimientoPrueba(string materia,string periodo) 
        {
            List<string[]> lista = new List<string[]>();
            var dtr = new DataSet();
            using(var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["CadenaPrueba"].ConnectionString))
            {
                try 
                {
                    var cmd = new SqlCommand("ProcedimientoPrueba", conn)
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
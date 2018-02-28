using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebSima.Models
{
    public class MConfiguracionApp
    {
        public int id { get; set; }
        public string periodo_actual { get; set; }

        /// <summary>
        /// consulta el perido actual q esta registrado en sima
        /// </summary>
        /// <param name="db"></param>
        /// <returns></returns>
        public static String getPeridoActual( bd_simaEntitie db){
            String periodo = null;
            List<String> query = (from p in db.configuracion_app where (p.id == 1) select (p.periodo_actual)).ToList();
            if (query.Count() > 0)
            {
                periodo = query[0];
            }
            return periodo;
        }
    }
}
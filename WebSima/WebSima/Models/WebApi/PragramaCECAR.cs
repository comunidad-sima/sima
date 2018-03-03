using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebSima.Models.WebApi
{
    /// <summary>
    /// Esta clase contiene los de los programas ofertados por CECAR en sincelejo
    /// </summary>
    public class PragramaCECAR
    {
        public String cod_unidad { get; set; }
        public String nom_unidad { get; set; }
        public String cod_sede { get; set; }
        public String nom_sede { get; set; }
        public String cod_modalidad { get; set; }
        public String nom_modalidad { get; set; }
        public String est_metodologica { get; set; }
        public String nom_est_metodologica { get; set; }
    
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebSima.Models.WebApi
{
    /// <summary>
    /// Esta clase contiene los de los programas ofertados por CECAR en sincelejo
    /// </summary>
    public class Grupo
    {
        public string cod_unidad { get; set; }
        public string nom_unidad { get; set; }
        public string cod_sede { get; set; }
        public string nom_sede { get; set; }
        public string cod_modalidad { get; set; }
        public string nom_modalidad { get; set; }
        public string est_metodologica { get; set; }
        public string nom_est_metodologica { get; set; }      
        
        public string cod_materia{ get; set; }
        public string nom_materia{ get; set; }
        public string num_grupo{ get; set; }
        public string id_grupo{ get; set; }
        public string doc_docente{ get; set; }
        public string nom_docente{ get; set; }
        public string dir_email{ get; set; }
    
    }
}
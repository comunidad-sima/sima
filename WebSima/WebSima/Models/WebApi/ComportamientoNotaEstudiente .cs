using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebSima.Models.WebApi
{
    public class ComportamientoNotaEstudiente
    {

        public String id_grupo { get; set; }
        public String num_identificacion { get; set; }
        public String nom_largo { get; set; }
        public String dir_email { get; set; }
        public String cod_periodo { get; set; }
        public String fec_matricula { get; set; }
        public String cod_materia { get; set; }
        public String nom_materia { get; set; }
        public String semestre { get; set; }
        public String num_grupo { get; set; }
        public String cod_sede { get; set; }
        public String nom_sede { get; set; }
        public String cod_unidad { get; set; }
        public String nom_unidad { get; set; }
        public String programa_matricula_estudiante { get; set; }
        public String nom_prog_matricula_estudiante { get; set; }
        public String num_nota { get; set; }
        public String pes_nota { get; set; }
        public String nota { get; set; }
    }

}
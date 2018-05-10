using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebSima.Models.WebApi
{
    public class ComportamientoNotaEstudiente
    {

        public string id_grupo { get; set; }
        public string num_identificacion { get; set; }
        public string nom_largo { get; set; }
        public string dir_email { get; set; }
        public string cod_periodo { get; set; }
        public string fec_matricula { get; set; }
        public string cod_materia { get; set; }
        public string nom_materia { get; set; }
        public string semestre { get; set; }
        public string num_grupo { get; set; }
        public string cod_sede { get; set; }
        public string nom_sede { get; set; }
        public string cod_unidad { get; set; }
        public string nom_unidad { get; set; }
        public string programa_matricula_estudiante { get; set; }
        public string nom_prog_matricula_estudiante { get; set; }
        public string num_nota { get; set; }
        public string pes_nota { get; set; }
        public string nota { get; set; }
        public string est_matricula { get; set; }
        public string nom_est_matricula { get; set; }
        public string num_horas_total { get; set; }
        public string num_fallas { get; set; }
        public string doc_docente { get; set; }
        public string nom_docente { get; set; }
    }

}
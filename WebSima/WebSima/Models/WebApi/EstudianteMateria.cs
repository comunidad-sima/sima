using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebSima.Models.WebApi
{
    /// <summary>
    /// Datos de los estudiantes que estan viendo una asignatura en CECAR
    /// </summary>
    public class EstudianteMateria
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
        public string fec_nacimiento { get; set; }
    }
}
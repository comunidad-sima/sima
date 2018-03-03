using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebSima.Models.WebApi
{
    /// <summary>
    /// esta calse contiene los datos de los grupos que tiene un asignatura en CECAR
    /// 
    /// A través de esta se pueden consultar todos lo grupos que tiene una asignatura 
    /// o todas las asignatutas con los grupos que tiene creado en CECAR
    /// 
    /// </summary>
    public class AsignaturaGrupo
    {
        public String cod_unidad { get; set; }
        public String nom_unidad { get; set; }
        public String nom_sede { get; set; }
        public String cod_modalidad { get; set; }
        public String nom_modalidad { get; set; }
        public String est_metodologica { get; set; }
        public String nom_est_metodologica { get; set; }
        public String cod_materia { get; set; }
        public String nom_materia { get; set; }
        public String num_grupo { get; set; }
        public String id_grupo { get; set; }
    
    }
}
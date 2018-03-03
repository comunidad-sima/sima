using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebSima.Models.WebApi
{
    /// <summary>
    /// Clase que contiene los datos del horario de un estudiantes 
    /// </summary>
    public class HorarioEstudianteID
    {

        public String id_grupo { get; set; }
        public String cod_periodo { get; set; }
        public String num_identificacion { get; set; }
        public String nom_largo { get; set; }
        public String cod_unidad { get; set; }
        public String nom_unidad { get; set; }
        public String cod_materia { get; set; }
        public String nom_materia { get; set; }
        public String fecha_clase { get; set; }
        public String horainicio_seg { get; set; }
        public String hor_fin_seg { get; set; }
        public String num_dia { get; set; }
    
    }
}
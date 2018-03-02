using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebSima.Models.WebApi
{
    public class ComportamientoNotaEstudiente
    {       
    
        String id_grupo{ get; set; }
         String num_identificacion{ get; set; }
         String nom_largo{ get; set; }
         String dir_email{ get; set; }
         String cod_periodo{ get; set; }
         String fec_matricula{ get; set; }
         String cod_materia{ get; set; }
         String nom_materia{ get; set; }
         String semestre{ get; set; }
         String num_grupo{ get; set; }
         String cod_sede{ get; set; }
         String nom_sede{ get; set; }
         String cod_unidad{ get; set; }
         String nom_unidad{ get; set; }
         String programa_matricula_estudiante{ get; set; }
         String nom_prog_matricula_estudiante{ get; set; }
         int num_nota{ get; set; }
         int pes_nota{ get; set; }
         float nota { get; set; }
    }

}
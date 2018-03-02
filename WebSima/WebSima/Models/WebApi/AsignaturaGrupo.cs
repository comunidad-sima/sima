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
        String cod_unidad{ get; set; }
        String nom_unidad{ get; set; }
        String nom_sede{ get; set; }           
        String cod_modalidad{ get; set; }
        String nom_modalidad{ get; set; }
        String est_metodologica{ get; set; }
        String nom_est_metodologica{ get; set; }
        String cod_materia{ get; set; }
        String nom_materia{ get; set; }
        String num_grupo{ get; set; }
        String id_grupo{ get; set; }
    
    }
}
//------------------------------------------------------------------------------
// <auto-generated>
//    Este código se generó a partir de una plantilla.
//
//    Los cambios manuales en este archivo pueden causar un comportamiento inesperado de la aplicación.
//    Los cambios manuales en este archivo se sobrescribirán si se regenera el código.
// </auto-generated>
//------------------------------------------------------------------------------

namespace WebSima.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class Notas
    {
        public double valor { get; set; }
        public int id_calificaciones_periodo { get; set; }
        public string tipo { get; set; }
        public string id_estudiante { get; set; }
        public int id { get; set; }
    
        public virtual calificaciones_periodo calificaciones_periodo { get; set; }
    }
}
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
    
    public partial class notas_periodo
    {
        public double nota { get; set; }
        public string id_docente { get; set; }
        public string id_estudiante { get; set; }
        public int corte { get; set; }
        public string periodo { get; set; }
        public System.DateTime fecha_registro { get; set; }
        public string asignatura { get; set; }
        public string grupo { get; set; }
        public string programa { get; set; }
        public int id { get; set; }
    
        public virtual materias materias { get; set; }
    }
}

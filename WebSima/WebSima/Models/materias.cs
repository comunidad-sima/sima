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
    
    public partial class materias
    {
        public materias()
        {
            this.cursos = new HashSet<cursos>();
            this.grupos_acargo = new HashSet<grupos_acargo>();
            this.notas_periodo = new HashSet<notas_periodo>();
        }
    
        public string nombre { get; set; }
    
        public virtual ICollection<cursos> cursos { get; set; }
        public virtual ICollection<grupos_acargo> grupos_acargo { get; set; }
        public virtual ICollection<notas_periodo> notas_periodo { get; set; }
    }
}

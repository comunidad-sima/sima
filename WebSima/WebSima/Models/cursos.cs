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
    
    public partial class cursos
    {
        public cursos()
        {
            this.clases_sima = new HashSet<clases_sima>();
            this.respuestas = new HashSet<respuestas>();
        }
    
        public int id { get; set; }
        public string periodo { get; set; }
        public string nombre_materia { get; set; }
        public byte estado { get; set; }
        public System.DateTime fecha_finalizacion { get; set; }
        public string idUsuario { get; set; }
        public Nullable<byte> eliminado { get; set; }
    
        public virtual ICollection<clases_sima> clases_sima { get; set; }
        public virtual materias materias { get; set; }
        public virtual usuarios usuarios { get; set; }
        public virtual ICollection<respuestas> respuestas { get; set; }
    }
}

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
    
    public partial class pregunta_test_responder
    {
        public pregunta_test_responder()
        {
            this.respuestas = new HashSet<respuestas>();
        }
    
        public int id_test { get; set; }
        public int id_pregunta_test { get; set; }
        public int id { get; set; }
    
        public virtual preguntas_test preguntas_test { get; set; }
        public virtual Test Test { get; set; }
        public virtual ICollection<respuestas> respuestas { get; set; }
    }
}

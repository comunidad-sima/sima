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
    
    public partial class Test
    {
        public Test()
        {
            this.pregunta_test_responder = new HashSet<pregunta_test_responder>();
        }
    
        public int id { get; set; }
        public System.DateTime fecha_fin { get; set; }
        public System.DateTime fecha_inicio { get; set; }
        public string ferfil_usuario { get; set; }
        public byte eliminado { get; set; }
        public byte estado_cierre { get; set; }
        public string id_usuario_creado { get; set; }
        public string periodo { get; set; }
    
        public virtual ICollection<pregunta_test_responder> pregunta_test_responder { get; set; }
        public virtual usuarios usuarios { get; set; }
    }
}
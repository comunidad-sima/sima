using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebSima.Models
{
    public class Respuesta
    {
        // tipos de respustas:
        // ERROR
        // OK
        //LOGIN
        // 
        public String RESPUESTA{ get; set; }
        public String MENSAJE{ get; set; }
        public List<Object> DATOS { get; set; }
        
    }
}
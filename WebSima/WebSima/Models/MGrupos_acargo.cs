using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebSima.Models
{
    public class MGrupos_acargo
    {
      
            public int id { get; set; }
            public string idUsuario { get; set; }
            public string materia { get; set; }
            public string periodo { get; set; }
            public int id_grupo { get; set; }
            public int id_curso { get; set; }

            public virtual cursos cursos { get; set; }
            public virtual materias materias { get; set; }
            public virtual usuarios usuarios { get; set; }

            public static bool guardar(bd_simaEntitie db)
            {
                bool guardado = true;

                return guardado;

             }


        }


    }

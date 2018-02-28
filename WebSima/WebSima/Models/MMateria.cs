using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Web;
using System.Web.WebPages.Html;

namespace WebSima.Models
{
    public class MMateria
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Se requiere una Asignatura")]  

        public string nombre { get; set; }
        /// <summary>
        /// consulta las materias registrada en sima
        /// </summary>
        /// <param name="db"></param>
        /// <returns></returns>
        [MethodImpl(MethodImplOptions.Synchronized)]  
       
        public static List<SelectListItem> getMaterias(bd_simaEntitie db)
        {
            var materias = (from m in db.materias
                           select new SelectListItem
                               {
                                   Value = m.nombre,
                                   Text = m.nombre
                               });
            return materias.ToList();

        }
        /// <summary>
        /// consulta el nombre de las materias que se le ha creado un curso en un perido
        /// </summary>
        /// <param name="db"></param>
        /// <returns></returns>
        public static List<SelectListItem> getMaterias_registro_grupos(bd_simaEntitie db, String periodo )
        {
            //List<cursos> materia = ((from m in db.cursos
            //                where(m.periodo.Equals(periodo))
            //                          select m)).ToList();

            var k = (from mm in db.cursos
                     where (mm.periodo.Equals(periodo))
                group mm by mm.nombre_materia into temp
                select new SelectListItem
                        {
                            Value = temp.Key,
                            Text = temp.Key
                        }).ToList();
   
            return k;

        }

    }
    
}
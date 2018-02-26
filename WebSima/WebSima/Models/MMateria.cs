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
            var maerias = (from m in db.materias
                           select new SelectListItem
                               {
                                   Value = m.nombre,
                                   Text = m.nombre
                               });
            return maerias.ToList();

        }

    }
    
}
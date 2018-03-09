using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace WebSima.Models
{
    public class MPreguntas_test
    {
        [Display(Name = "Código")]
        public int id { get; set; }
        [StringLength(700, ErrorMessage = "Máximo 700 aracteres")]
        [Display(Name = "Pregunta")]
        [Required]
        public string Pregunata { get; set; }
        [Display(Name = "Estado")]
        public byte eliminado { get; set; }
         [Display(Name = "Tipo")]
         [Required]
        public string tipo { get; set; }

        public virtual ICollection<pregunta_test_responder> pregunta_test_responder { get; set; }

        /// <summary>
        /// Consulta las preguntas registradas segun el estado de liminado
        /// </summary>
        /// <param name="db"></param>
        /// <param name="eliminado">Estado de la pregunta</param>
        /// <returns></returns>
        public  List<MPreguntas_test> getCapacitacionesPeriodo(bd_simaEntitie db ,int eliminado=0)
        {

            var preguntas =
                from pre in db.preguntas_test
                where pre.eliminado == eliminado
                select new MPreguntas_test
                {
                    id = pre.id,
                    eliminado = pre.eliminado,
                    Pregunata = pre.Pregunata,
                    tipo = pre.tipo,
                    
                };
            return preguntas.ToList();
        }
        /// <summary>
        /// Registra un nueva pregunta 
        /// </summary>
        /// <param name="db"></param>
        /// <param name="pregunta"></param>
        /// <returns></returns>
        public bool guardar_pregunta(bd_simaEntitie db, preguntas_test pregunta)
        {
            bool guardado = true;
            try
            {

                db.preguntas_test.Add(pregunta);
                db.SaveChanges();

            }
            catch (Exception)
            {
                guardado = false;
            }
            return guardado;
        }
    }
}
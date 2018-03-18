using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data;
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
        /// Consulta una pregunta por el id
        /// </summary>
        /// <param name="db"></param>
        /// <param name="id">id de la pregunta</param>
        /// <returns></returns>
        public MPreguntas_test getPreguntaId(bd_simaEntitie db, int id)
        {
            MPreguntas_test pregunta = null;
            pregunta = (from p in db.preguntas_test
                        where (p.id == id)
                        select (new MPreguntas_test
                        {
                            eliminado = p.eliminado,
                            id = p.id,
                            Pregunata = p.Pregunata,
                            pregunta_test_responder = p.pregunta_test_responder,
                            tipo = p.tipo
                        })).First();

            return pregunta;
        }

        public bool actualizar_pregunta(bd_simaEntitie db,MPreguntas_test pregunta){
            bool actualizado = false;
            try
            {
                preguntas_test pre = db.preguntas_test.Find(pregunta.id);
                pre.Pregunata = pregunta.Pregunata;
                pre.tipo = pregunta.tipo;
                db.Entry(pre).State = EntityState.Modified;
                db.SaveChanges();
                actualizado = true;
            }
            catch (Exception)
            {

            }
            return actualizado;

        }

        /// <summary>
        /// Consulta las preguntas registradas segun el estado de liminado
        /// </summary>
        /// <param name="db"></param>
        /// <param name="eliminado">Estado de la pregunta</param>
        /// <returns></returns>
        public  List<MPreguntas_test> getPreguntas(bd_simaEntitie db ,int eliminado=0)
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
        /// <summary>
        /// Consulta las preguntas registradas para la creacion de los test
        /// </summary>
        /// <param name="db"></param>
        /// <param name="eliminado"></param>
        /// <returns></returns>
        public List<MPreguntas_test> getPreguntas_test(bd_simaEntitie db, int eliminado=0)
        {
            List<MPreguntas_test> preguntas = null;

            preguntas = (from p in db.preguntas_test
                        where (p.eliminado == 0)
                        select new MPreguntas_test
                        {
                            eliminado = p.eliminado,
                            id = p.id,
                            Pregunata = p.Pregunata,
                            pregunta_test_responder = p.pregunta_test_responder,
                            tipo = p.tipo
                        }).ToList();
            return preguntas;
        }
    }
}
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Transactions;
using System.Web;

namespace WebSima.Models
{
    public class MTest
    {
        [Display(Name = "Código")]
        public int id { get; set; }
        [Display(Name = "Fecha de finalización")]
        
        [Required]
        public System.DateTime fecha_fin { get; set; }
        [Display(Name = "Fecha de inicio")]
        [Required]
        public System.DateTime fecha_inicio { get; set; }
        [Display(Name = "¿Quien responde?")]
        [Required]
        public string ferfil_usuario { get; set; }
        [Display(Name = "Eliminado")]        
        public byte eliminado { get; set; }
        [Display(Name = "Estado")]        
        public byte estado_cierre { get; set; }
        [Display(Name = "Creado")]        
        public string id_usuario_creado { get; set; }
        [Display(Name = "Período")]        
        public string periodo { get; set; }

        public virtual ICollection<pregunta_test_responder> pregunta_test_responder { get; set; }
        public virtual usuarios usuarios { get; set; }
        /// <summary>
        /// Registra un nuevo test en la bd
        /// </summary>
        /// <param name="db"></param>
        /// <param name="test"> obj con los datos del test </param>
        /// <param name="id_preguntas">yds de las preguntas asignadas al test</param>
        /// <returns></returns>
        public bool guardar_Test(bd_simaEntitie db, Test test, int[] id_preguntas)
        {
            bool guardado = true;
            try
            {
                using (var transaccion = new TransactionScope())
                {
                    using (var contestTransaccion = new bd_simaEntitie())
                    {
                        db.Test.Add(test);
                        db.SaveChanges();
                        pregunta_test_responder pregunta ;
                        foreach(int id in id_preguntas){
                            pregunta = new pregunta_test_responder{
                                id_pregunta_test=id,
                                id_test=test.id
                                 
                            };
                            db.pregunta_test_responder.Add(pregunta);
                                                       
                        }
                       db.SaveChanges();
                       transaccion.Complete();
                    }
                }

            }
            catch (Exception)
            {
                guardado = false;
            }
            return guardado;
        }
        public bool guardar_respuestas_test(bd_simaEntitie db,  List<respuestas> respuestas)
        {
            bool guardado = true;
            try
            {
                using (var transaccion = new TransactionScope())
                {
                    using (var contestTransaccion = new bd_simaEntitie())
                    {
                                              
                        
                        foreach (respuestas respuesta in respuestas)
                        {
                            db.respuestas.Add(respuesta);
                        }
                        db.SaveChanges();
                        transaccion.Complete();
                    }
                }

            }
            catch (Exception)
            {
                guardado = false;
            }
            return guardado;
        }
        /// <summary>
        /// Consulta los test en un periodo
        /// </summary>
        /// <param name="db"></param>
        /// <param name="periodo">Perido a consultar </param>
        /// <param name="estado_cierre"> el estado del test cerrado o abierto (0 o 1)</param>
        /// <param name="eliminado"> el estado de eliminacion del test eliminado o no (0 o 1)</param>
        /// <returns></returns>
        public List<MTest> getTestPeriodo(bd_simaEntitie db, string periodo, int estado_cierre=0, int eliminado =0){
            List<MTest> test = null;

            test = (from p in db.Test
                      where (periodo.Equals(p.periodo) && p.eliminado == eliminado && p.estado_cierre == estado_cierre)
                      select new MTest
                      {
                          id=p.id,
                          eliminado=p.eliminado,
                          estado_cierre=p.estado_cierre,
                          fecha_fin=p.fecha_fin,
                          fecha_inicio=p.fecha_inicio,
                          ferfil_usuario=p.ferfil_usuario,
                          id_usuario_creado=p.id_usuario_creado,
                          periodo=p.periodo,
                          pregunta_test_responder=p.pregunta_test_responder,
                          usuarios=p.usuarios
                      }).ToList();
            return test;

        }
        /// <summary>
        /// Consulta un test por el id
        /// </summary>
        /// <param name="db"></param>
        /// <param name="id_test">id del test a consultar </param>
        /// <returns></returns>

        public MTest getTestPorId(bd_simaEntitie db, int id_test)
        {
            MTest Mtest = null;
            Test test = db.Test.Find(id_test);
            if (null != test)
            {
                Mtest = new MTest
                       {
                           id = test.id,
                           eliminado = test.eliminado,
                           estado_cierre = test.estado_cierre,
                           fecha_fin = test.fecha_fin,
                           fecha_inicio = test.fecha_inicio,
                           ferfil_usuario = test.ferfil_usuario,
                           id_usuario_creado = test.id_usuario_creado,
                           periodo = test.periodo,
                           pregunta_test_responder = test.pregunta_test_responder,
                           usuarios = test.usuarios
                       };
            }

            return Mtest;

        
        }
        /// <summary>
        /// se consulta id de la relacion entre la preguntas y el rest 
        /// </summary>
        /// <param name="db"></param>
        /// <param name="id_test"></param>
        /// <returns></returns>
        public pregunta_test_responder getPregunta_test_responder(bd_simaEntitie db, int id_test, int id_pregunta)
        {
            pregunta_test_responder preguntas = null;

            preguntas = (from pre in db.pregunta_test_responder
                        
                         where(pre.id_test==id_test && pre.id_pregunta_test==id_pregunta)
                         
                         select  pre).First();
  
            return preguntas;
        }

        public List<MPreguntas_test> getPreguntas_test(bd_simaEntitie db, int id_test)
        {
            List<MPreguntas_test> preguntas = null;

            preguntas = (from t in db.Test
                         join pr in db.pregunta_test_responder on t.id equals pr.id_test
                         join p in db.preguntas_test on pr.id_pregunta_test equals p.id
                         where (t.id == id_test)
                         orderby (p.tipo) descending
                         select new MPreguntas_test
                         {
                             eliminado = p.eliminado,
                             id = p.id,
                             Pregunata = p.Pregunata,
                             tipo = p.tipo,
                             pregunta_test_responder = p.pregunta_test_responder
                         }).ToList();

            return preguntas;
        }
    }
}
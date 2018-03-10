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
    }
}
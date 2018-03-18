using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Web;
using WebSima.Models;

namespace WebSima.clases
{
    public class Rutina
    {
        /// <summary>
        /// cierra todos los test que hayan llegado a la fecha fin
        /// </summary>
        [MethodImpl(MethodImplOptions.Synchronized)]
        public static void cerrarTest(){
           bd_simaEntitie db = new bd_simaEntitie();
            var query = from c in db.Test
            where (c.estado_cierre == 0)
            select c;
            foreach (Test t in query) {
                if (DateTime.Compare(DateTime.Now, t.fecha_fin) >0)
                {
                    t.estado_cierre = 1;
                }
              

            }
          db.SaveChanges();
        }
        /// <summary>
        /// cierra todos los curoso que hayan llegado a la fecha de finalizacion
        /// </summary>
        [MethodImpl(MethodImplOptions.Synchronized)]
        public static void cerrarCursos()
        {
            bd_simaEntitie db = new bd_simaEntitie();
            var query = from c in db.cursos
                        where (c.estado == 1)
                        select c;
            foreach (cursos cur in query)
            {
                if (DateTime.Compare(DateTime.Now, cur.fecha_finalizacion) > 0)
                {
                    cur.estado = 0;
                }


            }
            db.SaveChanges();
        }
        [MethodImpl(MethodImplOptions.Synchronized)]
        public static void Rutinas()
        {
            cerrarTest();
            cerrarCursos();
        }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebSima.Models
{
    public class MAlerta
    {
        public int id { get; set; }
        public byte vista { get; set; }
        public byte eliminada { get; set; }
        public String mensaje { get; set; }
        public string tipo_alerta { get; set; }
        public System.DateTime fecha_creada { get; set; }
        public string creador { get; set; }
        public string perfil_ver { get; set; }
        public string titulo { get; set; }


        public static List<MAlerta> getAlertasActivas(){
            bd_simaEntitie db = new bd_simaEntitie();
            List<MAlerta> alertas =( from a in db.Alertas
                          where (a.eliminada == 0 && a.vista == 0)
                          select new MAlerta
                          {
                              creador=a.creador,
                              eliminada=a.eliminada,
                              fecha_creada=a.fecha_creada,
                              id=a.id,
                              mensaje=a.mensaje,
                              perfil_ver=a.perfil_ver,
                              tipo_alerta=a.tipo_alerta,
                              titulo=a.titulo,
                              vista=a.vista

                          }).ToList();
            return alertas;

        }
        public bool crearAlerta(bd_simaEntitie db,MAlerta Malerta)
        {
            bool creada = true;
            try
            {
                Alertas alerta = new Alertas
                {
                    creador = Malerta.creador,
                    eliminada = Malerta.eliminada,
                    fecha_creada = Malerta.fecha_creada,
                    id = Malerta.id,
                    mensaje = Malerta.mensaje,
                    perfil_ver = Malerta.perfil_ver,
                    tipo_alerta = Malerta.tipo_alerta,
                    titulo = Malerta.titulo,
                    vista = Malerta.vista
                };
                db.Alertas.Add(alerta);
                db.SaveChanges();
            }
            catch (Exception)
            {
                creada = false;
            }
            return creada;
        }
    }
}
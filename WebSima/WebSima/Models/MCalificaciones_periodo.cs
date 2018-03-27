using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Transactions;
using System.Web;
using System.Web.Mvc;

namespace WebSima.Models
{
    public class MCalificaciones_periodo
    {

        public string id_docente { get; set; }
        public int corte { get; set; }
        public string periodo { get; set; }
        public System.DateTime fecha_registro { get; set; }
        public string asignatura { get; set; }
        public string grupo { get; set; }
        public string programa { get; set; }
        public int id { get; set; }

        public virtual materias materias { get; set; }
        public virtual ICollection<Notas> Notas { get; set; }

        public String guardar(bd_simaEntitie db, FormCollection datos_notas)
        {
            Sesion sesison = new Sesion();
            String guardado = "OK";
            String asignatura = "MATEMATICA BASICA";
            String programa = "INGENIERIA DE SISTEMAS";
            String grupo = "1";
            String id_docente = sesison.getIdUsuario();
            try
            {
                using (var transaccion = new TransactionScope())
                {
                    using (var contestTransaccion = new bd_simaEntitie())
                    {
                        eliminaCalificaciones(db, id_docente, programa, grupo, asignatura);
                        calificaciones_periodo calificacion = new calificaciones_periodo
                        {
                            asignatura = asignatura,
                            corte=1,
                            fecha_registro = DateTime.Now,
                            grupo=grupo,
                            id_docente=id_docente,
                            periodo=MConfiguracionApp.getPeridoActual(db),
                            programa=programa
                            
                        };
                        db.calificaciones_periodo.Add(calificacion);
                        db.SaveChanges();
                        List<String> claves = datos_notas.AllKeys.ToList();
                        int n=datos_notas.GetValues(0).Count();
                        double valorNota = 0;
                        NumberFormatInfo provider = new NumberFormatInfo();
                        provider.NumberDecimalSeparator = ",";
                        /// se recorren las filas de la tabla
                        List<String> cabezaTabla = datos_notas.GetValues(0).ToList();
                        for (int i = 1; i < claves.Count() -1; i++)
                        {                            
                             List<String> dato = datos_notas.GetValues(claves[i]).ToList();
                             String valida = validaFila(cabezaTabla.Count(), dato, provider);
                             if (valida.Equals("OK")) { 
                            /// se recorren las columnas
                                 for (int j = 1; j < n - 1; j++)
                                 {
                                     // posicion dende esta el nombre, esto no se guarda
                                     if (j != 1)
                                     {
                                         valorNota = Convert.ToDouble(dato[j], provider);
                                         Notas nota = new Notas
                                         {
                                             id_calificaciones_periodo = calificacion.id,
                                             id_estudiante = dato[0],
                                             tipo = cabezaTabla[j],
                                             valor = valorNota
                                         };
                                         db.Notas.Add(nota);
                                         db.SaveChanges();
                                     }
                                 }
                             }
                             else
                             {
                                 guardado = valida;
                                 break;
                             }
                        }
                        if (guardado.Equals("OK"))
                        {
                            transaccion.Complete();
                        }
                    }
                }
            }
            catch (Exception)
            {
                guardado = "Error al guardar";
            }
            return guardado;
        }

        private String validaFila(int n, List<String> fila, NumberFormatInfo provider)
        {
            String valido = "OK",nota="";
            try
            {
                if (fila.Count() == n)
                {
                    for (int i = 2; i < n - 1; i++)
                    {
                        nota=fila[i];
                      
                        if (n != 1)
                        {
                            double valorNota = Convert.ToDouble(nota, provider);
                            if (valorNota > 5 || valorNota < 0)
                            {
                                valido = "Nota invalida [" + nota + "]";
                                break;
                            }
                        }
                    }
                }
                else
                    valido = "Faltan datos";
            }catch(Exception ){
                valido = "Nota invalida ["+nota+"]";
            }

            return valido;

        }

        public void eliminaCalificaciones(bd_simaEntitie db,String id_docente,String programa,String grupo,String materia){

            var calificacion = (from c in db.calificaciones_periodo where(c.grupo==grupo && c.programa==programa &&
                                    c.asignatura==materia && c.id_docente==id_docente) select c);
            if (calificacion.Count()>0)
            {
               calificaciones_periodo califi = calificacion.First();
                List<Notas> notas = (from n in db.Notas
                                     where (n.id_calificaciones_periodo == califi.id)
                                     select n).ToList();
                foreach (Notas nota in notas)
                {
                    db.Notas.Remove(nota);
                }
                db.calificaciones_periodo.Remove(califi);
                db.SaveChanges();
            }

        }
    }
}
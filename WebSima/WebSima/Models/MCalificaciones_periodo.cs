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
          
            Sesion sesion = new Sesion();
            String guardado = "OK";
            String asignatura = sesion.getMateria_nota();
            String programa = sesion.getPrgrama_notas();
            String grupo = sesion.getGrupo_nota();
            String id_docente = sesion.getIdUsuario();
            try
            {
                using (var transaccion = new TransactionScope())
                {
                    using (var contestTransaccion = new bd_simaEntitie())
                    {
                        // se comprueba que las columnas contenca una nota y las filas un estuniente  como minimo
                        // se bene de restar los datos difrente a los de la tabla que vengan (datos_notas.AllKeys.ToList().Count()-1)

                        if ((datos_notas.GetValues(0).Count() - 1 > 2) && (datos_notas.AllKeys.ToList().Count() - 1 > 2))
                        {

                            List<String> cabezaTabla = datos_notas.GetValues(0).ToList();
                            // no se permite q el nombre de las actividades sean las misma
                            if (cabezaTabla.Distinct().Count() == cabezaTabla.Count())
                            {
                                eliminaCalificaciones(db, id_docente, programa, grupo, asignatura);
                                calificaciones_periodo calificacion = new calificaciones_periodo
                                {
                                    asignatura = asignatura,
                                    corte = 1,
                                    fecha_registro = DateTime.Now,
                                    grupo = grupo,
                                    id_docente = id_docente,
                                    periodo = MConfiguracionApp.getPeridoActual(db),
                                    programa = programa

                                };
                                db.calificaciones_periodo.Add(calificacion);
                                db.SaveChanges();
                                List<String> claves = datos_notas.AllKeys.ToList();
                                //  cabeceras tabla
                                int n = datos_notas.GetValues(0).Count();
                                double valorNota = 0;
                                NumberFormatInfo provider = new NumberFormatInfo();
                                provider.NumberDecimalSeparator = ",";
                                /// se recorren las filas de la tabla

                                // si se envian otros valores en el formulario, se debe de restar en el  (claves.Count()-n) del primer for
                                // siempre se  suma -1 porque la ultima fila siempre esta vacia
                                // se inicia en 1 porque la primera fila es la que contiene el nombre de las actividades
                                for (int i = 1; i < claves.Count() - 1; i++)
                                {
                                    List<String> dato = datos_notas.GetValues(claves[i]).ToList();
                                    guardado = validaFila(cabezaTabla.Count(), dato, provider);
                                    if (guardado.Equals("OK"))
                                    {
                                        /// se recorren las columnas, las dos primeras columnas no se toman 
                                        /// //se suma -1 porque la ultma columna siempre esta vacia
                                        for (int j = 2; j < n - 1; j++)
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
                                    else
                                    {
                                        break;
                                    }
                                }
                                if (guardado.Equals("OK"))
                                {
                                    MAlerta alerta = new MAlerta
                                    {
                                        creador = "SIMA",
                                        eliminada = 0,
                                        fecha_creada = DateTime.Now,
                                        mensaje = "Actualización de calificaciones del estudiante ",
                                        perfil_ver = "Administrador",
                                        tipo_alerta = "Notas",
                                        titulo = "CALIFICACIONES " + asignatura,
                                        vista = 0
                                    };
                                    alerta.crearAlerta(db, alerta);
                                    transaccion.Complete();
                                }
                            }
                            else
                            {
                                guardado = "El nombre de las actividades no pueden ser el mismo.";
                            }
                        }
                        else
                        {
                            guardado = "Se debe de registrar como minimo una nota y un estunate antes de guardar.";
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
                valido = "Nota inválida ["+nota+"]";
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
        public int getIdCalificacion(bd_simaEntitie db, String id_docente, String programa, String grupo, String materia)
        {
            int id = -1;
            var calificacion = (from c in db.calificaciones_periodo
                                where (c.grupo == grupo && c.programa == programa &&
                                    c.asignatura == materia && c.id_docente == id_docente)
                                select c);
            if (calificacion.Count() > 0)
            {
                id = calificacion.First().id;
            }
            return id;

        }
    }
}
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Web;

namespace WebSima.Models
{
    public class MCapacitacion
    {
        [Display(Name = "Código")]
        public int id { get; set; }
        [Display(Name = "Periodo")]
        public string periodo { get; set; }
        [Display(Name = "Encargado")]
        [Required(ErrorMessage = "Debe indicar el encargado")]
        [StringLength(60, ErrorMessage = "Máximo 60 aracteres")]
        public String encargado { get; set; }
        [Display(Name = "Tema")]
        [Required]
        public string tema { get; set; }
        [DataType(DataType.MultilineText)]
        [Display(Name = "Comentarios")]

        [Required]
        public string comentarios { get; set; }
        [Display(Name = "Fecha aplicada")]
        [Required]
        //[DataType(DataType.Date), DisplayFormat(DataFormatString = "{0:dd/mm/yyyy}", ApplyFormatInEditMode = true)]
       //[DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}", ApplyFormatInEditMode = true)]
        public DateTime fecha { get; set; }
        [Display(Name = "Evidencia")]
        [DataType(DataType.Upload, ErrorMessage = "error")]
        public string File { get; set; }
        public String guardar(capacitaciones capacitacion, bd_simaEntitie db){
            String resultado = null;
            try{
                capacitacion.periodo = MConfiguracionApp.getPeridoActual(db);
                db.capacitaciones.Add(capacitacion);
                db.SaveChanges();
                return "Capacitación guardada.";
            }
            catch (Exception ){
               resultado=null;
            }
            return resultado;
        }
        public  List<String> getPeriodos(bd_simaEntitie db)
        {
            return db.Database.SqlQuery<String>("select DISTINCT periodo from capacitaciones").ToList();
        }

        /**
         * busca las capacitaciones de un periodo
         */
        public    List<MCapacitacion> getCapacitacionesPeriodo(bd_simaEntitie db,String periodo)
        {

            var capacitaciones =
                from cap in db.capacitaciones
                where cap.periodo == periodo
                select new MCapacitacion
                {
                    comentarios = cap.comentarios,
                    fecha = cap.fecha,
                    encargado = cap.encargado,
                    File = cap.nom_File,
                    periodo = cap.periodo,
                    tema = cap.tema,
                    id = cap.id
                };
            return capacitaciones.ToList();

        }

      
        public  MCapacitacion getCapacitacionId(bd_simaEntitie db, int id)
        {
            capacitaciones cap = db.capacitaciones.Find(id);
            MCapacitacion capacitacion=null;
            if (cap != null)
            {
                capacitacion = new MCapacitacion
                                    {
                                        comentarios = cap.comentarios,
                                        fecha = cap.fecha,
                                        encargado = cap.encargado,
                                        File = cap.nom_File,
                                        periodo = cap.periodo,
                                        tema = cap.tema,
                                        id = cap.id
                                    };
            }
         
            return capacitacion;

        }
        
    }
    
    
}
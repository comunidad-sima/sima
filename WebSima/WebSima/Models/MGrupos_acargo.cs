using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebSima.Models
{
    public class MGrupos_acargo
    {

        public int id { get; set; }
        public string idUsuario { get; set; }
        public string materia { get; set; }
        public string periodo { get; set; }
        public int id_grupo { get; set; }
        public int id_curso { get; set; }

        public virtual cursos cursos { get; set; }
        public virtual materias materias { get; set; }
        public virtual usuarios usuarios { get; set; }

        /// <summary>
        /// consulta los los programas y grupos que tiene a cargo un monitor en un periodo
        /// </summary>
        /// <param name="db"></param>
        /// <param name="Usuario"></param>
        /// <param name="periodo"></param>
        /// <returns></returns>
        public List<grupos_acargo> getGrupuposPerido(bd_simaEntitie db, String IdUsuario, String periodo)
        {
            List<grupos_acargo> grupos_acargo = (
                      from p in db.grupos_acargo
                      where p.idUsuario == IdUsuario && p.periodo == periodo
                      select p).ToList();
            return grupos_acargo;
        }
        /// <summary>
        /// consulta los grupos y programas a cargo de un monitor filtrado por materia
        /// </summary>
        /// <param name="db"></param>
        /// <param name="IdUsuario"></param>
        /// <param name="periodo"></param>
        /// <returns></returns>
        public List<grupos_acargo> getGrupuposPeridoMateria(bd_simaEntitie db, String IdUsuario, String periodo, String materia)
        {
            List<grupos_acargo> grupos_acargo = (
                      from p in db.grupos_acargo
                      where p.idUsuario == IdUsuario && p.periodo == periodo && p.materia == materia
                      select p).ToList();
            return grupos_acargo;
        }
    }





}

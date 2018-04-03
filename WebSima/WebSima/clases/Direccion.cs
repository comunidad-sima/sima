using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebSima.clases
{
    public class Direccion
    {

        private static String urlBase = "~/Uploads";

        private static String urlCapacitaciones = "/capacitaciones";
        private static String urlClase = "/clases";
        private static String urlPlantillas = "/plantillas";

        public static String getDirCapacitaciones()
        {
            return (urlBase + urlCapacitaciones);
        }
        public static String getDirClases()
        {
            return (urlBase + urlClase);
        }
        public static String getDirPlatillas()
        {
            return (urlBase + urlPlantillas);
        }

    }
}
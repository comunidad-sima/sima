using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebSima.clases
{
    public class Direccion
    {

        private static string urlBase = "~/Uploads";
        private static string urlCapacitaciones = "/capacitaciones";
        private static string urlClase = "/clases";
        private static string urlPlantillas = "/plantillas";

        public static string getDirCapacitaciones()
        {
            return (urlBase + urlCapacitaciones);
        }
        public static string getDirClases()
        {
            return (urlBase + urlClase);
        }
        public static string getDirPlatillas()
        {
            return (urlBase + urlPlantillas);
        }

    }
}
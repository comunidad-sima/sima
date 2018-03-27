using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebSima.clases
{
    public class Direccion
    {

        private static String urlBase = "~/Uploads";

        private static String urlCapacitaciones = "/calapcitaciones";
        private static String urlClase = "/clases";

        public static String getDirCapacitaciones()
        {
            return (urlBase + urlCapacitaciones);
        }
        public static String getDirClases()
        {
            return (urlBase + urlClase);
        }

    }
}
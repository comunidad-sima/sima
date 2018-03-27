using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WebSima.Models;

namespace WebSima.clases
{
    public class HelperAlerta
    {
        public static List<MAlerta> getAlertar()
        {
            return MAlerta.getAlertasActivas();
        }
    }
}
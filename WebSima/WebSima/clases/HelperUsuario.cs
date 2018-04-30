using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WebSima.Models;

namespace WebSima.clases
{
    public class HelperUsuario
    {
        public static MUsuario getUsuario(string id)
        {
            return new MUsuario().getUsuarioId(id);
        }
    }
}
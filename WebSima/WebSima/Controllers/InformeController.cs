using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Mvc;

namespace WebSima.Controllers
{
    public class InformeController : ApiController
    {
        public ActionResult Home()
        {

            return View();
        }

        private ActionResult View()
        {
            throw new NotImplementedException();
        }
    }
}

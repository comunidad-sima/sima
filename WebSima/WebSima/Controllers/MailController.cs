﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebSima.clases;

namespace WebSima.Controllers
{
    public class MailController : Controller
    {
        //
        // GET: /Mail/

        public ActionResult Index()
        {
            
           
            return View();
        }
        public ActionResult Redactar()
        {
            return View("Redactar");
        }
        public ActionResult Recibidos()
        {
            return View("Recibidos");
        }

    }
}

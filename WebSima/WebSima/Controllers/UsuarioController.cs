using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebSima.clases;
using WebSima.Models;

namespace WebSima.Controllers
{
    public class UsuarioController : Controller
    {
        private bd_simaEntitie db = new bd_simaEntitie();
        Sesion sesion = new Sesion();
        public ActionResult Home(String periodo = "2017-2")
        {
            if (sesion.esUsuarioValido(db, "Administrador"))
            {               
                return View();
            }
            else
            {
                return Redirect("~/Inicio/Login");
            }
        }
        //
        // GET: /Usuario/

        public ActionResult Listar(String buscar="")
        {
            if (sesion.esUsuarioValido(db, "Administrador"))
            {
               
                return View(MUsuario.getUsuarios(db, buscar));
            }
            else
            {
                return null;
            }
        }

        //
        // GET: /Usuario/Details/5

        public ActionResult Details(String id = "0")
        {
            if (sesion.esUsuarioValido(db, "Administrador"))
            {
                MUsuario usuario = MUsuario.getUsuarioId(db, id);
                if (usuario == null)
                {
                    return HttpNotFound();
                }
                return View(usuario);
            }
            else
            {
                return Redirect("~/Inicio/Login");
            }
        }

        //
        // GET: /Usuario/Create

        public ActionResult Create()
        {
            if (sesion.esUsuarioValido(db, "Administrador"))
            {
                return View();
            }
            else
            {
                return null;
            }
        }

        //
        // POST: /Usuario/Create

        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult Create(MUsuario usuario)
        {
            Respusta respuesta = new Respusta();
            if (sesion.esUsuarioValido(db, "Administrador"))
            {
                if (ModelState.IsValid)
                {
                    usuarios usu = db.usuarios.Find(usuario.id);
                    if (usu == null)
                    {
                        DateTime fecha = DateTime.Now;
                        String contrasena = Seguridad.Encriptar("Cecar123");
                        usuarios c = new usuarios
                        {
                            id = usuario.id,
                            nombre = usuario.nombre.ToUpper(),
                            apellidos = usuario.apellidos.ToUpper(),
                            correo = usuario.correo.ToUpper(),
                            celular = usuario.celular,
                            tipo = usuario.tipo,
                            fecha_registro = fecha,
                            contrasena = contrasena,
                            eliminado=0
                        };
                        String guardar = usuario.guardar(c, db);
                        if (guardar != null)
                        {
                            respuesta.RESPUESTA = "OK";
                        }
                        else
                        {
                            respuesta.RESPUESTA = "ERROR";
                            respuesta.MENSAJE = "Error al registrar el usuario.";
                        }
                    }
                    else
                    {
                        respuesta.RESPUESTA = "ERROR";
                        respuesta.MENSAJE = "Usuario " + usuario.id + " ya existe.";
                    }
                }
                else
                {
                    respuesta.RESPUESTA = "ERROR";
                    respuesta.MENSAJE = "Los datos ingresados son incorrecotos.";
                }
            }
            else
            {
                respuesta.RESPUESTA = "LOGIN";
            }
            return Json(respuesta);
        }

        //
        // GET: /Usuario/Edit/5

        public ActionResult Edit(String id = "0")
        {
            if (sesion.esUsuarioValido(db, "Administrador"))
            {
            MUsuario usuario = MUsuario.getUsuarioId(db, id);
            if (usuario == null)
            {
                return HttpNotFound();
            }
            return View(usuario);
                 }
            else
            {
                return Redirect("~/Inicio/Login");
            }
        }

        //
        // POST: /Usuario/Edit/5

        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult Edit(MUsuario usuario, String idAntiguo)
        {
            Respusta respuesta = new Respusta();
            if (sesion.esUsuarioValido(db, "Administrador"))
            {
                if (ModelState.IsValid)
                {
                    usuarios exiteUsuario = null;
                    // se comprueba si cambia el id y si el nuevo id exiete
                    if (!usuario.id.Equals(idAntiguo))
                        exiteUsuario = db.usuarios.Find(usuario.id);

                    // si el usuario no exiete se actualiza con su nuevo datos e id
                    if (exiteUsuario == null)
                    {
                        int resultado = usuario.actualizar(db, usuario, idAntiguo);
                        if (resultado == 1)
                        {
                            respuesta.RESPUESTA = "OK";

                        }
                        else
                        {
                            respuesta.RESPUESTA = "ERROR";
                            respuesta.MENSAJE = "Error al actualizar el usuario " + idAntiguo;
                        }
                    }
                    else
                    {
                        respuesta.RESPUESTA = "ERROR";
                        respuesta.MENSAJE = "Usuario " + usuario.id + " ya existe.";
                    }
                }
                else
                {
                    respuesta.RESPUESTA = "ERROR";
                    respuesta.MENSAJE = "Datos incorrectos.";
                }
            }
            else
            {
                respuesta.RESPUESTA = "LOGIN";

            }
            return Json(respuesta);
        }

        //
        // GET: /Usuario/Delete/5

       /* public ActionResult Delete(String id = "0")
        {
            if (sesion.esUsuarioValido(db, "Administrador"))
            {
                MUsuario usuario = MUsuario.getUsuarioId(db, id);
                if (usuario == null)
                {
                    return HttpNotFound();
                }
                return View(usuario);
            }
            else
            {
                return Redirect("~/Inicio/Login");
            }
        }*/

        //
        // POST: /Usuario/Delete/5

        [HttpPost]
       // [ValidateAntiForgeryToken]
        public JsonResult Delete(String id)
        {
            Respusta respuesta = new Respusta();
            
            if (sesion.esUsuarioValido(db, "Administrador"))
            {
                usuarios usuarios = db.usuarios.Find(id);
                if (usuarios != null)
                {
                    if (usuarios.cursos.Count() == 0)
                    {
                        usuarios.eliminado = 1;
                        //db.usuarios.Remove(usuarios);
                        db.Entry(usuarios).State = EntityState.Modified;
                        db.SaveChanges();
                        respuesta.RESPUESTA = "OK";
                    }
                    else
                    {
                        respuesta.RESPUESTA = "ERROR";
                        respuesta.MENSAJE = "Usuario no se puede eliminar porque tiene grupo a cargo.";
                    }
                    
                }
                else
                {
                    respuesta.RESPUESTA = "ERROR";
                    respuesta.MENSAJE = "Usuario no exite.";
                }
            }
            else
            {
                respuesta.RESPUESTA = "LOGIN";
            }
            return Json(respuesta);
        }

        protected override void Dispose(bool disposing)
        {
            db.Dispose();
            base.Dispose(disposing);
        }
    }
}
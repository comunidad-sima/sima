using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data.SqlClient;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Web;
using System.Web.WebPages.Html;

namespace WebSima.Models
{
    public class MUsuario
    {
        [Range(0, Int64.MaxValue, ErrorMessage = "Identificación no válida")]
        [StringLength(12, ErrorMessage = "Máximo 12 aracteres")]
        [Display(Name = "Identificación")]
        [Required]
        public String id { get; set; }

        [Display(Name = "Nombres")]
        [Required]
        [StringLength(50, ErrorMessage = "Máximo 50 caracteres")]
        public string nombre { get; set; }

        [Display(Name = "Apellidos")]
        [Required]
        [StringLength(60, ErrorMessage = "Máximo 60 caracteres")]
        public string apellidos { get; set; }
        [Display(Name = "Correo")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Se requiere un correo electrónico")]      
        [StringLength(60, ErrorMessage = "Máximo 60 caracteres")]
        [DataType(DataType.EmailAddress)]
        [RegularExpression(@"^(([\w-]+\.)+[\w-]+|([a-zA-Z]{1}|[\w-]{2,}))@((([0-1]?[0-9]{1,2}|25[0-5]|
        2[0-4][0-9])\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\.
        ([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])){1}|([a-zA-Z]+[\w-]+\.)+[a-zA-Z]{2,4})$",
            ErrorMessage = "No es un email válido.")]

        public string correo { get; set; }
        [Display(Name = "Celular")]
        [DataType(DataType.PhoneNumber)]
        [Range(0, 9999999999, ErrorMessage = "celular no válida")]
        [StringLength(12, ErrorMessage = "Máximo 12 caracteres")]
        public string celular { get; set; }

        [Display(Name = "Tipo")]
        [Required]
        [StringLength(15, ErrorMessage = "Máximo 15 caracteres")]
        public string tipo { get; set; }

        [Display(Name = "Contraseña")]        
        [StringLength(12, ErrorMessage = "Máximo 12 caracteres")]
        public string contrasena { get; set; }
        
        [Display(Name = "Facha de registro")]
        public System.DateTime fecha_registro { get; set; }
        public virtual ICollection<clases_sima> clases_sima { get; set; }
        public virtual ICollection<cursos> cursos { get; set; }
        public Nullable<byte> eliminado { get; set; }

        public String guardar(usuarios usuario, bd_simaEntitie db)
        {
            String resultado = null;
            try
            {                
                db.usuarios.Add(usuario);
                db.SaveChanges();
                return "Usuario registrado.";
            }
            catch (Exception )
            {
                resultado = null;
            }
            return resultado;
        
        }
        /// <summary>
        /// Esta funcion actua los datos de un usuario, ecepto la contraseña
        /// </summary>
        /// <param name="db"></param>
        /// <param name="u"></param>
        /// <param name="idAntiguo"></param>
        /// <returns></returns>

        public  int actualizar(bd_simaEntitie db, MUsuario u, String idAntiguo)
        {
            String sql = "UPDATE usuarios SET id= @id, nombre= @nombres, apellidos= @apellidos," +
            "correo= @correo, celular= @celular, tipo= @tipo WHERE  id= @idAntiguo";

            var resultado = db.Database.ExecuteSqlCommand(sql,
                   new SqlParameter("@id", u.id),
                   new SqlParameter("@nombres", u.nombre.ToUpper()),
                   new SqlParameter("@apellidos", u.apellidos.ToUpper()),
                   new SqlParameter("@correo", u.correo.ToUpper()),
                   new SqlParameter("@celular", u.celular),
                   new SqlParameter("@tipo", u.tipo),
                   new SqlParameter("@idAntiguo", idAntiguo)
                    );
            return resultado;
           
        }
        /// <summary>
        /// Esta funcion actualiza la contraseña de un usuario
        /// </summary>
        /// <param name="db"></param>
        /// <param name="nuevaContrasena"></param>
        /// <param name="id"></param>
        public  void actualizarContrasena(bd_simaEntitie db, String nuevaContrasena , String id)
        {
            String sql = "UPDATE usuarios SET contrasena = @contrasena WHERE  id= @id";
            var resultado = db.Database.ExecuteSqlCommand(sql,
                   new SqlParameter("@id", id),
                   new SqlParameter("@contrasena", nuevaContrasena)                   
                    );

        }
        /// <summary>
        /// Esta funcion constlta los usurios regitrsdos que el nombre largo contengan la cadena a buacar o su id inicie con la cadena a buscar
        /// </summary>
        /// <param name="db"> conexión BD</param>
        /// <param name="buscar"> cadena por la que se desea buscar</param>
        /// <returns></returns>
        [MethodImpl(MethodImplOptions.Synchronized)]
        public static List<MUsuario> getUsuarios(bd_simaEntitie db, String buscar)
        {
           
            var usuario = (from user in db.usuarios
                           where ((user.nombre + " " + user.apellidos).Contains(buscar) || user.id.StartsWith(buscar)
                           ) && user.eliminado == 0
                                
                                 select new MUsuario
                                 {
                                     id = user.id,
                                     nombre = user.nombre,
                                     apellidos = user.apellidos,
                                     correo = user.correo,
                                     celular = user.celular,
                                     tipo = user.tipo,
                                     contrasena = user.contrasena,
                                     fecha_registro = user.fecha_registro
                                 }).Take(50);
            return usuario.ToList();

        }
        /// <summary>
        /// consulta los usurios segun el estado de eliminado
        /// </summary>
        /// <param name="db"> conexión BD</param>
        /// <param name="buscar"> cadena por la que se desea buscar</param>
        /// <returns></returns>
        [MethodImpl(MethodImplOptions.Synchronized)]
        public static List<MUsuario> getUsuariosEliminados(bd_simaEntitie db, int eliminado)
        {

            var usuario = (from user in db.usuarios
                           where (user.eliminado == eliminado)

                           select new MUsuario
                           {
                               id = user.id,
                               nombre = user.nombre,
                               apellidos = user.apellidos,
                               correo = user.correo,
                               celular = user.celular,
                               tipo = user.tipo,
                               contrasena = user.contrasena,
                               fecha_registro = user.fecha_registro
                           });
            return usuario.ToList();

        }
        /// <summary>
        /// Esta funcion consulta todos los monitores regitrsdos que el nombre largo contengan la cadena a buacar o su id inicie con la cadena a buscar
        /// </summary>
        /// <param name="db"></param>
        /// <param name="buscar"> cadena a buscar</param>
        /// <returns></returns>
        [MethodImpl(MethodImplOptions.Synchronized)]
        public static List<MUsuario> getMonitores(bd_simaEntitie db, String buscar)
        {
            var usuario = (from user in db.usuarios
                            where ((user.nombre + " " + user.apellidos).Contains(buscar) || user.id.StartsWith(buscar)) &&
                            user.tipo=="Monitor" && user.eliminado==0
                            select new MUsuario
                            {
                                id = user.id,
                                nombre = user.nombre,
                                apellidos = user.apellidos,
                                correo = user.correo,
                                celular = user.celular,
                                tipo = user.tipo,
                                contrasena = user.contrasena,
                                fecha_registro = user.fecha_registro                               
                            }).Take(15);
            return usuario.ToList();
        }
        /// <summary>
        /// Esta funcion consulta un usuario por el id
        /// </summary>
        /// <param name="db"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        [MethodImpl(MethodImplOptions.Synchronized)]
        public static MUsuario getUsuarioId(bd_simaEntitie db, String id)
        {
            usuarios us = db.usuarios.Find(id);
            MUsuario usuario = null;
            if (us != null)
            {
                usuario = new MUsuario
                {
                    id = us.id,
                    nombre = us.nombre,
                    apellidos = us.apellidos,
                    celular = us.celular,
                    contrasena = us.contrasena,
                    tipo = us.tipo,
                    correo= us.correo,
                    fecha_registro= us.fecha_registro,
                    
                };
            }

            return usuario;

        }
        /// <summary>
        /// Esta funcion consulta los datos (nombre largo e id ) de los monitores que tienen  curso a cargo en un periodo
        /// </summary>
        /// <param name="db"></param>
        /// <returns></returns>
        public static List<MUsuario> getDatosMonitoresPeriodo(bd_simaEntitie db, String periodo)
        {
           

                  var datos =
                  ( from usu in db.usuarios
                   join cur in db.cursos on usu.id equals cur.idUsuario
                   where cur.periodo == periodo && cur.eliminado==0
                   select new MUsuario { 
                    nombre=usu.nombre,
                    apellidos=usu.apellidos,
                    id=usu.id                    
                   }).Distinct().ToList();
        
            
            
            return datos.ToList();
        }
    }
}
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Web;

namespace WebSima.clases
{
    public  class Archivo
    {
        [MethodImpl(MethodImplOptions.Synchronized)]
        /// <summary>
        /// esta función permite subir un archivo al servidor.
        /// </summary>
        /// <param name="files"> archivos que se desean guardar </param>
        /// <param name="ruta">ruta dobde  se guardaran los archivos</param> 
        /// <returns>retorna un String[2]. si el archivo se guarda correctamente se retorna en [0] ok par indicar que se guardo y en [1] el nombre el archivo,
        /// si ocurre un error al  guardar, se retorna en [0] error para indicar que hubo un error y en [1] el error q ocurrio</returns>
        public static String[] subir(HttpFileCollectionBase files, String ruta)
        {
            String[] subida=new String[2];
            try {
                HttpPostedFileBase file = files[0];

                if (file != null && file.ContentLength > 0)
                {
                    String extension = Path.GetExtension((file.FileName).ToLower());
                    // se valida la extension
                    if (extensionValida(extension))
                    {
                        if (!Directory.Exists(ruta))
                            Directory.CreateDirectory(ruta);

                        String archivo = ("evid_" + DateTime.Now.ToString("yyyy-MM-dd HH-mm-ss-ff"));
                        // se renombra si existe
                        int i = 0;
                        
                        String aux = archivo;
                        while (File.Exists(ruta + "/" + aux + extension))
                        {
                            aux = archivo + "(" + i + ")";
                            i++;
                        }
                        archivo = aux;

                        file.SaveAs(ruta + "/" + archivo + extension);
                        //si el archivo se guarda correctamente se retorna en [0] ok par indicar que se guardó, y en [1] el nombre el archivo
                        subida[0] = "ok";
                        subida[1] = archivo + extension;
                    }
                    else
                    {
                        subida[0] = "error";
                        subida[1] = "El tipo de archivo "+extension+" no es válido.";
                    }
                }
                else
                {
                    subida[0] = "ok";
                    subida[1] = "-";
                }                
            }

            catch (Exception e)
            {
                subida[0] = "error";
                subida[1] = "Ocurrio un error al subir la evidencia ("+e.Message+")";
            }
            return subida;
        }

        [MethodImpl(MethodImplOptions.Synchronized)]
        public static bool  elimiarFichero(String ruta,String fichero)
        {
            try
            {
                if (File.Exists(ruta + "/" + fichero))
                    File.Delete(ruta + "/" + fichero);
            }catch(Exception ){
                return false;
            }
            return true;
        }

        [MethodImpl(MethodImplOptions.Synchronized)]
        /// <summary>
        /// valida que la extension de un archivo es la permitada 
        /// </summary>
        /// <param name="extension">Extension de archivo </param>
        /// <returns> retorna true si la extension es valida de lo contrario  false</returns>        

        private static bool extensionValida(String extension)
        {
            bool exten = false;
            String[] extensiones = new string[] { ".jpg", ".jpeg", ".pdf", ".png", ".doc", ".JPG", ".JPGE", ".PDF", ".PNG", ".DOC" };
            foreach(String e in extensiones){
                if (e.Equals(extension))
                {
                    exten = true;
                    break;
                }
            }
            return exten;
        }
        [MethodImpl(MethodImplOptions.Synchronized)]
        public static bool existeFile(String rutaLarga)
        {
            if (File.Exists(rutaLarga))
                return true;
            else return false;
        }
        
    }
}
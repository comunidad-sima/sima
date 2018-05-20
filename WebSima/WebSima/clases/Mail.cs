using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections;
using System.Net;
using System.Net.Mail;
using System.Net.Mime; 
namespace WebSima.clases
{
    public class Mail
    {
      private string  myMailAddress="sima@cecar.edu.co";
      private string myClave = "T5k1uTJP"; 
      
        public string enviarEMail(string[]correosDestino,string subject, string mensajeEMail)
        {
            string mensaje = "";            
            System.Net.Mail.MailMessage msg = new System.Net.Mail.MailMessage();
            foreach(string correo in correosDestino){
                msg.To.Add(new MailAddress(correo));
            }           
            msg.From = new MailAddress(myMailAddress, "SIMA", System.Text.Encoding.UTF8);
            msg.Subject = subject;
            msg.SubjectEncoding = System.Text.Encoding.UTF8;
            msg.Body = mensajeEMail;
            msg.BodyEncoding = System.Text.Encoding.UTF8;
            msg.IsBodyHtml = true; 

            //Aquí es donde se hace lo especial
            SmtpClient client = new SmtpClient();
            client.Credentials = new System.Net.NetworkCredential(myMailAddress, myClave);
            client.Port = 587;
            client.Host = "smtp.gmail.com";
            client.EnableSsl = true; //Esto es para que vaya a través de SSL que es obligatorio con GMail
            try
            {
                        client.Send(msg);
                        mensaje = "OK";

            }
            catch (Exception ex)
            {
                mensaje = (ex.Message);
                       
            }

            return mensaje;
        }
    }
}
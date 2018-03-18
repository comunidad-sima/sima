using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.Data.Common;
using System.Data.EntityClient;
using System.Data.SqlClient;
using System.Linq;
using System.Transactions;
using System.Web;

namespace WebSima.Models
{
    public class MTest
    {
        [Display(Name = "Código")]
        public int id { get; set; }
        [Display(Name = "Fecha de finalización")]
        
        [Required]
        public System.DateTime fecha_fin { get; set; }
        [Display(Name = "Fecha de inicio")]
        [Required]
        public System.DateTime fecha_inicio { get; set; }
        [Display(Name = "¿Quién responde?")]
        [Required]
        public string ferfil_usuario { get; set; }
        [Display(Name = "Eliminado")]        
        public byte eliminado { get; set; }
        [Display(Name = "Estado")]        
        public byte estado_cierre { get; set; }
        [Display(Name = "Creado")]        
        public string id_usuario_creado { get; set; }
        [Display(Name = "Período")]        
        public string periodo { get; set; }

        public virtual ICollection<pregunta_test_responder> pregunta_test_responder { get; set; }
        public virtual usuarios usuarios { get; set; }

        /// <summary>
        /// Registra un nuevo test en la bd
        /// </summary>
        /// <param name="db"></param>
        /// <param name="test"> obj con los datos del test </param>
        /// <param name="id_preguntas">yds de las preguntas asignadas al test</param>
        /// <returns></returns>
        public bool guardar_Test(bd_simaEntitie db, Test test, int[] id_preguntas, int id_test_actualizar=-1)
        {
            bool guardado = true;
            try
            {
                using (var transaccion = new TransactionScope())
                {
                    using (var contestTransaccion = new bd_simaEntitie())
                    {
                        if (id_test_actualizar==-1)
                        {
                            db.Test.Add(test);
                            db.SaveChanges();
                            add_pregunta_test(db, id_preguntas, test.id);
                        }
                        else
                        {
                            List<pregunta_test_responder> preguntas = (from pre in db.pregunta_test_responder
                                                                       where (pre.id_test == id_test_actualizar)
                                                                       select pre).ToList();
                            foreach (var pregunta in preguntas)
                            {
                                db.pregunta_test_responder.Remove(pregunta);
                            }
                            add_pregunta_test(db, id_preguntas, id_test_actualizar);
                            
                            
                        }
                       db.SaveChanges();
                       transaccion.Complete();
                    }
                }

            }
            catch (Exception)
            {
                guardado = false;
            }
            return guardado;
        }
        /// <summary>
        /// agrega las preguntas de un test
        /// </summary>
        /// <param name="db"></param>
        /// <param name="id_preguntas"></param>
        /// <param name="id_test"></param>
        private void add_pregunta_test(bd_simaEntitie db,int[] id_preguntas, int id_test)
        {
            pregunta_test_responder pregunta;
            foreach (int id in id_preguntas)
            {
                pregunta = new pregunta_test_responder
                {
                    id_pregunta_test = id,
                    id_test = id_test

                };
                db.pregunta_test_responder.Add(pregunta);

            }
        }
        /// <summary>
        /// guarda las respuesta de un test
        /// </summary>
        /// <param name="db"></param>
        /// <param name="respuestas"> Lista de objeto </param>
        /// <returns></returns>
        public bool guardar_respuestas_test(bd_simaEntitie db,  List<respuestas> respuestas)
        {
            bool guardado = true;
            try
            {
                using (var transaccion = new TransactionScope())
                {
                    using (var contestTransaccion = new bd_simaEntitie())
                    {
                                              
                        
                        foreach (respuestas respuesta in respuestas)
                        {
                            db.respuestas.Add(respuesta);
                            
                        }
                        db.SaveChanges();
                        transaccion.Complete();
                    }
                }

            }
            catch (Exception)
            {
                guardado = false;
            }
            return guardado;
        }
        /// <summary>
        /// Consulta los test en un periodo
        /// </summary>
        /// <param name="db"></param>
        /// <param name="periodo">Perido a consultar </param>
        /// <param name="estado_cierre"> el estado del test cerrado o abierto 0 o 1</param>
        /// <param name="eliminado"> el estado de eliminacion del test eliminado o no ,0 o 1</param>
        /// <returns></returns>
        public List<MTest> getTestPeriodo(bd_simaEntitie db, string periodo, int estado_cierre=0, int eliminado =0){
            List<MTest> test = null;

            test = (from p in db.Test
                      where (periodo.Equals(p.periodo) && p.eliminado == eliminado && p.estado_cierre == estado_cierre)
                      select new MTest
                      {
                          id=p.id,
                          eliminado=p.eliminado,
                          estado_cierre=p.estado_cierre,
                          fecha_fin=p.fecha_fin,
                          fecha_inicio=p.fecha_inicio,
                          ferfil_usuario=p.ferfil_usuario,
                          id_usuario_creado=p.id_usuario_creado,
                          periodo=p.periodo,
                          pregunta_test_responder=p.pregunta_test_responder,
                          usuarios=p.usuarios
                      }).ToList();
            return test;

        }
        /// <summary>
        /// Consulta un test por el id
        /// </summary>
        /// <param name="db"></param>
        /// <param name="id_test">id del test a consultar </param>
        /// <returns></returns>

        public MTest getTestPorId(bd_simaEntitie db, int id_test)
        {
            MTest Mtest = null;
            Test test = db.Test.Find(id_test);
            if (null != test)
            {
                Mtest = new MTest
                       {
                           id = test.id,
                           eliminado = test.eliminado,
                           estado_cierre = test.estado_cierre,
                           fecha_fin = test.fecha_fin,
                           fecha_inicio = test.fecha_inicio,
                           ferfil_usuario = test.ferfil_usuario,
                           id_usuario_creado = test.id_usuario_creado,
                           periodo = test.periodo,
                           pregunta_test_responder = test.pregunta_test_responder,
                           usuarios = test.usuarios
                       };
            }

            return Mtest;

        
        }
        /// <summary>
        /// Consulta los test que no estan cerrados
        /// </summary>
        /// <param name="db"></param>
        /// <param name="estado_cierre"> el estado del test cerrado o abierto (0 o 1)</param>
        /// <param name="eliminado"> el estado de eliminacion del test eliminado o no (0 o 1)</param>
        /// <returns></returns>
        public List<MTest> getTest_abiertos(bd_simaEntitie db, int estado_cierre, int eliminado )
        {
            List<MTest> test = null;

            test = (from p in db.Test
                    where (p.eliminado == eliminado && p.estado_cierre == estado_cierre)
                    select new MTest
                    {
                        id = p.id,
                        eliminado = p.eliminado,
                        estado_cierre = p.estado_cierre,
                        fecha_fin = p.fecha_fin,
                        fecha_inicio = p.fecha_inicio,
                        ferfil_usuario = p.ferfil_usuario,
                        id_usuario_creado = p.id_usuario_creado,
                        periodo = p.periodo,
                        pregunta_test_responder = p.pregunta_test_responder,
                        usuarios = p.usuarios
                    }).ToList();
            return test;
        }
        /// <summary>
        /// se consulta id de la relacion entre la preguntas y el rest 
        /// </summary>
        /// <param name="db"></param>
        /// <param name="id_test"></param>
        /// <returns></returns>
        public pregunta_test_responder getPregunta_test_responder(bd_simaEntitie db, int id_test, int id_pregunta)
        {
            pregunta_test_responder preguntas = null;

            preguntas = (from pre in db.pregunta_test_responder
                        
                         where(pre.id_test==id_test && pre.id_pregunta_test==id_pregunta)
                         
                         select  pre).First();
  
            return preguntas;
        }
        /// <summary>
        /// Se consulta las preguntas de un test segun el estado  no esten eliminado(0) 
        /// </summary>
        /// <param name="db"></param>
        /// <param name="id_test"></param>
        /// <returns></returns>
        public List<MPreguntas_test> getPreguntas_test_a_resonder(bd_simaEntitie db, int id_test)
        {
            List<MPreguntas_test> preguntas = null;

            preguntas = (from t in db.Test
                         join pr in db.pregunta_test_responder on t.id equals pr.id_test
                         join p in db.preguntas_test on pr.id_pregunta_test equals p.id
                         where (t.id == id_test && p.eliminado==0)
                         orderby (p.tipo) descending
                         select new MPreguntas_test
                         {
                             eliminado = p.eliminado,
                             id = p.id,
                             Pregunata = p.Pregunata,
                             tipo = p.tipo,
                             pregunta_test_responder = p.pregunta_test_responder
                         }).ToList();

            return preguntas;
        }

        /// <summary>
        /// Consulta todas las preguntas de un test, si la pregunta esta eliminada tambien se mostrará 
        /// </summary>
        /// <param name="db"></param>
        /// <param name="id_test"></param>
        /// <returns></returns>
        public List<MPreguntas_test> getPreguntas_test(bd_simaEntitie db, int id_test)
        {
            List<MPreguntas_test> preguntas = null;

            preguntas = (from t in db.Test
                         join pr in db.pregunta_test_responder on t.id equals pr.id_test
                         join p in db.preguntas_test on pr.id_pregunta_test equals p.id
                         where (t.id == id_test )
                         orderby (p.tipo) descending
                         select new MPreguntas_test
                         {
                             eliminado = p.eliminado,
                             id = p.id,
                             Pregunata = p.Pregunata,
                             tipo = p.tipo,
                             pregunta_test_responder = p.pregunta_test_responder
                         }).ToList();

            return preguntas;
        }
        /// <summary>
        /// consulta si el ususrio ya respondio el test de un curso o monitor
        /// </summary>
        /// <param name="id_curso"></param>
        /// <param name="id_test"></param>
        /// <returns></returns>
        public  bool isRespondioTest( int id_curso, int id_test )
        {
            bd_simaEntitie db = new bd_simaEntitie();
            Sesion sesion= new Sesion();
            String id_usuario_ = sesion.getIdUsuario();
            bool respondio=false;
        
            var respuesta= (from t in db.Test
                         join p in db.pregunta_test_responder on t.id equals p.id_test
                            join r in db.respuestas on p.id equals r.id_preguntas_test_respustas
                         where (t.id == id_test && r.id_persona==id_usuario_ && r.id_curso==id_curso)                         
                         select  r).ToList();


            if (respuesta.Count()> 0)
                respondio = true;

            return respondio;
       
        }
        /// <summary>
        /// Consulta la cantidad de test que ha respondido un usuario en un periodo
        /// </summary>
        /// <param name="db"></param>
        /// <param name="id_usuario"></param>
        /// <param name="periodo_"></param>
        /// <returns>vector 2 posisiciones. id pregunta, puntaje</returns>
        public int contarTestRespondidoPeriodo(bd_simaEntitie db, String id_usuario,String periodo_)
        {
            //select Distinct(t.id) from Test t , respuestas r , pregunta_test_responder p 
 //where ( t.id= p.id_test and p.id = r.id_preguntas_test_respustas and r.id_persona ='1000248961' and t.periodo='2017-2' )
            var respuesta = (from t in db.Test
                             join p in db.pregunta_test_responder on t.id equals p.id_test
                             join r in db.respuestas on p.id equals r.id_preguntas_test_respustas
                             where (t.id==p.id_test && p.id== r.id_preguntas_test_respustas
                             && r.id_persona== id_usuario && periodo_== t.periodo)
                             select t).Distinct();
            return respuesta.Count();
        }
        /// <summary>
        /// Se consulta las preguntas de un tes con el puntos obtenediso por los votantes de tipo cerrada
        /// </summary>
        /// <param name="id_test"></param>
        /// <returns></returns>
        public List<String[]> getPreguntaPuntosTotal(int id_test, int id_curso=-1)
        {
            String sql;
            if(id_curso>0)
             sql = @"select  p.id_pregunta_test,  SUM(r.punto) from bd_simaEntitie.Test as t, " +
                "bd_simaEntitie.pregunta_test_responder as p, bd_simaEntitie.respuestas as r , bd_simaEntitie.preguntas_test as pt " +
                "where(t.id=p.id_test and p.id = r.id_preguntas_test_respustas and "+
                " p.id_pregunta_test =pt.id and t.id= @id_test and r.id_curso= @id_curso and pt.tipo= 'Cerrada' ) " +
                "GROUP BY  p.id_pregunta_test";
            else
                sql = @"select  p.id_pregunta_test,  SUM(r.punto) from bd_simaEntitie.Test as t, " +
                "bd_simaEntitie.pregunta_test_responder as p, bd_simaEntitie.respuestas as r , bd_simaEntitie.preguntas_test as pt " +
                "where(t.id=p.id_test and p.id = r.id_preguntas_test_respustas and " +
                " p.id_pregunta_test =pt.id and t.id= @id_test  and pt.tipo= 'Cerrada' ) " +
                "GROUP BY  p.id_pregunta_test";

            List<String[]> puntos = new List<String[]>();
            using (EntityConnection conn = new EntityConnection("name=bd_simaEntitie"))
            {
                conn.Open();

                using (EntityCommand cmd = new EntityCommand(sql, conn))
                {
                    // Create two parameters and add them to 
                    // the EntityCommand's Parameters collection 
                    EntityParameter param1 = new EntityParameter();
                    param1.ParameterName = "id_test";
                    param1.Value = id_test;
                    cmd.Parameters.Add(param1); ;
                    if (id_curso > 0)
                    {
                        EntityParameter param2 = new EntityParameter();
                        param2.ParameterName = "id_curso";
                        param2.Value = id_curso;
                        cmd.Parameters.Add(param2); ;
                    }
                    
                    using (DbDataReader rdr = cmd.ExecuteReader(CommandBehavior.SequentialAccess))
                    {

                        while (rdr.Read())
                        {
                            String[] dato = new String[2];
                            dato[0] = "" + rdr.GetInt32(0);
                            dato[1] = ""+ rdr.GetInt32(1);
                            puntos.Add(dato);

                        }
                    }
                }
                conn.Close();
            }
            return puntos.OrderBy(m => m[0]).ToList();
        
        }
        /// <summary>
        /// Consulta las preguntas de tipo abierta con sus cometarios de un test
        /// </summary>
        /// <param name="id_test"></param>
        /// <returns></returns>
        public List<String[]> getCometariosPreguntasAbiertaTest(int id_test, int id_curso=-1)
        {
            String sql;
            if(id_curso>0)
            sql = @"select  p.id_pregunta_test,  r.observacion from bd_simaEntitie.Test as t," +
                " bd_simaEntitie.pregunta_test_responder as p, bd_simaEntitie.respuestas as r , bd_simaEntitie.preguntas_test as pt " +
                " where(t.id=p.id_test and p.id=r.id_preguntas_test_respustas and "+
                " p.id_pregunta_test =pt.id and t.id= @id_test  and r.id_curso= @id_curso and pt.tipo='Abierta' ) ";
            else
                sql = @"select  p.id_pregunta_test,  r.observacion from bd_simaEntitie.Test as t," +
               " bd_simaEntitie.pregunta_test_responder as p, bd_simaEntitie.respuestas as r , bd_simaEntitie.preguntas_test as pt " +
               " where(t.id=p.id_test and p.id=r.id_preguntas_test_respustas and " +
               " p.id_pregunta_test =pt.id and t.id= @id_test  and pt.tipo='Abierta'  ) "; 

            List<String[]> puntos = new List<String[]>();
            using (EntityConnection conn = new EntityConnection("name=bd_simaEntitie"))
            {
                conn.Open();

                using (EntityCommand cmd = new EntityCommand(sql, conn))
                {
                    // Create two parameters and add them to 
                    // the EntityCommand's Parameters collection 
                    EntityParameter param1 = new EntityParameter();
                    param1.ParameterName = "id_test";
                    param1.Value = id_test;
                    cmd.Parameters.Add(param1); ;
                    if (id_curso > 0)
                    {
                        EntityParameter param2 = new EntityParameter();
                        param2.ParameterName = "id_curso";
                        param2.Value = id_curso;
                        cmd.Parameters.Add(param2); ;
                    }


                    using (DbDataReader rdr = cmd.ExecuteReader(CommandBehavior.SequentialAccess))
                    {

                        while (rdr.Read())
                        {
                            String[] dato = new String[2];
                            dato[0] = "" + rdr.GetInt32(0);
                            try
                            {
                                dato[1] = rdr.GetString(1);
                            }
                            catch (Exception)
                            {
                                dato[1] = "";
                            }
                            puntos.Add(dato);

                        }
                    }
                }
                conn.Close();
            }
            return puntos.OrderBy(m => m[0]).ToList();

        }
        /// <summary>
        /// Cuenta la cantidad de susrios que han realizado un test
        /// </summary>
        /// <param name="id_test"></param>
        /// <param name="id_curso"></param>
        /// <returns></returns>
        public int ContarCantidaUasuarioRespondenTest(int id_test, int id_curso = -1)
        {
            String sql;
            // si id curso es negagativo  se consulta en general, si es diferente de 0 se filtra por el curso
            if (id_curso > 0)
                sql = @"select  DISTINCT(r.id_persona) from bd_simaEntitie.Test as t, bd_simaEntitie.pregunta_test_responder as p, " +
                    "bd_simaEntitie.respuestas as r , bd_simaEntitie.preguntas_test as pt  where(t.id=p.id_test and " +
                    "p.id=r.id_preguntas_test_respustas and p.id_pregunta_test =pt.id and t.id= @id_test  and r.id_curso= @id_curso )";
           
            else
                sql = @"select  DISTINCT(r.id_persona) from bd_simaEntitie.Test as t, bd_simaEntitie.pregunta_test_responder as p, " +
                    "bd_simaEntitie.respuestas as r , bd_simaEntitie.preguntas_test as pt  where(t.id=p.id_test and " +
                    "p.id=r.id_preguntas_test_respustas and p.id_pregunta_test =pt.id and t.id= @id_test)";

            int cantidad = 0;
            using (EntityConnection conn = new EntityConnection("name=bd_simaEntitie"))
            {
                conn.Open();
                using (EntityCommand cmd = new EntityCommand(sql, conn))
                {
                    // Create two parameters and add them to 
                    // the EntityCommand's Parameters collection 
                    EntityParameter param1 = new EntityParameter();
                    param1.ParameterName = "id_test";
                    param1.Value = id_test;
                    cmd.Parameters.Add(param1); ;
                    if (id_curso > 0)
                    {
                        EntityParameter param2 = new EntityParameter();
                        param2.ParameterName = "id_curso";
                        param2.Value = id_curso;
                        cmd.Parameters.Add(param2); ;
                    }
                    using (DbDataReader rdr = cmd.ExecuteReader(CommandBehavior.SequentialAccess))
                    {                       
                        while (rdr.Read())
                         cantidad++;
                    }
                }
                conn.Close();
            }
            return cantidad;

        }
        public bool actualizar_test(bd_simaEntitie db, MTest test)
        {
            bool actualizado = false;
            try
            {
                Test test_ = db.Test.Find(test.id);
                test_.eliminado = 0;
                test_.estado_cierre = 0;
                test_.fecha_fin = test.fecha_fin;
                test_.fecha_inicio = test.fecha_inicio;
                test_.periodo = MConfiguracionApp.getPeridoActual(db);
                test_.ferfil_usuario = test.ferfil_usuario;
                test_.id = test.id;
                db.Entry(test_).State = EntityState.Modified;
                db.SaveChanges();
                actualizado = true;
            }
            catch (Exception)
            {

            }
            return actualizado;

        }

    }
}
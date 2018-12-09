create or replace PACKAGE CapacitacionPKG
IS
PROCEDURE cap_agregar (
			id_capacitacion IN CAPACITACION.ID_CAP%TYPE,
			nom_cap IN CAPACITACION.NOMBRE_CAPACITACION%TYPE,
			estado_cap IN CAPACITACION.ESTADO_CAPACITACION%TYPE,
			plan_c_id_plan_c IN CAPACITACION.PLAN_CAP_ID_PLAN_CAP%TYPE,
			tipo_c_id_tipo_c IN CAPACITACION.TIPO_CAP_ID_TIPO_CAP%TYPE,
      cur OUT SYS_REFCURSOR);
PROCEDURE cap_eliminar (id_capacitacion IN CAPACITACION.ID_CAP%TYPE, estado_cap IN CAPACITACION.ESTADO_CAPACITACION%TYPE);
PROCEDURE cap_modificar (
			nom_cap IN CAPACITACION.NOMBRE_CAPACITACION%TYPE,
			estado_cap IN CAPACITACION.ESTADO_CAPACITACION%TYPE,
			plan_c_id_plan_c IN CAPACITACION.PLAN_CAP_ID_PLAN_CAP%TYPE,
			tipo_c_id_tipo_c IN CAPACITACION.TIPO_CAP_ID_TIPO_CAP%TYPE,
			id_capacitacion IN CAPACITACION.ID_CAP%TYPE);
PROCEDURE cap_consultar (id_capacitacion IN CAPACITACION.ID_CAP%TYPE, cur OUT SYS_REFCURSOR);
PROCEDURE All_capacitacion_consultar (estado_cap IN CAPACITACION.ESTADO_CAPACITACION%TYPE , cur OUT SYS_REFCURSOR);
END capacitacionPKG;
/

create or replace PACKAGE BODY CapacitacionPKG
IS
PROCEDURE cap_agregar (
			id_capacitacion IN CAPACITACION.ID_CAP%TYPE,
			nom_cap IN CAPACITACION.NOMBRE_CAPACITACION%TYPE,
			estado_cap IN CAPACITACION.ESTADO_CAPACITACION%TYPE,
			plan_c_id_plan_c IN CAPACITACION.PLAN_CAP_ID_PLAN_CAP%TYPE,
			tipo_c_id_tipo_c IN CAPACITACION.TIPO_CAP_ID_TIPO_CAP%TYPE,
      cur OUT SYS_REFCURSOR)
IS 
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM CAPACITACION
WHERE ID_CAP = id_capacitacion;			
IF contar = 0 THEN 
  INSERT INTO CAPACITACION VALUES (id_capacitacion, nom_cap, estado_cap, plan_c_id_plan_c, tipo_c_id_tipo_c);
  OPEN cur FOR
  SELECT *
  FROM CAPACITACION
  WHERE ID_CAP = (SELECT MAX(ID_CAP) FROM CAPACITACION);
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20001, 'La Capacitación Existe, No se puede agregar al sistema');
  ROLLBACK;
END IF;  
END cap_agregar;

PROCEDURE cap_eliminar (id_capacitacion IN CAPACITACION.ID_CAP%TYPE, estado_cap IN CAPACITACION.ESTADO_CAPACITACION%TYPE)
IS
contar NUMBER(1) := 0;
resp CAPACITACION.ID_CAP%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM CAPACITACION
WHERE ID_CAP = id_capacitacion;
IF contar = 1 THEN 
  UPDATE CAPACITACION SET ESTADO_CAPACITACION = estado_cap
  WHERE ID_CAP = id_capacitacion
  RETURNING id_capacitacion INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La Capcitacion NO Existe, Verifique Capacitación');
  ROLLBACK;
END IF; 
END cap_eliminar;

PROCEDURE cap_modificar (
			nom_cap IN CAPACITACION.NOMBRE_CAPACITACION%TYPE,
			estado_cap IN CAPACITACION.ESTADO_CAPACITACION%TYPE,
			plan_c_id_plan_c IN CAPACITACION.PLAN_CAP_ID_PLAN_CAP%TYPE,
			tipo_c_id_tipo_c IN CAPACITACION.TIPO_CAP_ID_TIPO_CAP%TYPE,
			id_capacitacion IN CAPACITACION.ID_CAP%TYPE)
IS
contar NUMBER(1) := 0;
resp CAPACITACION.ID_CAP%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM CAPACITACION
WHERE ID_CAP = id_capacitacion;
IF contar = 1 THEN 
  UPDATE CAPACITACION SET 
                  NOMBRE_CAPACITACION = nom_cap, 
                  ESTADO_CAPACITACION = estado_cap, 
                  PLAN_CAP_ID_PLAN_CAP = plan_c_id_plan_c, 
                  TIPO_CAP_ID_TIPO_CAP = tipo_c_id_tipo_c
  WHERE ID_CAP = id_capacitacion RETURNING id_capacitacion INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La Capacitacion NO Existe, Verifique Capacitación');
  ROLLBACK;
END IF;  
END cap_modificar;

PROCEDURE cap_consultar (id_capacitacion IN CAPACITACION.ID_CAP%TYPE, cur OUT SYS_REFCURSOR)
IS
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM CAPACITACION
WHERE ID_CAP = id_capacitacion;
IF contar = 1 THEN 
  OPEN cur FOR
  SELECT ID_CAP, NOMBRE_CAPACITACION, ESTADO_CAPACITACION, PLAN_CAP_ID_PLAN_CAP, TIPO_CAP_ID_TIPO_CAP
  FROM CAPACITACION
  WHERE ID_CAP = id_capacitacion AND ESTADO_CAPACITACION > 0;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La Capacitacion NO Existe, Verifique Capacitación');
  ROLLBACK;
END IF; 
END cap_consultar;

PROCEDURE All_capacitacion_consultar (estado_cap IN CAPACITACION.ESTADO_CAPACITACION%TYPE , cur OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN cur FOR
  SELECT ID_CAP, NOMBRE_CAPACITACION, ESTADO_CAPACITACION, PLAN_CAP_ID_PLAN_CAP, TIPO_CAP_ID_TIPO_CAP
  FROM CAPACITACION
  WHERE ESTADO_CAPACITACION >= estado_cap;
  COMMIT;
END All_capacitacion_consultar;
END CapacitacionPKG;
/

create or replace PACKAGE CertificadoPKG
IS
PROCEDURE cetificado_agregar (
			id_cer IN CERTIFICADO.ID_CERTIFICADO%TYPE,
			tipo_cer IN CERTIFICADO.TIPO_CERTIFICADO%TYPE,
			cod_cer IN CERTIFICADO.COD_CERTIFICADO%TYPE,
			estado_cer IN CERTIFICADO.ESTADO%TYPE,
      f_creacion IN CERTIFICADO.FECHACREACION%TYPE,
      id_cliente IN CERTIFICADO.CLIENTE_ID_CLIENTE%TYPE,
      cur OUT SYS_REFCURSOR);
PROCEDURE certificado_eliminar (id_cer IN CERTIFICADO.ID_CERTIFICADO%TYPE, estado_cer IN CERTIFICADO.ESTADO%TYPE);
PROCEDURE certificado_modificar (
			tipo_cer IN CERTIFICADO.TIPO_CERTIFICADO%TYPE,
			cod_cer IN CERTIFICADO.COD_CERTIFICADO%TYPE,
			estado_cer IN CERTIFICADO.ESTADO%TYPE,
      f_creacion IN CERTIFICADO.FECHACREACION%TYPE,
      id_cliente IN CERTIFICADO.CLIENTE_ID_CLIENTE%TYPE,
			id_cer IN CERTIFICADO.ID_CERTIFICADO%TYPE);
PROCEDURE certificado_consultar (id_cer IN CERTIFICADO.ID_CERTIFICADO%TYPE, cur OUT SYS_REFCURSOR);
PROCEDURE All_certificado_consultar (estado_cer IN CERTIFICADO.ESTADO%TYPE, cur OUT SYS_REFCURSOR);
END CertificadoPKG;
/

create or replace PACKAGE BODY CertificadoPKG
IS
PROCEDURE cetificado_agregar (
			id_cer IN CERTIFICADO.ID_CERTIFICADO%TYPE,
			tipo_cer IN CERTIFICADO.TIPO_CERTIFICADO%TYPE,
			cod_cer IN CERTIFICADO.COD_CERTIFICADO%TYPE,
			estado_cer IN CERTIFICADO.ESTADO%TYPE,
      f_creacion IN CERTIFICADO.FECHACREACION%TYPE,
      id_cliente IN CERTIFICADO.CLIENTE_ID_CLIENTE%TYPE,
      cur OUT SYS_REFCURSOR)
IS 
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM CERTIFICADO
WHERE ID_CERTIFICADO = id_cer;			
IF contar = 0 THEN 
  INSERT INTO CERTIFICADO VALUES (id_cer, tipo_cer, cod_cer, estado_cer,(TO_DATE(f_creacion,'dd-mm-rr')), id_cliente);
  OPEN cur FOR
  SELECT *
  FROM CERTIFICADO
  WHERE ID_CERTIFICADO = (SELECT MAX(ID_CERTIFICADO) FROM CERTIFICADO);
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20001, 'El Certificado Existe, No se puede agregar el certificado al sistema');
  ROLLBACK;
END IF;  
END cetificado_agregar;

PROCEDURE certificado_eliminar (id_cer IN CERTIFICADO.ID_CERTIFICADO%TYPE, estado_cer IN CERTIFICADO.ESTADO%TYPE)
IS
contar NUMBER(1) := 0;
resp CERTIFICADO.ID_CERTIFICADO%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM CERTIFICADO
WHERE ID_CERTIFICADO = id_cer;
IF contar = 1 THEN 
  UPDATE CERTIFICADO SET ESTADO = estado_cer
  WHERE ID_CERTIFICADO = id_cer
  RETURNING id_cer INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El Certificado NO Existe, Verifique Certificado');
  ROLLBACK;
END IF; 
END certificado_eliminar;

PROCEDURE certificado_modificar (
			tipo_cer IN CERTIFICADO.TIPO_CERTIFICADO%TYPE,
			cod_cer IN CERTIFICADO.COD_CERTIFICADO%TYPE,
			estado_cer IN CERTIFICADO.ESTADO%TYPE,
      f_creacion IN CERTIFICADO.FECHACREACION%TYPE,
      id_cliente IN CERTIFICADO.CLIENTE_ID_CLIENTE%TYPE,
			id_cer IN CERTIFICADO.ID_CERTIFICADO%TYPE)
IS
contar NUMBER(1) := 0;
resp CERTIFICADO.ID_CERTIFICADO%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM CERTIFICADO
WHERE ID_CERTIFICADO = id_cer;
IF contar = 1 THEN 
  UPDATE CERTIFICADO SET 
                  TIPO_CERTIFICADO = tipo_cer, 
                  COD_CERTIFICADO = cod_cer, 
                  ESTADO = estado_cer,
                  FECHACREACION = f_creacion,
                  CLIENTE_ID_CLIENTE = id_cliente
  WHERE ID_CERTIFICADO = id_cer RETURNING id_cer INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El Certificado NO Existe, Verifique Certificado');
  ROLLBACK;
END IF;  
END certificado_modificar;

PROCEDURE certificado_consultar (id_cer IN CERTIFICADO.ID_CERTIFICADO%TYPE, cur OUT SYS_REFCURSOR)
IS
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM CERTIFICADO
WHERE ID_CERTIFICADO = id_cer;
IF contar = 1 THEN 
  OPEN cur FOR
  SELECT ID_CERTIFICADO, TIPO_CERTIFICADO, COD_CERTIFICADO, ESTADO, FECHACREACION, CLIENTE_ID_CLIENTE
  FROM CERTIFICADO
  WHERE ID_CERTIFICADO = id_cer AND ESTADO > 0;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El Certificado NO Existe, Verifique Certificado');
  ROLLBACK;
END IF; 
END certificado_consultar;

PROCEDURE All_certificado_consultar (estado_cer IN CERTIFICADO.ESTADO%TYPE, cur OUT SYS_REFCURSOR)
IS
BEGIN
OPEN cur FOR
      SELECT ID_CERTIFICADO, TIPO_CERTIFICADO, COD_CERTIFICADO, ESTADO, FECHACREACION, CLIENTE_ID_CLIENTE
      FROM CERTIFICADO
      WHERE ESTADO = estado_cer;
      COMMIT;
END All_certificado_consultar;

END CertificadoPKG;
/

create or replace PACKAGE ClientePKG
IS 
PROCEDURE Cliente_Agregar (
                          id_cli IN CLIENTE.ID_CLIENTE%TYPE,
                          raz_soc IN CLIENTE.RAZON_SOCIAL%TYPE, 
                          rut_cli IN CLIENTE.RUT_CLIENTE%TYPE, 
                          giro_cli IN CLIENTE.GIRO_CLIENTE%TYPE,
                          dir_cli IN CLIENTE.DIRECCION_CLIENTE%TYPE, 
                          tel_of IN CLIENTE.TEL_OFICINA%TYPE, 
                          nom_contacto IN CLIENTE.NOMBRE_CONTACTO%TYPE, 
                          fn_contacto IN CLIENTE.FONO_CONTACTO%TYPE,
                          correo_Contacto IN CLIENTE.MAIL_CONTACTO%TYPE, 
                          cargo IN CLIENTE.CARGO_CONTACTO%TYPE, 
                          obs IN CLIENTE.OBSERVACIONES_CLIENTE%TYPE,
                          est_cli IN CLIENTE.ESTADO_CLIENTE%TYPE,
                          f_creacion IN CLIENTE.FECHACREACION%TYPE,
                          cur OUT SYS_REFCURSOR);
PROCEDURE Cliente_Eliminar (rut_cli IN CLIENTE.RUT_CLIENTE%TYPE, est_cli IN CLIENTE.ESTADO_CLIENTE%TYPE);
PROCEDURE Cliente_Modificar (
                          raz_soc IN CLIENTE.RAZON_SOCIAL%TYPE, 
                          rut_cli IN CLIENTE.RUT_CLIENTE%TYPE, 
                          giro_cli IN CLIENTE.GIRO_CLIENTE%TYPE, 
                          dir_cli IN CLIENTE.DIRECCION_CLIENTE%TYPE, 
                          tel_of IN CLIENTE.TEL_OFICINA%TYPE, 
                          nom_contacto IN CLIENTE.NOMBRE_CONTACTO%TYPE, 
                          fn_contacto IN CLIENTE.FONO_CONTACTO%TYPE,
                          correo_Contacto IN CLIENTE.MAIL_CONTACTO%TYPE, 
                          cargo IN CLIENTE.CARGO_CONTACTO%TYPE, 
                          obs IN CLIENTE.OBSERVACIONES_CLIENTE%TYPE, 
                          est_cli IN CLIENTE.ESTADO_CLIENTE%TYPE,
                          f_creacion IN CLIENTE.FECHACREACION%TYPE,
                          id_cli IN CLIENTE.ID_CLIENTE%TYPE);
PROCEDURE Cliente_Consultar (rut_cli IN CLIENTE.RUT_CLIENTE%TYPE, cur OUT SYS_REFCURSOR);
PROCEDURE Cliente_Consultar_id (id_cli IN CLIENTE.ID_CLIENTE%TYPE, cur OUT SYS_REFCURSOR);
PROCEDURE All_Cliente_Consultar (estado IN CLIENTE.ESTADO_CLIENTE%TYPE, cur OUT SYS_REFCURSOR);
END ClientePKG;
/

create or replace PACKAGE BODY ClientePKG
IS
PROCEDURE Cliente_Agregar (
                          id_cli IN CLIENTE.ID_CLIENTE%TYPE,
                          raz_soc IN CLIENTE.RAZON_SOCIAL%TYPE, 
                          rut_cli IN CLIENTE.RUT_CLIENTE%TYPE, 
                          giro_cli IN CLIENTE.GIRO_CLIENTE%TYPE,
                          dir_cli IN CLIENTE.DIRECCION_CLIENTE%TYPE, 
                          tel_of IN CLIENTE.TEL_OFICINA%TYPE, 
                          nom_contacto IN CLIENTE.NOMBRE_CONTACTO%TYPE, 
                          fn_contacto IN CLIENTE.FONO_CONTACTO%TYPE,
                          correo_Contacto IN CLIENTE.MAIL_CONTACTO%TYPE, 
                          cargo IN CLIENTE.CARGO_CONTACTO%TYPE, 
                          obs IN CLIENTE.OBSERVACIONES_CLIENTE%TYPE,
                          est_cli IN CLIENTE.ESTADO_CLIENTE%TYPE,
                          f_creacion IN CLIENTE.FECHACREACION%TYPE,
                          cur OUT SYS_REFCURSOR)
IS
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM cliente 
WHERE rut_cliente = rut_cli;
IF contar = 0 THEN 
  INSERT INTO Cliente VALUES (id_cli, raz_soc, rut_cli, giro_cli, dir_cli, tel_of, nom_contacto, 
                              fn_contacto, correo_Contacto, cargo, obs, est_cli, (TO_DATE(f_creacion,'dd-mm-rr')));
  OPEN cur FOR
  SELECT *
  FROM CLIENTE
  WHERE ID_CLIENTE = (SELECT MAX(ID_CLIENTE) FROM CLIENTE);
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20001, 'El Usuario Existe, No se puede agregar al sistema');
  ROLLBACK;
END IF;  
END Cliente_Agregar;

PROCEDURE Cliente_Eliminar (rut_cli IN CLIENTE.RUT_CLIENTE%TYPE, est_cli IN CLIENTE.ESTADO_CLIENTE%TYPE)
IS
contar NUMBER(1) := 0;
resp CLIENTE.ID_CLIENTE%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM CLIENTE
WHERE RUT_CLIENTE = rut_cli;
IF contar = 1 THEN 
  UPDATE CLIENTE SET ESTADO_CLIENTE = est_cli
  WHERE RUT_CLIENTE = rut_cli
  RETURNING rut_cli INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El cliente NO Existe, Verifique Cliente');
  ROLLBACK;
END IF; 
END Cliente_Eliminar;

PROCEDURE Cliente_Modificar (
                              raz_soc IN CLIENTE.RAZON_SOCIAL%TYPE,
                              rut_cli IN CLIENTE.RUT_CLIENTE%TYPE, 
                              giro_cli IN CLIENTE.GIRO_CLIENTE%TYPE, 
                              dir_cli IN CLIENTE.DIRECCION_CLIENTE%TYPE,
                              tel_of IN CLIENTE.TEL_OFICINA%TYPE, 
                              nom_contacto IN CLIENTE.NOMBRE_CONTACTO%TYPE, 
                              fn_contacto IN CLIENTE.FONO_CONTACTO%TYPE,
                              correo_Contacto IN CLIENTE.MAIL_CONTACTO%TYPE, 
                              cargo IN CLIENTE.CARGO_CONTACTO%TYPE, 
                              obs IN CLIENTE.OBSERVACIONES_CLIENTE%TYPE, 
                              est_cli IN CLIENTE.ESTADO_CLIENTE%TYPE,
                              f_creacion IN CLIENTE.FECHACREACION%TYPE,
                              id_cli IN CLIENTE.ID_CLIENTE%TYPE)
IS
contar NUMBER(1) := 0;
resp CLIENTE.id_cliente%type;
BEGIN
SELECT COUNT(*) INTO contar
FROM cliente 
WHERE id_cliente = id_cli;
IF contar = 1 THEN 
  UPDATE Cliente SET 
                  RAZON_SOCIAL = raz_soc, 
                  RUT_CLIENTE = rut_cli, 
                  GIRO_CLIENTE = giro_cli, 
                  DIRECCION_CLIENTE = dir_cli, 
                  TEL_OFICINA = tel_of, 
                  NOMBRE_CONTACTO = nom_contacto,
                  FONO_CONTACTO = fn_contacto, 
                  MAIL_CONTACTO = correo_contacto, 
                  CARGO_CONTACTO = cargo, 
                  OBSERVACIONES_CLIENTE = obs,
                  FECHACREACION = f_creacion,
		  ESTADO_CLIENTE = est_cli
  WHERE ID_CLIENTE = id_cli RETURNING id_cli INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El Usuario NO Existe, Verifique RUT del cliente');
  ROLLBACK;
END IF;  
END Cliente_Modificar;

PROCEDURE Cliente_Consultar (rut_cli IN CLIENTE.RUT_CLIENTE%TYPE, cur OUT SYS_REFCURSOR)
IS
contar NUMBER(1) := 0;
BEGIN
    SELECT COUNT(*) INTO contar
    FROM cliente 
    WHERE RUT_CLIENTE = rut_cli;
    IF contar = 1 THEN 
      OPEN cur FOR
      SELECT ID_CLIENTE, RAZON_SOCIAL, RUT_CLIENTE, GIRO_CLIENTE, DIRECCION_CLIENTE, TEL_OFICINA, 
            NOMBRE_CONTACTO, FONO_CONTACTO, MAIL_CONTACTO, CARGO_CONTACTO, OBSERVACIONES_CLIENTE, ESTADO_CLIENTE, FECHACREACION
      FROM CLIENTE
      WHERE RUT_CLIENTE = rut_cli AND ESTADO_CLIENTE > 0;
    COMMIT;
    ELSE
      RAISE_APPLICATION_ERROR(-20002, 'El Usuario NO Existe, Verifique RUT del cliente');
      ROLLBACK;
END IF;
END Cliente_Consultar;

PROCEDURE Cliente_Consultar_id (id_cli IN CLIENTE.ID_CLIENTE%TYPE, cur OUT SYS_REFCURSOR)
IS
contar NUMBER(1) := 0;
BEGIN
    SELECT COUNT(*) INTO contar
    FROM cliente 
    WHERE ID_CLIENTE = id_cli;
    IF contar = 1 THEN 
      OPEN cur FOR
      SELECT ID_CLIENTE, RAZON_SOCIAL, RUT_CLIENTE, GIRO_CLIENTE, DIRECCION_CLIENTE, TEL_OFICINA, 
            NOMBRE_CONTACTO, FONO_CONTACTO, MAIL_CONTACTO, CARGO_CONTACTO, OBSERVACIONES_CLIENTE, ESTADO_CLIENTE, FECHACREACION
      FROM CLIENTE
      WHERE ID_CLIENTE = id_cli AND ESTADO_CLIENTE > 0;
    COMMIT;
    ELSE
      RAISE_APPLICATION_ERROR(-20002, 'El Usuario NO Existe, Verifique RUT del cliente');
      ROLLBACK;
END IF;
END Cliente_Consultar_id;

PROCEDURE All_Cliente_Consultar (estado IN CLIENTE.ESTADO_CLIENTE%TYPE, cur OUT SYS_REFCURSOR)
IS
BEGIN
      OPEN cur FOR
      SELECT ID_CLIENTE, RAZON_SOCIAL, RUT_CLIENTE, GIRO_CLIENTE, DIRECCION_CLIENTE, TEL_OFICINA, 
            NOMBRE_CONTACTO, FONO_CONTACTO, MAIL_CONTACTO, CARGO_CONTACTO, OBSERVACIONES_CLIENTE, ESTADO_CLIENTE, FECHACREACION
      FROM CLIENTE
      WHERE ESTADO_CLIENTE = ESTADO;
      COMMIT;
        
END All_Cliente_Consultar;

END CLIENTEPKG;
/

create or replace PACKAGE Estado_Eval_Terr_PKG
IS
PROCEDURE estado_eval_terr_agregar (
			id_est IN Estado_Eval_Terr.ID_ESTADO%TYPE,
			descrip_est_eval_terr IN Estado_Eval_Terr.DESCRIP_ESTADO_EVAL_TERR%TYPE,
			est_est IN Estado_Eval_Terr.ESTADO%TYPE,
      cur OUT SYS_REFCURSOR);
PROCEDURE estado_eval_terr_eliminar (id_est IN Estado_Eval_Terr.ID_ESTADO%TYPE, est_est IN Estado_Eval_Terr.ESTADO%TYPE);
PROCEDURE estado_eval_terr_modificar (
			descrip_est_eval_terr IN Estado_Eval_Terr.DESCRIP_ESTADO_EVAL_TERR%TYPE,
			est_est IN Estado_Eval_Terr.ESTADO%TYPE,
			id_est IN Estado_Eval_Terr.ID_ESTADO%TYPE);
PROCEDURE estado_eval_terr_consultar (id_est IN Estado_Eval_Terr.ID_ESTADO%TYPE, cur OUT SYS_REFCURSOR);
PROCEDURE All_estado_eval_terr_consultar (est_est IN Estado_Eval_Terr.ESTADO%TYPE, cur OUT SYS_REFCURSOR);
END Estado_Eval_Terr_PKG;
/

create or replace PACKAGE BODY Estado_Eval_Terr_PKG
IS
PROCEDURE estado_eval_terr_agregar (
			id_est IN Estado_Eval_Terr.ID_ESTADO%TYPE,
			descrip_est_eval_terr IN Estado_Eval_Terr.DESCRIP_ESTADO_EVAL_TERR%TYPE,
			est_est IN Estado_Eval_Terr.ESTADO%TYPE,
      cur OUT SYS_REFCURSOR)
IS 
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM Estado_Eval_Terr
WHERE ID_ESTADO = id_est;			
IF contar = 0 THEN 
  INSERT INTO Estado_Eval_Terr VALUES (id_est, descrip_est_eval_terr, est_est);
  OPEN cur FOR
  SELECT *
  FROM Estado_Eval_Terr
  WHERE ID_ESTADO = (SELECT MAX(ID_ESTADO) FROM Estado_Eval_Terr);
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20001, 'Estado evaluación terreno Existe, No se puede agregar el estado al sistema');
  ROLLBACK;
END IF;  
END estado_eval_terr_agregar;

PROCEDURE estado_eval_terr_eliminar (id_est IN Estado_Eval_Terr.ID_ESTADO%TYPE, est_est IN Estado_Eval_Terr.ESTADO%TYPE)
IS
contar NUMBER(1) := 0;
resp Estado_Eval_Terr.ID_ESTADO%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM Estado_Eval_Terr
WHERE ID_ESTADO = id_est;
IF contar = 1 THEN 
  UPDATE Estado_Eval_Terr SET ESTADO = est_est
  WHERE ID_ESTADO = id_est
  RETURNING id_est INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El estado de evaluación en terreno NO Existe, Verifique estado');
  ROLLBACK;
END IF; 
END estado_eval_terr_eliminar;

PROCEDURE estado_eval_terr_modificar (
			descrip_est_eval_terr IN Estado_Eval_Terr.DESCRIP_ESTADO_EVAL_TERR%TYPE,
			est_est IN Estado_Eval_Terr.ESTADO%TYPE,
			id_est IN Estado_Eval_Terr.ID_ESTADO%TYPE)
IS
contar NUMBER(1) := 0;
resp Estado_Eval_Terr.ID_ESTADO%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM Estado_Eval_Terr
WHERE ID_ESTADO = id_est;
IF contar = 1 THEN 
  UPDATE Estado_Eval_Terr SET 
                  DESCRIP_ESTADO_EVAL_TERR = descrip_est_eval_terr, 
                  Estado_Eval_Terr.ESTADO = est_est
  WHERE ID_ESTADO = id_est RETURNING id_est INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El estado de evaluación en terreno NO Existe, Verifique estado');
  ROLLBACK;
END IF;  
END estado_eval_terr_modificar;

PROCEDURE estado_eval_terr_consultar (id_est IN Estado_Eval_Terr.ID_ESTADO%TYPE, cur OUT SYS_REFCURSOR)
IS
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM Estado_Eval_Terr
WHERE ID_ESTADO = id_est;
IF contar = 1 THEN 
  OPEN cur FOR
  SELECT ID_ESTADO, DESCRIP_ESTADO_EVAL_TERR, ESTADO
  FROM Estado_Eval_Terr
  WHERE ID_ESTADO = id_est AND ESTADO > 0;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El estado de evaluación en terreno NO Existe, Verifique estado');
  ROLLBACK;
END IF; 
END estado_eval_terr_consultar;

PROCEDURE All_estado_eval_terr_consultar (est_est IN Estado_Eval_Terr.ESTADO%TYPE, cur OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN cur FOR
  SELECT ID_ESTADO, DESCRIP_ESTADO_EVAL_TERR, ESTADO
  FROM Estado_Eval_Terr
  WHERE ESTADO = est_est;
  COMMIT;
END All_estado_eval_terr_consultar;
  
END Estado_Eval_Terr_PKG;
/

create or replace PACKAGE Eval_TerrPKG
IS
PROCEDURE eval_terr_agregar (
			id_eval_t IN EVAL_TERR.ID_EVAL_TERR%TYPE,
			obs_vis IN EVAL_TERR.OBS_VISITA%TYPE,
      f_visita IN EVAL_TERR.FECHAVISITA%TYPE,
			estado_ev_ter IN EVAL_TERR.ESTADO%TYPE,
			solievalter_id_soli IN EVAL_TERR.SOLIEVALTER_ID_SOLICITUD%TYPE,			
			est_eval_ter_id_estado IN EVAL_TERR.ESTADO_EVAL_TERR_ID_ESTADO%TYPE,
			cert_id_cert IN EVAL_TERR.CERTIFICADO_ID_CERTIFICADO%TYPE,
      id_usuario IN EVAL_TERR.USUARIOS_ID_USUARIO%TYPE,
      f_creacion IN EVAL_TERR.FECHACREACION%TYPE,
      cur OUT SYS_REFCURSOR);
PROCEDURE eval_terr_eliminar (id_eval_t IN EVAL_TERR.ID_EVAL_TERR%TYPE, estado_ev_ter IN EVAL_TERR.ESTADO%TYPE);
PROCEDURE eval_terr_modificar (
			obs_vis IN EVAL_TERR.OBS_VISITA%TYPE,
      f_visita IN EVAL_TERR.FECHAVISITA%TYPE,
			estado_ev_ter IN EVAL_TERR.ESTADO%TYPE,
			solievalter_id_soli IN EVAL_TERR.SOLIEVALTER_ID_SOLICITUD%TYPE,			
			est_eval_ter_id_estado IN EVAL_TERR.ESTADO_EVAL_TERR_ID_ESTADO%TYPE,
			cert_id_cert IN EVAL_TERR.CERTIFICADO_ID_CERTIFICADO%TYPE,
      id_usuario IN EVAL_TERR.USUARIOS_ID_USUARIO%TYPE,
      f_creacion IN EVAL_TERR.FECHACREACION%TYPE,
			id_eval_t IN EVAL_TERR.ID_EVAL_TERR%TYPE);
PROCEDURE eval_terr_consultar (id_eval_t IN EVAL_TERR.ID_EVAL_TERR%TYPE, cur OUT SYS_REFCURSOR);
PROCEDURE All_eval_terr_consultar(est IN EVAL_TERR.ESTADO%TYPE, cur OUT SYS_REFCURSOR);
END Eval_TerrPKG;
/

create or replace PACKAGE BODY Eval_TerrPKG
IS
PROCEDURE eval_terr_agregar (
			id_eval_t IN EVAL_TERR.ID_EVAL_TERR%TYPE,
			obs_vis IN EVAL_TERR.OBS_VISITA%TYPE,
      f_visita IN EVAL_TERR.FECHAVISITA%TYPE,
			estado_ev_ter IN EVAL_TERR.ESTADO%TYPE,
			solievalter_id_soli IN EVAL_TERR.SOLIEVALTER_ID_SOLICITUD%TYPE,			
			est_eval_ter_id_estado IN EVAL_TERR.ESTADO_EVAL_TERR_ID_ESTADO%TYPE,
			cert_id_cert IN EVAL_TERR.CERTIFICADO_ID_CERTIFICADO%TYPE,
      id_usuario IN EVAL_TERR.USUARIOS_ID_USUARIO%TYPE,
      f_creacion IN EVAL_TERR.FECHACREACION%TYPE,
      cur OUT SYS_REFCURSOR)
IS 
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM EVAL_TERR
WHERE ID_EVAL_TERR = id_eval_t;			
IF contar = 0 THEN 
  INSERT INTO EVAL_TERR VALUES (id_eval_t, obs_vis, (TO_DATE(f_visita,'dd-mm-rr')), estado_ev_ter, solievalter_id_soli, est_eval_ter_id_estado, cert_id_cert,
                                id_usuario, (TO_DATE(f_creacion,'dd-mm-rr')));
  OPEN cur FOR
  SELECT *
  FROM EVAL_TERR
  WHERE ID_EVAL_TERR = (SELECT MAX(ID_EVAL_TERR) FROM EVAL_TERR);
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20001, 'La evaluación en terreno Existe, No se puede agregar la evaluación al sistema');
  ROLLBACK;
END IF;  
END eval_terr_agregar;

PROCEDURE eval_terr_eliminar (id_eval_t IN EVAL_TERR.ID_EVAL_TERR%TYPE, estado_ev_ter IN EVAL_TERR.ESTADO%TYPE)
IS
contar NUMBER(1) := 0;
resp EVAL_TERR.ID_EVAL_TERR%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM EVAL_TERR
WHERE ID_EVAL_TERR = id_eval_t;
IF contar = 1 THEN 
  UPDATE EVAL_TERR SET ESTADO = estado_ev_ter
  WHERE ID_EVAL_TERR = id_eval_t
  RETURNING id_eval_t INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La evaluación NO Existe, Verifique Evaluación');
  ROLLBACK;
END IF; 
END eval_terr_eliminar;

PROCEDURE eval_terr_modificar (
			obs_vis IN EVAL_TERR.OBS_VISITA%TYPE,
      f_visita IN EVAL_TERR.FECHAVISITA%TYPE,
			estado_ev_ter IN EVAL_TERR.ESTADO%TYPE,
			solievalter_id_soli IN EVAL_TERR.SOLIEVALTER_ID_SOLICITUD%TYPE,			
			est_eval_ter_id_estado IN EVAL_TERR.ESTADO_EVAL_TERR_ID_ESTADO%TYPE,
			cert_id_cert IN EVAL_TERR.CERTIFICADO_ID_CERTIFICADO%TYPE,
      id_usuario IN EVAL_TERR.USUARIOS_ID_USUARIO%TYPE,
      f_creacion IN EVAL_TERR.FECHACREACION%TYPE,
			id_eval_t IN EVAL_TERR.ID_EVAL_TERR%TYPE)
IS
contar NUMBER(1) := 0;
resp EVAL_TERR.ID_EVAL_TERR%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM EVAL_TERR
WHERE ID_EVAL_TERR = id_eval_t;
IF contar = 1 THEN 
  UPDATE EVAL_TERR SET 
                  OBS_VISITA = obs_vis, 
                  FECHAVISITA = f_visita,
                  ESTADO = estado_ev_ter,                  
                  SOLIEVALTER_ID_SOLICITUD = solievalter_id_soli,                   
                  ESTADO_EVAL_TERR_ID_ESTADO = est_eval_ter_id_estado,
                  CERTIFICADO_ID_CERTIFICADO = cert_id_cert,
                  USUARIOS_ID_USUARIO = id_usuario,
                  FECHACREACION = f_creacion
  WHERE ID_EVAL_TERR = id_eval_t RETURNING id_eval_t INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La evaluación NO Existe, Verifique Evaluación');
  ROLLBACK;
END IF;  
END eval_terr_modificar;

PROCEDURE eval_terr_consultar (id_eval_t IN EVAL_TERR.ID_EVAL_TERR%TYPE, cur OUT SYS_REFCURSOR)
IS
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM EVAL_TERR
WHERE ID_EVAL_TERR = id_eval_t;
IF contar = 1 THEN 
  OPEN cur FOR
  SELECT ID_EVAL_TERR, OBS_VISITA, FECHAVISITA, ESTADO, SOLIEVALTER_ID_SOLICITUD, ESTADO_EVAL_TERR_ID_ESTADO, CERTIFICADO_ID_CERTIFICADO, USUARIOS_ID_USUARIO, FECHACREACION
  FROM EVAL_TERR
  WHERE ID_EVAL_TERR = id_eval_t AND ESTADO > 0;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La evaluación NO Existe, Verifique Evaluación');
  ROLLBACK;
END IF; 
END eval_terr_consultar;

PROCEDURE All_eval_terr_consultar(est IN EVAL_TERR.ESTADO%TYPE, cur OUT SYS_REFCURSOR)
IS
BEGIN
OPEN cur FOR
  SELECT ID_EVAL_TERR, OBS_VISITA, FECHAVISITA, ESTADO, SOLIEVALTER_ID_SOLICITUD, ESTADO_EVAL_TERR_ID_ESTADO, CERTIFICADO_ID_CERTIFICADO, USUARIOS_ID_USUARIO, FECHACREACION
  FROM EVAL_TERR
  WHERE ESTADO = est;
  COMMIT;
END All_eval_terr_consultar;
END Eval_TerrPKG;
/

create or replace PACKAGE EXAMENESPKG
IS
PROCEDURE examen_agregar (
			id_exa IN EXAMENES.ID_EXAMEN%TYPE,
			nom_exa IN EXAMENES.NOMBRE_EXAMEN%TYPE,
			est_exa IN EXAMENES.ESTADO_EXAMEN%TYPE,
			plan_sal_id_plan_sal IN EXAMENES.PLAN_SALUD_ID_PLAN_SALUD%TYPE,
			tipo_exa_id_tipo_exa IN EXAMENES.TIPO_EXAMEN_ID_TIPO_EXAM%TYPE,
      cur OUT SYS_REFCURSOR);
PROCEDURE examen_eliminar (id_exa IN EXAMENES.ID_EXAMEN%TYPE, est_exa IN EXAMENES.ESTADO_EXAMEN%TYPE);
PROCEDURE examen_modificar (
			nom_exa IN EXAMENES.NOMBRE_EXAMEN%TYPE,
			est_exa IN EXAMENES.ESTADO_EXAMEN%TYPE,
			plan_sal_id_plan_sal IN EXAMENES.PLAN_SALUD_ID_PLAN_SALUD%TYPE,
			tipo_exa_id_tipo_exa IN EXAMENES.TIPO_EXAMEN_ID_TIPO_EXAM%TYPE,
			id_exa IN EXAMENES.ID_EXAMEN%TYPE);
PROCEDURE examen_consultar (id_exa IN EXAMENES.ID_EXAMEN%TYPE, cur OUT SYS_REFCURSOR);
PROCEDURE All_examen_consultar (est_exa IN EXAMENES.ESTADO_EXAMEN%TYPE, cur OUT SYS_REFCURSOR);
END EXAMENESPKG;
/

create or replace PACKAGE BODY EXAMENESPKG
IS
PROCEDURE examen_agregar (
			id_exa IN EXAMENES.ID_EXAMEN%TYPE,
			nom_exa IN EXAMENES.NOMBRE_EXAMEN%TYPE,
			est_exa IN EXAMENES.ESTADO_EXAMEN%TYPE,
			plan_sal_id_plan_sal IN EXAMENES.PLAN_SALUD_ID_PLAN_SALUD%TYPE,
			tipo_exa_id_tipo_exa IN EXAMENES.TIPO_EXAMEN_ID_TIPO_EXAM%TYPE,
      cur OUT SYS_REFCURSOR)
IS 
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM EXAMENES
WHERE ID_EXAMEN = id_exa;			
IF contar = 0 THEN 
  INSERT INTO EXAMENES VALUES (id_exa, nom_exa, est_exa, plan_sal_id_plan_sal, tipo_exa_id_tipo_exa);
  OPEN cur FOR
  SELECT *
  FROM EXAMENES
  WHERE ID_EXAMEN = (SELECT MAX(ID_EXAMEN) FROM EXAMENES);
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20001, 'El examen Existe, No se puede agregar el examen al sistema');
  ROLLBACK;
END IF;  
END examen_agregar;

PROCEDURE examen_eliminar (id_exa IN EXAMENES.ID_EXAMEN%TYPE, est_exa IN EXAMENES.ESTADO_EXAMEN%TYPE)
IS
contar NUMBER(1) := 0;
resp EXAMENES.ID_EXAMEN%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM EXAMENES
WHERE ID_EXAMEN = id_exa;
IF contar = 1 THEN 
  UPDATE EXAMENES SET ESTADO_EXAMEN = est_exa
  WHERE ID_EXAMEN = id_exa
  RETURNING id_exa INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El Examen NO Existe, Verifique Examen');
  ROLLBACK;
END IF; 
END examen_eliminar;

PROCEDURE examen_modificar (
			nom_exa IN EXAMENES.NOMBRE_EXAMEN%TYPE,
			est_exa IN EXAMENES.ESTADO_EXAMEN%TYPE,
			plan_sal_id_plan_sal IN EXAMENES.PLAN_SALUD_ID_PLAN_SALUD%TYPE,
			tipo_exa_id_tipo_exa IN EXAMENES.TIPO_EXAMEN_ID_TIPO_EXAM%TYPE,
			id_exa IN EXAMENES.ID_EXAMEN%TYPE)
IS
contar NUMBER(1) := 0;
resp EXAMENES.ID_EXAMEN%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM EXAMENES
WHERE ID_EXAMEN = id_exa;
IF contar = 1 THEN 
  UPDATE EXAMENES SET 
                  NOMBRE_EXAMEN = nom_exa, 
                  ESTADO_EXAMEN = est_exa, 
                  PLAN_SALUD_ID_PLAN_SALUD = plan_sal_id_plan_sal,
		  TIPO_EXAMEN_ID_TIPO_EXAM = tipo_exa_id_tipo_exa	  
  WHERE ID_EXAMEN = id_exa RETURNING id_exa INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El Examen NO Existe, Verifique Examen');
  ROLLBACK;
END IF;  
END examen_modificar;

PROCEDURE examen_consultar (id_exa IN EXAMENES.ID_EXAMEN%TYPE, cur OUT SYS_REFCURSOR)
IS	
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM EXAMENES
WHERE ID_EXAMEN = id_exa;
IF contar = 1 THEN 
  OPEN cur FOR
  SELECT ID_EXAMEN, NOMBRE_EXAMEN, ESTADO_EXAMEN, PLAN_SALUD_ID_PLAN_SALUD, TIPO_EXAMEN_ID_TIPO_EXAM
  FROM EXAMENES
  WHERE ID_EXAMEN = id_exa AND ESTADO_EXAMEN > 0;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El Examen NO Existe, Verifique Examen');
  ROLLBACK;
END IF; 
END examen_consultar;

PROCEDURE All_examen_consultar (est_exa IN EXAMENES.ESTADO_EXAMEN%TYPE, cur OUT SYS_REFCURSOR)
IS 
BEGIN 
  OPEN cur FOR
  SELECT ID_EXAMEN, NOMBRE_EXAMEN, ESTADO_EXAMEN, PLAN_SALUD_ID_PLAN_SALUD, TIPO_EXAMEN_ID_TIPO_EXAM
  FROM EXAMENES
  WHERE ESTADO_EXAMEN = est_exa;
  COMMIT;
END All_examen_consultar;
END EXAMENESPKG;
/

create or replace PACKAGE EXPOSITORPKG
IS
PROCEDURE expositor_agregar (
			id_exp IN EXPOSITOR.ID_EXPOSITOR%TYPE,
			run_exp IN EXPOSITOR.RUN_EXPOSITOR%TYPE,
			nom_exp IN EXPOSITOR.NOMBRE_EXPOSITOR%TYPE,
			tel_exp IN EXPOSITOR.TEL_EXPOSITOR%TYPE,
			mail_exp IN EXPOSITOR.MAIL_EXPOSITOR%TYPE,
			est_exp IN EXPOSITOR.ESTADO_EXPOSITOR%TYPE,
      f_creacion IN EXPOSITOR.FECHACREACION%TYPE,
      cur OUT SYS_REFCURSOR);
PROCEDURE expositor_eliminar (id_exp IN EXPOSITOR.ID_EXPOSITOR%TYPE, est_exp IN EXPOSITOR.ESTADO_EXPOSITOR%TYPE);
PROCEDURE expositor_modificar (
			run_exp IN EXPOSITOR.RUN_EXPOSITOR%TYPE,
			nom_exp IN EXPOSITOR.NOMBRE_EXPOSITOR%TYPE,
			tel_exp IN EXPOSITOR.TEL_EXPOSITOR%TYPE,
			mail_exp IN EXPOSITOR.MAIL_EXPOSITOR%TYPE,
			est_exp IN EXPOSITOR.ESTADO_EXPOSITOR%TYPE,
      f_creacion IN EXPOSITOR.FECHACREACION%TYPE,
			id_exp IN EXPOSITOR.ID_EXPOSITOR%TYPE);
PROCEDURE expositor_consultar (id_exp IN EXPOSITOR.ID_EXPOSITOR%TYPE, cur OUT SYS_REFCURSOR);
PROCEDURE All_expositor_consultar (est_exp IN EXPOSITOR.ESTADO_EXPOSITOR%TYPE, cur OUT SYS_REFCURSOR);
END EXPOSITORPKG;
/

create or replace PACKAGE BODY EXPOSITORPKG
IS
PROCEDURE expositor_agregar (
			id_exp IN EXPOSITOR.ID_EXPOSITOR%TYPE,
			run_exp IN EXPOSITOR.RUN_EXPOSITOR%TYPE,
			nom_exp IN EXPOSITOR.NOMBRE_EXPOSITOR%TYPE,
			tel_exp IN EXPOSITOR.TEL_EXPOSITOR%TYPE,
			mail_exp IN EXPOSITOR.MAIL_EXPOSITOR%TYPE,
			est_exp IN EXPOSITOR.ESTADO_EXPOSITOR%TYPE,
      f_creacion IN EXPOSITOR.FECHACREACION%TYPE,
      cur OUT SYS_REFCURSOR)
IS 
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM EXPOSITOR
WHERE ID_EXPOSITOR = id_exp;			
IF contar = 0 THEN 
  INSERT INTO EXPOSITOR VALUES (id_exp, run_exp, nom_exp, tel_exp, mail_exp, est_exp, (TO_DATE(f_creacion,'dd-mm-rr')));
  OPEN cur FOR
  SELECT *
  FROM EXPOSITOR
  WHERE ID_EXPOSITOR = (SELECT MAX(ID_EXPOSITOR) FROM EXPOSITOR);
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20001, 'El expositor Existe, No se puede agregar el expositor al sistema');
  ROLLBACK;
END IF;  
END expositor_agregar;

PROCEDURE expositor_eliminar (id_exp IN EXPOSITOR.ID_EXPOSITOR%TYPE, est_exp IN EXPOSITOR.ESTADO_EXPOSITOR%TYPE)
IS
contar NUMBER(1) := 0;
resp EXPOSITOR.ID_EXPOSITOR%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM EXPOSITOR
WHERE ID_EXPOSITOR = id_exp;
IF contar = 1 THEN 
  UPDATE EXPOSITOR SET ESTADO_EXPOSITOR = est_exp
  WHERE ID_EXPOSITOR = id_exp
  RETURNING id_exp INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El expositor NO Existe, Verifique expositor');
  ROLLBACK;
END IF; 
END expositor_eliminar;

PROCEDURE expositor_modificar (
			run_exp IN EXPOSITOR.RUN_EXPOSITOR%TYPE,
			nom_exp IN EXPOSITOR.NOMBRE_EXPOSITOR%TYPE,
			tel_exp IN EXPOSITOR.TEL_EXPOSITOR%TYPE,
			mail_exp IN EXPOSITOR.MAIL_EXPOSITOR%TYPE,
			est_exp IN EXPOSITOR.ESTADO_EXPOSITOR%TYPE,
      f_creacion IN EXPOSITOR.FECHACREACION%TYPE,
			id_exp IN EXPOSITOR.ID_EXPOSITOR%TYPE)
IS
contar NUMBER(1) := 0;
resp EXPOSITOR.ID_EXPOSITOR%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM EXPOSITOR
WHERE ID_EXPOSITOR = id_exp;
IF contar = 1 THEN 
  UPDATE EXPOSITOR SET 
                  RUN_EXPOSITOR = run_exp, 
                  NOMBRE_EXPOSITOR = nom_exp, 
                  TEL_EXPOSITOR = tel_exp,
                  MAIL_EXPOSITOR = mail_exp,
                  ESTADO_EXPOSITOR = est_exp,
                  FECHACREACION = f_creacion
  WHERE ID_EXPOSITOR = id_exp RETURNING id_exp INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El expositor NO Existe, Verifique expositor');
  ROLLBACK;
END IF;  
END expositor_modificar;

PROCEDURE expositor_consultar (id_exp IN EXPOSITOR.ID_EXPOSITOR%TYPE, cur OUT SYS_REFCURSOR)
IS
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM EXPOSITOR
WHERE ID_EXPOSITOR = id_exp;
IF contar = 1 THEN 
  OPEN cur FOR
  SELECT ID_EXPOSITOR, RUN_EXPOSITOR, NOMBRE_EXPOSITOR, TEL_EXPOSITOR, MAIL_EXPOSITOR, ESTADO_EXPOSITOR, FECHACREACION
  FROM EXPOSITOR
  WHERE ID_EXPOSITOR = id_exp AND ESTADO_EXPOSITOR > 0;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El expositor NO Existe, Verifique expositor');
  ROLLBACK;
END IF; 
END expositor_consultar;

PROCEDURE All_expositor_consultar (est_exp IN EXPOSITOR.ESTADO_EXPOSITOR%TYPE, cur OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN cur FOR
  SELECT ID_EXPOSITOR, RUN_EXPOSITOR, NOMBRE_EXPOSITOR, TEL_EXPOSITOR, MAIL_EXPOSITOR, ESTADO_EXPOSITOR, FECHACREACION
  FROM EXPOSITOR
  WHERE ESTADO_EXPOSITOR = est_exp;
  COMMIT;
END All_expositor_consultar;
END EXPOSITORPKG;
/

create or replace PACKAGE List_Asis_Cap_PKG
IS
PROCEDURE list_asis_cap_agregar (
			id_list_cap IN List_Asis_Cap.ID_LISTA_CAP%TYPE,
			est_asist_cap IN List_Asis_Cap.ESTADO_ASIST_CAP%TYPE,
			ses_cap_id_ses_cap IN List_Asis_Cap.SESION_CAP_ID_SESION_CAP%TYPE,
      f_creacion IN List_Asis_Cap.FECHACREACION%TYPE,
      cur OUT SYS_REFCURSOR);
PROCEDURE list_asis_cap_eliminar (id_list_cap IN List_Asis_Cap.ID_LISTA_CAP%TYPE, est_asist_cap IN List_Asis_Cap.ESTADO_ASIST_CAP%TYPE);
PROCEDURE list_asis_cap_modificar (
			est_asist_cap IN List_Asis_Cap.ESTADO_ASIST_CAP%TYPE,
			ses_cap_id_ses_cap IN List_Asis_Cap.SESION_CAP_ID_SESION_CAP%TYPE,
      f_creacion IN List_Asis_Cap.FECHACREACION%TYPE,
			id_list_cap IN List_Asis_Cap.ID_LISTA_CAP%TYPE);
PROCEDURE list_asis_cap_consultar (id_list_cap IN List_Asis_Cap.ID_LISTA_CAP%TYPE, cur OUT SYS_REFCURSOR);
PROCEDURE All_list_asis_cap_consultar (est_asist_cap IN List_Asis_Cap.ESTADO_ASIST_CAP%TYPE, cur OUT SYS_REFCURSOR);
END List_Asis_Cap_PKG;
/

create or replace PACKAGE BODY List_Asis_Cap_PKG
IS
PROCEDURE list_asis_cap_agregar (
			id_list_cap IN List_Asis_Cap.ID_LISTA_CAP%TYPE,
			est_asist_cap IN List_Asis_Cap.ESTADO_ASIST_CAP%TYPE,
			ses_cap_id_ses_cap IN List_Asis_Cap.SESION_CAP_ID_SESION_CAP%TYPE,
      f_creacion IN List_Asis_Cap.FECHACREACION%TYPE,
      cur OUT SYS_REFCURSOR)
IS 
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM List_Asis_Cap
WHERE ID_LISTA_CAP = id_list_cap;			
IF contar = 0 THEN 
  INSERT INTO List_Asis_Cap VALUES (id_list_cap, est_asist_cap, ses_cap_id_ses_cap, (TO_DATE(f_creacion,'dd-mm-rr')));
  OPEN cur FOR
  SELECT *
  FROM List_Asis_Cap
  WHERE ID_LISTA_CAP = (SELECT MAX(ID_LISTA_CAP) FROM List_Asis_Cap);
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20001, 'La lista de asistencia Existe, No se puede agregar lista asistencia al sistema');
  ROLLBACK;
END IF;  
END list_asis_cap_agregar;

PROCEDURE list_asis_cap_eliminar (id_list_cap IN List_Asis_Cap.ID_LISTA_CAP%TYPE, est_asist_cap IN List_Asis_Cap.ESTADO_ASIST_CAP%TYPE)
IS
contar NUMBER(1) := 0;
resp List_Asis_Cap.ID_LISTA_CAP%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM List_Asis_Cap
WHERE ID_LISTA_CAP = id_list_cap;
IF contar = 1 THEN 
  UPDATE List_Asis_Cap SET ESTADO_ASIST_CAP = est_asist_cap
  WHERE ID_LISTA_CAP = id_list_cap
  RETURNING id_list_cap INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La lista de asistencia NO Existe, Verifique lista asistencia');
  ROLLBACK;
END IF; 
END list_asis_cap_eliminar;

PROCEDURE list_asis_cap_modificar (
			est_asist_cap IN List_Asis_Cap.ESTADO_ASIST_CAP%TYPE,
			ses_cap_id_ses_cap IN List_Asis_Cap.SESION_CAP_ID_SESION_CAP%TYPE,
      f_creacion IN List_Asis_Cap.FECHACREACION%TYPE,
			id_list_cap IN List_Asis_Cap.ID_LISTA_CAP%TYPE)
IS
contar NUMBER(1) := 0;
resp List_Asis_Cap.ID_LISTA_CAP%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM List_Asis_Cap
WHERE ID_LISTA_CAP = id_list_cap;
IF contar = 1 THEN 
  UPDATE List_Asis_Cap SET 
                  ESTADO_ASIST_CAP = est_asist_cap, 
                  SESION_CAP_ID_SESION_CAP = ses_cap_id_ses_cap,
                  FECHACREACION = f_creacion
  WHERE ID_LISTA_CAP = id_list_cap RETURNING id_list_cap INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La lista de asistencia NO Existe, Verifique lista asistencia');
  ROLLBACK;
END IF;  
END list_asis_cap_modificar;

PROCEDURE list_asis_cap_consultar (id_list_cap IN List_Asis_Cap.ID_LISTA_CAP%TYPE, cur OUT SYS_REFCURSOR)
IS
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM List_Asis_Cap
WHERE ID_LISTA_CAP = id_list_cap;
IF contar = 1 THEN 
  OPEN cur FOR
  SELECT ID_LISTA_CAP, ESTADO_ASIST_CAP, SESION_CAP_ID_SESION_CAP, FECHACREACION
  FROM List_Asis_Cap
  WHERE ID_LISTA_CAP = id_list_cap AND ESTADO_ASIST_CAP > 0;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La lista de asistencia NO Existe, Verifique lista asistencia');
  ROLLBACK;
END IF; 
END list_asis_cap_consultar;

PROCEDURE All_list_asis_cap_consultar (est_asist_cap IN List_Asis_Cap.ESTADO_ASIST_CAP%TYPE, cur OUT SYS_REFCURSOR)
IS 
BEGIN
  OPEN cur FOR
  SELECT ID_LISTA_CAP, ESTADO_ASIST_CAP, SESION_CAP_ID_SESION_CAP, FECHACREACION
  FROM List_Asis_Cap
  WHERE ESTADO_ASIST_CAP = est_asist_cap;
  COMMIT;
END All_list_asis_cap_consultar;
END List_Asis_Cap_PKG;
/

create or replace PACKAGE LISTASISSALUD_PKG
IS
PROCEDURE listasissalud_agregar (
			id_li_salud IN LISTASISSALUD.ID_LIST_SALUD%TYPE,
			est_asis_salud IN LISTASISSALUD.ESTADO_ASIST_SALUD%TYPE,
			ses_sal_id_ses_salud IN LISTASISSALUD.SESION_SALUD_ID_SESION_SALUD%TYPE,
      f_creacion IN LISTASISSALUD.FECHACREACION%TYPE,
      cur OUT SYS_REFCURSOR);
PROCEDURE listasissalud_eliminar (id_li_salud IN LISTASISSALUD.ID_LIST_SALUD%TYPE, est_asis_salud IN LISTASISSALUD.ESTADO_ASIST_SALUD%TYPE);
PROCEDURE listasissalud_modificar (
			est_asis_salud IN LISTASISSALUD.ESTADO_ASIST_SALUD%TYPE,
			ses_sal_id_ses_salud IN LISTASISSALUD.SESION_SALUD_ID_SESION_SALUD%TYPE,
      f_creacion IN LISTASISSALUD.FECHACREACION%TYPE,
			id_li_salud IN LISTASISSALUD.ID_LIST_SALUD%TYPE);
PROCEDURE listasissalud_consultar (id_li_salud IN LISTASISSALUD.ID_LIST_SALUD%TYPE, cur OUT SYS_REFCURSOR);
PROCEDURE All_listasissalud_consultar (est_asis_salud IN LISTASISSALUD.ESTADO_ASIST_SALUD%TYPE, cur OUT SYS_REFCURSOR);
END LISTASISSALUD_PKG;
/

create or replace PACKAGE BODY LISTASISSALUD_PKG
IS
PROCEDURE listasissalud_agregar (
			id_li_salud IN LISTASISSALUD.ID_LIST_SALUD%TYPE,
			est_asis_salud IN LISTASISSALUD.ESTADO_ASIST_SALUD%TYPE,
			ses_sal_id_ses_salud IN LISTASISSALUD.SESION_SALUD_ID_SESION_SALUD%TYPE,
      f_creacion IN LISTASISSALUD.FECHACREACION%TYPE,
      cur OUT SYS_REFCURSOR)
IS 
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM LISTASISSALUD
WHERE ID_LIST_SALUD = id_li_salud;			
IF contar = 0 THEN 
  INSERT INTO LISTASISSALUD VALUES (id_li_salud, est_asis_salud, ses_sal_id_ses_salud, (TO_DATE(f_creacion,'dd-mm-rr')));
  OPEN cur FOR
  SELECT *
  FROM LISTASISSALUD
  WHERE ID_LIST_SALUD = (SELECT MAX(ID_LIST_SALUD) FROM LISTASISSALUD);
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20001, 'Lista asistencia Existe, No se puede agregar la lista al sistema');
  ROLLBACK;
END IF;  
END listasissalud_agregar;

PROCEDURE listasissalud_eliminar (id_li_salud IN LISTASISSALUD.ID_LIST_SALUD%TYPE, est_asis_salud IN LISTASISSALUD.ESTADO_ASIST_SALUD%TYPE)
IS
contar NUMBER(1) := 0;
resp LISTASISSALUD.ID_LIST_SALUD%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM LISTASISSALUD
WHERE ID_LIST_SALUD = id_li_salud;
IF contar = 1 THEN 
  UPDATE LISTASISSALUD SET ESTADO_ASIST_SALUD = est_asis_salud
  WHERE ID_LIST_SALUD = id_li_salud
  RETURNING id_li_salud INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La lista NO Existe, Verifique lista');
  ROLLBACK;
END IF; 
END listasissalud_eliminar;

PROCEDURE listasissalud_modificar (
			est_asis_salud IN LISTASISSALUD.ESTADO_ASIST_SALUD%TYPE,
			ses_sal_id_ses_salud IN LISTASISSALUD.SESION_SALUD_ID_SESION_SALUD%TYPE,
      f_creacion IN LISTASISSALUD.FECHACREACION%TYPE,
			id_li_salud IN LISTASISSALUD.ID_LIST_SALUD%TYPE)
IS
contar NUMBER(1) := 0;
resp LISTASISSALUD.ID_LIST_SALUD%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM LISTASISSALUD
WHERE ID_LIST_SALUD = id_li_salud;
IF contar = 1 THEN 
  UPDATE LISTASISSALUD SET 
                  ESTADO_ASIST_SALUD = est_asis_salud, 
                  SESION_SALUD_ID_SESION_SALUD = ses_sal_id_ses_salud,
                  FECHACREACION = f_creacion
  WHERE ID_LIST_SALUD = id_li_salud RETURNING id_li_salud INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La lista NO Existe, Verifique lista');
  ROLLBACK;
END IF;  
END listasissalud_modificar;

PROCEDURE listasissalud_consultar (id_li_salud IN LISTASISSALUD.ID_LIST_SALUD%TYPE, cur OUT SYS_REFCURSOR)
IS
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM LISTASISSALUD
WHERE ID_LIST_SALUD = id_li_salud;
IF contar = 1 THEN 
  OPEN cur FOR
  SELECT ID_LIST_SALUD, ESTADO_ASIST_SALUD, SESION_SALUD_ID_SESION_SALUD, FECHACREACION
  FROM LISTASISSALUD
  WHERE ID_LIST_SALUD = id_li_salud AND ESTADO_ASIST_SALUD > 0;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La lista NO Existe, Verifique lista');
  ROLLBACK;
END IF; 
END listasissalud_consultar;

PROCEDURE All_listasissalud_consultar (est_asis_salud IN LISTASISSALUD.ESTADO_ASIST_SALUD%TYPE, cur OUT SYS_REFCURSOR)
IS
BEGIN
OPEN cur FOR
  SELECT ID_LIST_SALUD, ESTADO_ASIST_SALUD, SESION_SALUD_ID_SESION_SALUD, FECHACREACION
  FROM LISTASISSALUD
  WHERE ESTADO_ASIST_SALUD = est_asis_salud;
  COMMIT;
END All_listasissalud_consultar;
END LISTASISSALUD_PKG;
/

create or replace PACKAGE List_Trab_Cap_PKG
IS
PROCEDURE list_trab_cap_agregar (
			id_list_trab_cap IN LIST_TRAB_CAP.ID_LIS_TRAB_CAP%TYPE,
			presen IN LIST_TRAB_CAP.PRESENTE%TYPE,
			est_list_trab_cap IN LIST_TRAB_CAP.ESTADO%TYPE,
			usu_id_usu IN LIST_TRAB_CAP.USUARIOS_ID_USUARIO%TYPE,
			list_asis_cap_id_list_cap IN LIST_TRAB_CAP.LIST_ASIS_CAP_ID_LISTA_CAP%TYPE,
			cert_id_cert IN LIST_TRAB_CAP.CERTIFICADO_ID_CERTIFICADO%TYPE,
      f_creacion IN LIST_TRAB_CAP.FECHACREACION%TYPE,
      cur OUT SYS_REFCURSOR);
PROCEDURE list_trab_cap_eliminar (id_list_trab_cap IN LIST_TRAB_CAP.ID_LIS_TRAB_CAP%TYPE, est_list_trab_cap IN LIST_TRAB_CAP.ESTADO%TYPE);
PROCEDURE list_trab_cap_modificar (
			presen IN LIST_TRAB_CAP.PRESENTE%TYPE,
			est_list_trab_cap IN LIST_TRAB_CAP.ESTADO%TYPE,
			usu_id_usu IN LIST_TRAB_CAP.USUARIOS_ID_USUARIO%TYPE,
			list_asis_cap_id_list_cap IN LIST_TRAB_CAP.LIST_ASIS_CAP_ID_LISTA_CAP%TYPE,
			cert_id_cert IN LIST_TRAB_CAP.CERTIFICADO_ID_CERTIFICADO%TYPE,
      f_creacion IN LIST_TRAB_CAP.FECHACREACION%TYPE,
			id_list_trab_cap IN LIST_TRAB_CAP.ID_LIS_TRAB_CAP%TYPE);
PROCEDURE list_trab_cap_consultar (id_list_trab_cap IN LIST_TRAB_CAP.ID_LIS_TRAB_CAP%TYPE, cur OUT SYS_REFCURSOR);
PROCEDURE All_list_trab_cap_consultar (est_list_trab_cap IN LIST_TRAB_CAP.ESTADO%TYPE, cur OUT SYS_REFCURSOR);
END List_Trab_Cap_PKG;
/

create or replace PACKAGE BODY List_Trab_Cap_PKG
IS
PROCEDURE list_trab_cap_agregar (
			id_list_trab_cap IN LIST_TRAB_CAP.ID_LIS_TRAB_CAP%TYPE,
			presen IN LIST_TRAB_CAP.PRESENTE%TYPE,
			est_list_trab_cap IN LIST_TRAB_CAP.ESTADO%TYPE,
			usu_id_usu IN LIST_TRAB_CAP.USUARIOS_ID_USUARIO%TYPE,
			list_asis_cap_id_list_cap IN LIST_TRAB_CAP.LIST_ASIS_CAP_ID_LISTA_CAP%TYPE,
			cert_id_cert IN LIST_TRAB_CAP.CERTIFICADO_ID_CERTIFICADO%TYPE,
      f_creacion IN LIST_TRAB_CAP.FECHACREACION%TYPE,
      cur OUT SYS_REFCURSOR)
IS 
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM LIST_TRAB_CAP
WHERE ID_LIS_TRAB_CAP = id_list_trab_cap;			
IF contar = 0 THEN 
  INSERT INTO LIST_TRAB_CAP VALUES (id_list_trab_cap, presen, est_list_trab_cap, usu_id_usu, list_asis_cap_id_list_cap, cert_id_cert, (TO_DATE(f_creacion,'dd-mm-rr')));
  OPEN cur FOR
  SELECT *
  FROM LIST_TRAB_CAP
  WHERE ID_LIS_TRAB_CAP = (SELECT MAX(ID_LIS_TRAB_CAP) FROM LIST_TRAB_CAP);
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20001, 'Lista de trabajadores Existe, No se puede agregar lista al sistema');
  ROLLBACK;
END IF;  
END list_trab_cap_agregar;

PROCEDURE list_trab_cap_eliminar (id_list_trab_cap IN LIST_TRAB_CAP.ID_LIS_TRAB_CAP%TYPE, est_list_trab_cap IN LIST_TRAB_CAP.ESTADO%TYPE)
IS
contar NUMBER(1) := 0;
resp LIST_TRAB_CAP.ID_LIS_TRAB_CAP%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM LIST_TRAB_CAP
WHERE ID_LIS_TRAB_CAP = id_list_trab_cap;
IF contar = 1 THEN 
  UPDATE LIST_TRAB_CAP SET ESTADO = est_list_trab_cap
  WHERE ID_LIS_TRAB_CAP = id_list_trab_cap
  RETURNING id_list_trab_cap INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La lista de trabajadores NO Existe, Verifique lista');
  ROLLBACK;
END IF; 
END list_trab_cap_eliminar;

PROCEDURE list_trab_cap_modificar (
			presen IN LIST_TRAB_CAP.PRESENTE%TYPE,
			est_list_trab_cap IN LIST_TRAB_CAP.ESTADO%TYPE,
			usu_id_usu IN LIST_TRAB_CAP.USUARIOS_ID_USUARIO%TYPE,
			list_asis_cap_id_list_cap IN LIST_TRAB_CAP.LIST_ASIS_CAP_ID_LISTA_CAP%TYPE,
			cert_id_cert IN LIST_TRAB_CAP.CERTIFICADO_ID_CERTIFICADO%TYPE,
      f_creacion IN LIST_TRAB_CAP.FECHACREACION%TYPE,
			id_list_trab_cap IN LIST_TRAB_CAP.ID_LIS_TRAB_CAP%TYPE)
IS
contar NUMBER(1) := 0;
resp LIST_TRAB_CAP.ID_LIS_TRAB_CAP%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM LIST_TRAB_CAP
WHERE ID_LIS_TRAB_CAP = id_list_trab_cap;
IF contar = 1 THEN 
  UPDATE LIST_TRAB_CAP SET 
                  PRESENTE = presen, 
                  ESTADO = est_list_trab_cap, 
                  USUARIOS_ID_USUARIO = usu_id_usu,
                  LIST_ASIS_CAP_ID_LISTA_CAP = list_asis_cap_id_list_cap,
                  CERTIFICADO_ID_CERTIFICADO = cert_id_cert,
                  FECHACREACION = f_creacion
  WHERE ID_LIS_TRAB_CAP = id_list_trab_cap RETURNING id_list_trab_cap INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La lista de trabajadores NO Existe, Verifique lista');
  ROLLBACK;
END IF;  
END list_trab_cap_modificar;

PROCEDURE list_trab_cap_consultar (id_list_trab_cap IN LIST_TRAB_CAP.ID_LIS_TRAB_CAP%TYPE, cur OUT SYS_REFCURSOR)
IS
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM LIST_TRAB_CAP
WHERE ID_LIS_TRAB_CAP = id_list_trab_cap;
IF contar = 1 THEN 
  OPEN cur FOR
  SELECT ID_LIS_TRAB_CAP, PRESENTE, ESTADO, USUARIOS_ID_USUARIO, LIST_ASIS_CAP_ID_LISTA_CAP, CERTIFICADO_ID_CERTIFICADO, FECHACREACION
  FROM LIST_TRAB_CAP
  WHERE ID_LIS_TRAB_CAP = id_list_trab_cap AND ESTADO > 0;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La lista de trabajadores NO Existe, Verifique lista');
  ROLLBACK;
END IF; 
END list_trab_cap_consultar;

PROCEDURE All_list_trab_cap_consultar (est_list_trab_cap IN LIST_TRAB_CAP.ESTADO%TYPE, cur OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN cur FOR
  SELECT ID_LIS_TRAB_CAP, PRESENTE, ESTADO, USUARIOS_ID_USUARIO, LIST_ASIS_CAP_ID_LISTA_CAP, CERTIFICADO_ID_CERTIFICADO, FECHACREACION
  FROM LIST_TRAB_CAP
  WHERE ESTADO = est_list_trab_cap;
  COMMIT;
END All_list_trab_cap_consultar;
END List_Trab_Cap_PKG;
/

create or replace PACKAGE LISTTRABSALUD_PKG
IS
PROCEDURE listtrabsalud_agregar (
			id_list_trab_salud IN LISTTRABSALUD.ID_LIS_TRAB_SALUD%TYPE,
			presen IN LISTTRABSALUD.PRESENTE%TYPE,
			est_sal IN LISTTRABSALUD.ESTADO%TYPE,
			usu_id_usu IN LISTTRABSALUD.USUARIOS_ID_USUARIO%TYPE,
			lis_asis_salud_id_list_salud IN LISTTRABSALUD.LISTASISSALUD_ID_LIST_SALUD%TYPE,
			cert_id_cert IN LISTTRABSALUD.CERTIFICADO_ID_CERTIFICADO%TYPE,
      f_creacion IN LISTTRABSALUD.FECHACREACION%TYPE,
      cur OUT SYS_REFCURSOR);
PROCEDURE listtrabsalud_eliminar (id_list_trab_salud IN LISTTRABSALUD.ID_LIS_TRAB_SALUD%TYPE, est_sal IN LISTTRABSALUD.ESTADO%TYPE);
PROCEDURE listtrabsalud_modificar (
			presen IN LISTTRABSALUD.PRESENTE%TYPE,
			est_sal IN LISTTRABSALUD.ESTADO%TYPE,
			usu_id_usu IN LISTTRABSALUD.USUARIOS_ID_USUARIO%TYPE,
			lis_asis_salud_id_list_salud IN LISTTRABSALUD.LISTASISSALUD_ID_LIST_SALUD%TYPE,
			cert_id_cert IN LISTTRABSALUD.CERTIFICADO_ID_CERTIFICADO%TYPE,
      f_creacion IN LISTTRABSALUD.FECHACREACION%TYPE,
			id_list_trab_salud IN LISTTRABSALUD.ID_LIS_TRAB_SALUD%TYPE);
PROCEDURE listtrabsalud_consultar (id_list_trab_salud IN LISTTRABSALUD.ID_LIS_TRAB_SALUD%TYPE, cur OUT SYS_REFCURSOR);
PROCEDURE All_listtrabsalud_consultar (est_sal IN LISTTRABSALUD.ESTADO%TYPE, cur OUT SYS_REFCURSOR);
END LISTTRABSALUD_PKG;
/

create or replace PACKAGE BODY LISTTRABSALUD_PKG
IS
PROCEDURE listtrabsalud_agregar (
			id_list_trab_salud IN LISTTRABSALUD.ID_LIS_TRAB_SALUD%TYPE,
			presen IN LISTTRABSALUD.PRESENTE%TYPE,
			est_sal IN LISTTRABSALUD.ESTADO%TYPE,
			usu_id_usu IN LISTTRABSALUD.USUARIOS_ID_USUARIO%TYPE,
			lis_asis_salud_id_list_salud IN LISTTRABSALUD.LISTASISSALUD_ID_LIST_SALUD%TYPE,
			cert_id_cert IN LISTTRABSALUD.CERTIFICADO_ID_CERTIFICADO%TYPE,
      f_creacion IN LISTTRABSALUD.FECHACREACION%TYPE,
      cur OUT SYS_REFCURSOR)
IS 
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM LISTTRABSALUD
WHERE ID_LIS_TRAB_SALUD = id_list_trab_salud;			
IF contar = 0 THEN 
  INSERT INTO LISTTRABSALUD VALUES (id_list_trab_salud, presen, est_sal, usu_id_usu, lis_asis_salud_id_list_salud, cert_id_cert, (TO_DATE(f_creacion,'dd-mm-rr')));
  OPEN cur FOR
  SELECT *
  FROM LISTTRABSALUD
  WHERE ID_LIS_TRAB_SALUD = (SELECT MAX(ID_LIS_TRAB_SALUD) FROM LISTTRABSALUD);
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20001, 'Lista asistencia trabajadores Existe, No se puede agregar la lista al sistema');
  ROLLBACK;
END IF;  
END listtrabsalud_agregar;

PROCEDURE listtrabsalud_eliminar (id_list_trab_salud IN LISTTRABSALUD.ID_LIS_TRAB_SALUD%TYPE, est_sal IN LISTTRABSALUD.ESTADO%TYPE)
IS
contar NUMBER(1) := 0;
resp LISTTRABSALUD.ID_LIS_TRAB_SALUD%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM LISTTRABSALUD
WHERE ID_LIS_TRAB_SALUD = id_list_trab_salud;
IF contar = 1 THEN 
  UPDATE LISTTRABSALUD SET ESTADO = est_sal
  WHERE ID_LIS_TRAB_SALUD = id_list_trab_salud
  RETURNING id_list_trab_salud INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'Lista de trabajador NO Existe, Verifique lista');
  ROLLBACK;
END IF; 
END listtrabsalud_eliminar;

PROCEDURE listtrabsalud_modificar (
			presen IN LISTTRABSALUD.PRESENTE%TYPE,
			est_sal IN LISTTRABSALUD.ESTADO%TYPE,
			usu_id_usu IN LISTTRABSALUD.USUARIOS_ID_USUARIO%TYPE,
			lis_asis_salud_id_list_salud IN LISTTRABSALUD.LISTASISSALUD_ID_LIST_SALUD%TYPE,
			cert_id_cert IN LISTTRABSALUD.CERTIFICADO_ID_CERTIFICADO%TYPE,
      f_creacion IN LISTTRABSALUD.FECHACREACION%TYPE,
			id_list_trab_salud IN LISTTRABSALUD.ID_LIS_TRAB_SALUD%TYPE)
IS
contar NUMBER(1) := 0;
resp LISTTRABSALUD.ID_LIS_TRAB_SALUD%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM LISTTRABSALUD
WHERE ID_LIS_TRAB_SALUD = id_list_trab_salud;
IF contar = 1 THEN 
  UPDATE LISTTRABSALUD SET 
                  PRESENTE = presen, 
                  ESTADO = est_sal, 
                  USUARIOS_ID_USUARIO = usu_id_usu,
                  LISTASISSALUD_ID_LIST_SALUD = lis_asis_salud_id_list_salud,
                  CERTIFICADO_ID_CERTIFICADO = cert_id_cert,
                  FECHACREACION = f_creacion
  WHERE ID_LIS_TRAB_SALUD = id_list_trab_salud RETURNING id_list_trab_salud INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'Lista de trabajador NO Existe, Verifique lista');
  ROLLBACK;
END IF;  
END listtrabsalud_modificar;

PROCEDURE listtrabsalud_consultar (id_list_trab_salud IN LISTTRABSALUD.ID_LIS_TRAB_SALUD%TYPE, cur OUT SYS_REFCURSOR)
IS
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM LISTTRABSALUD
WHERE ID_LIS_TRAB_SALUD = id_list_trab_salud;
IF contar = 1 THEN 
  OPEN cur FOR
  SELECT ID_LIS_TRAB_SALUD, PRESENTE, ESTADO, USUARIOS_ID_USUARIO, LISTASISSALUD_ID_LIST_SALUD, CERTIFICADO_ID_CERTIFICADO, FECHACREACION
  FROM LISTTRABSALUD
  WHERE ID_LIS_TRAB_SALUD = id_list_trab_salud AND ESTADO > 0;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'Lista de trabajador NO Existe, Verifique lista');
  ROLLBACK;
END IF; 
END listtrabsalud_consultar;

PROCEDURE All_listtrabsalud_consultar (est_sal IN LISTTRABSALUD.ESTADO%TYPE, cur OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN cur FOR
  SELECT ID_LIS_TRAB_SALUD, PRESENTE, ESTADO, USUARIOS_ID_USUARIO, LISTASISSALUD_ID_LIST_SALUD, CERTIFICADO_ID_CERTIFICADO, FECHACREACION
  FROM LISTTRABSALUD
  WHERE ESTADO = est_sal;
  COMMIT;
END All_listtrabsalud_consultar;
END LISTTRABSALUD_PKG;
/

create or replace PACKAGE MEDICO_PKG
IS
PROCEDURE medico_agregar (
			id_med IN MEDICO.ID_MEDICO%TYPE,
			run_med IN MEDICO.RUN_MEDICO%TYPE,
			nom_med IN MEDICO.NOMBRE_MEDICO%TYPE,
			univers IN MEDICO.UNIVERSIDAD%TYPE,
			mail_med IN MEDICO.MAIL_MEDICO%TYPE,
			tel_med IN MEDICO.TEL_MEDICO%TYPE,
			est_med IN MEDICO.ESTADO_MEDICO%TYPE,
      f_creacion IN MEDICO.FECHACREACION%TYPE,
      cur OUT SYS_REFCURSOR);
PROCEDURE medico_eliminar (id_med IN MEDICO.ID_MEDICO%TYPE, est_med IN MEDICO.ESTADO_MEDICO%TYPE);
PROCEDURE medico_modificar (
			run_med IN MEDICO.RUN_MEDICO%TYPE,
			nom_med IN MEDICO.NOMBRE_MEDICO%TYPE,
			univers IN MEDICO.UNIVERSIDAD%TYPE,
			mail_med IN MEDICO.MAIL_MEDICO%TYPE,
			tel_med IN MEDICO.TEL_MEDICO%TYPE,
			est_med IN MEDICO.ESTADO_MEDICO%TYPE,
      f_creacion IN MEDICO.FECHACREACION%TYPE,
			id_med IN MEDICO.ID_MEDICO%TYPE);
PROCEDURE medico_consultar (id_med IN MEDICO.ID_MEDICO%TYPE, cur OUT SYS_REFCURSOR);
PROCEDURE All_medico_consultar (est_med IN MEDICO.ESTADO_MEDICO%TYPE, cur OUT SYS_REFCURSOR);
END MEDICO_PKG;
/

create or replace PACKAGE BODY MEDICO_PKG
IS
PROCEDURE medico_agregar (
			id_med IN MEDICO.ID_MEDICO%TYPE,
			run_med IN MEDICO.RUN_MEDICO%TYPE,
			nom_med IN MEDICO.NOMBRE_MEDICO%TYPE,
			univers IN MEDICO.UNIVERSIDAD%TYPE,
			mail_med IN MEDICO.MAIL_MEDICO%TYPE,
			tel_med IN MEDICO.TEL_MEDICO%TYPE,
			est_med IN MEDICO.ESTADO_MEDICO%TYPE,
      f_creacion IN MEDICO.FECHACREACION%TYPE,
      cur OUT SYS_REFCURSOR)
IS 
contar NUMBER(1) := 0;
resp MEDICO.ID_MEDICO%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM MEDICO
WHERE ID_MEDICO = id_med;			
IF contar = 0 THEN 
  INSERT INTO MEDICO VALUES (id_med, run_med, nom_med, univers, mail_med, tel_med, est_med, (TO_DATE(f_creacion,'dd-mm-rr')));
  OPEN cur FOR
  SELECT *
  FROM MEDICO
  WHERE ID_MEDICO = (SELECT MAX(ID_MEDICO) FROM MEDICO);
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20001, 'El médico Existe, No se puede agregar el médico al sistema');
  ROLLBACK;
END IF;  
END medico_agregar;

PROCEDURE medico_eliminar (id_med IN MEDICO.ID_MEDICO%TYPE, est_med IN MEDICO.ESTADO_MEDICO%TYPE)
IS
contar NUMBER(1) := 0;
resp MEDICO.ID_MEDICO%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM MEDICO
WHERE ID_MEDICO = id_med;
IF contar = 1 THEN 
  UPDATE MEDICO SET ESTADO_MEDICO = est_med
  WHERE ID_MEDICO = id_med
  RETURNING id_med INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El médico NO Existe, Verifique médico');
  ROLLBACK;
END IF; 
END medico_eliminar;

PROCEDURE medico_modificar (
			run_med IN MEDICO.RUN_MEDICO%TYPE,
			nom_med IN MEDICO.NOMBRE_MEDICO%TYPE,
			univers IN MEDICO.UNIVERSIDAD%TYPE,
			mail_med IN MEDICO.MAIL_MEDICO%TYPE,
			tel_med IN MEDICO.TEL_MEDICO%TYPE,
			est_med IN MEDICO.ESTADO_MEDICO%TYPE,
      f_creacion IN MEDICO.FECHACREACION%TYPE,
			id_med IN MEDICO.ID_MEDICO%TYPE)
IS
contar NUMBER(1) := 0;
resp MEDICO.ID_MEDICO%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM MEDICO
WHERE ID_MEDICO = id_med;
IF contar = 1 THEN 
  UPDATE MEDICO SET 
                  RUN_MEDICO = run_med, 
                  NOMBRE_MEDICO = nom_med, 
                  UNIVERSIDAD = univers,
                  MAIL_MEDICO = mail_med,
                  TEL_MEDICO = 	tel_med,
                  ESTADO_MEDICO = est_med,
                  FECHACREACION = f_creacion
  WHERE ID_MEDICO = id_med RETURNING id_med INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El médico NO Existe, Verifique médico');
  ROLLBACK;
END IF;  
END medico_modificar;

PROCEDURE medico_consultar (id_med IN MEDICO.ID_MEDICO%TYPE, cur OUT SYS_REFCURSOR)
IS
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM MEDICO
WHERE ID_MEDICO = id_med;
IF contar = 1 THEN 
  OPEN cur FOR
  SELECT ID_MEDICO, RUN_MEDICO, NOMBRE_MEDICO, UNIVERSIDAD, MAIL_MEDICO, TEL_MEDICO, ESTADO_MEDICO, FECHACREACION
  FROM MEDICO
  WHERE ID_MEDICO = id_med AND ESTADO_MEDICO > 0;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El médico NO Existe, Verifique médico');
  ROLLBACK;
END IF; 
END medico_consultar;

PROCEDURE All_medico_consultar (est_med IN MEDICO.ESTADO_MEDICO%TYPE, cur OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN cur FOR
  SELECT ID_MEDICO, RUN_MEDICO, NOMBRE_MEDICO, UNIVERSIDAD, MAIL_MEDICO, TEL_MEDICO, ESTADO_MEDICO, FECHACREACION
  FROM MEDICO
  WHERE ESTADO_MEDICO = est_med;
  COMMIT;
END All_medico_consultar;
END MEDICO_PKG;
/

create or replace PACKAGE OBS_INGENIERO_PKG
IS
PROCEDURE obs_ingeniero_agregar (
			id_obs_ing IN OBS_INGENIERO.ID_OBS_INGENIERO%TYPE,
			fechaHora_obs_ing IN OBS_INGENIERO.FECHA_HORA_OBS_ING%TYPE,
			obs IN OBS_INGENIERO.OBS_ING%TYPE,
			eval_ter_id_eval_ter IN OBS_INGENIERO.EVAL_TERR_ID_EVAL_TERR%TYPE,
			est_obs IN OBS_INGENIERO.ESTADO%TYPE,
      id_usuario IN OBS_INGENIERO.EVAL_TERR_ID_USUARIO%TYPE,      
      cur OUT SYS_REFCURSOR);
PROCEDURE obs_ingeniero_eliminar (id_obs_ing IN OBS_INGENIERO.ID_OBS_INGENIERO%TYPE, est_obs IN OBS_INGENIERO.ESTADO%TYPE);
PROCEDURE obs_ingeniero_modificar (
			fechaHora_obs_ing IN OBS_INGENIERO.FECHA_HORA_OBS_ING%TYPE,
			obs IN OBS_INGENIERO.OBS_ING%TYPE,
			eval_ter_id_eval_ter IN OBS_INGENIERO.EVAL_TERR_ID_EVAL_TERR%TYPE,
			est_obs IN OBS_INGENIERO.ESTADO%TYPE,
      id_usuario IN OBS_INGENIERO.EVAL_TERR_ID_USUARIO%TYPE,
			id_obs_ing IN OBS_INGENIERO.ID_OBS_INGENIERO%TYPE);
PROCEDURE obs_ingeniero_consultar (id_obs_ing IN OBS_INGENIERO.ID_OBS_INGENIERO%TYPE, cur OUT SYS_REFCURSOR);
PROCEDURE All_obs_ingeniero_consultar (est_obs IN OBS_INGENIERO.ESTADO%TYPE, cur OUT SYS_REFCURSOR);
END OBS_INGENIERO_PKG;
/

create or replace PACKAGE BODY OBS_INGENIERO_PKG
IS
PROCEDURE obs_ingeniero_agregar (
			id_obs_ing IN OBS_INGENIERO.ID_OBS_INGENIERO%TYPE,
			fechaHora_obs_ing IN OBS_INGENIERO.FECHA_HORA_OBS_ING%TYPE,
			obs IN OBS_INGENIERO.OBS_ING%TYPE,
			eval_ter_id_eval_ter IN OBS_INGENIERO.EVAL_TERR_ID_EVAL_TERR%TYPE,
			est_obs IN OBS_INGENIERO.ESTADO%TYPE,
      id_usuario IN OBS_INGENIERO.EVAL_TERR_ID_USUARIO%TYPE,
      cur OUT SYS_REFCURSOR)
IS 
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM OBS_INGENIERO
WHERE ID_OBS_INGENIERO = id_obs_ing;			
IF contar = 0 THEN 
  INSERT INTO OBS_INGENIERO VALUES (id_obs_ing, (TO_DATE(fechaHora_obs_ing,'dd-mm-rr')), obs, eval_ter_id_eval_ter, est_obs, id_usuario);
  OPEN cur FOR
  SELECT *
  FROM OBS_INGENIERO
  WHERE ID_OBS_INGENIERO = (SELECT MAX(ID_OBS_INGENIERO) FROM OBS_INGENIERO);
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20001, 'La observación Existe, No se puede agregar observación al sistema');
  ROLLBACK;
END IF;  
END obs_ingeniero_agregar;

PROCEDURE obs_ingeniero_eliminar (id_obs_ing IN OBS_INGENIERO.ID_OBS_INGENIERO%TYPE, est_obs IN OBS_INGENIERO.ESTADO%TYPE)
IS
contar NUMBER(1) := 0;
resp OBS_INGENIERO.ID_OBS_INGENIERO%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM OBS_INGENIERO
WHERE ID_OBS_INGENIERO = id_obs_ing;
IF contar = 1 THEN 
  UPDATE OBS_INGENIERO SET ESTADO = est_obs
  WHERE ID_OBS_INGENIERO = id_obs_ing
  RETURNING id_obs_ing INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La observación NO Existe, Verifique observaciones');
  ROLLBACK;
END IF; 
END obs_ingeniero_eliminar;

PROCEDURE obs_ingeniero_modificar (
			fechaHora_obs_ing IN OBS_INGENIERO.FECHA_HORA_OBS_ING%TYPE,
			obs IN OBS_INGENIERO.OBS_ING%TYPE,
			eval_ter_id_eval_ter IN OBS_INGENIERO.EVAL_TERR_ID_EVAL_TERR%TYPE,
			est_obs IN OBS_INGENIERO.ESTADO%TYPE,
      id_usuario IN OBS_INGENIERO.EVAL_TERR_ID_USUARIO%TYPE,
			id_obs_ing IN OBS_INGENIERO.ID_OBS_INGENIERO%TYPE)
IS
contar NUMBER(1) := 0;
resp OBS_INGENIERO.ID_OBS_INGENIERO%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM OBS_INGENIERO
WHERE ID_OBS_INGENIERO = id_obs_ing;
IF contar = 1 THEN 
  UPDATE OBS_INGENIERO SET 
                  FECHA_HORA_OBS_ING = fechaHora_obs_ing, 
                  OBS_ING = obs, 
                  EVAL_TERR_ID_EVAL_TERR = eval_ter_id_eval_ter,
                  ESTADO = est_obs,
                  EVAL_TERR_ID_USUARIO = id_usuario
  WHERE ID_OBS_INGENIERO = id_obs_ing RETURNING id_obs_ing INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La observación NO Existe, Verifique observaciones');
  ROLLBACK;
END IF;  
END obs_ingeniero_modificar;

PROCEDURE obs_ingeniero_consultar (id_obs_ing IN OBS_INGENIERO.ID_OBS_INGENIERO%TYPE, cur OUT SYS_REFCURSOR)
IS
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM OBS_INGENIERO
WHERE ID_OBS_INGENIERO = id_obs_ing;
IF contar = 1 THEN 
  OPEN cur FOR
  SELECT ID_OBS_INGENIERO, FECHA_HORA_OBS_ING, OBS_ING, EVAL_TERR_ID_EVAL_TERR, ESTADO, EVAL_TERR_ID_USUARIO
  FROM OBS_INGENIERO
  WHERE ID_OBS_INGENIERO = id_obs_ing AND ESTADO > 0;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La observación NO Existe, Verifique observaciones');
  ROLLBACK;
END IF; 
END obs_ingeniero_consultar;

PROCEDURE All_obs_ingeniero_consultar (est_obs IN OBS_INGENIERO.ESTADO%TYPE, cur OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN cur FOR
  SELECT ID_OBS_INGENIERO, FECHA_HORA_OBS_ING, OBS_ING, EVAL_TERR_ID_EVAL_TERR, ESTADO, EVAL_TERR_ID_USUARIO
  FROM OBS_INGENIERO
  WHERE ESTADO = est_obs;
  COMMIT;
END All_obs_ingeniero_consultar;
END OBS_INGENIERO_PKG;
/

create or replace PACKAGE OBS_SUPERVISOR_PKG
IS
PROCEDURE obs_supervisor_agregar (
			id_obs_sup IN OBS_SUPERVISOR.ID_OBS_SUPERVISOR%TYPE,
			fechaHora_obs_sup IN OBS_SUPERVISOR.FECHA_HORA_OBS_SUPERVISOR%TYPE,
			obs IN OBS_SUPERVISOR.OBS_SUPERVISOR%TYPE,
			est_obs IN OBS_SUPERVISOR.ESTADO%TYPE,
			eval_ter_id_eval_ter IN OBS_SUPERVISOR.EVAL_TERR_ID_EVAL_TERR%TYPE,
      id_usuario IN OBS_SUPERVISOR.EVAL_TERR_ID_USUARIO%TYPE,      
      cur OUT SYS_REFCURSOR);
PROCEDURE obs_supervisor_eliminar (id_obs_sup IN OBS_SUPERVISOR.ID_OBS_SUPERVISOR%TYPE, est_obs IN OBS_SUPERVISOR.ESTADO%TYPE);
PROCEDURE obs_supervisor_modificar (
			fechaHora_obs_sup IN OBS_SUPERVISOR.FECHA_HORA_OBS_SUPERVISOR%TYPE,
			obs IN OBS_SUPERVISOR.OBS_SUPERVISOR%TYPE,
			est_obs IN OBS_SUPERVISOR.ESTADO%TYPE,
			eval_ter_id_eval_ter IN OBS_SUPERVISOR.EVAL_TERR_ID_EVAL_TERR%TYPE,
      id_usuario IN OBS_SUPERVISOR.EVAL_TERR_ID_USUARIO%TYPE,
			id_obs_sup IN OBS_SUPERVISOR.ID_OBS_SUPERVISOR%TYPE);
PROCEDURE obs_supervisor_consultar (id_obs_sup IN OBS_SUPERVISOR.ID_OBS_SUPERVISOR%TYPE, cur OUT SYS_REFCURSOR);
PROCEDURE All_obs_supervisor_consultar (est_obs IN OBS_SUPERVISOR.ESTADO%TYPE, cur OUT SYS_REFCURSOR);
END OBS_SUPERVISOR_PKG;
/

create or replace PACKAGE BODY OBS_SUPERVISOR_PKG
IS
PROCEDURE obs_supervisor_agregar (
			id_obs_sup IN OBS_SUPERVISOR.ID_OBS_SUPERVISOR%TYPE,
			fechaHora_obs_sup IN OBS_SUPERVISOR.FECHA_HORA_OBS_SUPERVISOR%TYPE,
			obs IN OBS_SUPERVISOR.OBS_SUPERVISOR%TYPE,
			est_obs IN OBS_SUPERVISOR.ESTADO%TYPE,
			eval_ter_id_eval_ter IN OBS_SUPERVISOR.EVAL_TERR_ID_EVAL_TERR%TYPE,
      id_usuario IN OBS_SUPERVISOR.EVAL_TERR_ID_USUARIO%TYPE,
      cur OUT SYS_REFCURSOR)
IS 
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM OBS_SUPERVISOR
WHERE ID_OBS_SUPERVISOR = id_obs_sup;			
IF contar = 0 THEN 
  INSERT INTO OBS_SUPERVISOR VALUES (id_obs_sup, (TO_DATE(fechaHora_obs_sup,'dd-mm-rr')), obs, est_obs, eval_ter_id_eval_ter, id_usuario);
  OPEN cur FOR
  SELECT *
  FROM OBS_SUPERVISOR
  WHERE ID_OBS_SUPERVISOR = (SELECT MAX(ID_OBS_SUPERVISOR) FROM OBS_SUPERVISOR);
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20001, 'La observación Existe, No se puede agregar observación al sistema');
  ROLLBACK;
END IF;  
END obs_supervisor_agregar;

PROCEDURE obs_supervisor_eliminar (id_obs_sup IN OBS_SUPERVISOR.ID_OBS_SUPERVISOR%TYPE, est_obs IN OBS_SUPERVISOR.ESTADO%TYPE)
IS
contar NUMBER(1) := 0;
resp OBS_SUPERVISOR.ID_OBS_SUPERVISOR%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM OBS_SUPERVISOR
WHERE ID_OBS_SUPERVISOR = id_obs_sup;
IF contar = 1 THEN 
  UPDATE OBS_SUPERVISOR SET ESTADO = est_obs
  WHERE ID_OBS_SUPERVISOR = id_obs_sup
  RETURNING id_obs_sup INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La observación NO Existe, Verifique observaciones');
  ROLLBACK;
END IF; 
END obs_supervisor_eliminar;

PROCEDURE obs_supervisor_modificar (
			fechaHora_obs_sup IN OBS_SUPERVISOR.FECHA_HORA_OBS_SUPERVISOR%TYPE,
			obs IN OBS_SUPERVISOR.OBS_SUPERVISOR%TYPE,
			est_obs IN OBS_SUPERVISOR.ESTADO%TYPE,
			eval_ter_id_eval_ter IN OBS_SUPERVISOR.EVAL_TERR_ID_EVAL_TERR%TYPE,
      id_usuario IN OBS_SUPERVISOR.EVAL_TERR_ID_USUARIO%TYPE,
			id_obs_sup IN OBS_SUPERVISOR.ID_OBS_SUPERVISOR%TYPE)
IS
contar NUMBER(1) := 0;
resp OBS_SUPERVISOR.ID_OBS_SUPERVISOR%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM OBS_SUPERVISOR
WHERE ID_OBS_SUPERVISOR = id_obs_sup;
IF contar = 1 THEN 
  UPDATE OBS_SUPERVISOR SET 
                  FECHA_HORA_OBS_SUPERVISOR = fechaHora_obs_sup, 
                  OBS_SUPERVISOR = obs, 
                  ESTADO = est_obs,
                  EVAL_TERR_ID_EVAL_TERR = id_obs_sup,
                  EVAL_TERR_ID_USUARIO = id_usuario
  WHERE ID_OBS_SUPERVISOR = id_obs_sup RETURNING id_obs_sup INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La observación NO Existe, Verifique observaciones');
  ROLLBACK;
END IF;  
END obs_supervisor_modificar;

PROCEDURE obs_supervisor_consultar (id_obs_sup IN OBS_SUPERVISOR.ID_OBS_SUPERVISOR%TYPE, cur OUT SYS_REFCURSOR)
IS
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM OBS_SUPERVISOR
WHERE ID_OBS_SUPERVISOR = id_obs_sup;
IF contar = 1 THEN 
  OPEN cur FOR
  SELECT ID_OBS_SUPERVISOR, FECHA_HORA_OBS_SUPERVISOR, OBS_SUPERVISOR, ESTADO, EVAL_TERR_ID_EVAL_TERR, EVAL_TERR_ID_USUARIO
  FROM OBS_SUPERVISOR
  WHERE ID_OBS_SUPERVISOR = id_obs_sup AND ESTADO > 0;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La observación NO Existe, Verifique observaciones');
  ROLLBACK;
END IF; 
END obs_supervisor_consultar;

PROCEDURE All_obs_supervisor_consultar (est_obs IN OBS_SUPERVISOR.ESTADO%TYPE, cur OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN cur FOR
  SELECT ID_OBS_SUPERVISOR, FECHA_HORA_OBS_SUPERVISOR, OBS_SUPERVISOR, ESTADO, EVAL_TERR_ID_EVAL_TERR, EVAL_TERR_ID_USUARIO
  FROM OBS_SUPERVISOR
  WHERE ESTADO = est_obs;
  COMMIT;
END All_obs_supervisor_consultar;
END OBS_SUPERVISOR_PKG;
/

create or replace PACKAGE PLAN_CAP_PKG
IS
PROCEDURE plan_cap_agregar (
			id_plan_capacitacion IN PLAN_CAP.ID_PLAN_CAP%TYPE,
			f_creacion IN PLAN_CAP.FECHA_CREACION%TYPE,
			est_plan_cap IN PLAN_CAP.ESTADO_PLAN_CAP%TYPE,
			cli_id_cli IN PLAN_CAP.CLIENTE_ID_CLIENTE%TYPE,
      cur OUT SYS_REFCURSOR);
PROCEDURE plan_cap_eliminar (id_plan_capacitacion IN PLAN_CAP.ID_PLAN_CAP%TYPE, est_plan_cap IN PLAN_CAP.ESTADO_PLAN_CAP%TYPE);
PROCEDURE plan_cap_modificar (
			f_creacion IN PLAN_CAP.FECHA_CREACION%TYPE,
			est_plan_cap IN PLAN_CAP.ESTADO_PLAN_CAP%TYPE,
			cli_id_cli IN PLAN_CAP.CLIENTE_ID_CLIENTE%TYPE,
			id_plan_capacitacion IN PLAN_CAP.ID_PLAN_CAP%TYPE);
PROCEDURE plan_cap_consultar (id_plan_capacitacion IN PLAN_CAP.ID_PLAN_CAP%TYPE, cur OUT SYS_REFCURSOR);
PROCEDURE All_plan_cap_consultar (est_plan_cap IN PLAN_CAP.ESTADO_PLAN_CAP%TYPE, cur OUT SYS_REFCURSOR);
END PLAN_CAP_PKG;
/

create or replace PACKAGE BODY PLAN_CAP_PKG
IS
PROCEDURE plan_cap_agregar (
			id_plan_capacitacion IN PLAN_CAP.ID_PLAN_CAP%TYPE,
			f_creacion IN PLAN_CAP.FECHA_CREACION%TYPE,
			est_plan_cap IN PLAN_CAP.ESTADO_PLAN_CAP%TYPE,
			cli_id_cli IN PLAN_CAP.CLIENTE_ID_CLIENTE%TYPE,
      cur OUT SYS_REFCURSOR)
IS 
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM PLAN_CAP
WHERE ID_PLAN_CAP = id_plan_capacitacion;			
IF contar = 0 THEN 
  INSERT INTO PLAN_CAP VALUES (id_plan_capacitacion, (TO_DATE(f_creacion,'dd-mm-rr')), est_plan_cap, cli_id_cli);
  OPEN cur FOR
  SELECT *
  FROM PLAN_CAP
  WHERE ID_PLAN_CAP = (SELECT MAX(ID_PLAN_CAP) FROM PLAN_CAP);
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20001, 'El plan Existe, No se puede agregar plan al sistema');
  ROLLBACK;
END IF;  
END plan_cap_agregar;

PROCEDURE plan_cap_eliminar (id_plan_capacitacion IN PLAN_CAP.ID_PLAN_CAP%TYPE, est_plan_cap IN PLAN_CAP.ESTADO_PLAN_CAP%TYPE)
IS
contar NUMBER(1) := 0;
resp PLAN_CAP.ID_PLAN_CAP%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM PLAN_CAP
WHERE ID_PLAN_CAP = id_plan_capacitacion;
IF contar = 1 THEN 
  UPDATE PLAN_CAP SET ESTADO_PLAN_CAP = est_plan_cap
  WHERE ID_PLAN_CAP = id_plan_capacitacion
  RETURNING id_plan_capacitacion INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El plan NO Existe, Verifique plan');
  ROLLBACK;
END IF; 
END plan_cap_eliminar;

PROCEDURE plan_cap_modificar (
			f_creacion IN PLAN_CAP.FECHA_CREACION%TYPE,
			est_plan_cap IN PLAN_CAP.ESTADO_PLAN_CAP%TYPE,
			cli_id_cli IN PLAN_CAP.CLIENTE_ID_CLIENTE%TYPE,
			id_plan_capacitacion IN PLAN_CAP.ID_PLAN_CAP%TYPE)
IS
contar NUMBER(1) := 0;
resp PLAN_CAP.ID_PLAN_CAP%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM PLAN_CAP
WHERE ID_PLAN_CAP = id_plan_capacitacion;
IF contar = 1 THEN 
  UPDATE PLAN_CAP SET 
                  FECHA_CREACION = f_creacion, 
                  ESTADO_PLAN_CAP = est_plan_cap, 
                  CLIENTE_ID_CLIENTE = cli_id_cli 
  WHERE ID_PLAN_CAP = id_plan_capacitacion RETURNING id_plan_capacitacion INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El plan NO Existe, Verifique plan');
  ROLLBACK;
END IF;  
END plan_cap_modificar;

PROCEDURE plan_cap_consultar (id_plan_capacitacion IN PLAN_CAP.ID_PLAN_CAP%TYPE, cur OUT SYS_REFCURSOR)
IS
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM PLAN_CAP
WHERE ID_PLAN_CAP = id_plan_capacitacion;
IF contar = 1 THEN 
  OPEN cur FOR
  SELECT ID_PLAN_CAP, FECHA_CREACION, ESTADO_PLAN_CAP, CLIENTE_ID_CLIENTE
  FROM PLAN_CAP
  WHERE ID_PLAN_CAP = id_plan_capacitacion AND ESTADO_PLAN_CAP > 0;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El plan NO Existe, Verifique plan');
  ROLLBACK;
END IF; 
END plan_cap_consultar;

PROCEDURE All_plan_cap_consultar (est_plan_cap IN PLAN_CAP.ESTADO_PLAN_CAP%TYPE, cur OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN cur FOR
  SELECT ID_PLAN_CAP, FECHA_CREACION, ESTADO_PLAN_CAP, CLIENTE_ID_CLIENTE
  FROM PLAN_CAP
  WHERE ESTADO_PLAN_CAP = est_plan_cap;
  COMMIT;
END All_plan_cap_consultar;
END PLAN_CAP_PKG;
/

create or replace PACKAGE PLAN_SALUD_PKG
IS
PROCEDURE plan_salud_agregar (
			id_plan_sal IN PLAN_SALUD.ID_PLAN_SALUD%TYPE,
			f_creacion IN PLAN_SALUD.FECHA_CREACION%TYPE,
			est_plan_sal IN PLAN_SALUD.ESTADO_PLAN_SALUD%TYPE,
			cli_id_cli IN PLAN_SALUD.CLIENTE_ID_CLIENTE%TYPE,
      cur OUT SYS_REFCURSOR);
PROCEDURE plan_salud_eliminar (id_plan_sal IN PLAN_SALUD.ID_PLAN_SALUD%TYPE, est_plan_sal IN PLAN_SALUD.ESTADO_PLAN_SALUD%TYPE);
PROCEDURE plan_salud_modificar (
			f_creacion IN PLAN_SALUD.FECHA_CREACION%TYPE,
			est_plan_sal IN PLAN_SALUD.ESTADO_PLAN_SALUD%TYPE,
			cli_id_cli IN PLAN_SALUD.CLIENTE_ID_CLIENTE%TYPE,
			id_plan_sal IN PLAN_SALUD.ID_PLAN_SALUD%TYPE);
PROCEDURE plan_salud_consultar (id_plan_sal IN PLAN_SALUD.ID_PLAN_SALUD%TYPE, cur OUT SYS_REFCURSOR);
PROCEDURE All_plan_salud_consultar (est_plan_sal IN PLAN_SALUD.ESTADO_PLAN_SALUD%TYPE, cur OUT SYS_REFCURSOR);
END PLAN_SALUD_PKG;
/

create or replace PACKAGE BODY PLAN_SALUD_PKG
IS
PROCEDURE plan_salud_agregar (
			id_plan_sal IN PLAN_SALUD.ID_PLAN_SALUD%TYPE,
			f_creacion IN PLAN_SALUD.FECHA_CREACION%TYPE,
			est_plan_sal IN PLAN_SALUD.ESTADO_PLAN_SALUD%TYPE,
			cli_id_cli IN PLAN_SALUD.CLIENTE_ID_CLIENTE%TYPE,
      cur OUT SYS_REFCURSOR)
IS 
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM PLAN_SALUD
WHERE ID_PLAN_SALUD = id_plan_sal;			
IF contar = 0 THEN 
  INSERT INTO PLAN_SALUD VALUES (id_plan_sal, (TO_DATE(f_creacion,'dd-mm-rr')), est_plan_sal, cli_id_cli);
  OPEN cur FOR
  SELECT *
  FROM PLAN_SALUD
  WHERE ID_PLAN_SALUD = (SELECT MAX(ID_PLAN_SALUD) FROM PLAN_SALUD);
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20001, 'El plan Existe, No se puede agregar plan al sistema');
  ROLLBACK;
END IF;  
END plan_salud_agregar;

PROCEDURE plan_salud_eliminar (id_plan_sal IN PLAN_SALUD.ID_PLAN_SALUD%TYPE, est_plan_sal IN PLAN_SALUD.ESTADO_PLAN_SALUD%TYPE)
IS
contar NUMBER(1) := 0;
resp PLAN_SALUD.ID_PLAN_SALUD%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM PLAN_SALUD
WHERE ID_PLAN_SALUD = id_plan_sal;
IF contar = 1 THEN 
  UPDATE PLAN_SALUD SET ESTADO_PLAN_SALUD = est_plan_sal
  WHERE ID_PLAN_SALUD = id_plan_sal
  RETURNING id_plan_sal INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El plan NO Existe, Verifique plan');
  ROLLBACK;
END IF; 
END plan_salud_eliminar;

PROCEDURE plan_salud_modificar (
			f_creacion IN PLAN_SALUD.FECHA_CREACION%TYPE,
			est_plan_sal IN PLAN_SALUD.ESTADO_PLAN_SALUD%TYPE,
			cli_id_cli IN PLAN_SALUD.CLIENTE_ID_CLIENTE%TYPE,
			id_plan_sal IN PLAN_SALUD.ID_PLAN_SALUD%TYPE)
IS
contar NUMBER(1) := 0;
resp PLAN_SALUD.ID_PLAN_SALUD%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM PLAN_SALUD
WHERE ID_PLAN_SALUD = id_plan_sal;
IF contar = 1 THEN 
  UPDATE PLAN_SALUD SET 
                  FECHA_CREACION = f_creacion, 
                  ESTADO_PLAN_SALUD = est_plan_sal, 
                  CLIENTE_ID_CLIENTE = cli_id_cli 
  WHERE ID_PLAN_SALUD = id_plan_sal RETURNING id_plan_sal INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El plan NO Existe, Verifique plan');
  ROLLBACK;
END IF;  
END plan_salud_modificar;

PROCEDURE plan_salud_consultar (id_plan_sal IN PLAN_SALUD.ID_PLAN_SALUD%TYPE, cur OUT SYS_REFCURSOR)
IS
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM PLAN_SALUD
WHERE ID_PLAN_SALUD = id_plan_sal;
IF contar = 1 THEN 
  OPEN cur FOR
  SELECT ID_PLAN_SALUD, FECHA_CREACION, ESTADO_PLAN_SALUD, CLIENTE_ID_CLIENTE
  FROM PLAN_SALUD
  WHERE ID_PLAN_SALUD = id_plan_sal AND ESTADO_PLAN_SALUD > 0;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El plan NO Existe, Verifique plan');
  ROLLBACK;
END IF; 
END plan_salud_consultar;

PROCEDURE All_plan_salud_consultar (est_plan_sal IN PLAN_SALUD.ESTADO_PLAN_SALUD%TYPE, cur OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN cur FOR
  SELECT ID_PLAN_SALUD, FECHA_CREACION, ESTADO_PLAN_SALUD, CLIENTE_ID_CLIENTE
  FROM PLAN_SALUD
  WHERE ESTADO_PLAN_SALUD = est_plan_sal;
  COMMIT;
END All_plan_salud_consultar;
END PLAN_SALUD_PKG;
/

create or replace PACKAGE SESION_CAP_PKG
IS
PROCEDURE sesion_cap_agregar (
			id_ses_cap IN SESION_CAP.ID_SESION_CAP%TYPE,
			num_ses_cap IN SESION_CAP.NUM_SESION_CAP%TYPE,
			nom_ses IN SESION_CAP.NOMBRE_SESION%TYPE,
			cupos_ses IN SESION_CAP.CUPOS_SESION%TYPE,
			f_sesion IN SESION_CAP.FECHA_SESION%TYPE,
			h_inicio_cap IN VARCHAR2,
			h_term_cap IN VARCHAR2,
			descrip_ses IN SESION_CAP.DESCRIPCION_SESION%TYPE,
			est_ses IN SESION_CAP.ESTADO%TYPE,
			cap_id_cap IN SESION_CAP.CAPACITACION_ID_CAP%TYPE,
			expo_id_expo IN SESION_CAP.EXPOSITOR_ID_EXPOSITOR%TYPE,
      cur OUT SYS_REFCURSOR);
PROCEDURE sesion_cap_eliminar (id_ses_cap IN SESION_CAP.ID_SESION_CAP%TYPE, est_ses IN SESION_CAP.ESTADO%TYPE);
PROCEDURE sesion_cap_modificar (
			num_ses_cap IN SESION_CAP.NUM_SESION_CAP%TYPE,
			nom_ses IN SESION_CAP.NOMBRE_SESION%TYPE,
			cupos_ses IN SESION_CAP.CUPOS_SESION%TYPE,
			f_sesion IN SESION_CAP.FECHA_SESION%TYPE,
			h_inicio_cap IN SESION_CAP.HORA_INICIO_CAP%TYPE,
			h_term_cap IN SESION_CAP.HORA_TERMINO_CAP%TYPE,
			descrip_ses IN SESION_CAP.DESCRIPCION_SESION%TYPE,
			est_ses IN SESION_CAP.ESTADO%TYPE,
			cap_id_cap IN SESION_CAP.CAPACITACION_ID_CAP%TYPE,
			expo_id_expo IN SESION_CAP.EXPOSITOR_ID_EXPOSITOR%TYPE,
			id_ses_cap IN SESION_CAP.ID_SESION_CAP%TYPE);
PROCEDURE sesion_cap_consultar (id_ses_cap IN SESION_CAP.ID_SESION_CAP%TYPE, cur OUT SYS_REFCURSOR);
PROCEDURE All_sesion_cap_consultar (est_ses IN SESION_CAP.ESTADO%TYPE, cur OUT SYS_REFCURSOR);
END SESION_CAP_PKG;
/

create or replace PACKAGE BODY SESION_CAP_PKG
IS
PROCEDURE sesion_cap_agregar (
			id_ses_cap IN SESION_CAP.ID_SESION_CAP%TYPE,
			num_ses_cap IN SESION_CAP.NUM_SESION_CAP%TYPE,
			nom_ses IN SESION_CAP.NOMBRE_SESION%TYPE,
			cupos_ses IN SESION_CAP.CUPOS_SESION%TYPE,
			f_sesion IN SESION_CAP.FECHA_SESION%TYPE,
			h_inicio_cap IN VARCHAR2,
			h_term_cap IN VARCHAR2,
			descrip_ses IN SESION_CAP.DESCRIPCION_SESION%TYPE,
			est_ses IN SESION_CAP.ESTADO%TYPE,
			cap_id_cap IN SESION_CAP.CAPACITACION_ID_CAP%TYPE,
			expo_id_expo IN SESION_CAP.EXPOSITOR_ID_EXPOSITOR%TYPE,
      cur OUT SYS_REFCURSOR)
IS 
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM SESION_CAP
WHERE ID_SESION_CAP = id_ses_cap;			
IF contar = 0 THEN 
  INSERT INTO SESION_CAP VALUES (id_ses_cap, num_ses_cap, nom_ses, cupos_ses, (TO_DATE(f_sesion,'dd-mm-rr')), (TO_DATE(h_inicio_cap, 'dd-mm-rr HH24:MI:SS')), 
                                (TO_DATE(h_term_cap, 'dd-mm-rr HH24:MI:SS')), descrip_ses, est_ses, cap_id_cap, expo_id_expo);
  OPEN cur FOR
  SELECT *
  FROM SESION_CAP
  WHERE ID_SESION_CAP = (SELECT MAX(ID_SESION_CAP) FROM SESION_CAP);
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20001, 'La sesion Existe, No se puede agregar la sesion al sistema');
  ROLLBACK;
END IF;  
END sesion_cap_agregar;

PROCEDURE sesion_cap_eliminar (id_ses_cap IN SESION_CAP.ID_SESION_CAP%TYPE, est_ses IN SESION_CAP.ESTADO%TYPE)
IS
contar NUMBER(1) := 0;
resp SESION_CAP.ID_SESION_CAP%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM SESION_CAP
WHERE ID_SESION_CAP = id_ses_cap;
IF contar = 1 THEN 
  UPDATE SESION_CAP SET ESTADO = est_ses
  WHERE ID_SESION_CAP = id_ses_cap
  RETURNING id_ses_cap INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La sesión NO Existe, Verifique sesión');
  ROLLBACK;
END IF; 
END sesion_cap_eliminar;

PROCEDURE sesion_cap_modificar (
			num_ses_cap IN SESION_CAP.NUM_SESION_CAP%TYPE,
			nom_ses IN SESION_CAP.NOMBRE_SESION%TYPE,
			cupos_ses IN SESION_CAP.CUPOS_SESION%TYPE,
			f_sesion IN SESION_CAP.FECHA_SESION%TYPE,
			h_inicio_cap IN SESION_CAP.HORA_INICIO_CAP%TYPE,
			h_term_cap IN SESION_CAP.HORA_TERMINO_CAP%TYPE,
			descrip_ses IN SESION_CAP.DESCRIPCION_SESION%TYPE,
			est_ses IN SESION_CAP.ESTADO%TYPE,
			cap_id_cap IN SESION_CAP.CAPACITACION_ID_CAP%TYPE,
			expo_id_expo IN SESION_CAP.EXPOSITOR_ID_EXPOSITOR%TYPE,
			id_ses_cap IN SESION_CAP.ID_SESION_CAP%TYPE)
IS
contar NUMBER(1) := 0;
resp SESION_CAP.ID_SESION_CAP%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM SESION_CAP
WHERE ID_SESION_CAP = id_ses_cap;
IF contar = 1 THEN 
  UPDATE SESION_CAP SET 
                  NUM_SESION_CAP = num_ses_cap, 
                  NOMBRE_SESION = nom_ses, 
                  CUPOS_SESION = cupos_ses,
		  FECHA_SESION = f_sesion,
		  HORA_INICIO_CAP = h_inicio_cap,
		  HORA_TERMINO_CAP = h_term_cap,
		  DESCRIPCION_SESION = descrip_ses,
		  ESTADO = est_ses,
		  CAPACITACION_ID_CAP = cap_id_cap,
		  EXPOSITOR_ID_EXPOSITOR = expo_id_expo
  WHERE ID_SESION_CAP = id_ses_cap RETURNING id_ses_cap INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La sesión NO Existe, Verifique sesión');
  ROLLBACK;
END IF;  
END sesion_cap_modificar;

PROCEDURE sesion_cap_consultar (id_ses_cap IN SESION_CAP.ID_SESION_CAP%TYPE, cur OUT SYS_REFCURSOR)
IS
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM SESION_CAP
WHERE ID_SESION_CAP = id_ses_cap;
IF contar = 1 THEN 
  OPEN cur FOR
  SELECT ID_SESION_CAP, NUM_SESION_CAP, NOMBRE_SESION, CUPOS_SESION, FECHA_SESION, HORA_INICIO_CAP, HORA_TERMINO_CAP,
	 DESCRIPCION_SESION, ESTADO, CAPACITACION_ID_CAP, EXPOSITOR_ID_EXPOSITOR
  FROM SESION_CAP
  WHERE ID_SESION_CAP = id_ses_cap AND ESTADO > 0;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La sesión NO Existe, Verifique sesión');
  ROLLBACK;
END IF; 
END sesion_cap_consultar;

PROCEDURE All_sesion_cap_consultar (est_ses IN SESION_CAP.ESTADO%TYPE, cur OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN cur FOR
  SELECT ID_SESION_CAP, NUM_SESION_CAP, NOMBRE_SESION, CUPOS_SESION, FECHA_SESION, HORA_INICIO_CAP, HORA_TERMINO_CAP,
	 DESCRIPCION_SESION, ESTADO, CAPACITACION_ID_CAP, EXPOSITOR_ID_EXPOSITOR
  FROM SESION_CAP
  WHERE ESTADO = est_ses;
  COMMIT;
END All_sesion_cap_consultar;
END SESION_CAP_PKG;
/

create or replace PACKAGE SESION_SALUD_PKG
IS
PROCEDURE sesion_salud_agregar (
			id_ses_salud IN SESION_SALUD.ID_SESION_SALUD%TYPE,
			num_ses_salud IN SESION_SALUD.NUM_SESION_SALUD%TYPE,
			nom_ses_salud IN SESION_SALUD.NOMBRE_SESION_SALUD%TYPE,
			cupos_ses IN SESION_SALUD.CUPOS_SESION%TYPE,
			f_sesion IN SESION_SALUD.FECHA_SESION%TYPE,
			h_inicio_sal IN VARCHAR2,
			h_term_sal IN VARCHAR2,
			descrip_ses IN SESION_SALUD.DESCRIPCION_SESION_SALUD%TYPE,			
			med_id_med IN SESION_SALUD.MEDICO_ID_MEDICO%TYPE,
			exa_id_exa IN SESION_SALUD.EXAMENES_ID_EXAMEN%TYPE,
			est_ses IN SESION_SALUD.ESTADO%TYPE,
      cur OUT SYS_REFCURSOR);
PROCEDURE sesion_salud_eliminar (id_ses_salud IN SESION_SALUD.ID_SESION_SALUD%TYPE, est_ses IN SESION_SALUD.ESTADO%TYPE);
PROCEDURE sesion_salud_modificar (
			num_ses_salud IN SESION_SALUD.NUM_SESION_SALUD%TYPE,
			nom_ses_salud IN SESION_SALUD.NOMBRE_SESION_SALUD%TYPE,
			cupos_ses IN SESION_SALUD.CUPOS_SESION%TYPE,
			f_sesion IN SESION_SALUD.FECHA_SESION%TYPE,
			h_inicio_sal IN SESION_SALUD.HORA_INICIO_SALUD%TYPE,
			h_term_sal IN SESION_SALUD.HORA_TERMINO_SALUD%TYPE,
			descrip_ses IN SESION_SALUD.DESCRIPCION_SESION_SALUD%TYPE,			
			med_id_med IN SESION_SALUD.MEDICO_ID_MEDICO%TYPE,
			exa_id_exa IN SESION_SALUD.EXAMENES_ID_EXAMEN%TYPE,
			est_ses IN SESION_SALUD.ESTADO%TYPE,
			id_ses_salud IN SESION_SALUD.ID_SESION_SALUD%TYPE);
PROCEDURE sesion_salud_consultar (id_ses_salud IN SESION_SALUD.ID_SESION_SALUD%TYPE, cur OUT SYS_REFCURSOR);
PROCEDURE All_sesion_salud_consultar (est_ses IN SESION_SALUD.ESTADO%TYPE, cur OUT SYS_REFCURSOR);
END SESION_SALUD_PKG;
/

create or replace PACKAGE BODY SESION_SALUD_PKG
IS
PROCEDURE sesion_salud_agregar (
			id_ses_salud IN SESION_SALUD.ID_SESION_SALUD%TYPE,
			num_ses_salud IN SESION_SALUD.NUM_SESION_SALUD%TYPE,
			nom_ses_salud IN SESION_SALUD.NOMBRE_SESION_SALUD%TYPE,
			cupos_ses IN SESION_SALUD.CUPOS_SESION%TYPE,
			f_sesion IN SESION_SALUD.FECHA_SESION%TYPE,
			h_inicio_sal IN VARCHAR2,
			h_term_sal IN VARCHAR2,
			descrip_ses IN SESION_SALUD.DESCRIPCION_SESION_SALUD%TYPE,			
			med_id_med IN SESION_SALUD.MEDICO_ID_MEDICO%TYPE,
			exa_id_exa IN SESION_SALUD.EXAMENES_ID_EXAMEN%TYPE,
			est_ses IN SESION_SALUD.ESTADO%TYPE,
      cur OUT SYS_REFCURSOR)
IS 
contar NUMBER(1) := 0;
resp SESION_SALUD.ID_SESION_SALUD%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM SESION_SALUD
WHERE ID_SESION_SALUD = id_ses_salud;	
IF contar = 0 THEN 
  INSERT INTO SESION_SALUD VALUES (id_ses_salud, num_ses_salud, nom_ses_salud, cupos_ses, (TO_DATE(f_sesion,'dd-mm-rr')), (TO_DATE(h_inicio_sal,'dd-mm-rr HH24:MI:SS')), 
                                  (TO_DATE(h_term_sal, 'dd-mm-rr HH24:MI:SS')), descrip_ses, med_id_med, exa_id_exa, est_ses);
  OPEN cur FOR
  SELECT ID_SESION_SALUD, NUM_SESION_SALUD, NOMBRE_SESION_SALUD, CUPOS_SESION, FECHA_SESION, HORA_INICIO_SALUD, 
         HORA_TERMINO_SALUD, DESCRIPCION_SESION_SALUD, MEDICO_ID_MEDICO, EXAMENES_ID_EXAMEN, ESTADO
  FROM SESION_SALUD
  WHERE ID_SESION_SALUD = (SELECT MAX(ID_SESION_SALUD) FROM SESION_SALUD);
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20001, 'La sesion Existe, No se puede agregar la sesion al sistema');
  ROLLBACK;
END IF;  
END sesion_salud_agregar;

PROCEDURE sesion_salud_eliminar (id_ses_salud IN SESION_SALUD.ID_SESION_SALUD%TYPE, est_ses IN SESION_SALUD.ESTADO%TYPE)
IS
contar NUMBER(1) := 0;
resp SESION_SALUD.ID_SESION_SALUD%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM SESION_SALUD
WHERE ID_SESION_SALUD = id_ses_salud;
IF contar = 1 THEN 
  UPDATE SESION_SALUD SET ESTADO = est_ses
  WHERE ID_SESION_SALUD = id_ses_salud
  RETURNING id_ses_salud INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La sesión NO Existe, Verifique sesión');
  ROLLBACK;
END IF; 
END sesion_salud_eliminar;

PROCEDURE sesion_salud_modificar (
			num_ses_salud IN SESION_SALUD.NUM_SESION_SALUD%TYPE,
			nom_ses_salud IN SESION_SALUD.NOMBRE_SESION_SALUD%TYPE,
			cupos_ses IN SESION_SALUD.CUPOS_SESION%TYPE,
			f_sesion IN SESION_SALUD.FECHA_SESION%TYPE,
			h_inicio_sal IN SESION_SALUD.HORA_INICIO_SALUD%TYPE,
			h_term_sal IN SESION_SALUD.HORA_TERMINO_SALUD%TYPE,
			descrip_ses IN SESION_SALUD.DESCRIPCION_SESION_SALUD%TYPE,			
			med_id_med IN SESION_SALUD.MEDICO_ID_MEDICO%TYPE,
			exa_id_exa IN SESION_SALUD.EXAMENES_ID_EXAMEN%TYPE,
			est_ses IN SESION_SALUD.ESTADO%TYPE,
			id_ses_salud IN SESION_SALUD.ID_SESION_SALUD%TYPE)
IS
contar NUMBER(1) := 0;
resp SESION_SALUD.ID_SESION_SALUD%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM SESION_SALUD
WHERE ID_SESION_SALUD = id_ses_salud;
IF contar = 1 THEN 
  UPDATE SESION_SALUD SET 
                  NUM_SESION_SALUD = num_ses_salud, 
                  NOMBRE_SESION_SALUD = nom_ses_salud, 
                  CUPOS_SESION = cupos_ses,
                  FECHA_SESION = f_sesion,
                  HORA_INICIO_SALUD = h_inicio_sal,
                  HORA_TERMINO_SALUD = h_term_sal,
                  DESCRIPCION_SESION_SALUD = descrip_ses,
                  MEDICO_ID_MEDICO = med_id_med,
                  EXAMENES_ID_EXAMEN = exa_id_exa,
                  ESTADO = est_ses
  WHERE ID_SESION_SALUD = id_ses_salud RETURNING id_ses_salud INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La sesión NO Existe, Verifique sesión');
  ROLLBACK;
END IF;  
END sesion_salud_modificar;

PROCEDURE sesion_salud_consultar (id_ses_salud IN SESION_SALUD.ID_SESION_SALUD%TYPE, cur OUT SYS_REFCURSOR)
IS
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM SESION_SALUD
WHERE ID_SESION_SALUD = id_ses_salud;
IF contar = 1 THEN 
  OPEN cur FOR
  SELECT ID_SESION_SALUD, NUM_SESION_SALUD, NOMBRE_SESION_SALUD, CUPOS_SESION, FECHA_SESION, HORA_INICIO_SALUD,
	 HORA_TERMINO_SALUD, DESCRIPCION_SESION_SALUD, MEDICO_ID_MEDICO, EXAMENES_ID_EXAMEN, ESTADO
  FROM SESION_SALUD
  WHERE ID_SESION_SALUD = id_ses_salud AND ESTADO > 0;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La sesión NO Existe, Verifique sesión');
  ROLLBACK;
END IF; 
END sesion_salud_consultar;

PROCEDURE All_sesion_salud_consultar (est_ses IN SESION_SALUD.ESTADO%TYPE, cur OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN cur FOR
  SELECT ID_SESION_SALUD, NUM_SESION_SALUD, NOMBRE_SESION_SALUD, CUPOS_SESION, FECHA_SESION, HORA_INICIO_SALUD,
	 HORA_TERMINO_SALUD, DESCRIPCION_SESION_SALUD, MEDICO_ID_MEDICO, EXAMENES_ID_EXAMEN, ESTADO
  FROM SESION_SALUD
  WHERE ESTADO = est_ses;
  COMMIT;
END All_sesion_salud_consultar;
END SESION_SALUD_PKG;
/

create or replace PACKAGE SOLIEVALTER_PKG
IS
PROCEDURE soliEvalTer_agregar (
			id_soli IN SOLIEVALTER.ID_SOLICITUD%TYPE,
			f_creacion IN SOLIEVALTER.FECHA_CREACION%TYPE,
			dir_visit IN SOLIEVALTER.DIRECCION_VISITA%TYPE,
			descrip_visit IN SOLIEVALTER.DESCRIP_VISITA%TYPE,
			cli_id_cli IN SOLIEVALTER.CLIENTE_ID_CLIENTE%TYPE,
			tipo_vis_id_tipo_vis IN SOLIEVALTER.TIPOVISITTER_ID_TIPO_VISTER%TYPE,
			est_soli_eval_ter IN SOLIEVALTER.ESTADO%TYPE,
      cur OUT SYS_REFCURSOR);
PROCEDURE soliEvalTer_eliminar (id_soli IN SOLIEVALTER.ID_SOLICITUD%TYPE, est_soli_eval_ter IN SOLIEVALTER.ESTADO%TYPE);
PROCEDURE soliEvalTer_modificar (
			f_creacion IN SOLIEVALTER.FECHA_CREACION%TYPE,
			dir_visit IN SOLIEVALTER.DIRECCION_VISITA%TYPE,
			descrip_visit IN SOLIEVALTER.DESCRIP_VISITA%TYPE,
			cli_id_cli IN SOLIEVALTER.CLIENTE_ID_CLIENTE%TYPE,
			tipo_vis_id_tipo_vis IN SOLIEVALTER.TIPOVISITTER_ID_TIPO_VISTER%TYPE,
			est_soli_eval_ter IN SOLIEVALTER.ESTADO%TYPE,
			id_soli IN SOLIEVALTER.ID_SOLICITUD%TYPE);
PROCEDURE soliEvalTer_consultar (id_soli IN SOLIEVALTER.ID_SOLICITUD%TYPE, cur OUT SYS_REFCURSOR);
PROCEDURE All_soliEvalTer_consultar (est_soli_eval_ter IN SOLIEVALTER.ESTADO%TYPE, cur OUT SYS_REFCURSOR);
END SOLIEVALTER_PKG;
/

create or replace PACKAGE BODY SOLIEVALTER_PKG
IS
PROCEDURE soliEvalTer_agregar (
			id_soli IN SOLIEVALTER.ID_SOLICITUD%TYPE,
			f_creacion IN SOLIEVALTER.FECHA_CREACION%TYPE,
			dir_visit IN SOLIEVALTER.DIRECCION_VISITA%TYPE,
			descrip_visit IN SOLIEVALTER.DESCRIP_VISITA%TYPE,
			cli_id_cli IN SOLIEVALTER.CLIENTE_ID_CLIENTE%TYPE,
			tipo_vis_id_tipo_vis IN SOLIEVALTER.TIPOVISITTER_ID_TIPO_VISTER%TYPE,
			est_soli_eval_ter IN SOLIEVALTER.ESTADO%TYPE,
      cur OUT SYS_REFCURSOR)
IS 
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM SOLIEVALTER
WHERE ID_SOLICITUD = id_soli;			
IF contar = 0 THEN 
  INSERT INTO SOLIEVALTER VALUES (id_soli, (TO_DATE(f_creacion,'dd-mm-rr')), dir_visit, descrip_visit, 
				cli_id_cli, tipo_vis_id_tipo_vis, est_soli_eval_ter);
  OPEN cur FOR
  SELECT *
  FROM SOLIEVALTER
  WHERE ID_SOLICITUD = (SELECT MAX(ID_SOLICITUD) FROM SOLIEVALTER);
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20001, 'La solicitud Existe, No se puede agregar solicitud al sistema');
  ROLLBACK;
END IF;  
END soliEvalTer_agregar;

PROCEDURE soliEvalTer_eliminar (id_soli IN SOLIEVALTER.ID_SOLICITUD%TYPE, est_soli_eval_ter IN SOLIEVALTER.ESTADO%TYPE)
IS
contar NUMBER(1) := 0;
resp SOLIEVALTER.ID_SOLICITUD%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM SOLIEVALTER
WHERE ID_SOLICITUD = id_soli;
IF contar = 1 THEN 
  UPDATE SOLIEVALTER SET ESTADO = est_soli_eval_ter
  WHERE ID_SOLICITUD = id_soli
  RETURNING id_soli INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La solicitud NO Existe, Verifique solicitud');
  ROLLBACK;
END IF; 
END soliEvalTer_eliminar;

PROCEDURE soliEvalTer_modificar (
			f_creacion IN SOLIEVALTER.FECHA_CREACION%TYPE,
			dir_visit IN SOLIEVALTER.DIRECCION_VISITA%TYPE,
			descrip_visit IN SOLIEVALTER.DESCRIP_VISITA%TYPE,
			cli_id_cli IN SOLIEVALTER.CLIENTE_ID_CLIENTE%TYPE,
			tipo_vis_id_tipo_vis IN SOLIEVALTER.TIPOVISITTER_ID_TIPO_VISTER%TYPE,
			est_soli_eval_ter IN SOLIEVALTER.ESTADO%TYPE,
			id_soli IN SOLIEVALTER.ID_SOLICITUD%TYPE)
IS
contar NUMBER(1) := 0;
resp SOLIEVALTER.ID_SOLICITUD%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM SOLIEVALTER
WHERE ID_SOLICITUD = id_soli;
IF contar = 1 THEN 
  UPDATE SOLIEVALTER SET 
                  FECHA_CREACION = f_creacion, 
                  DIRECCION_VISITA = dir_visit, 
                  DESCRIP_VISITA = descrip_visit,
		  CLIENTE_ID_CLIENTE = cli_id_cli,
		  TIPOVISITTER_ID_TIPO_VISTER = tipo_vis_id_tipo_vis,
		  ESTADO = est_soli_eval_ter
  WHERE ID_SOLICITUD = id_soli RETURNING id_soli INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La solicitud NO Existe, Verifique solicitud');
  ROLLBACK;
END IF;  
END soliEvalTer_modificar;

PROCEDURE soliEvalTer_consultar (id_soli IN SOLIEVALTER.ID_SOLICITUD%TYPE, cur OUT SYS_REFCURSOR)
IS
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM SOLIEVALTER
WHERE ID_SOLICITUD = id_soli;
IF contar = 1 THEN 
  OPEN cur FOR
  SELECT ID_SOLICITUD, FECHA_CREACION, DIRECCION_VISITA, DESCRIP_VISITA, CLIENTE_ID_CLIENTE, TIPOVISITTER_ID_TIPO_VISTER, ESTADO
  FROM SOLIEVALTER
  WHERE ID_SOLICITUD = id_soli AND ESTADO > 0;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'La solicitud NO Existe, Verifique solicitud');
  ROLLBACK;
END IF; 
END soliEvalTer_consultar;

PROCEDURE All_soliEvalTer_consultar (est_soli_eval_ter IN SOLIEVALTER.ESTADO%TYPE, cur OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN cur FOR
  SELECT ID_SOLICITUD, FECHA_CREACION, DIRECCION_VISITA, DESCRIP_VISITA, CLIENTE_ID_CLIENTE, TIPOVISITTER_ID_TIPO_VISTER, ESTADO
  FROM SOLIEVALTER
  WHERE ESTADO = est_soli_eval_ter;
  COMMIT;
END All_soliEvalTer_consultar;
END SOLIEVALTER_PKG;
/

create or replace PACKAGE TIPO_CAP_PKG
IS
PROCEDURE tipo_cap_agregar (
			id_tipo_capacitacion IN TIPO_CAP.ID_TIPO_CAP%TYPE,
			descrip_capacitacion IN TIPO_CAP.DESCRIP_CAP%TYPE,
			est_tipo_cap IN TIPO_CAP.ESTADO%TYPE,
      cur OUT SYS_REFCURSOR);
PROCEDURE tipo_cap_eliminar (id_tipo_capacitacion IN TIPO_CAP.ID_TIPO_CAP%TYPE, est_tipo_cap IN TIPO_CAP.ESTADO%TYPE);
PROCEDURE tipo_cap_modificar (
			descrip_capacitacion IN TIPO_CAP.DESCRIP_CAP%TYPE,
			est_tipo_cap IN TIPO_CAP.ESTADO%TYPE,
			id_tipo_capacitacion IN TIPO_CAP.ID_TIPO_CAP%TYPE);
PROCEDURE tipo_cap_consultar (id_tipo_capacitacion IN TIPO_CAP.ID_TIPO_CAP%TYPE, cur OUT SYS_REFCURSOR);
PROCEDURE All_tipo_cap_consultar (est_tipo_cap IN TIPO_CAP.ESTADO%TYPE, cur OUT SYS_REFCURSOR);
END TIPO_CAP_PKG;
/

create or replace PACKAGE BODY TIPO_CAP_PKG
IS
PROCEDURE tipo_cap_agregar (
			id_tipo_capacitacion IN TIPO_CAP.ID_TIPO_CAP%TYPE,
			descrip_capacitacion IN TIPO_CAP.DESCRIP_CAP%TYPE,
			est_tipo_cap IN TIPO_CAP.ESTADO%TYPE,
      cur OUT SYS_REFCURSOR)
IS 
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM TIPO_CAP
WHERE ID_TIPO_CAP = id_tipo_capacitacion;			
IF contar = 0 THEN 
  INSERT INTO TIPO_CAP VALUES (id_tipo_capacitacion, descrip_capacitacion, est_tipo_cap);
  OPEN cur FOR
  SELECT *
  FROM TIPO_CAP
  WHERE ID_TIPO_CAP = (SELECT MAX(ID_TIPO_CAP) FROM TIPO_CAP);
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20001, 'El tipo de capacitación Existe, No se puede agregar tipo capacitación al sistema');
  ROLLBACK;
END IF;  
END tipo_cap_agregar;

PROCEDURE tipo_cap_eliminar (id_tipo_capacitacion IN TIPO_CAP.ID_TIPO_CAP%TYPE, est_tipo_cap IN TIPO_CAP.ESTADO%TYPE)
IS
contar NUMBER(1) := 0;
resp TIPO_CAP.ID_TIPO_CAP%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM TIPO_CAP
WHERE ID_TIPO_CAP = id_tipo_capacitacion;
IF contar = 1 THEN 
  UPDATE TIPO_CAP SET ESTADO = est_tipo_cap
  WHERE ID_TIPO_CAP = id_tipo_capacitacion
  RETURNING id_tipo_capacitacion INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El tipo de capacitación NO Existe, Verifique tipo capacitación');
  ROLLBACK;
END IF; 
END tipo_cap_eliminar;

PROCEDURE tipo_cap_modificar (
			descrip_capacitacion IN TIPO_CAP.DESCRIP_CAP%TYPE,
			est_tipo_cap IN TIPO_CAP.ESTADO%TYPE,
			id_tipo_capacitacion IN TIPO_CAP.ID_TIPO_CAP%TYPE)
IS
contar NUMBER(1) := 0;
resp TIPO_CAP.ID_TIPO_CAP%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM TIPO_CAP
WHERE ID_TIPO_CAP = id_tipo_capacitacion;
IF contar = 1 THEN 
  UPDATE TIPO_CAP SET 
                  DESCRIP_CAP = descrip_capacitacion, 
                  ESTADO = est_tipo_cap
  WHERE ID_TIPO_CAP = id_tipo_capacitacion RETURNING id_tipo_capacitacion INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El tipo de capacitación NO Existe, Verifique tipo capacitación');
  ROLLBACK;
END IF;  
END tipo_cap_modificar;

PROCEDURE tipo_cap_consultar (id_tipo_capacitacion IN TIPO_CAP.ID_TIPO_CAP%TYPE, cur OUT SYS_REFCURSOR)
IS
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM TIPO_CAP
WHERE ID_TIPO_CAP = id_tipo_capacitacion;
IF contar = 1 THEN 
  OPEN cur FOR
  SELECT ID_TIPO_CAP, DESCRIP_CAP, ESTADO
  FROM TIPO_CAP
  WHERE ID_TIPO_CAP = id_tipo_capacitacion AND ESTADO > 1;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El tipo de capacitación NO Existe, Verifique tipo capacitación');
  ROLLBACK;
END IF; 
END tipo_cap_consultar;

PROCEDURE All_tipo_cap_consultar (est_tipo_cap IN TIPO_CAP.ESTADO%TYPE, cur OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN cur FOR
  SELECT ID_TIPO_CAP, DESCRIP_CAP, ESTADO
  FROM TIPO_CAP
  WHERE ESTADO = est_tipo_cap;
  COMMIT;
END All_tipo_cap_consultar;
END TIPO_CAP_PKG;
/

create or replace PACKAGE TIPO_EXAMEN_PKG
IS
PROCEDURE tipo_exa_agregar (
			id_tipo_examen IN TIPO_EXAMEN.ID_TIPO_EXAM%TYPE,
			descrip_examen IN TIPO_EXAMEN.DESCRIP_EXAM%TYPE,
			est_tipo_exa IN TIPO_EXAMEN.ESTADO%TYPE,
      cur OUT SYS_REFCURSOR);
PROCEDURE tipo_exa_eliminar (id_tipo_examen IN TIPO_EXAMEN.ID_TIPO_EXAM%TYPE, est_tipo_exa IN TIPO_EXAMEN.ESTADO%TYPE);
PROCEDURE tipo_exa_modificar (
			descrip_examen IN TIPO_EXAMEN.DESCRIP_EXAM%TYPE,
			est_tipo_exa IN TIPO_EXAMEN.ESTADO%TYPE,
			id_tipo_examen IN TIPO_EXAMEN.ID_TIPO_EXAM%TYPE);
PROCEDURE tipo_exa_consultar (id_tipo_examen IN TIPO_EXAMEN.ID_TIPO_EXAM%TYPE, cur OUT SYS_REFCURSOR);
PROCEDURE All_tipo_exa_consultar (est_tipo_exa IN TIPO_EXAMEN.ESTADO%TYPE, cur OUT SYS_REFCURSOR);
END TIPO_EXAMEN_PKG;
/

create or replace PACKAGE BODY TIPO_EXAMEN_PKG
IS
PROCEDURE tipo_exa_agregar (
			id_tipo_examen IN TIPO_EXAMEN.ID_TIPO_EXAM%TYPE,
			descrip_examen IN TIPO_EXAMEN.DESCRIP_EXAM%TYPE,
			est_tipo_exa IN TIPO_EXAMEN.ESTADO%TYPE,
      cur OUT SYS_REFCURSOR)
IS 
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM TIPO_EXAMEN
WHERE ID_TIPO_EXAM = id_tipo_examen;			
IF contar = 0 THEN 
  INSERT INTO TIPO_EXAMEN VALUES (id_tipo_examen, descrip_examen, est_tipo_exa);
  OPEN cur FOR
  SELECT *
  FROM TIPO_EXAMEN
  WHERE ID_TIPO_EXAM = (SELECT MAX(ID_TIPO_EXAM) FROM TIPO_EXAMEN);
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20001, 'El tipo de examen Existe, No se puede agregar tipo examen al sistema');
  ROLLBACK;
END IF;  
END tipo_exa_agregar;

PROCEDURE tipo_exa_eliminar (id_tipo_examen IN TIPO_EXAMEN.ID_TIPO_EXAM%TYPE, est_tipo_exa IN TIPO_EXAMEN.ESTADO%TYPE)
IS
contar NUMBER(1) := 0;
resp TIPO_EXAMEN.ID_TIPO_EXAM%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM TIPO_EXAMEN
WHERE ID_TIPO_EXAM = id_tipo_examen;
IF contar = 1 THEN 
  UPDATE TIPO_EXAMEN SET ESTADO = est_tipo_exa
  WHERE ID_TIPO_EXAM = id_tipo_examen
  RETURNING id_tipo_examen INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El tipo de examen NO Existe, Verifique tipo examen');
  ROLLBACK;
END IF; 
END tipo_exa_eliminar;

PROCEDURE tipo_exa_modificar (
			descrip_examen IN TIPO_EXAMEN.DESCRIP_EXAM%TYPE,
			est_tipo_exa IN TIPO_EXAMEN.ESTADO%TYPE,
			id_tipo_examen IN TIPO_EXAMEN.ID_TIPO_EXAM%TYPE)
IS
contar NUMBER(1) := 0;
resp TIPO_EXAMEN.ID_TIPO_EXAM%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM TIPO_EXAMEN
WHERE ID_TIPO_EXAM = id_tipo_examen;
IF contar = 1 THEN 
  UPDATE TIPO_EXAMEN SET 
                  DESCRIP_EXAM = descrip_examen, 
                  ESTADO = est_tipo_exa
  WHERE ID_TIPO_EXAM = id_tipo_examen RETURNING id_tipo_examen INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El tipo de examen NO Existe, Verifique tipo examen');
  ROLLBACK;
END IF;  
END tipo_exa_modificar;

PROCEDURE tipo_exa_consultar (id_tipo_examen IN TIPO_EXAMEN.ID_TIPO_EXAM%TYPE, cur OUT SYS_REFCURSOR)
IS
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM TIPO_EXAMEN
WHERE ID_TIPO_EXAM = id_tipo_examen;
IF contar = 1 THEN 
  OPEN cur FOR
  SELECT ID_TIPO_EXAM, DESCRIP_EXAM, ESTADO
  FROM TIPO_EXAMEN
  WHERE ID_TIPO_EXAM = id_tipo_examen AND ESTADO > 0;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El tipo de examen NO Existe, Verifique tipo examen');
  ROLLBACK;
END IF; 
END tipo_exa_consultar;

PROCEDURE All_tipo_exa_consultar (est_tipo_exa IN TIPO_EXAMEN.ESTADO%TYPE, cur OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN cur FOR
  SELECT ID_TIPO_EXAM, DESCRIP_EXAM, ESTADO
  FROM TIPO_EXAMEN
  WHERE ESTADO = est_tipo_exa;
  COMMIT;
END All_tipo_exa_consultar;
END TIPO_EXAMEN_PKG;
/

create or replace PACKAGE TIPOVISITTER_PKG
IS
PROCEDURE tipoVisitTer_agregar (
			id_tipo_visiter IN TIPOVISITTER.ID_TIPO_VISTER%TYPE,
			des_tip_vis_ter IN TIPOVISITTER.DES_TIPO_VIS_TER%TYPE,
			est_tipo_vis IN TIPOVISITTER.ESTADO%TYPE,
      cur OUT SYS_REFCURSOR);
PROCEDURE tipoVisitTer_eliminar (id_tipo_visiter IN TIPOVISITTER.ID_TIPO_VISTER%TYPE, est_tipo_vis IN TIPOVISITTER.ESTADO%TYPE);
PROCEDURE tipoVisitTer_modificar (
			des_tip_vis_ter IN TIPOVISITTER.DES_TIPO_VIS_TER%TYPE,
			est_tipo_vis IN TIPOVISITTER.ESTADO%TYPE,
			id_tipo_visiter IN TIPOVISITTER.ID_TIPO_VISTER%TYPE);
PROCEDURE tipoVisitTer_consultar (id_tipo_visiter IN TIPOVISITTER.ID_TIPO_VISTER%TYPE, cur OUT SYS_REFCURSOR);
PROCEDURE All_tipoVisitTer_consultar (est_tipo_vis IN TIPOVISITTER.ESTADO%TYPE, cur OUT SYS_REFCURSOR);
END TIPOVISITTER_PKG;
/

create or replace PACKAGE BODY TIPOVISITTER_PKG
IS
PROCEDURE tipoVisitTer_agregar (
			id_tipo_visiter IN TIPOVISITTER.ID_TIPO_VISTER%TYPE,
			des_tip_vis_ter IN TIPOVISITTER.DES_TIPO_VIS_TER%TYPE,
			est_tipo_vis IN TIPOVISITTER.ESTADO%TYPE,
      cur OUT SYS_REFCURSOR)
IS 
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM TIPOVISITTER
WHERE ID_TIPO_VISTER = id_tipo_visiter;			
IF contar = 0 THEN 
  INSERT INTO TIPOVISITTER VALUES (id_tipo_visiter, des_tip_vis_ter, est_tipo_vis);
  OPEN cur FOR
  SELECT *
  FROM TIPOVISITTER
  WHERE ID_TIPO_VISTER = (SELECT MAX(ID_TIPO_VISTER) FROM TIPOVISITTER);
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20001, 'El tipo de visita Existe, No se puede agregar tipo visita al sistema');
  ROLLBACK;
END IF;  
END tipoVisitTer_agregar;

PROCEDURE tipoVisitTer_eliminar (id_tipo_visiter IN TIPOVISITTER.ID_TIPO_VISTER%TYPE, est_tipo_vis IN TIPOVISITTER.ESTADO%TYPE)
IS
contar NUMBER(1) := 0;
resp TIPOVISITTER.ID_TIPO_VISTER%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM TIPOVISITTER
WHERE ID_TIPO_VISTER = id_tipo_visiter;
IF contar = 1 THEN 
  UPDATE TIPOVISITTER SET ESTADO = est_tipo_vis
  WHERE ID_TIPO_VISTER = id_tipo_visiter
  RETURNING id_tipo_visiter INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El tipo de visita NO Existe, Verifique tipo visita');
  ROLLBACK;
END IF; 
END tipoVisitTer_eliminar;

PROCEDURE tipoVisitTer_modificar (
			des_tip_vis_ter IN TIPOVISITTER.DES_TIPO_VIS_TER%TYPE,
			est_tipo_vis IN TIPOVISITTER.ESTADO%TYPE,
			id_tipo_visiter IN TIPOVISITTER.ID_TIPO_VISTER%TYPE)
IS
contar NUMBER(1) := 0;
resp TIPOVISITTER.ID_TIPO_VISTER%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM TIPOVISITTER
WHERE ID_TIPO_VISTER = id_tipo_visiter;
IF contar = 1 THEN 
  UPDATE TIPOVISITTER SET 
                  DES_TIPO_VIS_TER = des_tip_vis_ter, 
                  ESTADO = est_tipo_vis
  WHERE ID_TIPO_VISTER = id_tipo_visiter RETURNING id_tipo_visiter INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El tipo de visita NO Existe, Verifique tipo visita');
  ROLLBACK;
END IF;  
END tipoVisitTer_modificar;

PROCEDURE tipoVisitTer_consultar (id_tipo_visiter IN TIPOVISITTER.ID_TIPO_VISTER%TYPE, cur OUT SYS_REFCURSOR)
IS
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM TIPOVISITTER
WHERE ID_TIPO_VISTER = id_tipo_visiter;
IF contar = 1 THEN 
  OPEN cur FOR
  SELECT ID_TIPO_VISTER, DES_TIPO_VIS_TER, ESTADO
  FROM TIPOVISITTER
  WHERE ID_TIPO_VISTER = id_tipo_visiter AND ESTADO > 0;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El tipo de visita NO Existe, Verifique tipo visita');
  ROLLBACK;
END IF; 
END tipoVisitTer_consultar;

PROCEDURE All_tipoVisitTer_consultar (est_tipo_vis IN TIPOVISITTER.ESTADO%TYPE, cur OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN cur FOR
  SELECT ID_TIPO_VISTER, DES_TIPO_VIS_TER, ESTADO
  FROM TIPOVISITTER
  WHERE ESTADO = est_tipo_vis;
  COMMIT;
END All_tipoVisitTer_consultar;
END TIPOVISITTER_PKG;
/

create or replace PACKAGE USUARIOS_PKG
IS
PROCEDURE LOGIN (run_usu IN USUARIOS.RUN_USUARIO%TYPE, clave_usu IN USUARIOS.CLAVE_USUARIO%TYPE, cur OUT SYS_REFCURSOR);
PROCEDURE usuarios_agregar (
			id_usu IN USUARIOS.ID_USUARIO%TYPE,
			run_usu IN USUARIOS.RUN_USUARIO%TYPE,
			nom_usu IN USUARIOS.NOMBRES_USUARIO%TYPE,
			ap_pat IN USUARIOS.AP_PATERNO%TYPE,
			ap_mat IN USUARIOS.AP_MATERNO%TYPE,
			f_nac_usu IN USUARIOS.F_NACIMIENTO_USUARIO%TYPE,
			sexo_usu IN USUARIOS.SEXO_USUARIO%TYPE,
			tel_usu IN USUARIOS.TEL_USUARIO%TYPE,
			mail_usu IN USUARIOS.MAIL_USUARIO%TYPE,
			estado_usu IN USUARIOS.ESTADO_USUARIO%TYPE,
			clave_usu IN USUARIOS.CLAVE_USUARIO%TYPE,
			perf_id_perf IN USUARIOS.PERFIL_ID_PERFIL%TYPE,
			cli_id_cli IN USUARIOS.CLIENTE_ID_CLIENTE%TYPE,
      f_creacion IN USUARIOS.FECHACREACION%TYPE,
      cur OUT SYS_REFCURSOR);
PROCEDURE usuarios_eliminar (run_usu IN USUARIOS.RUN_USUARIO%TYPE, estado_usu IN USUARIOS.ESTADO_USUARIO%TYPE);
PROCEDURE usuarios_modificar (
			run_usu IN USUARIOS.RUN_USUARIO%TYPE,
			nom_usu IN USUARIOS.NOMBRES_USUARIO%TYPE,
			ap_pat IN USUARIOS.AP_PATERNO%TYPE,
			ap_mat IN USUARIOS.AP_MATERNO%TYPE,
			f_nac_usu IN USUARIOS.F_NACIMIENTO_USUARIO%TYPE,
			sexo_usu IN USUARIOS.SEXO_USUARIO%TYPE,
			tel_usu IN USUARIOS.TEL_USUARIO%TYPE,
			mail_usu IN USUARIOS.MAIL_USUARIO%TYPE,
			estado_usu IN USUARIOS.ESTADO_USUARIO%TYPE,
			clave_usu IN USUARIOS.CLAVE_USUARIO%TYPE,
			perf_id_perf IN USUARIOS.PERFIL_ID_PERFIL%TYPE,
			cli_id_cli IN USUARIOS.CLIENTE_ID_CLIENTE%TYPE,
      f_creacion IN USUARIOS.FECHACREACION%TYPE,
			id_usu IN USUARIOS.ID_USUARIO%TYPE);
PROCEDURE usuarios_consultar (run_usu IN USUARIOS.RUN_USUARIO%TYPE, cur OUT SYS_REFCURSOR);
PROCEDURE All_usuarios_consultar (estado_usu IN USUARIOS.ESTADO_USUARIO%TYPE, cur OUT SYS_REFCURSOR);
END USUARIOS_PKG;
/

create or replace PACKAGE BODY USUARIOS_PKG
IS
PROCEDURE LOGIN (run_usu IN USUARIOS.RUN_USUARIO%TYPE, clave_usu IN USUARIOS.CLAVE_USUARIO%TYPE, cur OUT SYS_REFCURSOR)
IS 
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM USUARIOS
WHERE RUN_USUARIO = run_usu;			
IF contar > 0 THEN 
  OPEN cur FOR
  SELECT ID_USUARIO, RUN_USUARIO, NOMBRES_USUARIO, AP_PATERNO, AP_MATERNO, F_NACIMIENTO_USUARIO, SEXO_USUARIO,
	 TEL_USUARIO, MAIL_USUARIO, ESTADO_USUARIO, CLAVE_USUARIO, PERFIL_ID_PERFIL, CLIENTE_ID_CLIENTE, FECHACREACION
  FROM USUARIOS
  WHERE RUN_USUARIO = run_usu AND CLAVE_USUARIO = clave_usu;
  COMMIT;  
ELSE
  RAISE_APPLICATION_ERROR(-20005, 'Clave incorrecta');
  ROLLBACK;
END IF;  
END LOGIN;

PROCEDURE usuarios_agregar (
			id_usu IN USUARIOS.ID_USUARIO%TYPE,
			run_usu IN USUARIOS.RUN_USUARIO%TYPE,
			nom_usu IN USUARIOS.NOMBRES_USUARIO%TYPE,
			ap_pat IN USUARIOS.AP_PATERNO%TYPE,
			ap_mat IN USUARIOS.AP_MATERNO%TYPE,
			f_nac_usu IN USUARIOS.F_NACIMIENTO_USUARIO%TYPE,
			sexo_usu IN USUARIOS.SEXO_USUARIO%TYPE,
			tel_usu IN USUARIOS.TEL_USUARIO%TYPE,
			mail_usu IN USUARIOS.MAIL_USUARIO%TYPE,
			estado_usu IN USUARIOS.ESTADO_USUARIO%TYPE,
			clave_usu IN USUARIOS.CLAVE_USUARIO%TYPE,
			perf_id_perf IN USUARIOS.PERFIL_ID_PERFIL%TYPE,
			cli_id_cli IN USUARIOS.CLIENTE_ID_CLIENTE%TYPE,
      f_creacion IN USUARIOS.FECHACREACION%TYPE,
      cur OUT SYS_REFCURSOR)
IS 
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM USUARIOS
WHERE ID_USUARIO = id_usu;			
IF contar = 0 THEN 
  INSERT INTO USUARIOS VALUES (id_usu, run_usu, nom_usu, ap_pat, ap_mat, (TO_DATE(f_nac_usu,'dd-mm-rr')), sexo_usu, 
				tel_usu, mail_usu, estado_usu, clave_usu, perf_id_perf, cli_id_cli, (TO_DATE(f_creacion,'dd-mm-rr')));
  OPEN cur FOR
  SELECT *
  FROM USUARIOS
  WHERE ID_USUARIO = (SELECT MAX(ID_USUARIO) FROM USUARIOS);
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20001, 'El usuario Existe, No se puede agregar usuario al sistema');
  ROLLBACK;
END IF;  
END usuarios_agregar;

PROCEDURE usuarios_eliminar (run_usu IN USUARIOS.RUN_USUARIO%TYPE, estado_usu IN USUARIOS.ESTADO_USUARIO%TYPE)
IS
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM USUARIOS
WHERE RUN_USUARIO = run_usu;
IF contar = 1 THEN 
  UPDATE USUARIOS SET ESTADO_USUARIO = estado_usu
  WHERE RUN_USUARIO = run_usu;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El usuario NO Existe, Verifique usuario');
  ROLLBACK;
END IF; 
END usuarios_eliminar;

PROCEDURE usuarios_modificar (
			run_usu IN USUARIOS.RUN_USUARIO%TYPE,
			nom_usu IN USUARIOS.NOMBRES_USUARIO%TYPE,
			ap_pat IN USUARIOS.AP_PATERNO%TYPE,
			ap_mat IN USUARIOS.AP_MATERNO%TYPE,
			f_nac_usu IN USUARIOS.F_NACIMIENTO_USUARIO%TYPE,
			sexo_usu IN USUARIOS.SEXO_USUARIO%TYPE,
			tel_usu IN USUARIOS.TEL_USUARIO%TYPE,
			mail_usu IN USUARIOS.MAIL_USUARIO%TYPE,
			estado_usu IN USUARIOS.ESTADO_USUARIO%TYPE,
			clave_usu IN USUARIOS.CLAVE_USUARIO%TYPE,
			perf_id_perf IN USUARIOS.PERFIL_ID_PERFIL%TYPE,
			cli_id_cli IN USUARIOS.CLIENTE_ID_CLIENTE%TYPE,
      f_creacion IN USUARIOS.FECHACREACION%TYPE,
			id_usu IN USUARIOS.ID_USUARIO%TYPE)
IS
contar NUMBER(1) := 0;
resp USUARIOS.ID_USUARIO%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM USUARIOS
WHERE ID_USUARIO = id_usu;
IF contar = 1 THEN 
  UPDATE USUARIOS SET 
                  RUN_USUARIO = run_usu, 
                  NOMBRES_USUARIO = nom_usu,
                  AP_PATERNO = ap_pat,
                  AP_MATERNO = ap_mat,
                  F_NACIMIENTO_USUARIO = f_nac_usu,
                  SEXO_USUARIO = sexo_usu,
                  TEL_USUARIO = tel_usu,
                  MAIL_USUARIO = mail_usu,
                  ESTADO_USUARIO = estado_usu,
                  CLAVE_USUARIO = clave_usu,
                  PERFIL_ID_PERFIL = perf_id_perf,
                  CLIENTE_ID_CLIENTE = cli_id_cli,
                  FECHACREACION = f_creacion
  WHERE ID_USUARIO = id_usu RETURNING id_usu INTO resp;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El usuario NO Existe, Verifique usuario');
  ROLLBACK;
END IF;  
END usuarios_modificar;

PROCEDURE usuarios_consultar (run_usu IN USUARIOS.RUN_USUARIO%TYPE, cur OUT SYS_REFCURSOR)
IS
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM USUARIOS
WHERE RUN_USUARIO = run_usu;
IF contar = 1 THEN 
  OPEN cur FOR
  SELECT ID_USUARIO, RUN_USUARIO, NOMBRES_USUARIO, AP_PATERNO, AP_MATERNO, F_NACIMIENTO_USUARIO, SEXO_USUARIO,
	 TEL_USUARIO, MAIL_USUARIO, ESTADO_USUARIO, CLAVE_USUARIO, PERFIL_ID_PERFIL, CLIENTE_ID_CLIENTE, FECHACREACION
  FROM USUARIOS
  WHERE RUN_USUARIO = run_usu AND ESTADO_USUARIO > 0;
  COMMIT;
ELSE
  RAISE_APPLICATION_ERROR(-20002, 'El usuario NO Existe, Verifique usuario');
  ROLLBACK;
END IF; 
END usuarios_consultar;

PROCEDURE All_usuarios_consultar (estado_usu IN USUARIOS.ESTADO_USUARIO%TYPE, cur OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN cur FOR
  SELECT ID_USUARIO, RUN_USUARIO, NOMBRES_USUARIO, AP_PATERNO, AP_MATERNO, F_NACIMIENTO_USUARIO, SEXO_USUARIO,
	 TEL_USUARIO, MAIL_USUARIO, ESTADO_USUARIO, CLAVE_USUARIO, PERFIL_ID_PERFIL, CLIENTE_ID_CLIENTE, FECHACREACION
  FROM USUARIOS
  WHERE ESTADO_USUARIO > 0;
  COMMIT;
END All_usuarios_consultar;
END USUARIOS_PKG;
/

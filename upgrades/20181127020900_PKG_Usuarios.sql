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
  SELECT NOMBRES_USUARIO, AP_PATERNO, AP_MATERNO, PERFIL_ID_PERFIL
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
      cur OUT SYS_REFCURSOR)
IS 
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM USUARIOS
WHERE ID_USUARIO = id_usu;			
IF contar = 0 THEN 
  INSERT INTO USUARIOS VALUES (id_usu, run_usu, nom_usu, ap_pat, ap_mat, (TO_DATE(f_nac_usu,'dd-mm-rr')), sexo_usu, 
				tel_usu, mail_usu, estado_usu, clave_usu, perf_id_perf, cli_id_cli);
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
resp USUARIOS.ID_USUARIO%TYPE;
BEGIN
SELECT COUNT(*) INTO contar
FROM USUARIOS
WHERE RUN_USUARIO = run_usu;
IF contar = 1 THEN 
  UPDATE USUARIOS SET ESTADO_USUARIO = estado_usu
  WHERE RUN_USUARIO = run_usu
  RETURNING run_usu INTO resp;
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
		  CLIENTE_ID_CLIENTE = cli_id_cli
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
	 TEL_USUARIO, MAIL_USUARIO, ESTADO_USUARIO, CLAVE_USUARIO, PERFIL_ID_PERFIL, CLIENTE_ID_CLIENTE
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
	 TEL_USUARIO, MAIL_USUARIO, ESTADO_USUARIO, CLAVE_USUARIO, PERFIL_ID_PERFIL, CLIENTE_ID_CLIENTE
  FROM USUARIOS
  WHERE ESTADO_USUARIO > 0;
  COMMIT;
END All_usuarios_consultar;
END USUARIOS_PKG;
/
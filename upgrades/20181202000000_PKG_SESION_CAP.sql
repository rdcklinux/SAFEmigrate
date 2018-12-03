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
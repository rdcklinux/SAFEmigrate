  create or replace PACKAGE LISTTRABSALUD_PKG
IS
PROCEDURE listtrabsalud_agregar (
			id_list_trab_salud IN LISTTRABSALUD.ID_LIS_TRAB_SALUD%TYPE,
			present IN LISTTRABSALUD.PRESENTE%TYPE,
			est_sal IN LISTTRABSALUD.ESTADO%TYPE,
			usu_id_usu IN LISTTRABSALUD.USUARIOS_ID_USUARIO%TYPE,
			lis_asis_salud_id_list_salud IN LISTTRABSALUD.LISTASISSALUD_ID_LIST_SALUD%TYPE,
			cert_id_cert IN LISTTRABSALUD.CERTIFICADO_ID_CERTIFICADO%TYPE,
      cur OUT SYS_REFCURSOR);
PROCEDURE listtrabsalud_eliminar (id_list_trab_salud IN LISTTRABSALUD.ID_LIS_TRAB_SALUD%TYPE, est_sal IN LISTTRABSALUD.ESTADO%TYPE);
PROCEDURE listtrabsalud_modificar (
			presen IN LISTTRABSALUD.PRESENTE%TYPE,
			est_sal IN LISTTRABSALUD.ESTADO%TYPE,
			usu_id_usu IN LISTTRABSALUD.USUARIOS_ID_USUARIO%TYPE,
			lis_asis_salud_id_list_salud IN LISTTRABSALUD.LISTASISSALUD_ID_LIST_SALUD%TYPE,
			cert_id_cert IN LISTTRABSALUD.CERTIFICADO_ID_CERTIFICADO%TYPE,
			id_list_trab_salud IN LISTTRABSALUD.ID_LIS_TRAB_SALUD%TYPE);
PROCEDURE listtrabsalud_consultar (id_list_trab_salud IN LISTTRABSALUD.ID_LIS_TRAB_SALUD%TYPE, cur OUT SYS_REFCURSOR);
PROCEDURE All_listtrabsalud_consultar (est_sal IN LISTTRABSALUD.ESTADO%TYPE, cur OUT SYS_REFCURSOR);
END LISTTRABSALUD_PKG;
/

create or replace PACKAGE BODY LISTTRABSALUD_PKG
IS
PROCEDURE listtrabsalud_agregar (
			id_list_trab_salud IN LISTTRABSALUD.ID_LIS_TRAB_SALUD%TYPE,
			present IN LISTTRABSALUD.PRESENTE%TYPE,
			est_sal IN LISTTRABSALUD.ESTADO%TYPE,
			usu_id_usu IN LISTTRABSALUD.USUARIOS_ID_USUARIO%TYPE,
			lis_asis_salud_id_list_salud IN LISTTRABSALUD.LISTASISSALUD_ID_LIST_SALUD%TYPE,
			cert_id_cert IN LISTTRABSALUD.CERTIFICADO_ID_CERTIFICADO%TYPE,
      cur OUT SYS_REFCURSOR)
IS 
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM LISTTRABSALUD
WHERE ID_LIS_TRAB_SALUD = id_list_trab_salud;			
IF contar = 0 THEN 
  INSERT INTO LISTTRABSALUD VALUES (id_list_trab_salud, present, est_sal, usu_id_usu, lis_asis_salud_id_list_salud, cert_id_cert);
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
                  CERTIFICADO_ID_CERTIFICADO = cert_id_cert
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
  SELECT ID_LIS_TRAB_SALUD, PRESENTE, ESTADO, USUARIOS_ID_USUARIO, LISTASISSALUD_ID_LIST_SALUD, CERTIFICADO_ID_CERTIFICADO
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
  SELECT ID_LIS_TRAB_SALUD, PRESENTE, ESTADO, USUARIOS_ID_USUARIO, LISTASISSALUD_ID_LIST_SALUD, CERTIFICADO_ID_CERTIFICADO
  FROM LISTTRABSALUD
  WHERE ESTADO = est_sal;
  COMMIT;
END All_listtrabsalud_consultar;
END LISTTRABSALUD_PKG;
/
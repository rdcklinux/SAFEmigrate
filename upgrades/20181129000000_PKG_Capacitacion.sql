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
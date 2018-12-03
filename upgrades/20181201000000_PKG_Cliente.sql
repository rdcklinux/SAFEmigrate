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
                          cur OUT SYS_REFCURSOR)
IS
contar NUMBER(1) := 0;
BEGIN
SELECT COUNT(*) INTO contar
FROM cliente 
WHERE rut_cliente = rut_cli;
IF contar = 0 THEN 
  INSERT INTO Cliente VALUES (id_cli, raz_soc, rut_cli, giro_cli, dir_cli, tel_of, nom_contacto, fn_contacto, correo_Contacto, cargo, obs, est_cli);
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
            NOMBRE_CONTACTO, FONO_CONTACTO, MAIL_CONTACTO, CARGO_CONTACTO, OBSERVACIONES_CLIENTE, ESTADO_CLIENTE
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
            NOMBRE_CONTACTO, FONO_CONTACTO, MAIL_CONTACTO, CARGO_CONTACTO, OBSERVACIONES_CLIENTE, ESTADO_CLIENTE
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
            NOMBRE_CONTACTO, FONO_CONTACTO, MAIL_CONTACTO, CARGO_CONTACTO, OBSERVACIONES_CLIENTE, ESTADO_CLIENTE
      FROM CLIENTE
      WHERE ESTADO_CLIENTE = ESTADO;
      COMMIT;
        
END All_Cliente_Consultar;

END CLIENTEPKG;
/
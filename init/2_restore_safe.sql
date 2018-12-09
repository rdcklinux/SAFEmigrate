CREATE TABLE Capacitacion
  (
    id_cap               INTEGER NOT NULL ,
    nombre_capacitacion  VARCHAR2 (50) ,
    estado_capacitacion  NUMBER ,
    Plan_Cap_id_plan_cap INTEGER NOT NULL ,
    Tipo_Cap_id_tipo_cap INTEGER NOT NULL
  ) ;
ALTER TABLE Capacitacion ADD CONSTRAINT Capacitacion_PK PRIMARY KEY ( id_cap ) ;

CREATE TABLE Certificado
  (
    id_certificado     INTEGER NOT NULL ,
    tipo_certificado   VARCHAR2 (20) ,
    cod_certificado    VARCHAR2 (64) ,
    estado             NUMBER ,
    fechaCreacion      DATE ,
    Cliente_id_cliente INTEGER NOT NULL
  ) ;
ALTER TABLE Certificado ADD CONSTRAINT Certificado_PK PRIMARY KEY ( id_certificado ) ;

CREATE TABLE Cliente
  (
    id_cliente            INTEGER NOT NULL ,
    razon_social          VARCHAR2 (50) ,
    rut_cliente           VARCHAR2 (12) ,
    giro_cliente          VARCHAR2 (100) ,
    Direccion_cliente     VARCHAR2 (50) ,
    tel_oficina           VARCHAR2 (14) ,
    nombre_contacto       VARCHAR2 (50) ,
    fono_contacto         VARCHAR2 (14) ,
    mail_contacto         VARCHAR2 (50) ,
    cargo_contacto        VARCHAR2 (30) ,
    observaciones_cliente VARCHAR2 (200) ,
    estado_cliente        NUMBER ,
    fechaCreacion         DATE
  ) ;
ALTER TABLE Cliente ADD CONSTRAINT Cliente_PK PRIMARY KEY ( id_cliente ) ;

CREATE TABLE Estado_Eval_Terr
  (
    id_Estado                INTEGER NOT NULL ,
    descrip_estado_eval_terr VARCHAR2 (20) ,
    estado                   NUMBER
  ) ;
ALTER TABLE Estado_Eval_Terr ADD CONSTRAINT Estado_Eval_Terr_PK PRIMARY KEY ( id_Estado ) ;

CREATE TABLE Eval_Terr
  (
    id_eval_Terr               INTEGER NOT NULL ,
    obs_visita                 VARCHAR2 (1000) ,
    fechaVisita                DATE ,
    estado                     NUMBER ,
    SoliEvalTer_id_solicitud   INTEGER NOT NULL ,
    Estado_Eval_Terr_id_Estado INTEGER NOT NULL ,
    Certificado_id_certificado INTEGER NOT NULL ,
    Usuarios_id_usuario        INTEGER NOT NULL ,
    fechaCreacion              DATE
  ) ;
CREATE UNIQUE INDEX Eval_Terr__IDX ON Eval_Terr
  (
    SoliEvalTer_id_solicitud ASC
  )
  ;
CREATE UNIQUE INDEX Eval_Terr__IDXv1 ON Eval_Terr
  (
    Certificado_id_certificado ASC
  )
  ;
  ALTER TABLE Eval_Terr ADD CONSTRAINT Eval_Terr_PK PRIMARY KEY ( id_eval_Terr, Usuarios_id_usuario ) ;

CREATE TABLE Examenes
  (
    id_examen                INTEGER NOT NULL ,
    nombre_examen            VARCHAR2 (30) ,
    estado_examen            NUMBER ,
    Plan_Salud_id_plan_salud INTEGER NOT NULL ,
    Tipo_Examen_id_tipo_exam INTEGER NOT NULL
  ) ;
ALTER TABLE Examenes ADD CONSTRAINT Examenes_PK PRIMARY KEY ( id_examen ) ;

CREATE TABLE Expositor
  (
    id_expositor     INTEGER NOT NULL ,
    run_expositor    VARCHAR2 (12) ,
    nombre_expositor VARCHAR2 (30) ,
    tel_expositor    VARCHAR2 (14) ,
    mail_expositor   VARCHAR2 (30) ,
    estado_expositor NUMBER ,
    fechaCreacion    DATE
  ) ;
ALTER TABLE Expositor ADD CONSTRAINT Expositor_PK PRIMARY KEY ( id_expositor ) ;

CREATE TABLE ListAsisSalud
  (
    id_list_salud                INTEGER NOT NULL ,
    estado_asist_salud           NUMBER ,
    Sesion_Salud_id_sesion_salud INTEGER NOT NULL ,
    fechaCreacion                DATE
  ) ;
CREATE UNIQUE INDEX ListAsisSalud__IDX ON ListAsisSalud
  (
    Sesion_Salud_id_sesion_salud ASC
  )
  ;
  ALTER TABLE ListAsisSalud ADD CONSTRAINT ListAsisSalud_PK PRIMARY KEY ( id_list_salud ) ;

CREATE TABLE ListTrabSalud
  (
    id_lis_trab_salud           INTEGER NOT NULL ,
    presente                    NUMBER ,
    estado                      NUMBER ,
    Usuarios_id_usuario         INTEGER NOT NULL ,
    ListAsisSalud_id_list_salud INTEGER NOT NULL ,
    Certificado_id_certificado  INTEGER NOT NULL ,
    fechaCreacion               DATE
  ) ;
CREATE UNIQUE INDEX ListTrabSalud__IDX ON ListTrabSalud
  (
    Certificado_id_certificado ASC
  )
  ;
  ALTER TABLE ListTrabSalud ADD CONSTRAINT ListTrabSalud_PK PRIMARY KEY ( id_lis_trab_salud ) ;

CREATE TABLE List_Asis_Cap
  (
    id_lista_cap             INTEGER NOT NULL ,
    estado_asist_cap         NUMBER ,
    Sesion_Cap_id_sesion_cap INTEGER NOT NULL ,
    fechaCreacion            DATE
  ) ;
CREATE UNIQUE INDEX List_Asis_Cap__IDX ON List_Asis_Cap
  (
    Sesion_Cap_id_sesion_cap ASC
  )
  ;
  ALTER TABLE List_Asis_Cap ADD CONSTRAINT List_Asis_Cap_PK PRIMARY KEY ( id_lista_cap ) ;

CREATE TABLE List_Trab_Cap
  (
    id_lis_trab_cap            INTEGER NOT NULL ,
    presente                   NUMBER ,
    estado                     NUMBER ,
    Usuarios_id_usuario        INTEGER NOT NULL ,
    List_Asis_Cap_id_lista_cap INTEGER NOT NULL ,
    Certificado_id_certificado INTEGER NOT NULL ,
    fechaCreacion              DATE
  ) ;
CREATE UNIQUE INDEX List_Trab_Cap__IDX ON List_Trab_Cap
  (
    Certificado_id_certificado ASC
  )
  ;
  ALTER TABLE List_Trab_Cap ADD CONSTRAINT List_Trab_Cap_PK PRIMARY KEY ( id_lis_trab_cap ) ;

CREATE TABLE Medico
  (
    id_medico     INTEGER NOT NULL ,
    run_medico    VARCHAR2 (12) ,
    nombre_medico VARCHAR2 (50) ,
    universidad   VARCHAR2 (30) ,
    mail_medico   VARCHAR2 (30) ,
    tel_medico    VARCHAR2 (14) ,
    estado_medico NUMBER ,
    fechaCreacion DATE
  ) ;
ALTER TABLE Medico ADD CONSTRAINT Medico_PK PRIMARY KEY ( id_medico ) ;

CREATE TABLE Menu
  (
    id_menu          INTEGER NOT NULL ,
    nombre_menu      VARCHAR2 (50) ,
    padre_menu       INTEGER ,
    destino_menu     VARCHAR2 (100) ,
    Perfil_id_perfil INTEGER NOT NULL
  ) ;
ALTER TABLE Menu ADD CONSTRAINT Menu_PK PRIMARY KEY ( id_menu ) ;

CREATE TABLE Obs_Ingeniero
  (
    id_obs_ingeniero       INTEGER NOT NULL ,
    fecha_hora_obs_ing     DATE ,
    obs_ing                VARCHAR2 (100) ,
    Eval_Terr_id_eval_Terr INTEGER NOT NULL ,
    estado                 NUMBER ,
    Eval_Terr_id_usuario   INTEGER NOT NULL
  ) ;
ALTER TABLE Obs_Ingeniero ADD CONSTRAINT Obs_Ingeniero_PK PRIMARY KEY ( id_obs_ingeniero ) ;

CREATE TABLE Obs_Supervisor
  (
    id_obs_supervisor         INTEGER NOT NULL ,
    fecha_hora_obs_supervisor DATE ,
    obs_supervisor            VARCHAR2 (100) ,
    estado                    NUMBER ,
    Eval_Terr_id_eval_Terr    INTEGER NOT NULL ,
    Eval_Terr_id_usuario      INTEGER NOT NULL
  ) ;
ALTER TABLE Obs_Supervisor ADD CONSTRAINT Obs_Supervisor_PK PRIMARY KEY ( id_obs_supervisor ) ;

CREATE TABLE Perfil
  (
    id_perfil   INTEGER NOT NULL ,
    tipo_perfil VARCHAR2 (20)
  ) ;
ALTER TABLE Perfil ADD CONSTRAINT Perfil_PK PRIMARY KEY ( id_perfil ) ;

CREATE TABLE Plan_Cap
  (
    id_plan_cap        INTEGER NOT NULL ,
    fecha_creacion     DATE ,
    estado_plan_cap    NUMBER ,
    Cliente_id_cliente INTEGER NOT NULL
  ) ;
ALTER TABLE Plan_Cap ADD CONSTRAINT Plan_Cap_PK PRIMARY KEY ( id_plan_cap ) ;

CREATE TABLE Plan_Salud
  (
    id_plan_salud      INTEGER NOT NULL ,
    fecha_creacion     DATE ,
    estado_plan_salud  NUMBER ,
    Cliente_id_cliente INTEGER NOT NULL
  ) ;
ALTER TABLE Plan_Salud ADD CONSTRAINT Plan_Salud_PK PRIMARY KEY ( id_plan_salud ) ;

CREATE TABLE Sesion_Cap
  (
    id_sesion_cap          INTEGER NOT NULL ,
    num_sesion_cap         INTEGER ,
    nombre_sesion          VARCHAR2 (30) ,
    cupos_sesion           INTEGER ,
    fecha_sesion           DATE ,
    hora_inicio_cap        DATE ,
    hora_termino_cap       DATE ,
    descripcion_sesion     VARCHAR2 (100) ,
    estado                 NUMBER ,
    Capacitacion_id_cap    INTEGER NOT NULL ,
    Expositor_id_expositor INTEGER NOT NULL
  ) ;
ALTER TABLE Sesion_Cap ADD CONSTRAINT Sesion_Cap_PK PRIMARY KEY ( id_sesion_cap ) ;

CREATE TABLE Sesion_Salud
  (
    id_sesion_salud          INTEGER NOT NULL ,
    num_sesion_salud         INTEGER ,
    nombre_sesion_salud      VARCHAR2 (30) ,
    cupos_sesion             INTEGER ,
    fecha_sesion             DATE ,
    hora_inicio_salud        DATE ,
    hora_termino_salud       DATE ,
    descripcion_sesion_salud VARCHAR2 (100) ,
    Medico_id_medico         INTEGER NOT NULL ,
    Examenes_id_examen       INTEGER NOT NULL ,
    estado                   NUMBER
  ) ;
ALTER TABLE Sesion_Salud ADD CONSTRAINT Sesion_Salud_PK PRIMARY KEY ( id_sesion_salud ) ;

CREATE TABLE SoliEvalTer
  (
    id_solicitud                INTEGER NOT NULL ,
    fecha_creacion              DATE ,
    direccion_visita            VARCHAR2 (50) ,
    descrip_visita              VARCHAR2 (100) ,
    Cliente_id_cliente          INTEGER NOT NULL ,
    tipoVisitTer_id_tipo_visTer INTEGER NOT NULL ,
    estado                      NUMBER
  ) ;
ALTER TABLE SoliEvalTer ADD CONSTRAINT SoliEvalTer_PK PRIMARY KEY ( id_solicitud ) ;

CREATE TABLE Tipo_Cap
  (
    id_tipo_cap INTEGER NOT NULL ,
    descrip_cap VARCHAR2 (100) NOT NULL ,
    estado      NUMBER
  ) ;
ALTER TABLE Tipo_Cap ADD CONSTRAINT Tipo_Cap_PK PRIMARY KEY ( id_tipo_cap ) ;

CREATE TABLE Tipo_Examen
  (
    id_tipo_exam INTEGER NOT NULL ,
    descrip_exam VARCHAR2 (100) NOT NULL ,
    estado       NUMBER
  ) ;
ALTER TABLE Tipo_Examen ADD CONSTRAINT Tipo_Examen_PK PRIMARY KEY ( id_tipo_exam ) ;

CREATE TABLE Usuarios
  (
    id_usuario           INTEGER NOT NULL ,
    run_usuario          VARCHAR2 (12) ,
    nombres_usuario      VARCHAR2 (50) ,
    ap_paterno           VARCHAR2 (50) ,
    ap_materno           VARCHAR2 (50) ,
    f_nacimiento_usuario DATE ,
    sexo_usuario         VARCHAR2 (10) ,
    tel_usuario          VARCHAR2 (14) ,
    mail_usuario         VARCHAR2 (60) ,
    estado_usuario       NUMBER ,
    clave_usuario        VARCHAR2 (64) ,
    Perfil_id_perfil     INTEGER NOT NULL ,
    Cliente_id_cliente   INTEGER NOT NULL ,
    FechaCreacion        DATE
  ) ;
ALTER TABLE Usuarios ADD CONSTRAINT Usuarios_PK PRIMARY KEY ( id_usuario ) ;

CREATE TABLE tipoVisitTer
  (
    id_tipo_visTer   INTEGER NOT NULL ,
    des_tipo_vis_ter VARCHAR2 (20) ,
    estado           NUMBER
  ) ;
ALTER TABLE tipoVisitTer ADD CONSTRAINT tipoVisitTer_PK PRIMARY KEY ( id_tipo_visTer ) ;

ALTER TABLE Capacitacion ADD CONSTRAINT Capacitacion_Plan_Cap_FK FOREIGN KEY ( Plan_Cap_id_plan_cap ) REFERENCES Plan_Cap ( id_plan_cap ) ;

ALTER TABLE Capacitacion ADD CONSTRAINT Capacitacion_Tipo_Cap_FK FOREIGN KEY ( Tipo_Cap_id_tipo_cap ) REFERENCES Tipo_Cap ( id_tipo_cap ) ;

ALTER TABLE Certificado ADD CONSTRAINT Certificado_Cliente_FK FOREIGN KEY ( Cliente_id_cliente ) REFERENCES Cliente ( id_cliente ) ;

ALTER TABLE Eval_Terr ADD CONSTRAINT Eval_Terr_Certificado_FK FOREIGN KEY ( Certificado_id_certificado ) REFERENCES Certificado ( id_certificado ) ;

ALTER TABLE Eval_Terr ADD CONSTRAINT Eval_Terr_Estado_Eval_Terr_FK FOREIGN KEY ( Estado_Eval_Terr_id_Estado ) REFERENCES Estado_Eval_Terr ( id_Estado ) ;

ALTER TABLE Eval_Terr ADD CONSTRAINT Eval_Terr_SoliEvalTer_FK FOREIGN KEY ( SoliEvalTer_id_solicitud ) REFERENCES SoliEvalTer ( id_solicitud ) ;

ALTER TABLE Eval_Terr ADD CONSTRAINT Eval_Terr_Usuarios_FK FOREIGN KEY ( Usuarios_id_usuario ) REFERENCES Usuarios ( id_usuario ) ;

ALTER TABLE Examenes ADD CONSTRAINT Examenes_Plan_Salud_FK FOREIGN KEY ( Plan_Salud_id_plan_salud ) REFERENCES Plan_Salud ( id_plan_salud ) ;

ALTER TABLE Examenes ADD CONSTRAINT Examenes_Tipo_Examen_FK FOREIGN KEY ( Tipo_Examen_id_tipo_exam ) REFERENCES Tipo_Examen ( id_tipo_exam ) ;

ALTER TABLE ListAsisSalud ADD CONSTRAINT ListAsisSalud_Sesion_Salud_FK FOREIGN KEY ( Sesion_Salud_id_sesion_salud ) REFERENCES Sesion_Salud ( id_sesion_salud ) ;

ALTER TABLE ListTrabSalud ADD CONSTRAINT ListTrabSalud_Certificado_FK FOREIGN KEY ( Certificado_id_certificado ) REFERENCES Certificado ( id_certificado ) ;

ALTER TABLE ListTrabSalud ADD CONSTRAINT ListTrabSalud_ListAsisSalud_FK FOREIGN KEY ( ListAsisSalud_id_list_salud ) REFERENCES ListAsisSalud ( id_list_salud ) ;

ALTER TABLE ListTrabSalud ADD CONSTRAINT ListTrabSalud_Usuarios_FK FOREIGN KEY ( Usuarios_id_usuario ) REFERENCES Usuarios ( id_usuario ) ;

ALTER TABLE List_Asis_Cap ADD CONSTRAINT List_Asis_Cap_Sesion_Cap_FK FOREIGN KEY ( Sesion_Cap_id_sesion_cap ) REFERENCES Sesion_Cap ( id_sesion_cap ) ;

ALTER TABLE List_Trab_Cap ADD CONSTRAINT List_Trab_Cap_Certificado_FK FOREIGN KEY ( Certificado_id_certificado ) REFERENCES Certificado ( id_certificado ) ;

ALTER TABLE List_Trab_Cap ADD CONSTRAINT List_Trab_Cap_List_Asis_Cap_FK FOREIGN KEY ( List_Asis_Cap_id_lista_cap ) REFERENCES List_Asis_Cap ( id_lista_cap ) ;

ALTER TABLE List_Trab_Cap ADD CONSTRAINT List_Trab_Cap_Usuarios_FK FOREIGN KEY ( Usuarios_id_usuario ) REFERENCES Usuarios ( id_usuario ) ;

ALTER TABLE Menu ADD CONSTRAINT Menu_Perfil_FK FOREIGN KEY ( Perfil_id_perfil ) REFERENCES Perfil ( id_perfil ) ;

ALTER TABLE Obs_Ingeniero ADD CONSTRAINT Obs_Ingeniero_Eval_Terr_FK FOREIGN KEY ( Eval_Terr_id_eval_Terr, Eval_Terr_id_usuario ) REFERENCES Eval_Terr ( id_eval_Terr, Usuarios_id_usuario ) ;

ALTER TABLE Obs_Supervisor ADD CONSTRAINT Obs_Supervisor_Eval_Terr_FK FOREIGN KEY ( Eval_Terr_id_eval_Terr, Eval_Terr_id_usuario ) REFERENCES Eval_Terr ( id_eval_Terr, Usuarios_id_usuario ) ;

ALTER TABLE Plan_Cap ADD CONSTRAINT Plan_Cap_Cliente_FK FOREIGN KEY ( Cliente_id_cliente ) REFERENCES Cliente ( id_cliente ) ;

ALTER TABLE Plan_Salud ADD CONSTRAINT Plan_Salud_Cliente_FK FOREIGN KEY ( Cliente_id_cliente ) REFERENCES Cliente ( id_cliente ) ;

ALTER TABLE Sesion_Cap ADD CONSTRAINT Sesion_Cap_Capacitacion_FK FOREIGN KEY ( Capacitacion_id_cap ) REFERENCES Capacitacion ( id_cap ) ;

ALTER TABLE Sesion_Cap ADD CONSTRAINT Sesion_Cap_Expositor_FK FOREIGN KEY ( Expositor_id_expositor ) REFERENCES Expositor ( id_expositor ) ;

ALTER TABLE Sesion_Salud ADD CONSTRAINT Sesion_Salud_Examenes_FK FOREIGN KEY ( Examenes_id_examen ) REFERENCES Examenes ( id_examen ) ;

ALTER TABLE Sesion_Salud ADD CONSTRAINT Sesion_Salud_Medico_FK FOREIGN KEY ( Medico_id_medico ) REFERENCES Medico ( id_medico ) ;

ALTER TABLE SoliEvalTer ADD CONSTRAINT SoliEvalTer_Cliente_FK FOREIGN KEY ( Cliente_id_cliente ) REFERENCES Cliente ( id_cliente ) ;

ALTER TABLE SoliEvalTer ADD CONSTRAINT SoliEvalTer_tipoVisitTer_FK FOREIGN KEY ( tipoVisitTer_id_tipo_visTer ) REFERENCES tipoVisitTer ( id_tipo_visTer ) ;

ALTER TABLE Usuarios ADD CONSTRAINT Usuarios_Cliente_FK FOREIGN KEY ( Cliente_id_cliente ) REFERENCES Cliente ( id_cliente ) ;

ALTER TABLE Usuarios ADD CONSTRAINT Usuarios_Perfil_FK FOREIGN KEY ( Perfil_id_perfil ) REFERENCES Perfil ( id_perfil ) ;


CREATE sequence Capacitacion_auto_incr start with 1 increment by 1;

CREATE sequence Certificado_auto_incr start with 1 increment by 1;

CREATE sequence Cliente_auto_incr start with 1 increment by 1;

CREATE sequence Estado_Eval_Terr_auto_incr start with 1 increment by 1;

CREATE sequence Eval_Terr_auto_incr start with 1 increment by 1;

CREATE sequence Examenes_auto_incr start with 1 increment by 1;

CREATE sequence Expositor_auto_incr start with 1 increment by 1;

CREATE sequence ListAsisSalud_auto_incr start with 1 increment by 1;

CREATE sequence ListTrabSalud_auto_incr start with 1 increment by 1;

CREATE sequence List_Asis_Cap_auto_incr start with 1 increment by 1;

CREATE sequence List_Trab_Cap_auto_incr start with 1 increment by 1;

CREATE sequence Medico_auto_incr start with 1 increment by 1;

CREATE sequence Menu_auto_incr start with 1 increment by 1;

CREATE sequence Obs_Ingeniero_auto_incr start with 1 increment by 1;

CREATE sequence Obs_Supervisor_auto_incr start with 1 increment by 1;

CREATE sequence Perfil_auto_incr start with 1 increment by 1;

CREATE sequence Plan_Cap_auto_incr start with 1 increment by 1;

CREATE sequence Plan_Salud_auto_incr start with 1 increment by 1;

CREATE sequence Sesion_Cap_auto_incr start with 1 increment by 1;

CREATE sequence Sesion_Salud_auto_incr start with 1 increment by 1;

CREATE sequence SoliEvalTer_auto_incr start with 1 increment by 1;

CREATE sequence Tipo_Cap_auto_incr start with 1 increment by 1;

CREATE sequence Tipo_Examen_auto_incr start with 1 increment by 1;

CREATE sequence Usuarios_auto_incr start with 1 increment by 1;

CREATE sequence tipoVisitTer_auto_incr start with 1 increment by 1;


create or replace TRIGGER CAPACITACION_TGR
BEFORE INSERT ON CAPACITACION
FOR EACH ROW
BEGIN
:new.id_cap := capacitacion_auto_incr.nextval;
END;
/

create or replace TRIGGER CERTIFICADO_TGR
BEFORE INSERT ON CERTIFICADO
FOR EACH ROW
BEGIN
:new.id_certificado := certificado_auto_incr.nextval;
END;
/

create or replace TRIGGER CLIENTE_TGR
BEFORE INSERT ON CLIENTE
FOR EACH ROW
BEGIN
:new.id_cliente := cliente_auto_incr.nextval;
END;
/

create or replace TRIGGER ESTADO_EVAL_TERR_TGR
BEFORE INSERT ON ESTADO_EVAL_TERR
FOR EACH ROW
BEGIN
:new.id_estado := estado_eval_terr_auto_incr.nextval;
END;


create or replace TRIGGER EVAL_TERR_TGR
BEFORE INSERT ON EVAL_TERR
FOR EACH ROW
BEGIN
:new.id_eval_terr := eval_terr_auto_incr.nextval;
END;
/

create or replace TRIGGER EXAMENES_TGR
BEFORE INSERT ON EXAMENES
FOR EACH ROW
BEGIN
:new.id_examen := examenes_auto_incr.nextval;
END;
/

create or replace TRIGGER EXPOSITOR_TGR
BEFORE INSERT ON EXPOSITOR
FOR EACH ROW
BEGIN
:new.id_expositor := expositor_auto_incr.nextval;
END;
/

create or replace TRIGGER LIST_ASIS_CAP_TGR
BEFORE INSERT ON LIST_ASIS_CAP
FOR EACH ROW
BEGIN
:new.id_lista_cap := list_asis_cap_auto_incr.nextval;
END;
/

create or replace TRIGGER LIST_TRAB_CAP_TGR
BEFORE INSERT ON LIST_TRAB_CAP
FOR EACH ROW
BEGIN
:new.id_lis_trab_cap := list_trab_cap_auto_incr.nextval;
END;
/

create or replace TRIGGER LISTASISSALUD_TGR
BEFORE INSERT ON LISTASISSALUD
FOR EACH ROW
BEGIN
:new.id_list_salud := listasissalud_auto_incr.nextval;
END;
/

create or replace TRIGGER LISTTRABSALUD_TGR
BEFORE INSERT ON LISTTRABSALUD
FOR EACH ROW
BEGIN
:new.id_lis_trab_salud := listtrabsalud_auto_incr.nextval;
END;
/

create or replace TRIGGER MEDICO_TGR
BEFORE INSERT ON MEDICO
FOR EACH ROW
BEGIN
:new.id_medico := medico_auto_incr.nextval;
END;
/

create or replace TRIGGER OBS_INGENIERO_TGR
BEFORE INSERT ON OBS_INGENIERO
FOR EACH ROW
BEGIN
:new.id_obs_ingeniero := obs_ingeniero_auto_incr.nextval;
END;
/

create or replace TRIGGER OBS_SUPERVISOR_TGR
BEFORE INSERT ON OBS_SUPERVISOR
FOR EACH ROW
BEGIN
:new.id_obs_supervisor := obs_supervisor_auto_incr.nextval;
END;
/

create or replace TRIGGER PLAN_CAP_TGR
BEFORE INSERT ON PLAN_CAP
FOR EACH ROW
BEGIN
:new.id_plan_cap := plan_cap_auto_incr.nextval;
END;
/

create or replace TRIGGER PLAN_SALUD_TGR
BEFORE INSERT ON PLAN_SALUD
FOR EACH ROW
BEGIN
:new.id_plan_salud := plan_salud_auto_incr.nextval;
END;
/

create or replace TRIGGER SESION_CAP_TGR
BEFORE INSERT ON SESION_CAP
FOR EACH ROW
BEGIN
:new.id_sesion_cap := sesion_cap_auto_incr.nextval;
END;
/

create or replace TRIGGER SESION_SALUD_TGR
BEFORE INSERT ON SESION_SALUD
FOR EACH ROW
BEGIN
:new.id_sesion_salud := sesion_salud_auto_incr.nextval;
END;
/

create or replace TRIGGER SOLIEVALTER_TGR
BEFORE INSERT ON SOLIEVALTER
FOR EACH ROW
BEGIN
:new.id_solicitud := solievalter_auto_incr.nextval;
END;
/

create or replace TRIGGER TIPO_CAP_TGR
BEFORE INSERT ON TIPO_CAP
FOR EACH ROW
BEGIN
:new.id_tipo_cap := tipo_cap_auto_incr.nextval;
END;
/

create or replace TRIGGER TIPO_EXAMEN_TGR
BEFORE INSERT ON TIPO_EXAMEN
FOR EACH ROW
BEGIN
:new.id_tipo_exam := tipo_examen_auto_incr.nextval;
END;
/

create or replace TRIGGER TIPOVISITTER_TGR
BEFORE INSERT ON TIPOVISITTER
FOR EACH ROW
BEGIN
:new.id_tipo_vister := tipovisitter_auto_incr.nextval;
END;
/

create or replace TRIGGER USUARIOS_TGR
BEFORE INSERT ON USUARIOS
FOR EACH ROW
BEGIN
:new.id_usuario := usuarios_auto_incr.nextval;
END;
/




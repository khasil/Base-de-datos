/*==============================================================*/
/* DBMS name:      PostgreSQL 8                                 */
/* Created on:     16/09/2025 22:26:35                          */
/*==============================================================*/


drop index AREA_PK;

drop table AREA;

drop index AUTOR_PK;

drop table AUTOR;

drop index EDITORIAL_PK;

drop table EDITORIAL;

drop index ESTADO_PK;

drop table ESTADO;

drop index LIBRO_TIPOLIBRO_FK;

drop index LIBRO_PAIS_FK;

drop index LIBRO_PK;

drop table LIBRO;

drop index RELACION_FK;

drop index LIBROSPOREXISTENCIA_PK;

drop table LIBROSPOREXISTENCIA;

drop index LIBROSPOREXISTENCIA_ESTADO_FK;

drop index LIBROSPOREXISTENCIA_ESTADO2_FK;

drop index LIBROSPOREXISTENCIA_ESTADO_PK;

drop table LIBROSPOREXISTENCIA_ESTADO;

drop index CONTIENE_FK;

drop index CONTIENE2_FK;

drop index LIBRO_AREA_PK;

drop table LIBRO_AREA;

drop index LIBRO_AUTOR_FK;

drop index LIBRO_AUTOR2_FK;

drop index LIBRO_AUTOR_PK;

drop table LIBRO_AUTOR;

drop index PAIS_PK;

drop table PAIS;

drop index PRESTAMO_TIPOPRESTAMO_FK;

drop index PRESTAMO_AFILIADO_FK;

drop index LIBROSPOREXISTENCIA_PRESTAMO_FK;

drop index PRESTAMO_PK;

drop table PRESTAMO;

drop index TIPOLIBRO_PK;

drop table TIPOLIBRO;

drop index TIPOPRESTAMO_PK;

drop table TIPOPRESTAMO;

drop index USUARIO_PK;

drop table USUARIO;

/*==============================================================*/
/* Table: AREA                                                  */
/*==============================================================*/
create table AREA (
   COD_AREA             INT4                 not null,
   NOMBRE_AREA          VARCHAR(50)          null,
   constraint PK_AREA primary key (COD_AREA)
);

/*==============================================================*/
/* Index: AREA_PK                                               */
/*==============================================================*/
create unique index AREA_PK on AREA (
COD_AREA
);

/*==============================================================*/
/* Table: AUTOR                                                 */
/*==============================================================*/
create table AUTOR (
   COD_AUTOR            INT4                 not null,
   NOMBRE_AUTOR         VARCHAR(50)          null,
   NACIONALIDAD         VARCHAR(30)          null,
   ANIO_NACIMIENTO      INT4                 null,
   constraint PK_AUTOR primary key (COD_AUTOR)
);

/*==============================================================*/
/* Index: AUTOR_PK                                              */
/*==============================================================*/
create unique index AUTOR_PK on AUTOR (
COD_AUTOR
);

/*==============================================================*/
/* Table: EDITORIAL                                             */
/*==============================================================*/
create table EDITORIAL (
   COD_EDITORIAL        VARCHAR(4)           not null,
   NOMBRE_EDITORIAL     VARCHAR(100)         null,
   DIRECCION_EDITORIAL  VARCHAR(50)          null,
   TELEFONO_EDITORIAL   NUMERIC(11)          null,
   constraint PK_EDITORIAL primary key (COD_EDITORIAL)
);

/*==============================================================*/
/* Index: EDITORIAL_PK                                          */
/*==============================================================*/
create unique index EDITORIAL_PK on EDITORIAL (
COD_EDITORIAL
);

/*==============================================================*/
/* Table: ESTADO                                                */
/*==============================================================*/
create table ESTADO (
   COD_ESTADO           INT4                 not null,
   ESTADO               VARCHAR(50)          null,
   constraint PK_ESTADO primary key (COD_ESTADO)
);

/*==============================================================*/
/* Index: ESTADO_PK                                             */
/*==============================================================*/
create unique index ESTADO_PK on ESTADO (
COD_ESTADO
);

/*==============================================================*/
/* Table: LIBRO                                                 */
/*==============================================================*/
create table LIBRO (
   COD_LIBRO            INT4                 not null,
   COD_PAIS             INT4                 null,
   COD_TIPOLIBRO        INT4                 null,
   ISBN                 VARCHAR(50)          null,
   TITULO               VARCHAR(100)         not null,
   FECHAPUBLICACION     DATE                 null,
   EDICION              VARCHAR(100)         null,
   constraint PK_LIBRO primary key (COD_LIBRO)
);

/*==============================================================*/
/* Index: LIBRO_PK                                              */
/*==============================================================*/
create unique index LIBRO_PK on LIBRO (
COD_LIBRO
);

/*==============================================================*/
/* Index: LIBRO_PAIS_FK                                         */
/*==============================================================*/
create  index LIBRO_PAIS_FK on LIBRO (
COD_PAIS
);

/*==============================================================*/
/* Index: LIBRO_TIPOLIBRO_FK                                    */
/*==============================================================*/
create  index LIBRO_TIPOLIBRO_FK on LIBRO (
COD_TIPOLIBRO
);

/*==============================================================*/
/* Table: LIBROSPOREXISTENCIA                                   */
/*==============================================================*/
create table LIBROSPOREXISTENCIA (
   COD_EXISTENCIA       INT4                 not null,
   COD_LIBRO            INT4                 null,
   COD_INVENTARIO       VARCHAR(20)          null,
   UBICACION            VARCHAR(50)          null,
   FECHA_ADQUISICION    DATE                 null,
   constraint PK_LIBROSPOREXISTENCIA primary key (COD_EXISTENCIA)
);

/*==============================================================*/
/* Index: LIBROSPOREXISTENCIA_PK                                */
/*==============================================================*/
create unique index LIBROSPOREXISTENCIA_PK on LIBROSPOREXISTENCIA (
COD_EXISTENCIA
);

/*==============================================================*/
/* Index: RELACION_FK                                           */
/*==============================================================*/
create  index RELACION_FK on LIBROSPOREXISTENCIA (
COD_LIBRO
);

/*==============================================================*/
/* Table: LIBROSPOREXISTENCIA_ESTADO                            */
/*==============================================================*/
create table LIBROSPOREXISTENCIA_ESTADO (
   COD_ESTADO           INT4                 not null,
   COD_EXISTENCIA       INT4                 not null,
   constraint PK_LIBROSPOREXISTENCIA_ESTADO primary key (COD_ESTADO, COD_EXISTENCIA)
);

/*==============================================================*/
/* Index: LIBROSPOREXISTENCIA_ESTADO_PK                         */
/*==============================================================*/
create unique index LIBROSPOREXISTENCIA_ESTADO_PK on LIBROSPOREXISTENCIA_ESTADO (
COD_ESTADO,
COD_EXISTENCIA
);

/*==============================================================*/
/* Index: LIBROSPOREXISTENCIA_ESTADO2_FK                        */
/*==============================================================*/
create  index LIBROSPOREXISTENCIA_ESTADO2_FK on LIBROSPOREXISTENCIA_ESTADO (
COD_EXISTENCIA
);

/*==============================================================*/
/* Index: LIBROSPOREXISTENCIA_ESTADO_FK                         */
/*==============================================================*/
create  index LIBROSPOREXISTENCIA_ESTADO_FK on LIBROSPOREXISTENCIA_ESTADO (
COD_ESTADO
);

/*==============================================================*/
/* Table: LIBRO_AREA                                            */
/*==============================================================*/
create table LIBRO_AREA (
   COD_LIBRO            INT4                 not null,
   COD_AREA             INT4                 not null,
   constraint PK_LIBRO_AREA primary key (COD_LIBRO, COD_AREA)
);

/*==============================================================*/
/* Index: LIBRO_AREA_PK                                         */
/*==============================================================*/
create unique index LIBRO_AREA_PK on LIBRO_AREA (
COD_LIBRO,
COD_AREA
);

/*==============================================================*/
/* Index: CONTIENE2_FK                                          */
/*==============================================================*/
create  index CONTIENE2_FK on LIBRO_AREA (
COD_AREA
);

/*==============================================================*/
/* Index: CONTIENE_FK                                           */
/*==============================================================*/
create  index CONTIENE_FK on LIBRO_AREA (
COD_LIBRO
);

/*==============================================================*/
/* Table: LIBRO_AUTOR                                           */
/*==============================================================*/
create table LIBRO_AUTOR (
   COD_AUTOR            INT4                 not null,
   COD_LIBRO            INT4                 not null,
   constraint PK_LIBRO_AUTOR primary key (COD_AUTOR, COD_LIBRO)
);

/*==============================================================*/
/* Index: LIBRO_AUTOR_PK                                        */
/*==============================================================*/
create unique index LIBRO_AUTOR_PK on LIBRO_AUTOR (
COD_AUTOR,
COD_LIBRO
);

/*==============================================================*/
/* Index: LIBRO_AUTOR2_FK                                       */
/*==============================================================*/
create  index LIBRO_AUTOR2_FK on LIBRO_AUTOR (
COD_LIBRO
);

/*==============================================================*/
/* Index: LIBRO_AUTOR_FK                                        */
/*==============================================================*/
create  index LIBRO_AUTOR_FK on LIBRO_AUTOR (
COD_AUTOR
);

/*==============================================================*/
/* Table: PAIS                                                  */
/*==============================================================*/
create table PAIS (
   COD_PAIS             INT4                 not null,
   NOMBRE_PAIS          VARCHAR(100)         null,
   constraint PK_PAIS primary key (COD_PAIS)
);

/*==============================================================*/
/* Index: PAIS_PK                                               */
/*==============================================================*/
create unique index PAIS_PK on PAIS (
COD_PAIS
);

/*==============================================================*/
/* Table: PRESTAMO                                              */
/*==============================================================*/
create table PRESTAMO (
   COD_PRESTAMO         INT4                 not null,
   COD_EXISTENCIA       INT4                 null,
   COD_USUARIO          INT4                 null,
   COD_TIPOPRESTAMO     INT4                 null,
   FECHA_PRESTAMO       DATE                 not null,
   HORA_PRESTAMO        TIME                 not null,
   FECHA_ENTREGA        DATE                 null,
   HORA_ENTREGA         TIME                 null,
   constraint PK_PRESTAMO primary key (COD_PRESTAMO)
);

/*==============================================================*/
/* Index: PRESTAMO_PK                                           */
/*==============================================================*/
create unique index PRESTAMO_PK on PRESTAMO (
COD_PRESTAMO
);

/*==============================================================*/
/* Index: LIBROSPOREXISTENCIA_PRESTAMO_FK                       */
/*==============================================================*/
create  index LIBROSPOREXISTENCIA_PRESTAMO_FK on PRESTAMO (
COD_EXISTENCIA
);

/*==============================================================*/
/* Index: PRESTAMO_AFILIADO_FK                                  */
/*==============================================================*/
create  index PRESTAMO_AFILIADO_FK on PRESTAMO (
COD_USUARIO
);

/*==============================================================*/
/* Index: PRESTAMO_TIPOPRESTAMO_FK                              */
/*==============================================================*/
create  index PRESTAMO_TIPOPRESTAMO_FK on PRESTAMO (
COD_TIPOPRESTAMO
);

/*==============================================================*/
/* Table: TIPOLIBRO                                             */
/*==============================================================*/
create table TIPOLIBRO (
   COD_TIPOLIBRO        INT4                 not null,
   TIPO                 VARCHAR(50)          null,
   constraint PK_TIPOLIBRO primary key (COD_TIPOLIBRO)
);

/*==============================================================*/
/* Index: TIPOLIBRO_PK                                          */
/*==============================================================*/
create unique index TIPOLIBRO_PK on TIPOLIBRO (
COD_TIPOLIBRO
);

/*==============================================================*/
/* Table: TIPOPRESTAMO                                          */
/*==============================================================*/
create table TIPOPRESTAMO (
   COD_TIPOPRESTAMO     INT4                 not null,
   TIPOPRESTAMO         VARCHAR(50)          null,
   constraint PK_TIPOPRESTAMO primary key (COD_TIPOPRESTAMO)
);

/*==============================================================*/
/* Index: TIPOPRESTAMO_PK                                       */
/*==============================================================*/
create unique index TIPOPRESTAMO_PK on TIPOPRESTAMO (
COD_TIPOPRESTAMO
);

/*==============================================================*/
/* Table: USUARIO                                               */
/*==============================================================*/
create table USUARIO (
   COD_USUARIO          INT4                 not null,
   NOMBRE_USUARIO       CHAR(50)             not null,
   APELLIDO             VARCHAR(50)          null,
   DOCUMENTOID          INT8                 not null,
   FECHA_NACIMIENTO     VARCHAR(50)          null,
   TELEFONO             NUMERIC(11)          null,
   DIRECCION            VARCHAR(50)          null,
   CORREO               VARCHAR(100)         null,
   constraint PK_USUARIO primary key (COD_USUARIO)
);

/*==============================================================*/
/* Index: USUARIO_PK                                            */
/*==============================================================*/
create unique index USUARIO_PK on USUARIO (
COD_USUARIO
);

alter table LIBRO
   add constraint FK_LIBRO_LIBRO_PAI_PAIS foreign key (COD_PAIS)
      references PAIS (COD_PAIS)
      on delete restrict on update restrict;

alter table LIBRO
   add constraint FK_LIBRO_LIBRO_TIP_TIPOLIBR foreign key (COD_TIPOLIBRO)
      references TIPOLIBRO (COD_TIPOLIBRO)
      on delete restrict on update restrict;

alter table LIBROSPOREXISTENCIA
   add constraint FK_LIBROSPO_RELACION_LIBRO foreign key (COD_LIBRO)
      references LIBRO (COD_LIBRO)
      on delete restrict on update restrict;

alter table LIBROSPOREXISTENCIA_ESTADO
   add constraint FK_LIBROSPO_LIBROSPOR_ESTADO foreign key (COD_ESTADO)
      references ESTADO (COD_ESTADO)
      on delete restrict on update restrict;

alter table LIBROSPOREXISTENCIA_ESTADO
   add constraint FK_LIBROSPO_LIBROSPOR_LIBROSPO foreign key (COD_EXISTENCIA)
      references LIBROSPOREXISTENCIA (COD_EXISTENCIA)
      on delete restrict on update restrict;

alter table LIBRO_AREA
   add constraint FK_LIBRO_AR_CONTIENE_LIBRO foreign key (COD_LIBRO)
      references LIBRO (COD_LIBRO)
      on delete restrict on update restrict;

alter table LIBRO_AREA
   add constraint FK_LIBRO_AR_CONTIENE2_AREA foreign key (COD_AREA)
      references AREA (COD_AREA)
      on delete restrict on update restrict;

alter table LIBRO_AUTOR
   add constraint FK_LIBRO_AU_LIBRO_AUT_AUTOR foreign key (COD_AUTOR)
      references AUTOR (COD_AUTOR)
      on delete restrict on update restrict;

alter table LIBRO_AUTOR
   add constraint FK_LIBRO_AU_LIBRO_AUT_LIBRO foreign key (COD_LIBRO)
      references LIBRO (COD_LIBRO)
      on delete restrict on update restrict;

alter table PRESTAMO
   add constraint FK_PRESTAMO_LIBROSPOR_LIBROSPO foreign key (COD_EXISTENCIA)
      references LIBROSPOREXISTENCIA (COD_EXISTENCIA)
      on delete restrict on update restrict;

alter table PRESTAMO
   add constraint FK_PRESTAMO_PRESTAMO__USUARIO foreign key (COD_USUARIO)
      references USUARIO (COD_USUARIO)
      on delete restrict on update restrict;

alter table PRESTAMO
   add constraint FK_PRESTAMO_PRESTAMO__TIPOPRES foreign key (COD_TIPOPRESTAMO)
      references TIPOPRESTAMO (COD_TIPOPRESTAMO)
      on delete restrict on update restrict;


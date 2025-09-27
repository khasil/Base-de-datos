/*==============================================================*/
/* DBMS name:      PostgreSQL 8                                 */
/* Created on:     26/09/2025 10:11:21 p. m.                    */
/*==============================================================*/


drop index idx_asiento_sala;

drop table cine.asiento;

drop table cine.clasificacion;

drop index idx_cliente_tipo_doc;

drop table cine.cliente;

drop table cine.descuento;

drop index idx_entrada_venta;

drop index idx_entrada_asiento;

drop index idx_entrada_funcion;

drop table cine.entrada;

drop index idx_funcion_sala;

drop index idx_funcion_pelicula;

drop table cine.funcion;

drop index idx_fd_descuento;

drop index idx_fd_funcion;

drop table cine.funcion_descuento;

drop table cine.genero;

drop table cine.metodo_pago;

drop index idx_pelicula_clasificacion;

drop table cine.pelicula;

drop index idx_pg_genero;

drop index idx_pg_pelicula;

drop table cine.pelicula_genero;

drop index idx_reserva_funcion;

drop index idx_reserva_cliente;

drop table cine.reserva;

drop index idx_sala_tipo;

drop table cine.sala;

drop table cine.tipo_documento;

drop table cine.tipo_sala;

drop index idx_venta_descuento;

drop index idx_venta_cliente;

drop table cine.venta;

drop index idx_vp_metodo;

drop index idx_vp_venta;

drop table cine.venta_pago;

drop sequence seq_asiento;

drop sequence seq_clasificacion;

drop sequence seq_cliente;

drop sequence seq_descuento;

drop sequence seq_entrada;

drop sequence seq_funcion;

drop sequence seq_funcion_descuento;

drop sequence seq_genero;

drop sequence seq_metodo_pago;

drop sequence seq_pelicula;

drop sequence seq_reserva;

drop sequence seq_sala;

drop sequence seq_tipo_documento;

drop sequence seq_tipo_sala;

drop sequence seq_venta;

drop sequence seq_venta_pago;

drop schema cine;

/*==============================================================*/
/* User: cine                                                   */
/*==============================================================*/
create schema cine;

create sequence seq_asiento
START 1;

create sequence seq_clasificacion
START 1;

create sequence seq_cliente
START 1;

create sequence seq_descuento
START 1;

create sequence seq_entrada
START 1;

create sequence seq_funcion
START 1;

create sequence seq_funcion_descuento
START 1;

create sequence seq_genero
START 1;

create sequence seq_metodo_pago
START 1;

create sequence seq_pelicula
START 1;

create sequence seq_reserva
START 1;

create sequence seq_sala
START 1;

create sequence seq_tipo_documento
START 1;

create sequence seq_tipo_sala
START 1;

create sequence seq_venta
START 1;

create sequence seq_venta_pago
START 1;

/*==============================================================*/
/* Table: asiento                                               */
/*==============================================================*/
create table cine.asiento (
   id_asiento           INTEGER              not null default nextval('seq_asiento'),
   id_sala              INTEGER              not null,
   fila                 CHAR(1)              not null,
   numero               INT                  not null,
   constraint PK_ASIENTO primary key (id_asiento),
   constraint uq_asiento unique (id_sala, fila, numero)
);

/*==============================================================*/
/* Index: idx_asiento_sala                                      */
/*==============================================================*/
create  index idx_asiento_sala on asiento (
id_sala
);

/*==============================================================*/
/* Table: clasificacion                                         */
/*==============================================================*/
create table cine.clasificacion (
   id_clasificacion     INTEGER              not null default nextval('seq_clasificacion'),
   codigo               VARCHAR(10)          not null,
   descripcion          VARCHAR(100)         not null,
   constraint PK_CLASIFICACION primary key (id_clasificacion),
   constraint AK_KEY_2_CLASIFIC unique (codigo)
);

/*==============================================================*/
/* Table: cliente                                               */
/*==============================================================*/
create table cine.cliente (
   id_cliente           INTEGER              not null default nextval('seq_cliente'),
   primer_nombre        VARCHAR(50)          not null,
   segundo_nombre       VARCHAR(50)          null,
   primer_apellido      VARCHAR(50)          not null,
   segundo_apellido     VARCHAR(50)          null,
   id_tipo_documento    INTEGER              not null,
   numero_documento     VARCHAR(30)          not null,
   correo               VARCHAR(100)         not null,
   telefono             VARCHAR(20)          null,
   fecha_registro       TIMESTAMP            not null default now(),
   constraint PK_CLIENTE primary key (id_cliente),
   constraint AK_KEY_2_CLIENTE unique (numero_documento),
   constraint AK_KEY_3_CLIENTE unique (correo)
);

/*==============================================================*/
/* Index: idx_cliente_tipo_doc                                  */
/*==============================================================*/
create  index idx_cliente_tipo_doc on cliente (
id_tipo_documento
);

/*==============================================================*/
/* Table: descuento                                             */
/*==============================================================*/
create table cine.descuento (
   id_descuento         INTEGER              not null default nextval('seq_descuento'),
   nombre               VARCHAR(50)          not null,
   porcentaje           DECIMAL(5,2)         not null,
   dia_semana           INT                  null
      constraint CKC_DIA_SEMANA_DESCUENT check (dia_semana is null or (dia_semana between '0' and '6')),
   descripcion          VARCHAR(100)         null,
   constraint PK_DESCUENTO primary key (id_descuento)
);

/*==============================================================*/
/* Table: entrada                                               */
/*==============================================================*/
create table cine.entrada (
   id_entrada           INTEGER              not null default nextval('seq_entrada'),
   id_funcion           INTEGER              not null,
   id_asiento           INTEGER              not null,
   id_venta             INTEGER              not null,
   precio               DECIMAL(10,2)        not null,
   constraint PK_ENTRADA primary key (id_entrada),
   constraint uq_entrada unique (id_funcion, id_asiento)
);

/*==============================================================*/
/* Index: idx_entrada_funcion                                   */
/*==============================================================*/
create  index idx_entrada_funcion on entrada (
id_funcion
);

/*==============================================================*/
/* Index: idx_entrada_asiento                                   */
/*==============================================================*/
create  index idx_entrada_asiento on entrada (
id_asiento
);

/*==============================================================*/
/* Index: idx_entrada_venta                                     */
/*==============================================================*/
create  index idx_entrada_venta on entrada (
id_venta
);

/*==============================================================*/
/* Table: funcion                                               */
/*==============================================================*/
create table cine.funcion (
   id_funcion           INTEGER              not null default nextval('seq_funcion'),
   id_pelicula          INTEGER              not null,
   id_sala              INTEGER              not null,
   fecha                DATE                 not null,
   hora                 TIME                 not null,
   precio_base          DECIMAL(10,2)        not null,
   constraint PK_FUNCION primary key (id_funcion)
);

/*==============================================================*/
/* Index: idx_funcion_pelicula                                  */
/*==============================================================*/
create  index idx_funcion_pelicula on funcion (
id_pelicula
);

/*==============================================================*/
/* Index: idx_funcion_sala                                      */
/*==============================================================*/
create  index idx_funcion_sala on funcion (
id_sala
);

/*==============================================================*/
/* Table: funcion_descuento                                     */
/*==============================================================*/
create table cine.funcion_descuento (
   id_funcion_descuento INTEGER              not null default nextval('seq_funcion_descuento'),
   id_funcion           INTEGER              not null,
   id_descuento         INTEGER              not null,
   constraint PK_FUNCION_DESCUENTO primary key (id_funcion_descuento)
);

/*==============================================================*/
/* Index: idx_fd_funcion                                        */
/*==============================================================*/
create  index idx_fd_funcion on funcion_descuento (
id_funcion
);

/*==============================================================*/
/* Index: idx_fd_descuento                                      */
/*==============================================================*/
create  index idx_fd_descuento on funcion_descuento (
id_descuento
);

/*==============================================================*/
/* Table: genero                                                */
/*==============================================================*/
create table cine.genero (
   id_genero            INTEGER              not null default nextval('seq_genero'),
   nombre               VARCHAR(50)          not null,
   constraint PK_GENERO primary key (id_genero),
   constraint AK_KEY_2_GENERO unique (nombre)
);

/*==============================================================*/
/* Table: metodo_pago                                           */
/*==============================================================*/
create table cine.metodo_pago (
   id_metodo            INTEGER              not null default nextval('seq_metodo_pago'),
   nombre               VARCHAR(50)          not null,
   descripcion          VARCHAR(100)         null,
   constraint PK_METODO_PAGO primary key (id_metodo),
   constraint AK_KEY_2_METODO_P unique (nombre)
);

/*==============================================================*/
/* Table: pelicula                                              */
/*==============================================================*/
create table cine.pelicula (
   id_pelicula          INTEGER              not null default nextval('seq_pelicula'),
   titulo               VARCHAR(100)         not null,
   duracion_min         INT                  not null,
   idioma               VARCHAR(50)          not null,
   subtitulos           BOOLEAN              null,
   id_clasificacion     INTEGER              not null,
   fecha_estreno        DATE                 null,
   constraint PK_PELICULA primary key (id_pelicula)
);

/*==============================================================*/
/* Index: idx_pelicula_clasificacion                            */
/*==============================================================*/
create  index idx_pelicula_clasificacion on pelicula (
id_clasificacion
);

/*==============================================================*/
/* Table: pelicula_genero                                       */
/*==============================================================*/
create table cine.pelicula_genero (
   id_pelicula          INTEGER              not null,
   id_genero            INTEGER              not null,
   constraint PK_PELICULA_GENERO primary key (id_pelicula, id_genero)
);

/*==============================================================*/
/* Index: idx_pg_pelicula                                       */
/*==============================================================*/
create  index idx_pg_pelicula on pelicula_genero (
id_pelicula
);

/*==============================================================*/
/* Index: idx_pg_genero                                         */
/*==============================================================*/
create  index idx_pg_genero on pelicula_genero (
id_genero
);

/*==============================================================*/
/* Table: reserva                                               */
/*==============================================================*/
create table cine.reserva (
   id_reserva           INTEGER              not null default nextval('seq_reserva'),
   id_cliente           INTEGER              not null,
   id_funcion           INTEGER              not null,
   fecha_reserva        TIMESTAMP            not null default now(),
   estado               VARCHAR(20)          not null default 'pendiente',
   constraint PK_RESERVA primary key (id_reserva)
);

/*==============================================================*/
/* Index: idx_reserva_cliente                                   */
/*==============================================================*/
create  index idx_reserva_cliente on reserva (
id_cliente
);

/*==============================================================*/
/* Index: idx_reserva_funcion                                   */
/*==============================================================*/
create  index idx_reserva_funcion on reserva (
id_funcion
);

/*==============================================================*/
/* Table: sala                                                  */
/*==============================================================*/
create table cine.sala (
   id_sala              INTEGER              not null default nextval('seq_sala'),
   nombre               VARCHAR(50)          not null,
   capacidad            INT                  not null,
   id_tipo_sala         INTEGER              not null,
   constraint PK_SALA primary key (id_sala),
   constraint AK_KEY_2_SALA unique (nombre)
);

/*==============================================================*/
/* Index: idx_sala_tipo                                         */
/*==============================================================*/
create  index idx_sala_tipo on sala (
id_tipo_sala
);

/*==============================================================*/
/* Table: tipo_documento                                        */
/*==============================================================*/
create table cine.tipo_documento (
   id_tipo_documento    INTEGER              not null default nextval('seq_tipo_documento'),
   nombre               VARCHAR(50)          not null,
   descripcion          VARCHAR(100)         null,
   constraint PK_TIPO_DOCUMENTO primary key (id_tipo_documento)
);

/*==============================================================*/
/* Table: tipo_sala                                             */
/*==============================================================*/
create table cine.tipo_sala (
   id_tipo_sala         INTEGER              not null default nextval('seq_tipo_sala'),
   nombre               VARCHAR(50)          not null,
   descripcion          VARCHAR(100)         null,
   constraint PK_TIPO_SALA primary key (id_tipo_sala)
);

/*==============================================================*/
/* Table: venta                                                 */
/*==============================================================*/
create table cine.venta (
   id_venta             INTEGER              not null default nextval('seq_venta'),
   id_cliente           INTEGER              not null,
   fecha                TIMESTAMP            not null default now(),
   total                DECIMAL(10,2)        not null,
   id_descuento         INTEGER              null,
   online               BOOLEAN              null,
   constraint PK_VENTA primary key (id_venta)
);

/*==============================================================*/
/* Index: idx_venta_cliente                                     */
/*==============================================================*/
create  index idx_venta_cliente on venta (
id_cliente
);

/*==============================================================*/
/* Index: idx_venta_descuento                                   */
/*==============================================================*/
create  index idx_venta_descuento on venta (
id_descuento
);

/*==============================================================*/
/* Table: venta_pago                                            */
/*==============================================================*/
create table cine.venta_pago (
   id_venta_pago        INTEGER              not null default nextval('seq_venta_pago'),
   id_venta             INTEGER              not null,
   id_metodo            INTEGER              not null,
   monto                DECIMAL(10,2)        not null,
   constraint PK_VENTA_PAGO primary key (id_venta_pago)
);

/*==============================================================*/
/* Index: idx_vp_venta                                          */
/*==============================================================*/
create  index idx_vp_venta on venta_pago (
id_venta
);

/*==============================================================*/
/* Index: idx_vp_metodo                                         */
/*==============================================================*/
create  index idx_vp_metodo on venta_pago (
id_metodo
);

alter table asiento
   add constraint fk_asiento_sala foreign key (id_sala)
      references sala (id_sala)
      on delete restrict on update restrict;

alter table cliente
   add constraint fk_cliente_tipo_doc foreign key (id_tipo_documento)
      references tipo_documento (id_tipo_documento)
      on delete restrict on update restrict;

alter table entrada
   add constraint fk_entrada_asiento foreign key (id_asiento)
      references asiento (id_asiento)
      on delete restrict on update restrict;

alter table entrada
   add constraint fk_entrada_funcion foreign key (id_funcion)
      references funcion (id_funcion)
      on delete restrict on update restrict;

alter table entrada
   add constraint fk_entrada_venta foreign key (id_venta)
      references venta (id_venta)
      on delete restrict on update restrict;

alter table funcion
   add constraint fk_funcion_pelicula foreign key (id_pelicula)
      references pelicula (id_pelicula)
      on delete restrict on update restrict;

alter table funcion
   add constraint fk_funcion_sala foreign key (id_sala)
      references sala (id_sala)
      on delete restrict on update restrict;

alter table funcion_descuento
   add constraint fk_fd_descuento foreign key (id_descuento)
      references descuento (id_descuento)
      on delete restrict on update restrict;

alter table funcion_descuento
   add constraint fk_fd_funcion foreign key (id_funcion)
      references funcion (id_funcion)
      on delete restrict on update restrict;

alter table pelicula
   add constraint fk_pelicula_clasificacion foreign key (id_clasificacion)
      references clasificacion (id_clasificacion)
      on delete restrict on update restrict;

alter table pelicula_genero
   add constraint fk_pg_genero foreign key (id_genero)
      references genero (id_genero)
      on delete restrict on update restrict;

alter table pelicula_genero
   add constraint fk_pg_pelicula foreign key (id_pelicula)
      references pelicula (id_pelicula)
      on delete restrict on update restrict;

alter table reserva
   add constraint fk_reserva_cliente foreign key (id_cliente)
      references cliente (id_cliente)
      on delete restrict on update restrict;

alter table reserva
   add constraint fk_reserva_funcion foreign key (id_funcion)
      references funcion (id_funcion)
      on delete restrict on update restrict;

alter table sala
   add constraint fk_sala_tipo foreign key (id_tipo_sala)
      references tipo_sala (id_tipo_sala)
      on delete restrict on update restrict;

alter table venta
   add constraint fk_venta_cliente foreign key (id_cliente)
      references cliente (id_cliente)
      on delete restrict on update restrict;

alter table venta
   add constraint fk_venta_descuento foreign key (id_descuento)
      references descuento (id_descuento)
      on delete restrict on update restrict;

alter table venta_pago
   add constraint fk_vp_metodo foreign key (id_metodo)
      references metodo_pago (id_metodo)
      on delete restrict on update restrict;

alter table venta_pago
   add constraint fk_vp_venta foreign key (id_venta)
      references venta (id_venta)
      on delete restrict on update restrict;


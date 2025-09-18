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

--Insertar en editorial
INSERT INTO editorial VALUES (1, 'Planeta',NULL, '1234567');
INSERT INTO editorial VALUES (2, 'Penguin Random House',NULL, '9876543');
INSERT INTO editorial VALUES (3, 'HarperCollins',NULL, '4567890');
INSERT INTO editorial VALUES (4, 'Santillana',NULL, '1122334');
INSERT INTO editorial VALUES (5, 'McGraw-Hill',NULL, '9988776');

--Insertar en tala tipo de libro para diferenciarlos
INSERT INTO tipolibro VALUES (1, 'Novela');
INSERT INTO tipolibro VALUES (2, 'Ensayo');
INSERT INTO tipolibro VALUES (3, 'Ciencia');
INSERT INTO tipolibro VALUES (4, 'Historia');
INSERT INTO tipolibro VALUES (5, 'Educativo');

--Insertar en tabla Pais
INSERT INTO pais VALUES (1, 'España');
INSERT INTO pais VALUES (2, 'Estados Unidos');
INSERT INTO pais VALUES (3, 'México');
INSERT INTO pais VALUES (4, 'Argentina');
INSERT INTO pais VALUES (5, 'Colombia');

--Insertar en tabla Area
INSERT INTO area VALUES (1, 'Literatura');
INSERT INTO area VALUES (2, 'Ingeniería');
INSERT INTO area VALUES (3, 'Medicina');
INSERT INTO area VALUES (4, 'Matemáticas');
INSERT INTO area VALUES (5, 'Ciencias Sociales');

--insertar en tabla autor
INSERT INTO autor VALUES (1, 'Gabriel García Márquez', 'Colombiana', 1927);
INSERT INTO autor VALUES (2, 'J.K. Rowling', 'Británica', 1965);
INSERT INTO autor VALUES (3, 'Stephen Hawking', 'Británica', 1942);
INSERT INTO autor VALUES (4, 'Isabel Allende', 'Chilena', 1942);
INSERT INTO autor VALUES (5, 'Yuval Noah Harari', 'Israelí', 1976);

--insertar en tabla Libro
INSERT INTO libro (cod_libro, cod_pais, cod_tipolibro, isbn, titulo, fechapublicacion, edicion)
VALUES
(1, 1, 1, '978-84-376-0494-7', 'Cien Años de Soledad', '1967-05-30', 'Primera'),
(2, 2, 2, '978-0-7432-7356-5', 'El Código Da Vinci', '2003-03-18', 'Segunda'),
(3, 1, 3, '978-84-9759-260-5', 'La Sombra del Viento', '2001-06-06', 'Primera'),
(4, 3, 1, '978-1-56619-909-4', 'Don Quijote de la Mancha', '1605-01-16', 'Edición Conmemorativa'),
(5, 4, 4, '978-0-452-28423-4', '1984', '1949-06-08', 'Primera');

--Insertar en Libros por existencia
INSERT INTO librosporExistencia VALUES (1, 1, 'INV001', 'Sala General - Estante A - Nivel 1', '2015-03-10');
INSERT INTO librosporExistencia VALUES (2, 2, 'INV002', 'Sala Infantil - Estante B - Nivel 2', '2016-05-12');
INSERT INTO librosporExistencia VALUES (3, 3, 'INV003', 'Hemeroteca - Estante C - Nivel 1', '2018-07-23');
INSERT INTO librosporExistencia VALUES (4, 4, 'INV004', 'Sala Investigación - Estante D - Nivel 3', '2019-02-15');
INSERT INTO librosporExistencia VALUES (5, 5, 'INV005', 'Sala General - Estante A - Nivel 2', '2020-11-05');

--Insertar en Estado
INSERT INTO estado VALUES (1, 'Disponible');
INSERT INTO estado VALUES (2, 'Prestado');
INSERT INTO estado VALUES (3, 'Dañado');
INSERT INTO estado VALUES (4, 'Extraviado');
INSERT INTO estado VALUES (5, 'En reparación');

--Insertar en librosporExistencia_estado  Vincula cada ejemplar con su estado actual
INSERT INTO librosporExistencia_estado VALUES (1, 1);
INSERT INTO librosporExistencia_estado VALUES (2, 2);
INSERT INTO librosporExistencia_estado VALUES (3, 1);
INSERT INTO librosporExistencia_estado VALUES (4, 3);
INSERT INTO librosporExistencia_estado VALUES (5, 1);

--Insertar en usuario
INSERT INTO usuario VALUES (1, 'Carlos', 'Pérez', '12345678', '1990-04-10', 3001234567, 'Calle 10 #20-30', 'carlos@mail.com');
INSERT INTO usuario VALUES (2, 'María', 'Gómez', '87654321', '1985-07-21', 3107654321, 'Carrera 15 #45-67', 'maria@mail.com');
INSERT INTO usuario VALUES (3, 'Juan', 'Rodríguez', '11223344', '2000-01-15', 3159876543, 'Av. 30 #12-05', 'juan@mail.com');
INSERT INTO usuario VALUES (4, 'Laura', 'Martínez', '99887766', '1995-09-30', 3011122233, 'Calle 50 #22-11', 'laura@mail.com');
INSERT INTO usuario VALUES (5, 'Andrés', 'Ramírez', '55667788', '1992-06-18', 3023344556, 'Calle 80 #100-22', 'andres@mail.com');

--Insertar TipoPrestamo
INSERT INTO tipoprestamo VALUES (1, 'En sala');
INSERT INTO tipoprestamo VALUES (2, 'A domicilio');
INSERT INTO tipoprestamo VALUES (3, 'Interbibliotecario');
INSERT INTO tipoprestamo VALUES (4, 'Especial');
INSERT INTO tipoprestamo VALUES (5, 'Digital');

--Insertar en prestamo
INSERT INTO prestamo (cod_prestamo, cod_existencia, cod_usuario, cod_tipoprestamo, fecha_prestamo, hora_prestamo, fecha_entrega, hora_entrega)
VALUES
(1, 1, 1, 2, '2023-10-01', '10:30:00', '2023-10-10', '11:00:00'),
(2, 2, 2, 1, '2023-11-05', '14:00:00', '2023-11-15', '13:00:00'),
(3, 3, 3, 2, '2023-12-20', '09:15:00', '2023-12-27', '16:00:00'),
(4, 4, 4, 1, '2024-01-10', '11:45:00', '2024-01-20', '12:30:00'),
(5, 5, 5, 2, '2024-02-18', '08:20:00', '2024-02-25', '10:00:00');


SELECT 
    p.cod_prestamo,
    l.titulo,
    l.isbn,
    l.fechapublicacion,
    le.cod_inventario,
    le.ubicacion,
    u.nombre_usuario,
    u.apellido,
    tp.tipoprestamo AS tipo_prestamo,
    p.fecha_prestamo,
    p.hora_prestamo,
    p.fecha_entrega,
    p.hora_entrega
FROM prestamo p
JOIN librosporExistencia le 
     ON p.cod_existencia = le.cod_existencia
JOIN libro l 
     ON le.cod_libro = l.cod_libro
JOIN usuario u 
     ON p.cod_usuario = u.cod_usuario
JOIN tipoprestamo tp 
     ON p.cod_tipoprestamo = tp.cod_tipoprestamo;

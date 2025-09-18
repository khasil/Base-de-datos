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
   ESTADO_LIBRO         VARCHAR(10)          null,
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
   COD_EDITORIAL        VARCHAR(4)           null,
   ISBN                 VARCHAR(50)          null,
   TITULO               VARCHAR(100)         null,
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
/* Table: LIBROS_AREA                                           */
/*==============================================================*/
create table LIBROS_AREA (
   COD_LIBRO            INT4                 not null,
   COD_AREA             INT4                 not null,
   constraint PK_LIBROS_AREA primary key (COD_LIBRO, COD_AREA)
);

/*==============================================================*/
/* Index: LIBROS_AREA_PK                                        */
/*==============================================================*/
create unique index LIBROS_AREA_PK on LIBROS_AREA (
COD_LIBRO,
COD_AREA
);

/*==============================================================*/
/* Index: CONTIENE2_FK                                          */
/*==============================================================*/
create  index CONTIENE2_FK on LIBROS_AREA (
COD_AREA
);

/*==============================================================*/
/* Index: CONTIENE_FK                                           */
/*==============================================================*/
create  index CONTIENE_FK on LIBROS_AREA (
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
/* Table: MULTA                                                 */
/*==============================================================*/
create table MULTA (
   COD_MULTA            INT4                 not null,
   COD_PRESTAMO         INT4                 null,
   MONTO                DECIMAL(10,2)        not null,
   FECHA_ASIGNACION     DATE                 not null,
   DIAS_MORA            INT4                 null,
   FECHA_PAGO           DATE                 null,
   ESTADO_MULTA         VARCHAR(20)          null,
   constraint PK_MULTA primary key (COD_MULTA)
);

/*==============================================================*/
/* Index: MULTA_PK                                              */
/*==============================================================*/
create unique index MULTA_PK on MULTA (
COD_MULTA
);

/*==============================================================*/
/* Index: GENERA_FK                                             */
/*==============================================================*/
create  index GENERA_FK on MULTA (
COD_PRESTAMO
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
   FECHA_DEVOLUCION     DATE                 null,
   HORA_DEVOLUCION      TIME                 null,
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
   DOCUMENTOID          VARCHAR(20)          not null,
   FECHA_NACIMIENTO     DATE                 null,
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

alter table LIBRO
   add constraint FK_LIBRO_PUBLICA_EDITORIA foreign key (COD_EDITORIAL)
      references EDITORIAL (COD_EDITORIAL)
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

alter table LIBROS_AREA
   add constraint FK_LIBROS_A_CONTIENE_LIBRO foreign key (COD_LIBRO)
      references LIBRO (COD_LIBRO)
      on delete restrict on update restrict;

alter table LIBROS_AREA
   add constraint FK_LIBROS_A_CONTIENE2_AREA foreign key (COD_AREA)
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

alter table MULTA
   add constraint FK_MULTA_GENERA_PRESTAMO foreign key (COD_PRESTAMO)
      references PRESTAMO (COD_PRESTAMO)
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

-- Insertar en EDITORIAL Representa las editoriales que publican títulos de libros, incluyendo su nombre, dirección y contacto para rastreo de publicaciones.
INSERT INTO EDITORIAL (COD_EDITORIAL, NOMBRE_EDITORIAL, DIRECCION_EDITORIAL, TELEFONO_EDITORIAL) VALUES ('ED01', 'Planeta', 'Barcelona, España', 934123456);
INSERT INTO EDITORIAL (COD_EDITORIAL, NOMBRE_EDITORIAL, DIRECCION_EDITORIAL, TELEFONO_EDITORIAL) VALUES ('ED02', 'Penguin Random House', 'New York, USA', 2127829000);
INSERT INTO EDITORIAL (COD_EDITORIAL, NOMBRE_EDITORIAL, DIRECCION_EDITORIAL, TELEFONO_EDITORIAL) VALUES ('ED03', 'HarperCollins', 'London, UK', 2078302222);
INSERT INTO EDITORIAL (COD_EDITORIAL, NOMBRE_EDITORIAL, DIRECCION_EDITORIAL, TELEFONO_EDITORIAL) VALUES ('ED04', 'Santillana', 'Madrid, España', 913876543);
INSERT INTO EDITORIAL (COD_EDITORIAL, NOMBRE_EDITORIAL, DIRECCION_EDITORIAL, TELEFONO_EDITORIAL) VALUES ('ED05', 'McGraw-Hill', 'Chicago, USA', 3126611000);

-- Insertar en TIPOLIBRO Representa los tipos o géneros de libros, como novela o ensayo, para clasificar los títulos según su categoría.
INSERT INTO TIPOLIBRO (COD_TIPOLIBRO, TIPO) VALUES (1, 'Novela');
INSERT INTO TIPOLIBRO (COD_TIPOLIBRO, TIPO) VALUES (2, 'Ensayo');
INSERT INTO TIPOLIBRO (COD_TIPOLIBRO, TIPO) VALUES (3, 'Ciencia Ficción');
INSERT INTO TIPOLIBRO (COD_TIPOLIBRO, TIPO) VALUES (4, 'Historia');
INSERT INTO TIPOLIBRO (COD_TIPOLIBRO, TIPO) VALUES (5, 'Educativo');

-- Insertar en PAIS Representa los países de origen o publicación, utilizados para asociar nacionalidades o ubicaciones geográficas de autores y libros.
INSERT INTO PAIS (COD_PAIS, NOMBRE_PAIS) VALUES (1, 'España');
INSERT INTO PAIS (COD_PAIS, NOMBRE_PAIS) VALUES (2, 'Estados Unidos');
INSERT INTO PAIS (COD_PAIS, NOMBRE_PAIS) VALUES (3, 'México');
INSERT INTO PAIS (COD_PAIS, NOMBRE_PAIS) VALUES (4, 'Argentina');
INSERT INTO PAIS (COD_PAIS, NOMBRE_PAIS) VALUES (5, 'Colombia');
 
-- Insertar en AREA Representa las áreas temáticas o secciones de la biblioteca, como literatura o ingeniería, para organizar libros por contenido.
INSERT INTO AREA (COD_AREA, NOMBRE_AREA) VALUES (1, 'Literatura');
INSERT INTO AREA (COD_AREA, NOMBRE_AREA) VALUES (2, 'Ingeniería');
INSERT INTO AREA (COD_AREA, NOMBRE_AREA) VALUES (3, 'Medicina');
INSERT INTO AREA (COD_AREA, NOMBRE_AREA) VALUES (4, 'Matemáticas');
INSERT INTO AREA (COD_AREA, NOMBRE_AREA) VALUES (5, 'Ciencias Sociales');

-- Insertar en AUTOR Representa los autores de los libros, con detalles como nombre, nacionalidad y año de nacimiento para atribución creativa.
INSERT INTO AUTOR (COD_AUTOR, NOMBRE_AUTOR, NACIONALIDAD, ANIO_NACIMIENTO) VALUES (1, 'Gabriel García Márquez', 'Colombiana', 1927);
INSERT INTO AUTOR (COD_AUTOR, NOMBRE_AUTOR, NACIONALIDAD, ANIO_NACIMIENTO) VALUES (2, 'J.K. Rowling', 'Británica', 1965);
INSERT INTO AUTOR (COD_AUTOR, NOMBRE_AUTOR, NACIONALIDAD, ANIO_NACIMIENTO) VALUES (3, 'Stephen Hawking', 'Británica', 1942);
INSERT INTO AUTOR (COD_AUTOR, NOMBRE_AUTOR, NACIONALIDAD, ANIO_NACIMIENTO) VALUES (4, 'Isabel Allende', 'Chilena', 1942);
INSERT INTO AUTOR (COD_AUTOR, NOMBRE_AUTOR, NACIONALIDAD, ANIO_NACIMIENTO) VALUES (5, 'Yuval Noah Harari', 'Israelí', 1976);

-- Insertar en LIBRO Representa los títulos de libros abstractos (no copias físicas), incluyendo ISBN, título y edición para catalogación general.
INSERT INTO LIBRO (COD_LIBRO, COD_PAIS, COD_TIPOLIBRO, COD_EDITORIAL, ISBN, TITULO, FECHAPUBLICACION, EDICION) VALUES (1, 5, 1, 'ED01', '978-84-376-0494-7', 'Cien Años de Soledad', '1967-05-30', 'Primera');
INSERT INTO LIBRO (COD_LIBRO, COD_PAIS, COD_TIPOLIBRO, COD_EDITORIAL, ISBN, TITULO, FECHAPUBLICACION, EDICION) VALUES (2, 2, 3, 'ED02', '978-0-307-27767-1', 'The Da Vinci Code', '2003-03-18', 'Primera');
INSERT INTO LIBRO (COD_LIBRO, COD_PAIS, COD_TIPOLIBRO, COD_EDITORIAL, ISBN, TITULO, FECHAPUBLICACION, EDICION) VALUES (3, 1, 1, 'ED03','978-84-08-04942-5', 'La Sombra del Viento', '2001-04-01', 'Primera');
INSERT INTO LIBRO (COD_LIBRO, COD_PAIS, COD_TIPOLIBRO, COD_EDITORIAL, ISBN, TITULO, FECHAPUBLICACION, EDICION) VALUES (4, 1, 4, 'ED04', '978-84-89618-02-2', 'Don Quijote de la Mancha', '1605-01-16', 'Clásica');
INSERT INTO LIBRO (COD_LIBRO, COD_PAIS, COD_TIPOLIBRO, COD_EDITORIAL, ISBN, TITULO, FECHAPUBLICACION, EDICION) VALUES (5, 2, 3, 'ED05', '978-0-452-28423-4', '1984', '1949-06-08', 'Primera');

-- Insertar en LIBROSPOREXISTENCIA Representa las copias físicas o inventario de libros disponibles, con códigos de inventario y ubicaciones para gestión de stock.
INSERT INTO LIBROSPOREXISTENCIA (COD_EXISTENCIA, COD_LIBRO, COD_INVENTARIO, UBICACION, FECHA_ADQUISICION) VALUES (1, 1, 'INV001', 'Sala General - Estante A', '2015-03-10');
INSERT INTO LIBROSPOREXISTENCIA (COD_EXISTENCIA, COD_LIBRO, COD_INVENTARIO, UBICACION, FECHA_ADQUISICION) VALUES (2, 2, 'INV002', 'Sala Infantil - Estante B', '2016-05-12');
INSERT INTO LIBROSPOREXISTENCIA (COD_EXISTENCIA, COD_LIBRO, COD_INVENTARIO, UBICACION, FECHA_ADQUISICION) VALUES (3, 3, 'INV003', 'Hemeroteca - Estante C', '2018-07-23');
INSERT INTO LIBROSPOREXISTENCIA (COD_EXISTENCIA, COD_LIBRO, COD_INVENTARIO, UBICACION, FECHA_ADQUISICION) VALUES (4, 4, 'INV004', 'Sala Investigación - Estante D', '2019-02-15');
INSERT INTO LIBROSPOREXISTENCIA (COD_EXISTENCIA, COD_LIBRO, COD_INVENTARIO, UBICACION, FECHA_ADQUISICION) VALUES (5, 5, 'INV005', 'Sala General - Estante E', '2020-11-05');

-- Insertar en ESTADO Representa los estados posibles de las copias de libros, como disponible o prestado, para rastrear su condición actual.
INSERT INTO ESTADO (COD_ESTADO, ESTADO_LIBRO) VALUES (1, 'Disponible');
INSERT INTO ESTADO (COD_ESTADO, ESTADO_LIBRO) VALUES (2, 'Prestado');
INSERT INTO ESTADO (COD_ESTADO, ESTADO_LIBRO) VALUES (3, 'Dañado');
INSERT INTO ESTADO (COD_ESTADO, ESTADO_LIBRO) VALUES (4, 'Extraviado');
INSERT INTO ESTADO (COD_ESTADO, ESTADO_LIBRO) VALUES (5, 'reparación');

-- Insertar en LIBROSPOREXISTENCIA_ESTADO Representa la asociación entre copias de libros y sus estados, vinculando inventario con condiciones específicas.
INSERT INTO LIBROSPOREXISTENCIA_ESTADO (COD_ESTADO, COD_EXISTENCIA) VALUES (1, 1);
INSERT INTO LIBROSPOREXISTENCIA_ESTADO (COD_ESTADO, COD_EXISTENCIA) VALUES (2, 2);
INSERT INTO LIBROSPOREXISTENCIA_ESTADO (COD_ESTADO, COD_EXISTENCIA) VALUES (1, 3);
INSERT INTO LIBROSPOREXISTENCIA_ESTADO (COD_ESTADO, COD_EXISTENCIA) VALUES (3, 4);
INSERT INTO LIBROSPOREXISTENCIA_ESTADO (COD_ESTADO, COD_EXISTENCIA) VALUES (1, 5);

-- Insertar en USUARIO Representa los usuarios o miembros de la biblioteca, con datos personales como documento y contacto para gestión de cuentas.
INSERT INTO USUARIO (COD_USUARIO, NOMBRE_USUARIO, APELLIDO, DOCUMENTOID, FECHA_NACIMIENTO, TELEFONO, DIRECCION, CORREO) VALUES (1, 'Carlos', 'Pérez', '12345678', '1990-04-10', 3001234567, 'Calle 10 #20-30', 'carlos@mail.com');
INSERT INTO USUARIO (COD_USUARIO, NOMBRE_USUARIO, APELLIDO, DOCUMENTOID, FECHA_NACIMIENTO, TELEFONO, DIRECCION, CORREO) VALUES (2, 'María', 'Gómez', '87654321', '1985-07-21', 3107654321, 'Carrera 15 #45-67', 'maria@mail.com');
INSERT INTO USUARIO (COD_USUARIO, NOMBRE_USUARIO, APELLIDO, DOCUMENTOID, FECHA_NACIMIENTO, TELEFONO, DIRECCION, CORREO) VALUES (3, 'Juan', 'Rodríguez', '11223344', '2000-01-15', 3159876543, 'Av. 30 #12-05', 'juan@mail.com');
INSERT INTO USUARIO (COD_USUARIO, NOMBRE_USUARIO, APELLIDO, DOCUMENTOID, FECHA_NACIMIENTO, TELEFONO, DIRECCION, CORREO) VALUES (4, 'Laura', 'Martínez', '99887766', '1995-09-30', 3011122233, 'Calle 50 #22-11', 'laura@mail.com');
INSERT INTO USUARIO (COD_USUARIO, NOMBRE_USUARIO, APELLIDO, DOCUMENTOID, FECHA_NACIMIENTO, TELEFONO, DIRECCION, CORREO) VALUES (5, 'Andrés', 'Ramírez', '55667788', '1992-06-18', 3023344556, 'Calle 80 #100-22', 'andres@mail.com');

-- Insertar en TIPOPRESTAMO Representa los tipos de préstamos, como en sala o a domicilio, para definir reglas de uso de los libros.
INSERT INTO TIPOPRESTAMO (COD_TIPOPRESTAMO, TIPOPRESTAMO) VALUES (1, 'En sala');
INSERT INTO TIPOPRESTAMO (COD_TIPOPRESTAMO, TIPOPRESTAMO) VALUES (2, 'A domicilio');
INSERT INTO TIPOPRESTAMO (COD_TIPOPRESTAMO, TIPOPRESTAMO) VALUES (3, 'Interbibliotecario');
INSERT INTO TIPOPRESTAMO (COD_TIPOPRESTAMO, TIPOPRESTAMO) VALUES (4, 'Especial');
INSERT INTO TIPOPRESTAMO (COD_TIPOPRESTAMO, TIPOPRESTAMO) VALUES (5, 'Digital');

-- Insertar en PRESTAMO Representa los registros de préstamos de libros a usuarios, incluyendo fechas y horas para rastreo de devoluciones.
INSERT INTO PRESTAMO (COD_PRESTAMO, COD_EXISTENCIA, COD_USUARIO, COD_TIPOPRESTAMO, FECHA_PRESTAMO, HORA_PRESTAMO, FECHA_DEVOLUCION, HORA_DEVOLUCION) VALUES (1, 1, 1, 2, '2023-10-01', '10:30:00', '2023-10-10', '11:00:00');
INSERT INTO PRESTAMO (COD_PRESTAMO, COD_EXISTENCIA, COD_USUARIO, COD_TIPOPRESTAMO, FECHA_PRESTAMO, HORA_PRESTAMO, FECHA_DEVOLUCION, HORA_DEVOLUCION) VALUES (2, 2, 2, 1, '2023-11-05', '14:00:00', '2023-11-15', '13:00:00');
INSERT INTO PRESTAMO (COD_PRESTAMO, COD_EXISTENCIA, COD_USUARIO, COD_TIPOPRESTAMO, FECHA_PRESTAMO, HORA_PRESTAMO, FECHA_DEVOLUCION, HORA_DEVOLUCION) VALUES (3, 3, 3, 2, '2023-12-20', '09:15:00', '2023-12-27', '16:00:00');
INSERT INTO PRESTAMO (COD_PRESTAMO, COD_EXISTENCIA, COD_USUARIO, COD_TIPOPRESTAMO, FECHA_PRESTAMO, HORA_PRESTAMO, FECHA_DEVOLUCION, HORA_DEVOLUCION) VALUES (4, 4, 4, 1, '2024-01-10', '11:45:00', '2024-01-20', '12:30:00');
INSERT INTO PRESTAMO (COD_PRESTAMO, COD_EXISTENCIA, COD_USUARIO, COD_TIPOPRESTAMO, FECHA_PRESTAMO, HORA_PRESTAMO, FECHA_DEVOLUCION, HORA_DEVOLUCION) VALUES (5, 5, 5, 2, '2024-02-18', '08:20:00', '2024-02-25', '10:00:00');

-- Insertar en LIBROS_AREA Representa la relación muchos-a-muchos entre libros y áreas temáticas, para clasificar títulos en múltiples categorías.
INSERT INTO LIBROS_AREA (COD_LIBRO, COD_AREA) VALUES (1, 1);
INSERT INTO LIBROS_AREA (COD_LIBRO, COD_AREA) VALUES (2, 2);
INSERT INTO LIBROS_AREA (COD_LIBRO, COD_AREA) VALUES (3, 3);
INSERT INTO LIBROS_AREA (COD_LIBRO, COD_AREA) VALUES (4, 4);
INSERT INTO LIBROS_AREA (COD_LIBRO, COD_AREA) VALUES (5, 5);

-- Insertar en LIBRO_AUTOR Representa la relación muchos-a-muchos entre libros y autores, permitiendo múltiples autores por título.
INSERT INTO LIBRO_AUTOR (COD_AUTOR, COD_LIBRO) VALUES (1, 1);
INSERT INTO LIBRO_AUTOR (COD_AUTOR, COD_LIBRO) VALUES (2, 2);
INSERT INTO LIBRO_AUTOR (COD_AUTOR, COD_LIBRO) VALUES (3, 3);
INSERT INTO LIBRO_AUTOR (COD_AUTOR, COD_LIBRO) VALUES (4, 4);
INSERT INTO LIBRO_AUTOR (COD_AUTOR, COD_LIBRO) VALUES (5, 5);

-- Insertar en MULTA Representa las multas por devoluciones tardías, asociadas a préstamos, con montos y estados para control financiero.
INSERT INTO MULTA (COD_MULTA, COD_PRESTAMO, MONTO, FECHA_ASIGNACION, DIAS_MORA, FECHA_PAGO, ESTADO_MULTA) VALUES (1, 1, 5.00, '2023-10-11', 1, NULL, 'Pendiente');
INSERT INTO MULTA (COD_MULTA, COD_PRESTAMO, MONTO, FECHA_ASIGNACION, DIAS_MORA, FECHA_PAGO, ESTADO_MULTA) VALUES (2, 2, 10.00, '2023-11-16', 1, '2023-11-20', 'Pagada');
INSERT INTO MULTA (COD_MULTA, COD_PRESTAMO, MONTO, FECHA_ASIGNACION, DIAS_MORA, FECHA_PAGO, ESTADO_MULTA) VALUES (3, 3, 15.00, '2023-12-28', 1, NULL, 'Pendiente');
INSERT INTO MULTA (COD_MULTA, COD_PRESTAMO, MONTO, FECHA_ASIGNACION, DIAS_MORA, FECHA_PAGO, ESTADO_MULTA) VALUES (4, 4, 20.00, '2024-01-21', 1, '2024-01-25', 'Pagada');
INSERT INTO MULTA (COD_MULTA, COD_PRESTAMO, MONTO, FECHA_ASIGNACION, DIAS_MORA, FECHA_PAGO, ESTADO_MULTA) VALUES (5, 5, 25.00, '2024-02-26', 1, NULL, 'Pendiente');

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
p.fecha_devolucion,
p.hora_devolucion
FROM prestamo p
JOIN librosporexistencia le
ON p.cod_existencia = le.cod_existencia
JOIN libro l
ON le.cod_libro = l.cod_libro
JOIN usuario u
ON p.cod_usuario = u.cod_usuario
JOIN tipoprestamo tp
ON p.cod_tipoprestamo = tp.cod_tipoprestamo;

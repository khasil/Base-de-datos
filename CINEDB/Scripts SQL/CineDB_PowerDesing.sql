/*==============================================================*/
/* DBMS name:      PostgreSQL 8                                 */
/* Created on:     26/09/2025 9:57:39�p.�m.                     */
/*==============================================================*/


drop index idx_asiento_sala;

drop table PUBLICO.asiento;

drop table PUBLICO.clasificacion;

drop index idx_cliente_tipo_doc;

drop table PUBLICO.cliente;

drop table PUBLICO.descuento;

drop index idx_entrada_venta;

drop index idx_entrada_asiento;

drop index idx_entrada_funcion;

drop table PUBLICO.entrada;

drop index idx_funcion_sala;

drop index idx_funcion_pelicula;

drop table PUBLICO.funcion;

drop index idx_fd_descuento;

drop index idx_fd_funcion;

drop table PUBLICO.funcion_descuento;

drop table PUBLICO.genero;

drop table PUBLICO.metodo_pago;

drop index idx_pelicula_clasificacion;

drop table PUBLICO.pelicula;

drop index idx_pg_genero;

drop index idx_pg_pelicula;

drop table PUBLICO.pelicula_genero;

drop index idx_reserva_funcion;

drop index idx_reserva_cliente;

drop table PUBLICO.reserva;

drop index idx_sala_tipo;

drop table PUBLICO.sala;

drop table PUBLICO.tipo_documento;

drop table PUBLICO.tipo_sala;

drop index idx_venta_descuento;

drop index idx_venta_cliente;

drop table PUBLICO.venta;

drop index idx_vp_metodo;

drop index idx_vp_venta;

drop table PUBLICO.venta_pago;

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

drop schema PUBLICO;

drop schema cine;



-- =============================================
-- CREACIÓN DEL ESQUEMA
-- =============================================
CREATE SCHEMA cine;
SET search_path TO cine;

-- =============================================
-- SECUENCIAS
-- =============================================
CREATE SEQUENCE seq_tipo_documento START 1;
CREATE SEQUENCE seq_cliente START 1;
CREATE SEQUENCE seq_genero START 1;
CREATE SEQUENCE seq_clasificacion START 1;
CREATE SEQUENCE seq_pelicula START 1;
CREATE SEQUENCE seq_sala START 1;
CREATE SEQUENCE seq_tipo_sala START 1;
CREATE SEQUENCE seq_asiento START 1;
CREATE SEQUENCE seq_funcion START 1;
CREATE SEQUENCE seq_descuento START 1;
CREATE SEQUENCE seq_funcion_descuento START 1;
CREATE SEQUENCE seq_reserva START 1;
CREATE SEQUENCE seq_entrada START 1;
CREATE SEQUENCE seq_venta START 1;
CREATE SEQUENCE seq_metodo_pago START 1;
CREATE SEQUENCE seq_venta_pago START 1;

-- =============================================
-- TABLAS MAESTRAS
-- =============================================

-- Tipo de Documento
CREATE TABLE tipo_documento (
    id_tipo_documento INTEGER PRIMARY KEY DEFAULT nextval('seq_tipo_documento'),
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(100)
);

-- Cliente
CREATE TABLE cliente (
    id_cliente INTEGER PRIMARY KEY DEFAULT nextval('seq_cliente'),
    primer_nombre VARCHAR(50) NOT NULL,
    segundo_nombre VARCHAR(50),
    primer_apellido VARCHAR(50) NOT NULL,
    segundo_apellido VARCHAR(50),
    id_tipo_documento INTEGER NOT NULL,
    numero_documento VARCHAR(30) NOT NULL UNIQUE,
    correo VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    fecha_registro TIMESTAMP NOT NULL DEFAULT now(),
    CONSTRAINT fk_cliente_tipo_doc FOREIGN KEY (id_tipo_documento)
        REFERENCES tipo_documento(id_tipo_documento)
);

-- Género
CREATE TABLE genero (
    id_genero INTEGER PRIMARY KEY DEFAULT nextval('seq_genero'),
    nombre VARCHAR(50) NOT NULL UNIQUE
);

-- Clasificación
CREATE TABLE clasificacion (
    id_clasificacion INTEGER PRIMARY KEY DEFAULT nextval('seq_clasificacion'),
    codigo VARCHAR(10) NOT NULL UNIQUE,
    descripcion VARCHAR(100) NOT NULL
);

-- Película
CREATE TABLE pelicula (
    id_pelicula INTEGER PRIMARY KEY DEFAULT nextval('seq_pelicula'),
    titulo VARCHAR(100) NOT NULL,
    duracion_min INT NOT NULL,
    idioma VARCHAR(50) NOT NULL,
    subtitulos BOOLEAN DEFAULT FALSE,
    id_clasificacion INTEGER NOT NULL,
    fecha_estreno DATE,
    CONSTRAINT fk_pelicula_clasificacion FOREIGN KEY (id_clasificacion)
        REFERENCES clasificacion(id_clasificacion)
);

-- Relación Película - Género (M:N)
CREATE TABLE pelicula_genero (
    id_pelicula INTEGER NOT NULL,
    id_genero INTEGER NOT NULL,
    PRIMARY KEY (id_pelicula, id_genero),
    CONSTRAINT fk_pg_pelicula FOREIGN KEY (id_pelicula)
        REFERENCES pelicula(id_pelicula),
    CONSTRAINT fk_pg_genero FOREIGN KEY (id_genero)
        REFERENCES genero(id_genero)
);

-- Tipo de Sala
CREATE TABLE tipo_sala (
    id_tipo_sala INTEGER PRIMARY KEY DEFAULT nextval('seq_tipo_sala'),
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(100)
);

-- Sala
CREATE TABLE sala (
    id_sala INTEGER PRIMARY KEY DEFAULT nextval('seq_sala'),
    nombre VARCHAR(50) NOT NULL UNIQUE,
    capacidad INT NOT NULL,
    id_tipo_sala INTEGER NOT NULL,
    CONSTRAINT fk_sala_tipo FOREIGN KEY (id_tipo_sala)
        REFERENCES tipo_sala(id_tipo_sala)
);

-- Asiento
CREATE TABLE asiento (
    id_asiento INTEGER PRIMARY KEY DEFAULT nextval('seq_asiento'),
    id_sala INTEGER NOT NULL,
    fila CHAR(1) NOT NULL,
    numero INT NOT NULL,
    CONSTRAINT uq_asiento UNIQUE (id_sala, fila, numero),
    CONSTRAINT fk_asiento_sala FOREIGN KEY (id_sala)
        REFERENCES sala(id_sala)
);

-- Función
CREATE TABLE funcion (
    id_funcion INTEGER PRIMARY KEY DEFAULT nextval('seq_funcion'),
    id_pelicula INTEGER NOT NULL,
    id_sala INTEGER NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    precio_base DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_funcion_pelicula FOREIGN KEY (id_pelicula)
        REFERENCES pelicula(id_pelicula),
    CONSTRAINT fk_funcion_sala FOREIGN KEY (id_sala)
        REFERENCES sala(id_sala)
);

-- Descuento
CREATE TABLE descuento (
    id_descuento INTEGER PRIMARY KEY DEFAULT nextval('seq_descuento'),
    nombre VARCHAR(50) NOT NULL,
    porcentaje DECIMAL(5,2) NOT NULL,
    dia_semana INT CHECK (dia_semana BETWEEN 0 AND 6), -- 0=domingo
    descripcion VARCHAR(100)
);

-- Relación Función - Descuento (M:N)
CREATE TABLE funcion_descuento (
    id_funcion_descuento INTEGER PRIMARY KEY DEFAULT nextval('seq_funcion_descuento'),
    id_funcion INTEGER NOT NULL,
    id_descuento INTEGER NOT NULL,
    CONSTRAINT fk_fd_funcion FOREIGN KEY (id_funcion)
        REFERENCES funcion(id_funcion),
    CONSTRAINT fk_fd_descuento FOREIGN KEY (id_descuento)
        REFERENCES descuento(id_descuento)
);

-- Reserva
CREATE TABLE reserva (
    id_reserva INTEGER PRIMARY KEY DEFAULT nextval('seq_reserva'),
    id_cliente INTEGER NOT NULL,
    id_funcion INTEGER NOT NULL,
    fecha_reserva TIMESTAMP NOT NULL DEFAULT now(),
    estado VARCHAR(20) NOT NULL DEFAULT 'pendiente',
    CONSTRAINT fk_reserva_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente),
    CONSTRAINT fk_reserva_funcion FOREIGN KEY (id_funcion)
        REFERENCES funcion(id_funcion)
);

-- Venta
CREATE TABLE venta (
    id_venta INTEGER PRIMARY KEY DEFAULT nextval('seq_venta'),
    id_cliente INTEGER NOT NULL,
    fecha TIMESTAMP NOT NULL DEFAULT now(),
    total DECIMAL(10,2) NOT NULL,
    id_descuento INTEGER,
    online BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_venta_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente),
    CONSTRAINT fk_venta_descuento FOREIGN KEY (id_descuento)
        REFERENCES descuento(id_descuento)
);

-- Entrada
CREATE TABLE entrada (
    id_entrada INTEGER PRIMARY KEY DEFAULT nextval('seq_entrada'),
    id_funcion INTEGER NOT NULL,
    id_asiento INTEGER NOT NULL,
    id_venta INTEGER NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    CONSTRAINT uq_entrada UNIQUE (id_funcion, id_asiento),
    CONSTRAINT fk_entrada_funcion FOREIGN KEY (id_funcion)
        REFERENCES funcion(id_funcion),
    CONSTRAINT fk_entrada_asiento FOREIGN KEY (id_asiento)
        REFERENCES asiento(id_asiento),
    CONSTRAINT fk_entrada_venta FOREIGN KEY (id_venta)
        REFERENCES venta(id_venta)
);

-- Método de Pago
CREATE TABLE metodo_pago (
    id_metodo INTEGER PRIMARY KEY DEFAULT nextval('seq_metodo_pago'),
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(100)
);

-- Relación Venta - Pago (1:N)
CREATE TABLE venta_pago (
    id_venta_pago INTEGER PRIMARY KEY DEFAULT nextval('seq_venta_pago'),
    id_venta INTEGER NOT NULL,
    id_metodo INTEGER NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_vp_venta FOREIGN KEY (id_venta)
        REFERENCES venta(id_venta),
    CONSTRAINT fk_vp_metodo FOREIGN KEY (id_metodo)
        REFERENCES metodo_pago(id_metodo)
);

-- =============================================
-- ÍNDICES PARA CLAVES FORÁNEAS
-- =============================================

CREATE INDEX idx_cliente_tipo_doc ON cliente(id_tipo_documento);
CREATE INDEX idx_pelicula_clasificacion ON pelicula(id_clasificacion);
CREATE INDEX idx_pg_pelicula ON pelicula_genero(id_pelicula);
CREATE INDEX idx_pg_genero ON pelicula_genero(id_genero);
CREATE INDEX idx_sala_tipo ON sala(id_tipo_sala);
CREATE INDEX idx_asiento_sala ON asiento(id_sala);
CREATE INDEX idx_funcion_pelicula ON funcion(id_pelicula);
CREATE INDEX idx_funcion_sala ON funcion(id_sala);
CREATE INDEX idx_fd_funcion ON funcion_descuento(id_funcion);
CREATE INDEX idx_fd_descuento ON funcion_descuento(id_descuento);
CREATE INDEX idx_venta_cliente ON venta(id_cliente);
CREATE INDEX idx_venta_descuento ON venta(id_descuento);
CREATE INDEX idx_reserva_cliente ON reserva(id_cliente);
CREATE INDEX idx_reserva_funcion ON reserva(id_funcion);
CREATE INDEX idx_entrada_funcion ON entrada(id_funcion);
CREATE INDEX idx_entrada_asiento ON entrada(id_asiento);
CREATE INDEX idx_entrada_venta ON entrada(id_venta);
CREATE INDEX idx_vp_venta ON venta_pago(id_venta);
CREATE INDEX idx_vp_metodo ON venta_pago(id_metodo);

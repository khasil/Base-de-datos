-- ==========================================
--   BASE DE DATOS: Tienda Virtual
--   Versión en español - PostgreSQL
-- ==========================================

-- =======================
--  CREACIÓN DE TABLAS
-- =======================

CREATE TABLE categoria (
    id_categoria SERIAL PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL,
    descripcion TEXT
);

CREATE TABLE producto (
    id_producto SERIAL PRIMARY KEY,
    nombre_producto VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio NUMERIC(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    id_categoria INT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    nombre_cliente VARCHAR(100) NOT NULL,
    correo_electronico VARCHAR(120) UNIQUE NOT NULL,
    direccion TEXT,
    telefono VARCHAR(20)
);

CREATE TABLE carrito (
    id_carrito SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE carrito_producto (
    id_carrito INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    PRIMARY KEY (id_carrito, id_producto),
    FOREIGN KEY (id_carrito) REFERENCES carrito (id_carrito)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES producto (id_producto)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE pedido (
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total NUMERIC(12,2) NOT NULL CHECK (total >= 0),
    estado VARCHAR(30) DEFAULT 'Pendiente',
    FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE detalle_pedido (
    id_detalle SERIAL PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMERIC(10,2) NOT NULL CHECK (precio_unitario >= 0),
    FOREIGN KEY (id_pedido) REFERENCES pedido (id_pedido)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES producto (id_producto)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ====================================
-- TABLA DE PAGOS Y FACTURACIÓN
-- ====================================

CREATE TABLE metodo_pago (
    id_metodo_pago SERIAL PRIMARY KEY,
    tipo_pago VARCHAR(50) NOT NULL,
    descripcion TEXT
);

CREATE TABLE pago (
    id_pago SERIAL PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_metodo_pago INT NOT NULL,
    monto NUMERIC(12,2) NOT NULL CHECK (monto >= 0),
    fecha_pago TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pedido) REFERENCES pedido (id_pedido)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_metodo_pago) REFERENCES metodo_pago (id_metodo_pago)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ====================================
--   REGLAS Y SANCIONES (RELACIONADA)
-- ====================================

CREATE TABLE regla_sancion (
    id_regla SERIAL PRIMARY KEY,
    descripcion TEXT NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    penalizacion NUMERIC(10,2) NOT NULL CHECK (penalizacion >= 0)
);

-- Relación muchos a muchos entre cliente y regla_sancion
CREATE TABLE cliente_regla (
    id_cliente INT NOT NULL,
    id_regla INT NOT NULL,
    fecha_aplicacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_cliente, id_regla),
    FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_regla) REFERENCES regla_sancion (id_regla)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- =======================================
-- FUNCIONES Y DISPARADORES (TRIGGERS)
-- =======================================

-- Función: Actualizar stock al generar un pedido
CREATE OR REPLACE FUNCTION actualizar_stock()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE producto
    SET stock = stock - NEW.cantidad
    WHERE id_producto = NEW.id_producto;

    IF (SELECT stock FROM producto WHERE id_producto = NEW.id_producto) < 0 THEN
        RAISE EXCEPTION 'Stock insuficiente para el producto %', NEW.id_producto;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_actualizar_stock
AFTER INSERT ON detalle_pedido
FOR EACH ROW
EXECUTE FUNCTION actualizar_stock();

-- Función: Actualizar total del pedido
CREATE OR REPLACE FUNCTION calcular_total_pedido()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE pedido
    SET total = (
        SELECT SUM(cantidad * precio_unitario)
        FROM detalle_pedido
        WHERE id_pedido = NEW.id_pedido
    )
    WHERE id_pedido = NEW.id_pedido;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_calcular_total_pedido
AFTER INSERT OR UPDATE ON detalle_pedido
FOR EACH ROW
EXECUTE FUNCTION calcular_total_pedido();

-- ======================================
-- VISTAS DE ANÁLISIS
-- ======================================

CREATE VIEW ventas_por_categoria AS
SELECT
    c.nombre_categoria,
    SUM(dp.cantidad * dp.precio_unitario) AS total_vendido,
    COUNT(DISTINCT p.id_pedido) AS numero_pedidos
FROM detalle_pedido dp
JOIN producto pr ON dp.id_producto = pr.id_producto
JOIN categoria c ON pr.id_categoria = c.id_categoria
JOIN pedido p ON dp.id_pedido = p.id_pedido
GROUP BY c.nombre_categoria
ORDER BY total_vendido DESC;

-- ======================================
-- FIN DEL SCRIPT
-- ======================================

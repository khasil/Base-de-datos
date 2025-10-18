-- ========================================
-- BASE DE DATOS: Sistema de Préstamos Financieros
-- ========================================

DROP SCHEMA IF EXISTS prestamos_financieros CASCADE;
CREATE SCHEMA prestamos_financieros;
SET search_path TO prestamos_financieros;

-- ========================================
-- TABLA: Persona
-- ========================================
CREATE TABLE persona (
    id_persona BIGSERIAL PRIMARY KEY,
    tipo_documento VARCHAR(10) NOT NULL,
    numero_documento VARCHAR(30) NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE,
    correo_electronico VARCHAR(200),
    telefono VARCHAR(30),
    direccion VARCHAR(300),
    fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    fecha_actualizacion TIMESTAMP WITH TIME ZONE,
    UNIQUE (tipo_documento, numero_documento)
);
COMMENT ON TABLE persona IS 'Contiene los datos personales de todos los individuos: clientes, codeudores, garantes.';

-- ========================================
-- TABLA: Cliente
-- ========================================
CREATE TABLE cliente (
    id_cliente BIGSERIAL PRIMARY KEY,
    id_persona BIGINT NOT NULL,
    codigo_cliente VARCHAR(30) UNIQUE NOT NULL,
    fecha_registro DATE DEFAULT CURRENT_DATE,
    nivel_riesgo SMALLINT DEFAULT 5 CHECK (nivel_riesgo BETWEEN 1 AND 10),
    identificacion_tributaria VARCHAR(30)
);
COMMENT ON TABLE cliente IS 'Datos comerciales y tributarios del cliente.';

-- ========================================
-- TABLA: Préstamo
-- ========================================
CREATE TABLE prestamo (
    id_prestamo BIGSERIAL PRIMARY KEY,
    codigo_prestamo VARCHAR(40) UNIQUE NOT NULL,
    id_cliente BIGINT NOT NULL,
    monto_original NUMERIC(14,2) NOT NULL CHECK (monto_original > 0),
    moneda CHAR(3) DEFAULT 'COP',
    tasa_interes_anual NUMERIC(6,4) NOT NULL CHECK (tasa_interes_anual >= 0),
    tipo_interes VARCHAR(10) NOT NULL CHECK (tipo_interes IN ('FIJO','VARIABLE')),
    fecha_inicio DATE NOT NULL,
    plazo_meses INTEGER NOT NULL CHECK (plazo_meses > 0),
    frecuencia_pago VARCHAR(15) NOT NULL CHECK (frecuencia_pago IN ('MENSUAL','SEMANAL','QUINCENAL','DIARIA')),
    metodo_amortizacion VARCHAR(20) NOT NULL CHECK (metodo_amortizacion IN ('FRANCÉS','ALEMÁN','SIMPLE','PERSONALIZADO')),
    estado VARCHAR(20) DEFAULT 'ACTIVO' CHECK (estado IN ('ACTIVO','CERRADO','EN_MORA')),
    fecha_desembolso DATE,
    valor_desembolso NUMERIC(14,2),
    fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
COMMENT ON TABLE prestamo IS 'Contiene los datos de cada contrato de préstamo, condiciones y estado actual.';

-- ========================================
-- TABLA: Regla de Sanción por Mora
-- ========================================
CREATE TABLE regla_sancion (
    id_regla BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    dias_minimos INTEGER NOT NULL,
    dias_maximos INTEGER NOT NULL,
    tasa_sancion_anual NUMERIC(6,4) NOT NULL DEFAULT 0,
    valor_fijo NUMERIC(14,2) DEFAULT 0,
    CHECK (dias_minimos >= 0 AND dias_maximos >= dias_minimos)
);
COMMENT ON TABLE regla_sancion IS 'Define el cálculo de sanciones por mora en base al número de días de atraso.';

-- ========================================
-- TABLA: Participante de Préstamo
-- ========================================
CREATE TABLE participante_prestamo (
    id_participante BIGSERIAL PRIMARY KEY,
    id_prestamo BIGINT NOT NULL,
    id_persona BIGINT NOT NULL,
    rol VARCHAR(20) NOT NULL CHECK (rol IN ('DEUDOR','CODEUDOR','GARANTE')),
    porcentaje_responsabilidad NUMERIC(5,4) DEFAULT 1.0 CHECK (porcentaje_responsabilidad > 0),
    fecha_inicio DATE DEFAULT CURRENT_DATE,
    fecha_fin DATE,
    UNIQUE (id_prestamo, id_persona, rol)
);
COMMENT ON TABLE participante_prestamo IS 'Relaciona personas con préstamos y su rol dentro del contrato.';

-- ========================================
-- TABLA: Cuota
-- ========================================
CREATE TABLE cuota (
    id_cuota BIGSERIAL PRIMARY KEY,
    id_prestamo BIGINT NOT NULL,
    id_regla BIGINT,
    numero_cuota INTEGER NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    valor_capital NUMERIC(14,2) NOT NULL DEFAULT 0,
    valor_interes NUMERIC(14,2) NOT NULL DEFAULT 0,
    valor_sancion NUMERIC(14,2) NOT NULL DEFAULT 0,
    valor_impuestos NUMERIC(14,2) NOT NULL DEFAULT 0,
    total_cuota NUMERIC(14,2) GENERATED ALWAYS AS (valor_capital + valor_interes + valor_sancion + valor_impuestos) STORED,
    pagado_capital NUMERIC(14,2) DEFAULT 0,
    pagado_interes NUMERIC(14,2) DEFAULT 0,
    pagado_sancion NUMERIC(14,2) DEFAULT 0,
    pagado_impuestos NUMERIC(14,2) DEFAULT 0,
    estado VARCHAR(20) DEFAULT 'PENDIENTE' CHECK (estado IN ('PENDIENTE','PARCIAL','PAGADA','EN_MORA')),
    UNIQUE (id_prestamo, numero_cuota)
);
COMMENT ON TABLE cuota IS 'Calendario de pagos del préstamo con detalle de cada cuota y su regla de sanción asociada.';

-- ========================================
-- TABLA: Pago
-- ========================================
CREATE TABLE pago (
    id_pago BIGSERIAL PRIMARY KEY,
    id_prestamo BIGINT NOT NULL,
    id_persona_pagadora BIGINT,
    fecha_pago TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    valor_pagado NUMERIC(14,2) NOT NULL CHECK (valor_pagado >= 0),
    metodo_pago VARCHAR(30) NOT NULL CHECK (metodo_pago IN ('EFECTIVO','TRANSFERENCIA','TARJETA')),
    numero_recibo VARCHAR(80),
    observacion TEXT
);
COMMENT ON TABLE pago IS 'Registro de pagos efectuados sobre los préstamos.';

-- ========================================
-- TABLA: Detalle de Pago
-- ========================================
CREATE TABLE detalle_pago (
    id_detalle BIGSERIAL PRIMARY KEY,
    id_pago BIGINT NOT NULL,
    id_cuota BIGINT,
    tipo_movimiento VARCHAR(30) NOT NULL CHECK (tipo_movimiento IN ('CAPITAL','INTERÉS','SANCIÓN','IMPUESTO')),
    valor NUMERIC(14,2) NOT NULL CHECK (valor >= 0),
    observacion TEXT
);
COMMENT ON TABLE detalle_pago IS 'Desglose de cada pago según concepto (capital, interés, sanción, impuesto).';

-- ========================================
-- TABLA: Historial de Estados
-- ========================================
CREATE TABLE historial_estado_prestamo (
    id_historial BIGSERIAL PRIMARY KEY,
    id_prestamo BIGINT NOT NULL,
    estado VARCHAR(20) NOT NULL,
    id_persona_modifica BIGINT,
    fecha_cambio TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    observacion TEXT
);
COMMENT ON TABLE historial_estado_prestamo IS 'Historial de los cambios de estado del préstamo.';

-- ========================================
-- TABLA: Certificados
-- ========================================
CREATE TABLE certificado (
    id_certificado BIGSERIAL PRIMARY KEY,
    id_prestamo BIGINT NOT NULL,
    tipo_certificado VARCHAR(30) NOT NULL CHECK (tipo_certificado IN ('PAZ_Y_SALVO','TRIBUTARIO')),
    fecha_emision TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    id_emisor BIGINT,
    contenido JSONB NOT NULL,
    valido_hasta DATE
);
COMMENT ON TABLE certificado IS 'Certificados generados de paz y salvo o tributarios.';


-- ========================================
-- LLAVES FORÁNEAS (RELACIONES)
-- ========================================

-- Cliente → Persona
ALTER TABLE cliente
ADD CONSTRAINT fk_cliente_persona
FOREIGN KEY (id_persona) REFERENCES persona(id_persona)
ON DELETE RESTRICT ON UPDATE CASCADE;

-- Préstamo → Cliente
ALTER TABLE prestamo
ADD CONSTRAINT fk_prestamo_cliente
FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
ON DELETE RESTRICT ON UPDATE CASCADE;

-- Participante → Préstamo
ALTER TABLE participante_prestamo
ADD CONSTRAINT fk_participante_prestamo
FOREIGN KEY (id_prestamo) REFERENCES prestamo(id_prestamo)
ON DELETE CASCADE ON UPDATE CASCADE;

-- Participante → Persona
ALTER TABLE participante_prestamo
ADD CONSTRAINT fk_participante_persona
FOREIGN KEY (id_persona) REFERENCES persona(id_persona)
ON DELETE RESTRICT ON UPDATE CASCADE;

-- Cuota → Préstamo
ALTER TABLE cuota
ADD CONSTRAINT fk_cuota_prestamo
FOREIGN KEY (id_prestamo) REFERENCES prestamo(id_prestamo)
ON DELETE CASCADE ON UPDATE CASCADE;

-- Cuota → Regla de sanción
ALTER TABLE cuota
ADD CONSTRAINT fk_cuota_regla_sancion
FOREIGN KEY (id_regla) REFERENCES regla_sancion(id_regla)
ON DELETE SET NULL ON UPDATE CASCADE;

-- Pago → Préstamo
ALTER TABLE pago
ADD CONSTRAINT fk_pago_prestamo
FOREIGN KEY (id_prestamo) REFERENCES prestamo(id_prestamo)
ON DELETE RESTRICT ON UPDATE CASCADE;

-- Pago → Persona (pagador)
ALTER TABLE pago
ADD CONSTRAINT fk_pago_persona
FOREIGN KEY (id_persona_pagadora) REFERENCES persona(id_persona)
ON DELETE SET NULL ON UPDATE CASCADE;

-- Detalle Pago → Pago
ALTER TABLE detalle_pago
ADD CONSTRAINT fk_detalle_pago_pago
FOREIGN KEY (id_pago) REFERENCES pago(id_pago)
ON DELETE CASCADE ON UPDATE CASCADE;

-- Detalle Pago → Cuota
ALTER TABLE detalle_pago
ADD CONSTRAINT fk_detalle_pago_cuota
FOREIGN KEY (id_cuota) REFERENCES cuota(id_cuota)
ON DELETE SET NULL ON UPDATE CASCADE;

-- Historial → Préstamo
ALTER TABLE historial_estado_prestamo
ADD CONSTRAINT fk_historial_prestamo
FOREIGN KEY (id_prestamo) REFERENCES prestamo(id_prestamo)
ON DELETE CASCADE ON UPDATE CASCADE;

-- Historial → Persona (modificador)
ALTER TABLE historial_estado_prestamo
ADD CONSTRAINT fk_historial_persona
FOREIGN KEY (id_persona_modifica) REFERENCES persona(id_persona)
ON DELETE SET NULL ON UPDATE CASCADE;

-- Certificado → Préstamo
ALTER TABLE certificado
ADD CONSTRAINT fk_certificado_prestamo
FOREIGN KEY (id_prestamo) REFERENCES prestamo(id_prestamo)
ON DELETE CASCADE ON UPDATE CASCADE;

-- Certificado → Persona (emisor)
ALTER TABLE certificado
ADD CONSTRAINT fk_certificado_emisor
FOREIGN KEY (id_emisor) REFERENCES persona(id_persona)
ON DELETE SET NULL ON UPDATE CASCADE;

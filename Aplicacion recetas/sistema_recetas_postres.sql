
-- Eliminamos tablas si existen
DROP TABLE IF EXISTS comentarios CASCADE;
DROP TABLE IF EXISTS favoritos CASCADE;
DROP TABLE IF EXISTS imagenes_recetas CASCADE;
DROP TABLE IF EXISTS receta_etiquetas CASCADE;
DROP TABLE IF EXISTS receta_ingredientes CASCADE;
DROP TABLE IF EXISTS etiquetas CASCADE;
DROP TABLE IF EXISTS ingredientes CASCADE;
DROP TABLE IF EXISTS recetas CASCADE;
DROP TABLE IF EXISTS categorias CASCADE;
DROP TABLE IF EXISTS usuarios CASCADE;

-- ===================== TABLA USUARIOS =====================
CREATE TABLE usuarios (
    id_usuario SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    contrasena VARCHAR(100) NOT NULL,
    rol VARCHAR(50) CHECK (rol IN ('Administrador', 'Cocinero', 'Usuario')) DEFAULT 'Usuario',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE usuarios IS 'Contiene la información de los usuarios del sistema';
COMMENT ON COLUMN usuarios.id_usuario IS 'Identificador único del usuario';

-- ===================== TABLA CATEGORÍAS =====================
CREATE TABLE categorias (
    id_categoria SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT
);

COMMENT ON TABLE categorias IS 'Categorías generales de las recetas (Ej: Tortas, Galletas, Helados)';

-- ===================== TABLA RECETAS =====================
CREATE TABLE recetas (
    id_receta SERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descripcion TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tiempo_preparacion INTEGER,
    dificultad VARCHAR(50) CHECK (dificultad IN ('Fácil', 'Media', 'Difícil')),
    id_usuario INTEGER NOT NULL,
    id_categoria INTEGER NOT NULL,
    CONSTRAINT fk_receta_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_receta_categoria FOREIGN KEY (id_categoria) REFERENCES categorias (id_categoria) ON DELETE CASCADE ON UPDATE CASCADE
);

COMMENT ON TABLE recetas IS 'Contiene la información principal de cada receta';
COMMENT ON COLUMN recetas.id_usuario IS 'Hace referencia al autor de la receta';

-- ===================== TABLA INGREDIENTES =====================
CREATE TABLE ingredientes (
    id_ingrediente SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    unidad_medida VARCHAR(50)
);

COMMENT ON TABLE ingredientes IS 'Lista de ingredientes posibles';

-- ===================== TABLA RECETA_INGREDIENTES =====================
CREATE TABLE receta_ingredientes (
    id_receta INTEGER NOT NULL,
    id_ingrediente INTEGER NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_receta, id_ingrediente),
    CONSTRAINT fk_ri_receta FOREIGN KEY (id_receta) REFERENCES recetas (id_receta) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_ri_ingrediente FOREIGN KEY (id_ingrediente) REFERENCES ingredientes (id_ingrediente) ON DELETE CASCADE ON UPDATE CASCADE
);

COMMENT ON TABLE receta_ingredientes IS 'Tabla intermedia que relaciona las recetas con sus ingredientes';

-- ===================== TABLA ETIQUETAS =====================
CREATE TABLE etiquetas (
    id_etiqueta SERIAL PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

COMMENT ON TABLE etiquetas IS 'Etiquetas o palabras clave asociadas a las recetas';

-- ===================== TABLA RECETA_ETIQUETAS =====================
CREATE TABLE receta_etiquetas (
    id_receta INTEGER NOT NULL,
    id_etiqueta INTEGER NOT NULL,
    PRIMARY KEY (id_receta, id_etiqueta),
    CONSTRAINT fk_re_receta FOREIGN KEY (id_receta) REFERENCES recetas (id_receta) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_re_etiqueta FOREIGN KEY (id_etiqueta) REFERENCES etiquetas (id_etiqueta) ON DELETE CASCADE ON UPDATE CASCADE
);

COMMENT ON TABLE receta_etiquetas IS 'Relación entre recetas y etiquetas';

-- ===================== TABLA IMÁGENES DE RECETAS =====================
CREATE TABLE imagenes_recetas (
    id_imagen SERIAL PRIMARY KEY,
    id_receta INTEGER NOT NULL,
    url_imagen TEXT NOT NULL,
    descripcion TEXT,
    CONSTRAINT fk_imagen_receta FOREIGN KEY (id_receta) REFERENCES recetas (id_receta) ON DELETE CASCADE ON UPDATE CASCADE
);

COMMENT ON TABLE imagenes_recetas IS 'Imágenes asociadas a cada receta';

-- ===================== TABLA FAVORITOS =====================
CREATE TABLE favoritos (
    id_usuario INTEGER NOT NULL,
    id_receta INTEGER NOT NULL,
    fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario, id_receta),
    CONSTRAINT fk_fav_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_fav_receta FOREIGN KEY (id_receta) REFERENCES recetas (id_receta) ON DELETE CASCADE ON UPDATE CASCADE
);

COMMENT ON TABLE favoritos IS 'Recetas marcadas como favoritas por los usuarios';

-- ===================== TABLA COMENTARIOS =====================
CREATE TABLE comentarios (
    id_comentario SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    id_receta INTEGER NOT NULL,
    texto TEXT NOT NULL,
    calificacion INTEGER CHECK (calificacion BETWEEN 1 AND 5),
    fecha_publicacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_com_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_com_receta FOREIGN KEY (id_receta) REFERENCES recetas (id_receta) ON DELETE CASCADE ON UPDATE CASCADE
);

COMMENT ON TABLE comentarios IS 'Comentarios y calificaciones realizadas por los usuarios sobre las recetas';

-- ===================== ÍNDICES =====================
CREATE INDEX idx_recetas_categoria ON recetas(id_categoria);
CREATE INDEX idx_recetas_usuario ON recetas(id_usuario);
CREATE INDEX idx_receta_ingrediente ON receta_ingredientes(id_ingrediente);
CREATE INDEX idx_favoritos_usuario ON favoritos(id_usuario);
CREATE INDEX idx_comentarios_receta ON comentarios(id_receta);

-- ===================== FIN DEL SCRIPT =====================
-- ═══ PASO 2: INSERTAR USUARIOS ═══
INSERT INTO usuarios (nombre, correo, contrasena, rol) VALUES
('Chef María González', 'maria.chef@recetas.com', '123456', 'Administrador'),
('Carlos Repostero', 'carlos@postres.com', '123456', 'Cocinero'),
('Ana Pastelera', 'ana@dulces.com', '123456', 'Cocinero'),
('Luis Chocolatero', 'luis@chocolate.com', '123456', 'Usuario')
ON CONFLICT DO NOTHING;

-- ═══ PASO 3: INSERTAR CATEGORÍAS ═══
INSERT INTO categorias (nombre, descripcion) VALUES
('Brownies', 'Postres de chocolate densos y húmedos'),
('Cheesecakes', 'Tartas de queso cremosas y suaves'),
('Postres Fríos', 'Postres sin horno refrigerados'),
('Postres Latinoamericanos', 'Dulces tradicionales de Latinoamérica'),
('Postres con Frutas', 'Dulces que destacan frutas frescas'),
('Postres Italianos', 'Clásicos dulces de Italia'),
('Galletas', 'Galletas dulces y crujientes'),
('Flanes', 'Postres suaves y cremosos tipo flan')
ON CONFLICT DO NOTHING;

-- ═══ PASO 4: INSERTAR INGREDIENTES ═══
INSERT INTO ingredientes (nombre, unidad_medida) VALUES
-- Bases
('Harina de trigo', 'gramos'),
('Azúcar blanca', 'gramos'),
('Azúcar en polvo', 'gramos'),
('Huevos', 'unidades'),
('Mantequilla sin sal', 'gramos'),
('Leche entera', 'ml'),
('Crema de leche', 'ml'),
('Nata para montar', 'ml'),

-- Chocolates
('Chocolate negro 70%', 'gramos'),
('Chocolate blanco', 'gramos'),
('Cocoa en polvo', 'gramos'),
('Chispas de chocolate', 'gramos'),

-- Quesos
('Queso crema Philadelphia', 'gramos'),
('Queso mascarpone', 'gramos'),

-- Lácteos especiales
('Leche condensada', 'ml'),
('Leche evaporada', 'ml'),
('Yogur griego', 'gramos'),

-- Frutas
('Fresas frescas', 'gramos'),
('Duraznos', 'unidades'),
('Limón', 'unidades'),

-- Especias y extractos
('Extracto de vainilla', 'ml'),
('Canela en polvo', 'gramos'),
('Café expreso', 'ml'),
('Amaretto', 'ml'),

-- Otros
('Polvo de hornear', 'gramos'),
('Sal', 'gramos'),
('Galletas María', 'gramos'),
('Bizcochos de soletilla', 'unidades'),
('Dulce de leche', 'gramos'),
('Maicena', 'gramos'),
('Coco rallado', 'gramos'),
('Gelatina sin sabor', 'gramos')
ON CONFLICT DO NOTHING;

-- 1. INSERTAR USUARIOS
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO usuarios (nombre, correo, contrasena, rol) VALUES
('Chef María González', 'maria.chef@recetas.com', '123456', 'Administrador'),
('Carlos Repostero', 'carlos@postres.com', '123456', 'Cocinero'),
('Ana Pastelera', 'ana@dulces.com', '123456', 'Cocinero'),
('Luis Chocolatero', 'luis@chocolate.com', '123456', 'Usuario')
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════════════════════
-- 2. INSERTAR CATEGORÍAS
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO categorias (nombre, descripcion) VALUES
('Brownies', 'Postres de chocolate densos y húmedos'),
('Cheesecakes', 'Tartas de queso cremosas y suaves'),
('Postres Fríos', 'Postres sin horno refrigerados'),
('Postres Latinoamericanos', 'Dulces tradicionales de Latinoamérica'),
('Postres con Frutas', 'Dulces que destacan frutas frescas'),
('Postres Italianos', 'Clásicos dulces de Italia'),
('Galletas', 'Galletas dulces y crujientes'),
('Flanes', 'Postres suaves y cremosos tipo flan')
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════════════════════
-- 3. INSERTAR INGREDIENTES
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO ingredientes (nombre, unidad_medida) VALUES
('Harina de trigo', 'gramos'),
('Azúcar blanca', 'gramos'),
('Azúcar en polvo', 'gramos'),
('Huevos', 'unidades'),
('Mantequilla sin sal', 'gramos'),
('Leche entera', 'ml'),
('Crema de leche', 'ml'),
('Nata para montar', 'ml'),
('Chocolate negro 70%', 'gramos'),
('Chocolate blanco', 'gramos'),
('Cocoa en polvo', 'gramos'),
('Chispas de chocolate', 'gramos'),
('Queso crema Philadelphia', 'gramos'),
('Queso mascarpone', 'gramos'),
('Leche condensada', 'ml'),
('Leche evaporada', 'ml'),
('Yogur griego', 'gramos'),
('Fresas frescas', 'gramos'),
('Duraznos', 'unidades'),
('Limón', 'unidades'),
('Extracto de vainilla', 'ml'),
('Canela en polvo', 'gramos'),
('Café expreso', 'ml'),
('Amaretto', 'ml'),
('Polvo de hornear', 'gramos'),
('Sal', 'gramos'),
('Galletas María', 'gramos'),
('Bizcochos de soletilla', 'unidades'),
('Dulce de leche', 'gramos'),
('Maicena', 'gramos'),
('Coco rallado', 'gramos'),
('Gelatina sin sabor', 'gramos')
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════════════════════
-- 4. INSERTAR RECETAS (4 Recetas Principales)
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO recetas (titulo, descripcion, tiempo_preparacion, dificultad, id_usuario, id_categoria) VALUES

('Brownie Clásico de Chocolate',
 'Un delicioso brownie húmedo y denso con chocolate negro de alta calidad. Se hornea a 180°C durante 25-30 minutos hasta que los bordes estén firmes pero el centro aún esté ligeramente húmedo. Perfecto para los amantes del chocolate puro.',
 45, 'Fácil', 1, 1),

('Cheesecake Estilo New York',
 'El clásico cheesecake cremoso y suave con base de galleta. Se hornea a baño maría para obtener una textura perfecta sin grietas. Ideal para refrigerar por 4 horas antes de servir con coulis de fresas.',
 90, 'Media', 1, 2),

('Tiramisú Tradicional Italiano',
 'Postre italiano clásico con capas de bizcochos de soletilla empapados en café expreso, crema de mascarpone y cacao. No requiere horno, solo refrigeración por 6 horas para que los sabores se integren perfectamente.',
 30, 'Fácil', 2, 6),

('Pastel Tres Leches Tradicional',
 'Bizcocho esponjoso empapado en una mezcla de leche condensada, evaporada y crema. Coronado con merengue suave. Este postre latinoamericano debe reposar 12 horas en refrigeración para absorber toda la mezcla de leches.',
 120, 'Media', 2, 4)
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════════════════════
-- 5. INSERTAR INGREDIENTES DE RECETAS
-- ═══════════════════════════════════════════════════════════════════════════════

-- Brownie (ID 1)
INSERT INTO receta_ingredientes (id_receta, id_ingrediente, cantidad) VALUES
(1, 9, 200),   -- Chocolate negro 200g
(1, 5, 125),   -- Mantequilla 125g
(1, 4, 3),     -- Huevos 3
(1, 2, 160),   -- Azúcar 160g
(1, 1, 100),   -- Harina 100g
(1, 11, 30)    -- Cocoa 30g
ON CONFLICT DO NOTHING;

-- Cheesecake (ID 2)
INSERT INTO receta_ingredientes (id_receta, id_ingrediente, cantidad) VALUES
(2, 13, 600),  -- Queso crema 600g
(2, 2, 200),   -- Azúcar 200g
(2, 4, 3),     -- Huevos 3
(2, 7, 200),   -- Crema de leche 200ml
(2, 27, 200),  -- Galletas 200g
(2, 5, 100)    -- Mantequilla 100g
ON CONFLICT DO NOTHING;

-- Tiramisu (ID 3)
INSERT INTO receta_ingredientes (id_receta, id_ingrediente, cantidad) VALUES
(3, 14, 500),  -- Mascarpone 500g
(3, 4, 6),     -- Huevos 6
(3, 2, 100),   -- Azúcar 100g
(3, 23, 250),  -- Café 250ml
(3, 28, 30),   -- Bizcochos 30
(3, 11, 20)    -- Cocoa 20g
ON CONFLICT DO NOTHING;

-- Tres Leches (ID 4)
INSERT INTO receta_ingredientes (id_receta, id_ingrediente, cantidad) VALUES
(4, 4, 5),     -- Huevos 5
(4, 2, 200),   -- Azúcar 200g
(4, 1, 250),   -- Harina 250g
(4, 15, 400),  -- Leche condensada 400ml
(4, 16, 370),  -- Leche evaporada 370ml
(4, 7, 240)    -- Crema de leche 240ml
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════════════════════
-- 6. INSERTAR IMÁGENES 
-- ═══════════════════════════════════════════════════════════════════════════════


INSERT INTO imagenes_recetas (id_receta, url_imagen) VALUES

-- 1. Brownie Clásico
(1, 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80'),

-- 2. Tiramisu
(2, 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80')


ON CONFLICT DO NOTHING;
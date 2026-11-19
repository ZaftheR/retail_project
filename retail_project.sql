-- Preentrega 2 - Bases de Datos SQL
-- Proyecto: retail_project
-- Ejecutar en PostgreSQL, conectado a la base de datos retail_project.
-- La base se crea previamente con: CREATE DATABASE retail_project;

-- 1. Crear tablas principales (DDL)
CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    edad INTEGER NOT NULL,
    CHECK (edad >= 18)
);

CREATE TABLE productos (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    stock INTEGER NOT NULL,
    CHECK (precio > 0),
    CHECK (stock >= 0)
);

CREATE TABLE ventas (
    id_venta SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL,
    id_producto INTEGER NOT NULL,
    fecha DATE NOT NULL,
    cantidad INTEGER NOT NULL,
    CHECK (cantidad > 0),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- 2. Cargar los datos iniciales en una transacción (DML)
BEGIN;

INSERT INTO clientes (nombre, email, edad) VALUES
('Ana Gomez', 'ana.gomez@example.com', 28),
('Lucas Perez', 'lucas.perez@example.com', 34),
('Sofia Martinez', 'sofia.martinez@example.com', 25),
('Mateo Rodriguez', 'mateo.rodriguez@example.com', 40),
('Valentina Lopez', 'valentina.lopez@example.com', 31);

INSERT INTO productos (nombre, categoria, precio, stock) VALUES
('Mouse inalambrico', 'Tecnologia', 15000.00, 20),
('Teclado mecanico', 'Tecnologia', 45000.00, 10),
('Cuaderno A4', 'Libreria', 4500.00, 50),
('Lapicera azul', 'Libreria', 1200.00, 100),
('Mochila urbana', 'Accesorios', 35000.00, 15);

INSERT INTO ventas (id_cliente, id_producto, fecha, cantidad) VALUES
(1, 1, '2026-11-01', 1),
(2, 3, '2026-11-03', 2),
(3, 2, '2026-11-05', 1),
(4, 5, '2026-11-08', 1),
(5, 4, '2026-11-10', 3);

COMMIT;

-- 3. Consultar previamente qué productos serán modificados
SELECT id_producto, nombre, categoria, precio
FROM productos
WHERE categoria = 'Tecnologia';

-- 4. Aumentar un 10% el precio de los productos de Tecnologia
UPDATE productos
SET precio = ROUND(precio * 1.10, 2)
WHERE categoria = 'Tecnologia';

-- 5. Consultar previamente la venta de prueba que será eliminada
SELECT * FROM ventas WHERE id_venta = 5;

-- 6. Eliminar solo la venta identificada con id_venta = 5
DELETE FROM ventas
WHERE id_venta = 5;

-- 7. Verificar los datos finales
SELECT * FROM clientes ORDER BY id_cliente;
SELECT * FROM productos ORDER BY id_producto;
SELECT * FROM ventas ORDER BY id_venta;

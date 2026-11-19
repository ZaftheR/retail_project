-- Consulta 1: Rentabilidad por categoria
-- Permite identificar las categorias que generan
-- ingresos superiores a $10.000.

SELECT
    c.nombre AS categoria,
    SUM(v.cantidad) AS unidades_vendidas,
    SUM(v.cantidad * p.precio) AS ingreso_total
FROM ventas AS v
INNER JOIN productos AS p
    ON v.id_producto = p.id_producto
INNER JOIN categorias AS c
    ON p.id_categoria = c.id_categoria
GROUP BY c.nombre
HAVING SUM(v.cantidad * p.precio) > 10000
ORDER BY ingreso_total DESC;

-- Consulta 2: Clientes sin compras
-- Identifica clientes registrados que no realizaron
-- ninguna compra, para posibles campañas comerciales.

SELECT
    c.id_cliente,
    c.nombre AS cliente,
    c.email,
    COALESCE(COUNT(v.id_venta), 0) AS total_compras
FROM clientes AS c
LEFT JOIN ventas AS v
    ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente, c.nombre, c.email
HAVING COUNT(v.id_venta) = 0
ORDER BY c.nombre;

-- Consulta 3: Top de compras por cliente
-- Identifica el producto mas comprado por cada cliente,
-- las unidades adquiridas y la fecha de su ultima transaccion.

SELECT
    c.nombre AS cliente,
    p.nombre AS producto_mas_comprado,
    SUM(v.cantidad) AS unidades_compradas,
    (
        SELECT MAX(v3.fecha)
        FROM ventas AS v3
        WHERE v3.id_cliente = c.id_cliente
    ) AS ultima_transaccion
FROM clientes AS c
INNER JOIN ventas AS v
    ON c.id_cliente = v.id_cliente
INNER JOIN productos AS p
    ON v.id_producto = p.id_producto
GROUP BY c.id_cliente, c.nombre, p.id_producto, p.nombre
HAVING SUM(v.cantidad) = (
    SELECT MAX(compras.total_unidades)
    FROM (
        SELECT SUM(v2.cantidad) AS total_unidades
        FROM ventas AS v2
        WHERE v2.id_cliente = c.id_cliente
        GROUP BY v2.id_producto
    ) AS compras
)
ORDER BY unidades_compradas DESC, cliente;
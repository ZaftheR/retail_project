
-- PREENTREGA 5 - BASES DE DATOS SQL
-- Proyecto: Analisis avanzado de ventas
-- Base de datos: retail_project

-- CTE 1: Agrupar las ventas por mes y categoria.
-- Calcula el ingreso total de cada categoria en cada mes.

WITH ventas_mensuales AS (
    SELECT
        DATE_TRUNC('month', v.fecha)::DATE AS mes,
        c.nombre AS categoria,
        SUM(v.cantidad * p.precio) AS venta_total
    FROM ventas AS v
    INNER JOIN productos AS p
        ON v.id_producto = p.id_producto
    INNER JOIN categorias AS c
        ON p.id_categoria = c.id_categoria
    GROUP BY
        DATE_TRUNC('month', v.fecha),
        c.nombre
),

-- CTE 2: Calcular el ranking mensual y las ventas acumuladas.
-- RANK identifica la posicion de cada categoria en el mes.
-- SUM OVER acumula las ventas de cada categoria en el tiempo.

metricas_ventana AS (
    SELECT
        mes,
        categoria,
        venta_total,

        RANK() OVER (
            PARTITION BY mes
            ORDER BY venta_total DESC
        ) AS ranking_mensual,

        SUM(venta_total) OVER (
            PARTITION BY categoria
            ORDER BY mes
            ROWS BETWEEN UNBOUNDED PRECEDING
                     AND CURRENT ROW
        ) AS venta_acumulada

    FROM ventas_mensuales
),

-- CTE 3: Calcular el promedio historico por categoria.
-- Obtiene el promedio de las ventas mensuales registradas.

promedios_categoria AS (
    SELECT
        categoria,
        AVG(venta_total) AS promedio_historico
    FROM ventas_mensuales
    GROUP BY categoria
)

-- REPORTE FINAL
-- Compara la venta mensual con el promedio historico.
-- Si supera el promedio, se considera Exitoso.
-- En caso contrario, se muestra Bajo el promedio.

SELECT
    m.mes,
    m.categoria,
    m.venta_total,
    m.ranking_mensual,
    m.venta_acumulada,
    ROUND(p.promedio_historico, 2) AS promedio_historico,

    CASE
        WHEN m.venta_total > p.promedio_historico
            THEN 'Exitoso'
        ELSE 'Bajo el promedio'
    END AS estado_ventas

FROM metricas_ventana AS m
INNER JOIN promedios_categoria AS p
    ON m.categoria = p.categoria

ORDER BY m.mes, m.ranking_mensual;

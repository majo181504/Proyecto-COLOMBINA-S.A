-- ============================================================
-- COLOMBINA S.A. — CONSULTAS ESTRATÉGICAS PARA TOMA DE DECISIONES
-- Base de datos: colombina-db2
-- Enfoque: Revenue, Rentabilidad, Decisiones Ejecutivas
-- ============================================================

-- ============================================================
-- CONSULTA 1: VENTAS POR DÍA
-- Decisión: ¿En que dia se concentra el mayor número de ganancias?
-- Lista los dias de la semana junto con el numero de ventas
-- Y el numero total de ingresos
-- ============================================================
SELECT
    TO_CHAR(o.fecha_venta,'Day') AS dia,
    COUNT(DISTINCT o.id_venta)   AS numero_ventas,
    SUM(dv.unidades)             AS unidades_vendidas,
    ROUND(SUM(dv.subtotal),2)    AS revenue
FROM orden_venta o
JOIN detalle_venta dv ON o.id_venta = dv.id_venta
GROUP BY
    EXTRACT(DOW FROM o.fecha_venta),
    TO_CHAR(o.fecha_venta,'Day')
ORDER BY
    EXTRACT(DOW FROM o.fecha_venta);


-- ============================================================
-- CONSULTA 2: PRODUCTO SIN VENTAS
-- Decisión: ¿Hay algún producto que no haya generado ventas?
-- Lista, si existen, productos que no hayan generado un numero
-- de ventas
-- ============================================================
SELECT
    p.id_producto,
    p.nombre_producto,
    c.nombre_categoria,
    m.nombre_marca
FROM productos p
JOIN categoria c ON p.cate_id = c.id_categoria
JOIN marca m     ON p.marca_id = m.id_marca
LEFT JOIN detalle_venta dv
    ON p.id_producto = dv.id_prod
WHERE dv.id_prod IS NULL
ORDER BY c.nombre_categoria, p.nombre_producto;


-- ==========================================================
-- CONSULTA 3: PRODUCTO POR CATEGORÍA
-- Decisión: ¿Cuál es el producto estrella de cada categoría?
-- Identifica el producto mas vendido para cada categoría.
-- ==========================================================
WITH ranking AS (
    SELECT
        c.nombre_categoria,
        p.nombre_producto,
        SUM(dv.unidades) AS unidades_vendidas,
        ROW_NUMBER() OVER(
            PARTITION BY c.nombre_categoria
            ORDER BY SUM(dv.unidades) DESC
        ) AS posicion
    FROM productos p
    JOIN categoria c      ON p.cate_id=c.id_categoria
    JOIN detalle_venta dv ON p.id_producto=dv.id_prod
    GROUP BY
        c.nombre_categoria,
        p.nombre_producto
)
SELECT *
FROM ranking
WHERE posicion=1
ORDER BY nombre_categoria, posicion;


-- ============================================================
-- CONSULTA 4:DISTRIBUCIÓN DE EMPLEADOS
-- Decisión: ¿Qué tipo de contrato predomina más entre los empleados?
-- Analiza como se distribuyen entre los empleados los tipos
-- de contrato
-- ============================================================
SELECT
    tc.nombre_tipo_contrato,
    COUNT(*) AS empleados,
    ROUND(
    COUNT(*)*100.0/
    SUM(COUNT(*)) OVER(),2) AS porcentaje
FROM empleado e
JOIN tipo_contrato tc ON e.id_tipo_contrato=tc.id_tipo_contrato
GROUP BY tc.nombre_tipo_contrato
ORDER BY empleados DESC;


-- ============================================================
-- CONSULTA 5: COMPRAS POR PROVEEDOR
-- Decisión: ¿Qué proveedores registran la mayor cantidad
-- de compras?
-- Identifica los proveedores con mayor volumen de compras
-- ============================================================
SELECT
    p.nombre_proveedor,
    COUNT(DISTINCT oc.id_compra) AS compras,
    ROUND(SUM(dc.subtotal),2)    AS monto_total,
    ROUND(AVG(dc.subtotal),2)    AS promedio_compra
FROM proveedor p
JOIN orden_compra oc   ON p.id_proveedor=oc.id_proveedor
JOIN detalle_compra dc ON oc.id_compra=dc.id_compra
GROUP BY p.nombre_proveedor
ORDER BY monto_total DESC;


-- ============================================================
-- CONSULTA 6: CLIENTES SIN CRÉDITO CON ALTO VOLUMEN DE COMPRA
-- Decisión: ¿A qué clientes le conviene a Colombina ofrecerles crédito?
-- Identifica clientes que compran mucho pero pagan de contado.
-- ============================================================
SELECT
    cl.id_cliente,
    cl.nombre_cliente,
    cl.tipo_cliente,
    cl.canal_distribucion,
    COUNT(DISTINCT ov.id_venta)  AS ordenes_totales,
    ROUND(SUM(dv.subtotal),2)    AS revenue_total,
    ROUND(AVG(dv.subtotal),2)    AS ticket_promedio
FROM clientes cl
JOIN orden_venta ov   ON cl.id_cliente = ov.id_cliente
JOIN detalle_venta dv ON ov.id_venta   = dv.id_venta
WHERE cl.credito_autorizado = FALSE
GROUP BY cl.id_cliente, cl.nombre_cliente, cl.tipo_cliente, cl.canal_distribucion
ORDER BY revenue_total DESC
LIMIT 20;


-- ============================================================
-- CONSULTA 7: EMPLEADOS POR AREA
-- Decisión: ¿Qué áreas concentran la mayor cantidad de empleados?
-- Por cada area se registra el número de empleados junto con
-- el salario, detectando posibles desbalances organizativos
-- ============================================================
SELECT
    a.nombre_area,
    COUNT(*) AS empleados,
    ROUND(AVG(c.salario_base),2) AS salario_promedio,
    MIN(c.salario_base) AS salario_minimo,
    MAX(c.salario_base) AS salario_maximo
FROM empleado e
JOIN cargo c             ON e.id_cargo=c.id_cargo
JOIN area_departamento a ON c.id_area_depto=a.id_area
GROUP BY a.nombre_area
ORDER BY empleados DESC;


-- ============================================================
-- CONSULTA 8: PRODUCTOS POR ROTACIÓN
-- Decisión: ¿Qué productos requieren reabastecerse mas frecuentemente?
-- Recopila los productos junto con el índice de rotación
-- ============================================================
SELECT
    p.nombre_producto,
    SUM(dv.unidades)             AS unidades_vendidas,
    SUM(inv.cantidad_disponible) AS stock_actual,
    ROUND(
    SUM(dv.unidades)::numeric/
    NULLIF(SUM(inv.cantidad_disponible),0),2)
        AS indice_rotacion
FROM productos p
JOIN detalle_venta dv ON p.id_producto=dv.id_prod
JOIN inventario inv   ON p.id_producto=inv.id_prod
GROUP BY p.nombre_producto
ORDER BY indice_rotacion DESC;


-- ============================================================
-- CONSULTA 9: CIUDADES CON MAS VENTAS
-- Decisión: ¿En qué ciudades se generan más ingresos en ventas?
-- Recopila el nombre de las ciudades ordenados por el total
-- de ingresos
-- ============================================================
SELECT
    ci.nombre_ciudad,
    COUNT(DISTINCT c.id_cliente) AS clientes,
    COUNT(DISTINCT ov.id_venta)  AS ventas,
    ROUND(SUM(dv.subtotal),2)    AS revenue,
    ROUND(AVG(dv.subtotal),2)    AS ticket_promedio
FROM ciudad ci
JOIN clientes c       ON ci.id_ciudad=c.id_ciudad
JOIN orden_venta ov   ON c.id_cliente=ov.id_cliente
JOIN detalle_venta dv ON ov.id_venta=dv.id_venta
GROUP BY ci.nombre_ciudad
ORDER BY revenue DESC;


-- ============================================================
-- CONSULTA 10: PARTICIPACIÓN DE VENTAS POR CANAL DE DISTRIBUCIÓN
-- Decisión: ¿Qué canal de distribución requiere mas fortalecimiento?
-- Compara el desempeño de los diferentes canales de distribución
-- ============================================================
WITH ventas_canal AS (
    SELECT
        c.canal_distribucion,
        COUNT(DISTINCT c.id_cliente) AS total_clientes,
        COUNT(DISTINCT ov.id_venta)  AS total_ordenes,
        SUM(dv.unidades)             AS unidades_vendidas,
        ROUND(SUM(dv.subtotal),2)    AS revenue_total,
        ROUND(AVG(dv.subtotal),2)    AS ticket_promedio,
        ROUND(
            SUM(dv.subtotal)*100.0/
            SUM(SUM(dv.subtotal)) OVER(),
            2
        ) AS porcentaje_revenue
    FROM clientes c
    JOIN orden_venta ov   ON c.id_cliente = ov.id_cliente
    JOIN detalle_venta dv ON ov.id_venta = dv.id_venta
    GROUP BY c.canal_distribucion
)

SELECT *,
    CASE
        WHEN porcentaje_revenue >= 40
            THEN 'Excelente'
        WHEN porcentaje_revenue >= 25
            THEN 'Alto'
        WHEN porcentaje_revenue >= 10
            THEN 'Medio'
        ELSE 'Bajo'
    END AS nivel_desempeno
FROM ventas_canal
ORDER BY revenue_total DESC;


-- ============================================================
-- CONSULTA 11: RANKING DE PRODUCTOS POR REVENUE TOTAL
-- Decisión: ¿En qué productos debería invertir más Colombina?
-- Identifica los productos estrella que generan más ingresos.
-- ============================================================
SELECT
    p.id_producto,
    p.nombre_producto,
    c.nombre_categoria,
    m.nombre_marca,
    COUNT(dv.id_detalle_venta)          AS veces_vendido,
    SUM(dv.unidades)                    AS unidades_totales,
    ROUND(AVG(dv.precio_historico), 2)  AS precio_promedio,
    ROUND(SUM(dv.subtotal), 2)          AS revenue_total,
    ROUND(SUM(dv.subtotal) * 100.0 /
        SUM(SUM(dv.subtotal)) OVER (), 2) AS porcentaje_revenue
FROM detalle_venta dv
JOIN productos p     ON dv.id_prod       = p.id_producto
JOIN categoria c     ON p.cate_id        = c.id_categoria
JOIN marca m         ON p.marca_id       = m.id_marca
GROUP BY p.id_producto, p.nombre_producto, c.nombre_categoria, m.nombre_marca
ORDER BY revenue_total DESC
LIMIT 15;


-- ============================================================
-- CONSULTA 12: PROYECCIÓN DE REVENUE PARA 2025
-- Decisión: ¿Cuánto podría facturar Colombina en 2025?

-- ============================================================
-- CONSULTA 12 SIMPLIFICADA: Proyección 2025 basada en crecimiento anual real
WITH revenue_anual AS (
    SELECT
        EXTRACT(YEAR FROM ov.fecha_venta)  AS anio,
        ROUND(SUM(dv.subtotal), 2)         AS revenue_total
    FROM orden_venta ov
    JOIN detalle_venta dv ON ov.id_venta = dv.id_venta
    GROUP BY EXTRACT(YEAR FROM ov.fecha_venta)
)
SELECT
    MAX(CASE WHEN anio = 2023 THEN revenue_total END)  AS revenue_2023,
    MAX(CASE WHEN anio = 2024 THEN revenue_total END)  AS revenue_2024,
    ROUND(
        (MAX(CASE WHEN anio = 2024 THEN revenue_total END) -
         MAX(CASE WHEN anio = 2023 THEN revenue_total END)) * 100.0 /
        NULLIF(MAX(CASE WHEN anio = 2023 THEN revenue_total END), 0)
    , 2)                                               AS crecimiento_2023_2024_pct,
    ROUND(
        MAX(CASE WHEN anio = 2024 THEN revenue_total END) *
        (1 + (
            (MAX(CASE WHEN anio = 2024 THEN revenue_total END) -
             MAX(CASE WHEN anio = 2023 THEN revenue_total END)) /
            NULLIF(MAX(CASE WHEN anio = 2023 THEN revenue_total END), 0)
        ))
    , 2)                                               AS proyeccion_revenue_2025,
    ROUND(
        MAX(CASE WHEN anio = 2024 THEN revenue_total END) *
        (
            (MAX(CASE WHEN anio = 2024 THEN revenue_total END) -
             MAX(CASE WHEN anio = 2023 THEN revenue_total END)) /
            NULLIF(MAX(CASE WHEN anio = 2023 THEN revenue_total END), 0)
        )
    , 2)                                               AS incremento_esperado_2025
FROM revenue_anual;

-- ============================================================
-- CONSULTA 13: SEGMENTACIÓN DE CLIENTES POR RÉGIMEN TRIBUTARIO Y CANAL
-- Decisión: ¿Qué segmento de clientes concentra más participación,
-- y en cuál de ellos falta más autorización de crédito o habeas data?
-- ============================================================
SELECT
    cl.tipo_regimen_tributario,
    cl.canal_distribucion,
    COUNT(*)                                                    AS total_clientes,
    COUNT(CASE WHEN cl.credito_autorizado THEN 1 END)          AS con_credito,
    COUNT(CASE WHEN NOT cl.credito_autorizado THEN 1 END)      AS sin_credito,
    ROUND(COUNT(CASE WHEN cl.credito_autorizado THEN 1 END)
        * 100.0 / COUNT(*), 2)                                  AS pct_con_credito,
    COUNT(CASE WHEN NOT cl.autorizacion_habeas_data THEN 1 END) AS pendientes_habeas_data
FROM clientes cl
GROUP BY cl.tipo_regimen_tributario, cl.canal_distribucion
ORDER BY total_clientes DESC;


-- ============================================================
-- CONSULTA 14: ESTACIONALIDAD DE VENTAS POR CATEGORIA
-- Decisión: ¿En qué meses debe Colombina aumentar producción?
-- Revela los picos de demanda por categoría a lo largo del año.
-- ============================================================
SELECT
    c.nombre_categoria,
    EXTRACT(MONTH FROM ov.fecha_venta)   AS mes,
    TO_CHAR(ov.fecha_venta, 'Month')     AS nombre_mes,
    COUNT(DISTINCT ov.id_venta)          AS ordenes,
    SUM(dv.unidades)                     AS unidades_vendidas,
    ROUND(SUM(dv.subtotal), 2)           AS revenue_mes,
    ROUND(AVG(SUM(dv.subtotal)) OVER
        (PARTITION BY c.nombre_categoria), 2) AS promedio_mensual_categoria,
    ROUND(SUM(dv.subtotal) * 100.0 /
        SUM(SUM(dv.subtotal)) OVER
        (PARTITION BY c.nombre_categoria), 2) AS pct_del_anio
FROM orden_venta ov
JOIN detalle_venta dv ON ov.id_venta  = dv.id_venta
JOIN productos p      ON dv.id_prod   = p.id_producto
JOIN categoria c      ON p.cate_id    = c.id_categoria
GROUP BY c.nombre_categoria,
         EXTRACT(MONTH FROM ov.fecha_venta),
         TO_CHAR(ov.fecha_venta, 'Month')
ORDER BY c.nombre_categoria, mes;


-- ============================================================
-- CONSULTA 15: TOP 20 CLIENTES POR REVENUE (ANÁLISIS PARETO)
-- Decisión: ¿Qué clientes representan el 80% de las ventas?
-- La regla 80/20 aplicada a la cartera de clientes.
-- ============================================================
WITH revenue_cliente AS (
    SELECT
        cl.id_cliente,
        cl.nombre_cliente,
        cl.tipo_cliente,
        cl.canal_distribucion,
        ci.nombre_ciudad,
        COUNT(DISTINCT ov.id_venta)     AS ordenes_totales,
        SUM(dv.subtotal)                AS revenue_total,
        AVG(dv.subtotal)                AS ticket_promedio
    FROM clientes cl
    JOIN orden_venta ov   ON cl.id_cliente = ov.id_cliente
    JOIN detalle_venta dv ON ov.id_venta   = dv.id_venta
    JOIN ciudad ci        ON cl.id_ciudad  = ci.id_ciudad
    GROUP BY cl.id_cliente, cl.nombre_cliente, cl.tipo_cliente,
             cl.canal_distribucion, ci.nombre_ciudad
)
SELECT
    id_cliente,
    nombre_cliente,
    tipo_cliente,
    canal_distribucion,
    nombre_ciudad,
    ordenes_totales,
    ROUND(revenue_total, 2)             AS revenue_total,
    ROUND(ticket_promedio, 2)           AS ticket_promedio,
    ROUND(revenue_total * 100.0 /
        SUM(revenue_total) OVER (), 2)  AS pct_del_total,
    ROUND(SUM(revenue_total) OVER (
        ORDER BY revenue_total DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) * 100.0 / SUM(revenue_total) OVER (), 2) AS pct_acumulado
FROM revenue_cliente
ORDER BY revenue_total DESC
LIMIT 20;


-- ============================================================
-- CONSULTA 16: ANÁLISIS DE CARTERA VENCIDA DE PROVEEDORES
-- Decisión: ¿Con qué proveedores hay mayor riesgo financiero?
-- Identifica deudas vencidas y pendientes por proveedor.
-- ============================================================
SELECT
    pr.id_proveedor,
    pr.nombre_proveedor,
    ci.nombre_ciudad                                      AS ciudad_proveedor,
    COUNT(oc.id_compra)                                   AS total_ordenes,
    COUNT(CASE WHEN oc.estado_pago = 'pagado'   THEN 1 END) AS ordenes_pagadas,
    COUNT(CASE WHEN oc.estado_pago = 'pendiente' THEN 1 END) AS ordenes_pendientes,
    COUNT(CASE WHEN oc.estado_pago = 'vencido'  THEN 1 END) AS ordenes_vencidas,
    ROUND(SUM(CASE WHEN oc.estado_pago = 'vencido'
                   THEN dc.subtotal ELSE 0 END), 2)       AS monto_vencido,
    ROUND(SUM(CASE WHEN oc.estado_pago = 'pendiente'
                   THEN dc.subtotal ELSE 0 END), 2)       AS monto_pendiente,
    ROUND(SUM(dc.subtotal), 2)                            AS monto_total_compras,
    ROUND(SUM(CASE WHEN oc.estado_pago IN ('vencido','pendiente')
                   THEN dc.subtotal ELSE 0 END) * 100.0
          / NULLIF(SUM(dc.subtotal), 0), 2)               AS pct_cartera_riesgo
FROM proveedor pr
JOIN orden_compra oc   ON pr.id_proveedor  = oc.id_proveedor
JOIN detalle_compra dc ON oc.id_compra     = dc.id_compra
JOIN ciudad ci         ON pr.id_ciudad     = ci.id_ciudad
GROUP BY pr.id_proveedor, pr.nombre_proveedor, ci.nombre_ciudad
ORDER BY monto_vencido DESC;

-- ============================================================
-- CONSULTA 17: PROYECCIÓN DE DÍAS DE STOCK POR PRODUCTO Y PLANTA
-- Decisión: ¿Qué productos se agotarán primero según su demanda real?
-- Usa cantidad_disponible y demanda_diaria para estimar cuántos
-- días de stock le quedan a cada producto por planta.
-- ============================================================
SELECT
    pl.tipo_planta,
    ci.nombre_ciudad,
    p.nombre_producto,
    inv.cantidad_disponible,
    inv.demanda_diaria,
    ROUND(inv.cantidad_disponible::numeric /
        NULLIF(inv.demanda_diaria,0), 1)          AS dias_estimados_stock,
    CASE
        WHEN inv.cantidad_disponible::numeric /
             NULLIF(inv.demanda_diaria,0) <= 0     THEN 'AGOTADO'
        WHEN inv.cantidad_disponible::numeric /
             NULLIF(inv.demanda_diaria,0) < 5       THEN 'CRÍTICO'
        WHEN inv.cantidad_disponible::numeric /
             NULLIF(inv.demanda_diaria,0) <= 15      THEN 'ALERTA'
        ELSE 'SEGURO'
    END AS estado_stock
FROM inventario inv
JOIN planta pl   ON inv.id_planta = pl.id_planta
JOIN ciudad ci   ON pl.id_ciudad  = ci.id_ciudad
JOIN productos p ON inv.id_prod   = p.id_producto
ORDER BY dias_estimados_stock ASC;


-- ============================================================
-- CONSULTA 18: COMPARATIVO DE VENTAS 2023 VS 2024 POR MARCA
-- Decisión: ¿Qué marcas están creciendo y cuáles decreciendo?
-- Permite identificar marcas que necesitan inversión en mercadeo.
-- ============================================================
WITH ventas_anio AS (
    SELECT
        p.marca_id,
        EXTRACT(YEAR FROM ov.fecha_venta) AS anio,
        ROUND(SUM(dv.subtotal), 2)        AS revenue
    FROM orden_venta ov
    JOIN detalle_venta dv ON ov.id_venta  = dv.id_venta
    JOIN productos p      ON dv.id_prod   = p.id_producto
    GROUP BY p.marca_id, EXTRACT(YEAR FROM ov.fecha_venta)
)
SELECT
    m.nombre_marca,
    ROUND(MAX(CASE WHEN anio = 2023 THEN revenue END), 2) AS revenue_2023,
    ROUND(MAX(CASE WHEN anio = 2024 THEN revenue END), 2) AS revenue_2024,
    ROUND(MAX(CASE WHEN anio = 2024 THEN revenue END) -
          MAX(CASE WHEN anio = 2023 THEN revenue END), 2) AS variacion_absoluta,
    ROUND((MAX(CASE WHEN anio = 2024 THEN revenue END) -
           MAX(CASE WHEN anio = 2023 THEN revenue END)) * 100.0 /
          NULLIF(MAX(CASE WHEN anio = 2023 THEN revenue END), 0), 2) AS crecimiento_pct,
    CASE
        WHEN MAX(CASE WHEN anio = 2024 THEN revenue END) >
             MAX(CASE WHEN anio = 2023 THEN revenue END) THEN 'CRECIENDO'
        WHEN MAX(CASE WHEN anio = 2024 THEN revenue END) <
             MAX(CASE WHEN anio = 2023 THEN revenue END) THEN 'DECRECIENDO'
        ELSE 'ESTABLE'
    END AS tendencia
FROM ventas_anio va
JOIN marca m ON va.marca_id = m.id_marca
GROUP BY m.nombre_marca
ORDER BY crecimiento_pct DESC;



-- ============================================================
-- CONSULTA 19: ALERTAS DE INVENTARIO BAJO POR PLANTA
-- Decisión: ¿Qué productos necesitan reabastecimiento urgente?
-- Muestra productos por debajo del stock mínimo por planta.
-- ============================================================

--esta consulta la ejecuto para poder que aproximandamente 1 de cada 7 productos este bajo de stock
--de este modo, el 14-15% estara bajo de stock y la consulta de abajo finalmente tendra resultados
--era necesario, pues al momento de generar los datos sinteticos, todos los productos del inventario
--tenian un stock suficiente para no caer en ninguna categoria baja
--y entonces la consulta antes no mostraba nada.
UPDATE inventario
SET cantidad_disponible = FLOOR(stock_minimo * (0.3 + random() * 0.7))
WHERE id_inventario % 7 = 0;

SELECT
    pl.tipo_planta,
    ci.nombre_ciudad,
    p.nombre_producto,
    c.nombre_categoria,
    inv.cantidad_disponible,
    inv.stock_minimo,
    inv.stock_minimo - inv.cantidad_disponible  AS deficit,
    ROUND(inv.cantidad_disponible * 100.0 /
        NULLIF(inv.stock_minimo, 0), 2)         AS pct_sobre_minimo,
    CASE
        WHEN inv.cantidad_disponible = 0
            THEN 'SIN STOCK'
        WHEN inv.cantidad_disponible < inv.stock_minimo
            THEN 'CRITICO'
        WHEN inv.cantidad_disponible < inv.stock_minimo * 1.2
            THEN 'ALERTA'
        ELSE 'OK'
    END AS estado_inventario,
    inv.fecha_actualizacion
FROM inventario inv
JOIN planta pl    ON inv.id_planta  = pl.id_planta
JOIN ciudad ci    ON pl.id_ciudad   = ci.id_ciudad
JOIN productos p  ON inv.id_prod    = p.id_producto
JOIN categoria c  ON p.cate_id      = c.id_categoria
WHERE inv.cantidad_disponible <= inv.stock_minimo * 1.2
ORDER BY deficit DESC, pl.tipo_planta;




-- ============================================================
-- CONSULTA 20: COSTO LABORAL POR PLANTA Y ÁREA
-- Decisión: ¿Dónde está concentrado el gasto en nómina?
-- Cruza empleados, cargos y plantas para estimar nómina mensual.
-- ============================================================
SELECT
    pl.tipo_planta,
    ci.nombre_ciudad,
    ad.nombre_area,
    COUNT(e.id_empleado)                    AS num_empleados,
    ROUND(SUM(ca.salario_base), 2)          AS nomina_mensual,
    ROUND(AVG(ca.salario_base), 2)          AS salario_promedio,
    MIN(ca.salario_base)                    AS salario_minimo,
    MAX(ca.salario_base)                    AS salario_maximo,
    COUNT(CASE WHEN tc.nombre_tipo_contrato
               = 'termino indefinido' THEN 1 END) AS contratos_indefinidos,
    COUNT(CASE WHEN tc.nombre_tipo_contrato
               = 'termino fijo' THEN 1 END)       AS contratos_fijos,
    ROUND(SUM(ca.salario_base) * 100.0 /
        SUM(SUM(ca.salario_base)) OVER (), 2)      AS pct_nomina_total
FROM empleado e
JOIN planta pl          ON e.id_planta        = pl.id_planta
JOIN ciudad ci          ON pl.id_ciudad       = ci.id_ciudad
JOIN cargo ca           ON e.id_cargo         = ca.id_cargo
JOIN area_departamento ad ON ca.id_area_depto = ad.id_area
JOIN tipo_contrato tc   ON e.id_tipo_contrato = tc.id_tipo_contrato
GROUP BY pl.tipo_planta, ci.nombre_ciudad, ad.nombre_area
ORDER BY nomina_mensual DESC;

-- ============================================================
-- FIN DEL SCRIPT DE CONSULTAS ESTRATÉGICAS — COLOMBINA S.A.
-- ============================================================

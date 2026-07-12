-- =========================================================
-- Parche 007: repoblar columnas nuevas de CLIENTES
-- (agregadas en 002_atributos_faltantes.sql)
-- Proyecto Bases de Datos - Colombina S.A.
--
-- Con 120 clientes ya cargados, en vez de escribir 120 UPDATE
-- individuales se usa una regla basada en columnas que YA
-- existen (id_cliente, tipo_cliente) para generar variabilidad
-- realista sin perder trazabilidad de por qué cada cliente
-- quedó con cada valor.
--
-- Cómo correrlo:
--   psql -U <usuario> -d <base> -f db/schema/007_repoblar_clientes.sql
-- =========================================================

-- 1) Autorización de Habeas Data (Ley 1581 de 2012):
--    la gran mayoría de clientes ya aceptó el tratamiento de
--    datos; se deja un pequeño porcentaje (1 de cada 12) sin
--    autorizar, para que la app tenga casos reales que probar.
UPDATE clientes
SET autorizacion_habeas_data = TRUE;

UPDATE clientes
SET autorizacion_habeas_data = FALSE
WHERE id_cliente % 12 = 0;

-- 2) Representante legal: nombre sintético rotando una lista de
--    12 nombres colombianos (no son personas reales).
UPDATE clientes AS c
SET representante_legal = nombres.nombre
FROM (
    SELECT id_cliente,
           (ARRAY[
               'Andrés Felipe Gómez', 'María Camila Rojas', 'Juan Pablo Castro',
               'Laura Valentina Ríos', 'Carlos Andrés Muñoz', 'Diana Marcela Vargas',
               'Sebastián Torres', 'Paula Andrea Jiménez', 'Jorge Iván Ramírez',
               'Natalia Andrea Cárdenas', 'Felipe Ortiz', 'Camila Andrea Salazar'
           ])[(id_cliente % 12) + 1] AS nombre
    FROM clientes
) AS nombres
WHERE c.id_cliente = nombres.id_cliente;

-- 3) Tipo de régimen tributario: se deriva del tipo_cliente ya
--    cargado (los grandes compradores -mayoristas/distribuidores-
--    suelen ser responsables de IVA; minoristas pequeños, no).
UPDATE clientes
SET tipo_regimen_tributario = 'responsable_iva'
WHERE tipo_cliente IN ('Mayorista', 'Distribuidor', 'Institucional');

UPDATE clientes
SET tipo_regimen_tributario = 'no_responsable_iva'
WHERE tipo_cliente = 'Minorista';



-- =========================================================
-- Parche 006: repoblar columnas nuevas de PROVEEDOR
-- (agregadas en 002_atributos_faltantes.sql)
-- Proyecto Bases de Datos - Colombina S.A.
--
-- Para las personas naturales el RUT es el mismo número que la
-- cédula (según el enunciado); como todos nuestros proveedores
-- son empresas, el RUT coincide con el NIT ya cargado.
--
-- Cómo correrlo:
--   psql -U <usuario> -d <base> -f db/schema/006_repoblar_proveedor.sql
-- =========================================================

UPDATE proveedor SET
    rut             = nit,
    banco           = 'Bancolombia',
    tipo_cuenta     = 'corriente',
    numero_cuenta   = '01' || LPAD((id_proveedor * 7919 % 100000000)::text, 8, '0'),
    condiciones_pago = 30,
    calificacion    = 4
WHERE id_proveedor IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15);

-- Variabilidad intencional (no todos los proveedores son iguales):
-- distintos bancos, condiciones de pago y calificaciones según
-- desempeño histórico simulado.
UPDATE proveedor SET banco = 'Banco de Bogotá'        WHERE id_proveedor IN (2,5,8,11,14);
UPDATE proveedor SET banco = 'Davivienda'              WHERE id_proveedor IN (3,6,9,12,15);
UPDATE proveedor SET tipo_cuenta = 'ahorros'           WHERE id_proveedor IN (2,7,10,13);

UPDATE proveedor SET condiciones_pago = 60             WHERE id_proveedor IN (1,3,6,9,12);
UPDATE proveedor SET condiciones_pago = 45              WHERE id_proveedor IN (4,7,10,13);

UPDATE proveedor SET calificacion = 5                  WHERE id_proveedor IN (1,3,9,10,15);
UPDATE proveedor SET calificacion = 3                  WHERE id_proveedor IN (2,7,13);
UPDATE proveedor SET calificacion = 2                  WHERE id_proveedor IN (8);

-- Verificación rápida
-- SELECT id_proveedor, nombre_proveedor, rut, banco, tipo_cuenta,
--        numero_cuenta, condiciones_pago, calificacion
-- FROM proveedor ORDER BY id_proveedor;

-- =========================================================
-- Parche 009: corregir demanda_diaria <= 0 ya cargada, y
-- agregar restricciones CHECK como respaldo a nivel de BD
-- (además de los validators de Django del Paso 1).
-- =========================================================

-- 1) Arreglar los datos que ya se dañaron (demanda = 0 o negativa)
UPDATE inventario
SET demanda_diaria = 1
WHERE demanda_diaria < 1;

-- 2) Restricciones CHECK a nivel de base de datos (respaldo,
--    por si alguien inserta datos directo por SQL sin pasar
--    por la app web)

ALTER TABLE inventario
    ADD CONSTRAINT chk_demanda_diaria CHECK (demanda_diaria >= 1);

ALTER TABLE detalle_venta
    ADD CONSTRAINT chk_unidades_venta CHECK (unidades >= 1);

ALTER TABLE detalle_compra
    ADD CONSTRAINT chk_cantidad_compra CHECK (cantidad_prods >= 1);

ALTER TABLE inventario
    ADD CONSTRAINT chk_cantidad_disponible CHECK (cantidad_disponible >= 0);

ALTER TABLE inventario
    ADD CONSTRAINT chk_stock_minimo CHECK (stock_minimo >= 0);

-- Verificación rápida
--SELECT * FROM inventario WHERE demanda_diaria < 1;  -- debe salir vacío




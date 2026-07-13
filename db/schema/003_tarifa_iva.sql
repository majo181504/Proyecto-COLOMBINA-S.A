-- =========================================================
-- Parche 003: tarifa de IVA por producto
-- Proyecto Bases de Datos - Grupo 01 - Colombina S.A.
--
-- Los 3 integrantes deben correr este script UNA VEZ en su
-- propia base de datos local.
-- =========================================================

ALTER TABLE "productos" ADD COLUMN "tarifa_iva" varchar(20) NOT NULL DEFAULT 'general';

ALTER TABLE "productos" ADD CONSTRAINT productos_tarifa_iva_check
    CHECK (tarifa_iva IN ('general', 'diferencial', 'exento', 'excluido'));

-- Valores posibles y su significado (según el enunciado):
--   'general'     -> IVA 19% (la mayoría de productos)
--   'diferencial' -> IVA 5%  (canasta básica procesada, insumos agrícolas)
--   'exento'      -> IVA 0%  (tarifa cero, pero SÍ tiene IVA)
--   'excluido'    -> no causa IVA, el sistema no calcula nada
--
-- Todos los productos que ya tenías cargados quedan con 'general' (19%)
-- por defecto. Si Colombina vende productos que realmente son
-- diferencial/exento/excluido, edítalos desde la app (Productos -> Editar)
-- o con un UPDATE manual aquí mismo.

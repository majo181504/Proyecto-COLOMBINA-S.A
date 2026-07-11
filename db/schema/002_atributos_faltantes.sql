-- =========================================================
-- Parche de esquema: atributos faltantes del enunciado
-- Proyecto Bases de Datos - Colombina S.A.
--
-- IMPORTANTE: se debe correr este
-- script UNA VEZ en la base de datos local, en el
-- mismo orden en que aparece aquí. No borra ni modifica datos
-- existentes: solo agrega columnas nuevas (todas nullable o
-- con un valor por defecto, para no romper las filas que ya
-- se tienen cargadas).
--
-- Cómo correrlo:
--   psql -U <usuario> -d <base> -f db_patches/002_atributos_faltantes.sql
-- o desde pgAdmin: Query Tool -> open file -> Ejecutar (F5)
-- =========================================================

-- ---------------------------------------------------------
-- CLIENTES
-- ---------------------------------------------------------
ALTER TABLE "clientes" ADD COLUMN "autorizacion_habeas_data" boolean NOT NULL DEFAULT false;
ALTER TABLE "clientes" ADD COLUMN "representante_legal" varchar(150);

ALTER TABLE "clientes" ADD COLUMN "tipo_regimen_tributario" varchar(50);
ALTER TABLE "clientes" ADD CONSTRAINT cliente_regimen_check
    CHECK (tipo_regimen_tributario IN ('responsable_iva', 'no_responsable_iva')
           OR tipo_regimen_tributario IS NULL);

-- ---------------------------------------------------------
-- PROVEEDOR
-- ---------------------------------------------------------
ALTER TABLE "proveedor" ADD COLUMN "rut" varchar(20);
ALTER TABLE "proveedor" ADD COLUMN "banco" varchar(100);

ALTER TABLE "proveedor" ADD COLUMN "tipo_cuenta" varchar(20);
ALTER TABLE "proveedor" ADD CONSTRAINT proveedor_tipo_cuenta_check
    CHECK (tipo_cuenta IN ('ahorros', 'corriente') OR tipo_cuenta IS NULL);

ALTER TABLE "proveedor" ADD COLUMN "numero_cuenta" varchar(30);
ALTER TABLE "proveedor" ADD COLUMN "condiciones_pago" integer;

ALTER TABLE "proveedor" ADD COLUMN "calificacion" integer;
ALTER TABLE "proveedor" ADD CONSTRAINT proveedor_calificacion_rango
    CHECK (calificacion BETWEEN 1 AND 5 OR calificacion IS NULL);

-- ---------------------------------------------------------
-- INVENTARIO
-- ---------------------------------------------------------
-- Se usa para calcular "días de stock" = cantidad_disponible / demanda_diaria,
-- Se pone DEFAULT 1 (no 0) para evitar
-- división por cero en los cálculos mientras cargan el dato real.
ALTER TABLE "inventario" ADD COLUMN "demanda_diaria" integer NOT NULL DEFAULT 1;

-- ---------------------------------------------------------
-- PRODUCTO
-- ---------------------------------------------------------
-- Se implementa para tener unan "eliminación lógica" de los productos
-- y no borrar un registro físico para no perder los movimientos históricos
-- de inventario.
ALTER TABLE "productos" ADD COLUMN "estado" boolean NOT NULL DEFAULT true;

-- =========================================================
-- Fin del script
-- =========================================================

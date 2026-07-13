-- =========================================================
-- Parche 010: tabla inventario_insumo
-- Registra el inventario de MATERIAS PRIMAS por PROVEEDOR,
-- tal como lo pide el enunciado (Proveedor | Insumo |
-- Inventario actual | Demanda diaria).
-- =========================================================

CREATE TABLE inventario_materia_prima (
    id_inventario_materia_prima integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_proveedor integer NOT NULL,
    id_materia integer NOT NULL,
    cantidad_disponible integer NOT NULL CHECK (cantidad_disponible >= 0),
    demanda_diaria integer NOT NULL DEFAULT 1 CHECK (demanda_diaria >= 1),
    fecha_actualizacion timestamp NOT NULL DEFAULT now(),
    CONSTRAINT fk_inv_materia_proveedor FOREIGN KEY (id_proveedor)
        REFERENCES proveedor (id_proveedor)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_inv__materia_materia FOREIGN KEY (id_materia)
        REFERENCES materia_prima (id_materia)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_inv_materia_proveedor_materia UNIQUE (id_proveedor, id_materia)
);

-- Se puebla automáticamente a partir de las combinaciones que
-- YA existen en proveedor_materia (cada proveedor que vende
-- una materia prima, ahora también tiene su inventario).
INSERT INTO inventario_materia_prima (id_proveedor, id_materia, cantidad_disponible, demanda_diaria, fecha_actualizacion)
SELECT
    id_proveedor,
    id_materia,
    ((id_proveedor * 37 + id_materia * 13) % 500) + 20 AS cantidad_disponible,
    ((id_materia % 15) + 1) AS demanda_diaria,
    now()
FROM proveedor_materia;

-- Verificación rápida
-- SELECT * FROM inventario_materia_prima ORDER BY id_proveedor, id_materia;

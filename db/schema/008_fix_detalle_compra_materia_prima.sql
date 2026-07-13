ALTER TABLE detalle_compra ADD COLUMN id_materia integer;

UPDATE detalle_compra
SET id_materia = ((id_prod - 1) % 20) + 1;

ALTER TABLE detalle_compra ALTER COLUMN id_materia SET NOT NULL;

ALTER TABLE detalle_compra DROP CONSTRAINT fk4;
ALTER TABLE detalle_compra DROP COLUMN id_prod;

ALTER TABLE detalle_compra
    ADD CONSTRAINT fk4_materia FOREIGN KEY (id_materia)
    REFERENCES materia_prima (id_materia)
    ON DELETE RESTRICT ON UPDATE CASCADE;



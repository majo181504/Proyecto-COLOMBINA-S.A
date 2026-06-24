
-- PARTE 1: TABLAS MAESTRAS

-- PAIS
INSERT INTO pais (id_pais, nombre_pais) VALUES
(1,'Colombia'),
(2,'Ecuador'),
(3,'Peru'),
(4,'Chile'),
(5,'Guatemala');

-- CIUDAD
INSERT INTO ciudad (id_ciudad, nombre_ciudad, id_pais) VALUES
(1,'Cali',1),
(2,'Bogota',1),
(3,'Medellin',1),
(4,'Barranquilla',1),
(5,'Cartagena',1),
(6,'Bucaramanga',1),
(7,'Pereira',1),
(8,'Manizales',1),
(9,'Pasto',1),
(10,'Villavicencio',1),
(11,'Quito',2),
(12,'Guayaquil',2),
(13,'Lima',3),
(14,'Arequipa',3),
(15,'Santiago',4),
(16,'Valparaiso',4),
(17,'Ciudad de Guatemala',5),
(18,'Mixco',5),
(19,'Palmira',1),
(20,'Yumbo',1);

-- CATEGORIA
INSERT INTO categoria (id_categoria, nombre_categoria, descripcion) VALUES
(1,'Confiteria','Dulces, caramelos y chupetas'),
(2,'Chocolates','Productos a base de chocolate'),
(3,'Galletas','Galletas dulces y saladas'),
(4,'Snacks','Pasabocas y productos para compartir'),
(5,'Bebidas','Bebidas listas para consumir'),
(6,'Salsas','Salsas y aderezos'),
(7,'Reposteria','Ingredientes para reposteria'),
(8,'Helados','Productos congelados');

-- MARCA
INSERT INTO marca (id_marca, nombre_marca, descripcion) VALUES
(1,'Bon Bon Bum','Linea de chupetas y confites'),
(2,'Nucita','Cremas y dulces de chocolate'),
(3,'Coffee Delight','Caramelos sabor cafe'),
(4,'Grissly','Galletas y snacks'),
(5,'Bridge','Confiteria premium'),
(6,'Colombina 100%','Chocolates y confites'),
(7,'Crakeñas','Galletas saladas'),
(8,'Muu','Productos sabor leche'),
(9,'Fizz','Caramelos efervescentes'),
(10,'LatteMoo','Linea sabor lacteo');

-- TIPO_CONTRATO
INSERT INTO tipo_contrato (id_tipo_contrato, nombre_tipo_contrato, descripcion) VALUES
(1,'termino indefinido','Contrato permanente'),
(2,'termino fijo','Contrato por tiempo determinado'),
(3,'por obra o labor','Vinculado a un proyecto'),
(4,'prestacion de servicios','Contrato civil'),
(5,'de aprendizaje','Aprendiz SENA'),
(6,'ocasional','Necesidad temporal');

-- AREA_DEPARTAMENTO
INSERT INTO area_departamento (id_area, nombre_area) VALUES
(1,'Produccion'),
(2,'Logistica'),
(3,'Compras'),
(4,'Ventas'),
(5,'Mercadeo'),
(6,'Finanzas'),
(7,'Recursos Humanos'),
(8,'Calidad');

-- MATERIA_PRIMA
INSERT INTO materia_prima (id_materia, nombre, unidad_medida) VALUES
(1,'Azucar','kg'),
(2,'Cacao','kg'),
(3,'Leche en polvo','kg'),
(4,'Glucosa','kg'),
(5,'Gelatina','kg'),
(6,'Colorante rojo','kg'),
(7,'Colorante amarillo','kg'),
(8,'Saborizante fresa','L'),
(9,'Saborizante uva','L'),
(10,'Saborizante mango','L'),
(11,'Harina de trigo','kg'),
(12,'Aceite vegetal','L'),
(13,'Sal refinada','kg'),
(14,'Empaque plastico','unidad'),
(15,'Palitos para chupeta','unidad');

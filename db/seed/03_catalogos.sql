-- 4. CATEGORIA — 9 categorias reales del sitio web
INSERT INTO categoria (id_categoria, nombre_categoria, descripcion) VALUES
(1,'Dulces','Caramelos duros, chicles, gomitas, masmelos y dulces en general'),
(2,'Chocolateria','Chocolates, bombones, cremas de chocolate y productos derivados del cacao'),
(3,'Galleteria','Galletas dulces, saladas, waffers, barquillos y pasteles'),
(4,'Helados','Paletas de agua y leche, conos, vasos, postres y opciones de scooping'),
(5,'Salsas y Aderezos','Salsas, conservas, postres de leche, compotas y mermeladas'),
(6,'Cafe','Cafe molido, instantaneo y mezclas bajo la marca Cafe Buendia'),
(7,'Snacks','Pasabocas, papas, maiz pira y snacks salados'),
(8,'Enlatados de Pescado','Atun, sardinas y conservas de pescado marca Van Camps'),
(9,'Temporada','Productos especiales para fechas como Navidad, Halloween y San Valentin');

-- 5. MARCA — marcas reales de colombina.com
INSERT INTO marca (id_marca, nombre_marca, descripcion) VALUES
(1,'Bon Bon Bum','Paleta y dulces iconicos de Colombia, la marca mas reconocida de Colombina'),
(2,'Nucita','Cremas de chocolate y avellana, barquillos y chocolates icono de la infancia'),
(3,'Festival','Galletas dulces y saladas, la galleta mas vendida de Colombia'),
(4,'La Constancia','Salsas, conservas, mermeladas y aderezos de alta calidad'),
(5,'Cafe Buendia','Cafe colombiano de alta calidad, molido e instantaneo'),
(6,'Van Camps','Atun y enlatados de pescado de alto consumo masivo'),
(7,'Choco Break','Chocolates con waffer y leche, alternativa premium'),
(8,'Grissly','Dulces y gomitas de diferentes sabores y presentaciones'),
(9,'Crakenas','Galletas saladas crocantes, snack para cualquier momento'),
(10,'Snacky','Pasabocas y snacks salados de alto consumo'),
(11,'Pirulito','Paletas de diferentes sabores para el publico infantil'),
(12,'Fruly','Dulces y gomitas con sabores frutales intensos'),
(13,'Millows','Masmelos y dulces esponjosos en variedad de sabores'),
(14,'Colombina','Marca paraguas con productos de confiteria premium'),
(15,'Chocmelos','Masmelos bañados en chocolate, producto unico del portafolio');

-- 7. AREA_DEPARTAMENTO
INSERT INTO area_departamento (id_area, nombre_area) VALUES
(1,'Produccion'),
(2,'Logistica y Distribucion'),
(3,'Ventas y Comercial'),
(4,'Recursos Humanos'),
(5,'Finanzas y Contabilidad'),
(6,'Calidad e Inocuidad'),
(7,'Tecnologia e Innovacion'),
(8,'Mercadeo'),
(9,'Compras y Abastecimiento'),
(10,'Gerencia General');

-- 8. CARGO
INSERT INTO cargo (id_cargo, nombre_cargo, salario_base, id_area_depto) VALUES
(1,'Operario de Produccion',1900000,1),
(2,'Tecnico de Mantenimiento',2400000,1),
(3,'Supervisor de Produccion',3800000,1),
(4,'Jefe de Planta',6500000,1),
(5,'Conductor de Reparto',2200000,2),
(6,'Coordinador Logistico',3500000,2),
(7,'Jefe de Bodega',4200000,2),
(8,'Asesor Comercial',2800000,3),
(9,'Gerente de Ventas Regional',8500000,3),
(10,'Director Comercial',14000000,3),
(11,'Analista de RRHH',3000000,4),
(12,'Contador',3800000,5),
(13,'Inspector de Calidad',2900000,6),
(14,'Desarrollador de Software',5500000,7),
(15,'Analista de Mercadeo',3200000,8),
(16,'Jefe de Compras',5000000,9),
(17,'Gerente General',18000000,10),
(18,'Auxiliar Administrativo',2000000,4),
(19,'Analista de Datos',4500000,7),
(20,'Coordinador de Calidad',4000000,6);

-- 9. TIPO_CONTRATO
INSERT INTO tipo_contrato (id_tipo_contrato, nombre_tipo_contrato, descripcion) VALUES
(1,'termino indefinido','Contrato sin fecha de terminacion definida, brinda mayor estabilidad laboral y plenas prestaciones sociales'),
(2,'termino fijo','Contrato con fecha de terminacion pactada entre 1 mes y 3 anos, renovable segun necesidad'),
(3,'por obra o labor','Contrato vigente durante la ejecucion de una obra o labor especifica, sin fecha exacta de finalizacion'),
(4,'prestacion de servicios','Vinculacion como contratista independiente, sin subordinacion ni prestaciones sociales de ley'),
(5,'de aprendizaje','Contrato para estudiantes del SENA en etapa productiva, con apoyo de sostenimiento'),
(6,'ocasional','Contrato para actividades esporadicas o accidentales no superiores a 30 dias continuos');
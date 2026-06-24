
-- PARTE 2: EMPRESA, CARGOS, PLANTAS, PROVEEDORES, PROVEEDOR_MATERIA Y PRODUCTOS

-- EMPRESA
INSERT INTO empresa (id_empresa, nombre_empresa, nit) VALUES
(1, 'Colombina S.A.', '890301234-5');

-- CARGOS
INSERT INTO cargo (id_cargo, nombre_cargo, salario_base, id_area_depto) VALUES
(1,'Operario de Produccion',1800000,1),
(2,'Supervisor de Produccion',3200000,1),
(3,'Analista de Compras',2800000,3),
(4,'Jefe de Compras',4500000,3),
(5,'Analista Logistico',2900000,2),
(6,'Coordinador Logistico',4200000,2),
(7,'Ejecutivo Comercial',3000000,4),
(8,'Gerente Comercial',7000000,4),
(9,'Analista de Calidad',3100000,8),
(10,'Jefe de Recursos Humanos',5000000,7);

-- PLANTAS
INSERT INTO planta (id_planta, tipo_planta, id_ciudad, direccion, id_empresa) VALUES
(1,'Produccion de Confiteria',20,'Zona Industrial Acopi',1),
(2,'Produccion de Chocolates',1,'Via Jamundi',1),
(3,'Centro de Distribucion',2,'Zona Industrial Fontibon',1),
(4,'Empaque y Logistica',19,'Parque Industrial Palmira',1),
(5,'Exportaciones',4,'Zona Franca Barranquilla',1);

-- PROVEEDORES
INSERT INTO proveedor (id_proveedor,nit,nombre_proveedor,telefono,email,direccion,id_ciudad) VALUES
(1,'900100001-1','Azucares del Valle','6021111111','contacto@azucarvalle.com','Yumbo Industrial',20),
(2,'900100002-2','Cacaos Andinos','6012222222','ventas@cacaosandinos.com','Zona Industrial',2),
(3,'900100003-3','Empaques Flexibles SAS','6043333333','info@flexibles.com','Parque Industrial',3),
(4,'900100004-4','Sabores Tropicales SAS','6024444444','contacto@saborestrop.com','Zona Empresarial',1),
(5,'900100005-5','Lacteos del Pacifico','6025555555','ventas@lacteospacifico.com','Zona Industrial',19),
(6,'900100006-6','Harinas Nacionales','6016666666','info@harinas.com','Montevideo',2),
(7,'900100007-7','Aceites Colombia','6077777777','ventas@aceitesco.com','Zona Industrial',6),
(8,'900100008-8','Colorantes Alimenticios SAS','6048888888','info@colorantes.com','Sector Industrial',3),
(9,'900100009-9','Insumos Alimentarios SA','6029999999','ventas@insumos.com','Yumbo',20),
(10,'900100010-0','Materias Primas Integradas','6011234567','contacto@mpi.com','Bogota',2);

-- PROVEEDOR_MATERIA
INSERT INTO proveedor_materia
(id_proveedor_materia,id_proveedor,id_materia,precio_unitario,cantidad_minima)
VALUES
(1,1,1,4200,1000),
(2,2,2,18500,500),
(3,5,3,15800,300),
(4,1,4,5100,500),
(5,4,8,22000,100),
(6,4,9,22000,100),
(7,4,10,21500,100),
(8,6,11,3500,1000),
(9,7,12,8900,500),
(10,3,14,250,10000),
(11,8,6,32000,50),
(12,8,7,31500,50),
(13,9,5,12000,200),
(14,10,13,1800,1000),
(15,9,15,90,50000);

-- PRODUCTOS
INSERT INTO productos
(id_producto,nombre_producto,cate_id,marca_id,peso,unidad_medida,precio,sabor)
VALUES
(1,'Bon Bon Bum Fresa',1,1,24.00,'g',500,'Fresa'),
(2,'Bon Bon Bum Mora',1,1,24.00,'g',500,'Mora'),
(3,'Bon Bon Bum Sandia',1,1,24.00,'g',500,'Sandia'),
(4,'Bon Bon Bum Mango',1,1,24.00,'g',500,'Mango'),
(5,'Bon Bon Bum Chicle',1,1,24.00,'g',550,'Frutal'),
(6,'Coffee Delight Original',1,3,18.00,'g',450,'Cafe'),
(7,'Coffee Delight Capuccino',1,3,18.00,'g',500,'Capuccino'),
(8,'Bridge Menta',1,5,20.00,'g',600,'Menta'),
(9,'Bridge Hierbabuena',1,5,20.00,'g',600,'Hierbabuena'),
(10,'Fizz Limon',1,9,15.00,'g',400,'Limon'),
(11,'Fizz Naranja',1,9,15.00,'g',400,'Naranja'),
(12,'Nucita Clasica',2,2,45.00,'g',1800,'Chocolate'),
(13,'Nucita Duo',2,2,45.00,'g',1900,'Chocolate Vainilla'),
(14,'Nucita Avellana',2,2,50.00,'g',2200,'Avellana'),
(15,'Chocolate Colombina Leche',2,6,80.00,'g',3500,'Leche'),
(16,'Chocolate Colombina Amargo',2,6,80.00,'g',3800,'Amargo'),
(17,'Chocolate Colombina Almendras',2,6,90.00,'g',4200,'Almendras'),
(18,'Grissly Chocolate',3,4,40.00,'g',1200,'Chocolate'),
(19,'Grissly Vainilla',3,4,40.00,'g',1200,'Vainilla'),
(20,'Grissly Fresa',3,4,40.00,'g',1200,'Fresa'),
(21,'Crakeñas Original',3,7,110.00,'g',2500,'Salado'),
(22,'Crakeñas Integral',3,7,110.00,'g',2700,'Integral'),
(23,'Crakeñas Queso',3,7,110.00,'g',2800,'Queso'),
(24,'Muu Caramelo',1,8,20.00,'g',450,'Caramelo'),
(25,'Muu Leche',1,8,20.00,'g',450,'Leche'),
(26,'Bon Bon Bum Explosivo',1,1,24.00,'g',650,'Frutal'),
(27,'Bon Bon Bum Uva',1,1,24.00,'g',500,'Uva'),
(28,'Bon Bon Bum Maracuya',1,1,24.00,'g',500,'Maracuya'),
(29,'Bridge Frutos Rojos',1,5,20.00,'g',650,'Frutos Rojos'),
(30,'Coffee Delight Intenso',1,3,18.00,'g',500,'Cafe'),
(31,'Chocolate Colombina Blanco',2,6,80.00,'g',3600,'Blanco'),
(32,'Nucita Cookies',2,2,50.00,'g',2300,'Galleta'),
(33,'Grissly Coco',3,4,40.00,'g',1300,'Coco'),
(34,'Crakeñas Ajonjoli',3,7,110.00,'g',2900,'Ajonjoli'),
(35,'Fizz Uva',1,9,15.00,'g',400,'Uva'),
(36,'Fizz Frambuesa',1,9,15.00,'g',420,'Frambuesa'),
(37,'Bon Bon Bum Blueberry',1,1,24.00,'g',550,'Blueberry'),
(38,'Bon Bon Bum Tropical',1,1,24.00,'g',550,'Tropical'),
(39,'Bridge Eucalipto',1,5,20.00,'g',650,'Eucalipto'),
(40,'Coffee Delight Latte',1,3,18.00,'g',520,'Latte'),
(41,'Chocolate Colombina Mani',2,6,90.00,'g',4000,'Mani'),
(42,'Nucita Max',2,2,55.00,'g',2500,'Chocolate'),
(43,'Grissly Chips',3,4,45.00,'g',1400,'Chocolate'),
(44,'Crakeñas Semillas',3,7,120.00,'g',3100,'Semillas'),
(45,'Muu Toffee',1,8,20.00,'g',480,'Toffee'),
(46,'Bon Bon Bum Mini',1,1,12.00,'g',300,'Frutal'),
(47,'Bon Bon Bum Festival',1,1,24.00,'g',600,'Frutal'),
(48,'Chocolate Colombina Premium',2,6,100.00,'g',5000,'Premium'),
(49,'Nucita Snack',2,2,35.00,'g',1600,'Chocolate'),
(50,'Grissly Clasica',3,4,40.00,'g',1200,'Vainilla');

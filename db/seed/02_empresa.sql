-- 1. EMPRESA
INSERT INTO empresa (id_empresa, nombre_empresa, nit) VALUES
(1, 'Colombina S.A.', '860002534-1');

-- 10. PLANTA — 7 plantas reales de Colombina S.A.
INSERT INTO planta (id_planta, tipo_planta, id_ciudad, direccion, id_empresa) VALUES
(1,'Planta de Confiteria',11,'Corregimiento La Paila, Zarzal Valle del Cauca',1),
(2,'Planta de Galletas y Pasteles',12,'Zona Franca Santander de Quilichao Cauca',1),
(3,'Planta de Salsas y Conservas',13,'Av. El Porvenir Km 3 Tulua Valle',1),
(4,'Planta de Helados Itagui',14,'Calle 77 Sur No. 43-220 Itagui Antioquia',1),
(5,'Planta de Helados Bogota',1,'Av. Boyaca No. 22-60 Sur Bogota',1),
(6,'Planta Confiteria Guatemala',16,'Km 22.5 Carretera al Atlantico Guatemala',1),
(7,'Planta Confiteria Espana FIESTA',17,'Poligono Industrial Los Olivos Alcala de Henares',1);
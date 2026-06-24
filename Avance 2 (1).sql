CREATE TABLE "productos" (
  "id_producto" integer PRIMARY KEY,
  "nombre_producto" varchar(200) NOT NULL,
  "cate_id" integer NOT NULL,
  "marca_id" integer NOT NULL,
  "peso" decimal(5,2) NOT NULL,
  "unidad_medida" varchar(10) NOT NULL,
  "precio" NUMERIC(10,2) NOT NULL,
  "sabor" varchar
);

CREATE TABLE "categoria" (
  "id_categoria" integer PRIMARY KEY,
  "nombre_categoria" varchar(90) NOT NULL,
  "descripcion" varchar(500) NOT NULL
);

CREATE TABLE "marca" (
  "id_marca" integer PRIMARY KEY,
  "nombre_marca" varchar(200) NOT NULL,
  "descripcion" varchar(500) NOT NULL
);

CREATE TABLE "pais" (
"id_pais" SERIAL PRIMARY KEY,
"nombre_pais" varchar(80) NOT NULL
); 

CREATE TABLE "ciudad" (
"id_ciudad" integer PRIMARY KEY,
"nombre_ciudad" varchar(80) NOT NULL,
"id_pais" integer NOT NULL 
);

CREATE TABLE "clientes" (
  "id_cliente" integer PRIMARY KEY,
  "nit" varchar(20) UNIQUE NOT NULL,
  "nombre_cliente" varchar(150) NOT NULL,
  "tipo_cliente" varchar(50) NOT NULL,
  "canal_distribucion" varchar(50) NOT NULL,
  "direccion" varchar(150) NOT NULL,
  "id_ciudad" integer NOT NULL, 
  "telefono" varchar(20) NOT NULL,
  "email" varchar(100) NOT NULL,
  "credito_autorizado" boolean NOT NULL
);

CREATE TABLE "proveedor" (
  "id_proveedor" integer PRIMARY KEY,
  "nit" varchar(20) UNIQUE NOT NULL,
  "nombre_proveedor" varchar(150) NOT NULL,
  "telefono" varchar(20) NOT NULL,
  "email" varchar(100) NOT NULL,
  "direccion" varchar(150) NOT NULL,
  "id_ciudad" integer NOT NULL 
);

CREATE TABLE "orden_compra" (
  "id_compra" SERIAL PRIMARY KEY,
  "id_proveedor" integer NOT NULL,
  "fecha_compra" timestamp NOT NULL,
  
  "estado_pago" varchar(20) NOT NULL,
  CONSTRAINT estado CHECK (estado_pago IN ('pendiente', 
  'pagado', 'vencido')),
  
  "fecha_vencimiento" timestamp NOT NULL,
  "fecha_pago" timestamp NULL
);

CREATE TABLE "detalle_compra" (
  "id_detalle_compra" SERIAL PRIMARY KEY,
  "id_compra" integer NOT NULL,
  "id_prod" integer NOT NULL,
  "cantidad_prods" integer NOT NULL,
  "precio_historico" NUMERIC NOT NULL,
  "subtotal" NUMERIC NOT NULL
);

CREATE TABLE "orden_venta" (
  "id_venta" SERIAL PRIMARY KEY,
  "id_cliente" integer NOT NULL,
  "fecha_venta" timestamp NOT NULL
);

CREATE TABLE "detalle_venta" (
  "id_detalle_venta" SERIAL PRIMARY KEY,
  "id_venta" integer NOT NULL,
  "id_prod" integer NOT NULL,
  "unidades" integer NOT NULL,
  "precio_historico" NUMERIC NOT NULL,
  "subtotal" NUMERIC NOT NULL
);

CREATE TABLE "planta" (
  "id_planta" INTEGER PRIMARY KEY,
  "tipo_planta" varchar(200) NOT NULL,
  "id_ciudad" integer NOT NULL, 
  "direccion" varchar(100) NOT NULL,
  "id_empresa" integer NOT NULL
);

CREATE TABLE "inventario" (
  "id_inventario" SERIAL PRIMARY KEY,
  "id_planta" integer NOT NULL,
  "id_prod" integer NOT NULL,
  "cantidad_disponible" integer NOT NULL,
  "stock_minimo" integer NOT NULL,
  "fecha_actualizacion" timestamp NOT NULL
);

CREATE TABLE "empleado" (
  "id_empleado" integer PRIMARY KEY,
  "cedula" varchar(20) UNIQUE NOT NULL,
  "nombre_empleado" varchar(150) NOT NULL,
  "apellido_empleado" varchar(150) NOT NULL,
  "numero_telefonico" varchar(20) NOT NULL,
  "email_corporativo" varchar(150) NOT NULL,
  "fecha_ingreso" date NOT NULL,
  "id_cargo" integer NOT NULL,
  "id_tipo_contrato" integer NOT NULL,
  "id_planta" integer NOT NULL
);

CREATE TABLE "cargo" (
  "id_cargo" integer PRIMARY KEY,
  "nombre_cargo" varchar(50) NOT NULL,
  "salario_base" decimal NOT NULL,
  "id_area_depto" integer NOT NULL
);

CREATE TABLE "area_departamento" (
"id_area" SERIAL PRIMARY KEY,
"nombre_area" varchar(150) NOT NULL
);

CREATE TABLE "tipo_contrato" (
  "id_tipo_contrato" integer PRIMARY KEY,
  
  "nombre_tipo_contrato" varchar(50) NOT NULL,
  CONSTRAINT tipos_contrato CHECK (nombre_tipo_contrato IN('termino indefinido', 'termino fijo', 
  'por obra o labor', 'prestacion de servicios', 'de aprendizaje', 'ocasional')),
  
  "descripcion" varchar(500) NOT NULL
);

CREATE TABLE "accionista" (
  "id_accionista" integer PRIMARY KEY,
  "nombre" varchar(150) NOT NULL,
  "nit" varchar(20) NOT NULL,
  
  "tipo_accionista" varchar(50) NOT NULL,
  CONSTRAINT tipos_accionistas CHECK (tipo_accionista IN ('controlantes', 'fideicomisos',
  'institucionales y fondos de inversion', 'minoritarios/personas naturales')),
  
  "nacionalidad" varchar(50) NOT NULL,
  "id_empresa" integer NOT NULL,
  
  "acciones" integer NOT NULL,
  
  "porcentaje_participacion" decimal(5,2) NOT NULL,
  CONSTRAINT participacion_rango CHECK (porcentaje_participacion>0 
  AND porcentaje_participacion <= 100)
);

CREATE TABLE "materia_prima" (
  "id_materia" integer PRIMARY KEY,
  "nombre" varchar(200) NOT NULL,
  "unidad_medida" varchar(20) NOT NULL
  );

CREATE TABLE "proveedor_materia" (
  "id_proveedor_materia" integer PRIMARY KEY,
  "id_proveedor" integer NOT NULL,
  "id_materia" integer NOT NULL,
  "precio_unitario" numeric(10,2) NOT NULL,
  "cantidad_minima" integer NOT NULL,

  CONSTRAINT prov_materia UNIQUE (id_proveedor,id_materia)
);

CREATE TABLE "empresa" (
"id_empresa" integer PRIMARY KEY,
"nombre_empresa" varchar(150) NOT NULL,
"nit" varchar(20) NOT NULL
);

ALTER TABLE "productos" ADD CONSTRAINT fk1 FOREIGN KEY ("cate_id") REFERENCES "categoria" ("id_categoria") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "productos" ADD CONSTRAINT fk2 FOREIGN KEY ("marca_id") REFERENCES "marca" ("id_marca") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "orden_compra" ADD CONSTRAINT fk3 FOREIGN KEY ("id_proveedor") REFERENCES "proveedor" ("id_proveedor") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "detalle_compra" ADD CONSTRAINT fk4 FOREIGN KEY ("id_prod") REFERENCES "productos" ("id_producto") ON DELETE RESTRICT ON UPDATE CASCADE; --cambio

ALTER TABLE "detalle_compra" ADD CONSTRAINT fk5 FOREIGN KEY ("id_compra") REFERENCES "orden_compra" ("id_compra") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "orden_venta" ADD CONSTRAINT fk6 FOREIGN KEY ("id_cliente") REFERENCES "clientes" ("id_cliente") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "detalle_venta" ADD CONSTRAINT fk7 FOREIGN KEY ("id_prod") REFERENCES "productos" ("id_producto") ON DELETE RESTRICT ON UPDATE CASCADE; --cambio

ALTER TABLE "detalle_venta" ADD CONSTRAINT fk8 FOREIGN KEY ("id_venta") REFERENCES "orden_venta" ("id_venta") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inventario" ADD CONSTRAINT fk9 FOREIGN KEY ("id_planta") REFERENCES "planta" ("id_planta") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inventario" ADD CONSTRAINT fk10 FOREIGN KEY ("id_prod") REFERENCES "productos" ("id_producto") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "empleado" ADD CONSTRAINT fk11 FOREIGN KEY ("id_tipo_contrato") REFERENCES "tipo_contrato" ("id_tipo_contrato") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "empleado" ADD CONSTRAINT fk12 FOREIGN KEY ("id_cargo") REFERENCES "cargo" ("id_cargo") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "empleado" ADD CONSTRAINT fk13 FOREIGN KEY ("id_planta") REFERENCES "planta" ("id_planta") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "proveedor_materia" ADD CONSTRAINT fk14 FOREIGN KEY ("id_materia") REFERENCES "materia_prima" ("id_materia") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "proveedor_materia" ADD CONSTRAINT fk15 FOREIGN KEY ("id_proveedor") REFERENCES "proveedor" ("id_proveedor") ON DELETE RESTRICT ON UPDATE CASCADE; --cambio

ALTER TABLE "ciudad" ADD CONSTRAINT fk16 FOREIGN KEY ("id_pais") REFERENCES "pais" ("id_pais") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "clientes" ADD CONSTRAINT fk17 FOREIGN KEY ("id_ciudad") REFERENCES "ciudad" ("id_ciudad") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "proveedor" ADD CONSTRAINT fk18 FOREIGN KEY ("id_ciudad") REFERENCES "ciudad" ("id_ciudad") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "planta" ADD CONSTRAINT fk19 FOREIGN KEY ("id_ciudad") REFERENCES "ciudad" ("id_ciudad") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "cargo" ADD CONSTRAINT fk20 FOREIGN KEY ("id_area_depto") REFERENCES "area_departamento" ("id_area") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "accionista" ADD CONSTRAINT fk21 FOREIGN KEY ("id_empresa") REFERENCES "empresa" ("id_empresa") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "planta" ADD CONSTRAINT fk22 FOREIGN KEY ("id_empresa") REFERENCES "empresa" ("id_empresa") ON DELETE RESTRICT ON UPDATE CASCADE;

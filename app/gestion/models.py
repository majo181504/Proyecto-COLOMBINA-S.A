from django.db import models
from django.core.validators import MinValueValidator, MaxValueValidator

# =========================================================
#  TABLAS DE APOYO / CATÁLOGO (necesarias para los selects
#  desplegables que pide el enunciado)
# =========================================================

class Pais(models.Model):
    id_pais = models.AutoField(primary_key=True)
    nombre_pais = models.CharField(max_length=80)

    class Meta:
        managed = False
        db_table = "pais"

    def __str__(self):
        return self.nombre_pais


class Ciudad(models.Model):
    id_ciudad = models.IntegerField(primary_key=True)
    nombre_ciudad = models.CharField(max_length=80)
    id_pais = models.ForeignKey(
        Pais, on_delete=models.RESTRICT, db_column="id_pais"
    )

    class Meta:
        managed = False
        db_table = "ciudad"

    def __str__(self):
        return self.nombre_ciudad


class Categoria(models.Model):
    id_categoria = models.IntegerField(primary_key=True)
    nombre_categoria = models.CharField(max_length=90)
    descripcion = models.CharField(max_length=500)

    class Meta:
        managed = False
        db_table = "categoria"

    def __str__(self):
        return self.nombre_categoria


class Marca(models.Model):
    id_marca = models.IntegerField(primary_key=True)
    nombre_marca = models.CharField(max_length=200)
    descripcion = models.CharField(max_length=500)

    class Meta:
        managed = False
        db_table = "marca"

    def __str__(self):
        return self.nombre_marca


class Empresa(models.Model):
    id_empresa = models.IntegerField(primary_key=True)
    nombre_empresa = models.CharField(max_length=150)
    nit = models.CharField(max_length=20)

    class Meta:
        managed = False
        db_table = "empresa"

    def __str__(self):
        return self.nombre_empresa


class Planta(models.Model):
    id_planta = models.IntegerField(primary_key=True)
    tipo_planta = models.CharField(max_length=200)
    id_ciudad = models.ForeignKey(
        Ciudad, on_delete=models.RESTRICT, db_column="id_ciudad"
    )
    direccion = models.CharField(max_length=100)
    id_empresa = models.ForeignKey(
        Empresa, on_delete=models.RESTRICT, db_column="id_empresa"
    )

    class Meta:
        managed = False
        db_table = "planta"

    def __str__(self):
        return f"{self.tipo_planta} - {self.direccion}"


class MateriaPrima(models.Model):
    id_materia = models.IntegerField(primary_key=True)
    nombre = models.CharField(max_length=200)
    unidad_medida = models.CharField(max_length=20)

    class Meta:
        managed = False
        db_table = "materia_prima"

    def __str__(self):
        return self.nombre


# =========================================================
#  ENTIDAD: PRODUCTOS  (mapea a "Productos/Insumos")
# =========================================================

class Producto(models.Model):
    TARIFA_IVA_CHOICES = [
        ("general", "General (19%)"),
        ("diferencial", "Diferencial (5%)"),
        ("exento", "Exento (0%, pero SÍ tiene IVA)"),
        ("excluido", "Excluido (no se calcula IVA)"),
    ]
    PORCENTAJE_POR_TARIFA = {
        "general": 19,
        "diferencial": 5,
        "exento": 0,
        "excluido": None,
    }

    id_producto = models.IntegerField(primary_key=True)
    nombre_producto = models.CharField(max_length=200)
    cate_id = models.ForeignKey(
        Categoria, on_delete=models.RESTRICT, db_column="cate_id"
    )
    marca_id = models.ForeignKey(
        Marca, on_delete=models.RESTRICT, db_column="marca_id"
    )
    peso = models.DecimalField(max_digits=5, decimal_places=2)
    unidad_medida = models.CharField(max_length=10)
    precio = models.DecimalField(max_digits=10, decimal_places=2)
    sabor = models.CharField(max_length=255, null=True, blank=True)
    tarifa_iva = models.CharField(
        max_length=20, choices=TARIFA_IVA_CHOICES, default="general",
        verbose_name="Tarifa de IVA",
    )
    activo = models.BooleanField(
        default=True,
        db_column="estado",
        verbose_name="Activo",
        help_text="Los productos inactivos no se borran físicamente, "
                   "solo se ocultan, para no perder el histórico.",
    )

    class Meta:
        managed = False
        db_table = "productos"

    def __str__(self):
        return self.nombre_producto

    @property
    def porcentaje_iva(self):
        """None significa 'excluido': el sistema no calcula IVA."""
        return self.PORCENTAJE_POR_TARIFA[self.tarifa_iva]

    @property
    def valor_iva(self):
        """Cuánto IVA se le suma al precio base de este producto."""
        pct = self.porcentaje_iva
        if pct is None:
            return 0
        return round(self.precio * pct / 100, 2)

    @property
    def precio_con_iva(self):
        """Precio final que paga el cliente (precio base + IVA)."""
        return self.precio + self.valor_iva


# =========================================================
#  ENTIDAD: CLIENTES
# =========================================================

class Cliente(models.Model):
    REGIMEN_CHOICES = [
        ("responsable_iva", "Responsable de IVA (Ordinario)"),
        ("no_responsable_iva", "No responsable de IVA (Simplificado)"),
    ]

    id_cliente = models.IntegerField(primary_key=True)
    nit = models.CharField(max_length=20, unique=True)
    nombre_cliente = models.CharField(max_length=150)
    tipo_cliente = models.CharField(max_length=50)
    canal_distribucion = models.CharField(max_length=50)
    direccion = models.CharField(max_length=150)
    id_ciudad = models.ForeignKey(
        Ciudad, on_delete=models.RESTRICT, db_column="id_ciudad"
    )
    telefono = models.CharField(max_length=20)
    email = models.EmailField(max_length=100)
    credito_autorizado = models.BooleanField(default=False)
    autorizacion_habeas_data = models.BooleanField(
        default=False,
        verbose_name="Autorización Habeas Data (Ley 1581 de 2012)",
    )
    representante_legal = models.CharField(
        max_length=150, null=True, blank=True
    )
    tipo_regimen_tributario = models.CharField(
        max_length=50, choices=REGIMEN_CHOICES, null=True, blank=True
    )

    class Meta:
        managed = False
        db_table = "clientes"

    def __str__(self):
        return self.nombre_cliente


# =========================================================
#  ENTIDAD: PROVEEDOR
# =========================================================

class Proveedor(models.Model):
    TIPO_CUENTA_CHOICES = [
        ("ahorros", "Ahorros"),
        ("corriente", "Corriente"),
    ]

    id_proveedor = models.IntegerField(primary_key=True)
    nit = models.CharField(max_length=20, unique=True)
    nombre_proveedor = models.CharField(max_length=150)
    telefono = models.CharField(max_length=20)
    email = models.EmailField(max_length=100)
    direccion = models.CharField(max_length=150)
    id_ciudad = models.ForeignKey(
        Ciudad, on_delete=models.RESTRICT, db_column="id_ciudad"
    )
    rut = models.CharField(max_length=20, null=True, blank=True)
    banco = models.CharField(max_length=100, null=True, blank=True)
    tipo_cuenta = models.CharField(
        max_length=20, choices=TIPO_CUENTA_CHOICES, null=True, blank=True
    )
    numero_cuenta = models.CharField(max_length=30, null=True, blank=True)
    condiciones_pago = models.IntegerField(
        null=True, blank=True,
        verbose_name="Condiciones de pago (días máx.)",
    )
    calificacion = models.IntegerField(
        null=True, blank=True,
        verbose_name="Calificación (1 a 5)",
    )

    class Meta:
        managed = False
        db_table = "proveedor"

    def __str__(self):
        return self.nombre_proveedor


class ProveedorMateria(models.Model):
    id_proveedor_materia = models.IntegerField(primary_key=True)
    id_proveedor = models.ForeignKey(
        Proveedor, on_delete=models.RESTRICT, db_column="id_proveedor"
    )
    id_materia = models.ForeignKey(
        MateriaPrima, on_delete=models.RESTRICT, db_column="id_materia"
    )
    precio_unitario = models.DecimalField(max_digits=10, decimal_places=2)
    cantidad_minima = models.IntegerField()

    class Meta:
        managed = False
        db_table = "proveedor_materia"
        unique_together = (("id_proveedor", "id_materia"),)

    def __str__(self):
        return f"{self.id_proveedor} - {self.id_materia}"


# =========================================================
#  ENTIDAD: ÓRDENES DE PEDIDO (compras a proveedor)
#  = "orden_compra" + "detalle_compra"
# =========================================================

ESTADO_PAGO_CHOICES = [
    ("pendiente", "Pendiente"),
    ("pagado", "Pagado"),
    ("vencido", "Vencido"),
]


class OrdenCompra(models.Model):
    id_compra = models.AutoField(primary_key=True)
    id_proveedor = models.ForeignKey(
        Proveedor, on_delete=models.RESTRICT, db_column="id_proveedor"
    )
    fecha_compra = models.DateTimeField()
    estado_pago = models.CharField(max_length=20, choices=ESTADO_PAGO_CHOICES)
    fecha_vencimiento = models.DateTimeField()
    fecha_pago = models.DateTimeField(null=True, blank=True)

    class Meta:
        managed = False
        db_table = "orden_compra"

    def __str__(self):
        return f"Orden de compra #{self.id_compra}"

    @property
    def total(self):
        return sum(d.subtotal for d in self.detalles.all())


class DetalleCompra(models.Model):
    id_detalle_compra = models.AutoField(primary_key=True)
    id_compra = models.ForeignKey(
        OrdenCompra, on_delete=models.CASCADE, db_column="id_compra",
        related_name="detalles",
    )
    id_materia = models.ForeignKey(
        MateriaPrima, on_delete=models.RESTRICT, db_column="id_materia"
    )
    cantidad_prods = models.IntegerField(validators=[MinValueValidator(1)])
    precio_historico = models.DecimalField(max_digits=12, decimal_places=2)
    subtotal = models.DecimalField(max_digits=12, decimal_places=2)

    class Meta:
        managed = False
        db_table = "detalle_compra"

    def __str__(self):
        return f"Detalle compra #{self.id_detalle_compra}"


# =========================================================
#  ENTIDAD: FACTURAS (ventas a cliente)
#  = "orden_venta" + "detalle_venta"
# =========================================================

class OrdenVenta(models.Model):
    id_venta = models.AutoField(primary_key=True)
    id_cliente = models.ForeignKey(
        Cliente, on_delete=models.RESTRICT, db_column="id_cliente"
    )
    fecha_venta = models.DateTimeField()

    class Meta:
        managed = False
        db_table = "orden_venta"

    def __str__(self):
        return f"Factura #{self.id_venta}"

    @property
    def subtotal(self):
        return sum(d.subtotal for d in self.detalles.all())

    @property
    def iva(self):
        # Suma el IVA real de cada ítem (cada uno con su propia tarifa:
        # 19% general, 5% diferencial, 0% exento, o nada si es excluido).
        return sum(d.iva for d in self.detalles.all())

    @property
    def total(self):
        return self.subtotal + self.iva


class DetalleVenta(models.Model):
    id_detalle_venta = models.AutoField(primary_key=True)
    id_venta = models.ForeignKey(
        OrdenVenta, on_delete=models.CASCADE, db_column="id_venta",
        related_name="detalles",
    )
    id_prod = models.ForeignKey(
        Producto, on_delete=models.RESTRICT, db_column="id_prod"
    )
    unidades = models.IntegerField(validators=[MinValueValidator(1)])
    precio_historico = models.DecimalField(max_digits=12, decimal_places=2)
    subtotal = models.DecimalField(max_digits=12, decimal_places=2)

    class Meta:
        managed = False
        db_table = "detalle_venta"

    def __str__(self):
        return f"Detalle venta #{self.id_detalle_venta}"

    @property
    def iva(self):
        """IVA de esta línea según la tarifa del producto vendido."""
        pct = self.id_prod.porcentaje_iva
        if pct is None:  # excluido: no se calcula IVA
            return 0
        return round(self.subtotal * pct / 100, 2)

    @property
    def total(self):
        return self.subtotal + self.iva


# =========================================================
#  INVENTARIO (para el "módulo de gestión de inventarios")
# =========================================================

class Inventario(models.Model):
    id_inventario = models.AutoField(primary_key=True)
    id_planta = models.ForeignKey(
        Planta, on_delete=models.RESTRICT, db_column="id_planta"
    )
    id_prod = models.ForeignKey(
        Producto, on_delete=models.RESTRICT, db_column="id_prod"
    )
    cantidad_disponible = models.IntegerField(validators=[MinValueValidator(0), MaxValueValidator(1000000)])
    stock_minimo = models.IntegerField(validators=[MinValueValidator(0), MaxValueValidator(10000)])
    demanda_diaria = models.IntegerField(
        default=1, validators=[MinValueValidator(1), MaxValueValidator(10000)],
        verbose_name="Demanda diaria (unidades/día)"
    )
    fecha_actualizacion = models.DateTimeField()

    class Meta:
        managed = False
        db_table = "inventario"

    def __str__(self):
        return f"Inventario {self.id_prod} en {self.id_planta}"

    @property
    def dias_stock(self):
        """Días de stock = inventario actual / demanda diaria (enunciado)."""
        if not self.demanda_diaria:
            return None
        return round(self.cantidad_disponible / self.demanda_diaria, 1)

    @property
    def estado_stock(self):
        dias = self.dias_stock
        if dias is None:
            return "SIN DATO"
        if dias <= 0:
            return "AGOTADO"
        elif dias < 5:
            return "CRÍTICO"
        elif dias <= 15:
            return "ALERTA"
        return "SEGURO"

    @property
    def accion_recomendada(self):
        return {
            "AGOTADO": "Pedido inmediato",
            "CRÍTICO": "Pedido de emergencia",
            "ALERTA": "Realizar pedido normal",
            "SEGURO": "Mantener monitoreo",
            "SIN DATO": "Registrar demanda diaria",
        }[self.estado_stock]
        
            
class InventarioMateriaPrima(models.Model):
    """
    Inventario de materias primas por proveedor.
    Complementa el inventario de productos terminados.
    """

    id_inventario_materia_prima = models.AutoField(primary_key=True)

    id_proveedor = models.ForeignKey(
        Proveedor,
        on_delete=models.RESTRICT,
        db_column="id_proveedor"
    )

    id_materia = models.ForeignKey(
        MateriaPrima,
        on_delete=models.RESTRICT,
        db_column="id_materia"
    )

    cantidad_disponible = models.IntegerField(
        validators=[MinValueValidator(0)]
    )

    demanda_diaria = models.IntegerField(
        default=1,
        validators=[MinValueValidator(1)],
        verbose_name="Demanda diaria (unidades/día)"
    )

    fecha_actualizacion = models.DateTimeField()

    class Meta:
        managed = False
        db_table = "inventario_materia_prima"

    def __str__(self):
        return f"{self.id_materia.nombre} - {self.id_proveedor.nombre_proveedor}"

    @property
    def dias_stock(self):
        return round(
            self.cantidad_disponible / self.demanda_diaria,
            1
        )

    @property
    def estado_stock(self):
        dias = self.dias_stock

        if dias <= 0:
            return "AGOTADO"
        elif dias < 5:
            return "CRÍTICO"
        elif dias <= 15:
            return "ALERTA"

        return "SEGURO"

    @property
    def accion_recomendada(self):
        return {
            "AGOTADO": "Pedido inmediato",
            "CRÍTICO": "Pedido de emergencia",
            "ALERTA": "Realizar pedido normal",
            "SEGURO": "Mantener monitoreo",
        }[self.estado_stock]

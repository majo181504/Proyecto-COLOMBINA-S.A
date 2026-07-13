from django.contrib import admin
from .models import (
    Pais, Ciudad, Categoria, Marca, Empresa, Planta, MateriaPrima,
    Producto, Cliente, Proveedor, ProveedorMateria,
    OrdenCompra, DetalleCompra, OrdenVenta, DetalleVenta, Inventario,
)

admin.site.register(Pais)
admin.site.register(Ciudad)
admin.site.register(Categoria)
admin.site.register(Marca)
admin.site.register(Empresa)
admin.site.register(Planta)
admin.site.register(MateriaPrima)
admin.site.register(Producto)
admin.site.register(Cliente)
admin.site.register(Proveedor)
admin.site.register(ProveedorMateria)
admin.site.register(OrdenCompra)
admin.site.register(DetalleCompra)
admin.site.register(OrdenVenta)
admin.site.register(DetalleVenta)
admin.site.register(Inventario)

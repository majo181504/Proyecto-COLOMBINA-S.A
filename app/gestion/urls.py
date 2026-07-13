from django.urls import path
from . import views

app_name = "gestion"

urlpatterns = [
    path("", views.home, name="home"),

    # Clientes
    path("clientes/", views.ClienteListView.as_view(), name="cliente_list"),
    path("clientes/nuevo/", views.cliente_form_view, name="cliente_create"),
    path("clientes/<int:pk>/", views.ClienteDetailView.as_view(), name="cliente_detail"),
    path("clientes/<int:pk>/editar/", views.cliente_form_view, name="cliente_update"),
    path("clientes/<int:pk>/eliminar/", views.ClienteDeleteView.as_view(), name="cliente_delete"),

    # Proveedores
    path("proveedores/", views.ProveedorListView.as_view(), name="proveedor_list"),
    path("proveedores/nuevo/", views.proveedor_form_view, name="proveedor_create"),
    path("proveedores/<int:pk>/", views.ProveedorDetailView.as_view(), name="proveedor_detail"),
    path("proveedores/<int:pk>/editar/", views.proveedor_form_view, name="proveedor_update"),
    path("proveedores/<int:pk>/eliminar/", views.ProveedorDeleteView.as_view(), name="proveedor_delete"),

    # Productos / Insumos
    path("productos/", views.ProductoListView.as_view(), name="producto_list"),
    path("productos/nuevo/", views.producto_form_view, name="producto_create"),
    path("productos/<int:pk>/", views.ProductoDetailView.as_view(), name="producto_detail"),
    path("productos/<int:pk>/editar/", views.producto_form_view, name="producto_update"),
    path("productos/<int:pk>/eliminar/", views.ProductoDeleteView.as_view(), name="producto_delete"),
    path("productos/<int:pk>/reactivar/", views.producto_reactivar_view, name="producto_reactivar"),

    # Facturas (ventas)
    path("facturas/", views.FacturaListView.as_view(), name="factura_list"),
    path("facturas/nueva/", views.factura_create_view, name="factura_create"),
    path("facturas/<int:pk>/", views.FacturaDetailView.as_view(), name="factura_detail"),
    path("facturas/<int:pk>/eliminar/", views.FacturaDeleteView.as_view(), name="factura_delete"),

    # Órdenes de pedido (compras)
    path("ordenes/", views.OrdenCompraListView.as_view(), name="orden_list"),
    path("ordenes/nueva/", views.orden_create_view, name="orden_create"),
    path("ordenes/<int:pk>/", views.OrdenCompraDetailView.as_view(), name="orden_detail"),
    path("ordenes/<int:pk>/estado/", views.orden_actualizar_estado_view, name="orden_update_estado"),
    path("ordenes/<int:pk>/eliminar/", views.OrdenCompraDeleteView.as_view(), name="orden_delete"),

    # Inventario productos(solo lectura + editar demanda diaria)
    path("inventario/", views.InventarioListView.as_view(), name="inventario_list"),
    path("inventario/nuevo/", views.inventario_create_view, name="inventario_create"),
    path("inventario/<int:pk>/editar/", views.inventario_update_view, name="inventario_update"),
    
    # Inventario materias primas (solo lectura + editar demanda diaria)
    path("inventario/materias-primas/", views.InventarioMateriaPrimaListView.as_view(), name="inventario_materia_prima_list"),
    path("inventario/materias-primas/nuevo/", views.inventario_materia_prima_create_view, name="inventario_materia_prima_create"),
    path("inventario/materias-primas/<int:pk>/editar/", views.inventario_materia_prima_update_view, name="inventario_materia_prima_update"),
]

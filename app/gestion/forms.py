from django import forms
from django.forms import inlineformset_factory

from .models import (
    Cliente, Proveedor, Producto,
    OrdenVenta, DetalleVenta,
    OrdenCompra, DetalleCompra,
    Inventario,
)


class ClienteForm(forms.ModelForm):
    class Meta:
        model = Cliente
        fields = [
            "id_cliente", "nit", "nombre_cliente", "tipo_cliente",
            "canal_distribucion", "direccion", "id_ciudad",
            "telefono", "email", "credito_autorizado",
            "autorizacion_habeas_data", "representante_legal",
            "tipo_regimen_tributario",
        ]
        widgets = {f: forms.TextInput(attrs={"class": "form-control"})
                   for f in ["nombre_cliente", "tipo_cliente", "canal_distribucion",
                              "direccion", "telefono"]}

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        # El NIT identifica al cliente en el historial contable:
        # no se debe poder cambiar una vez creado.
        if self.instance.pk:
            self.fields["nit"].disabled = True
            self.fields["id_cliente"].disabled = True


class ProveedorForm(forms.ModelForm):
    class Meta:
        model = Proveedor
        fields = [
            "id_proveedor", "nit", "nombre_proveedor",
            "telefono", "email", "direccion", "id_ciudad",
            "rut", "banco", "tipo_cuenta", "numero_cuenta",
            "condiciones_pago", "calificacion",
        ]
        widgets = {
            "calificacion": forms.NumberInput(attrs={"min": 1, "max": 5}),
        }

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        if self.instance.pk:
            self.fields["nit"].disabled = True
            self.fields["id_proveedor"].disabled = True


class ProductoForm(forms.ModelForm):
    class Meta:
        model = Producto
        fields = [
            "id_producto", "nombre_producto", "cate_id", "marca_id",
            "peso", "unidad_medida", "precio", "sabor", "tarifa_iva",
        ]

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        if self.instance.pk:
            self.fields["id_producto"].disabled = True


class OrdenVentaForm(forms.ModelForm):
    class Meta:
        model = OrdenVenta
        fields = ["id_cliente", "fecha_venta"]
        widgets = {
            "fecha_venta": forms.DateTimeInput(
                attrs={"type": "datetime-local", "class": "form-control"}
            ),
        }


DetalleVentaFormSet = inlineformset_factory(
    OrdenVenta, DetalleVenta,
    fields=["id_prod", "unidades", "precio_historico", "subtotal"],
    extra=10, can_delete=True, min_num=1, validate_min=True,
)


class OrdenCompraForm(forms.ModelForm):
    class Meta:
        model = OrdenCompra
        fields = [
            "id_proveedor", "fecha_compra",
            "estado_pago", "fecha_vencimiento", "fecha_pago",
        ]
        widgets = {
            "fecha_compra": forms.DateTimeInput(
                attrs={"type": "datetime-local", "class": "form-control"}
            ),
            "fecha_vencimiento": forms.DateTimeInput(
                attrs={"type": "datetime-local", "class": "form-control"}
            ),
            "fecha_pago": forms.DateTimeInput(
                attrs={"type": "datetime-local", "class": "form-control"}
            ),
        }


DetalleCompraFormSet = inlineformset_factory(
    OrdenCompra, DetalleCompra,
    fields=["id_materia", "cantidad_prods", "precio_historico", "subtotal"],
    extra=10, can_delete=True, min_num=1, validate_min=True,
)


class InventarioForm(forms.ModelForm):
    """
    Solo se edita cantidad_disponible, stock_minimo y demanda_diaria.
    id_planta / id_prod no cambian una vez creado el registro para no
    mezclar el histórico de movimientos de inventario.
    """
    class Meta:
        model = Inventario
        fields = ["cantidad_disponible", "stock_minimo", "demanda_diaria"]

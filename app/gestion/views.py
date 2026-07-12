from django.conf import settings
from django.contrib import messages
from django.db import IntegrityError, transaction
from django.db.models import ProtectedError
from django.shortcuts import render, redirect, get_object_or_404
from django.urls import reverse_lazy
from django.views.generic import ListView, DetailView, DeleteView

from .models import (
    Cliente, Proveedor, Producto, Inventario,
    OrdenVenta, OrdenCompra,
)
from .forms import (
    ClienteForm, ProveedorForm, ProductoForm,
    OrdenVentaForm, DetalleVentaFormSet,
    OrdenCompraForm, DetalleCompraFormSet,
    InventarioForm,
)


def home(request):
    contexto = {
        "total_clientes": Cliente.objects.count(),
        "total_proveedores": Proveedor.objects.count(),
        "total_productos": Producto.objects.count(),
        "total_facturas": OrdenVenta.objects.count(),
        "total_ordenes": OrdenCompra.objects.count(),
    }
    return render(request, "gestion/home.html", contexto)


# =========================================================
#  Helper genérico para no repetir la lógica de
#  "crear o editar" en cada entidad simple (sin detalle)
# =========================================================

def guardar_formulario_simple(request, form_class, instance, plantilla,
                               url_lista, nombre_entidad):
    if request.method == "POST":
        form = form_class(request.POST, instance=instance)
        if form.is_valid():
            try:
                form.save()
                messages.success(
                    request, f"{nombre_entidad} guardado correctamente."
                )
                return redirect(url_lista)
            except IntegrityError as e:
                messages.error(
                    request,
                    f"No se pudo guardar: revisa que el NIT/ID no esté "
                    f"repetido o que las referencias existan. ({e})",
                )
    else:
        form = form_class(instance=instance)
    return render(request, plantilla, {"form": form, "entidad": nombre_entidad})


# =========================================================
#  CLIENTES
# =========================================================

class ClienteListView(ListView):
    model = Cliente
    template_name = "gestion/cliente_list.html"
    context_object_name = "clientes"
    paginate_by = 20
    
    def get_queryset(self):
        return Cliente.objects.order_by("id_cliente")


class ClienteDetailView(DetailView):
    model = Cliente
    template_name = "gestion/cliente_detail.html"
    context_object_name = "cliente"


def cliente_form_view(request, pk=None):
    instance = get_object_or_404(Cliente, pk=pk) if pk else None
    return guardar_formulario_simple(
        request, ClienteForm, instance,
        "gestion/cliente_form.html", "gestion:cliente_list", "Cliente",
    )


class ClienteDeleteView(DeleteView):
    model = Cliente
    template_name = "gestion/confirm_delete.html"
    success_url = reverse_lazy("gestion:cliente_list")

    def post(self, request, *args, **kwargs):
        self.object = self.get_object()
        try:
            self.object.delete()
            messages.success(request, "Cliente eliminado correctamente.")
        except (IntegrityError, ProtectedError):
            messages.error(
                request,
                "No se puede eliminar este cliente: tiene facturas "
                "(órdenes de venta) asociadas. Esto protege la trazabilidad "
                "contable exigida por la normativa colombiana.",
            )
        return redirect(self.success_url)


# =========================================================
#  PROVEEDORES
# =========================================================

class ProveedorListView(ListView):
    model = Proveedor
    template_name = "gestion/proveedor_list.html"
    context_object_name = "proveedores"
    paginate_by = 20
    
    def get_queryset(self):
        return Proveedor.objects.order_by("id_proveedor")


class ProveedorDetailView(DetailView):
    model = Proveedor
    template_name = "gestion/proveedor_detail.html"
    context_object_name = "proveedor"


def proveedor_form_view(request, pk=None):
    instance = get_object_or_404(Proveedor, pk=pk) if pk else None
    return guardar_formulario_simple(
        request, ProveedorForm, instance,
        "gestion/proveedor_form.html", "gestion:proveedor_list", "Proveedor",
    )


class ProveedorDeleteView(DeleteView):
    model = Proveedor
    template_name = "gestion/confirm_delete.html"
    success_url = reverse_lazy("gestion:proveedor_list")

    def post(self, request, *args, **kwargs):
        self.object = self.get_object()
        try:
            self.object.delete()
            messages.success(request, "Proveedor eliminado correctamente.")
        except (IntegrityError, ProtectedError):
            messages.error(
                request,
                "No se puede eliminar este proveedor: tiene órdenes de "
                "pedido o materias primas asociadas (integridad referencial).",
            )
        return redirect(self.success_url)


# =========================================================
#  PRODUCTOS / INSUMOS
# =========================================================

class ProductoListView(ListView):
    model = Producto
    template_name = "gestion/producto_list.html"
    context_object_name = "productos"
    paginate_by = 20

    def get_queryset(self):
        mostrar = self.request.GET.get("mostrar")
        if mostrar == "todos":
            return Producto.objects.order_by("id_producto")
        elif mostrar == "inactivos":
            return Producto.objects.filter(activo=False).order_by("id_producto")
        return Producto.objects.filter(activo=True).order_by("id_producto")

    def get_context_data(self, **kwargs):
        ctx = super().get_context_data(**kwargs)
        ctx["mostrar"] = self.request.GET.get("mostrar", "activos")
        return ctx


class ProductoDetailView(DetailView):
    model = Producto
    template_name = "gestion/producto_detail.html"
    context_object_name = "producto"

    def get_context_data(self, **kwargs):
        ctx = super().get_context_data(**kwargs)
        ctx["inventarios"] = Inventario.objects.filter(id_prod=self.object)
        return ctx


def producto_form_view(request, pk=None):
    # Restricción del enunciado: no se puede registrar un producto/insumo
    # sin categoría y marca ya existentes -> lo garantiza la FK NOT NULL.
    instance = get_object_or_404(Producto, pk=pk) if pk else None
    return guardar_formulario_simple(
        request, ProductoForm, instance,
        "gestion/producto_form.html", "gestion:producto_list", "Producto",
    )


class ProductoDeleteView(DeleteView):
    """
    Eliminación LÓGICA: en vez de borrar la fila físicamente, se marca
    activo=False. Así no se pierde el histórico de inventario, compras
    y ventas que referencian este producto (recomendación del enunciado).
    """
    model = Producto
    template_name = "gestion/confirm_delete.html"
    success_url = reverse_lazy("gestion:producto_list")

    def post(self, request, *args, **kwargs):
        self.object = self.get_object()
        self.object.activo = False
        self.object.save(update_fields=["activo"])
        messages.success(
            request,
            "Producto desactivado. Sigue existiendo en el histórico, pero "
            "ya no aparece en la lista de productos activos.",
        )
        return redirect(self.success_url)


def producto_reactivar_view(request, pk):
    producto = get_object_or_404(Producto, pk=pk)
    if request.method == "POST":
        producto.activo = True
        producto.save(update_fields=["activo"])
        messages.success(request, "Producto reactivado.")
    return redirect("gestion:producto_detail", pk=producto.pk)


# =========================================================
#  FACTURAS (orden_venta + detalle_venta)
#  Regla del enunciado: una vez guardadas, NO editables ni eliminables.
# =========================================================

class FacturaListView(ListView):
    model = OrdenVenta
    template_name = "gestion/factura_list.html"
    context_object_name = "facturas"
    paginate_by = 20
    ordering = ['-fecha_venta']
    
class FacturaDetailView(DetailView):
    model = OrdenVenta
    template_name = "gestion/factura_detail.html"
    context_object_name = "factura"

    def get_context_data(self, **kwargs):
        ctx = super().get_context_data(**kwargs)
        ctx["facturacion"] = settings.FACTURACION
        return ctx


def factura_create_view(request):
    if request.method == "POST":
        form = OrdenVentaForm(request.POST)
        formset = DetalleVentaFormSet(request.POST, instance=OrdenVenta())
        if form.is_valid() and formset.is_valid():
            try:
                with transaction.atomic():
                    factura = form.save()
                    formset.instance = factura
                    formset.save()
                messages.success(request, "Factura registrada correctamente.")
                return redirect("gestion:factura_detail", pk=factura.pk)
            except IntegrityError as e:
                messages.error(request, f"No se pudo registrar la factura: {e}")
    else:
        form = OrdenVentaForm()
        formset = DetalleVentaFormSet(instance=OrdenVenta())
    return render(request, "gestion/factura_form.html",
                  {"form": form, "formset": formset})


class FacturaDeleteView(DeleteView):
    """Bloqueada: las facturas no deben eliminarse (normativa de
    facturación electrónica). Se deja la vista solo para mostrar
    el mensaje explicativo si alguien intenta la URL directamente."""
    model = OrdenVenta
    template_name = "gestion/confirm_delete.html"
    success_url = reverse_lazy("gestion:factura_list")

    def post(self, request, *args, **kwargs):
        messages.error(
            request,
            "Las facturas no se pueden eliminar una vez emitidas: la "
            "normativa de facturación electrónica exige que el rastro de "
            "la transacción sea inalterable.",
        )
        return redirect(self.success_url)


# =========================================================
#  ÓRDENES DE PEDIDO (orden_compra + detalle_compra)
#  Regla: no editables/eliminables una vez creadas, salvo el
#  estado de pago, que sí puede cambiar (pendiente/pagado/vencido).
# =========================================================

class OrdenCompraListView(ListView):
    model = OrdenCompra
    template_name = "gestion/orden_list.html"
    context_object_name = "ordenes"
    paginate_by = 20
    
    def get_queryset(self):
        return OrdenCompra.objects.order_by("-id_compra")


class OrdenCompraDetailView(DetailView):
    model = OrdenCompra
    template_name = "gestion/orden_detail.html"
    context_object_name = "orden"


def orden_create_view(request):
    if request.method == "POST":
        form = OrdenCompraForm(request.POST)
        formset = DetalleCompraFormSet(request.POST, instance=OrdenCompra())
        if form.is_valid() and formset.is_valid():
            try:
                with transaction.atomic():
                    orden = form.save(commit=False)
                    orden.estado_pago = "pendiente"  # siempre inicia pendiente
                    orden.save()
                    formset.instance = orden
                    formset.save()
                messages.success(request, "Orden de pedido registrada.")
                return redirect("gestion:orden_detail", pk=orden.pk)
            except IntegrityError as e:
                messages.error(
                    request,
                    f"No se pudo registrar: verifica que el proveedor y los "
                    f"productos existan ({e}).",
                )
    else:
        form = OrdenCompraForm()
        formset = DetalleCompraFormSet(instance=OrdenCompra())
    return render(request, "gestion/orden_form.html",
                  {"form": form, "formset": formset})


def orden_actualizar_estado_view(request, pk):
    """Único cambio permitido sobre una orden ya creada: su estado de pago."""
    orden = get_object_or_404(OrdenCompra, pk=pk)
    if request.method == "POST":
        nuevo_estado = request.POST.get("estado_pago")
        if nuevo_estado in dict(OrdenCompra._meta.get_field(
                "estado_pago").choices):
            orden.estado_pago = nuevo_estado
            orden.save(update_fields=["estado_pago"])
            messages.success(request, "Estado de la orden actualizado.")
    return redirect("gestion:orden_detail", pk=orden.pk)


class OrdenCompraDeleteView(DeleteView):
    model = OrdenCompra
    template_name = "gestion/confirm_delete.html"
    success_url = reverse_lazy("gestion:orden_list")

    def post(self, request, *args, **kwargs):
        messages.error(
            request,
            "Las órdenes de pedido no se pueden eliminar una vez creadas, "
            "para conservar el rastro de la transacción con el proveedor.",
        )
        return redirect(self.success_url)


# =========================================================
#  INVENTARIO (solo consulta, para el módulo de alertas)
# =========================================================

class InventarioListView(ListView):
    model = Inventario
    template_name = "gestion/inventario_list.html"
    context_object_name = "inventarios"
    paginate_by = 30
    
    def get_queryset(self):
        return Inventario.objects.order_by("id_inventario")


def inventario_update_view(request, pk):
    inventario = get_object_or_404(Inventario, pk=pk)
    if request.method == "POST":
        form = InventarioForm(request.POST, instance=inventario)
        if form.is_valid():
            form.save()
            messages.success(request, "Inventario actualizado.")
            return redirect("gestion:inventario_list")
    else:
        form = InventarioForm(instance=inventario)
    return render(request, "gestion/inventario_form.html",
                  {"form": form, "inventario": inventario})

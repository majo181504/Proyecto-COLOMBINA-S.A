SELECT setval(
    'orden_venta_id_venta_seq',
    (SELECT MAX(id_venta) FROM orden_venta)
);

SELECT setval(
    'orden_compra_id_compra_seq',
    (SELECT MAX(id_compra) FROM orden_compra)
);

SELECT setval(
    'detalle_venta_id_detalle_venta_seq',
    (SELECT MAX(id_detalle_venta) FROM detalle_venta)
);

SELECT setval(
    'detalle_compra_id_detalle_compra_seq',
    (SELECT MAX(id_detalle_compra) FROM detalle_compra)
);

SELECT setval(
    'inventario_id_inventario_seq',
    (SELECT MAX(id_inventario) FROM inventario)
);

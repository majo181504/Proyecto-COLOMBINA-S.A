-- =========================================================
-- Parche 005: cálculo inicial de demanda diaria
-- =========================================================
-- Con este parche se arregla que siempre se ponia 1 como default en la demanda diaria
-- Eso generaba un escenario irreal, pero ahora se ha arreglado.

UPDATE inventario
SET demanda_diaria = GREATEST(
    2,
    ROUND(stock_minimo / 5.0)
);
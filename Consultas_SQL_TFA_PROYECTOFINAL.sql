-- Verificar la base de datos actual---
SELECT DB_NAME() AS Base_De_Datos;

-- Mostrar todas las tablas importadas--
SELECT
    TABLE_NAME AS Nombre_Tabla
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_SCHEMA = 'dbo'
ORDER BY TABLE_NAME;


-- Revisar las columnas y tipos de datos de cada tabla---
SELECT
    TABLE_NAME AS tabla,
    COLUMN_NAME AS columna,
    DATA_TYPE AS tipo_dato
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
ORDER BY TABLE_NAME, ORDINAL_POSITION;

-- Unir ventas con clientes
SELECT TOP 10
    c.nombre_cliente,
    v.fecha_venta,
    v.monto_total
FROM dbo.fact_ventas AS v
INNER JOIN dbo.dim_clientes AS c
    ON v.id_cliente = c.id_cliente
ORDER BY v.fecha_venta DESC;


-- Guardar la fecha de la última venta del dataset
DECLARE @ultima_fecha DATE = (
    SELECT MAX(fecha_venta)
    FROM dbo.fact_ventas
);

-- Ventas de los últimos 30 días
SELECT
    c.nombre_cliente,
    v.fecha_venta,
    CAST(v.monto_total AS DECIMAL(18,2)) AS total_venta
FROM dbo.fact_ventas AS v
INNER JOIN dbo.dim_clientes AS c
    ON v.id_cliente = c.id_cliente
WHERE v.fecha_venta BETWEEN DATEADD(DAY, -29, @ultima_fecha)
                        AND @ultima_fecha
ORDER BY v.fecha_venta DESC;


GO

-- Validar el período utilizado y la cantidad de ventas
DECLARE @ultima_fecha DATE = (
    SELECT MAX(fecha_venta)
    FROM dbo.fact_ventas
);

SELECT
    DATEADD(DAY, -29, @ultima_fecha) AS fecha_inicio,
    @ultima_fecha AS fecha_fin,
    COUNT(*) AS cantidad_ventas
FROM dbo.fact_ventas
WHERE fecha_venta BETWEEN DATEADD(DAY, -29, @ultima_fecha)
                      AND @ultima_fecha;

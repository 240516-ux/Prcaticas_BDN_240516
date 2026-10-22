-- Solo lectura. Ejecutar sobre bd_test para contrastar la documentación publicada.
-- Los totales esperados describen el modelo actual; si cambian, investigar la causa.
USE bd_test;
SELECT DATABASE() AS esquema, CURRENT_USER() AS cuenta, VERSION() AS version;

SELECT 'Tablas físicas' AS objeto, COUNT(*) AS total
FROM information_schema.TABLES
WHERE TABLE_SCHEMA='bd_test' AND TABLE_TYPE='BASE TABLE'
UNION ALL
SELECT 'Columnas físicas',COUNT(*)
FROM information_schema.COLUMNS c
JOIN information_schema.TABLES t
  ON t.TABLE_SCHEMA=c.TABLE_SCHEMA AND t.TABLE_NAME=c.TABLE_NAME
WHERE c.TABLE_SCHEMA='bd_test' AND t.TABLE_TYPE='BASE TABLE'
UNION ALL
SELECT 'Claves foráneas',COUNT(*)
FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_SCHEMA='bd_test'
UNION ALL
SELECT 'Triggers',COUNT(*)
FROM information_schema.TRIGGERS WHERE TRIGGER_SCHEMA='bd_test'
UNION ALL
SELECT 'Vistas',COUNT(*)
FROM information_schema.VIEWS WHERE TABLE_SCHEMA='bd_test';
-- Esperado: 17, 135, 19, 45 y 6, respectivamente.

-- Debe devolver cero filas: cada entidad de negocio tiene tres eventos AFTER.
SELECT t.TABLE_NAME,COUNT(tr.TRIGGER_NAME) AS total
FROM information_schema.TABLES t
LEFT JOIN information_schema.TRIGGERS tr
  ON tr.TRIGGER_SCHEMA=t.TABLE_SCHEMA AND tr.EVENT_OBJECT_TABLE=t.TABLE_NAME
WHERE t.TABLE_SCHEMA='bd_test' AND t.TABLE_TYPE='BASE TABLE'
  AND t.TABLE_NAME NOT IN ('tb_logs','tb_logs_productos')
GROUP BY t.TABLE_NAME
HAVING COUNT(tr.TRIGGER_NAME)<>3;

-- Debe devolver cero filas: sin combinaciones repetidas ni triggers BEFORE.
SELECT EVENT_OBJECT_TABLE,ACTION_TIMING,EVENT_MANIPULATION,COUNT(*) AS total
FROM information_schema.TRIGGERS
WHERE TRIGGER_SCHEMA='bd_test'
GROUP BY EVENT_OBJECT_TABLE,ACTION_TIMING,EVENT_MANIPULATION
HAVING COUNT(*)<>1 OR ACTION_TIMING<>'AFTER';

-- Debe devolver cero filas: las bitácoras no deben auditarse recursivamente.
SELECT TRIGGER_NAME,EVENT_OBJECT_TABLE
FROM information_schema.TRIGGERS
WHERE TRIGGER_SCHEMA='bd_test'
  AND EVENT_OBJECT_TABLE IN ('tb_logs','tb_logs_productos');

-- Contrastar este inventario completo con docs/diagramas/TRIGGERS_bd_test.md.
SELECT EVENT_OBJECT_TABLE,TRIGGER_NAME,ACTION_TIMING,EVENT_MANIPULATION,ACTION_STATEMENT
FROM information_schema.TRIGGERS
WHERE TRIGGER_SCHEMA='bd_test'
ORDER BY EVENT_OBJECT_TABLE,TRIGGER_NAME;

-- Las dos autorreferencias se dibujan mediante alias; no son tablas adicionales.
SELECT CONSTRAINT_NAME,TABLE_NAME,REFERENCED_TABLE_NAME,DELETE_RULE,UPDATE_RULE
FROM information_schema.REFERENTIAL_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA='bd_test' AND TABLE_NAME=REFERENCED_TABLE_NAME;

-- Solo consultar: no habilitar el evento para alterar los conteos.
SELECT EVENT_NAME,STATUS,EVENT_DEFINITION
FROM information_schema.EVENTS WHERE EVENT_SCHEMA='bd_test';

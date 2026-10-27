# Consultas y comprobaciones para continuar

Preparadas, no ejecutadas en el VPS por Codex. No repiten operaciones de escritura observadas. Ejecutar manualmente en cliente autorizado, revisando cada bloque. No copiar contraseñas a la línea de comandos.

## Local, desde la raíz del repositorio

```powershell
git status --short
git branch --show-current
docker compose --env-file Practica_PostgreSQL/.env.example -f Practica_PostgreSQL/docker-compose.yml config --quiet
```

Este último comando valida el ejemplo, no inicia contenedores. No usar una configuración resuelta que imprima secretos para capturar evidencia.

## MySQL, cliente conectado a la instancia propia

```sql
SELECT DATABASE(), CURRENT_USER(), VERSION();
```

Detenerse si la base no es bd_test_alan o la conexión no corresponde. Después, individualmente:

```sql
SHOW VARIABLES LIKE 'log_bin_trust_function_creators';
SHOW TRIGGERS FROM bd_test_alan;
SELECT 'tb_users' AS tabla, COUNT(*) AS registros FROM bd_test_alan.tb_users
UNION ALL SELECT 'tb_products', COUNT(*) FROM bd_test_alan.tb_products
UNION ALL SELECT 'tb_logs', COUNT(*) FROM bd_test_alan.tb_logs;
```

OFF y falta de auditoría siguen bloqueados para intervención del administrador. No ejecutar SET GLOBAL ni importar mysql.sql. Un inventario vacío depende de la visibilidad de la cuenta.

## PostgreSQL, cliente conectado a la instancia propia

```sql
SELECT current_database(), current_user, now(), current_setting('TimeZone');
```

Detenerse si no corresponde. Para revisar conteos y evolución ya existente, ejecutar por bloques `sql/validacion_historial_postgresql.sql`. Para estructura, usar `sql/validacion_postgresql.sql`. Son de lectura; no vuelven a cambiar el stock ni el correo.

Antes de capturar, preparar una pantalla completa que no muestre direcciones, credenciales ni datos privados. No recortar ni modificar la evidencia original. No repetir INSERT/UPDATE para obtener una imagen distinta. Ver PENDIENTES_ENTREGA.md para las pruebas aún no acreditadas.

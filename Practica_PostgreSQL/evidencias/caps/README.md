# Evidencias de caps.docx

22 imágenes extraídas en orden OOXML, con párrafo registrado; no se inventó paginación Word. Originales privados intactos. Se incorporaron 17 copias protegidas al manual; cinco se excluyeron por redundancia o menor legibilidad. No se pide repetir imágenes ya aprovechadas.

El inventario completo actualizado es ../INVENTARIO_GENERAL.csv; inventario_caps.csv conserva descripción, posición y limitaciones. Las copias están en ../seguras/Evidencias_tecnicas_redactadas.pdf.

| ID | Procedimiento / resultado | Uso actual |
|---|---|---|
| CAPS-01 | Servicios del VPS: Tres contenedores propios y puertos; sesión terminal | Copia protegida incorporada, página 23 |
| CAPS-02 | Identidad PostgreSQL: current_database bd_test_alan; current_user alan_admin | No incorporada; ver motivo en inventario general |
| CAPS-03 | Identidad MySQL: DATABASE bd_test_alan; CURRENT_USER alan_admin@% | No incorporada; ver motivo en inventario general |
| CAPS-04 | Acceso pgAdmin: Formulario de inicio; no demuestra autenticación exitosa | Copia protegida incorporada, página 26 |
| CAPS-05 | Sesión pgAdmin: Interfaz iniciada; aún sin servidor conectado en esa imagen | Copia protegida incorporada, página 27 |
| CAPS-06 | Registro servidor pgAdmin: Puerto interno 5432; base bd_test_alan; usuario alan_admin; contraseña enmascarada | Copia protegida incorporada, página 29 |
| CAPS-07 | Servidor conectado: Árbol PostgreSQL y bd_test_alan con panel de actividad | Copia protegida incorporada, página 30 |
| CAPS-08 | Tablas PostgreSQL: Árbol muestra tb_logs, tb_products y tb_users | Copia protegida incorporada, página 36 |
| CAPS-09 | Vistas PostgreSQL: Árbol muestra las dos vistas de trazabilidad | Copia protegida incorporada, página 49 |
| CAPS-10 | Auditoría INSERT PostgreSQL: SELECT tb_logs muestra siete filas anteriores, de usuarios y producto | No incorporada; ver motivo en inventario general |
| CAPS-11 | Eventos trigger PostgreSQL: Seis filas AFTER: INSERT, UPDATE y DELETE por tabla; nombres visibles/truncados | Copia protegida incorporada, página 47 |
| CAPS-12 | Bloqueo MySQL: SHOW TRIGGERS sin filas visibles; variable log_bin_trust_function_creators OFF | No incorporada; ver motivo en inventario general |
| CAPS-13 | Conteos MySQL: COUNT muestra tb_users 5; tb_products 4; tb_logs 0; variable OFF | Copia protegida incorporada, página 66 |
| CAPS-14 | Conteos PostgreSQL: COUNT muestra tb_users 6; tb_products 1; tb_logs 7 | Copia protegida incorporada, página 39 |
| CAPS-15 | Vista usuarios consultada: vw_trazabilidad_usuarios: seis filas INSERT visibles | Copia protegida incorporada, página 51 |
| CAPS-16 | Vista productos consultada: vw_trazabilidad_productos: una fila INSERT visible | Copia protegida incorporada, página 52 |
| CAPS-17 | UPDATE producto inicial: UPDATE por id=1 retorna stock 11 y una fila | Copia protegida incorporada, página 54 |
| CAPS-18 | Log UPDATE producto inicial: Log id 8 UPDATE del producto 1, stock 11; INSERT previo stock 10 | Copia protegida incorporada, página 55 |
| CAPS-19 | UPDATE usuario: UPDATE por alias alan.cruz retorna id 2 y correo demostrativo | Copia protegida incorporada, página 56 |
| CAPS-20 | Log UPDATE usuario: Log id 9 UPDATE para record_id 2; estado nuevo en JSON visible parcialmente | Copia protegida incorporada, página 57 |
| CAPS-21 | UPDATE producto repetido: Misma consulta retorna stock 12, una fila | No incorporada; ver motivo en inventario general |
| CAPS-22 | Logs UPDATE producto repetido: Log id 10 UPDATE stock 12; id 8 UPDATE stock 11; id 2 INSERT stock 10 | Copia protegida incorporada, página 58 |

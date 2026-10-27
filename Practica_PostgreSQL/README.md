# Bases de Datos en la Nube - Unidad 1

Manual individual de `Practica_PostgreSQL`, con PostgreSQL, MySQL y pgAdmin en un VPS compartido. Rama local: `Manual_VPS_BDs_Relacionales`. Esta edición sigue la lista oficial de 56 indicadores y 100 puntos; **todavía no es una entrega completa**.

## Documentos principales

- [Manual PDF](docs/Manual_Bases_Datos_Nube_FINAL.pdf): 69 páginas, con 33 capturas junto a sus procedimientos (57 originales revisados; 24 excluidos con motivo).
- [Cumplimiento por indicador](docs/CUMPLIMIENTO_RUBRICA.md), con [CSV](docs/CUMPLIMIENTO_RUBRICA.csv): requisito literal, estado, evidencia existente/faltante y acción.
- [Pendientes priorizados](docs/PENDIENTES_ENTREGA.md), [fuente del manual](docs/MANUAL_ENTREGA.md) y [validación local](docs/VALIDACION_LOCAL.md).
- [Evidencias seguras](evidencias/seguras/README.md), [inventario de caps.docx](evidencias/caps/README.md) y [fuentes](docs/FUENTES.md).

## Servicios y puertos declarados

| Servicio | Imagen | Contenedor | Puerto VPS / interno |
|---|---|---|---|
| PostgreSQL | postgres:18 | alan-postgres | 40516 / 5432 |
| MySQL | mysql:8.4 | alan-mysql | 40517 / 3306 |
| pgAdmin | dpage/pgadmin4:9.17 | alan-pgadmin | 40518 / 80 |

Base del manual: `bd_test_alan`. Cuenta de conexión declarada: `alan_admin`. No confundir con `bd_test` de prácticas anteriores. El puerto PostgreSQL corresponde a los últimos cinco dígitos de 240516; MySQL suma uno.

PostgreSQL monta postgres_data en /var/lib/postgresql y MySQL mysql_data en /var/lib/mysql. pgAdmin no declara volumen persistente propio. No recrear servicios para demostrar persistencia ni cambiar el nombre del proyecto/volúmenes. La revisión completa de persistencia y logs sigue pendiente.

## Estructura

- docker-compose.yml: configuración original conservada.
- sql/: scripts originales MySQL/PostgreSQL y validadores de lectura.
- docs/: manual, matriz oficial, pendientes y documentación.
- evidencias/seleccionadas/: dos capturas Docker sin editar.
- evidencias/seguras/: PDF con doce copias técnicas redactadas e índice de intervención.
- evidencias/caps/: inventario de 22 originales privados, no los originales.
- respaldos/ y evidencias/originales/: archivos locales anteriores ignorados por Git; no publicar.

## Variables y seguridad

Nunca abrir ni mostrar valores privados para documentación. `.env` está ignorado y no figura en el índice. `.env.example` contiene solo marcadores ficticios de POSTGRES_PASSWORD, MYSQL_PASSWORD, MYSQL_ROOT_PASSWORD, PGADMIN_EMAIL y PGADMIN_PASSWORD. No incluir secretos ni configuraciones resueltas en capturas.

Las doce copias técnicas se redactaron en PDF, eliminando los píxeles de dirección/identificación de acceso. Cada página avisa de la intervención; no se ocultaron resultados ni errores. Los originales de caps.docx permanecen fuera del árbol de trabajo, intactos. No se publicaron imágenes originales sensibles.

## Preparación y comprobación local

Desde la raíz del repositorio:

```powershell
docker compose --env-file Practica_PostgreSQL/.env.example -f Practica_PostgreSQL/docker-compose.yml config --quiet
```

Valida el ejemplo sin iniciar servicios. Una instalación nueva requeriría autorización, puertos libres, directorio propio, variables privadas y revisión de volúmenes antes de iniciar Compose. El despliegue existente no necesita reinstalación: no ejecutar down, restart, restauraciones ni importaciones completas para continuar esta documentación.

## Conexiones y validaciones

Usar HOST_VPS (marcador privado), puertos propios y base bd_test_alan, con contraseña solicitada por el cliente. La rúbrica exige clientes externos a los contenedores: **SSH/docker exec no acredita esa prueba**. La evidencia pgAdmin no basta para afirmar permisos administrativos efectivos de ambos motores. Faltan demostración externa MySQL, validación de privilegios y revisión de firewall/canal seguro por el administrador.

Ejecutar manualmente y por bloques, tras confirmar identidad, sql/validacion_mysql.sql o sql/validacion_postgresql.sql. sql/validacion_historial_postgresql.sql consulta el historial ya existente sin repetir UPDATE. No ejecutar ninguno desde esta tarea contra bases reales. [Comandos de continuación](docs/COMANDOS_CONTINUACION.md).

## Estado real documentado

PostgreSQL: evidencia histórica de tablas, dos vistas, dos triggers multievento, INSERT y UPDATE auditados, y pgAdmin conectado. Los conteos CAPS-14 fueron 6 usuarios, 1 producto y 7 logs antes de actualizaciones posteriores; no representan un conteo actual.

MySQL: CAPS-13 muestra 5 usuarios, 4 productos y 0 logs, con log_bin_trust_function_creators OFF. El error 1419 continúa bloqueando la auditoría; no se han comprobado triggers funcionando. Solo el administrador puede resolver la política/configuración correspondiente. No ejecutar SET GLOBAL ni conceder privilegios para eludirlo.

Los siete roles y cinco cuentas deben ser del motor; tb_users.role_name no acredita esos permisos. Los scripts originales no crean roles/cuentas/GRANT y no deben reimportarse: PostgreSQL contiene reemplazos y DROP TRIGGER; MySQL no protege la reejecución de triggers. Sus correcciones requieren un procedimiento autorizado separado.

## Entrega y Git

Quedan pendientes los datos personales de portada, conclusiones personales, enunciados de los diez ejercicios de clase y varios indicadores técnicos. La lista oficial no detalla esos diez enunciados. No se otorgan puntos a pruebas inexistentes ni se presenta la matriz provisional U/P como los ejercicios oficiales.

La rúbrica requiere commits y merge final. No se ejecutan: el alumno debe autorizarlos y revisar antes archivos/diff/secretos. Se mantiene intacto el índice preexistente, la rama y los cambios de Practica02/Practica03. No se confirmó la privacidad del repositorio remoto ni se hizo push. Confirmar con el docente el nombre de referencia Reporte_Unidad1_240516.pdf y la ubicación de los entregables antes de renombrar o duplicar nada.

Se conserva el borrador inicial y copias locales ignoradas de las ediciones anteriores. La fotografía adicional exige ambos respaldos completos de datos: ver docs/RESPALDOS_PREPARACION.md para exportación privada preparada y aún no ejecutada.

## Actualización por instrucciones manuscritas

La fotografía aporta ocho apartados de simulación para ambos motores y exige respaldos completos con datos. Ver [CASOS_SIMULACION.md](docs/CASOS_SIMULACION.md) y [RESPALDOS_PREPARACION.md](docs/RESPALDOS_PREPARACION.md) en docs/. Los casos 9 y 10 no se encontraron en los materiales disponibles: quedan pendientes del docente. No se inventan dividiendo UPDATE/DELETE o la actividad de vendedores.

Root, Support, usuario sin rol y dos vendedores deben identificarse como cuentas/roles reales, no por filas de tb_users. El GRANT P02 bajo el comentario sin rol apunta actualmente a alan.cruz: incoherencia que no se copia ni modifica. Support carece de DELETE en esa referencia, por lo que hay que aclarar si se evalúa una denegación. Nuevos validadores de permisos son solo lectura y no fueron ejecutados.

Los nombres tb_buyer_orders, tbd_order_items y tbd_cart_items sí aparecen en materiales de Practica03 para bd_test, pero no en los SQL de bd_test_alan. Falta confirmar alcance y definición antes de crearlos; no se importó estructura.

Solo se encontró el dump MySQL antiguo en la carpeta de respaldos del manual; no acredita el VPS actual y no se halló exportación PostgreSQL de datos. Ahora se prepararon comandos de exportación privados con destinos nuevos, contraseña interactiva y verificación de salida, tamaño y SHA-256, sin ejecutarlos. La exigencia de ambos respaldos viene de esta fotografía; sustituye la conclusión anterior de que no existía tal instrucción adicional. No se afirma restaurabilidad.

## Revisión editorial para entrega

El manual incorpora 33 capturas de 57 originales, organizadas junto a sus procedimientos. El inventario general identifica indicadores, alcance, protección y exclusiones; no se repitieron pruebas. La fuente docs/MANUAL_ENTREGA.md contiene un borrador editable de conclusiones con marcadores que el alumno debe confirmar personalmente. El indicador 52 sigue pendiente.

Se revisaron coherencia, portada, índice y referencias; los datos personales faltantes y la lista exacta del administrador están en docs/PENDIENTES_ENTREGA.md. Las diferencias SQL/Compose se documentan en docs/REVISION_TECNICA.md sin modificar esos archivos. Los ocho apartados siguen pendientes como serie oficial; 9/10 y la relación exacta de E08 con la rúbrica requieren aclaración. No se ejecutaron SQL, cargas o respaldos.

## Guía para una persona principiante

El manual ahora sigue el recorrido Windows → VPS → Compose → despliegue → clientes externos → tablas/roles → auditoría → ejercicios → respaldos → entrega. Cada capítulo distingue instrucciones, observaciones históricas y pendientes. No repetir SQL de las capturas.

- [Capturas realmente pendientes](docs/CAPTURAS_PENDIENTES.md): prioridades, consulta, resultado, equipo y dependencia.
- [Inventario completo de 57 originales](evidencias/INVENTARIO_GENERAL.csv): procedimiento, capítulo, indicador, página del PDF, protección y exclusión.
- [Fuente editable](docs/MANUAL_ENTREGA.md): personalizar portada y conclusiones. Las referencias FIG identifican imágenes del inventario.

Se incorporan 16 imágenes del documento anterior y 17 de caps.docx. Las 24 excluidas no equivalen a 24 fotos que haya que repetir. Git/Docker/Compose en VPS ya tienen evidencia DOCX-11. No hubo acciones remotas, commit, push o merge.

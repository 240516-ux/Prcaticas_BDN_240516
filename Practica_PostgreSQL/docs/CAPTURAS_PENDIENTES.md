# Capturas realmente pendientes

Revisión de 57 originales: 39 incorporados y 18 excluidos. Estos últimos NO son 18 capturas que deban repetirse. Hay 17 fichas de seguimiento abajo: algunas requieren series por actor/motor, por lo que no se conoce aún el número final de archivos nuevos. Los casos 9/10 no tienen enunciado disponible. Ninguna ficha se marca obtenida sin archivo comprobado.

Ya existen y no se piden de nuevo: Git/Docker/Compose en VPS (DOCX-11), servicios/puertos (CAPS-01), login y registro pgAdmin (CAPS-04/05/06/07), tablas/vistas PG (DOCX-32, CAPS-08/09), eventos de triggers PG (CAPS-11), trazabilidad INSERT/UPDATE (DOCX-33, CAPS-15/16/18/20/22), variable OFF y conteos MySQL (CAPS-13). La rama también aparece en capturas existentes.

Para toda captura nueva: pantalla completa, aplicación/consulta y resultado legibles, reloj visible cuando sea posible. No mostrar .env, contraseñas, tokens, claves, hashes ni datos de acceso privados. Revisar privacidad antes de incorporarla; conservar original en privado y copia redactada explícitamente si corresponde. No ejecutar las operaciones de esta lista sin la autorización que requieran.

## A. Indispensables para cerrar indicadores o instrucciones oficiales

| Código / nombre sugerido | Indicador | Pantalla o consulta y resultado válido | Programa / equipo | Capítulo | Dependencia |
|---|---|---|---|---|---|
| I01 `I01_recursos_vps.png` | 1-2 | CPU, RAM y disco con nproc, free -h, df -h /; constancia de habilitación autorizada sin facturación privada. Debian ya consta: no repetir solo la versión. | Terminal autorizada VPS | 4 | Administrador si faltan permisos/información |
| I02 `I02_cuentas_permisos_so.png` | 3-4 | Cuentas personales del equipo y permisos efectivos según responsabilidades; sin hashes o credenciales. | Terminal del administrador | 4 | Administrador confirma alcance y privacidad |
| I03 `I03_red_firewall.png` | 15-16,19 | Reglas efectivas y puertos propios sin conflictos; acceso autorizado desde cliente. No basta docker ps. | Consola de administración y cliente Windows | 8-9 | Administrador; solo lectura |
| I04 `I04_postgresql_externo.png` | 17 | Cliente Windows externo, current_database/session_user/current_user y permiso administrativo requerido comprobable. Base bd_test_alan. No SSH/docker exec. | psql o cliente PG local Windows | 9 | Acceso externo y permisos autorizados |
| I05 `I05_mysql_externo.png` | 18 | Workbench externo, DATABASE/CURRENT_USER y permisos suficientes. Puerto 40517, sin mostrar host privado. | Workbench Windows | 9 | Conectividad/cuenta autorizada; consulta no exige resolver triggers |
| I06 `I06_roles_cuentas_pg.png` | 20,24,26 | Siete roles reales, cinco cuentas y membresías en catálogos; role_name no sirve como sustituto. | Cliente externo PostgreSQL | 11 | Consulta autorizada; sin crear cuentas |
| I07 `I07_roles_cuentas_mysql.png` | 21,25,27 | Siete roles reales, cinco cuentas y concesiones/roles activos. No mysql.* con hashes. | Workbench externo | 11 | Permiso de consulta del administrador |
| I08 `I08_privilegios_ACTOR_MOTOR.png` | 22-23,37 | Serie por Root, Support, sin rol y vendedores: identidad y permisos efectivos. Constancia de entrega segura sin revelar credenciales. | Clientes externos de ambos motores | 11,13 | Confirmar actores y política Support con docente |
| I09 `I09_restricciones_MOTOR.png` | 30-31,36 | Definiciones de las tres tablas, claves/índices/restricciones cotejadas con lo visto en clase. No crear FK inventadas. | Clientes SQL externos | 10 | Falta definición docente suficiente para cotejo completo |
| I10 `I10_E0N_ACTOR_MOTOR.png` | 38-47 | Serie de los ocho apartados oficiales: actor/base, SQL autorizado, resultado y log o denegación. Usar historial válido sin repetir escrituras. 9/10 solo después de recibir enunciados. | Clientes externos PG/MySQL | 13 | Docente, autorización de escrituras y desbloqueo MySQL para auditoría |
| I11 `I11_respaldo_MOTOR.png` | Foto manuscrita; apoyo a entrega | Exportación terminada con código correcto, tamaño, fecha, SHA-256 e inventario compatible. Sin mostrar contenido del dump. Un índice de pg_restore no prueba restauración. | PowerShell Windows y directorio privado fuera de Git | 14 | Permisos de exportación; no hay dumps actuales comprobados |
| I12 `I12_entrega_git.png` | 54-56 | Privacidad del repositorio y fusión final autorizada; commits 3463afd/10c3fe0 ya verificados, no rehacerlos. Rama ya documentada. | Git y GitHub del estudiante | 16 | Autorización futura para fusión; aquí no push ni merge a main |

## B. Cuando el administrador habilite la auditoría MySQL

| Código / nombre sugerido | Indicador | Pantalla o consulta y resultado válido | Programa / equipo | Capítulo | Dependencia |
|---|---|---|---|---|---|
| M01 `M01_mysql_instancia_politica.png` | 33 | Instancia correcta y lectura de log_bin, confianza y permisos tras decisión del administrador. OFF ya tiene evidencia: no repetirla solo para mostrar el bloqueo. Recuperar error 1419 completo de registro existente si existe, sin provocar una importación fallida nueva. | Cliente autorizado MySQL | 15 | Decisión administrativa; no SET GLOBAL por el alumno |
| M02 `M02_mysql_triggers_vistas.png` | 33,35 | Seis triggers con eventos/tabla y SHOW CREATE VIEW de las dos vistas, una vez instalados solo los objetos faltantes autorizados. | Workbench externo | 12,15 | Respaldo previo, solución y ejecución autorizada mínima |
| M03 `M03_mysql_trazabilidad.png` | 33,35-36, casos aplicables | Operaciones oficiales autorizadas reflejadas una vez en tb_logs y vistas; comparar entidad/evento sin falsear actor. No añadir pruebas independientes para generar logs. | Workbench externo | 12-13 | M02 y ejecución autorizada I10 |

## C. Complementarias únicamente dentro del alcance oficial

| Código / nombre sugerido | Indicador | Pantalla / resultado | Programa / equipo | Capítulo | Condición |
|---|---|---|---|---|---|
| C01 `C01_persistencia_logs.png` | 11-12 | Montajes propios y logs de los tres servicios, sin secretos; evidencia existente de conservación tras ciclo autorizado si está disponible. No recrear servicios solo para esta lista. | Terminal autorizada VPS | 8 | Administrador revisa alcance; consulta segura, cualquier ciclo requiere autorización |
| C02 `C02_tablas_docente.png` | 30-31 solo si se confirma | Evidencia de tb_buyer_orders/tbd_order_items/tbd_cart_items únicamente si docente confirma su obligatoriedad y diseño. | Cliente SQL | 10 | No es requisito confirmado: no crear tablas ni pedir captura por ahora |

## Aclaraciones que no se resuelven tomando una foto

- Enunciados oficiales de casos 9/10 y correspondencia entre ocho apartados y diez indicadores.
- Si E08 con 5000 productos forma parte obligatoria de esta entrega y cómo continuar sin duplicar datos existentes.
- Cuenta real de Root y del usuario sin rol; expectativa de DELETE Support frente a la política de Práctica 02.
- Diseño/obligatoriedad de las tres tablas adicionales y restricciones de clase.
- Nombre de archivo final del reporte; portada y conclusiones personales.


## Revisión del 27/10/2026

Se recuperaron DOCX-16/25 y CAPS-02/03/10/21. Ya no se piden identidad interna, colocación de archivos, lectura directa de logs ni segundo UPDATE: existen copias seguras. La identidad interna NO resuelve I04/I05 de clientes externos. La captura parcial DOCX-16 no sustituye pantalla completa.

La existencia de commits está comprobada por Git (55 cumplido documentalmente). I12 se limita a la evidencia pendiente de privacidad y fusión. El nombre exacto de rama segura requiere resolver el conflicto con la rama original local que hereda secretos; no se publica ni se reescribe.

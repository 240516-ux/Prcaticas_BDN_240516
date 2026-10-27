# Ocho apartados de simulación y contraste con los diez casos

Fuente: fotografía manuscrita aportada el 26/10/2026 y transcripción del alumno. Original privado conservado intacto; no se publica por anotaciones/firma. Se mantienen ocho apartados, incluidos los compuestos. No se fragmentan UPDATE/DELETE o los dos vendedores para inventar los casos 9 y 10. La rúbrica exige diez casos, pero no contiene sus enunciados.

La fotografía pide tener base, tablas, triggers, usuarios, roles y privilegios, e investigar la ejecución SQL mediante Docker. Esa ejecución interna no sustituye los clientes externos exigidos por la rúbrica. La frase «en cuál se prende» es ambigua: no autoriza iniciar/reiniciar contenedores.

Las plantillas siguientes usan parámetros `:nombre`, no son SQL listo para pegar en psql/Workbench. Deben enlazarse desde un cliente preparado o sustituirse por valores reales aprobados después de autorización. No son resultados ni datos inventados; no se ejecutaron ni se genera carga nueva. Identificar IDs mediante consulta y no asumir secuencias. La conexión y rol del actor deben capturarse por separado de tb_users.role_name.

## E01. Como usuario Root insertar 3 usuarios.

Objetivo: Crear tres filas mediante actor administrativo.

Motor: PostgreSQL y MySQL, con ejecución y evidencia independientes. Actor: Root / superadmin; cuenta real por verificar.

```sql
-- PLANTILLA DOCUMENTAL; NO EJECUTADA
INSERT INTO tb_users (username,email,role_name) VALUES (:alias1,:email1,:rol1),(:alias2,:email2,:rol2),(:alias3,:email3,:rol3);
```

Esperado: Tres altas y tres logs INSERT si trigger operativo.

- PostgreSQL: CAPS-10/14: INSERT previos; no prueban tres altas con el actor exigido.
- MySQL: CAPS-13: cinco usuarios, cuatro productos y cero logs; OFF. No acredita el actor o la carga de esta actividad; auditoría bloqueada.

## E02. Decirle al usuario que no tiene rol que inserte 3 usuarios.

Objetivo: Probar tres altas mediante permisos directos sin pertenencia a roles.

Motor: PostgreSQL y MySQL, con ejecución y evidencia independientes. Actor: Usuario sin rol: identidad VPS no confirmada; no sustituir por common.

```sql
-- PLANTILLA DOCUMENTAL; NO EJECUTADA
Misma plantilla INSERT de E01; ejecutar desde la cuenta sin rol, no desde administrador.
```

Esperado: Permitido solo si existe INSERT directo. Falta comprobarlo; ausencia de rol no implica ausencia de permisos.

- PostgreSQL: CAPS-10/14: INSERT previos; no prueban tres altas con el actor exigido.
- MySQL: CAPS-13: cinco usuarios, cuatro productos y cero logs; OFF. No acredita el actor o la carga de esta actividad; auditoría bloqueada.

## E03. 3 usuarios del usuario con rol Support.

Objetivo: Probar tres altas desde Support.

Motor: PostgreSQL y MySQL, con ejecución y evidencia independientes. Actor: Support; luis.david aparece como fila, membresía real por verificar.

```sql
-- PLANTILLA DOCUMENTAL; NO EJECUTADA
Misma plantilla INSERT de E01, mediante sesión Support.
```

Esperado: Tres altas si INSERT efectivo; actor y logs deben comprobarse.

- PostgreSQL: CAPS-10/14: INSERT previos; no prueban tres altas con el actor exigido.
- MySQL: CAPS-13: cinco usuarios, cuatro productos y cero logs; OFF. No acredita el actor o la carga de esta actividad; auditoría bloqueada.

## E04. Como Root modificar un usuario que no sea el mío y eliminar uno.

Objetivo: Verificar UPDATE de otra identidad y DELETE autorizado.

Motor: PostgreSQL y MySQL, con ejecución y evidencia independientes. Actor: Root / superadmin real por verificar.

```sql
-- PLANTILLA DOCUMENTAL; NO EJECUTADA
UPDATE tb_users SET email=:correo_aprobado WHERE id=:id_ajeno; DELETE FROM tb_users WHERE id=:id_para_eliminar;
```

Esperado: Una fila por operación y un log por éxito; no modificar al propio usuario. No ejecutar ahora.

- PostgreSQL: CAPS-19/20: UPDATE de alan.cruz y log 9; no prueba el actor Root ni el requisito de usuario ajeno; DELETE sin evidencia.
- MySQL: CAPS-13: cinco usuarios, cuatro productos y cero logs; OFF. No acredita el actor o la carga de esta actividad; auditoría bloqueada.

## E05. Decirle al usuario sin rol que modifique y elimine uno.

Objetivo: Verificar permisos directos UPDATE y DELETE.

Motor: PostgreSQL y MySQL, con ejecución y evidencia independientes. Actor: Usuario sin rol: identidad no confirmada.

```sql
-- PLANTILLA DOCUMENTAL; NO EJECUTADA
Plantillas UPDATE y DELETE de E04 desde sesión sin rol.
```

Esperado: Éxitos solo si permisos directos verificados; error es resultado real si faltan.

- PostgreSQL: No hay evidencia de sesión sin rol o Support para esta operación.
- MySQL: CAPS-13: cinco usuarios, cuatro productos y cero logs; OFF. No acredita el actor o la carga de esta actividad; auditoría bloqueada.

## E06. Decirle al usuario con Support que modifique y elimine uno.

Objetivo: Distinguir operación autorizada y prohibida.

Motor: PostgreSQL y MySQL, con ejecución y evidencia independientes. Actor: Support real por verificar.

```sql
-- PLANTILLA DOCUMENTAL; NO EJECUTADA
Plantillas UPDATE y DELETE de E04 desde sesión Support.
```

Esperado: Referencia P02: UPDATE permitido; DELETE denegado. Confirmar si la consigna evalúa la denegación; no conceder DELETE para forzar éxito.

- PostgreSQL: No hay evidencia de sesión sin rol o Support para esta operación.
- MySQL: CAPS-13: cinco usuarios, cuatro productos y cero logs; OFF. No acredita el actor o la carga de esta actividad; auditoría bloqueada.

## E07. Como Root insertar 2 productos.

Objetivo: Crear dos productos desde actor administrativo.

Motor: PostgreSQL y MySQL, con ejecución y evidencia independientes. Actor: Root / superadmin real por verificar.

```sql
-- PLANTILLA DOCUMENTAL; NO EJECUTADA
INSERT INTO tb_products (product_name,price,stock) VALUES (:producto1,:precio1,:stock1),(:producto2,:precio2,:stock2);
```

Esperado: Dos altas y dos logs si auditoría operativa.

- PostgreSQL: CAPS-14/16: un producto/INSERT; no dos altas de Root.
- MySQL: CAPS-13: cinco usuarios, cuatro productos y cero logs; OFF. No acredita el actor o la carga de esta actividad; auditoría bloqueada.

## E08. Al usuario vendedor 1 insertar 5 productos y vendedor 2 los 5000 productos.

Objetivo: Comprobar inserciones por dos vendedores y atribución correcta.

Motor: PostgreSQL y MySQL, con ejecución y evidencia independientes. Actor: Dos cuentas seller distintas; alias y orden por confirmar, sin equiparar filas con cuentas.

```sql
-- PLANTILLA DOCUMENTAL; NO EJECUTADA
INSERT INTO tb_products(product_name,price,stock) VALUES (:producto,:precio,:stock); repetir solo con datos propios aprobados en una prueba futura autorizada.
```

Esperado: Cinco altas y 5000 altas separadas por actor. 5007 productos solo si se parte de vacío y no hay cargas anteriores; no forzar conteo.

- PostgreSQL: No existe evidencia de cinco/5000 altas por dos cuentas seller en bd_test_alan.
- MySQL: CAPS-13: cinco usuarios, cuatro productos y cero logs; OFF. No acredita el actor o la carga de esta actividad; auditoría bloqueada.

## Casos 9 y 10: no encontrados

Búsqueda de lectura en scripts, consultas, migraciones y documentación de Practica02, Practica03, Practica_PostgreSQL y docs; contraste con la rúbrica, caps.docx, el Word anterior y las notas disponibles. Hay semillas de 5000 productos y demostraciones de la práctica local anterior, pero no una fuente de clase que identifique dos ejercicios adicionales para el manual del VPS. Los casos U/P genéricos redactados antes son propuestas, no material del profesor. Pedir al docente los dos casos faltantes y confirmar correspondencia de los ocho apartados con los indicadores 38-45. No se inventan casos.

## Privilegios y conflicto confirmado

- Los scripts del manual no incluyen CREATE ROLE/USER ni GRANT. Compose declara alan_admin, pero no prueba sus privilegios actuales ni las siete membresías reales.
- Referencia P02: support tiene SELECT/INSERT/UPDATE en bd_test.tb_users y SELECT/UPDATE en productos; no DELETE. seller tiene SELECT/INSERT/UPDATE en productos. superadmin tiene privilegios globales en ese script de otro esquema; no implica que Root sea alan.cruz o alan_admin en el VPS.
- El comentario «usuario sin rol» del archivo P02 actual acompaña a un GRANT CRUD dirigido a alan.cruz, que también recibe superadmin. Es una incoherencia local: no demuestra un usuario realmente sin rol. No se corrige P02 ni se copia ese GRANT al VPS.
- La etiqueta sin rol no es el rol common. Identificar cuenta y permisos directos antes de esta prueba. La lista exige cinco cuentas personales, mientras que esta actividad menciona un actor sin rol adicional: confirmar si es cuenta temporal autorizada o una de las existentes; no crear una sexta automáticamente.
- Support DELETE debe registrarse como denegación si se conserva la política de P02. Los triggers AFTER no registran un DELETE rechazado. Si la foto pretende éxito, hace falta aclaración de política, no conceder DELETE por conveniencia.
- Con tres altas por cada actor habría nueve INSERT de usuarios. El número final de logs depende de permisos, operaciones exitosas y estado inicial; no se insertan logs artificiales ni se exige 14/15 por apariencia.

## Tablas manuscritas: coincidencia documental, no migración

Los nombres tb_buyer_orders y tbd_order_items están definidos en Practica03/migrations/20261022_03_entidades_faltantes.sql. tbd_cart_items aparece en migraciones/consultas de integridad de Practica03 y docs/diagramas/bd_test.estructura.json. La referencia usa seller_ID y seller_order_ID en tablas llamadas buyer/orders: revisar semántica antes de copiar, no corregir nombres por intuición.

Los SQL originales del manual solo crean tb_users, tb_products y tb_logs. No prueban la existencia de esas tres tablas en bd_test_alan. No hay definición de clase suficiente para migrarlas automáticamente a PostgreSQL/MySQL del manual; faltan alcance, estructura, tipos y relaciones compatibles. Confirmar con docente si esta anotación pertenece a la siguiente práctica o a esta entrega. No se crearon tablas.

## Evidencia y conclusión

Las catorce capturas del PDF siguen válidas con su alcance limitado; no prueban autores por cada rol ni las cargas solicitadas. INSERT y UPDATE PostgreSQL están observados, DELETE no ejecutado en evidencia. MySQL OFF y cero logs impiden declarar auditoría completa. Los registros anteriores y posteriores se observan en eventos distintos; los triggers actuales no guardan OLD y NEW juntos ni actor explícito. No se reconstruye historial.

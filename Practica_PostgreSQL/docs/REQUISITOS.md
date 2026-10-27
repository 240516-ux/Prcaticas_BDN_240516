# Requisitos oficiales de Unidad 1

La rúbrica oficial ya fue recibida y leída completa: 56 indicadores, 100 puntos, siete páginas. La matriz vigente es [CUMPLIMIENTO_RUBRICA.md](CUMPLIMIENTO_RUBRICA.md), con versión CSV. Sustituye las matrices provisionales anteriores; no certifica el funcionamiento actual ni asigna una nota.

La portada puede completar institución, programa, asignatura, nombre de práctica y unidad desde la rúbrica. Solo faltan nombre completo del alumno, grupo, equipo, docente y fecha de evaluación. Matrícula 240516 y puertos 40516/40517 ya se conocen. La IP/dominio requerido por el formato de evaluación se reserva para el canal privado del profesor, no se publica en Git.

La conexión mediante SSH/docker exec no sustituye las conexiones externas exigidas. Las cuentas/roles reales no se acreditan con role_name. Los diez ejercicios de clase no vienen detallados en la lista: todavía falta ese material. PostgreSQL nativo y tokens no son indicadores expresos de esta lista; no se tratan como obligaciones sin otra instrucción oficial.

Los respaldos no aparecen como entregables obligatorios de esta rúbrica. Si otro documento los exige, deberán entregarse por canal privado aprobado; no se inventan ni publican. El PDF debe incluir control de versiones y conclusiones personales, además del desarrollo y las pruebas.

## Actualización por instrucciones manuscritas

La fotografía aporta ocho apartados de simulación para ambos motores y exige respaldos completos con datos. Ver [CASOS_SIMULACION.md](CASOS_SIMULACION.md) y [RESPALDOS_PREPARACION.md](RESPALDOS_PREPARACION.md) en docs/. Los casos 9 y 10 no se encontraron en los materiales disponibles: quedan pendientes del docente. No se inventan dividiendo UPDATE/DELETE o la actividad de vendedores.

Root, Support, usuario sin rol y dos vendedores deben identificarse como cuentas/roles reales, no por filas de tb_users. El GRANT P02 bajo el comentario sin rol apunta actualmente a alan.cruz: incoherencia que no se copia ni modifica. Support carece de DELETE en esa referencia, por lo que hay que aclarar si se evalúa una denegación. Nuevos validadores de permisos son solo lectura y no fueron ejecutados.

Los nombres tb_buyer_orders, tbd_order_items y tbd_cart_items sí aparecen en materiales de Practica03 para bd_test, pero no en los SQL de bd_test_alan. Falta confirmar alcance y definición antes de crearlos; no se importó estructura.

Solo se encontró el dump MySQL antiguo en la carpeta de respaldos del manual; no acredita el VPS actual y no se halló exportación PostgreSQL de datos. Ahora se prepararon comandos de exportación privados con destinos nuevos, contraseña interactiva y verificación de salida, tamaño y SHA-256, sin ejecutarlos. La exigencia de ambos respaldos viene de esta fotografía; sustituye la conclusión anterior de que no existía tal instrucción adicional. No se afirma restaurabilidad.

# Pendientes de entrega

Revisión documental 26/10/2026. No se ejecutaron operaciones remotas ni Git de escritura. La matriz completa conserva 56 indicadores: 15 cumplidos documentalmente, 17 parciales, 23 pendientes y 1 bloqueado; no es una calificación. El PDF es provisional.

## 1. Confirmaciones del estudiante y docente

- Completar nombre completo, grupo, equipo, docente y fecha efectiva de evaluación. Institución/programa/asignatura y matrícula 240516 ya constan. La dirección y proveedor del VPS para ficha de evaluación se entregan por canal privado, sin publicar datos de acceso.
- Personalizar conclusiones en MANUAL_ENTREGA.md (indicador 52).
- Obtener enunciados 9/10 y correspondencia de los ocho apartados con los diez casos (38-47). No inventarlos ni dividir actividades.
- Confirmar actores Root/sin rol, DELETE Support y alcance de E08/5000 productos. No ejecutar carga ni crear tablas adicionales sin definición oficial.
- Nombre de entrega aplicado según rúbrica p.7: Reporte_Unidad1_240516.pdf, idéntico al manual con nombre anterior.

## 2. Evidencia faltante sin repetir trabajo

CAPTURAS_PENDIENTES.md contiene 12 fichas indispensables, 3 de auditoría MySQL y 2 condicionadas al alcance. Algunas son series por motor/actor, no un total conocido de fotos nuevas.

- 1-4: habilitación, recursos y cuentas/permisos del VPS. DOCX-11 ya demuestra Debian, Git y Compose: NO repetir versiones por indicadores 5/6.
- 11-12: persistencia/montajes y logs propios. No reiniciar ni recrear para esta revisión.
- 15-19: firewall y clientes externos con permisos suficientes. pgAdmin está documentado, pero no equivale a acreditar todo origen externo/administración. Docker exec no satisface la nota oficial.
- 20-27: siete roles reales, cinco cuentas, membresías y privilegios por motor. role_name no sustituye catálogos.
- 30-32 y 36: restricciones de clase, alcance completo de triggers/consistencia y operaciones no observadas. PostgreSQL tiene INSERT/UPDATE históricos; no repetirlos.
- 37-47: entrega segura de accesos y ejercicios oficiales por actor/motor, sin revelar credenciales.
- Respaldos de ambos motores exigidos por la foto: solo hay un dump MySQL antiguo, no una exportación actual comprobada. RESPALDOS_PREPARACION.md tiene bloques privados preparados, no ejecutados. No afirmar restaurabilidad.

## 3. Bloqueo MySQL: indicadores 33, 35 y 36

1. Administrador identifica alan-mysql / bd_test_alan / 40517.
2. Revisa versión, log_bin, log_bin_trust_function_creators y permisos efectivos. OFF ya está capturado; falta resolución autorizada en esta instancia. No SET GLOBAL por el alumno ni reinicios por esta tarea.
3. Tras respaldo e inventario, autoriza únicamente triggers/vistas que falten. No reimportar mysql.sql completo ni reemplazar datos.
4. Verifica seis triggers, dos vistas y sus definiciones. Una vista puede consultarse por lectura aun con OFF si existe; no confundir ese permiso con auditoría funcionando.
5. En operaciones oficiales futuras autorizadas, comprobar un evento por operación y coherencia de vistas. No duplicar escrituras históricas. M01-M03 especifican evidencia.

## 4. Cierre documental y Git

El manual integra 39 imágenes de 57 originales; 18 excluidas con motivo no son 18 capturas pendientes. Las secuencias pgAdmin y trazabilidad ya están incorporadas y protegidas. Algunos JSON estaban truncados en origen: no se afirma detalle exhaustivo.

48: completar campos de portada. 52: confirmar conclusiones personales. 53: completar solo etapas/casos sin evidencia. 54 y 56: comprobar privacidad y autorizar fusión después. 55: commits verificados; no volver a crearlos. Los commits 3463afd/10c3fe0 ya están publicados en rama segura; esta revisión no hace push ni merge a main.

Siguiente acción: solicitar al docente casos 9/10 y política Support/actores, y al administrador resolución de auditoría MySQL. Mientras responde, completar portada y capturar conexiones externas/roles mediante lecturas autorizadas. Después actualizar matriz y PDF, sin dar la entrega por terminada anticipadamente.


## Rama de nombre normal: limitación de seguridad

Manual_VPS_BDs_Relacionales existe con 9319fb8 y ascendencia sensible. No se puede conservar intacta su referencia y convertir esa misma historia en limpia simultáneamente. Se conserva local, sin push ni reescritura. Autorizar por separado la preservación de su referencia bajo otro nombre y asignación del nombre de entrega a la historia segura, o aceptar el nombre seguro existente. Ninguna de esas operaciones se ejecuta automáticamente.

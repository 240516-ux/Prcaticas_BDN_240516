# Publicación segura del proyecto

Estado del 22/10/2026: los commits de avances se conservan localmente en `Practica03`. **Push detenido** por exposición de credenciales y datos sensibles en archivos ya presentes en `origin/Practica03`. No se cambiaron contraseñas, se retiraron archivos del índice ni se reescribió el historial.

## Evidencia sin revelar valores

| Archivo seguido por Git | Riesgo confirmado | Evidencia de historial |
|---|---|---|
| `Practica02/scripts/remote_users_privileges_creation.sql` | Contraseñas SQL literales | Commit `86d3330`, incluido en la rama remota de trabajo |
| `Practica03/scripts/remote_users_privileges_creation.sql` | Contraseñas SQL literales | Commits `40ec3b1`, `eccd73a` y `768c4d0` |
| `Practica02/backups/respaldo_30092026.sql` | Filas de usuarios y valores del campo password | Versión sensible en `768c4d0` |
| `Practica03/backups/resoaldo_0710.sql` | Filas de usuarios y valores del campo password | Commit `768c4d0` |

La credencial leída del script local para la conexión autorizada funcionó en MySQL y coincide con la definición de esa cuenta en el script remoto. Esto confirma un riesgo vigente; no se publican el valor ni una huella de esa contraseña. No se probó la vigencia de las demás contraseñas expuestas.

Los archivos nuevos de documentación y migraciones se revisan por separado. Un diff seguro no sanea los secretos heredados de los commits anteriores. Cambiar el nombre de un archivo o añadirlo a `.gitignore` tampoco elimina su contenido histórico.

## Procedimiento propuesto, no ejecutado

1. **Preservar el trabajo.** Crear una copia privada fuera del repositorio con el directorio Git, los archivos seguidos y los no seguidos. Registrar rama, HEAD, estado del índice y cambios locales. No crear una copia de respaldo dentro del repositorio ni publicarla.
2. **Revocar o rotar las credenciales expuestas.** Coordinar con el titular de cada cuenta. Usar entrada protegida o un gestor de secretos, nunca contraseñas literales en comandos compartidos, capturas, documentación o nuevos scripts versionados. Actualizar Workbench y las conexiones del proyecto; comprobar acceso con la credencial nueva y rechazo de la anterior. Revisar otros servicios si se reutilizaron las contraseñas. Estos cambios necesitan autorización y no se han realizado.
3. **Preparar versiones publicables.** Sustituir los scripts con credenciales por instrucciones o plantillas sin valores reales, conservando antes sus originales locales. Mantener los respaldos completos en almacenamiento privado. Revisar también el campo password de las cuentas de aplicación contenidas en los respaldos: no se presupone su formato ni su vigencia.
4. **Excluir archivos nuevos específicamente.** Revisar reglas para `.env`, archivos de claves privadas, `Practica02/backups/`, `Practica03/backups/`, cachés y recibos de diagnóstico locales. Mantener ejemplos de configuración sin secretos cuando existan. No excluir globalmente SQL, CSV, JSON, SVG o Excel.
5. **Tratar los archivos ya seguidos por separado.** Solo con aprobación expresa, preparar una retirada del seguimiento que conserve los archivos locales, y revisar el diff antes de confirmar ese cambio. No ejecutar eliminaciones ni retirar entradas preexistentes del índice automáticamente. La retirada de seguimiento no elimina versiones antiguas.
6. **Decidir el tratamiento del historial compartido.** Coordinar con colaboradores antes de plantear cualquier limpieza. Las alternativas son mantener el repositorio con acceso restringido y credenciales ya revocadas, preparar una copia publicable limpia en un repositorio separado, o acordar una reescritura explícitamente autorizada con copias de seguridad y consecuencias para otros clones. No se ha elegido ni ejecutado ninguna alternativa. No usar force push como parte del trabajo rutinario.
7. **Reanudar la publicación solo tras verificar el riesgo.** Comprobar rama y remoto, revisar cada commit pendiente y sus archivos, confirmar que las credenciales antiguas ya no funcionan y resolver la exposición residual de datos privados. Si el remoto avanzó, inspeccionar las diferencias antes de integrar cambios; no sobrescribirlo.

## Exclusiones propuestas

Estas reglas ilustran el alcance a revisar; **no se han aplicado** ni sustituyen la retirada autorizada de archivos ya seguidos:

```gitignore
.env
.env.*
!.env.example
*.pem
*.key
*.p12
*.pfx
Practica02/backups/
Practica03/backups/
__pycache__/
*.pyc
*.tmp
~$*
docs/auditoria_20261022.json
docs/diccionario_datos.xlsx.inspect.ndjson
docs/diagramas/*.browser-check.json
docs/diagramas/*.delivery.json
docs/diagramas/*.finalize.json
docs/diagramas/*.finalize-summary.json
```

Antes de adoptar una regla, comprobar que no oculte un archivo de trabajo necesario. Los scripts personales y otras exclusiones se revisarían por ruta exacta; no se moverán ni borrarán para evitar su publicación.

## Criterio para los commits actuales

Seleccionar únicamente documentación, imágenes y consultas necesarias para la tarea mediante rutas explícitas. Revisar `git status --short`, rama, remoto, `git diff --cached --name-status` y el contenido íntegro del índice. Mantener fuera respaldos, credenciales, recibos locales y cambios previos ajenos. Los commits locales pueden conservar el avance mientras la publicación permanece detenida.

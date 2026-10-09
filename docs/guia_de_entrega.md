# Guía de entrega y ejecución

La base se llama **bd_test**. Las ramas son **main**, **Practica02** y **Practica03**. La rama Practica03 contiene la entrega completa; Practica02 conserva la etapa anterior y main conserva el punto base del historial.

## Archivos incluidos

| Carpeta o archivo | Contenido |
|---|---|
| Practica02/scripts | Instalación de tablas, seis triggers y vistas; seis cuentas y roles |
| Practica03/scripts | Instalación completa, doce triggers, vistas, tres procedimientos, función, evento y cuentas |
| Practica02/seeds | CSV de 5,000 productos y script de carga del vendedor |
| Practica03/seeds | CSV de categorías, productos y relaciones; scripts de carga por usuario |
| Practica02/backups/respaldo_funcional.sql | Dump completo de la etapa con 5,000 productos y su bitácora |
| Practica03/backups/respaldo_funcional.sql | Dump completo con 15,000 productos, 100 categorías y 41,696 relaciones |
| queries/consultas_verificacion.sql | Consultas de inspección de cada práctica |
| queries/verificacion_funcional.sql | Comprobaciones con resultado OK o ERROR |
| scripts/verificar_practica.ps1 | Verificador automático que falla si alguna comprobación no pasa |
| scripts/crear_respaldo.ps1 | Exporta todos los objetos y datos de bd_test y copia el script de cuentas y roles |
| readme.md de cada práctica | Orden de instalación, conexión, cargas y restauración |
| Practica03/verificacion.txt | Evidencia de las pruebas realizadas |

## Verificar la entrega

Ejecutar desde la raíz del repositorio después de instalar y cargar la práctica correspondiente. Los conteos esperados corresponden a las semillas incluidas; si agregas o eliminas productos después, esos conteos cambiarán.

```powershell
.\scripts\verificar_practica.ps1 -Practica 03
# Para un servidor remoto:
.\scripts\verificar_practica.ps1 -Practica 03 -Server IP_DEL_SERVIDOR -Port 3306 -User alan.cruz
```

La contraseña se solicita de forma interactiva. El verificador necesita una cuenta administradora para revisar las cuentas y los roles. El planificador de eventos debe estar activo para que pase la comprobación de eventos: el administrador puede habilitarlo con `SET GLOBAL event_scheduler=ON;`.

## Crear otro respaldo completo

```powershell
.\scripts\crear_respaldo.ps1 -Practica 03
```

Se generan dos archivos con fecha: el dump completo de bd_test y el script de las seis cuentas y sus roles. Para restaurar, importar primero el dump y después el script de usuarios. Las cuentas son objetos del servidor MySQL y se guardan aparte de los objetos de la base.

## Nombres de usuario sin host

Las vistas de trazabilidad muestran `bryan.javier` e `ivan.ojeda`, sin `@localhost`. Las seis cuentas solicitadas están creadas con host `%` para permitir conexiones remotas. La bitácora guarda únicamente el nombre del usuario; no conserva el host. Los DEFINER de los objetos pueden contener `root@localhost`: identifican la cuenta que creó los objetos y no son los nombres visibles de los vendedores.

## Instalación y restauración

Consultar los README de cada práctica. Elegir instalación con semillas **o** restauración del respaldo funcional. Cargar otra vez las mismas semillas después de restaurar duplicaría los SKU y produciría errores. Los respaldos con fechas del repositorio original conservan las estructuras históricas; el respaldo completo con datos propios es `respaldo_funcional.sql`.

## Instalación local comprobada

El servidor de este equipo está en 127.0.0.1:40516. Usar -Port 40516 en los scripts PowerShell y -P 40516 en mysql. Consultar [las llaves y la trazabilidad](llaves_y_trazabilidad.md). La entrega completa incluye también la semilla de seis usuarios ficticios y el script 01_normalizar_bitacora.sql para corregir una base ya instalada.

La corrección vigente elimina la columna connection_host de tb_logs y descarta el host de los registros de auditoría. Los triggers y respaldos vigentes guardan únicamente el nombre de usuario.

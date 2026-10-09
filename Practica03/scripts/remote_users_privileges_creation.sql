/* ============================================================
   CREACIÓN DE USUARIOS REMOTOS
   ============================================================ */

CREATE USER IF NOT EXISTS 'marco.ramirez'@'%'
IDENTIFIED BY 'qwerty123';

CREATE USER IF NOT EXISTS 'alan.cruz'@'%'
IDENTIFIED BY '240516';

CREATE USER IF NOT EXISTS 'ivan.macin'@'%'
IDENTIFIED BY '240793';

CREATE USER IF NOT EXISTS 'luis.david'@'%'
IDENTIFIED BY '240666';

CREATE USER IF NOT EXISTS 'ivan.ojeda'@'%'
IDENTIFIED BY '240136';

CREATE USER IF NOT EXISTS 'bryan.javier'@'%'
IDENTIFIED BY '240078';


/* ============================================================
   ASIGNACIÓN DE PRIVILEGIOS DIRECTOS
   ============================================================ */

/*
IMPORTANTE:
Este privilegio solamente debe asignarse al usuario administrador
*/

GRANT ALL PRIVILEGES ON *.*
TO 'alan.cruz'@'%';


/*
Asignar privilegios CRUD sobre la base bd_test. solo 1 vez al usuario sin rol
no es considerada una buena práctica ya podría generar problemas de seguridad, 
pero es para fines de aprendizaje.
*/

GRANT SELECT, INSERT, UPDATE, DELETE
ON bd_test.*
TO 'ivan.macin'@'%';


/* ============================================================
   CREACIÓN DE ROLES PARA EL SISTEMA E-COMMERCE
   ============================================================ */

CREATE ROLE IF NOT EXISTS 'superadmin';
CREATE ROLE IF NOT EXISTS 'admin';
CREATE ROLE IF NOT EXISTS 'seller';
CREATE ROLE IF NOT EXISTS 'buyer';
CREATE ROLE IF NOT EXISTS 'support';
CREATE ROLE IF NOT EXISTS 'common';
CREATE ROLE IF NOT EXISTS 'user_not_registered';


/* ============================================================
   ASIGNACIÓN DE PRIVILEGIOS A LOS ROLES
   ============================================================ */

/* SUPERADMIN */
GRANT ALL PRIVILEGES
ON *.*
TO 'superadmin';    

/* ADMIN */
GRANT ALL PRIVILEGES
ON bd_test.*
TO 'admin';


/* SUPPORT */
GRANT SELECT, INSERT, UPDATE
ON bd_test.tb_users
TO 'support';

GRANT SELECT, UPDATE
ON bd_test.tb_products
TO 'support';

GRANT SELECT 
ON bd_test.tbc_categories
TO 'support';

GRANT SELECT, INSERT, UPDATE 
ON bd_test.tbd_products_categories
TO 'support';



/* SELLER */
GRANT SELECT, INSERT, UPDATE
ON bd_test.tb_products
TO 'seller';

GRANT SELECT
ON bd_test.tbc_categories
TO 'seller';

/* ============================================================
   ASIGNACIÓN DE ROLES A LOS USUARIOS
   ============================================================ */

-- Este deben ser ustedes
GRANT 'superadmin'
TO 'alan.cruz'@'%';

-- Este debe ser el Prof. Marco
GRANT 'admin'
TO 'marco.ramirez'@'%';

-- SOPORTE
GRANT 'support'
TO 'luis.david'@'%';

-- VENDEDORES
GRANT 'seller'
TO 'bryan.javier'@'%';

GRANT 'seller'
TO 'ivan.ojeda'@'%';

/* ============================================================
   ESTABLECER ROLES PREDETERMINADOS
   ============================================================ */

/*
Esto permite que el rol se active automáticamente cuando
el usuario inicia sesión.
*/
SET DEFAULT ROLE 'superadmin'
TO 'alan.cruz'@'%';

SET DEFAULT ROLE 'admin'
TO 'marco.ramirez'@'%';

SET DEFAULT ROLE 'support'
TO 'luis.david'@'%';

SET DEFAULT ROLE 'seller'
TO 'bryan.javier'@'%';
SET DEFAULT ROLE 'seller'
TO 'ivan.ojeda'@'%';


/* ============================================================
   MENSAJE DE CONFIRMACIÓN
   ============================================================ */

SELECT "Los usuarios y privilegios han sido creados correctamente" AS mensaje;






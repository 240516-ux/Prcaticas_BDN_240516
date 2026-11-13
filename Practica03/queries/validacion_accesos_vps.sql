-- Ejecutar en el VPS con una cuenta administrativa. Solo lectura.
SELECT @@hostname AS servidor, VERSION() AS version_mysql, CURRENT_USER() AS cuenta;

WITH roles AS (
    SELECT 'superadmin' AS rol UNION ALL SELECT 'admin'
    UNION ALL SELECT 'support' UNION ALL SELECT 'seller'
    UNION ALL SELECT 'buyer' UNION ALL SELECT 'common_user'
    UNION ALL SELECT 'user_not_registered'
)
SELECT r.rol, u.Host, u.account_locked,
       IF(u.User IS NULL, 'FALTA', 'EXISTE') AS estado
FROM roles r LEFT JOIN mysql.user u ON u.User = r.rol
ORDER BY r.rol, u.Host;

SELECT u.User, u.Host, u.account_locked,
       e.FROM_USER AS rol, e.FROM_HOST AS host_rol,
       IF(d.DEFAULT_ROLE_USER IS NULL, 'NO', 'SI') AS predeterminado
FROM mysql.user u
LEFT JOIN mysql.role_edges e ON e.TO_USER = u.User AND e.TO_HOST = u.Host
LEFT JOIN mysql.default_roles d ON d.USER = u.User AND d.HOST = u.Host
    AND d.DEFAULT_ROLE_USER = e.FROM_USER AND d.DEFAULT_ROLE_HOST = e.FROM_HOST
WHERE u.User IN ('alan.cruz', 'bryan.javier', 'joseluis.bernabe')
ORDER BY u.User, u.Host, e.FROM_USER;

-- Ejecutar los SHOW GRANTS devueltos para revisar los permisos de cada rol existente.
SELECT CONCAT('SHOW GRANTS FOR ', QUOTE(User), '@', QUOTE(Host), ';') AS consulta
FROM mysql.user
WHERE User IN ('superadmin','admin','support','seller','buyer','common_user','user_not_registered');

SELECT ID, nick, status + 0 AS activo FROM bd_test.tb_users
WHERE nick IN ('alan.cruz', 'bryan.javier', 'joseluis.bernabe');

-- Repetir en cada conexión personal para acreditar el rol activo de esa sesión.
-- USE bd_test;
-- SELECT DATABASE(), USER(), CURRENT_USER(), CURRENT_ROLE();
-- SHOW SESSION STATUS LIKE 'Ssl_cipher';

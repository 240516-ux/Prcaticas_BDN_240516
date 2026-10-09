USE bd_test;
-- Datos ficticios de demostración: los correos example.test no son direcciones reales.
-- Ejecutar como luis.david; no son las cuentas de acceso de MySQL.
-- Los hashes corresponden a secretos aleatorios; no habilitan un inicio de sesión de aplicación.
-- Reejecutable: no modifica ni duplica registros que ya tengan el correo o el nick.
START TRANSACTION;
INSERT INTO tb_users(email,nick,password,status) SELECT 'alan.cruz@example.test','alan.cruz','scrypt$16384$8$1$74f653d9aa80e29b5bf1b9f80a57691e$c925fd0fc0f386de16f3955ec6e2ec00269e14ec243dc4e09877d68727a3c826',b'1' WHERE NOT EXISTS(SELECT 1 FROM tb_users WHERE email='alan.cruz@example.test' OR nick='alan.cruz');
INSERT INTO tb_users(email,nick,password,status) SELECT 'marco.ramirez@example.test','marco.ramirez','scrypt$16384$8$1$1f607ff713f1d25564b412bff1d7dbe8$9c4e1f1607ac43dea6147288f81a9d6abc0a1722bc12e088f4dab4112910f6dc',b'1' WHERE NOT EXISTS(SELECT 1 FROM tb_users WHERE email='marco.ramirez@example.test' OR nick='marco.ramirez');
INSERT INTO tb_users(email,nick,password,status) SELECT 'luis.david@example.test','luis.david','scrypt$16384$8$1$f1d36644088a8ad992192017d10925fc$de8397e508a1882f7939ac5c2a647a9a9f5e118e892880c02fc92382cf403508',b'1' WHERE NOT EXISTS(SELECT 1 FROM tb_users WHERE email='luis.david@example.test' OR nick='luis.david');
INSERT INTO tb_users(email,nick,password,status) SELECT 'bryan.javier@example.test','bryan.javier','scrypt$16384$8$1$ec195086ad92a37649fc3d3b75e71ac0$cf05cac2fd34b08094153451096e848f170129c51df07bc2940797e0f0e0791c',b'1' WHERE NOT EXISTS(SELECT 1 FROM tb_users WHERE email='bryan.javier@example.test' OR nick='bryan.javier');
INSERT INTO tb_users(email,nick,password,status) SELECT 'ivan.ojeda@example.test','ivan.ojeda','scrypt$16384$8$1$f45c5ef93afc737df1ab291caba9e093$b56fc9779c49ae756417bfd51eae6ffbd37fd4af74dd93830f7d7ae056163edb',b'1' WHERE NOT EXISTS(SELECT 1 FROM tb_users WHERE email='ivan.ojeda@example.test' OR nick='ivan.ojeda');
INSERT INTO tb_users(email,nick,password,status) SELECT 'ivan.macin@example.test','ivan.macin','scrypt$16384$8$1$e31289987f0944cf471c3f0d583b3696$73539d1f54958c3ba8fc0e4676ef9e66941569238bafeecf3c180cb6f2819643',b'1' WHERE NOT EXISTS(SELECT 1 FROM tb_users WHERE email='ivan.macin@example.test' OR nick='ivan.macin');
COMMIT;
SELECT nick,email,status+0 AS activo FROM tb_users WHERE email LIKE '%@example.test' ORDER BY nick;

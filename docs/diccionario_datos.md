# Diccionario de datos de bd_test

Consulta real: 2026-10-22T10:02:06.041713. MySQL 8.0.42.
Fuentes: INFORMATION_SCHEMA y COUNT(*). Sin datos de usuarios ni hashes de contraseña.
Las dependencias de vistas se identifican por referencias a nombres de tablas en su definición.
Las descripciones de negocio sin comentario en la base quedan pendientes de confirmar.

## Totales

| Tabla | Filas |
|---|---:|
| tb_carts | 0 |
| tb_logs | 41839 |
| tb_logs_productos | 15007 |
| tb_products | 15007 |
| tb_users | 6 |
| tbc_categories | 100 |
| tbc_payment_methods_types | 0 |
| tbd_cart_items | 0 |
| tbd_products_categories | 41713 |
| tbd_user_payment_methods | 0 |

## tb_carts

Descripción: Pendiente de confirmar

| Columna | Tipo | NULL | Predeterminado | Claves/índices | Referencia |
|---|---|---|---|---|---|
| ID | int unsigned | NO | null | PRIMARY UNIQUE |  |
| user_ID | int unsigned | NO | null |  |  |
| creation_date | datetime | NO | "CURRENT_TIMESTAMP" |  |  |

Triggers: Ninguno.
Vistas directas: Ninguna.

```sql
CREATE TABLE `tb_carts` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `user_ID` int unsigned NOT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

## tb_logs

Descripción: Pendiente de confirmar

| Columna | Tipo | NULL | Predeterminado | Claves/índices | Referencia |
|---|---|---|---|---|---|
| ID | int | NO | null | PRIMARY UNIQUE |  |
| table_name | varchar(100) | NO | null | ix_trace |  |
| table_operation | enum('Create','Read','Update','Delete') | NO | null | ix_trace |  |
| db_user | varchar(80) | NO | null |  |  |
| operation_description | text | NO | null |  |  |
| operation_date | datetime | NO | "CURRENT_TIMESTAMP" |  |  |
| operation_status | bit(1) | YES | "b'1'" |  |  |
| record_id | int unsigned | YES | null | ix_trace |  |
| record_key | varchar(100) | YES | null |  |  |
| actor_roles | varchar(255) | YES | null |  |  |

Triggers: Ninguno.
Vistas directas: vw_trazabilidad_usuarios; vw_bitacora_usuarios; vw_trazabilidad_categorias; vw_trazabilidad_categorizacion_productos.

```sql
CREATE TABLE `tb_logs` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `table_name` varchar(100) NOT NULL,
  `table_operation` enum('Create','Read','Update','Delete') NOT NULL,
  `db_user` varchar(80) NOT NULL,
  `operation_description` text NOT NULL,
  `operation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `operation_status` bit(1) DEFAULT b'1',
  `record_id` int unsigned DEFAULT NULL,
  `record_key` varchar(100) DEFAULT NULL,
  `actor_roles` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `ix_trace` (`table_name`,`record_id`,`table_operation`)
) ENGINE=InnoDB AUTO_INCREMENT=46847 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

## tb_logs_productos

Descripción: Pendiente de confirmar

| Columna | Tipo | NULL | Predeterminado | Claves/índices | Referencia |
|---|---|---|---|---|---|
| ID | int | NO | null | PRIMARY UNIQUE |  |
| table_name | varchar(100) | NO | null | ix_trace |  |
| table_operation | enum('Create','Read','Update','Delete') | NO | null | ix_trace |  |
| db_user | varchar(80) | NO | null |  |  |
| operation_description | text | NO | null |  |  |
| operation_date | datetime | NO | "CURRENT_TIMESTAMP" |  |  |
| operation_status | bit(1) | YES | "b'1'" |  |  |
| record_id | int unsigned | YES | null | ix_trace |  |
| record_key | varchar(100) | YES | null |  |  |
| actor_roles | varchar(255) | YES | null |  |  |

Triggers: Ninguno.
Vistas directas: vw_trazabilidad_productos.

```sql
CREATE TABLE `tb_logs_productos` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `table_name` varchar(100) NOT NULL,
  `table_operation` enum('Create','Read','Update','Delete') NOT NULL,
  `db_user` varchar(80) NOT NULL,
  `operation_description` text NOT NULL,
  `operation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `operation_status` bit(1) DEFAULT b'1',
  `record_id` int unsigned DEFAULT NULL,
  `record_key` varchar(100) DEFAULT NULL,
  `actor_roles` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `ix_trace` (`table_name`,`record_id`,`table_operation`)
) ENGINE=InnoDB AUTO_INCREMENT=15022 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

## tb_products

Descripción: Pendiente de confirmar

| Columna | Tipo | NULL | Predeterminado | Claves/índices | Referencia |
|---|---|---|---|---|---|
| ID | int unsigned | NO | null | PRIMARY UNIQUE |  |
| SKU | varchar(50) | NO | null | SKU UNIQUE |  |
| name | varchar(250) | NO | null |  |  |
| description | text | YES | null |  |  |
| current_price | decimal(10,2) | NO | "0.00" |  |  |
| current_stock | int unsigned | NO | "0" |  |  |
| status | bit(1) | YES | "b'1'" |  |  |
| creation_date | datetime | NO | "CURRENT_TIMESTAMP" |  |  |
| last_update | datetime | NO | "CURRENT_TIMESTAMP" |  |  |

Triggers: trg_products_after_delete (AFTER DELETE); trg_products_after_insert (AFTER INSERT); trg_products_after_update (AFTER UPDATE).
Vistas directas: vw_trazabilidad_productos; vw_total_products_by_category.

```sql
CREATE TABLE `tb_products` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `SKU` varchar(50) NOT NULL,
  `name` varchar(250) NOT NULL,
  `description` text,
  `current_price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `current_stock` int unsigned NOT NULL DEFAULT '0',
  `status` bit(1) DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `SKU` (`SKU`)
) ENGINE=InnoDB AUTO_INCREMENT=15008 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

## tb_users

Descripción: Pendiente de confirmar

| Columna | Tipo | NULL | Predeterminado | Claves/índices | Referencia |
|---|---|---|---|---|---|
| ID | int | NO | null | PRIMARY UNIQUE |  |
| email | varchar(80) | NO | null | email UNIQUE |  |
| nick | varchar(100) | NO | null | nickname UNIQUE |  |
| password | varchar(255) | NO | null |  |  |
| creation_date | datetime | NO | "CURRENT_TIMESTAMP" |  |  |
| last_update | datetime | YES | "CURRENT_TIMESTAMP" |  |  |
| last_login | datetime | YES | null |  |  |
| status | bit(1) | NO | "b'1'" |  |  |

Triggers: trg_users_after_insert (AFTER INSERT); trg_users_after_update (AFTER UPDATE); trg_users_after_delete (AFTER DELETE).
Vistas directas: vw_trazabilidad_usuarios.

```sql
CREATE TABLE `tb_users` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `email` varchar(80) NOT NULL,
  `nick` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_login` datetime DEFAULT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `nickname` (`nick`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

## tbc_categories

Descripción: Pendiente de confirmar

| Columna | Tipo | NULL | Predeterminado | Claves/índices | Referencia |
|---|---|---|---|---|---|
| ID | int unsigned | NO | null | PRIMARY UNIQUE |  |
| name | varchar(120) | NO | null | name UNIQUE |  |
| description | text | YES | null |  |  |
| sup_id_category | int unsigned | YES | null | fk_superior_category | tbc_categories.ID |
| status | bit(1) | NO | "b'1'" |  |  |
| creation_date | datetime | NO | "CURRENT_TIMESTAMP" |  |  |
| last_update | datetime | NO | "CURRENT_TIMESTAMP" |  |  |

Triggers: trg_categories_after_insert (AFTER INSERT); trg_categories_after_update (AFTER UPDATE); trg_categories_after_delete (AFTER DELETE).
Vistas directas: vw_total_products_by_category.

```sql
CREATE TABLE `tbc_categories` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) NOT NULL,
  `description` text,
  `sup_id_category` int unsigned DEFAULT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `name` (`name`),
  KEY `fk_superior_category` (`sup_id_category`),
  CONSTRAINT `fk_superior_category` FOREIGN KEY (`sup_id_category`) REFERENCES `tbc_categories` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

## tbc_payment_methods_types

Descripción: Pendiente de confirmar

| Columna | Tipo | NULL | Predeterminado | Claves/índices | Referencia |
|---|---|---|---|---|---|
| ID | int unsigned | NO | null | PRIMARY UNIQUE |  |
| code | varchar(30) | NO | null | code_UNIQUE UNIQUE |  |
| description | text | NO | null |  |  |
| status | bit(1) | NO | "b'1'" |  |  |
| creation_date | datetime | NO | "CURRENT_TIMESTAMP" |  |  |
| last_update | datetime | YES | null |  |  |

Triggers: Ninguno.
Vistas directas: Ninguna.

```sql
CREATE TABLE `tbc_payment_methods_types` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(30) NOT NULL,
  `description` text NOT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

## tbd_cart_items

Descripción: Pendiente de confirmar

| Columna | Tipo | NULL | Predeterminado | Claves/índices | Referencia |
|---|---|---|---|---|---|
| cart_ID | int unsigned | NO | null | PRIMARY UNIQUE | tb_carts.ID |
| provider_ID | int unsigned | NO | null | PRIMARY UNIQUE |  |
| product_ID | int unsigned | NO | null | PRIMARY UNIQUE |  |
| quantity | int unsigned | NO | "1" |  |  |
| creation_date | datetime | NO | "CURRENT_TIMESTAMP" |  |  |

Triggers: Ninguno.
Vistas directas: Ninguna.

```sql
CREATE TABLE `tbd_cart_items` (
  `cart_ID` int unsigned NOT NULL,
  `provider_ID` int unsigned NOT NULL,
  `product_ID` int unsigned NOT NULL,
  `quantity` int unsigned NOT NULL DEFAULT '1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`cart_ID`,`provider_ID`,`product_ID`),
  CONSTRAINT `fk_cart_items_cart` FOREIGN KEY (`cart_ID`) REFERENCES `tb_carts` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `chk_cart_quantity` CHECK ((`quantity` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

## tbd_products_categories

Descripción: Pendiente de confirmar

| Columna | Tipo | NULL | Predeterminado | Claves/índices | Referencia |
|---|---|---|---|---|---|
| category_ID | int unsigned | NO | null | PRIMARY UNIQUE | tbc_categories.ID |
| product_ID | int unsigned | NO | null | PRIMARY UNIQUE; fk_product | tb_products.ID |
| status | bit(1) | NO | "b'1'" |  |  |
| creation_date | datetime | NO | "CURRENT_TIMESTAMP" |  |  |
| last_update | datetime | NO | "CURRENT_TIMESTAMP" |  |  |

Triggers: trg_products_categories_after_insert (AFTER INSERT); trg_products_categories_after_update (AFTER UPDATE); trg_products_categories_after_delete (AFTER DELETE).
Vistas directas: vw_total_products_by_category.

```sql
CREATE TABLE `tbd_products_categories` (
  `category_ID` int unsigned NOT NULL,
  `product_ID` int unsigned NOT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_ID`,`product_ID`),
  KEY `fk_product` (`product_ID`),
  CONSTRAINT `fk_category` FOREIGN KEY (`category_ID`) REFERENCES `tbc_categories` (`ID`),
  CONSTRAINT `fk_product` FOREIGN KEY (`product_ID`) REFERENCES `tb_products` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

## tbd_user_payment_methods

Descripción: Pendiente de confirmar

| Columna | Tipo | NULL | Predeterminado | Claves/índices | Referencia |
|---|---|---|---|---|---|
| ID | bigint unsigned | NO | null | PRIMARY UNIQUE |  |
| user_ID | int | NO | null | idx_user_ID | tb_users.ID |
| payment_method_type_ID | int unsigned | NO | null | idx_payment_method_type_ID | tbc_payment_methods_types.ID |
| provider | varchar(60) | NO | null | uk_provider_method UNIQUE |  |
| provider_method_ref | varchar(255) | NO | null | uk_provider_method UNIQUE |  |
| label | varchar(100) | YES | null |  |  |
| last_four | char(4) | YES | null |  |  |
| is_default | tinyint(1) | NO | "0" |  |  |
| status | bit(1) | NO | "b'1'" |  |  |
| creation_date | datetime | NO | "CURRENT_TIMESTAMP" |  |  |
| last_update | datetime | YES | null |  |  |

Triggers: Ninguno.
Vistas directas: Ninguna.

```sql
CREATE TABLE `tbd_user_payment_methods` (
  `ID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_ID` int NOT NULL,
  `payment_method_type_ID` int unsigned NOT NULL,
  `provider` varchar(60) NOT NULL,
  `provider_method_ref` varchar(255) NOT NULL,
  `label` varchar(100) DEFAULT NULL,
  `last_four` char(4) DEFAULT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uk_provider_method` (`provider`,`provider_method_ref`),
  KEY `idx_user_ID` (`user_ID`),
  KEY `idx_payment_method_type_ID` (`payment_method_type_ID`),
  CONSTRAINT `fk_user_payment_methods_type` FOREIGN KEY (`payment_method_type_ID`) REFERENCES `tbc_payment_methods_types` (`ID`),
  CONSTRAINT `fk_user_payment_methods_user` FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

## Restricciones y auditoría

Las definiciones anteriores incluyen índices, CHECK, reglas ON DELETE/UPDATE y claves compuestas. tb_logs y tb_logs_productos conservan historia sin FK a las entidades. No añadir una FK que impida conservar eliminaciones.
Los 12 triggers son AFTER y registran una operación en una bitácora: productos en tb_logs_productos; usuarios, categorías y relaciones en tb_logs. Las modificaciones se registran incluso cuando UPDATE no cambia valores. actor_roles consulta roles asignados de mysql.role_edges, no acredita cuáles estaban activos; solo filtra host %. USER() identifica la cuenta de conexión, no la persona física.

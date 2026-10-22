# Diccionario de datos de bd_test

Estructura obtenida directamente de MySQL 8.0.42 el 2026-10-22T12:21:39.
17 tablas físicas, 135 columnas, 19 FK, 45 triggers y 6 vistas. No se ejecutaron migraciones ni escrituras.
Los conteos son datos, no estructura: se documentan por separado en [el informe de conteos](diagramas/CONTEOS_bd_test.md).
Fuente: INFORMATION_SCHEMA y SHOW CREATE TABLE. Los módulos son una agrupación documental; no crean esquemas ni relaciones.
SQL NULL se muestra como `null`; las cadenas predeterminadas conservan comillas JSON. Las longitudes, precisión y escala están disponibles en CSV/XLSX.
Las marcas PK/FK/UK significan participación en claves; una columna de una UK compuesta no es única por sí sola.
Las descripciones sin comentario real quedan pendientes de confirmar. No se incluyen filas de usuarios, contraseñas ni otros datos personales.

## Índice por módulo

- **Identidad**: `tb_users`, `tb_people`.
- **Direcciones**: `tb_user_addresses`, `tbd_address_components`.
- **Pagos**: `tbc_payment_methods_types`, `tbd_user_payment_methods`.
- **Catálogo**: `tb_products`, `tbc_categories`, `tbd_products_users_providers`, `tbd_products_categories`.
- **Ventas**: `tb_carts`, `tbd_cart_items`, `tb_buyer_orders`, `tbd_order_items`, `tbd_users_wishlist_products`.
- **Auditoría**: `tb_logs`, `tb_logs_productos`.

## Identidad

### tb_users

Motor: InnoDB. Collation: utf8mb4_0900_ai_ci.
Descripción: Pendiente de confirmar; sin comentario de tabla en MySQL.

| Columna | Tipo exacto | NULL | Predeterminado | Claves | Extra / generación |
|---|---|---|---|---|---|
| ID | int | NO | null | PRIMARY | auto_increment  |
| email | varchar(80) | NO | null | email |   |
| nick | varchar(100) | NO | null | nickname |   |
| password | varchar(255) | NO | null |  |   |
| creation_date | datetime | NO | "CURRENT_TIMESTAMP" |  | DEFAULT_GENERATED  |
| last_update | datetime | YES | "CURRENT_TIMESTAMP" |  | DEFAULT_GENERATED on update CURRENT_TIMESTAMP  |
| last_login | datetime | YES | null |  |   |
| status | bit(1) | NO | "b'1'" |  |   |

**Índices**

| Nombre | Columnas en orden | Unicidad | Tipo |
|---|---|---|---|
| email | email | UNIQUE | BTREE |
| nickname | nick | UNIQUE | BTREE |
| PRIMARY | ID | UNIQUE | BTREE |

**Claves foráneas declaradas**

| Restricción | Columnas hijas | Tabla padre | Columnas padre | DELETE | UPDATE |
|---|---|---|---|---|---|

**Triggers**
- `trg_users_after_delete`: AFTER DELETE; registra el evento en `tb_logs`.
- `trg_users_after_insert`: AFTER INSERT; registra el evento en `tb_logs`.
- `trg_users_after_update`: AFTER UPDATE; registra el evento en `tb_logs`.

Vistas que referencian directamente esta tabla: `vw_trazabilidad_usuarios`.

<details><summary>Definición real de la tabla</summary>

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

</details>

### tb_people

Motor: InnoDB. Collation: utf8mb4_0900_ai_ci.
Descripción: Pendiente de confirmar; sin comentario de tabla en MySQL.

| Columna | Tipo exacto | NULL | Predeterminado | Claves | Extra / generación |
|---|---|---|---|---|---|
| id | int | NO | null | PRIMARY | auto_increment  |
| user_id | int | NO | null | fk_people_user; uk_people_user |   |
| first_name | varchar(100) | NO | null |  |   |
| last_name | varchar(100) | NO | null |  |   |
| second_last_name | varchar(100) | YES | null |  |   |
| birth_date | date | YES | null |  |   |
| gender | varchar(30) | YES | null |  |   |
| phone | varchar(25) | YES | null |  |   |
| nationality | varchar(80) | YES | null |  |   |
| status | bit(1) | NO | "b'1'" |  |   |
| creation_date | datetime | NO | "CURRENT_TIMESTAMP" |  | DEFAULT_GENERATED  |
| last_update | datetime | YES | null |  | on update CURRENT_TIMESTAMP  |

**Índices**

| Nombre | Columnas en orden | Unicidad | Tipo |
|---|---|---|---|
| PRIMARY | id | UNIQUE | BTREE |
| uk_people_user | user_id | UNIQUE | BTREE |

**Claves foráneas declaradas**

| Restricción | Columnas hijas | Tabla padre | Columnas padre | DELETE | UPDATE |
|---|---|---|---|---|---|
| fk_people_user | user_id | tb_users | ID | RESTRICT | CASCADE |

**Triggers**
- `trg_people_after_delete`: AFTER DELETE; registra el evento en `tb_logs`.
- `trg_people_after_insert`: AFTER INSERT; registra el evento en `tb_logs`.
- `trg_people_after_update`: AFTER UPDATE; registra el evento en `tb_logs`.

Vistas que referencian directamente esta tabla: ninguna.

<details><summary>Definición real de la tabla</summary>

```sql
CREATE TABLE `tb_people` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `second_last_name` varchar(100) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `gender` varchar(30) DEFAULT NULL,
  `phone` varchar(25) DEFAULT NULL,
  `nationality` varchar(80) DEFAULT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_people_user` (`user_id`),
  CONSTRAINT `fk_people_user` FOREIGN KEY (`user_id`) REFERENCES `tb_users` (`ID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

## Direcciones

### tb_user_addresses

Motor: InnoDB. Collation: utf8mb4_0900_ai_ci.
Descripción: Pendiente de confirmar; sin comentario de tabla en MySQL.

| Columna | Tipo exacto | NULL | Predeterminado | Claves | Extra / generación |
|---|---|---|---|---|---|
| ID | bigint unsigned | NO | null | PRIMARY | auto_increment  |
| user_ID | int | NO | null | fk_addresses_users |   |
| address_label | varchar(100) | NO | null |  |   |
| recipient_name | varchar(150) | YES | null |  |   |
| recipient_phone | varchar(25) | YES | null |  |   |
| delivery_instructions | varchar(500) | YES | null |  |   |
| latitude | decimal(10,7) | YES | null |  |   |
| longitude | decimal(10,7) | YES | null |  |   |
| is_default | tinyint(1) | NO | "0" |  |   |
| status | bit(1) | NO | "b'1'" |  |   |
| creation_date | datetime | NO | "CURRENT_TIMESTAMP" |  | DEFAULT_GENERATED  |
| last_update | datetime | YES | null |  | on update CURRENT_TIMESTAMP  |

**Índices**

| Nombre | Columnas en orden | Unicidad | Tipo |
|---|---|---|---|
| idx_user_addresses | user_ID | No único | BTREE |
| PRIMARY | ID | UNIQUE | BTREE |

**Claves foráneas declaradas**

| Restricción | Columnas hijas | Tabla padre | Columnas padre | DELETE | UPDATE |
|---|---|---|---|---|---|
| fk_addresses_users | user_ID | tb_users | ID | NO ACTION | NO ACTION |

**CHECK**
- `chk_coordinates`: `(((`latitude` is null) and (`longitude` is null)) or ((`latitude` is not null) and (`longitude` is not null)))`. ENFORCED=YES.
- `chk_latitude`: `(`latitude` between -(90) and 90)`. ENFORCED=YES.
- `chk_longitude`: `(`longitude` between -(180) and 180)`. ENFORCED=YES.

**Triggers**
- `trg_user_addresses_after_delete`: AFTER DELETE; registra el evento en `tb_logs`.
- `trg_user_addresses_after_insert`: AFTER INSERT; registra el evento en `tb_logs`.
- `trg_user_addresses_after_update`: AFTER UPDATE; registra el evento en `tb_logs`.

Vistas que referencian directamente esta tabla: ninguna.

<details><summary>Definición real de la tabla</summary>

```sql
CREATE TABLE `tb_user_addresses` (
  `ID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_ID` int NOT NULL,
  `address_label` varchar(100) NOT NULL,
  `recipient_name` varchar(150) DEFAULT NULL,
  `recipient_phone` varchar(25) DEFAULT NULL,
  `delivery_instructions` varchar(500) DEFAULT NULL,
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `idx_user_addresses` (`user_ID`),
  CONSTRAINT `fk_addresses_users` FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`ID`),
  CONSTRAINT `chk_coordinates` CHECK ((((`latitude` is null) and (`longitude` is null)) or ((`latitude` is not null) and (`longitude` is not null)))),
  CONSTRAINT `chk_latitude` CHECK ((`latitude` between -(90) and 90)),
  CONSTRAINT `chk_longitude` CHECK ((`longitude` between -(180) and 180))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

### tbd_address_components

Motor: InnoDB. Collation: utf8mb4_0900_ai_ci.
Descripción: Pendiente de confirmar; sin comentario de tabla en MySQL.

| Columna | Tipo exacto | NULL | Predeterminado | Claves | Extra / generación |
|---|---|---|---|---|---|
| ID | bigint unsigned | NO | null | PRIMARY; uk_address_component | auto_increment  |
| address_ID | bigint unsigned | NO | null | fk_component_address; fk_component_parent; uk_address_component |   |
| value | varchar(255) | NO | null |  |   |
| component_type | varchar(50) | NO | null |  |   |
| status | bit(1) | NO | "b'1'" |  |   |
| address_sup_ID | bigint unsigned | YES | null | fk_component_parent |   |
| creation_date | datetime | NO | "CURRENT_TIMESTAMP" |  | DEFAULT_GENERATED  |
| last_update | datetime | YES | null |  | on update CURRENT_TIMESTAMP  |

**Índices**

| Nombre | Columnas en orden | Unicidad | Tipo |
|---|---|---|---|
| idx_address_parent | address_ID, address_sup_ID | No único | BTREE |
| PRIMARY | ID | UNIQUE | BTREE |
| uk_address_component | address_ID, ID | UNIQUE | BTREE |

**Claves foráneas declaradas**

| Restricción | Columnas hijas | Tabla padre | Columnas padre | DELETE | UPDATE |
|---|---|---|---|---|---|
| fk_component_address | address_ID | tb_user_addresses | ID | RESTRICT | NO ACTION |
| fk_component_parent | address_ID, address_sup_ID | tbd_address_components | address_ID, ID | RESTRICT | NO ACTION |

**Triggers**
- `trg_address_components_after_delete`: AFTER DELETE; registra el evento en `tb_logs`.
- `trg_address_components_after_insert`: AFTER INSERT; registra el evento en `tb_logs`.
- `trg_address_components_after_update`: AFTER UPDATE; registra el evento en `tb_logs`.

Vistas que referencian directamente esta tabla: ninguna.

<details><summary>Definición real de la tabla</summary>

```sql
CREATE TABLE `tbd_address_components` (
  `ID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `address_ID` bigint unsigned NOT NULL,
  `value` varchar(255) NOT NULL,
  `component_type` varchar(50) NOT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `address_sup_ID` bigint unsigned DEFAULT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uk_address_component` (`address_ID`,`ID`),
  KEY `idx_address_parent` (`address_ID`,`address_sup_ID`),
  CONSTRAINT `fk_component_address` FOREIGN KEY (`address_ID`) REFERENCES `tb_user_addresses` (`ID`) ON DELETE RESTRICT,
  CONSTRAINT `fk_component_parent` FOREIGN KEY (`address_ID`, `address_sup_ID`) REFERENCES `tbd_address_components` (`address_ID`, `ID`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

## Pagos

### tbc_payment_methods_types

Motor: InnoDB. Collation: utf8mb4_0900_ai_ci.
Descripción: Pendiente de confirmar; sin comentario de tabla en MySQL.

| Columna | Tipo exacto | NULL | Predeterminado | Claves | Extra / generación |
|---|---|---|---|---|---|
| ID | int unsigned | NO | null | PRIMARY | auto_increment  |
| code | varchar(30) | NO | null | code_UNIQUE |   |
| description | text | NO | null |  |   |
| status | bit(1) | NO | "b'1'" |  |   |
| creation_date | datetime | NO | "CURRENT_TIMESTAMP" |  | DEFAULT_GENERATED  |
| last_update | datetime | YES | null |  | on update CURRENT_TIMESTAMP  |

**Índices**

| Nombre | Columnas en orden | Unicidad | Tipo |
|---|---|---|---|
| code_UNIQUE | code | UNIQUE | BTREE |
| PRIMARY | ID | UNIQUE | BTREE |

**Claves foráneas declaradas**

| Restricción | Columnas hijas | Tabla padre | Columnas padre | DELETE | UPDATE |
|---|---|---|---|---|---|

**Triggers**
- `trg_payment_methods_types_after_delete`: AFTER DELETE; registra el evento en `tb_logs`.
- `trg_payment_methods_types_after_insert`: AFTER INSERT; registra el evento en `tb_logs`.
- `trg_payment_methods_types_after_update`: AFTER UPDATE; registra el evento en `tb_logs`.

Vistas que referencian directamente esta tabla: ninguna.

<details><summary>Definición real de la tabla</summary>

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

</details>

### tbd_user_payment_methods

Motor: InnoDB. Collation: utf8mb4_0900_ai_ci.
Descripción: Pendiente de confirmar; sin comentario de tabla en MySQL.

| Columna | Tipo exacto | NULL | Predeterminado | Claves | Extra / generación |
|---|---|---|---|---|---|
| ID | bigint unsigned | NO | null | PRIMARY | auto_increment  |
| user_ID | int | NO | null | fk_user_payment_methods_user |   |
| payment_method_type_ID | int unsigned | NO | null | fk_user_payment_methods_type |   |
| provider | varchar(60) | NO | null | uk_provider_method |   |
| provider_method_ref | varchar(255) | NO | null | uk_provider_method |   |
| label | varchar(100) | YES | null |  |   |
| last_four | char(4) | YES | null |  |   |
| is_default | tinyint(1) | NO | "0" |  |   |
| status | bit(1) | NO | "b'1'" |  |   |
| creation_date | datetime | NO | "CURRENT_TIMESTAMP" |  | DEFAULT_GENERATED  |
| last_update | datetime | YES | null |  | on update CURRENT_TIMESTAMP  |

**Índices**

| Nombre | Columnas en orden | Unicidad | Tipo |
|---|---|---|---|
| idx_payment_method_type_ID | payment_method_type_ID | No único | BTREE |
| idx_user_ID | user_ID | No único | BTREE |
| PRIMARY | ID | UNIQUE | BTREE |
| uk_provider_method | provider, provider_method_ref | UNIQUE | BTREE |

**Claves foráneas declaradas**

| Restricción | Columnas hijas | Tabla padre | Columnas padre | DELETE | UPDATE |
|---|---|---|---|---|---|
| fk_user_payment_methods_type | payment_method_type_ID | tbc_payment_methods_types | ID | NO ACTION | NO ACTION |
| fk_user_payment_methods_user | user_ID | tb_users | ID | NO ACTION | NO ACTION |

**Triggers**
- `trg_user_payment_methods_after_delete`: AFTER DELETE; registra el evento en `tb_logs`.
- `trg_user_payment_methods_after_insert`: AFTER INSERT; registra el evento en `tb_logs`.
- `trg_user_payment_methods_after_update`: AFTER UPDATE; registra el evento en `tb_logs`.

Vistas que referencian directamente esta tabla: ninguna.

<details><summary>Definición real de la tabla</summary>

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

</details>

## Catálogo

### tb_products

Motor: InnoDB. Collation: utf8mb4_0900_ai_ci.
Descripción: Pendiente de confirmar; sin comentario de tabla en MySQL.

| Columna | Tipo exacto | NULL | Predeterminado | Claves | Extra / generación |
|---|---|---|---|---|---|
| ID | int unsigned | NO | null | PRIMARY | auto_increment  |
| SKU | varchar(50) | NO | null | SKU |   |
| name | varchar(250) | NO | null |  |   |
| description | text | YES | null |  |   |
| current_price | decimal(10,2) | NO | "0.00" |  |   |
| current_stock | int unsigned | NO | "0" |  |   |
| status | bit(1) | YES | "b'1'" |  |   |
| creation_date | datetime | NO | "CURRENT_TIMESTAMP" |  | DEFAULT_GENERATED  |
| last_update | datetime | NO | "CURRENT_TIMESTAMP" |  | DEFAULT_GENERATED on update CURRENT_TIMESTAMP  |

**Índices**

| Nombre | Columnas en orden | Unicidad | Tipo |
|---|---|---|---|
| PRIMARY | ID | UNIQUE | BTREE |
| SKU | SKU | UNIQUE | BTREE |

**Claves foráneas declaradas**

| Restricción | Columnas hijas | Tabla padre | Columnas padre | DELETE | UPDATE |
|---|---|---|---|---|---|

**Triggers**
- `trg_products_after_delete`: AFTER DELETE; registra el evento en `tb_logs_productos`.
- `trg_products_after_insert`: AFTER INSERT; registra el evento en `tb_logs_productos`.
- `trg_products_after_update`: AFTER UPDATE; registra el evento en `tb_logs_productos`.

Vistas que referencian directamente esta tabla: `vw_total_products_by_category`, `vw_trazabilidad_productos`.

<details><summary>Definición real de la tabla</summary>

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

</details>

### tbc_categories

Motor: InnoDB. Collation: utf8mb4_0900_ai_ci.
Descripción: Pendiente de confirmar; sin comentario de tabla en MySQL.

| Columna | Tipo exacto | NULL | Predeterminado | Claves | Extra / generación |
|---|---|---|---|---|---|
| ID | int unsigned | NO | null | PRIMARY | auto_increment  |
| name | varchar(120) | NO | null | name |   |
| description | text | YES | null |  |   |
| sup_id_category | int unsigned | YES | null | fk_superior_category |   |
| status | bit(1) | NO | "b'1'" |  |   |
| creation_date | datetime | NO | "CURRENT_TIMESTAMP" |  | DEFAULT_GENERATED  |
| last_update | datetime | NO | "CURRENT_TIMESTAMP" |  | DEFAULT_GENERATED on update CURRENT_TIMESTAMP  |

**Índices**

| Nombre | Columnas en orden | Unicidad | Tipo |
|---|---|---|---|
| fk_superior_category | sup_id_category | No único | BTREE |
| name | name | UNIQUE | BTREE |
| PRIMARY | ID | UNIQUE | BTREE |

**Claves foráneas declaradas**

| Restricción | Columnas hijas | Tabla padre | Columnas padre | DELETE | UPDATE |
|---|---|---|---|---|---|
| fk_superior_category | sup_id_category | tbc_categories | ID | NO ACTION | NO ACTION |

**Triggers**
- `trg_categories_after_delete`: AFTER DELETE; registra el evento en `tb_logs`.
- `trg_categories_after_insert`: AFTER INSERT; registra el evento en `tb_logs`.
- `trg_categories_after_update`: AFTER UPDATE; registra el evento en `tb_logs`.

Vistas que referencian directamente esta tabla: `vw_total_products_by_category`.

<details><summary>Definición real de la tabla</summary>

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

</details>

### tbd_products_users_providers

Motor: InnoDB. Collation: utf8mb4_0900_ai_ci.
Descripción: Pendiente de confirmar; sin comentario de tabla en MySQL.

| Columna | Tipo exacto | NULL | Predeterminado | Claves | Extra / generación |
|---|---|---|---|---|---|
| user_ID | int | NO | null | fk_user1; PRIMARY |   |
| product_ID | int unsigned | NO | null | fk_products2; PRIMARY |   |
| type_ownership | enum('Owner','Reseller','Distributor') | YES | null |  |   |
| status | bit(1) | NO | "b'1'" |  |   |
| avalaible_date | datetime | NO | null |  |   |
| creation_date | datetime | NO | "CURRENT_TIMESTAMP" |  | DEFAULT_GENERATED  |
| last_update | datetime | NO | null |  | on update CURRENT_TIMESTAMP  |

**Índices**

| Nombre | Columnas en orden | Unicidad | Tipo |
|---|---|---|---|
| fk_products2 | product_ID | No único | BTREE |
| PRIMARY | user_ID, product_ID | UNIQUE | BTREE |

**Claves foráneas declaradas**

| Restricción | Columnas hijas | Tabla padre | Columnas padre | DELETE | UPDATE |
|---|---|---|---|---|---|
| fk_products2 | product_ID | tb_products | ID | RESTRICT | RESTRICT |
| fk_user1 | user_ID | tb_users | ID | RESTRICT | RESTRICT |

**Triggers**
- `trg_products_users_providers_after_delete`: AFTER DELETE; registra el evento en `tb_logs`.
- `trg_products_users_providers_after_insert`: AFTER INSERT; registra el evento en `tb_logs`.
- `trg_products_users_providers_after_update`: AFTER UPDATE; registra el evento en `tb_logs`.

Vistas que referencian directamente esta tabla: ninguna.

<details><summary>Definición real de la tabla</summary>

```sql
CREATE TABLE `tbd_products_users_providers` (
  `user_ID` int NOT NULL,
  `product_ID` int unsigned NOT NULL,
  `type_ownership` enum('Owner','Reseller','Distributor') DEFAULT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `avalaible_date` datetime NOT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_ID`,`product_ID`),
  KEY `fk_products2` (`product_ID`),
  CONSTRAINT `fk_products2` FOREIGN KEY (`product_ID`) REFERENCES `tb_products` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_user1` FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

### tbd_products_categories

Motor: InnoDB. Collation: utf8mb4_0900_ai_ci.
Descripción: Pendiente de confirmar; sin comentario de tabla en MySQL.

| Columna | Tipo exacto | NULL | Predeterminado | Claves | Extra / generación |
|---|---|---|---|---|---|
| category_ID | int unsigned | NO | null | fk_category; PRIMARY |   |
| product_ID | int unsigned | NO | null | fk_product; PRIMARY |   |
| status | bit(1) | NO | "b'1'" |  |   |
| creation_date | datetime | NO | "CURRENT_TIMESTAMP" |  | DEFAULT_GENERATED  |
| last_update | datetime | NO | "CURRENT_TIMESTAMP" |  | DEFAULT_GENERATED on update CURRENT_TIMESTAMP  |

**Índices**

| Nombre | Columnas en orden | Unicidad | Tipo |
|---|---|---|---|
| fk_product | product_ID | No único | BTREE |
| PRIMARY | category_ID, product_ID | UNIQUE | BTREE |

**Claves foráneas declaradas**

| Restricción | Columnas hijas | Tabla padre | Columnas padre | DELETE | UPDATE |
|---|---|---|---|---|---|
| fk_category | category_ID | tbc_categories | ID | NO ACTION | NO ACTION |
| fk_product | product_ID | tb_products | ID | NO ACTION | NO ACTION |

**Triggers**
- `trg_products_categories_after_delete`: AFTER DELETE; registra el evento en `tb_logs`.
- `trg_products_categories_after_insert`: AFTER INSERT; registra el evento en `tb_logs`.
- `trg_products_categories_after_update`: AFTER UPDATE; registra el evento en `tb_logs`.

Vistas que referencian directamente esta tabla: `vw_total_products_by_category`.

<details><summary>Definición real de la tabla</summary>

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

</details>

## Ventas

### tb_carts

Motor: InnoDB. Collation: utf8mb4_0900_ai_ci.
Descripción: Pendiente de confirmar; sin comentario de tabla en MySQL.

| Columna | Tipo exacto | NULL | Predeterminado | Claves | Extra / generación |
|---|---|---|---|---|---|
| ID | int unsigned | NO | null | PRIMARY | auto_increment  |
| user_ID | int | NO | null | fk_carts_user |   |
| creation_date | datetime | NO | "CURRENT_TIMESTAMP" |  | DEFAULT_GENERATED  |

**Índices**

| Nombre | Columnas en orden | Unicidad | Tipo |
|---|---|---|---|
| fk_carts_user | user_ID | No único | BTREE |
| PRIMARY | ID | UNIQUE | BTREE |

**Claves foráneas declaradas**

| Restricción | Columnas hijas | Tabla padre | Columnas padre | DELETE | UPDATE |
|---|---|---|---|---|---|
| fk_carts_user | user_ID | tb_users | ID | RESTRICT | RESTRICT |

**Triggers**
- `trg_carts_after_delete`: AFTER DELETE; registra el evento en `tb_logs`.
- `trg_carts_after_insert`: AFTER INSERT; registra el evento en `tb_logs`.
- `trg_carts_after_update`: AFTER UPDATE; registra el evento en `tb_logs`.

Vistas que referencian directamente esta tabla: ninguna.

<details><summary>Definición real de la tabla</summary>

```sql
CREATE TABLE `tb_carts` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `user_ID` int NOT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `fk_carts_user` (`user_ID`),
  CONSTRAINT `fk_carts_user` FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

### tbd_cart_items

Motor: InnoDB. Collation: utf8mb4_0900_ai_ci.
Descripción: Pendiente de confirmar; sin comentario de tabla en MySQL.

| Columna | Tipo exacto | NULL | Predeterminado | Claves | Extra / generación |
|---|---|---|---|---|---|
| cart_ID | int unsigned | NO | null | fk_cart_items_cart; PRIMARY |   |
| provider_ID | int | NO | null | fk_cart_items_provider_product; PRIMARY |   |
| product_ID | int unsigned | NO | null | fk_cart_items_provider_product; PRIMARY |   |
| quantity | int unsigned | NO | "1" |  |   |
| creation_date | datetime | NO | "CURRENT_TIMESTAMP" |  | DEFAULT_GENERATED  |

**Índices**

| Nombre | Columnas en orden | Unicidad | Tipo |
|---|---|---|---|
| idx_cart_items_provider_product | provider_ID, product_ID | No único | BTREE |
| PRIMARY | cart_ID, provider_ID, product_ID | UNIQUE | BTREE |

**Claves foráneas declaradas**

| Restricción | Columnas hijas | Tabla padre | Columnas padre | DELETE | UPDATE |
|---|---|---|---|---|---|
| fk_cart_items_cart | cart_ID | tb_carts | ID | CASCADE | NO ACTION |
| fk_cart_items_provider_product | provider_ID, product_ID | tbd_products_users_providers | user_ID, product_ID | RESTRICT | RESTRICT |

**CHECK**
- `chk_cart_quantity`: `(`quantity` > 0)`. ENFORCED=YES.

**Triggers**
- `trg_cart_items_after_delete`: AFTER DELETE; registra el evento en `tb_logs`.
- `trg_cart_items_after_insert`: AFTER INSERT; registra el evento en `tb_logs`.
- `trg_cart_items_after_update`: AFTER UPDATE; registra el evento en `tb_logs`.

Vistas que referencian directamente esta tabla: ninguna.

<details><summary>Definición real de la tabla</summary>

```sql
CREATE TABLE `tbd_cart_items` (
  `cart_ID` int unsigned NOT NULL,
  `provider_ID` int NOT NULL,
  `product_ID` int unsigned NOT NULL,
  `quantity` int unsigned NOT NULL DEFAULT '1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`cart_ID`,`provider_ID`,`product_ID`),
  KEY `idx_cart_items_provider_product` (`provider_ID`,`product_ID`),
  CONSTRAINT `fk_cart_items_cart` FOREIGN KEY (`cart_ID`) REFERENCES `tb_carts` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `fk_cart_items_provider_product` FOREIGN KEY (`provider_ID`, `product_ID`) REFERENCES `tbd_products_users_providers` (`user_ID`, `product_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_cart_quantity` CHECK ((`quantity` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

### tb_buyer_orders

Motor: InnoDB. Collation: utf8mb4_0900_ai_ci.
Descripción: Pendiente de confirmar; sin comentario de tabla en MySQL.

| Columna | Tipo exacto | NULL | Predeterminado | Claves | Extra / generación |
|---|---|---|---|---|---|
| ID | int unsigned | NO | null | PRIMARY | auto_increment  |
| seller_ID | int | NO | null | tb_buyer_orders_ibfk_1 |   |
| subtotal | decimal(12,2) | NO | "0.00" |  |   |
| shipping_cost | decimal(12,2) | NO | "0.00" |  |   |
| fulfillment_status | enum('Pending','Accepted','Preparing','Sent','Delivered','Canceled','Returned') | NO | "Pending" |  |   |
| status | bit(1) | NO | "b'1'" |  |   |
| creation_date | datetime | NO | "CURRENT_TIMESTAMP" |  | DEFAULT_GENERATED  |
| last_update | datetime | YES | null |  | on update CURRENT_TIMESTAMP  |

**Índices**

| Nombre | Columnas en orden | Unicidad | Tipo |
|---|---|---|---|
| PRIMARY | ID | UNIQUE | BTREE |
| seller_ID | seller_ID | No único | BTREE |

**Claves foráneas declaradas**

| Restricción | Columnas hijas | Tabla padre | Columnas padre | DELETE | UPDATE |
|---|---|---|---|---|---|
| tb_buyer_orders_ibfk_1 | seller_ID | tb_users | ID | NO ACTION | NO ACTION |

**CHECK**
- `tb_buyer_orders_chk_1`: `(`subtotal` >= 0)`. ENFORCED=YES.
- `tb_buyer_orders_chk_2`: `(`shipping_cost` >= 0)`. ENFORCED=YES.

**Triggers**
- `trg_after_delete_buyer_orders`: AFTER DELETE; registra el evento en `tb_logs`.
- `trg_after_insert_buyer_orders`: AFTER INSERT; registra el evento en `tb_logs`.
- `trg_after_update_buyer_orders`: AFTER UPDATE; registra el evento en `tb_logs`.

Vistas que referencian directamente esta tabla: ninguna.

<details><summary>Definición real de la tabla</summary>

```sql
CREATE TABLE `tb_buyer_orders` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `seller_ID` int NOT NULL,
  `subtotal` decimal(12,2) NOT NULL DEFAULT '0.00',
  `shipping_cost` decimal(12,2) NOT NULL DEFAULT '0.00',
  `fulfillment_status` enum('Pending','Accepted','Preparing','Sent','Delivered','Canceled','Returned') NOT NULL DEFAULT 'Pending',
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `seller_ID` (`seller_ID`),
  CONSTRAINT `tb_buyer_orders_ibfk_1` FOREIGN KEY (`seller_ID`) REFERENCES `tb_users` (`ID`),
  CONSTRAINT `tb_buyer_orders_chk_1` CHECK ((`subtotal` >= 0)),
  CONSTRAINT `tb_buyer_orders_chk_2` CHECK ((`shipping_cost` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

### tbd_order_items

Motor: InnoDB. Collation: utf8mb4_0900_ai_ci.
Descripción: Pendiente de confirmar; sin comentario de tabla en MySQL.

| Columna | Tipo exacto | NULL | Predeterminado | Claves | Extra / generación |
|---|---|---|---|---|---|
| ID | int unsigned | NO | null | PRIMARY | auto_increment  |
| seller_order_ID | int unsigned | NO | null | tbd_order_items_ibfk_1 |   |
| product_ID | int unsigned | NO | null | fk_order_provider_product |   |
| provider_ID | int | NO | null | fk_order_provider_product |   |
| product_name | varchar(255) | NO | null |  |   |
| quantity | int unsigned | NO | null |  |   |
| unit_price | decimal(12,2) | NO | null |  |   |
| subtotal | decimal(12,2) | YES | null |  | STORED GENERATED (`quantity` * `unit_price`) |
| creation_date | datetime | NO | "CURRENT_TIMESTAMP" |  | DEFAULT_GENERATED  |

**Índices**

| Nombre | Columnas en orden | Unicidad | Tipo |
|---|---|---|---|
| idx_order_provider_product | provider_ID, product_ID | No único | BTREE |
| PRIMARY | ID | UNIQUE | BTREE |
| product_ID | product_ID | No único | BTREE |
| provider_ID | provider_ID | No único | BTREE |
| seller_order_ID | seller_order_ID | No único | BTREE |

**Claves foráneas declaradas**

| Restricción | Columnas hijas | Tabla padre | Columnas padre | DELETE | UPDATE |
|---|---|---|---|---|---|
| fk_order_provider_product | provider_ID, product_ID | tbd_products_users_providers | user_ID, product_ID | NO ACTION | NO ACTION |
| tbd_order_items_ibfk_1 | seller_order_ID | tb_buyer_orders | ID | NO ACTION | NO ACTION |

**CHECK**
- `tbd_order_items_chk_1`: `(`quantity` > 0)`. ENFORCED=YES.
- `tbd_order_items_chk_2`: `(`unit_price` >= 0)`. ENFORCED=YES.

**Triggers**
- `trg_order_items_after_delete`: AFTER DELETE; registra el evento en `tb_logs`.
- `trg_order_items_after_insert`: AFTER INSERT; registra el evento en `tb_logs`.
- `trg_order_items_after_update`: AFTER UPDATE; registra el evento en `tb_logs`.

Vistas que referencian directamente esta tabla: ninguna.

<details><summary>Definición real de la tabla</summary>

```sql
CREATE TABLE `tbd_order_items` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `seller_order_ID` int unsigned NOT NULL,
  `product_ID` int unsigned NOT NULL,
  `provider_ID` int NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `quantity` int unsigned NOT NULL,
  `unit_price` decimal(12,2) NOT NULL,
  `subtotal` decimal(12,2) GENERATED ALWAYS AS ((`quantity` * `unit_price`)) STORED,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `seller_order_ID` (`seller_order_ID`),
  KEY `product_ID` (`product_ID`),
  KEY `provider_ID` (`provider_ID`),
  KEY `idx_order_provider_product` (`provider_ID`,`product_ID`),
  CONSTRAINT `fk_order_provider_product` FOREIGN KEY (`provider_ID`, `product_ID`) REFERENCES `tbd_products_users_providers` (`user_ID`, `product_ID`),
  CONSTRAINT `tbd_order_items_ibfk_1` FOREIGN KEY (`seller_order_ID`) REFERENCES `tb_buyer_orders` (`ID`),
  CONSTRAINT `tbd_order_items_chk_1` CHECK ((`quantity` > 0)),
  CONSTRAINT `tbd_order_items_chk_2` CHECK ((`unit_price` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

### tbd_users_wishlist_products

Motor: InnoDB. Collation: utf8mb4_0900_ai_ci.
Descripción: Pendiente de confirmar; sin comentario de tabla en MySQL.

| Columna | Tipo exacto | NULL | Predeterminado | Claves | Extra / generación |
|---|---|---|---|---|---|
| user_ID | int | NO | null | fk_user2; PRIMARY |   |
| product_ID | int unsigned | NO | null | fk_products3; PRIMARY |   |
| status | bit(1) | NO | "b'1'" |  |   |
| creation_date | datetime | NO | "CURRENT_TIMESTAMP" |  | DEFAULT_GENERATED  |
| last_update | datetime | NO | null |  | on update CURRENT_TIMESTAMP  |

**Índices**

| Nombre | Columnas en orden | Unicidad | Tipo |
|---|---|---|---|
| fk_products3 | product_ID | No único | BTREE |
| PRIMARY | user_ID, product_ID | UNIQUE | BTREE |

**Claves foráneas declaradas**

| Restricción | Columnas hijas | Tabla padre | Columnas padre | DELETE | UPDATE |
|---|---|---|---|---|---|
| fk_products3 | product_ID | tb_products | ID | NO ACTION | NO ACTION |
| fk_user2 | user_ID | tb_users | ID | NO ACTION | NO ACTION |

**Triggers**
- `trg_users_wishlist_products_after_delete`: AFTER DELETE; registra el evento en `tb_logs`.
- `trg_users_wishlist_products_after_insert`: AFTER INSERT; registra el evento en `tb_logs`.
- `trg_users_wishlist_products_after_update`: AFTER UPDATE; registra el evento en `tb_logs`.

Vistas que referencian directamente esta tabla: ninguna.

<details><summary>Definición real de la tabla</summary>

```sql
CREATE TABLE `tbd_users_wishlist_products` (
  `user_ID` int NOT NULL,
  `product_ID` int unsigned NOT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_ID`,`product_ID`),
  KEY `fk_products3` (`product_ID`),
  CONSTRAINT `fk_products3` FOREIGN KEY (`product_ID`) REFERENCES `tb_products` (`ID`),
  CONSTRAINT `fk_user2` FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

## Auditoría

### tb_logs

Motor: InnoDB. Collation: utf8mb4_0900_ai_ci.
Descripción: Pendiente de confirmar; sin comentario de tabla en MySQL.

| Columna | Tipo exacto | NULL | Predeterminado | Claves | Extra / generación |
|---|---|---|---|---|---|
| ID | int | NO | null | PRIMARY | auto_increment  |
| table_name | varchar(100) | NO | null |  |   |
| table_operation | enum('Create','Read','Update','Delete') | NO | null |  |   |
| db_user | varchar(80) | NO | null |  |   |
| operation_description | text | NO | null |  |   |
| operation_date | datetime | NO | "CURRENT_TIMESTAMP" |  | DEFAULT_GENERATED  |
| operation_status | bit(1) | YES | "b'1'" |  |   |
| record_id | int unsigned | YES | null |  |   |
| record_key | varchar(100) | YES | null |  |   |
| actor_roles | varchar(255) | YES | null |  |   |

**Índices**

| Nombre | Columnas en orden | Unicidad | Tipo |
|---|---|---|---|
| ix_trace | table_name, record_id, table_operation | No único | BTREE |
| PRIMARY | ID | UNIQUE | BTREE |

**Claves foráneas declaradas**

| Restricción | Columnas hijas | Tabla padre | Columnas padre | DELETE | UPDATE |
|---|---|---|---|---|---|

**Triggers**
- Ninguno: la tabla recibe auditoría; no se añaden triggers recursivos.

Vistas que referencian directamente esta tabla: `vw_bitacora_usuarios`, `vw_trazabilidad_categorias`, `vw_trazabilidad_categorizacion_productos`, `vw_trazabilidad_usuarios`.

<details><summary>Definición real de la tabla</summary>

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

</details>

### tb_logs_productos

Motor: InnoDB. Collation: utf8mb4_0900_ai_ci.
Descripción: Pendiente de confirmar; sin comentario de tabla en MySQL.

| Columna | Tipo exacto | NULL | Predeterminado | Claves | Extra / generación |
|---|---|---|---|---|---|
| ID | int | NO | null | PRIMARY | auto_increment  |
| table_name | varchar(100) | NO | null |  |   |
| table_operation | enum('Create','Read','Update','Delete') | NO | null |  |   |
| db_user | varchar(80) | NO | null |  |   |
| operation_description | text | NO | null |  |   |
| operation_date | datetime | NO | "CURRENT_TIMESTAMP" |  | DEFAULT_GENERATED  |
| operation_status | bit(1) | YES | "b'1'" |  |   |
| record_id | int unsigned | YES | null |  |   |
| record_key | varchar(100) | YES | null |  |   |
| actor_roles | varchar(255) | YES | null |  |   |

**Índices**

| Nombre | Columnas en orden | Unicidad | Tipo |
|---|---|---|---|
| ix_trace | table_name, record_id, table_operation | No único | BTREE |
| PRIMARY | ID | UNIQUE | BTREE |

**Claves foráneas declaradas**

| Restricción | Columnas hijas | Tabla padre | Columnas padre | DELETE | UPDATE |
|---|---|---|---|---|---|

**Triggers**
- Ninguno: la tabla recibe auditoría; no se añaden triggers recursivos.

Vistas que referencian directamente esta tabla: `vw_trazabilidad_productos`.

<details><summary>Definición real de la tabla</summary>

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

</details>

## Vistas: definiciones reales

Las dependencias se obtienen de referencias a nombres de tablas en VIEW_DEFINITION, no de relaciones inventadas.

### vw_bitacora_usuarios

SECURITY_TYPE=DEFINER; IS_UPDATABLE=YES; CHECK_OPTION=NONE.

```sql
select `bd_test`.`tb_logs`.`ID` AS `log_id`,(case `bd_test`.`tb_logs`.`table_operation` when 'Create' then 'Insercion' when 'Update' then 'Modificacion' when 'Delete' then 'Eliminacion' else `bd_test`.`tb_logs`.`table_operation` end) AS `operacion`,`bd_test`.`tb_logs`.`record_id` AS `usuario_id`,(case when (`bd_test`.`tb_logs`.`table_operation` = 'Update') then json_unquote(json_extract(`bd_test`.`tb_logs`.`operation_description`,'$.despues.nick')) else json_unquote(json_extract(`bd_test`.`tb_logs`.`operation_description`,'$.nick')) end) AS `usuario`,`bd_test`.`tb_logs`.`db_user` AS `realizado_por`,coalesce(nullif(`bd_test`.`tb_logs`.`actor_roles`,''),'SIN ROL') AS `rol`,`bd_test`.`tb_logs`.`operation_date` AS `fecha`,`bd_test`.`tb_logs`.`operation_description` AS `detalle`,(case when (`bd_test`.`tb_logs`.`table_operation` = 'Update') then json_unquote(json_extract(`bd_test`.`tb_logs`.`operation_description`,'$.despues.email')) else json_unquote(json_extract(`bd_test`.`tb_logs`.`operation_description`,'$.email')) end) AS `email` from `bd_test`.`tb_logs` where (`bd_test`.`tb_logs`.`table_name` = 'tb_users');
```

### vw_total_products_by_category

SECURITY_TYPE=DEFINER; IS_UPDATABLE=NO; CHECK_OPTION=NONE.

```sql
select `c`.`ID` AS `category_id`,`c`.`name` AS `category_name`,count(`p`.`ID`) AS `total_products` from ((`bd_test`.`tbc_categories` `c` left join `bd_test`.`tbd_products_categories` `pc` on(((`pc`.`category_ID` = `c`.`ID`) and (`pc`.`status` = 0x01)))) left join `bd_test`.`tb_products` `p` on(((`p`.`ID` = `pc`.`product_ID`) and (`p`.`status` = 0x01)))) group by `c`.`ID`,`c`.`name` union all select NULL AS `NULL`,'Sin categoria' AS `Sin categoria`,count(0) AS `COUNT(*)` from `bd_test`.`tb_products` `p` where ((`p`.`status` = 0x01) and exists(select 1 from `bd_test`.`tbd_products_categories` `pc` where ((`pc`.`product_ID` = `p`.`ID`) and (`pc`.`status` = 0x01))) is false);
```

### vw_trazabilidad_categorias

SECURITY_TYPE=DEFINER; IS_UPDATABLE=YES; CHECK_OPTION=NONE.

```sql
select `bd_test`.`tb_logs`.`ID` AS `log_id`,`bd_test`.`tb_logs`.`record_id` AS `record_id`,`bd_test`.`tb_logs`.`record_key` AS `record_key`,`bd_test`.`tb_logs`.`table_operation` AS `operation`,substring_index(`bd_test`.`tb_logs`.`db_user`,'@',1) AS `db_user`,substring_index(`bd_test`.`tb_logs`.`db_user`,'@',1) AS `username`,`bd_test`.`tb_logs`.`actor_roles` AS `roles`,`bd_test`.`tb_logs`.`operation_description` AS `operation_description`,`bd_test`.`tb_logs`.`operation_date` AS `operation_date`,`bd_test`.`tb_logs`.`operation_status` AS `operation_status` from `bd_test`.`tb_logs` where (`bd_test`.`tb_logs`.`table_name` = 'tbc_categories');
```

### vw_trazabilidad_categorizacion_productos

SECURITY_TYPE=DEFINER; IS_UPDATABLE=YES; CHECK_OPTION=NONE.

```sql
select `bd_test`.`tb_logs`.`ID` AS `log_id`,`bd_test`.`tb_logs`.`record_id` AS `record_id`,`bd_test`.`tb_logs`.`record_key` AS `record_key`,`bd_test`.`tb_logs`.`table_operation` AS `operation`,substring_index(`bd_test`.`tb_logs`.`db_user`,'@',1) AS `db_user`,substring_index(`bd_test`.`tb_logs`.`db_user`,'@',1) AS `username`,`bd_test`.`tb_logs`.`actor_roles` AS `roles`,`bd_test`.`tb_logs`.`operation_description` AS `operation_description`,`bd_test`.`tb_logs`.`operation_date` AS `operation_date`,`bd_test`.`tb_logs`.`operation_status` AS `operation_status` from `bd_test`.`tb_logs` where (`bd_test`.`tb_logs`.`table_name` = 'tbd_products_categories');
```

### vw_trazabilidad_productos

SECURITY_TYPE=DEFINER; IS_UPDATABLE=YES; CHECK_OPTION=NONE.

```sql
select `p`.`ID` AS `id`,`p`.`SKU` AS `SKU`,`p`.`name` AS `name`,`p`.`description` AS `description`,`b`.`db_user` AS `inserted_by`,`b`.`actor_roles` AS `roles`,`b`.`operation_description` AS `operation_description`,`b`.`operation_date` AS `operation_date` from (`bd_test`.`tb_products` `p` join `bd_test`.`tb_logs_productos` `b` on(((`b`.`record_id` = `p`.`ID`) and (`b`.`table_name` = 'tb_products') and (`b`.`table_operation` = 'Create'))));
```

### vw_trazabilidad_usuarios

SECURITY_TYPE=DEFINER; IS_UPDATABLE=NO; CHECK_OPTION=NONE.

```sql
select `b`.`record_id` AS `id`,coalesce(`u`.`nick`,json_unquote(json_extract(`b`.`operation_description`,'$.nick'))) AS `nick`,coalesce(`u`.`email`,json_unquote(json_extract(`b`.`operation_description`,'$.email'))) AS `email`,`b`.`db_user` AS `inserted_by`,`b`.`actor_roles` AS `roles`,`b`.`operation_description` AS `operation_description`,`b`.`operation_date` AS `operation_date`,(case when (`u`.`ID` is null) then 'Eliminado' else 'Existente' end) AS `estado_actual` from (`bd_test`.`tb_logs` `b` left join `bd_test`.`tb_users` `u` on((`u`.`ID` = `b`.`record_id`))) where ((`b`.`table_name` = 'tb_users') and (`b`.`table_operation` = 'Create'));
```

## Auditoría y límites

Se conservaron los doce triggers originales y las seis vistas: sus definiciones coinciden con el estado inicial de esta tarea.
USER() identifica la cuenta de conexión. actor_roles refleja roles asignados para host %, no necesariamente roles activos ni la identidad física de una persona.
Los nuevos triggers excluyen nombres de personas, teléfonos, valores de dirección y referencias privadas de pago. Si cambia un campo omitido, registran el evento pero no ese valor.
record_key conserva las claves completas; algunos IDs BIGINT no caben en record_id INT UNSIGNED y se registran allí como NULL. Las bitácoras no tienen FK a las entidades: conservan el historial de eliminaciones.

## Rutinas y evento

- `fn_total_products_by_category`: FUNCTION. Parámetros: RETURN  bigint; IN p_category_id int unsigned.

- `sp_restore_product`: PROCEDURE. Parámetros: IN p_id int unsigned.

- `sp_soft_delete_product`: PROCEDURE. Parámetros: IN p_id int unsigned.

- `sp_soft_delete_user`: PROCEDURE. Parámetros: IN p_id int unsigned.
- `ev_actualizar_estado_relaciones`: DISABLED; RECURRING 1 DAY. No se activó.

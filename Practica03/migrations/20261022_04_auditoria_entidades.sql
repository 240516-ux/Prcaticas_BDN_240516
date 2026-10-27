-- 33 triggers nuevos; conserva los 12 existentes.
-- Sin contraseñas, teléfonos, direcciones, nombres de personas ni referencias de pago en JSON.
-- Los cambios a campos omitidos registran evento e identidad, pero no sus valores.
-- Roles asignados (TO_HOST=%), igual que la auditoría previa; no son roles activos.
-- Para IDs fuera de uint32, record_id=NULL y record_key conserva la identidad completa.
USE bd_test;
DELIMITER $$

CREATE TRIGGER `trg_carts_after_insert` AFTER INSERT ON `tb_carts` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tb_carts', 'Create', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN NEW.`ID` BETWEEN 0 AND 4294967295 THEN NEW.`ID` ELSE NULL END,
     CAST(NEW.`ID` AS CHAR),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('ID', NEW.`ID`, 'user_ID', NEW.`user_ID`, 'creation_date', NEW.`creation_date`));
END$$

CREATE TRIGGER `trg_carts_after_update` AFTER UPDATE ON `tb_carts` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tb_carts', 'Update', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN NEW.`ID` BETWEEN 0 AND 4294967295 THEN NEW.`ID` ELSE NULL END,
     CAST(NEW.`ID` AS CHAR),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('antes', JSON_OBJECT('ID', OLD.`ID`, 'user_ID', OLD.`user_ID`, 'creation_date', OLD.`creation_date`), 'despues', JSON_OBJECT('ID', NEW.`ID`, 'user_ID', NEW.`user_ID`, 'creation_date', NEW.`creation_date`)));
END$$

CREATE TRIGGER `trg_carts_after_delete` AFTER DELETE ON `tb_carts` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tb_carts', 'Delete', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN OLD.`ID` BETWEEN 0 AND 4294967295 THEN OLD.`ID` ELSE NULL END,
     CAST(OLD.`ID` AS CHAR),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('ID', OLD.`ID`, 'user_ID', OLD.`user_ID`, 'creation_date', OLD.`creation_date`));
END$$

CREATE TRIGGER `trg_cart_items_after_insert` AFTER INSERT ON `tbd_cart_items` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tbd_cart_items', 'Create', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN NEW.`cart_ID` BETWEEN 0 AND 4294967295 THEN NEW.`cart_ID` ELSE NULL END,
     CONCAT(NEW.`cart_ID`, ':', NEW.`provider_ID`, ':', NEW.`product_ID`),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('cart_ID', NEW.`cart_ID`, 'provider_ID', NEW.`provider_ID`, 'product_ID', NEW.`product_ID`, 'quantity', NEW.`quantity`));
END$$

CREATE TRIGGER `trg_cart_items_after_update` AFTER UPDATE ON `tbd_cart_items` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tbd_cart_items', 'Update', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN NEW.`cart_ID` BETWEEN 0 AND 4294967295 THEN NEW.`cart_ID` ELSE NULL END,
     CONCAT(NEW.`cart_ID`, ':', NEW.`provider_ID`, ':', NEW.`product_ID`),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('antes', JSON_OBJECT('cart_ID', OLD.`cart_ID`, 'provider_ID', OLD.`provider_ID`, 'product_ID', OLD.`product_ID`, 'quantity', OLD.`quantity`), 'despues', JSON_OBJECT('cart_ID', NEW.`cart_ID`, 'provider_ID', NEW.`provider_ID`, 'product_ID', NEW.`product_ID`, 'quantity', NEW.`quantity`)));
END$$

CREATE TRIGGER `trg_cart_items_after_delete` AFTER DELETE ON `tbd_cart_items` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tbd_cart_items', 'Delete', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN OLD.`cart_ID` BETWEEN 0 AND 4294967295 THEN OLD.`cart_ID` ELSE NULL END,
     CONCAT(OLD.`cart_ID`, ':', OLD.`provider_ID`, ':', OLD.`product_ID`),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('cart_ID', OLD.`cart_ID`, 'provider_ID', OLD.`provider_ID`, 'product_ID', OLD.`product_ID`, 'quantity', OLD.`quantity`));
END$$

CREATE TRIGGER `trg_payment_methods_types_after_insert` AFTER INSERT ON `tbc_payment_methods_types` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tbc_payment_methods_types', 'Create', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN NEW.`ID` BETWEEN 0 AND 4294967295 THEN NEW.`ID` ELSE NULL END,
     CAST(NEW.`ID` AS CHAR),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('ID', NEW.`ID`, 'code', NEW.`code`, 'status', NEW.`status`+0));
END$$

CREATE TRIGGER `trg_payment_methods_types_after_update` AFTER UPDATE ON `tbc_payment_methods_types` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tbc_payment_methods_types', 'Update', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN NEW.`ID` BETWEEN 0 AND 4294967295 THEN NEW.`ID` ELSE NULL END,
     CAST(NEW.`ID` AS CHAR),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('antes', JSON_OBJECT('ID', OLD.`ID`, 'code', OLD.`code`, 'status', OLD.`status`+0), 'despues', JSON_OBJECT('ID', NEW.`ID`, 'code', NEW.`code`, 'status', NEW.`status`+0)));
END$$

CREATE TRIGGER `trg_payment_methods_types_after_delete` AFTER DELETE ON `tbc_payment_methods_types` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tbc_payment_methods_types', 'Delete', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN OLD.`ID` BETWEEN 0 AND 4294967295 THEN OLD.`ID` ELSE NULL END,
     CAST(OLD.`ID` AS CHAR),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('ID', OLD.`ID`, 'code', OLD.`code`, 'status', OLD.`status`+0));
END$$

CREATE TRIGGER `trg_user_payment_methods_after_insert` AFTER INSERT ON `tbd_user_payment_methods` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tbd_user_payment_methods', 'Create', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN NEW.`ID` BETWEEN 0 AND 4294967295 THEN NEW.`ID` ELSE NULL END,
     CAST(NEW.`ID` AS CHAR),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('ID', NEW.`ID`, 'user_ID', NEW.`user_ID`, 'payment_method_type_ID', NEW.`payment_method_type_ID`, 'status', NEW.`status`+0, 'is_default', NEW.`is_default`));
END$$

CREATE TRIGGER `trg_user_payment_methods_after_update` AFTER UPDATE ON `tbd_user_payment_methods` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tbd_user_payment_methods', 'Update', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN NEW.`ID` BETWEEN 0 AND 4294967295 THEN NEW.`ID` ELSE NULL END,
     CAST(NEW.`ID` AS CHAR),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('antes', JSON_OBJECT('ID', OLD.`ID`, 'user_ID', OLD.`user_ID`, 'payment_method_type_ID', OLD.`payment_method_type_ID`, 'status', OLD.`status`+0, 'is_default', OLD.`is_default`), 'despues', JSON_OBJECT('ID', NEW.`ID`, 'user_ID', NEW.`user_ID`, 'payment_method_type_ID', NEW.`payment_method_type_ID`, 'status', NEW.`status`+0, 'is_default', NEW.`is_default`)));
END$$

CREATE TRIGGER `trg_user_payment_methods_after_delete` AFTER DELETE ON `tbd_user_payment_methods` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tbd_user_payment_methods', 'Delete', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN OLD.`ID` BETWEEN 0 AND 4294967295 THEN OLD.`ID` ELSE NULL END,
     CAST(OLD.`ID` AS CHAR),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('ID', OLD.`ID`, 'user_ID', OLD.`user_ID`, 'payment_method_type_ID', OLD.`payment_method_type_ID`, 'status', OLD.`status`+0, 'is_default', OLD.`is_default`));
END$$

CREATE TRIGGER `trg_products_users_providers_after_insert` AFTER INSERT ON `tbd_products_users_providers` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tbd_products_users_providers', 'Create', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN NEW.`user_ID` BETWEEN 0 AND 4294967295 THEN NEW.`user_ID` ELSE NULL END,
     CONCAT(NEW.`user_ID`, ':', NEW.`product_ID`),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('user_ID', NEW.`user_ID`, 'product_ID', NEW.`product_ID`, 'type_ownership', NEW.`type_ownership`, 'status', NEW.`status`+0));
END$$

CREATE TRIGGER `trg_products_users_providers_after_update` AFTER UPDATE ON `tbd_products_users_providers` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tbd_products_users_providers', 'Update', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN NEW.`user_ID` BETWEEN 0 AND 4294967295 THEN NEW.`user_ID` ELSE NULL END,
     CONCAT(NEW.`user_ID`, ':', NEW.`product_ID`),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('antes', JSON_OBJECT('user_ID', OLD.`user_ID`, 'product_ID', OLD.`product_ID`, 'type_ownership', OLD.`type_ownership`, 'status', OLD.`status`+0), 'despues', JSON_OBJECT('user_ID', NEW.`user_ID`, 'product_ID', NEW.`product_ID`, 'type_ownership', NEW.`type_ownership`, 'status', NEW.`status`+0)));
END$$

CREATE TRIGGER `trg_products_users_providers_after_delete` AFTER DELETE ON `tbd_products_users_providers` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tbd_products_users_providers', 'Delete', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN OLD.`user_ID` BETWEEN 0 AND 4294967295 THEN OLD.`user_ID` ELSE NULL END,
     CONCAT(OLD.`user_ID`, ':', OLD.`product_ID`),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('user_ID', OLD.`user_ID`, 'product_ID', OLD.`product_ID`, 'type_ownership', OLD.`type_ownership`, 'status', OLD.`status`+0));
END$$

CREATE TRIGGER `trg_after_insert_buyer_orders` AFTER INSERT ON `tb_buyer_orders` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tb_buyer_orders', 'Create', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN NEW.`ID` BETWEEN 0 AND 4294967295 THEN NEW.`ID` ELSE NULL END,
     CAST(NEW.`ID` AS CHAR),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('ID', NEW.`ID`, 'seller_ID', NEW.`seller_ID`, 'subtotal', NEW.`subtotal`, 'shipping_cost', NEW.`shipping_cost`, 'fulfillment_status', NEW.`fulfillment_status`, 'status', NEW.`status`+0));
END$$

CREATE TRIGGER `trg_after_update_buyer_orders` AFTER UPDATE ON `tb_buyer_orders` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tb_buyer_orders', 'Update', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN NEW.`ID` BETWEEN 0 AND 4294967295 THEN NEW.`ID` ELSE NULL END,
     CAST(NEW.`ID` AS CHAR),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('antes', JSON_OBJECT('ID', OLD.`ID`, 'seller_ID', OLD.`seller_ID`, 'subtotal', OLD.`subtotal`, 'shipping_cost', OLD.`shipping_cost`, 'fulfillment_status', OLD.`fulfillment_status`, 'status', OLD.`status`+0), 'despues', JSON_OBJECT('ID', NEW.`ID`, 'seller_ID', NEW.`seller_ID`, 'subtotal', NEW.`subtotal`, 'shipping_cost', NEW.`shipping_cost`, 'fulfillment_status', NEW.`fulfillment_status`, 'status', NEW.`status`+0)));
END$$

CREATE TRIGGER `trg_after_delete_buyer_orders` AFTER DELETE ON `tb_buyer_orders` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tb_buyer_orders', 'Delete', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN OLD.`ID` BETWEEN 0 AND 4294967295 THEN OLD.`ID` ELSE NULL END,
     CAST(OLD.`ID` AS CHAR),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('ID', OLD.`ID`, 'seller_ID', OLD.`seller_ID`, 'subtotal', OLD.`subtotal`, 'shipping_cost', OLD.`shipping_cost`, 'fulfillment_status', OLD.`fulfillment_status`, 'status', OLD.`status`+0));
END$$

CREATE TRIGGER `trg_user_addresses_after_insert` AFTER INSERT ON `tb_user_addresses` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tb_user_addresses', 'Create', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN NEW.`ID` BETWEEN 0 AND 4294967295 THEN NEW.`ID` ELSE NULL END,
     CAST(NEW.`ID` AS CHAR),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('ID', NEW.`ID`, 'user_ID', NEW.`user_ID`, 'status', NEW.`status`+0, 'is_default', NEW.`is_default`));
END$$

CREATE TRIGGER `trg_user_addresses_after_update` AFTER UPDATE ON `tb_user_addresses` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tb_user_addresses', 'Update', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN NEW.`ID` BETWEEN 0 AND 4294967295 THEN NEW.`ID` ELSE NULL END,
     CAST(NEW.`ID` AS CHAR),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('antes', JSON_OBJECT('ID', OLD.`ID`, 'user_ID', OLD.`user_ID`, 'status', OLD.`status`+0, 'is_default', OLD.`is_default`), 'despues', JSON_OBJECT('ID', NEW.`ID`, 'user_ID', NEW.`user_ID`, 'status', NEW.`status`+0, 'is_default', NEW.`is_default`)));
END$$

CREATE TRIGGER `trg_user_addresses_after_delete` AFTER DELETE ON `tb_user_addresses` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tb_user_addresses', 'Delete', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN OLD.`ID` BETWEEN 0 AND 4294967295 THEN OLD.`ID` ELSE NULL END,
     CAST(OLD.`ID` AS CHAR),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('ID', OLD.`ID`, 'user_ID', OLD.`user_ID`, 'status', OLD.`status`+0, 'is_default', OLD.`is_default`));
END$$

CREATE TRIGGER `trg_address_components_after_insert` AFTER INSERT ON `tbd_address_components` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tbd_address_components', 'Create', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN NEW.`ID` BETWEEN 0 AND 4294967295 THEN NEW.`ID` ELSE NULL END,
     CAST(NEW.`ID` AS CHAR),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('ID', NEW.`ID`, 'address_ID', NEW.`address_ID`, 'address_sup_ID', NEW.`address_sup_ID`, 'component_type', NEW.`component_type`, 'status', NEW.`status`+0));
END$$

CREATE TRIGGER `trg_address_components_after_update` AFTER UPDATE ON `tbd_address_components` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tbd_address_components', 'Update', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN NEW.`ID` BETWEEN 0 AND 4294967295 THEN NEW.`ID` ELSE NULL END,
     CAST(NEW.`ID` AS CHAR),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('antes', JSON_OBJECT('ID', OLD.`ID`, 'address_ID', OLD.`address_ID`, 'address_sup_ID', OLD.`address_sup_ID`, 'component_type', OLD.`component_type`, 'status', OLD.`status`+0), 'despues', JSON_OBJECT('ID', NEW.`ID`, 'address_ID', NEW.`address_ID`, 'address_sup_ID', NEW.`address_sup_ID`, 'component_type', NEW.`component_type`, 'status', NEW.`status`+0)));
END$$

CREATE TRIGGER `trg_address_components_after_delete` AFTER DELETE ON `tbd_address_components` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tbd_address_components', 'Delete', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN OLD.`ID` BETWEEN 0 AND 4294967295 THEN OLD.`ID` ELSE NULL END,
     CAST(OLD.`ID` AS CHAR),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('ID', OLD.`ID`, 'address_ID', OLD.`address_ID`, 'address_sup_ID', OLD.`address_sup_ID`, 'component_type', OLD.`component_type`, 'status', OLD.`status`+0));
END$$

CREATE TRIGGER `trg_order_items_after_insert` AFTER INSERT ON `tbd_order_items` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tbd_order_items', 'Create', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN NEW.`ID` BETWEEN 0 AND 4294967295 THEN NEW.`ID` ELSE NULL END,
     CAST(NEW.`ID` AS CHAR),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('ID', NEW.`ID`, 'seller_order_ID', NEW.`seller_order_ID`, 'product_ID', NEW.`product_ID`, 'provider_ID', NEW.`provider_ID`, 'quantity', NEW.`quantity`, 'unit_price', NEW.`unit_price`, 'subtotal', NEW.`subtotal`));
END$$

CREATE TRIGGER `trg_order_items_after_update` AFTER UPDATE ON `tbd_order_items` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tbd_order_items', 'Update', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN NEW.`ID` BETWEEN 0 AND 4294967295 THEN NEW.`ID` ELSE NULL END,
     CAST(NEW.`ID` AS CHAR),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('antes', JSON_OBJECT('ID', OLD.`ID`, 'seller_order_ID', OLD.`seller_order_ID`, 'product_ID', OLD.`product_ID`, 'provider_ID', OLD.`provider_ID`, 'quantity', OLD.`quantity`, 'unit_price', OLD.`unit_price`, 'subtotal', OLD.`subtotal`), 'despues', JSON_OBJECT('ID', NEW.`ID`, 'seller_order_ID', NEW.`seller_order_ID`, 'product_ID', NEW.`product_ID`, 'provider_ID', NEW.`provider_ID`, 'quantity', NEW.`quantity`, 'unit_price', NEW.`unit_price`, 'subtotal', NEW.`subtotal`)));
END$$

CREATE TRIGGER `trg_order_items_after_delete` AFTER DELETE ON `tbd_order_items` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tbd_order_items', 'Delete', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN OLD.`ID` BETWEEN 0 AND 4294967295 THEN OLD.`ID` ELSE NULL END,
     CAST(OLD.`ID` AS CHAR),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('ID', OLD.`ID`, 'seller_order_ID', OLD.`seller_order_ID`, 'product_ID', OLD.`product_ID`, 'provider_ID', OLD.`provider_ID`, 'quantity', OLD.`quantity`, 'unit_price', OLD.`unit_price`, 'subtotal', OLD.`subtotal`));
END$$

CREATE TRIGGER `trg_users_wishlist_products_after_insert` AFTER INSERT ON `tbd_users_wishlist_products` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tbd_users_wishlist_products', 'Create', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN NEW.`user_ID` BETWEEN 0 AND 4294967295 THEN NEW.`user_ID` ELSE NULL END,
     CONCAT(NEW.`user_ID`, ':', NEW.`product_ID`),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('user_ID', NEW.`user_ID`, 'product_ID', NEW.`product_ID`, 'status', NEW.`status`+0));
END$$

CREATE TRIGGER `trg_users_wishlist_products_after_update` AFTER UPDATE ON `tbd_users_wishlist_products` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tbd_users_wishlist_products', 'Update', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN NEW.`user_ID` BETWEEN 0 AND 4294967295 THEN NEW.`user_ID` ELSE NULL END,
     CONCAT(NEW.`user_ID`, ':', NEW.`product_ID`),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('antes', JSON_OBJECT('user_ID', OLD.`user_ID`, 'product_ID', OLD.`product_ID`, 'status', OLD.`status`+0), 'despues', JSON_OBJECT('user_ID', NEW.`user_ID`, 'product_ID', NEW.`product_ID`, 'status', NEW.`status`+0)));
END$$

CREATE TRIGGER `trg_users_wishlist_products_after_delete` AFTER DELETE ON `tbd_users_wishlist_products` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tbd_users_wishlist_products', 'Delete', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN OLD.`user_ID` BETWEEN 0 AND 4294967295 THEN OLD.`user_ID` ELSE NULL END,
     CONCAT(OLD.`user_ID`, ':', OLD.`product_ID`),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('user_ID', OLD.`user_ID`, 'product_ID', OLD.`product_ID`, 'status', OLD.`status`+0));
END$$

CREATE TRIGGER `trg_people_after_insert` AFTER INSERT ON `tb_people` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tb_people', 'Create', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN NEW.`id` BETWEEN 0 AND 4294967295 THEN NEW.`id` ELSE NULL END,
     CAST(NEW.`id` AS CHAR),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('id', NEW.`id`, 'user_id', NEW.`user_id`, 'status', NEW.`status`+0));
END$$

CREATE TRIGGER `trg_people_after_update` AFTER UPDATE ON `tb_people` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tb_people', 'Update', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN NEW.`id` BETWEEN 0 AND 4294967295 THEN NEW.`id` ELSE NULL END,
     CAST(NEW.`id` AS CHAR),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('antes', JSON_OBJECT('id', OLD.`id`, 'user_id', OLD.`user_id`, 'status', OLD.`status`+0), 'despues', JSON_OBJECT('id', NEW.`id`, 'user_id', NEW.`user_id`, 'status', NEW.`status`+0)));
END$$

CREATE TRIGGER `trg_people_after_delete` AFTER DELETE ON `tb_people` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs
    (table_name, table_operation, db_user, record_id, record_key, actor_roles, operation_description)
  VALUES
    ('tb_people', 'Delete', SUBSTRING_INDEX(USER(),'@',1),
     CASE WHEN OLD.`id` BETWEEN 0 AND 4294967295 THEN OLD.`id` ELSE NULL END,
     CAST(OLD.`id` AS CHAR),
     (SELECT GROUP_CONCAT(DISTINCT FROM_USER ORDER BY FROM_USER SEPARATOR ', ')
      FROM mysql.role_edges WHERE TO_USER=SUBSTRING_INDEX(USER(),'@',1) AND TO_HOST='%'),
     JSON_OBJECT('id', OLD.`id`, 'user_id', OLD.`user_id`, 'status', OLD.`status`+0));
END$$
DELIMITER ;

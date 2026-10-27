-- Validaciones de solo lectura de la implementación del 22/10/2026.
USE bd_test;
SELECT DATABASE(), CURRENT_USER(), VERSION();
-- tb_buyer_orders_ibfk_1
SELECT COUNT(*) AS huerfanos FROM `tb_buyer_orders` a WHERE a.`seller_ID` IS NOT NULL AND NOT EXISTS(SELECT 1 FROM `tb_users` b WHERE a.`seller_ID`=b.`ID`);
-- fk_carts_user
SELECT COUNT(*) AS huerfanos FROM `tb_carts` a WHERE a.`user_ID` IS NOT NULL AND NOT EXISTS(SELECT 1 FROM `tb_users` b WHERE a.`user_ID`=b.`ID`);
-- fk_people_user
SELECT COUNT(*) AS huerfanos FROM `tb_people` a WHERE a.`user_id` IS NOT NULL AND NOT EXISTS(SELECT 1 FROM `tb_users` b WHERE a.`user_id`=b.`ID`);
-- fk_addresses_users
SELECT COUNT(*) AS huerfanos FROM `tb_user_addresses` a WHERE a.`user_ID` IS NOT NULL AND NOT EXISTS(SELECT 1 FROM `tb_users` b WHERE a.`user_ID`=b.`ID`);
-- fk_superior_category
SELECT COUNT(*) AS huerfanos FROM `tbc_categories` a WHERE a.`sup_id_category` IS NOT NULL AND NOT EXISTS(SELECT 1 FROM `tbc_categories` b WHERE a.`sup_id_category`=b.`ID`);
-- fk_component_address
SELECT COUNT(*) AS huerfanos FROM `tbd_address_components` a WHERE a.`address_ID` IS NOT NULL AND NOT EXISTS(SELECT 1 FROM `tb_user_addresses` b WHERE a.`address_ID`=b.`ID`);
-- fk_component_parent
SELECT COUNT(*) AS huerfanos FROM `tbd_address_components` a WHERE a.`address_ID` IS NOT NULL AND a.`address_sup_ID` IS NOT NULL AND NOT EXISTS(SELECT 1 FROM `tbd_address_components` b WHERE a.`address_ID`=b.`address_ID` AND a.`address_sup_ID`=b.`ID`);
-- fk_cart_items_cart
SELECT COUNT(*) AS huerfanos FROM `tbd_cart_items` a WHERE a.`cart_ID` IS NOT NULL AND NOT EXISTS(SELECT 1 FROM `tb_carts` b WHERE a.`cart_ID`=b.`ID`);
-- fk_cart_items_provider_product
SELECT COUNT(*) AS huerfanos FROM `tbd_cart_items` a WHERE a.`provider_ID` IS NOT NULL AND a.`product_ID` IS NOT NULL AND NOT EXISTS(SELECT 1 FROM `tbd_products_users_providers` b WHERE a.`provider_ID`=b.`user_ID` AND a.`product_ID`=b.`product_ID`);
-- fk_order_provider_product
SELECT COUNT(*) AS huerfanos FROM `tbd_order_items` a WHERE a.`provider_ID` IS NOT NULL AND a.`product_ID` IS NOT NULL AND NOT EXISTS(SELECT 1 FROM `tbd_products_users_providers` b WHERE a.`provider_ID`=b.`user_ID` AND a.`product_ID`=b.`product_ID`);
-- tbd_order_items_ibfk_1
SELECT COUNT(*) AS huerfanos FROM `tbd_order_items` a WHERE a.`seller_order_ID` IS NOT NULL AND NOT EXISTS(SELECT 1 FROM `tb_buyer_orders` b WHERE a.`seller_order_ID`=b.`ID`);
-- fk_category
SELECT COUNT(*) AS huerfanos FROM `tbd_products_categories` a WHERE a.`category_ID` IS NOT NULL AND NOT EXISTS(SELECT 1 FROM `tbc_categories` b WHERE a.`category_ID`=b.`ID`);
-- fk_product
SELECT COUNT(*) AS huerfanos FROM `tbd_products_categories` a WHERE a.`product_ID` IS NOT NULL AND NOT EXISTS(SELECT 1 FROM `tb_products` b WHERE a.`product_ID`=b.`ID`);
-- fk_products2
SELECT COUNT(*) AS huerfanos FROM `tbd_products_users_providers` a WHERE a.`product_ID` IS NOT NULL AND NOT EXISTS(SELECT 1 FROM `tb_products` b WHERE a.`product_ID`=b.`ID`);
-- fk_user1
SELECT COUNT(*) AS huerfanos FROM `tbd_products_users_providers` a WHERE a.`user_ID` IS NOT NULL AND NOT EXISTS(SELECT 1 FROM `tb_users` b WHERE a.`user_ID`=b.`ID`);
-- fk_user_payment_methods_type
SELECT COUNT(*) AS huerfanos FROM `tbd_user_payment_methods` a WHERE a.`payment_method_type_ID` IS NOT NULL AND NOT EXISTS(SELECT 1 FROM `tbc_payment_methods_types` b WHERE a.`payment_method_type_ID`=b.`ID`);
-- fk_user_payment_methods_user
SELECT COUNT(*) AS huerfanos FROM `tbd_user_payment_methods` a WHERE a.`user_ID` IS NOT NULL AND NOT EXISTS(SELECT 1 FROM `tb_users` b WHERE a.`user_ID`=b.`ID`);
-- fk_products3
SELECT COUNT(*) AS huerfanos FROM `tbd_users_wishlist_products` a WHERE a.`product_ID` IS NOT NULL AND NOT EXISTS(SELECT 1 FROM `tb_products` b WHERE a.`product_ID`=b.`ID`);
-- fk_user2
SELECT COUNT(*) AS huerfanos FROM `tbd_users_wishlist_products` a WHERE a.`user_ID` IS NOT NULL AND NOT EXISTS(SELECT 1 FROM `tb_users` b WHERE a.`user_ID`=b.`ID`);
SELECT 'tb_buyer_orders' AS tabla, COUNT(*) AS total FROM `tb_buyer_orders`;
SELECT 'tb_carts' AS tabla, COUNT(*) AS total FROM `tb_carts`;
SELECT 'tb_logs' AS tabla, COUNT(*) AS total FROM `tb_logs`;
SELECT 'tb_logs_productos' AS tabla, COUNT(*) AS total FROM `tb_logs_productos`;
SELECT 'tb_people' AS tabla, COUNT(*) AS total FROM `tb_people`;
SELECT 'tb_products' AS tabla, COUNT(*) AS total FROM `tb_products`;
SELECT 'tb_user_addresses' AS tabla, COUNT(*) AS total FROM `tb_user_addresses`;
SELECT 'tb_users' AS tabla, COUNT(*) AS total FROM `tb_users`;
SELECT 'tbc_categories' AS tabla, COUNT(*) AS total FROM `tbc_categories`;
SELECT 'tbc_payment_methods_types' AS tabla, COUNT(*) AS total FROM `tbc_payment_methods_types`;
SELECT 'tbd_address_components' AS tabla, COUNT(*) AS total FROM `tbd_address_components`;
SELECT 'tbd_cart_items' AS tabla, COUNT(*) AS total FROM `tbd_cart_items`;
SELECT 'tbd_order_items' AS tabla, COUNT(*) AS total FROM `tbd_order_items`;
SELECT 'tbd_products_categories' AS tabla, COUNT(*) AS total FROM `tbd_products_categories`;
SELECT 'tbd_products_users_providers' AS tabla, COUNT(*) AS total FROM `tbd_products_users_providers`;
SELECT 'tbd_user_payment_methods' AS tabla, COUNT(*) AS total FROM `tbd_user_payment_methods`;
SELECT 'tbd_users_wishlist_products' AS tabla, COUNT(*) AS total FROM `tbd_users_wishlist_products`;
SELECT COUNT(*) AS total FROM `vw_trazabilidad_productos`;
SELECT COUNT(*) AS total FROM `vw_trazabilidad_usuarios`;
SELECT COUNT(*) AS total FROM `vw_bitacora_usuarios`;
SELECT COUNT(*) AS total FROM `vw_total_products_by_category`;
SELECT COUNT(*) AS total FROM `vw_trazabilidad_categorias`;
SELECT COUNT(*) AS total FROM `vw_trazabilidad_categorizacion_productos`;
SELECT EVENT_OBJECT_TABLE,ACTION_TIMING,EVENT_MANIPULATION,TRIGGER_NAME FROM information_schema.TRIGGERS WHERE TRIGGER_SCHEMA='bd_test' ORDER BY EVENT_OBJECT_TABLE,EVENT_MANIPULATION;
SELECT TABLE_NAME,VIEW_DEFINITION FROM information_schema.VIEWS WHERE TABLE_SCHEMA='bd_test';
SELECT EVENT_NAME,STATUS,EVENT_DEFINITION FROM information_schema.EVENTS WHERE EVENT_SCHEMA='bd_test';

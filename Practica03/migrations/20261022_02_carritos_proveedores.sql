-- Migración incremental autorizada el 22/10/2026.
-- No repetir objetos existentes: inspeccionar antes; sin DROP ni importación de datos.
-- DDL tiene COMMIT implícito; ejecutar y verificar una sentencia a la vez.
USE bd_test;

ALTER TABLE bd_test.tb_carts
  MODIFY COLUMN user_ID INT NOT NULL,
  ADD CONSTRAINT fk_carts_user FOREIGN KEY (user_ID)
    REFERENCES bd_test.tb_users (ID)
    ON DELETE RESTRICT ON UPDATE RESTRICT;

CREATE TABLE bd_test.tbd_products_users_providers (
  user_ID INT NOT NULL,
  product_ID INT UNSIGNED NOT NULL,
  type_ownership ENUM('Owner','Reseller','Distributor') DEFAULT NULL,
  status BIT(1) NOT NULL DEFAULT b'1',
  avalaible_date DATETIME NOT NULL,
  creation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_update DATETIME NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (user_ID, product_ID),
  KEY fk_products2 (product_ID),
  CONSTRAINT fk_user1 FOREIGN KEY (user_ID)
    REFERENCES bd_test.tb_users (ID)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_products2 FOREIGN KEY (product_ID)
    REFERENCES bd_test.tb_products (ID)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

ALTER TABLE bd_test.tbd_cart_items
  MODIFY COLUMN provider_ID INT NOT NULL,
  ADD INDEX idx_cart_items_provider_product (provider_ID, product_ID),
  ADD CONSTRAINT fk_cart_items_provider_product
    FOREIGN KEY (provider_ID, product_ID)
    REFERENCES bd_test.tbd_products_users_providers (user_ID, product_ID)
    ON DELETE RESTRICT ON UPDATE RESTRICT;

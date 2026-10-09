USE bd_test;

/* Bitácora: mismas columnas y orden que en el repositorio de Marco. */
SELECT
    ID,
    table_name,
    table_operation,
    SUBSTRING_INDEX(db_user, '@', 1) AS db_user,
    operation_description,
    operation_date,
    operation_status
FROM tb_logs
ORDER BY ID;

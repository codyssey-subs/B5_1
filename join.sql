--INNER JOIN
SELECT
    c.category_id,
    c.name AS category_name,
    p.product_id,
    p.name AS product_name,
    p.price,
    p.stock
FROM categories c
INNER JOIN products p
    ON c.category_id = p.category_id;

--LEFT JOIN
SELECT
    c.category_id,
    c.name AS category_name,
    p.product_id,
    p.name AS product_name,
    p.price,
    p.stock
FROM categories c
LEFT JOIN products p
    ON c.category_id = p.category_id;
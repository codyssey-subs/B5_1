-- DB 날리기
-- FK관계가 있으므로 자식 테이블부터 삭제
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;


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


-- 없는 값 참조했을 때 FK 제약조건이 실제로 막히는지 테스트용
-- 존재하지 않는 user_id를 참조하는 주문 넣기
INSERT INTO orders (order_id, user_id, status)
VALUES (999, 9999, 'PAID');
-- 존재하지 않는 order_id를 참조
INSERT INTO order_items (order_item_id, order_id, product_id, quantity)
VALUES (999, 9999, 1, 2);
-- 존재하지 않는 product_id를 참조
INSERT INTO order_items (order_item_id, order_id, product_id, quantity)
VALUES (1000, 1, 9999, 2);
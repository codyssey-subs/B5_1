--1. 기본 조회
--1) 전체 사용자 조회
SELECT
    user_id, name, email, created_at
FROM users;
--2) 상품 목록 조회
SELECT
    product_id, name, price, stock
FROM products
WHERE price >= 30000;
--3) 가격이 30,000원 이상인 상품 조회
SELECT
    product_id, name, stock
FROM products
WHERE stock <= 10
ORDER BY stock ASC;
--4) 재고가 적은 상품 조회
SELECT
    product_id, name, stock
FROM products
WHERE stock <= 10
ORDER BY stock ASC;

--2. 조인
--5) 상품과 카테고리 함께 조회
SELECT
    p.product_id, p.name AS product_name, c.name AS category_name, p.price, p.stock
FROM products p
INNER JOIN categories c
    ON p.category_id = c.category_id;
--6) 주문한 사용자 정보 함께 조회
SELECT
    o.order_id, u.name AS user_name, u.email, o.order_date, o.status
FROM orders o
INNER JOIN users u
    ON o.user_id = u.user_id;
--7) 주문 상세 내역 조회
SELECT
    o.order_id, u.name AS user_name, p.name AS product_name, oi.quantity, oi.unit_price, oi.quantity * oi.unit_price AS item_total_price
FROM order_items oi
INNER JOIN orders o
    ON oi.order_id = o.order_id
INNER JOIN users u
    ON o.user_id = u.user_id
INNER JOIN products p
    ON oi.product_id = p.product_id;
--8) 모든 사용자와 주문 정보 조회
SELECT
    u.user_id, u.name AS user_name, o.order_id, o.order_date, o.status
FROM users u
LEFT JOIN orders o
    ON u.user_id = o.user_id;

--3. 집계
--9) 사용자별 주문 수 조회
SELECT
    u.user_id, u.name AS user_name, COUNT(o.order_id) AS order_count
FROM users u
LEFT JOIN orders o
    ON u.user_id = o.user_id
GROUP BY
    u.user_id, u.name;
--10) 주문별 총 결제 금액 조회
SELECT
    o.order_id, u.name AS user_name, SUM(oi.quantity * oi.unit_price) AS total_order_price
FROM orders o
INNER JOIN users u
    ON o.user_id = u.user_id
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    o.order_id, u.name;
--11) 카테고리별 평균 상품 가격 조회
SELECT
    c.category_id, c.name AS category_name, AVG(p.price) AS average_price
FROM categories c
INNER JOIN products p
    ON c.category_id = p.category_id
GROUP BY
    c.category_id, c.name;

--4. 서브쿼리
--12) 평균 가격보다 비싼 상품 조회
SELECT
    product_id, name, price
FROM products
WHERE price > (
    SELECT AVG(price)
    FROM products
);
--13) 특정 상품 재고 수정
UPDATE products
SET stock = 50
WHERE product_id = 1;
--14) 취소된 주문 삭제
DELETE FROM order_items
WHERE order_id IN (
    SELECT order_id
    FROM orders
    WHERE status = 'CANCELED'
);

DELETE FROM orders
WHERE status = 'CANCELED';

--5. 인덱스
--15) 상품 이름 검색 속도를 높이기 위한 인덱스 생성
CREATE INDEX idx_products_name
ON products(name);
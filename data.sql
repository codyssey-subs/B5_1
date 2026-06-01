-- 1. users 데이터 10개
INSERT INTO users (user_id, name, email) VALUES
(1, '김민준', 'minjun@example.com'),
(2, '이서연', 'seoyeon@example.com'),
(3, '박지훈', 'jihoon@example.com'),
(4, '최하은', 'haeun@example.com'),
(5, '정도윤', 'doyoon@example.com'),
(6, '강수빈', 'subin@example.com'),
(7, '조예린', 'yerin@example.com'),
(8, '윤서준', 'seojun@example.com'),
(9, '장유진', 'yujin@example.com'),
(10, '임현우', 'hyunwoo@example.com');


-- 2. categories 데이터 10개
INSERT INTO categories (category_id, name) VALUES
(1, '전자기기'),
(2, '의류'),
(3, '식품'),
(4, '도서'),
(5, '생활용품'),
(6, '스포츠'),
(7, '문구'),
(8, '뷰티'),
(9, '가구'),
(10, '완구');


-- 3. products 데이터 10개
INSERT INTO products (product_id, category_id, name, price, stock) VALUES
(1, 1, '무선 마우스', 25000, 100),
(2, 1, '기계식 키보드', 89000, 50),
(3, 2, '반팔 티셔츠', 19000, 200),
(4, 3, '원두 커피', 15000, 80),
(5, 4, 'SQL 입문서', 22000, 40),
(6, 5, '텀블러', 12000, 120),
(7, 6, '요가 매트', 30000, 60),
(8, 7, '노트 세트', 7000, 150),
(9, 8, '핸드크림', 9000, 90),
(10, 9, '접이식 의자', 45000, 30);


-- 4. orders 데이터 10개
INSERT INTO orders (order_id, user_id, status) VALUES
(1, 1, 'PAID'),
(2, 2, 'SHIPPING'),
(3, 3, 'DELIVERED'),
(4, 4, 'PAID'),
(5, 5, 'CANCELED'),
(6, 6, 'SHIPPING'),
(7, 7, 'DELIVERED'),
(8, 8, 'PAID'),
(9, 9, 'SHIPPING'),
(10, 10, 'DELIVERED');


-- 5. order_items 데이터 10개
INSERT INTO order_items (
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price
) VALUES
(1, 1, 1, 2, 25000),
(2, 2, 2, 1, 89000),
(3, 3, 3, 3, 19000),
(4, 4, 4, 2, 15000),
(5, 5, 5, 1, 22000),
(6, 6, 6, 4, 12000),
(7, 7, 7, 1, 30000),
(8, 8, 8, 5, 7000),
(9, 9, 9, 2, 9000),
(10, 10, 10, 1, 45000);
# B5_1
SQL로 만드는 나만의 데이터베이스

이 DB는 **사용자(users), 카테고리(categories), 상품(products), 주문(orders), 주문상세(order_items)** 를 관리하는 간단한 쇼핑몰 구조입니다.

상품은 하나의 카테고리에 속하고, 사용자는 여러 주문을 할 수 있으며, 하나의 주문에는 여러 상품이 `order_items`를 통해 연결됩니다.

또한 `FOREIGN KEY`, `UNIQUE`, `CHECK` 제약조건을 사용해 **없는 사용자/상품 참조 방지, 중복 주문상품 방지, 음수 가격·재고 방지, 주문 상태 제한** 같은 데이터 규칙을 적용합니다.

!mermaid-diagram (1).png.png)

### KEY

#### PK

<aside>
💡

각 행을 유일하게 구분하는 키

</aside>

- 중복 불가 : 같은 `user_id`를 가진 사용자가 2명 있을 수 없음
- NULL 불가 : 값이 비어 있으면 안 됨
- 테이블당 보통 1개 : 한 테이블의 대표 식별자 역할
- ex) users.user_id

#### FK

<aside>
💡

다른 테이블의 기본키를 참조해서 **테이블 사이의 관계를 연결하는 키**

</aside>

- ex) orders.user_id
- SQLite 외래키 설정하는 법
    
    ```
    --SQLite는 외래키를 선언해도, 설정에 따라 실제로 검사하지 않을 수 있음
    --SQLite에서는 보통 실행 전에 이걸 켜줘야 함
    PRAGMA foreign_keys = ON;
    ```
    
    - SQL 파일 맨 위에 항상 이렇게 써두는 게 좋아.
    - 실제로 켜졌는지 확인하려면 아래처럼 실행하면 돼.
    
    ```
    PRAGMA foreign_keys;
    ```
    
    - 없는 값을 참조하는지 테스트 후 정상이라면 아래 에러 출력
        
        ```
        Runtime error: FOREIGN KEY constraint failed
        ```
        
        - 예시 쿼리
            
            ```
            INSERTINTO orders (order_id, user_id, status)
            VALUES (999,9999,'PAID');
            ```
            

#### UK

<aside>
💡

기본키는 아니지만 **중복을 허용하지 않는 키**

</aside>

- ex) users.email
- PK와 차이:

| 구분 | PK | UNIQUE |
| --- | --- | --- |
| 역할 | 행의 대표 식별자 | 중복 방지 |
| NULL | 불가 | DB에 따라 가능 |
| 개수 | 보통 테이블당 1개 | 여러 개 가능 |

#### CK

<aside>
💡

기본키는 아니지만 **중복을 허용하지 않는 키**

</aside>

- 주로 중간 테이블에서 많이 사용
- ex) order_items(order_id, product_id)

### 정규화

<aside>
💡

테이블 간에 중복된 데이타를 허용하지 않는 것

</aside>

- 중복된 데이터를 허용하지 않음으로써 무결성(Integrity)를 유지할 수 있으며, DB의 저장 용량 역시 줄일 수 있다.

#### 1 정규화

- 테이블의 컬럼이 원자값(Atomic Value, 하나의 값)을 갖도록 테이블을 분해하는 것
- ex)
    - order테이블에서 products 컬럼에 여러 상품이 들어가는 경우 → order_items 테이블 생성
    
    | order_id | user_name | products |
    | --- | --- | --- |
    | 1 | 김철수 | 키보드, 마우스, 모니터 |
    
    | order_id | product_id | quantity |
    | --- | --- | --- |
    | 1 | 1 | 1 |
    | 1 | 2 | 2 |

#### 2 정규화

- 제1 정규화를 진행한 테이블에 대해 완전 함수 종속을 만족하도록 테이블을 분해하는 것
- 완전 함수 종속이라는 것은 기본키의 부분집합이 결정자가 되어선 안된다는 것
- ex)
    - order_items에서 product_name, category_name → product_id로 연결, user_name, user_email → order_id로 연결

```sql
order_items (
    order_id,
    product_id,
    product_name,
    category_name,
    user_name,
    user_email,
    quantity,
    unit_price
)
```

```sql
order_items (
		users,
		orders,
		products,
		categories,
		order_items
)
```

#### 3 정규화

- 제2 정규화를 진행한 테이블에 대해 이행적 종속을 없애도록 테이블을 분해하는 것
- 

```
이행적 종속이라는 것은 A -> B, B -> C가 성립할 때 A -> C가 성립되는 것
```

출처:

https://mangkyu.tistory.com/110

[MangKyu's Diary:티스토리]

```
제2 정규화를 진행한 테이블에 대해 이행적 종속을 없애도록 테이블을 분해하는 것
```

출처:

https://mangkyu.tistory.com/110

[MangKyu's Diary:티스토리]

- ex)
    - product와 category를 분리
    
    ```sql
    products (
        product_id,
        product_name,
        category_name,
        price,
        stock
    )
    ```
    
    ```sql
    products (
        product_id,
        category_id,
        price,
        stock
    )
    ```
    

### 무결성 제약조건

- DB에 **잘못된 데이터가 들어가지 않도록 막는 규칙**

| 제약조건 | 의미 | 예시 |
| --- | --- | --- |
| `PRIMARY KEY` | 각 행을 구분하는 고유한 값 | `user_id INTEGER PRIMARY KEY` |
| `FOREIGN KEY` | 다른 테이블에 실제로 존재하는 값만 참조 | `user_id`는 `users.user_id`에 있어야 함 |
| `NOT NULL` | 반드시 값이 있어야 함 | `name TEXT NOT NULL` |
| `UNIQUE` | 중복되면 안 됨 | `email TEXT UNIQUE` |
| `CHECK` | 정해진 조건을 만족해야 함 | `price >= 0` |
| `DEFAULT` | 값을 안 넣으면 기본값 자동 입력 | `created_at DEFAULT CURRENT_DATE` |

### 인덱스

<aside>
💡

CREATE INDEX 인덱스이름
ON 테이블이름(컬럼이름);

</aside>

<aside>
💡

CREATE INDEX idx_테이블명_컬럼명
ON 테이블이름(컬럼이름);

</aside>

- 검색을 빠르게 하기 위해 만드는 목차
    - 인덱스가 없으면 DB는 `products` 테이블의 데이터를 처음부터 끝까지 훑으면서 `name = '맥북'`인 데이터를 찾는다.
    - 이걸 **Full Scan**, 즉 전체 탐색이라고 볼 수 있어.
    - 그런데 `name`에 인덱스를 만들면 DB가 목차를 보고 바로 찾아갈 수 있다.
- 인덱스를 만들어두면 DB가 알아서 판단해서 사용
- 사용
    - `WHERE`에서 자주 검색하는 컬럼
    - 정렬에 자주 쓰이는 컬럼
- 단점
    - 데이터를 추가하거나 수정하거나 삭제할 때는 인덱스도 같이 갱신해야 해서 조금 느려질 수 있어

### JOIN

https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdna%2FeaO4DX%2FbtrGrYNKT7L%2FAAAAAAAAAAAAAAAAAAAAAKpqH21mrR5zNmN8gKfsBPWTmF2C1d5SoLt64Dg31296%2Fimg.png%3Fcredential%3DyqXZFxpELC7KVnFOS48ylbz2pIh7yKj8%26expires%3D1782831599%26allow_ip%3D%26allow_referer%3D%26signature%3Dq%252FWaqlonPgFs%252Bx9h%252BoTrz2Z1HCg%253D

### vs Excel

- 엑셀은 사람이 보는 표
- DB는 서비스가 신뢰할 수 있게 데이터를 관리하는 시스템

| 구분 | 엑셀 | DB |
| --- | --- | --- |
| 핵심 목적 | 사람이 직접 보고 수정하기 쉬움 | 서비스/시스템이 데이터를 안전하게 저장하고 조회 |
| 데이터 관계 | 시트끼리 관계 표현이 약함 | PK/FK로 테이블 간 관계 표현 가능 |
| 데이터 무결성 | 잘못된 값이 들어가도 막기 어려움 | NOT NULL, UNIQUE, CHECK, FK 등으로 규칙 강제 가능 |
| 대량 데이터 처리 | 데이터가 많아지면 느려지고 관리 어려움 | 대량 데이터 검색, 정렬, 집계에 강함 |
| 동시 사용 | 여러 명이 동시에 수정하면 충돌 위험 큼 | 여러 사용자의 동시 접근을 더 안전하게 처리 |
| 검색/조회 | 필터, 함수 중심 | SQL로 복잡한 조건, JOIN, GROUP BY 가능 |
| 변경 이력/트랜잭션 | 실수 복구나 동시 처리에 약함 | 트랜잭션으로 작업 전체 성공/실패를 안전하게 관리 |
| 서비스 연결 | 사람이 파일을 열어 사용 | 백엔드 서버가 직접 연결해서 사용 |
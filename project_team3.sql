-- 제품 테이블 생성
CREATE TABLE item (
    item_num NUMBER(5) PRIMARY KEY,      -- 제품 번호
    name     VARCHAR2(200) DEFAULT 0,    -- 제품 이름
    kind     VARCHAR2(20),               -- 제품 종류 (ex.한식,중식,...)
    price    NUMBER(10) DEFAULT 0,       -- 제품 가격
    regdate  DATE DEFAULT sysdate        -- 제품 등록일
);

-- 제품 번호 생성 시퀀스
CREATE SEQUENCE item_seq START WITH 1 INCREMENT BY 1; 

-- 고객 테이블 생성
CREATE TABLE users (
    id      VARCHAR2(20) PRIMARY KEY,   -- 유저 아이디
    pw      VARCHAR2(20),               -- 유저 패스워드
    name    VARCHAR2(20),               -- 유저 이름
    address VARCHAR2(100),              -- 유저 주소
    phone   VARCHAR2(20)                -- 유저 전화번호
);

-- 장바구니 테이블 생성
CREATE TABLE cart (
    cart_num      NUMBER(8) PRIMARY KEY,           -- 장바구니 번호
    id            VARCHAR2(20),                    -- 장바구니 이용 고객 아이디
    item_num      NUMBER(5),                       -- 제품 번호
    cart_quantity NUMBER(5) DEFAULT 1,             -- 장바구니에 담은 제품 수량
    cart_in_date  DATE DEFAULT sysdate,            -- 장바구니 담은 날짜
    CONSTRAINT fk_user_id FOREIGN KEY ( id )
        REFERENCES users ( id ),                      -- 외래키(참조)
    CONSTRAINT fk_item_num FOREIGN KEY ( item_num )
        REFERENCES item ( item_num )                  -- 외래키(참조)
);    

-- 장바구니 번호 생성 시퀀스
CREATE SEQUENCE cart_seq START WITH 1 INCREMENT BY 1;

-- 주문 테이블 생성
CREATE TABLE orders (
    orders_num  NUMBER(10) PRIMARY KEY,   -- 주문번호
    id          VARCHAR2(20),             -- 주문한 유저 아이디/foreign key for user(id)
    orders_date DATE DEFAULT sysdate,     -- 주문날짜  
    CONSTRAINT fk_orders_id FOREIGN KEY ( id )
        REFERENCES users ( id ) -- 외래키(참조)
);

-- 주문 번호 생성 시퀀스
CREATE SEQUENCE orders_seq START WITH 1 INCREMENT BY 1; 

-- 상세 주문 테이블 생성
CREATE TABLE orders_detail (
    orders_reaction_num NUMBER(10) PRIMARY KEY,      -- 주문처리 번호
    orders_num          NUMBER(10),                  -- 주문번호/foreign key for order(order_num)
    item_num            NUMBER(5),                   -- 제품번호/foreign key for item(item_num)
    quantity            NUMBER(5),                   -- 제품 수량
    orders_result       VARCHAR2(10) DEFAULT 1,      -- 처리유무(ex. 배송전:1, 배송중:2, 도착:3, ...)
    CONSTRAINT fk_orders_detail FOREIGN KEY ( orders_num )
        REFERENCES orders ( orders_num ),            -- 외래키(참조)
    CONSTRAINT fk_prod_detail FOREIGN KEY ( item_num )
        REFERENCES item ( item_num )                 -- 외래키(참조)
);

-- 주문처리 번호 생성 시퀀스
CREATE SEQUENCE orders_reaction_num_seq START WITH 1 INCREMENT BY 1;

-- 뷰 생성
-- (1) 카트 뷰
CREATE OR REPLACE VIEW cart_view AS
    SELECT
        c.cart_num      "장바구니 번호",
        c.id            "고객 ID",
        c.item_num      "제품 번호",
        u.name          고객명,
        i.name          제품명,
        c.cart_quantity "담은 수량",
        c.cart_in_date  "등록 날짜",
        i.price         가격
    FROM
        cart  c,
        users u,
        item  i
    WHERE
            c.id = u.id
        AND c.item_num = i.item_num;

-- (2) 주문 뷰
CREATE OR REPLACE VIEW order_view AS
    SELECT
        od.orders_reaction_num "주문처리 번호",
        o.orders_num "주문 번호",
        o.id 주문자명,
        o.orders_date "주문 날짜",
        od.item_num 주문번호,
        od.quantity 주문수량,
        u.name 고객명,
        u.address 주소,
        u.phone 전화번호,
        i.name 제품명,
        i.price 가격,
        od.orders_result 배송상태
    FROM
        orders        o,
        orders_detail od,
        users         u,
        item          i
    WHERE
            o.orders_num = od.orders_num
        AND o.id = u.id
        AND od.item_num = i.item_num;
        
-- 장바구니 뷰 출력        
SELECT
    *
FROM
    cart_view;
    
-- 주문 뷰 출력
SELECT
    *
FROM
    order_view;
    
    
    
-- 테이블 및 시퀀스 드랍    
DROP TABLE item;

DROP TABLE users;

DROP TABLE cart;

DROP TABLE orders;

DROP TABLE orders_detail;

DROP SEQUENCE item_seq;

DROP SEQUENCE orders_seq;

DROP SEQUENCE orders_reaction_num_seq;
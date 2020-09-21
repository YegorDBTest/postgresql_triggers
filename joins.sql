CREATE TABLE test_joins_1 (
    a integer,
    b varchar(1)
);

CREATE TABLE test_joins_2 (
    a integer,
    c integer
);


INSERT INTO test_joins_1 (a, b) VALUES (1, 'X');
INSERT INTO test_joins_2 (a, c) VALUES (1, 1);
INSERT INTO test_joins_2 (a, c) VALUES (1, 2);

INSERT INTO test_joins_1 (a, b) VALUES (2, 'Y');
INSERT INTO test_joins_2 (a, c) VALUES (2, 3);

INSERT INTO test_joins_1 (a, b) VALUES (3, 'Z');

INSERT INTO test_joins_2 (a, c) VALUES (4, 4);


-- Inner join

SELECT test_joins_1.b, test_joins_2.c
    FROM test_joins_1, test_joins_2
    WHERE test_joins_1.a = test_joins_2.a;
--  b | c 
-- ---+---
--  X | 1
--  X | 2
--  Y | 3
-- (3 rows)

SELECT test_joins_1.b, test_joins_2.c
    FROM test_joins_1 INNER JOIN test_joins_2
    ON (test_joins_1.a = test_joins_2.a);
--  b | c 
-- ---+---
--  X | 1
--  X | 2
--  Y | 3
-- (3 rows)


-- Left outer join

SELECT test_joins_1.b, test_joins_2.c
    FROM test_joins_1 LEFT OUTER JOIN test_joins_2
    ON (test_joins_1.a = test_joins_2.a);
--  b | c 
-- ---+---
--  X | 1
--  X | 2
--  Y | 3
--  Z |  
-- (4 rows)

SELECT test_joins_1.b, test_joins_2.c
    FROM test_joins_1 LEFT OUTER JOIN test_joins_2
    ON (test_joins_1.a = test_joins_2.a)
    WHERE test_joins_2.a IS NULL;
--  b | c 
-- ---+---
--  Z |  
-- (1 row)


-- Right outer join

SELECT test_joins_1.b, test_joins_2.c
    FROM test_joins_1 RIGHT OUTER JOIN test_joins_2
    ON (test_joins_1.a = test_joins_2.a);
--  b | c 
-- ---+---
--  X | 1
--  X | 2
--  Y | 3
--    | 4
-- (4 rows)

SELECT test_joins_1.b, test_joins_2.c
    FROM test_joins_1 RIGHT OUTER JOIN test_joins_2
    ON (test_joins_1.a = test_joins_2.a)
    WHERE test_joins_1.a IS NULL;
--  b | c 
-- ---+---
--    | 4
-- (1 row)


-- Full outer join

SELECT test_joins_1.b, test_joins_2.c
    FROM test_joins_1 FULL OUTER JOIN test_joins_2
    ON (test_joins_1.a = test_joins_2.a);
--  b | c 
-- ---+---
--  X | 1
--  X | 2
--  Y | 3
--  Z |  
--    | 4
-- (5 rows)

SELECT test_joins_1.b, test_joins_2.c
    FROM test_joins_1 FULL OUTER JOIN test_joins_2
    ON (test_joins_1.a = test_joins_2.a)
    WHERE test_joins_1.a IS NULL OR test_joins_2.a IS NULL;
--  b | c 
-- ---+---
--  Z |  
--    | 4
-- (2 rows)

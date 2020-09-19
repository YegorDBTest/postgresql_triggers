CREATE TABLE test1 (
    data integer
);

CREATE TABLE test2 (
    data integer
);

CREATE TABLE timestamps_holder (
    table_name text,
    dt timestamp
);


CREATE OR REPLACE FUNCTION add_test_timestamp() RETURNS TRIGGER AS $$
    BEGIN
        IF EXISTS(SELECT * FROM timestamps_holder WHERE table_name = TG_ARGV[0]) THEN
            UPDATE timestamps_holder SET dt = now() WHERE table_name = TG_ARGV[0];
        ELSE
            INSERT INTO timestamps_holder SELECT TG_ARGV[0], now();
        END IF;
        RETURN NULL;
    END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER add_test1_timestamp
    AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE ON test1
    FOR EACH STATEMENT
    EXECUTE PROCEDURE add_test_timestamp('test1');

CREATE TRIGGER add_test2_timestamp
    AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE ON test2
    FOR EACH STATEMENT
    EXECUTE PROCEDURE add_test_timestamp('test2');

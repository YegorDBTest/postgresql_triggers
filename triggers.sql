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

CREATE TABLE hashes_holder (
    table_name text,
    hash text
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

CREATE OR REPLACE FUNCTION add_test_hash() RETURNS TRIGGER AS $$
    DECLARE
        hash_value text := md5(random()::text);
    BEGIN
        IF EXISTS(SELECT * FROM hashes_holder WHERE table_name = TG_ARGV[0]) THEN
            UPDATE hashes_holder SET hash = hash_value WHERE table_name = TG_ARGV[0];
        ELSE
            INSERT INTO hashes_holder SELECT TG_ARGV[0], hash_value;
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

CREATE TRIGGER add_test1_hash
    AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE ON test1
    FOR EACH STATEMENT
    EXECUTE PROCEDURE add_test_hash('test1');

CREATE TRIGGER add_test2_hash
    AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE ON test2
    FOR EACH STATEMENT
    EXECUTE PROCEDURE add_test_hash('test2');

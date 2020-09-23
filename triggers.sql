CREATE TABLE test_triggers_1 (
    data integer
);

CREATE TABLE test_triggers_2 (
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
        IF EXISTS(SELECT * FROM timestamps_holder WHERE table_name = TG_TABLE_NAME) THEN
            UPDATE timestamps_holder SET dt = now() WHERE table_name = TG_TABLE_NAME;
        ELSE
            INSERT INTO timestamps_holder SELECT TG_TABLE_NAME, now();
        END IF;
        RETURN NULL;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_test_hash() RETURNS TRIGGER AS $$
    DECLARE
        hash_value text := md5(random()::text);
    BEGIN
        IF EXISTS(SELECT * FROM hashes_holder WHERE table_name = TG_TABLE_NAME) THEN
            UPDATE hashes_holder SET hash = hash_value WHERE table_name = TG_TABLE_NAME;
        ELSE
            INSERT INTO hashes_holder SELECT TG_TABLE_NAME, hash_value;
        END IF;
        RETURN NULL;
    END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER add_test1_timestamp
    AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE ON test_triggers_1
    FOR EACH STATEMENT
    EXECUTE PROCEDURE add_test_timestamp();

CREATE TRIGGER add_test2_timestamp
    AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE ON test_triggers_2
    FOR EACH STATEMENT
    EXECUTE PROCEDURE add_test_timestamp();

CREATE TRIGGER add_test1_hash
    AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE ON test_triggers_1
    FOR EACH STATEMENT
    EXECUTE PROCEDURE add_test_hash();

CREATE TRIGGER add_test2_hash
    AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE ON test_triggers_2
    FOR EACH STATEMENT
    EXECUTE PROCEDURE add_test_hash();

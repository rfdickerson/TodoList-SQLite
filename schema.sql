DROP TABLE IF EXISTS todos;
CREATE TABLE todos(rowid INTEGER PRIMARY KEY, title TEXT, owner_id VARCHAR(256), completed INTEGER, orderno INTEGER);

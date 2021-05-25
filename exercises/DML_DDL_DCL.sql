-- 1
-- ddl data definition language
-- create and modify databases and schema
-- CREATE DROP ALTER

-- dml data manipulation language
-- retrieve modify a databases data
-- SELECT INSERT UPDATE DELETE

-- dcl data control language
-- controls access to a database / table
-- defines rights and roles granted to users
-- GRANT REVOKE

-- 2
dml reads data

-- 3
ddl creates / manipulates tables not the data

-- 4
ddl ALTER manipulates the characteristics/attributes of a table (data definition) not the data

-- 5
dml create / manipulates the data in a table (not the structure of the data)

-- 6
dml update modifies rows of data of a database not its structure

-- 7
none as \d is a psql command not part of the SQL language / sublanguage, it does act like a ddl statement as it displays the schema of the table (the tables structure)

-- 8
DML as it deletes the data in a row and not the structure of the data

-- 9
ddl manipulates the database (structure of data) and the data deletion is a side-effect

-- 10
ddl CREATE creates structure of data as opposed to creating the data itself;

create sequence adds a sequence object to the database structure
sequence objects creates a bit of data used to keep track of a squence of automated generated values
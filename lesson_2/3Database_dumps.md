## Loading Database Dumps

SQL files contain manually typed SQL statements. There are 2 ways to import a SQL file into a database:

### psql

1. pipe the SQL file into the `psql` program using redirection on the command line, streaming it into `psql`s standard input:

```
$ psql -d my_database < file_to_import.sql
```

- this executes the SQL statements inside the `file_to_import.sql` inside the `my_database` database

2. if you already have a running `psql` session you can import a SQL file using `\i` meta command:

```sqlite
my_database=# \i ~/some/files/file_to_import.sql
```

its the same as the first command but you don't have to exit the current `psql` session

```sqlite
-- delete the public.films table if it exists
-- if films doesn't exist this line is ignored/skipped
DROP TABLE IF EXISTS public.films;

-- creates a table
CREATE TABLE films (title varchar(255), "year" integer, genre varchar(100));

-- inserts 3 individual records into a table 
INSERT INTO films(title, "year", genre) VALUES ('Die Hard', 1988, 'action');
INSERT INTO films(title, "year", genre) VALUES ('Casablanca', 1942, 'drama');
INSERT INTO films(title, "year", genre) VALUES ('The Conversation', 1974, 'thriller');
```


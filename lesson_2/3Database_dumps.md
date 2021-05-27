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

### Convert a table to a .sql file

```
pg_dump -d $DB_NAME -t $TABLE_NAME --inserts > dump.sql
```

```sql
--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: weather; Type: TABLE; Schema: public; Owner: instructor; Tablespace:
--

CREATE TABLE weather (
    date date NOT NULL,
    low integer NOT NULL,
    high integer NOT NULL,
    rainfall numeric(6,3) DEFAULT 0
);

ALTER TABLE weather OWNER TO instructor;

--
-- Data for Name: weather; Type: TABLE DATA; Schema: public; Owner: instructor
--

INSERT INTO weather VALUES ('2016-03-07', 29, 32, 0.000);
INSERT INTO weather VALUES ('2016-03-08', 23, 31, 0.000);
INSERT INTO weather VALUES ('2016-03-09', 17, 28, 0.000);
INSERT INTO weather VALUES ('2016-03-01', 34, 43, 0.117);
INSERT INTO weather VALUES ('2016-03-02', 32, 44, 0.117);
INSERT INTO weather VALUES ('2016-03-03', 31, 47, 0.156);
INSERT INTO weather VALUES ('2016-03-04', 33, 42, 0.078);
INSERT INTO weather VALUES ('2016-03-05', 39, 46, 0.273);
INSERT INTO weather VALUES ('2016-03-06', 32, 43, 0.078);

--
-- PostgreSQL database dump complete
--
```

- if you leave off the `--inserts` argument to `pg_dump` SQL output statements will restore table and its data but the format will be different:

  - it uses a `COPY FROM stdin` instead of multiple `INSERT` statements:

  ```sqlite
  COPY weather (date, low, high, rainfall) FROM stdin;
  2016-03-07  29  32  0.000
  2016-03-08  23  31  0.000
  2016-03-09  17  28  0.000
  2016-03-01  34  43  0.117
  2016-03-02  32  44  0.117
  2016-03-03  31  47  0.156
  2016-03-04  33  42  0.078
  2016-03-05  39  46  0.273
  2016-03-06  32  43  0.078
  \.
  ```

  - `COPY FROM` is default because it's more efficient on large data sets
  - uses `INSERTS` is valid and creates SQL statements that users write when adding data to a table manually

   

## KEYS

> *It is entirely possible to have identical rows of data that represent different real-world entities appear in the same table.*

The solution to the above issue is: 

- **do** use values that have been carefully select to be unique across the dataset
- **don't** use ordinary values in the data to identify rows

SQL databases use **keys**, which uniquely identify a single row in a database table. There's 2 types:

- Natural Keys
- Surrogate keys

### Natural Keys

these are existing values in a dataset that's used to uniquely identify a specific row of data. 

While it appears there's a lot of values that *might* satisfy the key criteria (a phone number, email address, SSN, product number), many do not. 

Phone numbers and email addresses can change hands, only some people have SSN's. Products can be revised whilst still maintaining the same product number

while you can create a **composite key** by combining more than 1 existing values, this can sometimes delay the problem instead of addressing it.

### Surrogate Keys

Instead we can use **surrogate keys** which is a value created solely to identify a row of data in a database table. 

- Because it was designed for that purpose, it avoids many problems associated with natural keys
- the most common surrogate key is an auto incrementing integer, which is added to each row every time we insert one into a table.
- as each row is added the value increases in order to remain unique in each row
- its common to call the surrogate key as **id** (short for identifier)

```sql
CREATE TABLE colors (id serial, name text);
INSERT INTO colors (name) VALUES ('red');
INSERT INTO colors (name) VALUES ('green');
INSERT INTO colors (name) VALUES ('blue');

 id | name
----+-------
  1 | red
  2 | green
  3 | blue
(3 rows)
```

- as shown all 3 rows have automatically added values entered into their `id` column
- These values can uniquely identify a row regardless of the values in other rows
- because these values are created by the database, outside forces cannot change them

`serial` is shorthand for a larger column definition:

```sqlite
-- Shorthand
CREATE TABLE colors (id serial, name text);

-- Longhand
CREATE SEQUENCE colors_id_seq;
CREATE TABLE colors (
    id integer NOT NULL DEFAULT nextval('colors_id_seq'),
    name text
);
```

- a sequence is a special kind of relations that generates a series of numbers. 
- A sequence will remember the last number generated and generates a predetermined sequence automatically.
- A sequences value is used as the `id` columns default value
- The next value in a sequence is accessed using `nextval` and can be done using a SQL statement:

```sqlite
SELECT nextval('colors_id_seq');
 nextval
---------
       4
(1 row)
```

- once a number is returned by `nextval` for a standard sequence, it cannot be returned again even if the value wasn't stored in a row.
- This means that `4` will be skipped as an id if we insert another row into the colors table

```sqlite
INSERT INTO colors (name) VALUES ('yellow');
 id |  name
----+--------
  1 | red
  2 | green
  3 | blue
  5 | yellow
(4 rows)
```



### Enforcing Uniqueness

A requirement of using an `id` column as a key is that all values must be unique - if there are duplicate values then the column isn't able to uniquely identify a row

```sql
INSERT INTO colors (id, name) VALUES (3, 'orange');

 id |  name
----+--------
  1 | red
  2 | green
  3 | blue
  5 | yellow
  3 | orange
(5 rows)
```

We can add a unique constraint, but all duplicated values must be updated first otherwise the error ` duplicate key value violates unique constraint` is raised:

```sqlite
UPDATE colors SET id = nextval('colors_id_seq') 
WHERE name = 'orange';
ALTER TABLE colors 
ADD CONSTRAINT id_unique UNIQUE (id);

 id |  name
----+--------
  1 | red
  2 | green
  3 | blue
  5 | yellow
  6 | orange
(5 rows)
```

### Primary Keys

PostgreSQL has 2 shortcuts for creating columns with default auto-incrementing values:

- `serial`
- `PRIMARY KEY`

specifying `PRIMARY KEY` as a constraint enables PostgreSQL to create an index on that column and enforces it to

- hold unique values
- prevent the column from holding `NULL` values

creating a table using primary key:

```sqlite
CREATE TABLE more_colors (id int PRIMARY KEY, name text);
```

create a table using constraints:

```sqlite
CREATE TABLE more_colors (id int NOT NULL UNIQUE, name text);
```

while the 2 are effectively the same, `PRIMARY KEY`s 

- are baked into the schema
- allow you to rely on a column to identify specific rows
- documents your intention as a database designer
- do not require the `NOT NULL` or `UNIQUE` constraints

To designate a column as a `PRIMARY KEY`:

- the column must contain unique values
- no values should be `NULL`

Following Conventions in software dev:

- saves time
- reduces confusion
- minimizes the time it takes to get up to speed on a new project

Contemporary database dev for Ruby / JS and other communities have developed the following conventions for tables and primary keys

1. all tables should have the primary column called `id`
2. `id` column should automatically be set to unique values as new rows are inserted into the table
3. `id` is often an integer (there are other data types - UUIDs)

While you don't have to have a `PRIMARY KEY` column in every table its generally a good idea

#### UUID

stands for *universally unique identifiers* are very large numbers that are used to identify individual objects or rows in a database. 

- There are different ways to generate these numbers (they don't increment by 1). 
- They are often represented using hexadecimal strings with dashes `f47ac10b-58cc-4372-a567-0e02b2c3d479`
## 1. Add Data with INSERT

The reason we add schema or structure to tables for that matter is to store data in an organized way. We use Data Manipulation language (DML) to add, query, change and remove data.



### Data and DML

DML is a sublanguage of SQL that enables us to write Data Manipulation Statements using:

- keywords
- clauses
- syntax

DML statements can be broken down into 4 different types:

1. `INSERT` - add new data into a database table
2. `SELECT` - aka queries, retrieve data from an existing table
3. `UPDATE` - update existing data in a database table
4. `DELETE` - delete exisiting data from a database table

#### CRUD

The actions performed by the above 4 types of DML is often known as CRUD. It's an acronym that stands for:

- **C**reate (`INSERT`)
- **R**ead (`SELECT`)
- **U**pdate (`UPDATE`)
- **D**elete (`DELETE`)

Each DML type correspond to a CRUD operation. Web apps that provide an interface to perform these actions are referred to as CRUD apps.



### Insertion Statement Syntax

the general form of an `INSERT` SQL statement:

```sqlite
INSERT INTO table_name (column1_name, column2_name, ...)
	VALUES (data_column1m data_column2, ...);
```

insert statements require 3 pieces of information:

1. The table name 
2. The names of the columns we're adding data to
3. The values we wish to store in said columns

- If you don't specify a column for data a null or default value will be added to the record you wish to store
- for each column specified you MUST add a value to it in the `VALUES` clause otherwise itll raise an error
- if you `INSERT` a `NULL` value into a `boolean` type it will insert `NULL` regardless. You don't want to practice this as `boolean` by nature has only 2 values: `true` or `false`. This is called the Three State Boolean problem or the Three Valued-logic problem.



### Adding rows of data

- columns give structure (schema) to our table
- rows (or tuples) contain the data of the table
  - each row in a table is an *individual entity* aka a record

#### add a row of data

```sqlite
sql_book=# \d users
                   Table "public.users"
   Column   |            Type             |   Modifiers
------------+-----------------------------+---------------
 id         | integer                     | not null
 full_name  | character varying(25)       | not null
 enabled    | boolean                     | default true
 last_login | timestamp without time zone | default now()
```

to add a row into the above table we could either make sure to supply a value for each column:

```sqlite
INSERT INTO users 
	VALUES (DEFAULT, 'John Smith', false, DEFAULT);
```

or specify the columns:

```sqlite
INSERT INTO users (full_name, enabled)
	VALUES ('John Smith', false);
```

The value order must match the columns order and by specifying columns its much easier to see each value line up

```sqlite
INSERT 0 1
```

The above is the response we get back:

- `0` refers to the `oid`
- `1` is how many rows were inserted

#### add multiple rows of data

you don't have to execute a separate `INSERT` statement for every piece of data inserted - we can use a single statement to add multiple rows of data to a table:

```sqlite
INSERT INTO users (full_name)
VALUES ('Jane Smith'), ('Harry Potter');
```

- its good practice to have every row on a separate line to clearly see what values you're adding to those rows
- postgreSQL adds rows in the order that was specified in our statement



### Constraints and adding Data

constraints are concerned with controlling what data can be added to a table

#### DEFAULT values

if a value isn't specified in an `INSERT` statement, then the `DEFAULT` value will be used instead.

#### NOT NULL constraints

`NOT NULL` constraints are useful that when a new row is added a value must be specified for that column.

if we try the following:

```sqlite
INSERT INTO users (id, enabled) VALUES (1, false);
```

We get the following error:

```sqlite
ERROR:  null value in column "full_name" violates not-null constraint
DETAIL:  Failing row contains (1, null, f, 2017-10-18 12:20:02.067639).
```

- if our `INSERT` statement is missing a column (with no `DEFAULT` constraint) SQL will try to insert `null` into that missing column. 
- Since we have a `NOT NULL` on the `full_name` column that `null` is rejected and an error is raised.

#### UNIQUE constraints

ensures you cannot have duplicate values in that column. 

- Having an id column in a database is useful. It's used to store unique identifiers per row of data
- we have to make sure that each id is `UNIQUE` for it to work properly
- We we added the `UNIQUE` constraint to the `id` column an index called `users_id_key` is created. 
- The next value that we insert into the id column is checked against existing values in the `users_id_key` index:
- if the value exists we can't insert any duplicate values into that column

```sqlite
ERROR:  duplicate key value violates unique constraint "unique_id"
DETAIL:  Key (id)=(1) already exists.
```

#### CHECK constraints

useful when we want to check values inserted against some specified pre condition

if we want to ensure a string isn't empty:

```sqlite
ALTER TABLE users ADD CHECK (full_name <> '');
```

`<>` is a 'not equal to' operator. If we were to insert the following into the `full_name` column we raise an error:

```sqlite
sql_book=# INSERT INTO users (id, full_name) VALUES (4, '');
ERROR:  new row for relation "users" violates check constraint "users_full_name_check"
DETAIL:  Failing row contains (4, , t, 2017-10-25 10:32:21.521183).
```

note: a name wasn't specified for the constraint and was left up to PostgreSQL

#### Quotations

if any word has a single quote mark or an apostrophe, it must be escaped with a second quote mark:

so `'O'Leary'` becomes `'O''Leary'`

### Summary

1 of 4 types of DML interaction: `INSERT`

- adding data
- creating data
- `INSERT` statement syntax
- Adding single and multiple rows of data
- Constraints to control what data is added:
  - `DEFAULT`
  - `NOT NULL` constraints
  - `UNIQUE` constraints
  - `CHECK` constraints

| Command                                                      | Notes                                                        |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| `INSERT INTO` table_name (column1_name, column2_name, ...) `VALUES` (data_for_column1, data_for_column2, ...); | creates a new record in *table_name* with the specified columns and their associated values. |
| `ALTER TABLE` table_name `ADD UNIQUE` (column_name);         | Adds a constraint to `table_name` that prevent non-unique values from being added to the table for `column_name` |
| `ALTER TABLE` table_name `ADD CHECK` (expression);           | Adds a constraint to `table_name` that prevents new rows from being added if they don't pass a *check* based on a specified expression. |





## 2. Select Queries

use `SELECT` to select or *query* data in specific ways. `SELECT` applies to the 'R' in CRUD - Read. And is considered to be the most common operation in database apps.  

### Select Query Syntax

The breakdown of a general `SELECT` statement is as follows:

```sqlite
SELECT [*, (column1, column2, ...)]
FROM table WHERE (condition);
```

```sqlite
SELECT enabled, full_name 
FROM users WHERE id < 2;

 enabled |  full_name
---------+--------------
 f       | John Smith
(1 row)
```

`SELECT` statement is very flexible and can be used with a number of clauses.

There are 3 parts to the above statement:

1. The column list: 
   - must sit between `SELECT` and `FROM`
   - can be a list of columns or a wildcard operator `*`
   - The order of columns in the response is based on the order of the column names in the statement
2. The table name:
   - comes after the `FROM` clause
   - table could exist in the database or could be a virtual table
3. The `WHERE` clause: 
   - comes after the table name
   - condition usually includes one of the columns you are querying



#### Identifiers and keywords

```sqlite
SELECT enabled, full_name 
FROM users WHERE id < 2;
```

in the example above:

- `enabled`, `full_name` and `users` are called identifiers as they identify columns or tables
- SQL is not a case-sensitive language 
  - anything that is isn't a keyword (keywords being `select` `from` `where`) is considered an identifier
- with this in mind try to avoid column or table names that are reserved keywords
- If its unavoidable double quote the identifier in the statement
  - eg. `year` is a reserved word so we must type `"year"` if we want it as an identifier

If you add parentheses to your query all data is grouped together in 1 column:

```sqlite
SELECT (id,name,age,species) FROM birds;
          row
-----------------------
 (1,Charlie,3,Finch)
 (2,Allie,5,Owl)
 (3,Jennifer,3,Magpie)
 (4,Jamie,4,Owl)
 (5,Roy,8,Crow)
(5 rows)
```



### `ORDER BY`

displays the result of a query in a particular sort order

eg. sorting blog posts from most recent on a website can be done with a query to order by the time of creation in descending order.

breakdown of an `ORDER_BY` clause is as follows:

```sqlite
SELECT [*, (column1, column2, ...)]
FROM table WHERE (condition)
ORDER BY column_name;
```

- `ORDER BY` comes after the table name and follows a `WHERE` clause if it is included.

```sqlite
SELECT full_name, enabled FROM users
ORDER BY enabled;

  full_name   | enabled
--------------+---------
 John Smith   |  f
 Jane Smith   |  t
 Harry Potter |  t
(3 rows)
```

- when ordering by boolean, `false` comes before `true` in ascending order
- Jane and Harry have the same `t` value so their order is arbitrary
- fine tune your order with `ASC` or `DESC` keywords (`ASC` is default if omitted)

```sqlite
SELECT full_name, enabled FROM users
ORDER BY enabled DESC;

  full_name   | enabled
--------------+---------
 Jane Smith   |  t
 Harry Potter |  t
 John Smith   |  f
(3 rows)
```

- to fine tune the ordering you have multiple columns order the results
- This is done with comma separated expressions in the `ORDER` clause:

```sqlite
SELECT full_name, enabled FROM users
ORDER BY enabled DESC, id DESC;

  full_name   | enabled
--------------+---------
 Harry Potter |  t
 Jane Smith   |  t
 John Smith   |  f
(3 rows)
```

- you can use columns or order by outside the list of identifiers mentioned
- you can set a sort direction for each column when ordering results

### Operators

typically used as part of an expression in a `WHERE` clause, operators are grouped into the following types:

1. comparison
2. logical
3. string matching

There are more operators available but the above are the most commonly used operators

#### comparison operators

compares 1 value to another. These values are usually numerical but other data types can be compared.

| Operator     | Description              |
| :----------- | :----------------------- |
| `<`          | less than                |
| `>`          | greater than             |
| `<=`         | less than or equal to    |
| `>=`         | greater than or equal to |
| `=`          | equal                    |
| `<>` or `!=` | not equal                |

There are also *comparison predicates* that behave like operators but have a special syntax:

- `BETWEEN`
- `NOT BETWEEN`
- `IS DISTINCT FROM`
- `IS NOT DISTINCT FROM`
- `IS NULL`
- `IS NOT NULL`

##### NULL

`NULL` by itself represents an unknown value. This means we cannot write something like:

```sqlite
WHERE column_name = NULL
```

When comparing with a `NULL` value we must use instead the `IS NULL` comparison predicate

```mysql
SELECT * FROM my_table WHERE my_column IS NULL;
```

#### logical operators

give more flexibility to your expressions:

- AND - allows you to combine multiple conditions into a single expression
- OR - allows you to combine multiple conditions into a single expression
- NOT - less commonly used

```mysql
SELECT * FROM users WHERE full_name = 'Harry Potter' OR enabled = 'false';
```

retrieves 2 rows as it looks for any row where either condition returns true

```mysql
 id |  full_name   | enabled |         last_login
----+--------------+---------+----------------------------
  1 | John Smith   | f       | 2017-10-25 10:26:10.015152
  3 | Harry Potter | t       | 2017-10-25 10:26:50.295461
(2 rows)
```

if AND replaced OR nothing would be retrieved as both conditions must be satisfied to retrieve a row

#### string matching

search for a subset of string data within a column 

if we wanted to check for all users with last name smith we can't check `full_name = smith` as smith is only part of the string. 

Here we can use the `LIKE` operator that follows a WHERE clause if present in a statement

```mysql
SELECT * FROM users WHERE full_name LIKE '%Smith';

id | full_name  | enabled |         last_login
----+------------+---------+----------------------------
 1 | John Smith | f       | 2017-10-25 10:26:10.015152
 2 | Jane Smith | t       | 2017-10-25 10:26:50.295461
(2 rows)
```

- the translation reads: match all users that have a full name with any number of characters followed by Smith
- the `%` is a wildcard character that represents any number of characters based on where it is placed in a string 
- LIKE is case sensitive: `%Smith` matches `Smith` but not `SMITH` nor `smith`
- for case-insensitive use `ILIKE %Smith`
- similarly `%`, `_` represents a single character that comes before after depending where it is placed
- `SIMILAR TO` is an alternative to `LIKE` except it expects a column to be compared with a regex expression 

### Summary

`SELECT` is the most used statement in SQL. Every database app will display data to users in some way.

| `SELECT` Clause                             | Notes                                                        |
| ------------------------------------------- | ------------------------------------------------------------ |
| `ORDER BY` column_name [ASC,DESC]           | Orders data selected by a column name inside a table. Data can be ordered either descending or ascending. If not specified the query defaults to ascending |
| `WHERE` column_name [>,=,<=, <>] value      | Filters result based on a comparison between a column and specified value. |
| `WHERE` expression1 [AND, OR] expression2   | Filters result based on truthiness of 1 expression AND OR truthiness of another expression |
| `WHERE` string_column `LIKE` `'%substring'` | Filters result based on if substring is found in a string_columns data and has x characters before or after that string.  Those characters are matched using the wildcard `%` |



## 3. More on Select

- how to use functions to process data
- how data can be grouped together based on various criteria
- further filter data using `LIMIT` `OFFSET` and `DISTINCT`

### LIMIT and OFFSET

displaying portions of data as separate 'pages' is a user interface pattern in web apps known as *pagination*. (splitting up pages from one page to the next like a results page)

![pagination example](https://d186loudes4jlv.cloudfront.net/sql/images/more_on_select/launch-school-forum-pagination.png)

`LIMIT` and `OFFSET` are at the heart of how pagination works.

If we only wanted to display 1 user at a time from the data it would work like this:

```sqlite
SELECT * FROM users LIMIT 1;
```

We can skip the first row and display the 2nd user using `OFFSET`:

```sqlite
SELECT * FROM users LIMIT 1 OFFSET 1;
```

If we need to return multiple results per page we can adjust the `LIMIT` value:

```sql
SELECT topic, author, publish_date, category, replies_count, likes_count, last_activity_date
FROM posts LIMIT 12 OFFSET 12;
```

`LIMIT` is also useful in development when previewing what kind of data would be available rather than returning the whole dataset. 

### DISTINCT

A common data quality issue is having duplicate data in your tables eg. joining tables together. To deal with duplication we can use the `DISTINCT` clause:

```sql
SELECT DISTINCT full_name FROM USERS;

 full_name
--------------
 John Smith
 Jane Smith
 Harry Potter
(3 rows)
```

`DISTINCT` is useful when used in conjunction with SQL functions:

```sql
SELECT count(DISTINCT full_name) FROM users;

 count
-------
     3
(1 row)
```

### Functions

A set of commands included as part of the RDBMS which perform operations on fields/data before returning the result.

- Some provide data transformations
- others return information on the operations carried out

Functions correspond to different types:

1. String
2. Date/Time
3. Aggregate

#### String Functions

| Function | Example                                               | Notes                                                        |
| :------- | :---------------------------------------------------- | :----------------------------------------------------------- |
| `length` | `SELECT length(full_name) FROM users;`                | This returns the length of every user's name. You could also use `length` in a `WHERE` clause to filter data based on name length. |
| `trim`   | `SELECT trim(leading ' ' from full_name) FROM users;` | If any of the data in our `full_name` column had a space in front of the name, using the `trim` function like this would remove that leading space. |

#### Date/Time Functions

| Function    | Example                                                      | Notes                                                        |
| :---------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| `date_part` | `SELECT full_name, date_part('year', last_login) FROM users;` | `date_part` allow us to view a table that only contains a part of a user's timestamp that we specify. The above query allows us to see each user's name along with the year of the `last_login` date. Sometimes having date/time data down to the second isn't needed |
| `age`       | `SELECT full_name, age(last_login) FROM users;`              | The `age` function, when passed a single `timestamp` as an argument, calculates the time elapsed between that timestamp and the current time. The above query allows us to see how long it has been since each user last logged in. |

#### Aggregate Functions

these functions compute a single result from a set of input values and they're useful when we group tables together:

| Function | Example                              | Notes                                                        |
| :------- | :----------------------------------- | :----------------------------------------------------------- |
| `count`  | `SELECT count(id) FROM users;`       | Returns the number of values in the column passed in as an argument. This type of function can be very useful depending on the context. We could find the number of users who have enabled an account, or even how many users have certain last names if we use the above statement with other clauses. |
| `sum`    | `SELECT sum(id) FROM users;`         | Not to be confused with `count`. This *sums* numeric type values for all of the selected rows and returns the total. |
| `min`    | `SELECT min(last_login) FROM users;` | This returns the lowest value in a column for all of the selected rows. Can be used with various data types such as numeric, date/ time, and string. |
| `max`    | `SELECT max(last_login) FROM users;` | This returns the highest value in a column for all of the selected rows. Can be used with various data types such as numeric, date/ time, and string. |
| `avg`    | `SELECT avg(id) FROM users;`         | Returns the average (arithmetic mean) of numeric type values for all of the selected rows. |

### GROUP BY

We often need to combine data results to form more meaningful information. 

if we wanted to count the number users who have accounts that are / aren't enabled

```sql
SELECT enabled, count(id) FROM users GROUP BY enabled;

 enabled | count
---------+-------
 f       |     1
 t       |     4
(2 rows)
```

```sql
SELECT enabled, full_name, count(id) FROM users GROUP BY enabled;   -- full_name is not grouped or
ERROR:  column "users.full_name" must appear in the GROUP BY clause or be used in an aggregate function
```

- When using aggregate functions you must include the columns you specified in the `GROUP BY` clause
- or be the result of an aggregate function
- or the `GROUP BY` clause must be based on the primary key
- this is to ensure that theres a single value for every column in the result
- while `GROUP BY` must specify all columns when using an aggregate function like `COUNT` we can ignore this rule when using `GROUP BY` with the tables primary key



### Summary

looked at a number of ways we can make `SELECT` more flexible:

- Retrieving portions of a dataset using `LIMIT` and `OFFSET`
- Retrieving unique value using `DISTINCT`
- Using SQL functions to work with data
- Aggregating data using `GROUP BY`



## 4. Update Data in a Table

uses for update / delete operations:

- Change the value of someone's `full_name`
- Fix a typo
- Update the enabled column for a specific user
- Delete an Incorrect entry
- Update the value of `last_login` when a user logs into the application



### Updating Data

To use the update statement:

```sqlite
UPDATE table_name SET [column_name = value, ... ]
WHERE (expression);
```

- This statement could be read as "Set column(s) to these values in a table when an expression evaluates to true"
- we can specify any table and any number of columns within that table to update its data
- The `WHERE` clause it optional and if omitted PostgreSQL will update every row in the target table
  - Because of this the expression to the `WHERE` clause needs to be restrictive / specific enough to only target the rows you want to modify
  - Test your clause using `SELECT` first before using `UPDATE`
- you can `SET` 1 or more column values with the `UPDATE` statement
- `WHERE` selects the rows that need to be updated

#### update specific rows

`WHERE` lets us update omit the specific rows that meet the condition set in that clause:

```sqlite
UPDATE users SET enabled = true
WHERE full_name = 'Harry Potter' OR full_name = 'Jane Smith'
```

As long as the `WHERE` clause is specific enough we can take advantage of the `id` column and update a single user:

```sqlite
UPDATE users SET full_name = 'Alice Walker' WHERE id = 2;
```

#### update all rows

Typically this is fairly unusual and you would want to update specific rows based on some criteria including the `WHERE` clause

eg. if you want to disable all users in response to a security issue:

```sqlite
UPDATE users SET enabled = false;
```

![Update All Rows](https://d186loudes4jlv.cloudfront.net/sql/images/update_and_delete_data/updating-data-update-all-rows.png)



### Deleting Data

Sometimes it isn't enough to fix a data issue and you may need to delete the row altogether

To use the delete statement:

```sqlite
DELETE FROM table_name WHERE (expression);
```

- `WHERE` is used to target specific rows

#### delete specific rows

```sqlite
DELETE FROM users 
WHERE full_name = 'Harry Potter' AND id > 3;
```

- adding the full_name adds extra protection from accidentally typing the wrong id value

#### delete all rows

- It's rare to delete all rows in a table
- The WHERE clause in a DELETE statement is optional and if omitted **ALL** rows in the table will be deleted

```sql
DELETE FROM users;
```



### Update vs Delete

- `SET` allows you to update 1 or more rows OR columns
- `DELETE` only allows you to remove 1 or more rows and not specific data in those rows
  - its not possible to delete values in rows
  - We use `NULL` instead to represent a deleted / unknown value 

To display a "deleted value":

```sqlite
UPDATE table_name SET column_name = NULL
WHERE (expression);
```

- we can use `SET =` to assign a `NULL` because it is not being compared to
- if a column has a `NOT NULL` constraint we can't set the value to `NULL` and an error is thrown



### Use Caution

- ideally you do not want to update / delete all the rows in a table
- If you `UPDATE` / `DELETE` without a `WHERE` clause you *WILL AFFECT THE ENTIRE TABLE*
- use `SELECT` first to verify the targeted rows you want to `UPDATE` / `DELETE`



### Summary

- the U and D in CRUD (updating and deleting)

| Statement                                                    | Notes                                                        |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| UPDATE table_name SET [column_name1 = value1, ...] WHERE (expression); | Update specified fields within a table. The rows updated are dependent on the `WHERE` clause. We may update all rows by leaving out the `WHERE` clause. |
| DELETE FROM table_name WHERE (expression);                   | Delete rows in the specified table. Which rows are deleted is dependent on the `WHERE` clause. We may delete all rows by leaving out the `WHERE` clause. |

- for a very simple application a single table may be all that needed
- However majority of the time multiple related tables are required 
- this is to model the data structure that your app needs
## 1. Create and View Database

before we can work with tables we need somewhere for it to exist - we need to create a database first.

The database can be likened to a building's envelope, its outer shell and the various shapes and sizes of rooms, some connected to each other within the building are like tables.

We'll be using Data Definition Language or DDL to create our database. It deals with setting up the structure / schema of a database. DDL refers to defining the characteristics of a database and its tables and columns 



### create a database

to **create** a new database quit `psql` and type `createdb $NAME;` where `$NAME` is the name of the database you'd like to create:

```
createdb sql_book
```



to **connect** to it via the psql console use the `psql` command and pass the `-d` flag along with the name of the database:

```
psql -d sql_book
```

This opens the database and connects to the specified database using the `-d` flag:

```mysql
psql (12.6)
Type "help" for help.

sql_book=#
```



`\list` meta command shows us the current list of all running databases:

```mysql
sql_book=# \list
                                List of databases
Name           |   Owner   | Encoding |   Collate   |    Ctype    |    Access privileges
---------------+-----------+----------+-------------+-------------+-------------------------
postgres       |   User    | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
sql_book       |   User    | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
template0      |   User    | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/User            +
               |           |          |             |             | User=CTc/User
template1      |   User    | UTF8     | en_US.UTF-8 | en_US.UTF-8 | User=CTc/User      +
               |           |          |             |             | =c/User
(4 rows)

When you create a new database it will be added to this list. 

When you installed `PostgreSQL` you are provided with 4 default databases:

- `template 0`
- `template 1`
- `postgres`
- `database of logged in user`



#### Using a SQL statement

while using `createdb` acts as a nice shortcut it is essentially a wrapper to the SQL command `CREATE DATABASE`. This implies that: 

- the utility function `createdb` is executed from the terminal 
- whereas the SQL command `CREATE DATABASE` is executed from the psql console. 

​```mysql
sql_book=# CREATE DATABASE another_database;
CREATE DATABASE
sql_book=#
```

- on line 1 we execute the `CREATE DATABASE` SQL command and pass the new databases name `another_database`. be sure to terminate the statement with a semi-colon
- on line 2 `CREATE DATABASE` is the response returned from PostgreSQL to let us know that the statement was executed successfully
- On line 3 a new prompt awaits ready to issue a new command

Aside from the name, we can pass additional arguments to the `CREATE DATABASE` command such as databases:

- encoding
- collation
- connection limit
- etc.

When omitted SQL will use default settings for these parameters



#### Convention: uppercase commands, Lowercase names

This convention is used by many developers to retain clarity. However SQL isn't case-sensitive as the below works too:

```mysql
create database my_database;
```

#### Convention: database naming

when naming a database:

- always try to keep names self-descriptive
  - eg a database containing info about employees could be named "employees" or "employee_database"
- less descriptive names could be "emp" or "records"
- databases should be written in `snake_casing`: lowercase words separated by underscores



### Connecting to a database

when we are in the psql console we can connect to a different database using the `\c` or `\connect` meta-commands:

```mysql
sql_book=# \c another_database
You are now connected to database "another_database" as user "User".
another_database=#
```

- on line 1 we were connected to `sql_book` as shown in the prompt. We then executed the `\c` meta command and passed `another_database` as the database   argument
- on line 2 is the output informing us that we successfully connected to the database `another_database`. The previous connection to `sql_book` is now closed and we are fully connected to `another_database`
- on line 3 the prompt now reads `another_database=#` referring to the database we are now connected to

Note that unlike SQL statements, we do *not* terminated meta-commands with a semi-colon

`\c` and `\connect` can take additional arguments other than the database name:

- username
- host
- port
- etc.

When omitted the command *reuses* the values from the previous connection. If connecting to a locally installed database you can omit the arguments above entirely

These additional arguments are helpful when connecting to a database hosted remotely or on a different server than the application / system wanting to connect to the database

### Delete the database

to delete a database we use the SQL command `DROP DATABASE $NAME;` where `$NAME` is the name of the database followed by a semi-colon: 

```mysql
yet_another_database=# DROP DATABASE another_database;
DROP DATABASE
yet_another_database=#
```

- line 1 indicates the SQL statement
- line 2 indicates the response returned by PostgreSQL to let us know the statement executed was successful
- line 3 prompts the user again for more commands

`dropdb` is the alias to `DROP DATABASE` and works the same when outside the psql console in command line. `dropdb` acts as a wrapper for `DROP DATABASE`

**caution:** treat the above commands with extreme care as their actions are permanent and irreversible. All data and schema related to the database is deleted. Think before issuing these commands.

### Summary

learned a handful of commands

1. learned commands that can be used in a `psql` session:

   | PSQL Command                         | Notes                                                        |
   | :----------------------------------- | :----------------------------------------------------------- |
   | `\l` or `\list`                      | displays all databases                                       |
   | `\c sql_book` or `\connect sql_book` | connects to the `sql_book` database                          |
   | `\q` or `exit`                       | exits the PostgreSQL session and returns to the command prompt |

   

2. learned commands that are programs installed by PostgreSQL on our system:

   | Command-line Command | Notes                                                        |
   | :------------------- | :----------------------------------------------------------- |
   | `psql -d sql_book`   | starts a `psql` session and connects to the `sql_database` called `sql_book` |
   | `createdb sql_book`  | creates a new database `sql_book` using a psql utility       |
   | `dropdb my_database` | permanently deletes the database named my_database and all its data |

   

3. utilities such as `createdb` and `dropdb` are wrapper functions for actual SQL statements:

   | SQL Statement               | Notes                                                        |
   | :-------------------------- | :----------------------------------------------------------- |
   | `CREATE DATABASE sql_book`  | creates a new database called sql_book                       |
   | `DROP DATABASE my_database` | permanently deletes the database names my_database and all its data |

## 2. Create and View Tables

now that we have the building's envelope - the database - it is now time to create the rooms inside it. Rooms provide the structure for spaces as does tables do for our data.

relationships are the real structure that helps house our data.

Tables (or relations as its sometimes called), often represent abstractions of real-world business logic- such as a customer or an order. Once created, tables can be used to store data relevant to that particular abstraction.

### Table Creation Syntax

to create a table we use the `CREATE TABLE` SQL statement. While it's similar to the `CREATE DATABASE` statement, it contains a set of parentheses at the end of it. 

```mysql
CREATE TABLE some_table();
```

With empty parentheses an empty table is created which, has no structure therefore we must add columns. To do it we add "column definitions" *between* the parentheses:

 ```mysql
 CREATE TABLE table_name (
   column_1_name column_1_data_type [constraints, ...],
   column_2_name column_2_data_type [constraints, ...],
   .
   .
   .
   constraints
 );
 ```

The above is the basic format for creating a new table:

- Each column definition is written on a new line, separated by a comma.
- column names and data types are required, constraints are optional
- constraints can be defined at either column or table level

#### creating a `users` table

we want to store a list of users in the `sql_book` database. For each user we want to store: 

1. an id
2. their username
3. whether their account is `enabled` or not

We will create a column for each that functions as a container for each piece of data:

```mysql
CREATE TABLE users (
id serial UNIQUE NOT NULL,
username char(25),
enabled boolean DEFAULT TRUE
);
```

- `CREATE TABLE users` is the primary command
- `users` is the name of the table to be created
- `()` all information between parentheses are related to the columns in the table
- `id, username, enabled` are the 3 columns of the table
- `serial`, `char(25)`, `boolean` are the 3 data types of each column
- `UNIQUE`, `NOT NULL` These are constraints
- `DEFAULT TRUE` specifies a default value for the column
- each column is separated by a comma `,` and parentheses are terminated with a semicolon `;`



### Data Types

data types classify particular values that allowed for that column, this is to prevent the database from receiving invalid data types.

in our above example:

- `id` column has the data type `serial`
- `username` column has the data type `char(25)`
- enabled column has the data type`boolean`

#### Common data types:

- **serial:** auto-incrementing integer identifiers that cannot contain a null value. They're used to create identifier columns for a PostgreSQL database
  - as of v.10 of Postgres `IDENTITY` is the new syntax for handling auto-incrementing values. Using `serial` is no longer recommended for new apps. `serial` is said to have compatibility and permission management issues
- **char(N): **data strings of up to N characters in length. If a string less than N is stored it is filled up with space characters
- **varchar(N):** data strings of up to N characters in length. If a string less than N is stored, the remaining string length isn't used
- **boolean:** data type that only has 2 values `true` or `false`. PostgreSQL can use the shorthand formant `t` or `f`
- **integer or INT:** a non-decimal whole number that can be negative or positive
- **decimal(precision, scale):** decimals take 2 arguments, the first is the total number of digits on both sides of the decimal (the precision), the second is the number of digits on the fractional part (to the right) of the decimal (the scale). eg. 50.00(4, 2)
- **timestamp:** simple data / time format : yyyy-mm-dd     hh:mm:ss
- **date:** contains the date but no time

### Keys and Constraints

Constraints are extremely useful and while they aren't mandatory like data types are, you'll want to add some type of constraint to your columns.

Keys and constraints define the rules for what data values are allowed in a particular column, single or multiple tables or an entire schema. This helps to maintain a databases data integrity and quality. 

Keys and Constraints is apart of a databases schema definition and the database design process.

#### Common Constraints / Properties

- **UNIQUE:** prevents any duplicate values from being entered into that column
- **NOT NULL:** when adding data to the table a value is required for this column; it cannot be left empty
- **DEFAULT:** if no value is set in this field when a record is create then the value of `TRUE` is set in that field

Keys come into play when we setup relationships between different database tables. They also help keep track of unique rows in a database table.

### View the Table

to view a list of all the tables that exist in the database use the `\dt` meta-command:

```mysql
sql_book=# \dt
         List of relations
 Schema | Name  | Type  |   Owner
--------+-------+-------+-----------
 public | users | table | User
(1 row)
```



to view more detailed information about a particular table use the `\d` command and pass the name of the table we'd like to view:

```mysql
sql_book=# \d users
        Table "public.users"
  Column  |     Type      |  Modifiers
----------+---------------+----------------------------------------------------
 id       | integer       | not null default nextval('users_id_seq'::regclass)
 username | character(25) |
 enabled  | boolean       | default true
Indexes:
   "users_id_key" UNIQUE CONSTRAINT, btree (id)
```

This displays the table with each columns data type and properties. The return value of `\d` will vary from version to version of PostgreSQL

- the `id` column's type is `integer`, which may seem strange considering `serial` was the type when we created the `users` table. `serial` uses the `integer` data type along with a `DEFAULT` constraint and a function called `nextval` - this keeps track of the highest value and increments it by 1 to be used as the next value
- the table also contains has an index of `users_id_key` which was created when we added the `UNIQUE` constraint. Indices are a way of storing quick-reference values in a particular column. will be discussed again when inserting data into our table 

### Schema and DCL

A databases **schema** provides the structured needed to house our data.`\dt` and `\d` commands are only related to *schema* of the database - not the data.

While the sub-sql language DDL (data definition language) manages most of a database's schema, There are parts of the databases schema that is handled by DCL (data control language)

DCL deals with security settings and who can perform certain actions in a database. When we view table information with `\dt` we can see `Owner`. Everything within the `Owner` column is handled by DCL as it deals with permissions. 

An example of this is adding a restriction to the table so other users can add, read, update and delete the data from a table but only the owner can alter or delete the structure of the table entirely. 

### Summary

Tables:

- Tables are created using the `CREATE TABLE` SQL command
- Table columns definitions go between parentheses of the `CREATE TABLE` statement
  - Table column definitions consist of: 
    - column name, 
    - data type
    - optional constraints
  - Constraints can be used on the data that is entered into a particular column
- we use meta-commands to view a list of tables / structures of a particular table in the psql console
- Majority of database schema is DDL, but parts of it (access and permissions) are determined by DCL (Data Control Language)

| Command                | Notes                                    |
| :--------------------- | :--------------------------------------- |
| CREATE TABLE users (); | Creates a new table called *users*       |
| \dt                    | Shows the tables in the current database |
| \d users               | Shows the schema of the table *users*    |

## 3. Alter a Table

Before any alterations, make sure you have a think about how changing a table's schema will affect your data. Adding an extra column adds a column to all existing rows while deleting a column means permanently deleting all its containing data. 

### Alter Table Syntax

the `ALTER TABLE` statement is DDL and it is only for altering a **schema**

the basic format for an `ALTER TABLE` statement is:

```sqlite
ALTER TABLE table_name ALTERATION additional arguments;
```



### Rename a table

A table can be renamed using the `RENAME` clause followed by the `TO` clause, which specifies what we want to rename the table as:

```sqlite
ALTER TABLE users
RENAME TO all_users;



### Rename a column

you can also use the `RENAME` clause to rename a column in the table. The difference between naming a table is that you must pass the `COLUMN` clause followed by the columns name between the `RENAME` and `TO` clauses.

​```sql
ALTER TABLE all_users
RENAME COLUMN username TO full_name;
```



### Change a Columns Datatype

There may be times where you will have to alter a columns type and you can do so by using the `ALTER TABLE` statement in conjunction with the `ALTER COLUMN` statement to target a specific column

```mysql
ALTER TABLE all_users
ALTER COLUMN full_name TYPE varchar(25);
```

If there is no implicit conversion (cast) from the old data type to the new type (eg. if both are still strings) you will need to add a `USING` clause to the statement, specifying how to compute the new column value from the old:

```mysql
ALTER COLUMN column_name
TYPE new_data_type
USING column_name::new_data_type
```

When it comes to decimal if you are changing the precision and scale, the syntax is the same as if changing to a completely new type

### Adding a Constraint 

constraints are optional and different to datatypes in the sense that we don't change a column, we instead add or remove constraints. You can add multiple constraints too.

The syntax for constraints will vary and depends on the type of constraint we're adding: 

- Some types are considered 'table constraints' (even if they apply to a specific column) 
- while others (such as `NOT NULL`) are 'column constraints'

Some commands will let you specify table constraints while others are for column constraints

- `NOT NULL` is always a column constraint
- the others `PRIMARY KEY`,  `FOREIGN KEY`, `UNIQUE` and `CHECK` can either be table or column constraints
- `CREATE TABLE` lets you specify either column / table constraints
- `ALTER TABLE` lets you only work with with table constraints or `NOT NULL`
- you can also add column constraints when defining a new column in an existing table



to add the `NOT_NULL` column constraint to an existing table:

```sqlite
ALTER TABLE table_name ALTER COLUMN column_name SET NOT NULL;
```

to add any other constraint to an existing table:

```sqlite
ALTER TABLE table_name ADD CONSTRAINT constraint_name constraint clause;
```

if you don't want to specify a name:

```sqlite
ALTER TABLE table_name ADD constraint_clause;
```

multiple comma separated `ALTER COLUMN` actions can be combined under 1 `ALTER TABLE` statement:



### Removing a constraint

For most types of constraints we can use the same syntax for both column and table constraints

```sqlite
ALTER TABLE table_name DROP CONSTRAINT constraint_name;
```

`DEFAULT` technically isn't a constraint so the syntax works different:

```sqlite
ALTER TABLE table_name
ALTER COLUMN column_name DROP DEFAULT;
```



### Adding a Column:

There may be situations where you have to add a whole new column. Use the `ADD COLUMN` clause after the `ALTER TABLE` statement.

```sqlite
ALTER TABLE table_name
ADD COLUMN column_name data_type optional_constraints;
```

`NOW()` is a SQL function that gives the current date and time when invoked, there are many functions available.



### Removing a column:

To remove a column use the `ALTER TABLE` clause and the `DROP COLUMN` clause:

```sqlite
ALTER TABLE all_users DROP COLUMN enabled;
```



### Dropping Tables:

to permanently remove a table its similar to dropping a database:

```mysql
DROP TABLE table_name
```

`DROP COLUMN` and `DROP TABLE` are irreversible and should be cautiously used. Bear in mind if you delete the schema or table you permanently lose all data it contained.



### Summary

general syntax for `ALTER TABLE` (altering a table):

| Action                                | Command                                                      | Notes                                                        |
| :------------------------------------ | :----------------------------------------------------------- | :----------------------------------------------------------- |
| Add a column to a table               | ALTER TABLE table_name ADD COLUMN column_name data_type CONSTRAINTS; | Alters a table by adding a column with a specified data type and optional constraints. |
| Alter a column's data type            | ALTER TABLE table_name ALTER COLUMN column_name TYPE data_type; | Alters the table by changing the datatype of column.         |
| Rename a table                        | ALTER TABLE table_name RENAME TO new_table_name;             | Changes the name of a table in the currently connected to database. |
| Rename a column within a table        | ALTER TABLE table_name RENAME COLUMN column_name TO new_column_name; | Renames a column of the specified table.                     |
| Add column constraint (`NOT NULL`)    | ALTER TABLE table_name ALTER COLUMN column_name SET NOT NULL; | Adds a specified constraint to the specified table column.   |
| Add table constraint                  | ALTER TABLE table_name ADD CONSTRAINT constraint_name constraint_clause; | Adds a specified constraint to the specified table.          |
| Remove a table constraint             | ALTER TABLE table_name DROP CONSTRAINT constraint_name;      | Removes a constraint from the specified table.               |
| Remove a column constraint (NOT NULL) | ALTER TABLE table_name ALTER COLUMN column_name DROP CONSTRAINT; | Removes a constraint from the specified column. This syntax is necessary for `NOT NULL` constraints, which aren't specifically named. |
| Remove a column from a table          | ALTER TABLE table_name DROP COLUMN column_name;              | Removes a column from the specified table.                   |
| Delete a table from the database      | DROP TABLE table_name;                                       | Permanently deletes the specified table from its database.   |

- creating and setting up tables with DDL syntax is much less frequent than when working with data in the tables, which means you don't have to memorize all of the specific syntax covered.

- have a clear picture of how schema works refer to documentation when you need to check syntax

- Familiarize yourself with DML syntax as the bulk of your time will be spent manipulating data - so you should be as fluent as possible with commands and clauses 


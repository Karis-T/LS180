## 1. Introduction

### The importance of data

humans have a limited capacity to remember facts and figures - but we can make better choices with tools that help us access and analyse data quickly 

collecting, organising and studying data to find patterns and meaning is of primary importance. Before data can be studied it needs to be structured and stored 

### structured data

structured data aims to solve the problems with *unstructured data*

While unstructured may work with small amount of information, *when there's too much data its too hard to wield*

![Unstructured data](https://d186loudes4jlv.cloudfront.net/sql/images/introduction/unstructured-data.png)

This is why we structure data - one way to do it is in tabular format with rows and columns

![Structured data](https://d186loudes4jlv.cloudfront.net/sql/images/introduction/structured-data.png)

storing data in this way helps us easily find and manage the data better

data can also be arranged in various ways too

- sorting alphabetically 
- totaling a set of values 

a common way to store structured data is with a relational database. 

A database is basically *a structured set of data held in a computer*

### Spreadsheet as database

if we want to store the name, email of reviewers for a popular website we could create a worksheet and add an id to each name and email

![A users table](https://d186loudes4jlv.cloudfront.net/sql/images/introduction/users.png)

We don't want to clutter the spreadsheet but we want to add the users reviews so we make a second worksheet

![A reviews table](https://d186loudes4jlv.cloudfront.net/sql/images/introduction/reviews.png)

most spreadsheets will have multiple worksheets to organize data

each worksheet has unique columns for new data that needs storing

*A spreadsheet can be thought of as a database*

- The worksheets describe tables within a database
- A table in this context is a list of individual, related data entries (rows)
  - each row is a single set of related data
-  each data entry stores values for shared attributes (columns) 
  - each column is a standard way to store data for that type of attribute

| Spreadsheet      | Database     |
| ---------------- | ------------ |
| Worksheet        | Table        |
| Worksheet Column | Table Column |
| Worksheet Row    | Table Record |

### Relational Database Management Systems

over time all kinds of data is added to the spread sheet above. 

issues such as:
- duplicate data
- typos
- formatting issues (multiple people working on the same file)
- finding/collecting information requires a lot of scrolling and searching

The spreadsheet is now too difficult to wield so its time to move to a **relational database management system**

A **relational database** is a database organised according to the relational model of data.

- relational databases: 
  - cut down duplicated data
  - are useful data structures to interact with

A **relational model** defines a set of relations (think tables) and its connections so we can determine how the stored data interacts.

- relational models elevate a database from a 2 dimensional table to data structured in a complex and detailed fashion
- a relational model is not the only database structured model out there. 
  - There's also a document-orientated data storage /retrieval model used by programs like Mongo DB. 
  - These systems are grouped under the term 'NoSQL'

A (relational database management system) (RDBMS) is a software application / system for managing databases. 

RDBMS's allow users or another application to interact with a database by issuing commands using syntax that conforms to a set of conventions / standards

There are many RDBMSs:

- SQLite
- MS SQL
- PostgreSQL
- MySQL

some are lightweight and easy to install / use. Others are robust / scalable and more complex to use

while RDBMSes vary and have slight syntactical differences They all use the same language - SQL

### SQL

SQL (pronounced Sequel or "S" "Q" "L") means *Structured Query Language* and is the programming language used to communicate with a relational database

by learning SQL you are able to use any of the programs mentioned previously plus more.

SQL is a **declarative language** which means when you write a SQL statement you describe *what* needs to be done rather than *how* to do it

The *how* is handled by the RDBMS internally

#### SQL history

SQL began in the 1970s where a paper "A relational model for large data banks" by E.F.Codd laid the foundation of relational databases.

Over time companies saw the value in Codds paper and mmany begun developing the SQL language and producing relational database products.

relational algebra is a mathematical model that underlies relational databases and it is the theory that relational databases are built on.

####  Why learn SQL?

since relational databases are so widespread we use multiple databases per day:

- Firefox uses SQL lite to keep track of users history / data
- banking systems may use Oracle database to store daily transactions

SQL is used in programming languages like ruby on rails, where any code written generates SQL behind the scenes.

database data usually outlives the apps code in a program

well designed code and relational database concepts lays the foundation to building robust applications. Databases are a key part of nearly all web apps so understanding SQL is vital to becoming a great developer    

### Summary

- data supports and forms the basis of web applications / web development
- structured data vs unstructured data
  - databases are a useful way to structure data in web applications.
- RDBMS are software applications for managing relational databases - SQL is the language for this





## 2. Preparations

### Vocabulary

1. **Relational database:** A structured collection of data that follows the relational model
2. **RDBMS:** Relational Database Management System. A software application for managing relational databases such as PostgreSQL
3. **Relational Model:** a set of individual, related data entries- think database table
4. **SQL:** Structured Query Language - the Language used by RDBMSs.
5. **SQL Statement:** A SQL command used to access / use the database or its data
6. **SQL query:** A way to *search / lookup data* within a database (as opposed to updating / changing data). Queries are subsets of  SQL statements.

### Summary

- learned important terms and phrases used throughout the book
- learned how to install PostgreSQL on Linux





## 3. Interacting with PostgreSQL

### Interacting with a database

There are many ways / interfaces / clients you can use to access a RDBMS - in this case we are talking about PostgreSQL. 

you can access it 

- from a programming language
- through a GUI application
- or through command line interface

These interfaces all have common underlying architecture used to interact with a database. Each interface:

- issues a request / declaration
- and receives a response in return

This is known as *client-server* architecture. PostgreSQL is a "client-server" database design used by most relational databases 

**client-server architecture:** With a database we connect to the server (PostgreSQL server), using a client (PostgreSQL Client). clients transmits commands to the server and the server sends the result / data back.

![Client server architecture](https://d186loudes4jlv.cloudfront.net/sql/images/interacting_with_postgresql/client-server-msg.png)

whichever type of PostgreSQL client you want to use (be it through a GUI or CLI) that interface is an abstracted from basically issuing queries to the database using SQL syntax.

Depending on the client that SQL syntax may be 'wrapped' in other commands or abstracted away altogether with a visual interface, either way the same stuff is all happening underneath.

Using the command line develops a stronger understanding of the database fundamentals and SQL.

### PostgreSQL Client Applications

postgreSQL comes with a number of 'client applications' and interact with postgre via the command line. Call these from the terminal. Common client postgreSQL apps include:

-  `createdb`
- `dropdb`
- `pg_dump`
- `pg_restore`
- `pg_bench`

Some of these client applications are 'wrappers' for SQL commands:

- `createdb` is a wrapper for the SQL command `CREATE DATABASE` 
  - these commands create a new PostgreSQL database

The client app we will use is `psql` - it's a Postgre interactive console  / terminal-based front-end app to PostgreSQL. It allows you to: 

- write queries in SQL syntax
- issue them to a PostgreSQL database
- see the results of the queries in the terminal
- `psql` is pretty much a REPL

### The psql console

by default type `psql` to go to your user created database (UNIX)

type `psql postgres` to go to the database called `postgres` and can issue commands to it.

There are 2 different types of commands issues from the psql console:

1. psql console meta commands
2. SQL statements using SQL syntax

#### meta commands

syntax begins with a `\` followed by the command and any optional arguments:

- eg. `\conninfo` details connection info to the current database

Meta commands are used for the following reasons:

- connecting to a different database
- listing tables
- describing the structure of a particular table
- setting environment tables 
- etc.

remember `\q` which quits `psql` and returns to command line

#### SQL statements

statements are commands issued to the database using SQL syntax. A simple statement might look something like this:

```sqlite
postgres=# SELECT name FROM people WHERE id = 1;
```

```sqlite
postgres=# SELECT name
FROM people
WHERE id = 1;
```

- statements always terminate with a `;` which allows you to write multiple lines
- PostgreSQL will not execute the statement until it reaches the `;`
- the above 2 statements are the same

**a `SELECT`** statement is used to retrieve data from a database. Regardless of how its written, The response in `psql` will return:

```sqlite
  name
---------
 Michael
(1 row)
```

### SQL Sub-languages

SQL can be broken down into 3 sub-languages that are concerned with different ways of interacting with a database:

1. **DDL Data Definition Language:** defines the structure of a database and its tables  and columns
2. **DML Data manipulation Language:** retrieves / modifies data stored in a database (`SELECT` queries are part of DML)
3. **DCL Data control Language:** determines the various users can / can't do when interacting with a database

DDL and DML are the focus of this book

### Summary

- learned the various ways to interact with PostgreSQL
  - using PostgreSQL Client Applications
  - using one of those client applications `psql` to
    - run `psql` console meta commands
    - issue SQL statements
- You can access a database via a programming language or a GUI application
- learned how to interact with Postgres via the command line





## 4. SQL Basics Tutorial

### Setup

to create a database do so from the terminal:

````
createdb ls_burger
````

create a `.sql` file related to this database. Then from the files folder issue the following psql command:

```
psql -d ls_burger < ls_burger.sql
```

this attaches your `.sql` file to the `ls_burger` database. This database now has a table called `orders` containing the data below:

![Orders Table](https://d186loudes4jlv.cloudfront.net/sql/images/basics_tutorial/tutorial-orders-table.png)

(The above won't show up on the screen from the CLI)

### connect

to connect to the database you just created type the following from the command line:

```
psql -d ls_burger
```

which will give you the following prompt:

```
ls_burger=#
```

The above indicates you are now in the psql console.

### select all

The `SELECT` keyword accesses data from a database:

```sqlite
ls_burger=# SELECT * FROM orders;
```

which returns the following:

 ```sql
 id |    customer_name   |          burger          |     side    |      drink
 ---+--------------------+--------------------------+-------------+-----------------
  1 | Todd Perez         | LS Burger                | Fries       | Lemonade
  2 | Florence Jordan    | LS Cheeseburger          | Fries       | Chocolate Shake
  3 | Robin Barnes       | LS Burger                | Onion Rings | Vanilla Shake
  4 | Joyce Silva        | LS Double Deluxe Burger  | Fries       | Chocolate Shake
  5 | Joyce Silva        | LS Chicken Burger        | Onion Rings | Cola
 (5 rows)
 ```

`SELECT * FROM orders;` means "retrieve all the columns from the orders table"

- `SELECT` - determines the type of statement issued and since it starts with `SELECT` we know that this keyword retrieves data.  
- `*` - the wild card character identifies all the columns in a given table
- `FROM` - a keyword that's used as a clause within `SELECT` to identify the table we retrieve the data from
- `orders` - the name of the table where we retrieved the data from

usually you won't want to select all columns from a database - only a *subset* of the data. This can be achieved by `SELECT`ing specific columns, or using criteria's to select specific rows.

### selecting columns

if you only wanted to select the `sides` use the `SELECT` query to return data in the `side` column like so:

```mysql
SELECT side FROM orders;
```

returns:

```mysql
     side
-------------
 Fries
 Fries
 Onion Rings
 Fries
 Onion Rings
(5 rows)
```

to select multiple columns use commas `,`:

```mysql
SELECT drink, side FROM orders;
```

returns:

```mysql
      drink      |    side
-----------------+-------------
 Lemonade        | Fries
 Chocolate Shake | Fries
 Vanilla Shake   | Onion Rings
 Chocolate Shake | Fries
 Cola            | Onion Rings
(5 rows)
```

the order of the selected columns matches the order it appears when returned

### Selecting rows

usually databases add a unique value that'll fall under the `id` column. This is to identify a particular row. This can be used to return data for a particular row

to return the data of a row where all the columns `id` is `1` :

 ```mysql
 SELECT * FROM orders WHERE id = 1;
 ```

returns:

```mysql
 id | customer_name |  burger   | side  |  drink
----+---------------+-----------+-------+----------
  1 | Todd Perez    | LS Burger | Fries | Lemonade
(1 row)
```

`WHERE id = 1` is a condition that checks each row in the table.

- if it evaluates to true the data in that row is returned by the `SELECT` query, 
- false, the data is not included as part of the data returned from the `SELECT` query
- `WHERE` tells the `SELECT` statement that only the rows that match the condition should be returned.
- `id = 1` that follows the `WHERE` keyword is the condition to be matched which must return `true` for the row to be returned
-  since there is only 1 row where `id = 1` only that one row of data is returned

`=` in SQL does not refer to assignment - its treated as an equality operator and compares things.

### selecting columns and rows

we can combine syntax that selects columns and rows to return very specific data sets. 

If we wanted to know all the name of the customers who ordered Fries:

```mysql
SELECT customer_name FROM orders WHERE side = 'Fries'
```

returns:

```mysql
  customer_name
-----------------
 Todd Perez
 Florence Jordan
 Joyce Silva
(3 rows)
```

which are the 3 customers who ordered `Fries`

note that we had to add single quotes to `'Fries'` because it is a string where as the id `1` is an integer

### Data vs Schema

PostgreSQL knows how to return the right information, and knows the difference between `customer_name` and `'Fries'` partly due to the syntax used to issue the statement. 

**Schema** is concerned with the *structure* of the database this includes:

- the names of tables and columns
- The data types of the columns
- any constraints

**Data** is concerned with the *contents* of the database this includes:

- the actual values associated with specific rows and columns in a database table

Schema and data work together to let us interact with a database in a structured, useful way. Without schema we would have the unstructured data mentioned before, and without data we would have an array of empty tables.

### Summary

- basic SQL statements using `SELECT` to retrieve data from a database
- simple `SELECT` query to return all data from a table
- narrowed down data from a table pertaining to specific columns and rows
- learned how data and schema work together to help the developer interact with databases
- we can create, read, update and delete both schema and data
- The syntax for modifying schema is different to the syntax modifying data
- DDL and DML allows us to create, read, update and delete schema and data respectively
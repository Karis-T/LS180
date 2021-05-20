## Summary

#### Getting started

- introduce SQL language and key concepts to get ready for the course: [Database Foundations](https://launchschool.com/courses/019cfcf3/home)
- learn conceptually why data is important
  - how to compare structured and unstructured data
  - how databases, RDBMSes and SQL fit into the picture
- SQL and RDBMS vocabulary introduced
- PostgreSQL installation instructions and how to interact with it
- the concept of *connecting* to a database
- a brief tutorial on what SQL does

#### Schema

- how to create a database and tables inside it
- `psql` console meta commands
- create or change a schema with `CREATE`, `ALTER`, `DROP` SQL statements
- various data types
- keys and constraints

#### Data

- Schema determines the data we can have in our databases
- exploring CRUD operations:
  - `INSERT`
    - adds rows of *data*
    - intersecting rows and cols determines the data structure
    - *constraints determine the data that can and can't be added* to a table
  - `SELECT`
    - `WHERE` clauses *filter* only the necessary data rather than all the rows of a table
    -  `ORDER BY` clauses determine how results are *sorted*
    - to return a particular subset of a table use `LIMIT` and `OFFSET`
    - *aggregate* data with `GROUP BY`
    - different kinds of *operators*:
      - string matching
      - logical
      - comparison
    - SQL functions 
      - string
      - date/time
      - aggregate functions using the `GROUP BY` clause
  - `UPDATE`
    - *changing specific data values in existing rows*
    - *target only specific rows that you want to update*
  - `DELETE`
    - *removing entire rows altogether*
    - *target only the specific rows that you want to delete*

- the above statement types are core to work with data in SQL

#### Multiple Tables

- *redundancy and data integrity* issues occur when our database tables become to large
- to addresses these issues we use *normalization*: which is arranging data in multiple tables and define relationships between them
- *Entity relationship diagrams (ERD's)* is a tool in database design that models relationships between entities
- *Primary and Foreign keys* are used to create references between rows in different tables
- the different types of relationships between tables:
  - 1 to 1
  - 1 to many
  - many to many
- use the `JOIN` statement to leverage table relationships and *query data across multiple tables*
  - `JOIN` merges data from table rows together usually using a foreign and primary key
  - by joining tables in this way it creates a *join table* that can be queried by other tables
    - eg. it can be filtered using a `WHERE` clause
  - different types of `JOIN` and how the results of a query differs depending on the type of join used
    - `INNER JOIN`
    - `LEFT JOIN`
    - `RIGHT JOIN`
    - `FULL JOIN`
    - `CROSS JOIN`

#### Summary

SQL is a non-object oriented declarative language that is essential and used in many web and non-web apps. It is used to store data.

#### Resources

- [PostgreSQL manual](https://www.postgresql.org/docs/current/index.html)

- Practice with [SQL Bolt](https://sqlbolt.com/),  [PostgreSQL exercises](https://pgexercises.com/) and [SQLFiddle](http://sqlfiddle.com/)


## What to focus on

- Learn the SQL / relational database features well in this lesson
- Spend time with the documentation: be expected to look through the PostgreSQL documentation to find a SQL function that performs that particular opertation
- Know the difference between Schema and Data

## Summary

**SQL** is a *special purpose, declarative language*

- we use SQL to manipulate the structure and values of datasets stored in relational databases

- SQL is made up of 3 sublanguages:
  - **DDL** (Data definition Language)
    - controls relation/table structure and rules
    - `CREATE` `DROP` `ALTER`
  - **DML** (Data manipulation Language)
    - controls values stored in relations/tables
    - `SELECT` `INSERT` `UPDATE` `DELETE`
  - **DCL** (Data Control Language)
    - controls permissions: who can do what
    - `GRANT`

- SQL is made up of statements that must be terminated by a semicolon

PostgreSQL's **datatypes**:

| Data Type                   | Type      | Value                             | Example Values          |
| :-------------------------- | :-------- | :-------------------------------- | :---------------------- |
| `varchar(length)`           | character | up to `length` characters of text | `canoe`                 |
| `text`                      | character | unlimited length of text          | `a long string of text` |
| `integer`                   | numeric   | whole numbers                     | `42`, `-1423290`        |
| `real`                      | numeric   | floating-point numbers            | `24.563`, `-14924.3515` |
| `decimal(precision, scale)` | numeric   | arbitrary precision numbers       | `123.45`, `-567.89`     |
| `timestamp`                 | date/time | date and time                     | `1999-01-08 04:05:06`   |
| `date`                      | date/time | only a date                       | `1999-01-08`            |
| `boolean`                   | boolean   | true or false                     | `true`, `false`         |

**`NULL`** is a special value that represents the absence of any other value

- we can only compare `NULL` by using `IS NULL` or `IS NOT NULL`

**Database dumps** can be loaded using `psql -d database_name < file_to_import.sql`

**Table columns** can have default values, specified using `SET DEFAULT`

- Table columns can be prevented from storing `NULL` values using `SET NOT NULL`

**`CHECK`** **constraints** are rules that must be met by the table's data

**Keys:**

- **A natural key** is an existing value in a dataset that's used to uniquely identify each row of data in that dataset

- **A surrogate key** is a value thats created for the purposes of identifying a row of data in a database table
- **A primary key** is a value used to uniquely identify the *rows* in a table. The key:
  - cannot be `NULL`
  - must be unique in a table
  - created using `PRIMARY KEY`
- `serial` columns create auto-incrementing columns in PostgreSQL
- `AS` is used to rename tables and columns in a SQL statement


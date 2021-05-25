## The SQL Language

*SQL* manipulates the structure and values of datasets, which are stored in a relational database 

- SQL is considered to be a *special purpose language* 
  - its only purpose is to interact with relational databases
- general programming languages like Ruby / Javascipt are used for a variety of purposes
  - app creation
  - scripting
  - embedding in other languages
  - runtimes
- SQL is mostly a *declaritive language*
  - It describes *what* must be done but it doesn't detail *how* its objective is accomplished
  - this means that based on a variety of condiitions, a query may execute different;y on an identitcal dataset. 
  - SQL server abstracts these details away from the user
  - when a queries performance doesn't meet an apps requirements there are ways we can view how the query will be executed
- SQL database engine will select the most efficient way to execute a query however its performance can dramatically improve with a few hint from a user.

SQL is made up of 3 sub-languages:

| sub-language                          | controls                       | SQL Constructs                         |
| :------------------------------------ | :----------------------------- | :------------------------------------- |
| **DDL** or data definition language   | relation structure and rules   | `CREATE`, `DROP`, `ALTER`              |
| **DML** or data manipulation language | values stored within relations | `SELECT`, `INSERT`, `UPDATE`, `DELETE` |
| **DCL** or data control language      | who can do what                | `GRANT`, `REVOKE`                      |

### DDL Data Definition Language

- allows a user to create, modify and delete databases and tables
- describes how data is structured
- `CREATE` `ALTER` `ADD COLUMN` `DROP` are among a few statements designed to modify a databases data structure or rules 

### DML Data Manipulation Language

- allows a user to create, read, update and delete a databases data
- Some databases see retreval and manipulation as 2 sepatate languages but PostgreSQL docs combines them
- `SELECT` `INSERT` `UPDATE` `DELETE`

### DCL Data Control Language

- controls the rights of a user interacting with a database or table
- most developers have full rights to the database, schema and data
- sometimes you'll be granted a read-only access and can only use `SELECT` statements
- SQL controls access to a database
- responsible for defining rights and roles granted to individual users
- `GRANT` `REVOKE` 

### Syntax

SQL code is made up of statements terminated by a semi colon:

To evaluate an arbitrary expression or use operators / functions use `SELECT` :

 ```sqlite
 sql-course=# SELECT 1;
  ?column?
 ----------
         1
 (1 row)
 
 sql-course=# SELECT 'abc';
  ?column?
 ----------
  abc
 (1 row)
 
 sql-course=# SELECT 1 + 1;
  ?column?
 ----------
         2
 (1 row)
 
 sql-course=# SELECT (1 + 4) * 6;
  ?column?
 ----------
        30
 (1 row)
 
 sql-course=# SELECT round(1.5678);
  round
 -------
      2
 (1 row)
 ```



## SQL Style Guide

the [style guide](https://www.sqlstyle.guide/) is an excellent example of how to write SQL code but the rules aren't ironclad. eg. not to use `id` as a column name

Try to:

- Use consistent and descriptive identifiers and names.
- Make judicious use of white space and indentation to make code easier to read.
- Store [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) compliant time and date information (`YYYY-MM-DD HH:MM:SS.SSSSS`).
- Try to only use standard SQL functions instead of vendor-specific functions for reasons of portability.
- Keep code succinct and devoid of redundant SQL—such as unnecessary quoting or parentheses or `WHERE` clauses that can otherwise be derived.
- Include comments in SQL code where necessary. Use the C style opening `/*` and closing `*/` where possible otherwise precede comments with `--` and finish them with a new line.

Avoid:

- CamelCase—it is difficult to scan quickly.
- Descriptive prefixes or Hungarian notation such as `sp_` or `tbl`.
- Plurals—use the more natural collective term where possible instead. For example `staff` instead of `employees` or `people` instead of `individuals`.
- Quoted identifiers—if you must use them then stick to SQL-92 double quotes for portability (you may need to configure your SQL server to support this depending on vendor).
- Object-oriented design principles should not be applied to SQL or database structures.

In General:

- Ensure the name is unique and does not exist as a [reserved keyword](https://www.sqlstyle.guide/#reserved-keyword-reference).
- Keep the length to a maximum of 30 bytes—in practice this is 30 characters unless you are using a multi-byte character set.
- Names must begin with a letter and may not end with an underscore.
- Only use letters, numbers and underscores in names.
- Avoid the use of multiple consecutive underscores—these can be hard to read.
- Use underscores where you would naturally include a space in the name (first name becomes `first_name`).
- Avoid abbreviations and if you have to use them make sure they are commonly understood.

Aliasing:

- Should relate in some way to the object or expression they are aliasing.
- As a rule of thumb the correlation name should be the first letter of each word in the object’s name.
- If there is already a correlation with the same name then append a number.
- Always include the `AS` keyword—makes it easier to read as it is explicit.
- For computed data (`SUM()` or `AVG()`) use the name you would give it were it a column defined in the schema.

Reserved words:

- while its fine to use `"year"` without quotes in PostgreSQL it can cause issues in other RDMBSs when `year` is a reserved word
- Always use uppercase for the [reserved keywords](https://www.sqlstyle.guide/#reserved-keyword-reference) like `SELECT` and `WHERE`.
- It is best to avoid the abbreviated keywords and use the full length ones where available (prefer `ABSOLUTE` to `ABS`).
- Do not use database server specific keywords where an ANSI SQL keyword already exists performing the same function. This helps to make the code more portable.

## 1. Create Multiple Tables

Majority of the time you'll be working with databases that have more than 1 table. The tables will be connected together in various ways to form relationships

### Normalization

![Unnormalized Users Table](https://d186loudes4jlv.cloudfront.net/sql/images/table_relationships/unnormalized-users.png)

The above table is an example of a virtual library with data reflecting each:

- user
- if they're enabled in the system
- login time
- title of book
- author
- published data
- checkout date
- return date

While it technically works, there is a lot of information on one table! There would also be a lot of duplication of data if the same people wanted to borrow other books, or the same book is borrowed again and again

Data duplication can also lead to data integrity issues. eg. entering: 

- "My Second SQL book" 
- "My 2nd SQL book"

We wouldn't know which one is correct

The way to handle this situation is to split up data across multiple tables and establish relationships between them. **normalization** is the process of splitting up data to remove duplication and improve data integrity.

Normalization is a deep topic with a complex set of rules that determine if a database should be normalized. These rule-sets are called ''normal-forms" and there are 2 things to remember:

1. The reason we normalize is to **reduce redundancy and improve data integrity**
2. the way we normalize is to arrange data in multiple tables and define relationships between them

In order to split up our data into tables and define relationships between those tables its useful to think on a higher level of abstraction and understand the process of database design

### Database Design

Database design involves:

- defining **entities** to represent different sorts of data
- designing **relationships** between those entities

#### Entities

An entity could be defined as:

- a real world object 
- a set of data that we want to model in our database

entities are usually *major nouns* of the system we're modelling. In a real world scenario databases for a single entity could be stored in more than 1 table

Entities to define in our virtual library:

- the user in our `users` table could be an entity in our app; that is a **user** is someone that uses the app
- The book app allows users to borrow books about SQL, **books** could also be an entity
- A user can checkout books so another entity could be **checkout**
- A user can leave review of the book they've read so another entity could be **reviews**
- We also need to store the users **address** data. While this is technically apart of the user this information is only accessed occasionally and not for every interaction. We can store this in a separate table'

![SQL Book Library Tables Diagram](https://d186loudes4jlv.cloudfront.net/sql/images/table_relationships/table-relationships.png)

#### Relationships

While we have modelled the entities that our tables need its still lacking the relationships that exist between them. That is its not obvious how these tables relate to each other

![Simple ERD Diagram](https://d186loudes4jlv.cloudfront.net/sql/images/table_relationships/simple-erd-fixed.png)

The diagram above represents an ERD (Entity relationship Diagram) which is a diagram that models relationships between entities. ERD's are common tools in database design and come in many forms both simple and complex

### Keys

We implement the above relationships using keys. Keys are a special type of constraint used to: 

- establish relationships
- create uniqueness
- *identify a specific row in the current table*
- *refer to specific row in another table*

There are 2 keys that fulfill the above points: Primary and Foreign keys:

#### Primary Keys

To forge a relationship between to entities we must first be able to identify the *data* correctly

- *Primary keys are a unique identifier for a row of data*

To act as a unique identifier a column must contain:

- some data
- the data must be unique to each row (sort of like ids)
- making a column a `PRIMARY KEY` is similar to adding `NOT NULL` and `UNIQUE` constraints to that column

Since the `id` column fits the above description, we can add it as a primary key:

```sqlite
ALTER TABLE users ADD PRIMARY KEY (id);
```

- Each table can only have **1 Primary Key**
- Common practice for a Primary key to be a column named `id`

#### Foreign Keys

- allows us to associate a single row in 1 table to a single row in another table, creating a connection between rows in different tables
- to do this we set a single column in a table as a `FOREIGN KEY` and that column reference another tables `PRIMARY KEY`
- to create this relationship we use the `REFERENCES` keyword:

```sqlite
FOREIGN KEY (fkey_column_name) REFERENCES target_table_name (pkey_column_name)
```

![Shapes and Colors, separate tables](https://d186loudes4jlv.cloudfront.net/sql/images/table_relationships/joins-explanation-separate-tables.png)

The above shows 2 tables `colors` and `shapes`. `shapes` `color_id` column is a Foreign Key that references the data of the column `id` in the `colors` table. It results in the following associations:

- Red square
- Red star
- Blue Triangle
- Green Circle

By setting up the above reference we ensure the *referential integrity* of a relationship

- **Referential integrity** is to ensure that a column's value MUST exist in order to be referenced elsewhere. 
- If it doesn't exist then an error is thrown. 
- PostgreSQL won't allow you to add a value to a foreign key column unless it exists in the Primary key column first 

the type of relationship we want to establish determines how we use the Foreign keys in our schema. We must therefore describe the relationship we want to model between our entities:

1. A user can have ONE address. An address can have ONE user
2. A review is written only for ONE book. A book has MANY reviews
3. A user can have MANY books that they've checked out. A book can be checked out by MANY users

The entities above can be broken into 3 types:

- one to one
- one to many
- many to many

### one-to-one

an entity instance exists on 1 table and is associated to only 1 entity instance in another table:

- eg. A user can have ONE address. An address can have ONE user
- the `id` is the `users` table's `PRIMARY KEY`, and it is used as both a `FOREIGN KEY` and `PRIMARY KEY` of the `addresses` table.

```sqlite
-- 1 to 1: User has 1 address

CREATE TABLE addresses (
  user_id int, -- Both a primary and foreign key
  street varchar(30) NOT NULL,
  city varchar(30) NOT NULL,
  state varchar(30) NOT NULL,
  PRIMARY KEY (user_id),
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);
```

- the above creates an `addresses` table and establishes a relationship between itself and the `users` table
- both keys at the end of the statement create a constraint: 
  - the `user_id` becomes the primary key of this table
  - the `user_id` is also the foreign key of the `users` table
- the `ON DELETE` clause set to `CASCADE` means that if a referenced row is deleted the row referencing that row is also deleted. The alternatives to `CASCADE` are:
  - `SET NULL` or `SET DEFAULT` which instead of deleting the referencing row it'll set a new value in the column for that row
  - If you don't set an `ON DELETE` clause an error will be thrown
  - deleting rows referenced by another row is an important design decision and is part of referential integrity

![one-to-one schema](https://d186loudes4jlv.cloudfront.net/sql/images/table_relationships/one-to-one.png)

- The `user_id` column uses values from the `id` column to connect the tables together using the newly created foreign keys.

### Referential Integrity

states that table relationships must always be consistent. RMDBSes might enforce referential integrity rules different but the concept is the same.

The above establishes a one to one relationship between itself and the `addresses` table. This constraint is enforced whereby any new user may only have one address and any new address many only have one user. This is an example of referential integrity. If you try to give a user a second address the following happens:

```sql
ERROR:  duplicate key value violates unique constraint "addresses_pkey"
DETAIL:  Key (user_id)=(1) already exists.
```

- the error occurs because `user_id` with a value of `1` already exists

If you try to add an address for an `id` that doesn't yet exist the following happens:

```sqlite
ERROR:  insert or update on table "addresses" violates foreign key constraint "addresses_user_id_fkey"
DETAIL:  Key (user_id)=(7) is not present in table "users".
```

the reason we can't add an address without a user is due to the *modality* of the relationship between 2 entities. This is another aspect of entity relationships.

### One to many

This is an entity instance in one table is associated with multiple records (entity instances) in another table. The opposite relationship doesn't exist in that each entity instance in the other table can only be associated with ONE entity instance in the first table.

eg. A review belongs to only 1 book . A book has many reviews

```sql
CREATE TABLE books (
  id serial,
  title varchar(100) NOT NULL,
  author varchar(100) NOT NULL,
  published_date timestamp NOT NULL,
  isbn char(12),
  PRIMARY KEY (id),
  UNIQUE (isbn)
);

/*
 one-to-many: Book has many reviews
*/

CREATE TABLE reviews (
  id serial,
  book_id integer NOT NULL,
  reviewer_name varchar(255),
  content varchar(255),
  rating integer,
  published_date timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);
```

- While its similar to the previous 1 to 1 setup there is a key difference:

  - unlike the `addresses` table, the `PRIMARY KEY` and `FOREIGN KEY` reference different columns- `id` and `book_id` respectivley
  - this means that our `FOREIGN KEY` column - `book_id` - is not bound by the `UNIQUE` constraint of our `PRIMARY KEY`, meaning the same value from the `id` column can appear in the `book_id` column multiple times.
  - This means a book can now have many reviews
  - The order we `INSERT` the data is important - we need `id` table `books` to exist before we can reference the `id` numbers in our `reviews` table. 
  - the `FOREIGN KEY` column data creates relationships between the `reviews` and `books` table.

  ![one-to-many schema](https://d186loudes4jlv.cloudfront.net/sql/images/table_relationships/one-to-many.png)

### Many to Many

this relationship exists between 2 entities - for 1 entity instance there could be multiple records of it in another table, and vice versa.

eg.  a user can check out many books. A single book can be checked out by many users

To implement this relationship a 3rd cross reference table must be introduced. This table holds the relationship between 2 entities, by having 2 `FOREIGN KEYS`. Each `FOREIGN KEY` references the `PRIMARY KEY` of the table that they want a many to many relationship with.

- in this example we have a `users` table and a `books` table we need a 3rd cross reference table: `checkouts`

![many-to-many cross-reference table](https://d186loudes4jlv.cloudfront.net/sql/images/table_relationships/checkouts-table-references.png)

- the `user_id` column in `checkouts` references the `id` column in `users`
- the `book_id` column references the `id` column in `books`
- each row of the `checkouts` table users these 2 foreign keys to create an association between rows of `users` and `books`

```sql
CREATE TABLE checkouts (
  id serial,
  user_id int NOT NULL,
  book_id int NOT NULL,
  checkout_date timestamp,
  return_date timestamp,
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);
```

- the `checkouts` table includes additional columns `checkout_date` and `return date`
- These columns represent the *association* between a user and a book and don't necessarily establish the relationship between `users` and `books`
- This info can be useful to the business logic of an app. Eg. to prevent more than 1 users trying to checkout the same book at the same time, the app could determine which book is currently checked out by querying those that have a value in the `checkout_date` `AND` the `return date` set to `NULL`

![many-to-many schema](https://d186loudes4jlv.cloudfront.net/sql/images/table_relationships/many-to-many.png)

- the many to many relationship can be thought as combining 2 one to many relationships

### Summary

- normalization: reduces redundancy and improves data integrity in a database
- ERDs model relationships between different entities
- how Primary and Foreign keys build relationships between tables
- different types of relationships that exist between tables
  - how to implement these relationships using SQL

**A list of common relationships when working with SQL:**

| Relationship |                           Example                           |
| :----------- | :---------------------------------------------------------: |
| one-to-one   |               **A** User has **ONE** address                |
| one-to-many  |               **A** Book has **MANY** reviews               |
| many-to-many | **A** user has **MANY** books and a book has **MANY** users |





## 2. SQL Joins

now that our data is split across several tables we have to `JOIN` it up before we can `SELECT` related data again.

SQL  handles quries across multiple table using `JOIN`s. `JOIN`s are clauses which link 2 tables together based on the keys that first defined the relationship between the 2 tables. 

There are several types of `JOIN`s:

- `INNER`
- `LEFT OUTER`
- `RIGHT OUTER`
- `FULL OUTER`
- `CROSS`

### Join Syntax

standard syntax of a `JOIN` statement:

```sqlite
SELECT [table_name.column_name1, table_name.column_name2, ...] FROM
table_name1 join_type JOIN table_name2 ON (join_condition);
```

- line 1: is the same as `SELECT columns FROM` in previous `SELECT` queries
  - the difference is the columns are prepended with its table name
- line 2: to join 1 table to another PostgreSQL needs to know several pieces of info:
  1. The name of the 1st table
  2. the type of join to use
  3. the name of the 2nd table
  4. the join condition
     - follows the `ON` keyword
     - defines the logic with how the row in table 1 is joined to the row in table 2
     - usually created with the `PRIMARY KEY` from table 1 and the `FOREIGN KEY` from table 2

![Shapes and Colors, separate tables](https://d186loudes4jlv.cloudfront.net/sql/images/table_relationships/joins-explanation-separate-tables.png)

```sqlite
SELECT colors.color, shapes.shape FROM
colors JOIN shapes ON colors.id = shapes.color_id;
```

- line 2: the join condition will look at each `id` value and attempt to match it with the `color_id` value
  - If there is a match then the 2 rows are joined together to form a new row in a virtual *join table*
  - since orange isn't used in the `shapes` table, its omitted in the virtual join table

![Shapes and Colors, virtual join table](https://d186loudes4jlv.cloudfront.net/sql/images/joins/joins-explanation-virtual-join-table.png)

- line 1: `SELECT column_list FROM` then selects its columns from this virtual join table shown above
  - These columns could come from the first or second table
  - to avoid confusion the table and column name needs to be declared in the column list (`table1.column1`)
  - select columns from our virtual join table will look like this:

```sqlite
SELECT colors.color, shapes.shape FROM shapes_colors_join_table;
```

![Shapes and Colors, resulting data](https://d186loudes4jlv.cloudfront.net/sql/images/joins/joins-explanation-query-result.png)

### Types of Joins

- add the join type just before the `JOIN` keyword

#### INNER JOIN 

returns a result set that contains the common elements of the tables 

- the intersection where they match on the join condition
- The most frequently used JOIN
- It's PostgreSQL's default option if you don't specify a join type

![Users and Addresses](https://d186loudes4jlv.cloudfront.net/sql/images/joins/users-and-addresses.png)

```sqlite
SELECT users.*, addresses.* FROM users
INNER JOIN addresses ON (users.id = addresses.user_id);
```

- Line 2: creates the intersection between the 2 tables
  - this means that the joined table only has rows that evaluated to true (`5` is omitted as it has no `user_id`)
- Line 1: selects everything from the `users` table and everything from the `addresses` table to include in the final join table

![Inner Join](https://d186loudes4jlv.cloudfront.net/sql/images/joins/inner-join.png)

- if you wanted to include `Jane Smith` in the results despite not having met the condition we'd need to use an `OUTER JOIN` 

#### LEFT JOIN

- takes **all** the rows from table 1 (defined as the `LEFT` table) and joins it with table 2 
- `JOIN` is based on the conditions supplied in the parentheses
- `LEFT JOIN` always includes **all** the rows from the `LEFT` table even if there's no matching rows

```sqlite
SELECT users.*, addresses.*
FROM users
LEFT JOIN addresses
ON (users.id = addresses.user_id);
```

![Left Join](https://d186loudes4jlv.cloudfront.net/sql/images/joins/left-join.png)

- In this table `Jane Smith` is included despite the condition
- Because she doesn't have any matching rows in the `addresses` table all the values in that table are `NULL`
- `LEFT JOIN` and `LEFT OUTER JOIN` is the same thing (OUTER is often omitted)
- this is still referred to as an OUTER join to differentiate it from an INNER join

#### RIGHT JOIN

- takes **all** the rows from table 2 are included along with any matching rows from table 1

![Reviews and Books](https://d186loudes4jlv.cloudfront.net/sql/images/joins/reviews-and-books.png)

```sqlite
SELECT reviews.book_id, reviews.content,
       reviews.rating, reviews.published_date,
       books.id, books.title, books.author
FROM reviews RIGHT JOIN books ON (reviews.book_id = books.id);
```

![Right Join](https://d186loudes4jlv.cloudfront.net/sql/images/joins/right-join.png)

- the above example displays all reviews and their associated books but it also includes any books that don't have a review
- Because the last book doesn't have a review all its values are `NULL`
- `RIGHT JOIN` is also known as `RIGHT OUTER JOIN` 

#### FULL JOIN

- a combination of the `LEFT JOIN` and `RIGHT JOIN` 
- This join contains all the rows from both tables
- Where the join condition evaluates to true, the tables contain the data
- for any row either side where the condition evaluates to false, they're included in the selection anyways, but all its values from the other table are `NULL` 

#### CROSS JOIN

- an uncommon type of join also known as a Cartesian JOIN
- returns all rows from 1st table crossed with every row from the 2nd table
- contains every possible combination of rows from the joined tables
- returns all combinations so therefore doesn't use a join condition nor an `ON` clause

```sqlite
sql_book=# SELECT * FROM users CROSS JOIN addresses;
```

![CROSS Join](https://d186loudes4jlv.cloudfront.net/sql/images/joins/cross-join.png)

- in application its very unlikely `CROSS JOIN` will be used
- most of the time you select rows to return a meaningful result
- be aware of `CROSS JOINS` as you may occasionally encounter them

### Multiple Joins

- you can join more than 2 tables together
- to do so add additional `JOIN` clauses to the `SELECT` statement
- To join multiple tables there must be a **logical relationship** between the tables involved

to join the `users` `checkouts` and `books` tables:

```sqlite
SELECT users.full_name, books.title, checkouts.checkout_date FROM users
INNER JOIN checkouts ON (users.id = checkouts.user_id)
INNER JOIN books ON (books.id = checkouts.book_id);
```

- 2  `INNER JOIN`s:
  - 1 between `users` and `checkouts`
  - the other between `books` and `checkouts`
- `JOIN` is implemented using the Primary key of 1 table and the foreign key of the `checkouts` table 

### Aliasing

- we can cut back the length of queries using aliasing. 
- Aliasing allows us to specify another name for a column / table 
- use this name in later parts of the query for more concise syntax

```sqlite
SELECT u.full_name, b.title, c.checkout_date
FROM users AS u
INNER JOIN checkouts AS c ON (u.id = c.user_id)
INNER JOIN books AS b ON (b.id = c.book_id);
```

- single letter aliases for our tables and prepend the column names to them - known as 'table aliasing'
- optional you can remove the `AS` keyword
  - `FROM users u` is the same as `FROM users AS u`

#### column aliasing

- aliasing allows us to display more meaningful information in our result table too

If we want to display the number of checkouts from the library:

```sqlite
SELECT count(id) AS "Number of Books Checked Out" FROM checkouts;
Number of Books Checked Out
-----------------------------
                          4
(1 row)
```

as opposed to:

```sqlite
SELECT count(id) FROM checkouts;
 count
-------
     4
(1 row)
```

### Subqueries

while joining is the most common way of working with multiple tables, you can achieve the same results through subqueries.

- the idea is similar to method chaining where the return value is used to invoke another method
- In this case the return table from the 1st `SELECT` query is used as the condition in another `SELECT` query
- This is known as nesting / subqueries

![Checkouts table](https://d186loudes4jlv.cloudfront.net/sql/images/joins/checkouts.png)

```sqlite
SELECT u.full_name FROM users u
WHERE u.id NOT IN (SELECT c.user_id FROM checkouts c);

  full_name
-------------
 Harry Potter
(1 row)
```

- the example above shows the user who never checked out a book
- to do this we find the `users.id` that's not in the `checkouts.user_id` column

- the `NOT IN` clause compares the current `id` to all rows in the return value table (`SELECT u.full_name FROM users u`)
  - If that `id` isn't part of the return value, the `full_name` for that current row is added to the result

![Nested Query Results](https://d186loudes4jlv.cloudfront.net/sql/images/joins/nested-query.png)

- above shows the return value of `SELECT u.full_name FROM users u`
- it is a virtual table used in the `NOT IN` clause which we check for our value 

![NOT IN example](https://d186loudes4jlv.cloudfront.net/sql/images/joins/not-in-subquery.png)

- we can compare this virtual table to the `id` column of the `users` table
- The only one not found in the return value is `id = 3` which is why `Harry Potter` is returned

#### Subquery expressions

The following expressions can be used with sub queries:

- `IN`
- `NOT IN`
- `ANY`
- `SOME`
- `ALL`

#### Subqueries vs Joins

Subqueries can be used as an alternative to joins as there is more than 1 way to write a query to achieve the same result. This is usually the case with JOINs and subqueries:

```sqlite
SELECT u.full_name FROM users AS u
LEFT JOIN checkouts AS c ON (u.id = c.user_id)
WHERE c.user_id IS NULL;

  full_name
--------------
 Harry Potter
(1 row)
```

- as a general rule, JOINs are faster to run than subqueries and need to be considered when working with large datasets

### Summary

- how joins work at a conceptual level
- different types of joins
- aliasing and subqueries

- how joins work:
  - set a condition that compares a value from the 1st table (primary key)
  - with a value from a 2nd table (foreign key)
  - if the condition evaluates to true then the row with the 1st value is joined to the row with the  2nd value
- sometimes the queries can get unwieldy when working with 2 or more `JOIN`s
- To better manage this we can **alias** table and column names to shorten the query
  - alias gives context about query results
- the result of a join query can be obtained using different methods
- **Subqueries** is another method to query the database and retrieve the same results of similar results - like using a `JOIN` clause

| Join Type | Notes                                                        |
| :-------- | :----------------------------------------------------------- |
| INNER     | Combines rows from two tables whenever the join condition is met. |
| LEFT      | Same as an inner join, except rows from the first table are added to the join table, regardless of the evaluation of the join condition. |
| RIGHT     | Same as an inner join, except rows from the second table are added to the join table, regardless of the evaluation of the join condition. |
| FULL      | A combination of left join and right join.                   |
| CROSS     | Doesn't use a join condition. The join table is the result of matching every row from the first table with the second table, the cross product of all rows across both tables. |


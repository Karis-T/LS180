### SQL

1. What are the different types of joins?

   - INNER JOIN

   >`INNER JOIN`s instruct a database to locate matching rows from both tables based on the specified join condition. This results in an intersection of common elements from both tables. 
   >
   >
   >```sqlite
   >SELECT users.*, addresses.* FROM users
   >INNER JOIN addresses ON (users.id = addresses.user_id);
   >```
   >
   >Line 2 creates an intersection between both tables and creates a virtual join table that only has rows that evaluated to `true` based on the join condition
   >
   >Line 1 selects all the users and addresses columns from the join table to include in the final result

   - LEFT OUTER JOIN

   >`LEFT OUTER JOIN` always joins all the rows from the first table (table to the LEFT of the `JOIN` clause) to a second table. Only matching values will be obtained from the second table.
   >
   >```sql
   >SELECT users.*, addresses.*
   >FROM users
   >LEFT OUTER JOIN addresses
   >ON (users.id = addresses.user_id);
   >```
   >
   >An `INNER JOIN` will be performed first followed by a `LEFT OUTER JOIN` which will match all the rows in the left table that doesn't satisfy the join condition. This results in a join table that may contain `NULL` values where the match from the second table didn't take place.

   - RIGHT OUTER JOIN

   >`RIGHT OUTER JOIN` is similar to a left join except it joins all the rows from the second table (table to the RIGHT of the `JOIN` clause) to the first table. Only matching values will be obtained from the first table.
   >
   >```sql
   >SELECT * FROM comments 
   >RIGHT OUTER JOIN users ON comments.user_id = users.id;
   >```
   >
   >An `INNER JOIN` will be performed first followed by a `RIGHT OUTER JOIN` which will match all the rows in the right table that doesn't satisfy the join condition. This results in a join table that may contain `NULL` values where the match from the first table didn't take place.

   - FULL OUTER JOIN

   >`FULL OUTER JOIN` Combines the capabilities of `LEFT` and `RIGHT` outer joins, and containins all the rows from both tables.  As before an `INNER JOIN` is performed first and rows are matched based on the join condition. Where the condition is not met rows from each respective table when joined will contain `NULL` values where the match didn't take place. 
   >
   >```sql
   >SELECT c.* FROM customers c
   >FULL OUTER JOIN customers_services cs ON cs.customer_id = c.id
   >WHERE cs.customer_id IS NULL;
   >```
   >
   >first an `INNER JOIN` is performed, follows by a `LEFT OUTER JOIN` then a `RIGHT OUTER JOIN`. In the example `customers` table joined to the `customer_services` table used a `FULL OUTER JOIN`. This is reflected in the returned join table where all rows from both tables are retrieved and displayed even if they didn't meet the join condition. Where they didn't meet the join condition `NULL` values are placed in the corresponding columns of the other table. 

   - CROSS JOIN

   >```sql
   >SELECT * FROM comments CROSS JOIN users;
   >```
   >
   >also known as a Cartesian JOIN returns all rows from 1st table crossed with every row from the 2nd table contains every possible combination of rows from the joined tables returns all combinations so therefore doesn't use a join condition nor an `ON` clause.

2. What are the 3 sublanguages? 

   - **Data Definition Language DDL** definition and classify different statements by sublanguage:

   >DDL is a language that creates, modifies and deletes the **schema** of a database. It governs a relations (tables) structure and the rules that manage data in a database.
   >
   >```sqlite
   >CREATE TABLE things (id serial PRIMARY KEY);
   >ALTER TABLE things
   >DROP CONSTRAINT things_item_key;
   >```
   >
   >Since it doesn't operates on any data but rather the structure - that is, how we define the data - its considered to be a DDL sublanguage.

   - **Data Manipulation Language DML** definition and classify different statements by sublanguage:

   >DML is a language that creates, reads, updates and deletes the **data** stored inside a database. It governs the values stored in a relation rather than the relation itself. 
   >
   >```sqlite
   >INSERT INTO things VALUES (3, 'scrissors', 'metal');
   >SELECT column_name FROM my_table;
   >UPDATE things SET material = 'plastic';
   >DELETE FROM things WHERE item = 'Cup';
   >```
   >
   >Since the above operates on the data (as opposed to the structure of the data) its part of the DML sublanguage.

   - **Data Control Language DCL** definition:

   >DCL is a language that handles the rights or access that a user is permitted to have when interacting with a database. It governs which user can do what in a database.
   >
   >```sqlite
   >GRANT REVOKE
   >```

3. Write a SQL statement using:

   - INSERT (1 or more rows)

   ```sqlite
   INSERT INTO (col1, col2, ...)
        VALUES (val1, val2, ...),
               (val1, val2, ...),
               (val1, val2, ...);
   ```

   - UPDATE (1 or more fields in 1 or more columns)

   ```sqlite
   UPDATE table_name SET col1 = true
   WHERE col2 > 0;
   ```

   - DELETE (1 or more rows)

   ```sqlite
   DELETE FROM table_name WHERE col2 IS NULL;
   ```

   - CREATE TABLE

   ```sqlite
   CREATE TABLE table_name (
     col1 datatype constraints, 
     col2 datatype constraints, 
     ...);
   ```

   - ALTER TABLE

   ```sqlite
   ALTER TABLE table_name RENAME TO new_table_name;
   ```

   - DROP TABLE

   ```sqlite
   DROP TABLE table_name;
   ```

   - ADD COLUMN

   ```sqlite
   ALTER TABLE table_name
   	ADD COLUMN col_name datatype constraints;
   ```

   - ALTER COLUMN

   ```sqlite
   ALTER TABLE table_name
   	ALTER COLUMN col_name SET NULL;
   ```

   - DROP COLUMN

   ```sqlite
   ALTER TABLE table_name 
   	DROP COLUMN column_name;
   ```

   

4. How do the following clauses work in a SELECT query?

   - 1.virtual derived table

   >database creating a new temporary table using the data from all the tables listed in the query's `FROM` clause. This includes tables that are used in `JOIN` clauses.

   - 3.GROUP BY

   >If the query includes a `GROUP BY` clause, the remaining rows are divided into the appropriate groups.

   ```sqlite
   SELECT col1, agg(col2) FROM table_name
   	GROUP BY col1;
   ```

   - 6.ORDER BY

   >The result set is sorted as specified in an `ORDER BY` clause. Without this clause, the results are returned in an order that is the result of how the database executed the query and the rows' order in the original tables.

   ```sqlite
   SELECT col1, col2 FROM table_name
   	ORDER BY col2 DESC;
   ```

   - 2.WHERE

   >All the conditions in the `WHERE` clause are evaluated for each row, and those that don't meet these requirements are removed.

   ```sqlite
   SELECT col1, col2 FROM table_name
   	WHERE col1 IS NOT NULL;
   ```

   - 4.HAVING

   >Both `GROUP BY` and aggregate functions perform grouping, and the `HAVING` clause is used to filter that aggregated/grouped data.

   ```sqlite
   SELECT col1, agg(col2) FROM table_name
   	GROUP BY col1 HAVING col1 >= 'M'; 
   ```

   - 5.compute values

   >Each element in the select list is evaluated, including any functions

   - 6.LIMIT and OFFSET

   >these are used to adjust which rows in the result set are returned.

5. How do you modify a constraint?

   - create a constraint

   ```sql
   -- postgreSQL gives us a name
   CREATE TABLE table_name (
     col_name datatype UNIQUE
   );
   
   -- We define a name for the CHECK
   CREATE TABLE table_name (
     col_name datatype CONSTRAINT constraint_name UNIQUE
   );
   ```

   - make sure there are no pre-existing values that violate this check constraint! delete them first then add in the check:

   ```sql
   -- postgreSQL gives us a name
   ALTER TABLE table_name ADD CHECK (condition);
   
   -- We define a name for the CHECK
   ALTER TABLE table_name
   	ADD CONSTRAINT constraint_name CHECK (condition);
   ```

   ```sql
   ALTER TABLE table_name ALTER COLUMN column_name SET NOT NULL;
   ALTER TABLE table_name ALTER COLUMN column_name SET DEFAULT 0;
   ```

   - remove a constraint (check the \d schema for its name)

   ```sql
   ALTER TABLE table_name DROP CONSTRAINT constraint_name;
   ```

   ```sql
   ALTER TABLE table_name ALTER COLUMN col_name DROP NOT NULL;
   ALTER TABLE table_name ALTER COLUMN col_name DROP DEFAULT;
   ```

   - how are CHECK constraints different?

   >CHECK constraints require a condition alongside it set in parentheses. It doesn't fall under indexing and can be created in a table or column

6. How do you use subqueries?

```sqlite
-- IN clause - multiple return values
SELECT col1, col2 FROM table_name WHERE col1 IN 
	(SELECT col3 FROM another_table);

-- using = to return 1 answer
SELECT col1 from table_1 WHERE col2 =
	(SELECT col3 FROM table_2 WHERE condition );

-- EXISTS if 1+ rows are returned by the subquery it evaluates to 'true' otherwise false
SELECT 1 WHERE EXISTS (SELECT id FROM books WHERE isbn = '9780316005388');

-- NOT IN

-- SOME / ANY

-- ALL
```

>Subqueries use a nested query to generate a set of one or more values. These values are then used part of an outer query (usually as part of a condition)
>
>subquery expressions are a special set of operators used only with subqueries usually within conditional subqueries
>
>if you want to return data from one table conditional on data from another table, but don't need to return any data from the second table, then a subquery may make more logical sense and be more readable. If you need to return data from both tables then you would need to use a join.

### PostgreSQL

1. What is a sequence?
   
   >In PostgreSQL sequences are a kind of relation that's able to generate a sequence of numbers in an automatic predetermined fashion. The last value is always remembered in a sequence and the next number is accessed using the `nexval()` function.
   
   - What is a sequence used for?
   
   >The great thing about sequence values is since no two values will ever be the same, they can be relied upon as unique identifiers and can aid in generating surrogate keys - default values for an `id` column. 
   
2. What is an auto-incrementing column?

   > a table column that will automatically generate incrementing values and are added to each row as its created. These types of columns usually function as surrogate keys as their values are unique to each row. In PostgreSQL auto-incrementing columns are usually handled using the `serial` datatype which is shorthand to creating a `NOT NULL`, `DEFAULT`, auto-incrementing, integer-based sequence.  We can break down how it works below:
   >
   > ```sql
   > -- This statement:
   > CREATE TABLE shapes (id serial, name text);
   > 
   > -- could be written in long form like so:
   > CREATE SEQUENCE shapes_id_seq;
   > CREATE TABLE shapes (
   >     id integer NOT NULL DEFAULT nextval('shapes_id_seq'),
   >     name text
   > );
   > ```

   > The important thing to remember is that once a number is returned by `nextval()` for a standard sequence, it cannot be returned again even if the value wasn't stored in a row.
   >
   > ```sqlite
   > SELECT nextval('shapes_id_seq');
   >  nextval
   > ---------
   >        4
   > (1 row)
   > ```
   >
   > This means that `4` will be skipped as an id if we insert another row into the shapes table
   >
   > ```sqlite
   > INSERT INTO shapes (name) VALUES ('rectangle');
   >  id |  name
   > ----+--------
   >   1 | circle
   >   2 | square
   >   3 | triangle
   >   5 | rectangle
   > (4 rows)
   > ```

3. How do we define a DEFAULT value for a column?

   To `CREATE` a table with a `DEFAULT` value 

   ```sqlite
   CREATE TABLE table_name (
     col_name datatype DEFAULT 0
   );
   ```

   To `ALTER` a table and add a `DEFAULT` value

   ```sqlite
   ALTER TABLE table_name 
   			ALTER col_name 
   				SET DEFAULT 0; 
   ```

4. Describe what are the following keys?

   - PRIMARY KEY

     >is a value that uniquely identifies for a row of data in a database table. `PRIMARY KEY` columns should not contain `NULL` values and must always be `UNIQUE`. The `PRIMARY KEY` constraint in PostgreSQL will automatically handle these requirements but you can only designate one `PRIMARY KEY` column per table

   - FOREIGN KEY

     >is a column that forges a relationship between a row in one table with a row in another table. This is achieved by using a `FOREIGN KEY` and the `REFERENCES` keyword to point to another table's `PRIMARY KEY`. `FOREIGN KEY` constraints determine the rules for which values are suitable for foreign key relationships.  You can designate multiple `FOREIGN KEY` columns per table, however `NULL` values aren't automatically handled and must be manually established.
     >
     >a column that stores references to a primary key column elsewhere in a database. Foreign keys usually point to other tables but they can sometimes point to rows in the same table
     >
     >Foreign keys are put in place to handle **referential integrity**: that is - data that must have valid references. If a value in a column references a value in another column (usually another table), then that value needs to exist first in the referenced column

   - natural key

     >are pre-existing values in a database table that can be used to identify all rows of data in a database table. While natural keys seem like a good idea, they are subject to change by outside forces and therefore cannot be always relied upon as a fixed unique identifier.

   - surrogate key

     >a value that's created purely for the purposes of identifying a row of data in a database table. Since these values are generated by a table from within a database, they are considered to be more reliable unique identifiers and cannot be changed by outside forces.

5. How do you do the following with a CHECK constraint?

   - Create a CHECK constraint on a column

   ```sqlite
   -- postgreSQL gives us a name
   CREATE TABLE table_name (
     col_name datatype CHECK (condition)
   );
   
   -- We define a name for the CHECK
   CREATE TABLE table_name (
     col_name datatype CONSTRAINT constraint_name CHECK (condition)
   );
   ```

   alter a table to add a CHECK without a name:

   ```sqlite
   ALTER TABLE table_name ADD CHECK (check condition);
   ```

   alter a table to add a CHECK with a name: 

   ```sqlite
   ALTER TABLE table_name 
   	ADD CONSTRAINT constraint_name 
   	CHECK (check condition);
   ```

   - remove a CHECK constraint from a column

   ```sqlite
   ALTER TABLE table_name 
   	DROP CONSTRAINT constraint_name; 
   ```

6. **How do you do the following with a FOREIGN KEY constraint?**

   - Create a FOREIGN KEY constraint on a column

   ```sqlite
   CREATE TABLE table_name (
   	other_table_id integer REFERENCES other_tables (id)
   );
   
   CREATE TABLE table_name (
   	other_table_id integer,
     FOREIGN KEY (other_table_id) REFERENCES other_tables (id)
   );
   ```

   add a `FOREIGN KEY` to an existing table:

   ```sqlite
   ALTER TABLE table_name
   	ADD FOREIGN KEY (other_table_id) 
   	REFERENCES other_tables (id);
   ```

   add a `FOREIGN KEY` with name to an existing table:

   ```sqlite
   ALTER TABLE table_name
   	ADD CONSTRAINT other_table_id_fkey 
   	FOREIGN KEY (other_table_id) 
   	REFERENCES other_tables (id);
   ```

   - remove a FOREIGN KEY constraint from a column

   ```sqlite
   ALTER TABLE table_name
   	DROP CONSTRAINT constraint_name;
   ```

### Database Diagrams

1. What are the different levels of schema?

   - conceptual
     - at the conceptual level we work on a high level design, working with bigger objects (or entities) and think about data in a very abstract way. We focus on establishing entities and the relationships they have to each other

   - logical
     - the logical level is a combination of the conceptual and physical levels. While it lists all the attributes and datatypes its not database specific.

   - physical
     - at the physical level we work with a database specific design and focus on implementing all the entity attributes, datatypes, and rules as well as establishing how entities relate to one another.

2. What is... 

   - Cardinality
     - The number of objects on each side of the relationship: be it either 1 to 1, 1 to many or many to many.
     - how many objects occur on each side of a relationship. It could either be 1 to 1, 1 to many or many to many.
     
   - Modality
     - determines if a relationship is either required by (indicating a 1) or optional (indicating a 0). If a relationship is required there must be at least 1 instance of that entity, and if optional no instances are required.

3. How Do we represent database diagrams using crows foot notation?

![image-20210528150725284](C:\Users\Karis\AppData\Roaming\Typora\typora-user-images\image-20210528150725284.png)

- **one optional:** There can be 0 or 1 instances of an entity on that side of the relationship
- **one required:** There can be 1 and only 1 entity instance on that side of the relationship
- **many optional:** There can be 0 or more entities on that side of the relationship
- **many required:** There must be at least 1 or more entity instances on that side of the relationship

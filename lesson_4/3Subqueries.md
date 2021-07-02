## Subqueries

the key thing to understand is that subqueries: 

1. use a inner nested query to generate a set of one or more values
2. those return values are used as part of an outer query (usually as part of a condition)

```sqlite
SELECT title FROM books WHERE author_id =
  (SELECT id FROM authors WHERE name = 'William Gibson');
```

- When the nested query is executed it returns the id value from the `authors` table for `William Gibson` (the integer 1):

  ```sqlite
  SELECT id FROM authors WHERE name = 'William Gibson';
   id
  ----
    1
  (1 row)
  ```

- the outer query then uses that value in the `WHERE` condition:

  ```sqlite
  SELECT title FROM books WHERE author_id = 1;
  ```

  - we were able to use `=` because the subquery returned a single value: `1`
  - for multiple return values we can use subquery expressions

### Subquery Expressions

- a special set of operators for use specifically with subqueries, usually within a conditional subquery.

```sqlite
my_books=# SELECT * FROM authors;
 id |      name
----+----------------
  1 | William Gibson
  2 | Iain M. Banks
  3 | Philip K. Dick
(3 rows)

my_books=# SELECT * FROM books;
 id |        title         |     isbn      | author_id
----+----------------------+---------------+-----------
  1 | Neuromancer          | 9780441569595 |         1
  2 | Consider Phlebas     | 9780316005388 |         2
  3 | Idoru                | 9780425158647 |         1
  4 | The State of the Art | 0929480066    |         2
  5 | The Simulacra        | 9780547572505 |         3
  6 | Pattern Recognition  | 9780425198681 |         1
  7 | A Scanner Darkly     | 9780547572178 |         3
(7 rows)
```

The following PostgreSQL subquery expressions are described below:

#### EXISTS

- checks if **any** rows are returned by the nested query. If at least 1 row is returned by the subquery then the result of exists evaluates to true otherwise false

```sqlite
SELECT 1 WHERE EXISTS
(SELECT id FROM books WHERE isbn = '9780316005388');
 ?column?
----------
        1
(1 row)
```

- the above would only return `1` if the `isbn` value exists. Because it does `1` is returned
- `EXISTS` is a little unusual and is helpful for *correlated subqueries* 

#### IN

- compares an evaluated expression to every row in the subquery result. If a row is equal to the evaluated expression, then the result evaluates to 'true' otherwise 'false'. 'True' values are returned

```sqlite
SELECT name FROM authors WHERE id IN
(SELECT author_id FROM books WHERE title LIKE 'The%');
      name
----------------
 Iain M. Banks
 Philip K. Dick
(2 rows)
```

- the nested query returns `author_id` values of `(2, 3)` from the `books` table as they returned 'true' based on the `WHERE` condition
- the outer query then returns the `name` values where the `id` matches the results from the nested query

#### NOT IN

- the opposite of `IN` where the results `NOT IN` the subquery evaluate to 'true'. If a `row` is found it evaluates to 'false'.

```sqlite
SELECT name FROM authors WHERE id NOT IN
   (SELECT author_id FROM books WHERE title LIKE 'The%');
      name
----------------
 William Gibson
(1 row)
```

- the nested query returns the same list from `author_id` `(2, 3)` from the `books` table based on the `WHERE` condition
- the outer query then returns the `name` value from any row of the `authors` table where `id` is `NOT IN` the results of the nested query

#### ANY / SOME

- `ANY` and `SOME` can be used interchangeably and are used along with an operator `=` `<` `>` etc. The result of `ANY` / `SOME` evaluates to 'true' if **at least one** of the outer query results (left of the operator) evaluates to 'true' when compared with the nested query results

```sqlite
SELECT name FROM authors WHERE length(name) > ANY
	(SELECT length(title) FROM books WHERE title LIKE 'The%');
      name
----------------
 William Gibson
 Philip K. Dick
(2 rows)
```

- the above returns any `title` length starting with 'The' that's smaller than the length of the authors `name`
- the nested query returns the length of any title starting with 'The'. 
- The outer query then returns the `name` of any author where the length of `name` is greater than **any** of the results in the nested query
  - 2 of the authors names are 14 characters in length and therefore satisfy the condition since they are greater than *at least one* of the titles lengths (13) from the results in the nested query

**Note:** when the `=` operator is used with `ANY` / `SOME`, this is equivalent to `IN`.

#### ALL

`ALL` is also used with an operator and evaluates to 'true' if **all** of the results in the outer query (left of the operator) are 'true' when compared with the nested query results

```sqlite
SELECT name FROM authors WHERE length(name) > ALL
	(SELECT length(title) FROM books WHERE title LIKE 'The%');
 name
------
(0 rows)
```

- the nested query returns the length of any title starting with 'The'. 
- The outer query then returns the `name` of any author where the length of `name` is greater than **all** of the results in the nested query
  - the lengths of all the authors names need to be greater than **all** the title lengths. Since this isn't the case nothing is returned

**Note**: when the `<>`  or  `!=` operator is used with `ALL`, this is equivalent to `NOT IN`

### When to use Subqueries?

- while subqueries and joins often produce the same result one is usually faster than the other
  - When you first create your query, optimization is often a later step in the project
- while performance isn't really a concern as of yet, using a subquery / join will come down to **personal preference**
- Some say that subqueries are more readable / make more logical sense in certain scenarios:
  - eg. **use a subquery when returning data from one table** based on data from another table (not wanting to return any data from the second table)
  - **use a join when returning data from both tables**

For more info on subqueries have a look at the [PostgreSQL documentation](https://www.postgresql.org/docs/9.6/static/functions-subquery.html)


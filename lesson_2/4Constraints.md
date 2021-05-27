## NOT NULL & DEFAULT

> the more specific and and exact the design of the **schema** is, the neater and more consistent the data will be.

- relational databases allow a schema design to build a variety of rules into the system. 
- rules allow users to make assumptions about the data that leads to simpler solutions 

```sql
CREATE TABLE employees (
    first_name character varying(100),
    last_name character varying(100),
    department character varying(100),
    vacation_remaining integer
);

 first_name | last_name | department | vacation_remaining
------------+-----------+------------+--------------------
 Leonardo   | Ferreira  | finance    |                 14
 Sara       | Mikaelsen | operations |                 14
 Lian       | Ma        | marketing  |                 13
 Haiden     | Smith     |            |
(4 rows)
```

- the table above indicates the last employee 'Haiden Smith' is a new employee which currently doesn't have a department or any accumulated vacation
- This is indicated by 2 blank spaces or `NULL` values 

### Behavior of NULL values

NULL is an unknown values and this means its behaviour is also unknown or unpredictable:

-  eg. If the HR department wanted to view the employees with the most amount of accumulated vacation they might run a query like this:

```sqlite
SELECT * FROM employees ORDER BY vacation_remaining DESC;
```

Which results in the following table:

```sqlite
 first_name | last_name | department | vacation_remaining
------------+-----------+------------+--------------------
 Haiden     | Smith     |            |
 Leonardo   | Ferreira  | finance    |                 14
 Sara       | Mikaelsen | operations |                 14
 Lian       | Ma        | marketing  |                 13
(4 rows)
```

- even though the new employee has no vacation he appears at the top of the list.

**Important things to know about `NULL` values:**

- `NULL` values sort to the top. 
- using any operator on a `NULL` value returns a `NULL` value (an unknown value)
- This makes it impossible to compare a `NULL` value with any other value
- comparing values to each other is normally how values are sorted
- Because of this vague ordering, `NULL` values are displayed first or last and In PostgreSQL they appear:
  - first if you specify a `DESC` order
  - last if you specify `ASC` order
- You cannot edit a column to add `NOT NULL` constraints when there is existing `NULL` values in that column

if the same company decided to pay its employees for the vacation they didn't take last year they could use the following query:

```sqlite
SELECT *, vacation_remaining * 15.50 * 8 AS amount FROM employees ORDER BY vacation_remaining DESC;
```

which results in the following table:

```sqlite
 first_name | last_name | department | vacation_remaining | amount
------------+-----------+------------+--------------------+---------
 Haiden     | Smith     |            |                    |
 Leonardo   | Ferreira  | finance    |                 14 | 1736.00
 Sara       | Mikaelsen | operations |                 14 | 1736.00
 Lian       | Ma        | marketing  |                 13 | 1612.00
(4 rows)
```

- there is a `NULL` value in the new `amount` column
- if this `NULL` value was fed into the payroll system, which automatically paid employees via a transaction from the companies bank; the bank could attempt to transfer an undefined amount into the employees account!!

**this example implies that:**

- an empty value in one column of a database has the potential to affect queries of that system but also other systems that have to operate on the same data

- Having undefined values - `NULL`s - in a database can lead to problems
  - manifesting more complicated queries
  - additional complexity in other systems that have to test for every possible value that could be missing

#### Solutions to NULL values

- only allow NULL values in the database when they are absolutely needed. 

- Most of the time there's another value that can be used instead of `NULL` which prevents complications

- add a rule to the column that requires a known value:

  - You must delete `NULL` values from a column before you can add `NOT NULL` constraints

  ```sqlite
  DELETE FROM employees WHERE vacation_remaining IS NULL;
  ALTER TABLE employees ALTER COLUMN vacation_remaining SET NOT NULL;
  ```

- if you try to add a `NULL` value into a column with a `NOT NULL` constraint:

  ```sql
  INSERT INTO employees (first_name, last_name) VALUES ('Haiden', 'Smith');
  -- ERROR:  null value in column "vacation_remaining" violates not-null constraint 
  -- DETAIL:  Failing row contains (Haiden, Smith, null, null).
  ```

  - an PostgreSQL error explains that there is a `not-null constraint` preventing us from storing a `NULL` value in the `vacation_remaining` column

- While we could provide a value for this column (in this case it would be `0`), a better way to handle this situation is to **define a `DEFAULT` value for the column:**

  ```sqlite
  ALTER TABLE employees ALTER COLUMN vacation_remaining SET DEFAULT 0;
  ```

- So now even it we attempt to create a row without providing a value for `vacation_remaning` the database will use `0` as the columns value:

  ```sqlite
  INSERT INTO employees (first_name, last_name) VALUES ('Haiden', 'Smith');
  
   first_name | last_name | department | vacation_remaining
  ------------+-----------+------------+--------------------
   Leonardo   | Ferreira  | finance    |                 14
   Sara       | Mikaelsen | operations |                 14
   Lian       | Ma        | marketing  |                 13
   Haiden     | Smith     |            |                  0
  (4 rows)
  ```

And previous queries will now work as expected:

```sqlite
SELECT *, vacation_remaining * 15.50 * 8 AS amount FROM employees ORDER BY vacation_remaining DESC;
 first_name | last_name | department | vacation_remaining | amount
------------+-----------+------------+--------------------+---------
 Leonardo   | Ferreira  | finance    |                 14 | 1736.00
 Sara       | Mikaelsen | operations |                 14 | 1736.00
 Lian       | Ma        | marketing  |                 13 | 1612.00
 Haiden     | Smith     |            |                  0 |    0.00
(4 rows)
```

> NOT NULL is one of several constraints available that help make a database schema as precise and protective as possible.


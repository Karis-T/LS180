## PostgreSQL Data Types

- there is more than the table below of data types but these are the most common ones covered in this course:

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

- refer to the types of data types available in postgreSQL [here](https://www.postgresql.org/docs/current/datatype.html) (be aware of the kinds of data types available)
  - certain types are specific to certain RDBMSes and is not part of the SQL standard 
  - eg `text` isn't found in the SQL standard even though it is preferable to use and has a performance improvement from `character(n)` to `text`
- the names above are postgreSQL docs recommended names but many have alternative names from SQL standards.

- `numeric` is an alias of `decimal`
- most data types have a limit to the amount of data they can store
  - eg. `integer` can store values between -2147483648 and +2147483647
  - `varchar` has a limit defined by the column
  - postgreSQL will return an error if the data value is too large

### NULL

- is a special value that represents nothing - the absense of any other value
- behaves different;y to 'nothing' value in other languages
  - usually when you compare it to other values you get a 'truthy' result

```ruby
nil == nil
=> true
```

- in SQL when `NULL` appears either side of an comparision operator (`<` `>` `=` etc) the operator returns `NULL` instead of `true` or `false` 

```sqlite
SELECT NULL = NULL;

 ?column?
----------
					--data is empty
(1 row)
```

- instead always use the `IS NULL` or `IS NOT NULL` constructs / keywords:

```sqlite
sql-course=# SELECT NULL IS NULL;
 ?column?
----------
 t
(1 row)

sql-course=# SELECT NULL IS NOT NULL;
 ?column?
----------
 f
(1 row)
```


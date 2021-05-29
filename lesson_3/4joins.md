## JOINs

### Inner Join

```sqlite
SELECT * FROM comments INNER JOIN users
ON comments.user_id = users.id;
```

- connect the 2 tables together where the value of the user_id column is equal to the id value in users id table
- this will match up comments and the users that created them
- use inner join when you know all the values will be there and there isn't any missing joins

> INNER join tells the database that it needs to find a matching row in both tables in order to return data from either one

### Outer joins

- when you want to make sure you ALWAYS get the values from one table or the other (or sometimes both!)

#### Outer Left Join

```sqlite
SELECT * FROM comments OUTER LEFT JOIN users
ON comments.user_id = users.id;
```

- performs an inner join first followed by a left outer join (the matching rows in the left table that don't satisfy the join condition)
- we want to get back data from all the rows in the *left* table (the first table mentioned)
- We always get values from the left table
- we only get values from the right table IF there is a matching row
- This results in at least one for every row of comments
- more common to use this join because you're going to start with the table that you want all the values for
- be explicit in your join language as it helps other humans understand your code much better

#### Outer Right Join

```sqlite
SELECT * FROM comments OUTER LEFT JOIN users
ON comments.user_id = users.id;
```

- performs an inner join first followed by a right outer join (the matching rows in the right table that don't satisfy the join condition)
- same as left except we tell the database that we care about the right table rows
- we get back data from at least one row for every row of users

#### Cross Join

```sqlite
SELECT * FROM comments CROSS JOIN users;
```

- dont specify an `ON` clause - no need to tell the dataabse how to match the 2 tables together
- not common
- cross join returns the cartesian product:
  - takes each row from the first table and matches it up with each of the rows from the 2nd table
  - returns every possible combination of rows from each of those 2 tables.

```sqlite
SELECT * from comments, users WHERE comments.user_id = users.id
```

- same as using an inner join
- multiples wasy to write the same thing
- above is the older syntax
- join are newer and are more explicit about what joins are userd
- frees us the `WHERE` clause

#### Full join

- combination of the `LEFT OUTER JOIN` and the `RIGHT OUTER JOIN`
  - first an `INNER JOIN` is performed
  - followed by a `LEFT OUTER JOIN` 
  - and then a `RIGHT OUTER JOIN`
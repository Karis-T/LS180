## Relational Databases

### Relational

are known to be relational because they *persist* data inside *relation* - better known as a 'table'. 

Sequences and views are also relations and if its found in a `FROM` clause in a `SELECT` statement more than likely its a relation.

### Relationships

relationships in the context of a database is the connection that entity instances - better know as rows of data - share with one another. This is usually based on what the rows of data represent.

eg. a **customers** table has a relationship with 0 or more rows in an **orders** table

- most of the time relations are another way to say 'table'
- relationships is the connection between data stored in relations
- relational data refers to working with more than 1 table at a time
  - there's several reasons to break data up into multiple tables
  - how a tables keys and constraints affect the way rows are retrieved, inserted, updated and deleted 

 
## Indexes

- not going into too much detail as indexes are a deep and complex topic
- not necessary to explore fully at this point

### What are indexes?

- indexes are a mechanism that SQL uses to help speed up queries

  - we speed up queries by storing indexed data in a table like structure
  - this stored data can be quickly searched using specific search algorithms. The search result is a link back to record(s) where the indexed data lives.
  - using indexes allows us to locate column values more efficiently since its not required to search through every record in a table in sequence

- to visualize how indexes work we can refer to the back of a reference book which often index key terms and list all the pages where that term is mentioned.

  - to find a particular term in the book search the index in a book and you'll know where to find out more about it in the book

- when we have an index on a column of a database table - it enables fast lookup

  ![Books table](https://da77jsbdz4r05.cloudfront.net/images/optimizing_queries/books_table.png)

  - eg. if we wanted to lookup all the william gibson books from the following table instead of checking each row 1 by one we would create an index that will tell you where all the william gibson books are found:

  ![Books table with highlighted rows and index](https://da77jsbdz4r05.cloudfront.net/images/optimizing_queries/books_table_highlighted_index.png)

  - here William Gibson can be found at row 1, 3 and 6

- in a database situation the indexed column would usually be a foreign key id column instead

### When do we use indexes?

- if you index every column you can end up with slower tables
  - one reason for this is every time you update or insert a row the index is also updated which is a performance cost and doubles the amount of modification time
- to assess whether a index is worth having consider the below
  - use indexes when sequential reading isn't good enough, eg. columns that map relationships (foreign key columns or columns frequently used in `ORDER BY` clauses)
  - indexes are best suited to tables/columns where data is read more frequently

#### Types of indexes

- [different types](https://www.postgresql.org/docs/9.2/static/indexes-types.html) use different data structures and search algorithims
- index types in PostgreSQL are:
  - B-tree
  - Hash
  - GiST
  - GIN

### How to create an index

- when you define a `PRIMARY KEY` or a `UNIQUE` constraint you are automatically (implicitly) creating an index for that column
- indexes are the mechanism behind how these constraints enforce uniqueness

```sql
                          Table "public.books"
     Column     |          Type          |                     Modifiers
----------------+------------------------+----------------------------------------------------
 id             | integer                | not null default nextval('books_id_seq'::regclass)
 title          | character varying(100) | not null
 isbn           | character(13)          | not null
 author_id      | integer                |
 
Indexes:
  "books_pkey" PRIMARY KEY, btree (id)
  "books_isbn_key" UNIQUE CONSTRAINT, btree (isbn)
Foreign-key constraints:
  "books_author_id_fkey" FOREIGN KEY (author_id) REFERENCES authors(id)
```

- the 2 entries listed under `Indexes` are a `PRMARY KEY` for `id` and a `UNIQUE` constraint for `isbn` columns
- `btree` is the type of index used and is PostgreSQL's default, and is the only type available for unique constraints
- `FOREIGN KEY` constraints don't automatically create an index on a column hence they make good candidates for indexing. This must be explicitly done

```sqlite
CREATE INDEX index_name ON table_name (field_name);
```

- if you omit the index name, PostgreSQL will generate a unique name for you. 
- you must give an index a name that hasn't already been used:

```sqlite
CREATE INDEX ON books (author_id);

                         Table "public.books"
     Column     |          Type          |                     Modifiers
----------------+------------------------+----------------------------------------------------
 id             | integer                | not null default nextval('books_id_seq'::regclass)
 title          | character varying(100) | not null
 isbn           | character(13)          | not null
 author_id      | integer                |
Indexes:
  "books_pkey" PRIMARY KEY, btree (id)
  "books_isbn_key" UNIQUE CONSTRAINT, btree (isbn)
  "books_author_id_idx" btree (author_id)
```

#### Unique vs Non-unique

- `PRIMARY KEY` and `UNIQUE` constraints create a *unique* index. When an index is unique: 
  - multiple table rows with equal values aren't allowed
  - its also not possible to insert duplicate values into the columns `books_pkey` and `books_isbn_key` reference
- `books_author_id_idx` index that we added *doesn't enforce uniqueness* called a non-unique index
  - this means the same value can occur multiple times in the indexed column 

#### Multicolumn Indexes

- you can create an index for multiple columns in a table

```sqlite
CREATE INDEX index_name ON table_name (field_name_1, field_name_2);
```

- only certain index types support multicolumn index
- there's a limit to how many columns you can combine into one index

#### Partial indexes

- built from a subset of the data in a table
- subset is defined by a conditional expression
- the index will only contain entries for the rows (values) in the table that satisfies the condition
  - eg. only indexing rows where the values in `author_name` starts with an `A`
- useful in certain situations but more than likely you'll use single or multi-column indexes

### How to delete an index

use the `DROP INDEX` command followed by the name of the index

- to list all the indexes for a table use the `\di` psql command: 

```sqlite
my_books=# \di
              List of relations
 Schema |        Name         | Type  | Owner |  Table
--------+---------------------+-------+-------+---------
 public | authors_pkey        | index | User  | authors
 public | books_author_id_idx | index | User  | books
 public | books_isbn_key      | index | User  | books
 public | books_pkey          | index | User  | books
(4 rows)
```

- 3 indexes on `books` table and 1 on `authors`

```sqlite
DROP INDEX books_author_id_idx;

                 List of relations
 Schema |      Name      | Type  | Owner |  Table
--------+----------------+-------+-------+---------
 public | authors_pkey   | index | karl  | authors
 public | books_isbn_key | index | karl  | books
 public | books_pkey     | index | karl  | books
(3 rows)
```


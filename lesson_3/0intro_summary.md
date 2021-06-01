## Introduction

- Pay attention to how to work with multiple tables using `JOIN`
  - understand the several types of joins
- Understand that SQL has many optional keywords
  - the course uses a very explicit style of SQL but there are other types on the internet
  - the course uses this style to help breakdown what a SQL statement does
- keep in mind that schemas can change over time
  - consider if its possible to stick with the current schema or if an update to the schema is needed.

## Summary

- **relational databases** are considered to be relational because they persist data in a set of **relations** - better known as **tables**
- A **relationship** is when entity relationships - better known as rows of data - share a connection between each other, which is often based on what the rows of data represent.
- The 3 levels of schema are:
  - **conceptual**: high level design with a focus on identifying the necessary entities and their relationships
  - logical
  - **physical**: low level database specific design with a focus on implementation
- The 3 types of relationships are: 
  - 1 : 1 (one to one)
  - 1 : M (one to many)
  - M : M (many to many) 
- **Cardinality** refers to the number of objects on either side of a relationship (many or one)
- **Modality** refers to the idea of whether a relationship between entities is required or not
- **Referential Integrity** refers to data that needs all its references to be valid. That is, A columns values must first exist in order to be referenced by another column (usually located in another table)


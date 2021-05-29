## Cardinality

>the number of objects on each side of the relationship (1:1, 1:M. M:M)



## Modality

> if the relationship is required (1) or optional (0)

- if it IS required there has to be **at least 1 instance** of that entity
- conversely if its not needed there you don't have to have any instances at all
- Modality is concerned with how many instances there can be in a relationship
- indicated by a single number
  - 1 required
  - 0 optional

![image-20210528150725284](C:\Users\Karis\AppData\Roaming\Typora\typora-user-images\image-20210528150725284.png)

![image-20210528150840804](C:\Users\Karis\AppData\Roaming\Typora\typora-user-images\image-20210528150840804.png)

- an author must have at least 1 book
- a book must have at least 1 author
- a book doesn't have to have a category
- a category doesn't have to have a book
- we don't have to enforce these rules its just about a developer understanding how these entities and their relationships work together

![image-20210528151542186](C:\Users\Karis\AppData\Roaming\Typora\typora-user-images\image-20210528151542186.png)

- an even doesn't have to have a ticket
- a ticket must have at least 1 event
- a customer doesn't have to have a ticket
- a ticket has to have at least 1 customer
- A section has to have at least 1 seat
- A seat has to have at least 1 section
- A seat doesn't have to have a ticket
- a ticket has to have at least 1 seat



**1 to 1 relationships in databases are pretty rare**

- if there is a 1 to 1 relationship between 2 entities, they should be folded into a single entity
  - or when you convert it into a physical schema, that those entities should be stored in the same table
- **The schema you create for a 1 to 1 relationship is the same as a 1 to many relationship**

![image-20210528152832507](C:\Users\Karis\AppData\Roaming\Typora\typora-user-images\image-20210528152832507.png)

![image-20210528153205812](C:\Users\Karis\AppData\Roaming\Typora\typora-user-images\image-20210528153205812.png)

- crows foot notation is the most common and easiest to understand
- you many come across different styles of ERD. If you do ask yourself:
  - what level of schema is it representing? (conceptual logical or physical?)
  - how are certain things represented?
    - entities?
    - relationships? Are they shown?
    - are the attributes of the entities shown? if so how? Are the datatypes displayed as well?

![image-20210528153559094](C:\Users\Karis\AppData\Roaming\Typora\typora-user-images\image-20210528153559094.png)

chens notation

- entities are green rectangles
- relationships between entities are purple diamonds that describe the relationship
- cardinality is the little numbers next to the diamond
- shows the attributes but not the datatypes
- somewhere between conceptual and logical


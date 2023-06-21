/*1
Users who have rated a classic or fantasy 
book with a rating of at least 4.*/

MATCH (u:User)-[r:RATED]->(b:Book)-[:GENRE_OF]->(g:Genre)
WHERE g.genre IN ['classic', 'fantasy'] AND r.rank >= 4
RETURN u.name AS Name, u.surname AS Surname, b.title AS BookTitle, r.rank AS Rating

/*2
Users who have borrowed at least three different 
books sorted in descending order by the books 
borrowed (user's full name, number of books)*/

MATCH (u:User)-[:BORROWED]->(b:Book)
WITH u, COUNT(DISTINCT b) AS NumberOfBooks
WHERE NumberOfBooks >= 3
RETURN u.name AS Name, u.surname AS Surname, NumberOfBooks
ORDER BY NumberOfBooks DESC

/*3
Books not borrowed and not rated by 
anyone. (titles and types of books)*/

MATCH (b:Book)-[:GENRE_OF]->(g:Genre)
WHERE NOT EXISTS((b)<-[:BORROWED]-()) AND NOT EXISTS((b)<-[:RATED]-())
RETURN b.title AS BookTitle, g.genre AS BookGenre

/*4
Recommend to Gary Oldman books rated >3 
by users who borrowed the same books as 
him, and which he has not read (borrowed 
or rated himself). (all relevant data).*/

MATCH (u1:User {name: "Gary", surname: "Oldman"})-[:BORROWED]->(b:Book)<-[:BORROWED]-(u2:User)-[r:RATED]->(b1)
WHERE r.rank > 3 AND NOT EXISTS((u1)-[:BORROWED]->(b1)) AND NOT EXISTS((u1)-[:RATED]->(b1))
RETURN u2.name AS Name, u2.surname AS Surname, b1.title AS BookTitle, r.rank AS Rating

/*5
For each publisher, the number of books 
published by each genre in alphabetical 
order (publisher, genre, number of books).*/

MATCH (e:Editor)-[:PUBLISHED]->(b:Book)-[:GENRE_OF]->(g:Genre)
WITH e.publisher AS publisher, g.genre AS genre, COUNT(b) AS BookCount
ORDER BY publisher, genre
RETURN publisher AS Publisher, genre AS Genre, BookCount

/*6
The authors and publishers who are within 
a distance of 4 from Gabriel Byrne. publishers).*/

MATCH (:User {name: 'Gabriel', surname: 'Byrne'})-[*1..4]-(whatever)
WHERE NOT whatever:User AND NOT whatever:Genre
RETURN DISTINCT whatever.author AS Authors, whatever.publisher AS Publishers

/*7
Give the shortest path between all user pairs,
for users with a first name starting with 'B'. 
Display the pairs starting from the one with 
the shortest path to the one with the longest. 
(user name1, user name 2, path length).*/

MATCH p=shortestPath((u1:User)-[*]-(u2:User))
WHERE u1.name STARTS WITH 'B' AND u2.name STARTS WITH 'B' AND u1 <> u2
RETURN DISTINCT u1.name AS NameUser1, u1.surname AS SurnameUser1, u2.name AS NameUser2, u2.surname AS SurnameUser2, length(p) AS ShortestPathLength
ORDER BY ShortestPathLength ASC

/*8
Find the pair of users who have borrowed the 
most shared books (full name of user1, 
full name of user2, number of books).*/

MATCH (u1:User)-[:BORROWED]->(b:Book)<-[:BORROWED]-(u2:User)
WITH u1, u2, COUNT(DISTINCT b) AS SharedBooks
WHERE u1 <> u2
RETURN u1.name AS User1, u2.name AS User2, SharedBooks
ORDER BY SharedBooks DESC
LIMIT 1

/*9
For books that have more than 3 items, the 
number of users who have borrowed them. 
(title, number of users)*/

MATCH (u:User)-[:BORROWED]->(b:Book)-[:GENRE_OF]->(g:Genre)
WITH b, COUNT(DISTINCT g) AS numberOfGenres, COLLECT(DISTINCT u) AS users
WHERE numberOfGenres >= 3
RETURN b.title AS BookTitle, SIZE(users) AS NumberOfUsersBorrowed

/*10
The users who have borrowed a book that 
Al Pacino has read, but has not rated by 
neither Bill Murray nor Brad Pitt. (users, books)*/

MATCH (u:User)-[:BORROWED]->(b:Book)<-[:BORROWED]-(u2:User {name: "Al", surname: "Pacino"})
WHERE NOT (u {name: "Bill", surname: "Murray"})-[:RATED]->(b)
AND NOT (u {name: "Brad", surname: "Pitt"})-[:RATED]->(b)
RETURN u.name AS Name, u.surname AS Surname, b.title AS BookTitle

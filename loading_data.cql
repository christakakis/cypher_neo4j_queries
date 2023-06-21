LOAD CSV WITH HEADERS FROM 'file:///books.csv' AS csvline
MERGE (b:Book {title: csvline.title, author: csvline.author, year_written: csvline.year_written, edition: csvline.edition, price: csvline.price})

LOAD CSV WITH HEADERS FROM 'file:///editors.csv' AS csvline
CREATE (e:Editor {publisher: csvline.publisher, address: csvline.address})

LOAD CSV WITH HEADERS FROM 'file:///genres.csv' AS csvline
MERGE (g:Genre {genre: csvline.genre})

LOAD CSV WITH HEADERS FROM 'file:///users.csv' AS csvline
CREATE (u:User {id: csvline.id, name: csvline.Name, surname: csvline.Surname, birthdate: csvline.BirthDate})

LOAD CSV WITH HEADERS FROM 'file:///books.csv' AS csvline
MATCH (b:Book {edition: csvline.edition})
MATCH (e:Editor {publisher: csvline.edition})
MERGE  (e)-[:PUBLISHED]->(b)

LOAD CSV WITH HEADERS FROM 'file:///genres.csv' AS csvline
MATCH (b:Book {title: csvline.title})
MATCH (g:Genre {genre: csvline.genre})
CREATE (b)-[:GENRE_OF]->(g)

LOAD CSV WITH HEADERS FROM 'file:///borrowed.csv' AS csvline
MATCH (b:Book {title: csvline.title})
MATCH (u:User {id: csvline.userid})
CREATE (u)-[:BORROWED {date: toString(csvline.date)}]->(b)

LOAD CSV WITH HEADERS FROM 'file:///rated.csv' AS csvline
MATCH (b:Book {title: csvline.title})
MATCH (u:User {id: csvline.userid})
CREATE (u)-[:RATED {rank: toInteger(csvline.rank)}]->(b)
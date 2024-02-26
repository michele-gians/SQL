CREATE DATABASE ToysGroup;
USE ToysGroup;

CREATE TABLE Category (Category_ID INTEGER PRIMARY KEY AUTO_INCREMENT,
Category_name VARCHAR(20));


CREATE TABLE Product (Product_ID INTEGER PRIMARY KEY AUTO_INCREMENT,
Name VARCHAR(30),
Price FLOAT(15,2),
Target_Age VARCHAR(15),
Category_ID INT,
FOREIGN KEY (Category_ID) REFERENCES Category(Category_ID));


CREATE TABLE Region (Region_ID INTEGER PRIMARY KEY AUTO_INCREMENT,
Region_name VARCHAR (25));


CREATE TABLE State (State_ID INTEGER PRIMARY KEY AUTO_INCREMENT,
State_Name VARCHAR(25),
Region_ID INT,
FOREIGN KEY (Region_ID) REFERENCES Region(Region_ID));


CREATE TABLE Sales (Sale_ID INTEGER PRIMARY KEY AUTO_INCREMENT,
Sale_date DATE,
Product_ID INT,
State_ID INT,
Price FLOAT(15,2),
FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID),
FOREIGN KEY (State_ID) REFERENCES State(State_ID));


INSERT INTO Category (Category_name) VALUES
('Board Game'),
('Puzzle'),
('Creative Toy'),
('Action Figure'),
('Card geame');

INSERT INTO Product (Name,Price,Target_Age,Category_ID) VALUES 
('Monopoly', 20, '6+', 1),
('Rubik''s cube', 12, '3+', 2),
('He man', 9, '3+', 4),
('Power Rangers', 8, '3+', 4),
('Magic deck', 15, '6+', 5),
('Poker cards', 13, '3+', 5),
('Lego set', 32, '6+', 3),
('Geomag set', 28, '9+', 3),
('Risiko', 22, '6+', 1),
('Tangram', 15, '9+', 2);

INSERT INTO Region (Region_name) VALUES
('NorthEurope'),
('SouthEurope'),
('EastEurope');

INSERT INTO State (State_name, Region_ID) VALUES
('Germany',1),
('France',1),
('Switzerland',1),
('Italy',2),
('Greece',2),
('Spain',2),
('Russia',3),
('Poland',3),
('Lithuania',3);


INSERT INTO Sales (Sale_date,Product_ID,State_ID, Price) VALUES
('2023-01-12', 9, 8, 22),
('2023-01-30', 1, 8, 20),
('2023-02-07', 2, 6, 12),
('2023-02-19', 1, 4, 20),
('2023-03-03', 3, 3, 9),
('2023-03-20', 5, 4, 15),
('2023-04-09', 6, 2, 13),
('2023-04-17', 7, 1, 32),
('2023-05-09', 7, 3, 32),
('2023-05-28', 4, 4, 8),
('2023-06-05', 3, 5, 9),
('2023-06-21', 2, 3, 12),
('2023-07-07', 3, 1, 9),
('2023-07-15', 4, 2, 8),
('2023-07-26', 5, 3, 15),
('2023-08-10', 8, 4, 28),
('2023-08-25', 7, 4, 32),
('2023-09-10', 4, 5, 8),
('2023-09-26', 5, 6, 15),
('2023-10-03', 3, 2, 9),
('2023-10-18', 7, 1, 32),
('2023-10-30', 7, 3, 32),
('2023-11-02', 5, 1, 15),
('2023-11-24', 4, 5, 8),
('2023-12-02', 2, 5, 12),
('2023-12-15', 1, 4, 20),
('2023-12-29', 3, 2, 9),
('2024-01-08', 4, 2, 8),
('2024-01-23', 6, 3, 13),
('2024-02-02', 8, 6, 28),
('2024-02-14', 9, 7, 22),
('2024-02-17', 9, 8, 22),
('2024-03-05', 5, 9, 15),
('2024-03-12', 4, 6, 8),
('2024-03-18', 3, 4, 9),
('2024-04-01', 4, 4, 8),
('2024-04-07', 5, 3, 15),
('2024-04-19', 6, 2, 13),
('2024-04-23', 2, 2, 12),
('2024-05-06', 2, 4, 12),
('2024-05-15', 2, 2, 12);

 
 -- 1. Verificare che i campi definiti come PK siano univoci.  
 
select count(*) as PK_Not_Unique, Sales.Sale_ID 
from Sales
group by (Sale_ID)
having count(*) > 1;

select count(*) as PK_Not_Unique, Region.Region_ID
from Region
group by (Region_ID)
having count(*) > 1;

select count(*) as PK_Not_Unique, Product.Product_ID
from product
group by (Product_ID)
having count(*) > 1;

select count(*) as PK_Not_Unique, State.State_ID
from State
group by (State_ID)
having count(*) > 1;

select count(*) as PK_Not_Unique, Category.Category_ID
from Category
group by (Category_ID)
having count(*) > 1;


-- 2. Esporre l’elenco dei soli prodotti venduti e per ognuno di questi il fatturato totale per anno.

select product.name as Product_name, sum(sales.Price) as Revenue, year(Sale_date) as Year
from product 
join sales using (Product_ID)
group by Product_ID, year(Sale_date);


-- 3. Esporre il fatturato totale per stato per anno. Ordina il risultato per data e per fatturato decrescente. 

select State.State_Name, sum(sales.Price) as Revenue, year(Sale_date) as Year
from State
join Sales using (State_ID)
group by State_ID, year(Sale_date)
order by Year, Revenue desc;


-- 4. Rispondere alla seguente domanda: qual è la categoria di articoli maggiormente richiesta dal mercato? 

select Category.Category_name
from Category
join Product using (Category_ID)
join Sales using (Product_ID)
group by Category_ID
order by count(Sale_ID) desc
limit 1;


-- 5. Rispondere alla seguente domanda: quali sono, se ci sono, i prodotti invenduti? Proponi due approcci risolutivi differenti. 

-- Metodo 1

select Product.Name as Product_name
from Product 
left join sales using (Product_ID)
where Sale_ID is null;


-- Metodo 2

select Product.Name as Product_name
from Product
where Product_ID not in (select Product_ID from sales);


-- 6. Esporre l’elenco dei prodotti con la rispettiva ultima data di vendita (la data di vendita più recente).

select Product.name as Product_name, max(sales.Sale_date) as Ultima_vendita
from Product
join sales using (Product_ID)
group by Product.name;


-- BONUS: Esporre l’elenco delle transazioni indicando nel result set il codice documento, la data, il nome del prodotto, 
-- la categoria del prodotto, il nome dello stato, il nome della regione di vendita 
-- e un campo booleano valorizzato in base alla condizione che siano passati più di 180 giorni dalla data vendita o meno 
-- (>180 -> True, <= 180 -> False)

select  Sales.Sale_ID, Sales.Sale_date AS Date, 
Product.Name AS Product_name, Category.Category_name,
State.State_Name, Region.Region_name,
case  
when datediff(curdate(), Sales.Sale_date) > 180 then true
else false end as 180_Days_Passed
from  Sales
join Product using (Product_ID)
join Category using (Category_ID)
join State using (State_ID)
join Region using (Region_ID)
order by Sale_ID;



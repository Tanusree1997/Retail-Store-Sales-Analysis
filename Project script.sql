Create database Retail;

Use retail;
/*Importing features table*/

Create table Features(store int, date text, temperature double, Fuel_price double, 
Markdown1 double, Markdown2 double, Markdown3 double, Markdown4 double, Markdown5 double, CPI double,
Unemployment double, isholiday text);

select * from features;


/* changing the zeros in markdown columns to null value*/
update features
set markdown5= null
where markdown5=0;

Select markdown1, markdown2, markdown3, markdown4, markdown5
from features;


/* change date column*/
Alter table  features
add column NewDate date;

select Str_to_date(Date,"%d/%c/%Y"), NewDate
from features;

SET SQL_SAFE_UPDATES = 0;

update features
set NewDate = Str_to_date(Date,"%d/%c/%Y");

Alter table features
drop Date;

/* The average values of the independent factors in each year*/

select year(newdate), round(avg(temperature), 2) as avgtemperature, round(avg(CPI),2) as avgcpi, round(avg(unemployment),2) as avgunemployment
from features
group by year(newdate);

/* Importing other two tables*/
Create table sales(store int, dept int, date text, weekly_sales double, Isholiday text);
Select * from sales;

Select *
from sales;

Create table stores(store int, type text, size int);
Select * from stores;

/* change date in sales table*/

Alter table  sales
add column NewDate date;

select Str_to_date(Date,"%d/%c/%Y"), NewDate
from sales;

SET SQL_SAFE_UPDATES = 0;

update sales
set NewDate = Str_to_date(Date,"%d/%c/%Y");

Alter table sales
drop Date;

/*Let's find the trends in weekly sales*/
Select round(avg(weekly_sales),2) as averageweeklysales, year(newdate)
from sales
group by year(newdate);

Select round(avg(weekly_sales),2) as averageweeklysales, isholiday
from sales
group by isholiday;

Select round(avg(S.weekly_sales),2) as averageweeklysales, Month(S.newdate)
from sales as S inner join features as F on S.store=F.store
where year(S.newdate)= "2022"
group by Month(S.newdate)
order by Month(S.newdate) asc;

create view C as
Select round(sum(weekly_sales),2) as sales, newdate, store
from sales 
group by newdate, store;

/* This table gives the common entries of features and sales table*/

create view Imptable as select f.store, f.temperature, f.fuel_price, f.cpi, f.unemployment, c.sales, c.newdate
from features as f inner join c using(store)
where f.newdate=c.newdate;

Select *
from imptable;

/* let's see whether holidays have any significance in weeklysales or not*/
Select round(avg(weekly_sales),2) as averageweeklysales, isholiday
from sales
where year(newdate)= 2022
group by isholiday;

/* let's see whether holidays have any significance in weeklysales or not*/

create view Imptable2 as select f.store, f.markdown1, f.markdown2, f.markdown3, f.markdown4, 
f.markdown5, c.sales, c.newdate
from features as f inner join c using(store)
where f.newdate=c.newdate;

select * from imptable2;

/*checking the joint and independent impacts of holidayweeks and markdowns on averageweeklysales*/

create view C1 as Select round(sum(weekly_sales),2) as sales, newdate, store, isholiday
from sales 
group by newdate, store, isholiday;

select f.store, f.markdown1, f.markdown2, f.markdown3, f.markdown4, 
f.markdown5, c1.sales, c1.newdate, c1.isholiday
from c1 inner join features as f using(store)
where f.newdate=c1.newdate;

select f.store, f.markdown1, f.markdown2, f.markdown3, f.markdown4, 
f.markdown5, c1.sales, c1.newdate, c1.isholiday
from c1 inner join features as f using(store)
where f.newdate=c1.newdate and f.markdown1 = 0 and f.markdown2 = 0
and f.markdown3 = 0 and f.markdown4 = 0  and f.markdown5 = 0 and c1.isholiday = "true";


Select round(sum(weekly_sales),2) as sales, store
from sales 
where year(newdate)= 2022
group by store;


/* Does store size matters?*/
create view C3 as Select C.store, round(avg(C.sales),2) as avgsales
from C inner join stores as S using(store)
group by c.store;

Select C3.store, C3.avgsales, s.size
from C3 inner join stores as s using(store);


/* Does type of store matters?*/
Select round(avg(C3.avgsales),2), s.type
from C3 inner join stores as s using(store)
group by s.type;






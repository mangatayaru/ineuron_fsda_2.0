USE DATABASE DEMO_DATABASE1;

--1.Load the given dataset into snowflake with a primary key to Order Date column.

CREATE or replace table sales_data_final(
  order_id varchar(30) ,
  order_date DATE primary key,
  ship_date DATE,
  ship_mode varchar(30),
  customer_name varchar(30),
  segment varchar(30),
  state varchar(60),
  country varchar(60),
  market varchar(30),
  region varchar(30),
  product_id varchar(60),
  category varchar(30),
  sub_category varchar(30),
  product_name varchar(150),
  sales number,
  quantity number,
  discount number(10,4),
  profit number(20,6),
  shipping_cost number(10,2),
  order_priority varchar(30),
  year number(4)
  );
select * from sales_data_final;
DESCRIBE TABLE sales_data_final;

----2. Change the Primary key to Order Id Column.
ALTER TABLE sales_data_final
DROP PRIMARY KEY;

ALTER TABLE sales_data_final
ADD PRIMARY KEY (order_id);

DESCRIBE TABLE sales_data_final;

---3. Check the data type for Order date and Ship date and mention in what data type it should be?
--The Order date and Shipdate are of date datatype and should be in "YYYY-MM-DD" form.

---4. Create a new column called order_extract and extract the number after the last ‘–‘from Order ID column. 
alter table sales_data_final
ADD column  ORDER_EXTRACT varchar(10);

UPDATE sales_data_final
SET ORDER_EXTRACT = SPLIT_PART(order_id,'-',3);

---5. Create a new column called Discount Flag and categorize it based on discount. Use ‘Yes’ if the discount is greater than zero else ‘No’.

alter table sales_data_final
ADD column  DISCOUNT_FLAG varchar(5);

UPDATE sales_data_final
SET DISCOUNT_FLAG=case
            when  discount>0 then 'YES'
            else 'FALSE'
            end;
            
---6. Create a new column called process days and calculate how many days it takes for each order id to process from the order to its shipment.
alter table sales_data_final
ADD column  PROCESS_days numeric;

UPDATE sales_data_final
SET PROCESS_days=datediff(day, order_date ,ship_date);
 
---7. Create a new column called Rating and then based on the Process dates give rating like given below.
---a. If process days less than or equal to 3days then rating should be 5
---b. If process days are greater than 3 and less than or equal to 6 then rating should be 4.
---c. If process days are greater than 6 and less than or equal to 10 then rating should be 3
---d. If process days are greater than 10 then the rating should be 2.

alter table sales_data_final
ADD column  RATING NUMERIC;


UPDATE sales_data_final
SET RATING=case
          when PROCESS_days<3 THEN 5 
          when PROCESS_days<6 THEN 4
          when PROCESS_days<10 THEN 3
          else 2
         end;

-------DISPLAYING THE TABLE
select * from sales_data_final;
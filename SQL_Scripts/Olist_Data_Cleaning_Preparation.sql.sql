 --check miss value and unicqness of primary key of order table
select count(*),count(distinct order_id),count(customer_id),count(order_status),count(order_purchase_timestamp),
count(order_approved_at),count(order_delivered_carrier_date),count(order_delivered_customer_date),
count(order_estimated_delivery_date)
from olist_orders_dataset;

--valid nulls value
select order_status,count(*) as missingCount from olist_orders_dataset
where order_approved_at is null
group by order_status;
select order_status,count(*) as missingCount from olist_orders_dataset
where order_delivered_carrier_date is null
group by order_status;
select  order_status,count(*) as missingCount from olist_orders_dataset
where order_delivered_customer_date is null
group by order_status;

select  order_status,count(*) as Count from olist_orders_dataset
group by order_status
order by count;

--check period range
select min(order_purchase_timestamp),max(order_purchase_timestamp)
from olist_orders_dataset;
--check dates
select count(*) from olist_orders_dataset
where order_purchase_timestamp>order_approved_at;

select count(*) from olist_orders_dataset
where order_delivered_customer_date<order_delivered_carrier_date;

--find errors in delivery dates
select top 23 order_id,customer_id,order_status,order_purchase_timestamp,
order_approved_at,order_delivered_carrier_date,order_delivered_customer_date,
order_estimated_delivery_date from olist_orders_dataset
where order_delivered_customer_date<order_delivered_carrier_date;

--........................................................................................................
-- check data quality of order items
--check missing values
select count(*),count(order_id),count(order_item_id),COUNT(product_id),
count(seller_id),count(shipping_limit_date),count(price),count(freight_value)
from olist_order_items_dataset;

-- check primary key and unicqness
select count(*)
from(select distinct order_id,order_item_id from olist_order_items_dataset) as taple;

--check prices range
select min(price),max(price) from olist_order_items_dataset;
--valid ranges

--check freight values range
select min(freight_value),max(freight_value) from olist_order_items_dataset;
--valid ranges

--check shipping_limit_date range
select min(shipping_limit_date),max(shipping_limit_date) from olist_order_items_dataset;
--max is 2020-04-09 22:35:08.0000000

--find count order deliver after 1/11/2018
select count(*) from olist_orders_dataset
where order_delivered_customer_date> '11/01/2018';
--answer 0
select count(*) from olist_orders_dataset
where order_delivered_carrier_date> '11/01/2018';
--answer 0
--so shipping_limit_date is considerd deadline only

--check valid value for order id
select count(*) from olist_orders_dataset t1 join olist_order_items_dataset t2
on t1.order_id=t2.order_id;
--relation is true

--check valid value for product id
select count(*) from olist_products_dataset t1 join olist_order_items_dataset t2
on t1.product_id=t2.product_id;
--relation is true

--check valid value for seller id
select count(*) from olist_sellers_dataset t1 join olist_order_items_dataset t2
on t1.seller_id=t2.seller_id;
--relation is true


--check serial number
select order_id,min(order_item_id) from olist_order_items_dataset
group by order_id having max(order_item_id)<>count(order_item_id);
--no answer so serial number is true
--..................................................................................................................
-- check data quality of order paymentes
--check missing values
select count(*),count(order_id),count(payment_sequential),count(payment_type),count(payment_installments),count(payment_value)
from olist_order_payments_dataset;
--no missing value

-- check primary key and unicqness
select count(*)
from(select distinct order_id,payment_sequential from olist_order_payments_dataset) as taple;
--they are uniqueness and no duplicates

--check range payment value
select min(payment_value),max(payment_value)
from olist_order_payments_dataset;
--min is 0 this is a problem
--check problem size
select count(*) from olist_order_payments_dataset
where payment_value=0;
--answer is 9 
select order_status,count(*) from olist_orders_dataset t1 join olist_order_payments_dataset t2
on t1.order_id=t2.order_id
where payment_value=0
group by order_status;
  
select * from olist_order_payments_dataset 
where payment_value=0;

--check relationship 
select count(*) from olist_orders_dataset t1 left join olist_order_payments_dataset t2
on t1.order_id=t2.order_id;
select * from olist_orders_dataset t1 left join olist_order_payments_dataset t2
on t1.order_id=t2.order_id
where t2.order_id is null;
select count(*) from olist_orders_dataset t1 right join olist_order_payments_dataset t2
on t1.order_id=t2.order_id;
select count(*) from olist_orders_dataset t1 join olist_order_payments_dataset t2
on t1.order_id=t2.order_id;
--relation is true but 1 order doesnt have payment record

--check range payment installments
select min(payment_installments),max(payment_installments)
from olist_order_payments_dataset;
--min is 0 this is a problem
--check problem size
select count(*) from olist_order_payments_dataset
where payment_installments=0;
--answer is 2 
select * from olist_order_payments_dataset
where payment_installments=0;


--check range payment sequential
select min(payment_sequential),max(payment_sequential)
from olist_order_payments_dataset;
--valid range

--check values consistency
select distinct payment_type from olist_order_payments_dataset;
-- values is okay and count them 5

select count(payment_type) from olist_order_payments_dataset
where payment_type='not_defined';
--3
--..................................................................................................................
-- check data quality of order reviews
--check missing values
select count(*),count(review_id),count(order_id),count(review_score),count(review_comment_title),
count(review_comment_message),count(review_creation_date),count(review_answer_timestamp)
from olist_order_reviews_dataset;
--missing value in review_comment_title and review_comment_message but they cases are normal

-- check primary key and unicqness
select count(*)
from(select distinct review_id,order_id from olist_order_reviews_dataset) as taple;
--order_id and review_id is composite key

select review_id,count(*) from olist_order_reviews_dataset
group by review_id
having count(*)>2;
select * from olist_order_reviews_dataset where review_id='4548534449b1f572e357211b90724f1b';


--check relationship 
select count(*) from olist_orders_dataset t1 left join olist_order_reviews_dataset t2
on t1.order_id=t2.order_id;
select count(*) from olist_orders_dataset t1 right join olist_order_reviews_dataset t2
on t1.order_id=t2.order_id;
select count(*) from olist_orders_dataset t1 join olist_order_reviews_dataset t2
on t1.order_id=t2.order_id;
--relation is true but some order not have reviews

--check review_comment_title
select review_comment_title,count(*)
from olist_order_reviews_dataset
group by review_comment_title;
--reviews have large varity from titels

--check review_score
select min(review_score),max(review_score) from olist_order_reviews_dataset;
--valid range

--check review_creation_date range
select min(review_creation_date),max(review_creation_date) from olist_order_reviews_dataset;
--valid range

--check review_answer_timestamp range
select min(review_answer_timestamp),max(review_answer_timestamp) from olist_order_reviews_dataset;
--valid range

--dates relationship
select count(*) from olist_order_reviews_dataset
where review_answer_timestamp<review_creation_date;
--..................................................................................................................
-- check data quality of products
--check missing values
select count(*),count(product_id),count(product_category_name),count(product_name_lenght),
count(product_description_lenght),count(product_photos_qty),count(product_weight_g),count(product_length_cm),
count(product_height_cm),count(product_width_cm)
from olist_products_dataset;
select * from olist_products_dataset where product_width_cm is null;
--2 product not have weight,lenght,hight and weight
select * from olist_products_dataset where product_category_name is null;
--610 product not have product_category_name,product_name_lenght,product_description_lenght and product_photos_qty

select t3.order_status,count(*) from olist_products_dataset t1 join olist_order_items_dataset t2
on t1.product_id=t2.product_id join olist_orders_dataset t3
on t3.order_id=t2.order_id where product_category_name is null and product_name_lenght is null
and product_description_lenght is null and product_photos_qty is null
group by t3.order_status;

select count(distinct t1.product_id) from olist_products_dataset t1
join olist_order_items_dataset t2 on t1.product_id=t2.product_id where product_category_name is null
and product_name_lenght is null and product_description_lenght is null and product_photos_qty is null;
--answer 610

select sum(t2.price)
from olist_products_dataset t1
join olist_order_items_dataset t2
on t1.product_id=t2.product_id
where product_category_name is null;

select sum(t2.price)
from olist_products_dataset t1
join olist_order_items_dataset t2
on t1.product_id=t2.product_id;
--1.3% from total so keep it


-- check primary key and unicqness
select count(distinct product_id) from olist_products_dataset;
--product id is primary key and no duplicats

--check range of product_name_lenght
select min(product_name_lenght),max(product_name_lenght) from olist_products_dataset;
--valid range

--check range of product_description_lenght
select min(product_description_lenght),max(product_description_lenght) from olist_products_dataset;
--valid range

--check range of product_photos_qty
select min(product_photos_qty),max(product_photos_qty) from olist_products_dataset;
--valid range

--check range of product_weight_g
select min(product_weight_g),max(product_weight_g) from olist_products_dataset;
--min value is 0
--find problem scope
select count(*) from olist_products_dataset where product_weight_g = 0;
--answer is 4 record
select * from olist_products_dataset where product_weight_g = 0;
--solving it
update olist_products_dataset set product_weight_g=null where product_weight_g = 0;

--check range of product_length_cm
select min(product_length_cm),max(product_length_cm) from olist_products_dataset;
--valid range

--check range of product_height_cm
select min(product_height_cm),max(product_height_cm) from olist_products_dataset;
--valid range

--check range of product_width_cm
select min(product_width_cm),max(product_width_cm) from olist_products_dataset;
--valid range

--check relationship 
select count(*) from olist_products_dataset t1 left join product_category_name_translation t2
on t1.product_category_name=t2.column1
where t1.product_category_name is not null;
--answer 32341
select distinct t1.product_category_name from olist_products_dataset t1 left join
product_category_name_translation t2 on t1.product_category_name=t2.column1
where t1.product_category_name is not null and t2.column1 is null;
--solving this 
insert into product_category_name_translation
values('pc_gamer','Gaming PCs'),
('portateis_cozinha_e_preparadores_de_alimentos','Portable Kitchen Appliances and Food Preparers');

select count(*) from olist_products_dataset t1 right join product_category_name_translation t2
on t1.product_category_name=t2.column1;
--answer 32329
select count(*) from olist_products_dataset t1 join product_category_name_translation t2
on t1.product_category_name=t2.column1;
--answer 32328
--relation is true but 2 category_name not have name_translation
--..................................................................................................................
-- check data quality of product_category_name_translation
--check missing values
select count(*),count(column1),count(column2)
from product_category_name_translation;
--no missing value

-- check primary key and unicqness
select count(distinct column1) from product_category_name_translation;
--column1 is primary key and no duplicates
--..................................................................................................................
-- check data quality of olist_customers_dataset
--check missing values
select count(*),count(customer_id),count(customer_unique_id),count(customer_zip_code_prefix),
count(customer_city),count(customer_state) from olist_customers_dataset;
--no missing value and count it 99441

-- check primary key and unicqness
select count(distinct customer_id) from olist_customers_dataset;--99441
select count(distinct customer_unique_id) from olist_customers_dataset;--96096
--customer_id is primary key and no duplicates

--check range of customer_zip_code_prefix
select min(customer_zip_code_prefix),max(customer_zip_code_prefix) from olist_customers_dataset;
--valid range no mines or 0 values

--distribution size
select count(distinct customer_state) from olist_customers_dataset; --27 state
select count(distinct customer_city) from olist_customers_dataset; --4119 large varity
--..................................................................................................................
-- check data quality of olist_sellers_dataset
--check missing values
select count(*),count(seller_id),count(seller_zip_code_prefix),count(seller_city),count(seller_state)
from olist_sellers_dataset;
--no missing value and count it 3095

-- check primary key and unicqness
select count(distinct seller_id) from olist_sellers_dataset;--3095
--seller_id is primary key and no duplicates

--check range of customer_zip_code_prefix
select min(seller_zip_code_prefix),max(seller_zip_code_prefix) from olist_sellers_dataset;
--valid range no mines or 0 values

--distribution size8018010
select count(distinct seller_state) from olist_sellers_dataset; --23 state
select count(distinct seller_city) from olist_sellers_dataset; --611 large varity
--..................................................................................................................
-- check data quality of olist_geolocation_dataset
--check missing values
select count(*),count(geolocation_zip_code_prefix),count(geolocation_lat),count(geolocation_lng),
count(geolocation_city),count(geolocation_state)
from olist_geolocation_dataset;
--answer 1000163	1000163	998827	1000160	1000163	1000163

-- check primary key and unicqness
select count(distinct geolocation_zip_code_prefix) from olist_geolocation_dataset;--19015
select count(distinct geolocation_city) from olist_geolocation_dataset;--8010
-- No unique identifier was found in the dataset.

--check range 
select min(geolocation_lat),max(geolocation_lat),
       min(geolocation_lng),max(geolocation_lng)
from olist_geolocation_dataset;
--valid range
--..................................................................................................................
--primary key constraint

alter table olist_orders_dataset
add constraint ordersPK primary key(order_id);

alter table olist_order_items_dataset
add constraint orderItemsPK primary key(order_id,order_item_id);

alter table olist_order_payments_dataset
add constraint orderPaymentsPK primary key(order_id,payment_sequential);

alter table olist_order_reviews_dataset
add constraint orderReviewsPK primary key(order_id,review_id);

alter table olist_products_dataset
add constraint productsPK primary key(product_id);

alter table product_category_name_translation
add constraint translationPK primary key(column1);

alter table olist_customers_dataset
add constraint customersPK primary key(customer_id);

alter table olist_sellers_dataset
add constraint sellersPK primary key(seller_id);

--..................................................................................................................
--forign key constraint

alter table olist_orders_dataset
add constraint ordersCustomersFK foreign key(customer_id) references olist_customers_dataset(customer_id);


alter table olist_order_items_dataset
add constraint orderItemsFK foreign key(order_id) references olist_orders_dataset(order_id);

alter table olist_order_items_dataset
add constraint productItemsFK foreign key(product_id) references olist_products_dataset(product_id);

alter table olist_order_items_dataset
add constraint sellerItemsFK foreign key(seller_id) references olist_sellers_dataset(seller_id);

alter table olist_order_reviews_dataset
add constraint ordersReviewsFK foreign key(order_id) references olist_orders_dataset(order_id);

alter table olist_order_payments_dataset
add constraint ordersPaymentsFK foreign key(order_id) references olist_orders_dataset(order_id);

alter table olist_products_dataset
add constraint productTranslationFK foreign key(product_category_name)
references product_category_name_translation(column1);
--..................................................................................................................
-- Check Constraints

-- Review Score
ALTER TABLE olist_order_reviews_dataset
ADD CONSTRAINT CK_ReviewScore
CHECK (review_score BETWEEN 1 AND 5);

-- Product Weight
ALTER TABLE olist_products_dataset
ADD CONSTRAINT CK_ProductWeight
CHECK (product_weight_g >= 0);

-- Product Length
ALTER TABLE olist_products_dataset
ADD CONSTRAINT CK_ProductLength
CHECK (product_length_cm >= 0);

-- Product Width
ALTER TABLE olist_products_dataset
ADD CONSTRAINT CK_ProductWidth
CHECK (product_width_cm >= 0);

-- Product Height
ALTER TABLE olist_products_dataset
ADD CONSTRAINT CK_ProductHeight
CHECK (product_height_cm >= 0);

-- Product Photos
ALTER TABLE olist_products_dataset
ADD CONSTRAINT CK_ProductPhotos
CHECK (product_photos_qty >= 0);

-- Product Name Length
ALTER TABLE olist_products_dataset
ADD CONSTRAINT CK_ProductNameLength
CHECK (product_name_lenght >= 0);

-- Product Description Length
ALTER TABLE olist_products_dataset
ADD CONSTRAINT CK_ProductDescriptionLength
CHECK (product_description_lenght >= 0);

-- Item Price
ALTER TABLE olist_order_items_dataset
ADD CONSTRAINT CK_ItemPrice
CHECK (price >= 0);

-- Freight Value
ALTER TABLE olist_order_items_dataset
ADD CONSTRAINT CK_FreightValue
CHECK (freight_value >= 0);

-- Payment Value
ALTER TABLE olist_order_payments_dataset
ADD CONSTRAINT CK_PaymentValue
CHECK (payment_value >= 0);

-- Payment Installments
ALTER TABLE olist_order_payments_dataset
ADD CONSTRAINT CK_PaymentInstallments
CHECK (payment_installments >= 0);

-- Payment Sequential
ALTER TABLE olist_order_payments_dataset
ADD CONSTRAINT CK_PaymentSequential
CHECK (payment_sequential > 0);
--..................................................................................................................
--questions?
--analyze the factors affecting revenue and customer satisfiction?
--revenue over time
select year(order_purchase_timestamp) as order_year,month(order_purchase_timestamp) as order_month
,cast(sum(price+freight_value) as decimal(18,2)) as revenue
from olist_orders_dataset t1 join olist_order_items_dataset t2
on t1.order_id=t2.order_id
group by year(order_purchase_timestamp),month(order_purchase_timestamp)
order by year(order_purchase_timestamp),month(order_purchase_timestamp);

select order_purchase_timestamp  
from olist_orders_dataset
where order_purchase_timestamp>'2018-08-30';

select year(order_purchase_timestamp) as order_year,month(order_purchase_timestamp) as order_month
,cast(sum(payment_value) as decimal(18,2)) as revenue
from olist_orders_dataset t1 join olist_order_payments_dataset t2
on t1.order_id=t2.order_id
group by year(order_purchase_timestamp),month(order_purchase_timestamp)
order by year(order_purchase_timestamp),month(order_purchase_timestamp);

select cast(sum(price+freight_value) as decimal(18,2)) as revenue from olist_order_items_dataset;
select cast(sum(payment_value) as decimal(18,2)) as revenue from olist_order_payments_dataset;

with items as
(select order_id,cast(sum(price+freight_value) as decimal(18,2)) as revenue 
from olist_order_items_dataset
group by order_id),
payments as
(select order_id,cast(sum(payment_value) as decimal(18,2)) as revenue 
from olist_order_payments_dataset
group by order_id)
select * from items i join payments p
on i.order_id=p.order_id
where i.revenue <> p.revenue;

--paymemte not equal items so we using items 

--.................................................................................................................

--KPI
select cast(sum(price+freight_value) as decimal(18,2)) as total_revenue from olist_order_items_dataset; 

select count(distinct order_id) as orders_count from olist_orders_dataset;

select count(distinct order_id) as canceled_orders_count from olist_orders_dataset
where order_status='canceled';


with w as(
select order_id,cast(sum(price+freight_value) as decimal(18,2)) as revenue
from olist_order_items_dataset
group by order_id)
select cast(avg(revenue) as decimal(18,2)) as AOV from w;

select count(distinct customer_unique_id) as customers_count 
from olist_customers_dataset t1 join olist_orders_dataset t2
on t1.customer_id=t2.customer_id;


--.................................................................................................................
--catogrise&revenue
select top 5 product_category_name,cast(sum(price+freight_value) as decimal(18,2)) as revenue
from olist_order_items_dataset t1 join olist_products_dataset t2
on t1.product_id=t2.product_id
group by product_category_name
order by revenue desc;
--.................................................................................................................
--states&revenue
select customer_state,cast(sum(price+freight_value) as decimal(18,2)) as revenue
from olist_order_items_dataset t1 join olist_orders_dataset t2
on t1.order_id=t2.order_id
join olist_customers_dataset t3
on t2.customer_id=t3.customer_id
group by customer_state
order by revenue desc;
--.................................................................................................................
--customers&revenue
select customer_unique_id,cast(sum(price+freight_value) as decimal(18,2)) as revenue
from olist_order_items_dataset t1 join olist_orders_dataset t2
on t1.order_id=t2.order_id
join olist_customers_dataset t3
on t3.customer_id=t2.customer_id
group by customer_unique_id
order by revenue desc;
--.................................................................................................................
--products&revenue
select top 10 product_id,cast(sum(price+freight_value) as decimal(18,2)) as revenue
from olist_order_items_dataset t1
group by product_id
order by revenue desc;
--..................................................................................................................
--products&sales by quentity
select top 10 product_id,count(*) as countable
from olist_order_items_dataset t1
group by product_id
order by countable desc;
--..................................................................................................................
--outlier in revenue over time
--outlier in revenue over time
--9&11&12 monthes in 2016
--9 month in 2018
--revenue in all very low for normal range
--..................................................................................................................
--repeat customers
WITH w AS (
    SELECT customer_unique_id,
           COUNT(order_id) AS orders_count
    FROM olist_orders_dataset t1
    JOIN olist_customers_dataset t2
        ON t1.customer_id = t2.customer_id
    GROUP BY customer_unique_id
)

SELECT
CAST(
    COUNT(CASE WHEN orders_count > 1 THEN 1 END) * 100.0
    / COUNT(*)
AS DECIMAL(5,2)) AS Repeat_Customer_Rate
FROM w;
--this means most customers no repeat purchase
--.................................................................................................................
--ored has more than 1 category
select order_id,count(distinct product_category_name)
 from olist_order_items_dataset t1 
 join olist_products_dataset t2
 on t1.product_id=t2.product_id
 group by order_id
 having count(distinct product_category_name)>1
order by order_id;
--.................................................................................................................
--order has more than 1 seller
select order_id,count(distinct seller_id)
from olist_order_items_dataset
group by order_id
having count(distinct seller_id)>1;
--.................................................................................................................
--score distribution
select review_score,count(distinct order_id) as countable
from olist_order_reviews_dataset
group by review_score
order by review_score;
--..................................................................................................................
--kpis

select avg(review_score) as review_avg from olist_order_reviews_dataset;

select count(*) as review_count
from(select distinct review_id,order_id from olist_order_reviews_dataset) as taple;
--.................................................................................................................
--reviews&fright value
with w as(
select order_id,cast(sum(freight_value) as decimal(18,2)) as total_freight 
from olist_order_items_dataset
group by order_id)
select review_score,cast(avg(total_freight) as decimal(18,2)) as avg_freight
from w join olist_order_reviews_dataset t
on w.order_id=t.order_id
group by review_score
order by review_score;
--freight affecting on review
--....................................................................................................................
--review&payment type
select payment_type,cast(avg(review_score) as decimal(18,2)) as avg_score
from olist_order_reviews_dataset t1 join olist_order_payments_dataset t2
on t1.order_id=t2.order_id
group by payment_type
order by avg_score;
--not_defined is very low score=1 but only 3 order from type not_defined so we ignore that
--...................................................................................................................
--review_score&state
select customer_state,cast(avg(review_score) as decimal(18,2)) as avg_score
from olist_order_reviews_dataset t1 join olist_orders_dataset t2
on t1.order_id=t2.order_id
join olist_customers_dataset t3
on t2.customer_id=t3.customer_id
group by customer_state
order by avg_score;
--all states avg_score=3 or 4
--.................................................................................................................
--review score over time
select year(review_creation_date) as year,month(review_creation_date) as month,
cast(avg(review_score) as decimal(18,2)) as avg_score
from olist_order_reviews_dataset 
group by year(review_creation_date),month(review_creation_date)
order by year(review_creation_date),month(review_creation_date);
--no found static relationships
--.................................................................................................................
--reviews&delivery time
select review_score,avg(datediff(day,order_purchase_timestamp,order_delivered_customer_date)) as delivery_time
from olist_order_reviews_dataset t1 join olist_orders_dataset t2
on t1.order_id=t2.order_id
group by review_score
order by review_score;
--more delivery time less review rate
--.................................................................................................................
--reviews&delay time
select review_score,avg(datediff(day,order_estimated_delivery_date,order_delivered_customer_date)) as delay_time
from olist_order_reviews_dataset t1 join olist_orders_dataset t2
on t1.order_id=t2.order_id
where order_delivered_customer_date>order_estimated_delivery_date
group by review_score
order by review_score;
--more delay time less review rate
--.................................................................................................................
--states&revenue&review
select customer_state,cast(sum(price+freight_value) as decimal(18,2)) as revenue,
cast(avg(review_score) as decimal(18,2)) as avg_score
from olist_order_items_dataset t1 join olist_orders_dataset t2
on t1.order_id=t2.order_id
join olist_customers_dataset t3
on t2.customer_id=t3.customer_id
join olist_order_reviews_dataset t4
on t2.order_id=t4.order_id
group by customer_state
order by revenue desc;
--no found static relationships
--.................................................................................................................
--customers&revenue
select customer_unique_id,cast(sum(price+freight_value) as decimal(18,2)) as revenue,
cast(avg(review_score) as decimal(18,2)) as avg_score
from olist_order_items_dataset t1 join olist_orders_dataset t2
on t1.order_id=t2.order_id
join olist_customers_dataset t3
on t3.customer_id=t2.customer_id
join olist_order_reviews_dataset t4
on t2.order_id=t4.order_id
group by customer_unique_id
order by revenue desc;
--no found static relationships
--.................................................................................................................
--repeat customer &reviews
select customer_unique_id,cast(avg(review_score) as decimal(18,2)) as avg_score
from olist_orders_dataset t1 join olist_customers_dataset t2
on t1.customer_id=t2.customer_id
join olist_order_reviews_dataset t3
on t3.order_id=t1.order_id
group by customer_unique_id
having count(t1.order_id)>1
order by count(t1.order_id)
--no found static relationships
--.................................................................................................................

use wish

select *
from wish_db

-- venitul total pe platforma--
-- total revenue--

select SUM(TotalSum_product) TotalIncome
from wish_db

--52297352.4499996--

-- total produse vandute--
-- total of products sold--
select SUM(units_sold) TotalQTY
from wish_db

-- top 5 produse cu cele mai mari incasari--
-- top 5 products by revenue--

select top 5  product_id,
				price,
				title_orig,
				merchant_id,
				units_sold,
				TotalSum_product
from wish_db
order by TotalSum_product desc

select product_url
from wish_db
where TotalSum_product=800000

-- top 5 produse cele mai vandute--
-- top 5 best-selling products--

select top 5  *
				
from wish_db
order by units_sold desc

select          product_id,
				price,
				title_orig,
				units_sold,
				product_url				
from wish_db
where units_sold >=100000
order by units_sold desc

select product_id,
	   title_orig,
       units_sold
from wish_db
group by product_id,title_orig,units_sold
order by units_sold desc

-- influenta retail_price in vanzarea produselor--
-- retail_price influence in sales--
select retail_price-price as price_dif,
       units_sold,
	   TotalSum_product
from wish_db
order by price_dif desc

--vanzarile au fost influentate de uses_ad_boosts?--
--have sales been influenced by uses_ad_boosts?--
--Vanzatorul a platit pentru ca produsul sau sa fie promovat?--
--the seller paid for the product to be promoted?--


select sum(units_sold) TotalQty,
       count(product_id) CateProduse,
       sum(TotalSum_Product) TotalSales
from wish_db
group by uses_ad_boosts

--produsul cel mai promovat--
--most promoted product--
select top 1 title_orig,
	   price,
       units_sold,
	   product_url
from wish_db
group by uses_ad_boosts,
         title_orig,
		 price,
		 units_sold,
		 product_url
having uses_ad_boosts=1
order by units_sold desc

--vanzari in functie de preferintele clientilor--
--sales by customer preferance--


select sum(units_sold) TotalQty,
       gender
from wish_db
group by gender
order by TotalQty desc

--product rating--

--create view--
create view vCountRating as
    select 
        SUM(rating_five_count) as TotalRating5,
        SUM(rating_four_count) as TotalRating4,
        SUM(rating_three_count) as TotalRating3,
        SUM(rating_two_count) as TotalRating2,
        SUM(rating_one_count) as TotalRating1,
        SUM(units_sold) as TotalQty
    from wish_db

create view vTcountRating as
select 
    '5 stars' as RatingCategory, TotalRating5 as RatingCount, TotalQty
from vCountRating
union all
select 
    '4 stars', TotalRating4, TotalQty
from vCountRating
union all
select 
    '3 stars', TotalRating3, TotalQty
from vCountRating
union all
select 
    '2 stars', TotalRating2, TotalQty
from vCountRating
union all
select 
    '1 star', TotalRating1, TotalQty
from vCountRating

    create view vRatingTotals as 
    select 
        '5 stars' as RatingCategory, 
        SUM(units_sold) as TotalQty
    from wish_db
    where rating_five_count > 0
    union all
    select 
        '4 stars', 
        SUM(units_sold)
    from wish_db
    where rating_four_count > 0
    union all
    select 
        '3 stars', 
        SUM(units_sold)
    from wish_db
    where rating_three_count > 0
    union all
    select 
        '2 stars', 
        SUM(units_sold)
    from wish_db
    where rating_two_count > 0
    union all
    select 
        '1 star', 
        SUM(units_sold)
    from wish_db
    where rating_one_count > 0

select c.RatingCategory,
       c.RatingCount,
	   q.TotalQty
from vTcountRating c
join vRatingTotals q
on c.RatingCategory=q.RatingCategory



--shipping mode--

select SUM(units_sold) TotalQty,
       sum(TotalSum_product) TotalSum
from wish_db
group by shipping_option_name

--total shipping price--

select SUM(shipping_option_price) TotalShippingPrice,
       COUNT(product_id)          NoOfShippings
from wish_db
group by shipping_option_name

select SUM(shipping_option_price) TotalShippingPrice
from wish_db

--merchant rating count--

select merchant_rating,
	   count( merchant_title)  MerchantNo,
	   SUM(units_sold ) TotalQty,
       SUM(TotalSum_product) TotalRevenue
from wish_db
group by merchant_rating
order by merchant_rating

--merchant top 5--

select top 5 merchant_title,
			SUM(TotalSum_product) TotalRevenue,
			SUM(units_sold) TotalQty
from wish_db
group by merchant_title
order by TotalRevenue desc

--merchant badges_count--

select  badges_count,
		count(merchant_id) NoOfMerchants
from wish_db
group by badges_count

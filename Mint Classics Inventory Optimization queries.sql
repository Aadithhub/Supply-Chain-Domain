-- Where are items stored, and can a warehouse be eliminated
Select w.warehouseCode,w.warehousePctCap,count(p.productCode) as product_count,sum(p.quantityInStock) as total_qty
from products p join warehouses w on p.warehouseCode=w.warehouseCode 
group by p.warehouseCode order by total_qty asc;

-- How are inventory numbers related to sales figures
with cte1 as 
(SELECT 
    p.productCode,p.warehouseCode,
    p.productName,
    p.quantityInStock,
    IFNULL(SUM(od.quantityOrdered), 0) AS totalSold
    FROM 
    products p
LEFT JOIN 
    orderdetails od ON p.productCode = od.productCode
GROUP BY 
    p.productCode,p.productName)

select *,quantityInStock-totalSold as excessStock from cte1
ORDER BY 
    excessStock DESC;

-- Are we storing items that are not moving ( Products with no sales or Products which are not sold for certain period of  time  like 6 months)
-- Products or items with no sales     
select p.productCode,p.productName,p.quantityInStock from products p left join
orderdetails o on p.productCode=o.productCode where
o.productCode is null;

-- Products which are not sold for certain period of  time  like 6 months(Stored Procedure)
DROP PROCEDURE IF EXISTS get_inactive_products;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_inactive_products`(
IN maxdate date,
In monthsinterval int)
BEGIN
SELECT 
    p.productCode,
    p.productName,
    MAX(o.orderDate) AS lastSoldDate
FROM 
    products p
JOIN 
    orderdetails od ON p.productCode = od.productCode
JOIN 
    orders o ON od.orderNumber = o.orderNumber
GROUP BY 
    p.productCode, p.productName
HAVING 
    MAX(o.orderDate) < maxdate - INTERVAL monthsinterval MONTH;

END //
DELIMITER ;
call mintclassics.get_inactive_products('2005-11-10', 6);

-- Which warehouses has  products which  have high stock levels but low profit margins?
with cte2 as 
(SELECT 
    p.productCode,p.warehouseCode,
    p.productName,
    p.quantityInStock,
    IFNULL(SUM(od.quantityOrdered), 0) AS totalSold,buyPrice,
        IFNULL(Avg(od.priceEach),0) as selling_price

    FROM 
    products p
LEFT JOIN 
    orderdetails od ON p.productCode = od.productCode
GROUP BY 
    p.productCode,p.productName)

Select *,quantityInStock-totalSold as excessStock,selling_price-buyPrice as Profit_margin from cte2 
order by Profit_margin asc,excessStock desc;

-- Which warehouse serves the least customers and generates the least revenue?
Select w.warehouseCode,w.warehouseName,
count(distinct o.customerNumber) as customerServed, sum(od.quantityOrdered * od.priceEach) as total_revenue
from warehouses w join products p on w.warehouseCode=p.warehouseCode join
orderdetails od on p.productCode=od.productCode join 
orders o on od.orderNumber=o.orderNumber
group by w.warehouseCode,w.warehouseName order by total_revenue asc; 

-- What is the average delivery delay per warehouse?
SELECT 
    w.warehouseCode,w.warehouseName,
    Round(AVG(DATEDIFF(o.shippedDate, o.orderDate)),1) AS avgFulfillmentDays,
        COUNT(CASE WHEN o.shippedDate > o.requiredDate THEN 1 END) AS delayedShipments,
        count(*) as total_oders,
            ROUND(COUNT(CASE WHEN o.shippedDate > o.requiredDate THEN 1 END) * 100.0 / COUNT(*), 2) AS delayPercentage
FROM 
    warehouses w
JOIN 
    products p ON w.warehouseCode = p.warehouseCode
JOIN 
    orderdetails od ON p.productCode = od.productCode
JOIN 
    orders o ON od.orderNumber = o.orderNumber
GROUP BY 
    w.warehouseCode,warehouseName
ORDER BY 
    delayPercentage desc;
    
-- What is the average inventory turnover ratio per warehouse?(Efficency)
SELECT 
    w.warehouseCode,
    SUM(od.quantityOrdered) AS totalUnitsSold,
    SUM(p.quantityInStock) AS totalStock,
    ROUND(SUM(od.quantityOrdered) / NULLIF(SUM(p.quantityInStock), 0), 3) AS inventoryTurnoverRatio
FROM 
    warehouses w
JOIN 
    products p ON w.warehouseCode = p.warehouseCode
LEFT JOIN 
    orderdetails od ON p.productCode = od.productCode
GROUP BY 
    w.warehouseCode
ORDER BY 
    inventoryTurnoverRatio ASC;

    




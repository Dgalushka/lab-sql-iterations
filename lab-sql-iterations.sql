-- 1. Write a query to find what is the total business done by each store
use sakila;

SELECT SUM(amount) total_sales, store_id 
FROM sakila.payment p
JOIN sakila.staff s USING (staff_id)
GROUP BY store_id;

-- 2. convert previous query into stored procedure.

DELIMITER // 

CREATE PROCEDURE total_sales_per_store ()
BEGIN 
SELECT SUM(amount) total_sales, store_id 
FROM sakila.payment p
JOIN sakila.staff s USING (staff_id)
GROUP BY store_id;
END //
DELIMITER ;

call total_sales_per_store();

-- 3. Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.

DELIMITER // 
CREATE PROCEDURE input_total_sales_per_store (in store_number int)
BEGIN 
SELECT SUM(amount) total_sales, store_id 
FROM sakila.payment p
JOIN sakila.staff s USING (staff_id)
GROUP BY store_id
HAVING store_id = store_number;
END //
DELIMITER ;

call input_total_sales_per_store(2);

-- 4. Update the previous query. Declare a variable total_sales_value of float type, 
-- that will store the returned result (of the total sales amount for the store). Call the stored procedure and print the results.

DELIMITER // 
CREATE PROCEDURE variable_total_sales_per_store (in store_number float, out total_sales_value float)
BEGIN 
SELECT round(SUM(amount),0) into total_sales_value
FROM sakila.payment p
JOIN sakila.staff s USING (staff_id)
WHERE store_id = store_number;
END //
DELIMITER ;

call variable_total_sales_per_store (2, @total_sales_value);

select @total_sales_value;

-- 5. In the previous query, add another variable flag. If the total sales value for the store is over 30.000, 
-- then label it as green_flag, otherwise label is as red_flag. Update the stored procedure that takes an input as the store_id 
-- and returns total sales value for that store and flag value.

DELIMITER // 
CREATE PROCEDURE flagged_variable_total_sales_per_store (in store_number float, out total_sales_value float, out param_flag char(10))
BEGIN 

SELECT round(SUM(amount),0) into total_sales_value
FROM sakila.payment p
JOIN sakila.staff s USING (staff_id)
WHERE store_id = store_number;

SELECT CASE
WHEN total_sales_value >= 30000 
	THEN 'flag_green'
ELSE 'flag_red'
END
INTO param_flag;

END //
DELIMITER ;

call ffflagged_variable_total_sales_per_store (2, @total_sales_value, @param_flag);

select @total_sales_value, @param_flag;











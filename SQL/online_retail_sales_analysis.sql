-- Online Retail Sales Analysis Database
-- Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL
);

-- Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    discount DECIMAL(5, 2) DEFAULT 0.00
);

-- Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_status VARCHAR(20) NOT NULL,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Order items table
CREATE TABLE Order_Items (
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    CONSTRAINT pk_order_items PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Sample data: Customers
INSERT INTO Customers (customer_id, name, city) VALUES
(1, 'Ava Thompson', 'New York'),
(2, 'Liam Carter', 'Chicago'),
(3, 'Mia Patel', 'Houston'),
(4, 'Noah Garcia', 'Phoenix'),
(5, 'Sophia Lee', 'San Diego'),
(6, 'Ethan Davis', 'Dallas'),
(7, 'Isabella Moore', 'Seattle'),
(8, 'Lucas Martin', 'Boston'),
(9, 'Amelia Clark', 'Denver'),
(10, 'Oliver Scott', 'Miami');

-- Sample data: Products
INSERT INTO Products (product_id, name, category, price, discount) VALUES
(101, 'Wireless Mouse', 'Electronics', 25.00, 2.50),
(102, 'Bluetooth Headphones', 'Electronics', 60.00, 5.00),
(103, 'USB-C Cable', 'Electronics', 12.00, 0.00),
(104, 'T-Shirt', 'Clothing', 18.00, 1.00),
(105, 'Jeans', 'Clothing', 45.00, 4.00),
(106, 'Sneakers', 'Clothing', 75.00, 6.00),
(107, 'Coffee Beans 1kg', 'Grocery', 16.50, 0.00),
(108, 'Olive Oil 1L', 'Grocery', 14.00, 0.50),
(109, 'Rice 5kg', 'Grocery', 22.00, 1.00),
(110, 'Notebook', 'Stationery', 6.50, 0.00),
(111, 'Desk Lamp', 'Home', 32.00, 2.00),
(112, 'Water Bottle', 'Home', 15.00, 1.50),
(113, 'Smartphone Stand', 'Electronics', 10.00, 0.00),
(114, 'Jacket', 'Clothing', 90.00, 8.00),
(115, 'Granola Bars Pack', 'Grocery', 9.50, 0.00);

-- Sample data: Orders
INSERT INTO Orders (order_id, customer_id, order_date, order_status) VALUES
(1001, 1, '2025-11-12', 'Delivered'),
(1002, 2, '2025-12-05', 'Delivered'),
(1003, 3, '2026-01-14', 'Delivered'),
(1004, 4, '2026-02-02', 'Delivered'),
(1005, 1, '2026-02-20', 'Cancelled'),
(1006, 5, '2026-02-28', 'Delivered'),
(1007, 6, '2026-03-05', 'Delivered'),
(1008, 3, '2026-03-08', 'Delivered'),
(1009, 7, '2026-03-10', 'Delivered'),
(1010, 8, '2026-03-12', 'Delivered'),
(1011, 2, '2026-03-18', 'Delivered'),
(1012, 9, '2026-03-22', 'Delivered'),
(1013, 1, '2026-03-25', 'Delivered'),
(1014, 4, '2026-04-01', 'Delivered'),
(1015, 5, '2026-04-03', 'Delivered'),
(1016, 6, '2026-04-05', 'Delivered'),
(1017, 2, '2026-04-08', 'Delivered'),
(1018, 7, '2026-04-10', 'Delivered');

-- Sample data: Order Items
INSERT INTO Order_Items (order_id, product_id, quantity) VALUES
(1001, 101, 2),
(1001, 103, 3),
(1001, 110, 4),
(1002, 102, 1),
(1002, 104, 2),
(1003, 107, 2),
(1003, 109, 1),
(1003, 110, 5),
(1004, 105, 1),
(1004, 111, 1),
(1005, 106, 1),
(1005, 113, 2),
(1006, 107, 3),
(1006, 115, 4),
(1007, 108, 2),
(1007, 109, 2),
(1008, 101, 1),
(1008, 102, 1),

-- Core Query 1: Top-selling products by total quantity sold
-- Uses SUM(quantity) and GROUP BY to rank products
SELECT
    p.name AS product_name,
    SUM(oi.quantity) AS total_sold
FROM Products p
INNER JOIN Order_Items oi ON p.product_id = oi.product_id
INNER JOIN Orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.name
ORDER BY total_sold DESC;

-- Core Query 2: Most valuable customers by total spend
-- Uses JOINs and SUM(price * quantity) for revenue per customer
SELECT
    c.name AS customer_name,
    SUM((p.price - p.discount) * oi.quantity) AS total_spent
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
INNER JOIN Order_Items oi ON o.order_id = oi.order_id
INNER JOIN Products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY c.name
ORDER BY total_spent DESC;

-- Core Query 3: Monthly revenue
-- Groups revenue by year-month using DATE functions
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM((p.price - p.discount) * oi.quantity) AS revenue
FROM Orders o
INNER JOIN Order_Items oi ON o.order_id = oi.order_id
INNER JOIN Products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;

-- Core Query 4: Category-wise sales analysis
-- Aggregates revenue per product category
SELECT
    p.category AS category,
    SUM((p.price - p.discount) * oi.quantity) AS category_revenue
FROM Products p
INNER JOIN Order_Items oi ON p.product_id = oi.product_id
INNER JOIN Orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.category
ORDER BY category_revenue DESC;

-- Core Query 5: Inactive customers (no orders in last 6 months)
-- LEFT JOIN with date filter to find inactive customers
SELECT
    c.customer_id,
    c.name AS customer_name,
    c.city
FROM Customers c
LEFT JOIN Orders o
    ON c.customer_id = o.customer_id
    AND o.order_date >= DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH)
    AND o.order_status = 'Delivered'
WHERE o.order_id IS NULL
ORDER BY c.customer_id;

-- Optional Query: Top 3 cities by revenue
SELECT
    c.city AS city,
    SUM((p.price - p.discount) * oi.quantity) AS city_revenue
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
INNER JOIN Order_Items oi ON o.order_id = oi.order_id
INNER JOIN Products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY c.city
ORDER BY city_revenue DESC
LIMIT 3;

-- Optional Query: Average order value (AOV)
SELECT
    AVG(order_total) AS average_order_value
FROM (
    SELECT
        o.order_id,
        SUM((p.price - p.discount) * oi.quantity) AS order_total
    FROM Orders o
    INNER JOIN Order_Items oi ON o.order_id = oi.order_id
    INNER JOIN Products p ON oi.product_id = p.product_id
    WHERE o.order_status = 'Delivered'
    GROUP BY o.order_id
) totals;

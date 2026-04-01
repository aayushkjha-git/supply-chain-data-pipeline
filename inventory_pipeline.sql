-- ==========================================================
-- PART 1: DATABASE SCHEMA (TABLE CREATION)
-- ==========================================================

-- Create the Suppliers table to track vendors and delivery speed
CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(100),
    lead_time_days INT
);

-- Create the Products table to monitor inventory levels
CREATE TABLE Products (
    sku VARCHAR(50) PRIMARY KEY,
    product_name VARCHAR(100),
    quantity_in_stock INT,
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

-- Create the Orders table to log outgoing shipments
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    sku VARCHAR(50),
    quantity_shipped INT,
    order_date DATE,
    FOREIGN KEY (sku) REFERENCES Products(sku)
);

-- ==========================================================
-- PART 2: MOCK DATA INSERTION (FOR TESTING)
-- ==========================================================

INSERT INTO Suppliers (supplier_id, supplier_name, lead_time_days) VALUES
(1, 'Agri-Barley Farms', 7),
(2, 'ClearGlass Packaging', 14),
(3, 'Premium Hops Dist.', 5);

INSERT INTO Products (sku, product_name, quantity_in_stock, supplier_id) VALUES
('SKU-BRLY', 'Malted Barley', 1500, 1),
('SKU-GLS650', '650ml Glass Bottles', 45, 2), -- Intentionally low stock for testing
('SKU-HOPS', 'Cascade Hops', 300, 3);

INSERT INTO Orders (order_id, sku, quantity_shipped, order_date) VALUES
(1001, 'SKU-GLS650', 500, '2026-02-15'),
(1002, 'SKU-BRLY', 200, '2026-03-05'),
(1003, 'SKU-GLS650', 300, '2026-03-20');

-- ==========================================================
-- PART 3: OPERATIONAL QUERIES (THE ANALYSIS)
-- ==========================================================

-- 1. Automated Low-Stock Flagging
-- Identifies products falling below a critical threshold (e.g., 50 units) 
-- and pulls the supplier's lead time so the procurement team knows how fast to reorder.
SELECT 
    p.sku, 
    p.product_name, 
    p.quantity_in_stock, 
    s.supplier_name, 
    s.lead_time_days
FROM Products p
JOIN Suppliers s ON p.supplier_id = s.supplier_id
WHERE p.quantity_in_stock < 50;

-- 2. Average Supplier Lead Time Analysis
-- Calculates the average time it takes for the supply network to deliver materials.
SELECT 
    ROUND(AVG(lead_time_days), 1) AS avg_network_lead_time_days
FROM Suppliers;

-- 3. Monthly Throughput Tracking
-- Aggregates outgoing shipment volumes by month and product to monitor warehouse efficiency.
SELECT 
    EXTRACT(MONTH FROM order_date) AS shipment_month,
    sku,
    SUM(quantity_shipped) AS total_monthly_volume
FROM Orders
GROUP BY EXTRACT(MONTH FROM order_date), sku
ORDER BY shipment_month DESC, total_monthly_volume DESC;
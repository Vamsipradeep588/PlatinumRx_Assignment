-- ────────────────────────────────────────────────────────────
-- 1. Create Database
-- ────────────────────────────────────────────────────────────
CREATE DATABASE IF NOT EXISTS hotel_db;
USE hotel_db;
 
-- ────────────────────────────────────────────────────────────
-- 2. Drop tables in safe order (child → parent)
-- ────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS booking_commercials;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS users;
 
-- ────────────────────────────────────────────────────────────
-- 3. Create Tables
-- ────────────────────────────────────────────────────────────
 
CREATE TABLE users ( 
    user_id         VARCHAR(50)  PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    phone_number    VARCHAR(15),
    mail_id         VARCHAR(100),
    billing_address TEXT
);

 
CREATE TABLE bookings ( 
    booking_id   VARCHAR(50)  PRIMARY KEY,
    booking_date DATETIME     NOT NULL,
    room_no      VARCHAR(50)  NOT NULL,
    user_id      VARCHAR(50)  NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
 
CREATE TABLE items (
    item_id   VARCHAR(50)     PRIMARY KEY,
    item_name VARCHAR(100)    NOT NULL,
    item_rate DECIMAL(10, 2)  NOT NULL
);
 
CREATE TABLE booking_commercials (
    id            VARCHAR(50)   PRIMARY KEY,
    booking_id    VARCHAR(50)   NOT NULL,
    bill_id       VARCHAR(50)   NOT NULL,
    bill_date     DATETIME      NOT NULL,
    item_id       VARCHAR(50)   NOT NULL,
    item_quantity DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (item_id)    REFERENCES items(item_id)
);
 
-- ────────────────────────────────────────────────────────────
-- 4. Insert Sample Data
-- ────────────────────────────────────────────────────────────
 
-- Users
INSERT INTO users (user_id, name, phone_number, mail_id, billing_address) VALUES
('usr-001', 'John Doe',   '9700000001', 'john.doe@example.com',   '10, Street A, Mumbai'),
('usr-002', 'Jane Smith', '9700000002', 'jane.smith@example.com', '20, Street B, Delhi'),
('usr-003', 'Bob Brown',  '9700000003', 'bob.b@example.com',      '30, Street C, Pune'),
('usr-004', 'Alice Ray',  '9700000004', 'alice.r@example.com',    '40, Street D, Chennai'),
('usr-005', 'Charlie K',  '9700000005', 'charlie.k@example.com',  '50, Street E, Kolkata');
 
-- Items
INSERT INTO items (item_id, item_name, item_rate) VALUES
('itm-001', 'Tawa Paratha',  18.00),
('itm-002', 'Mix Veg',       89.00),
('itm-003', 'Paneer Butter', 160.00),
('itm-004', 'Dal Tadka',     75.00),
('itm-005', 'Veg Biryani',   130.00),
('itm-006', 'Masala Chai',   20.00),
('itm-007', 'Cold Coffee',   60.00),
('itm-008', 'Chicken Curry', 200.00),
('itm-009', 'Butter Naan',   30.00),
('itm-010', 'Fruit Salad',   90.00);
 
-- Bookings (spread across 2021 months to support queries)
INSERT INTO bookings (booking_id, booking_date, room_no, user_id) VALUES
-- September 2021
('bk-0001', '2021-09-05 10:00:00', 'rm-101', 'usr-001'),
('bk-0002', '2021-09-15 11:30:00', 'rm-102', 'usr-002'),
-- October 2021
('bk-0003', '2021-10-03 09:00:00', 'rm-103', 'usr-003'),
('bk-0004', '2021-10-18 14:00:00', 'rm-104', 'usr-004'),
('bk-0005', '2021-10-25 08:00:00', 'rm-101', 'usr-001'),
-- November 2021
('bk-0006', '2021-11-01 13:00:00', 'rm-105', 'usr-005'),
('bk-0007', '2021-11-10 15:00:00', 'rm-102', 'usr-002'),
('bk-0008', '2021-11-20 09:30:00', 'rm-103', 'usr-003'),
-- December 2021
('bk-0009', '2021-12-05 11:00:00', 'rm-104', 'usr-004'),
('bk-0010', '2021-12-22 16:00:00', 'rm-105', 'usr-005'),
-- Extra booking for usr-001 to test "last booked room"
('bk-0011', '2021-12-30 10:00:00', 'rm-201', 'usr-001');
 
-- Booking Commercials (bills)
-- September bills
INSERT INTO booking_commercials (id, booking_id, bill_id, bill_date, item_id, item_quantity) VALUES 
('bc-0001', 'bk-0001', 'bl-sep-01', '2021-09-05 12:00:00', 'itm-001', 3),
('bc-0002', 'bk-0001', 'bl-sep-01', '2021-09-05 12:00:00', 'itm-002', 2),
('bc-0003', 'bk-0002', 'bl-sep-02', '2021-09-15 13:00:00', 'itm-003', 4),
('bc-0004', 'bk-0002', 'bl-sep-02', '2021-09-15 13:00:00', 'itm-006', 5),
 
-- October bills (some > 1000)
('bc-0005', 'bk-0003', 'bl-oct-01', '2021-10-03 10:00:00', 'itm-008', 5),
('bc-0006', 'bk-0003', 'bl-oct-01', '2021-10-03 10:00:00', 'itm-005', 3),
('bc-0007', 'bk-0004', 'bl-oct-02', '2021-10-18 15:00:00', 'itm-003', 2),
('bc-0008', 'bk-0004', 'bl-oct-02', '2021-10-18 15:00:00', 'itm-004', 4),
('bc-0009', 'bk-0005', 'bl-oct-03', '2021-10-25 09:00:00', 'itm-007', 1),
('bc-0010', 'bk-0005', 'bl-oct-03', '2021-10-25 09:00:00', 'itm-001', 2),
 
-- November bills
('bc-0011', 'bk-0006', 'bl-nov-01', '2021-11-01 14:00:00', 'itm-003', 3),
('bc-0012', 'bk-0006', 'bl-nov-01', '2021-11-01 14:00:00', 'itm-005', 2),
('bc-0013', 'bk-0007', 'bl-nov-02', '2021-11-10 16:00:00', 'itm-008', 4),
('bc-0014', 'bk-0007', 'bl-nov-02', '2021-11-10 16:00:00', 'itm-009', 6),
('bc-0015', 'bk-0008', 'bl-nov-03', '2021-11-20 10:00:00', 'itm-010', 3),
('bc-0016', 'bk-0008', 'bl-nov-03', '2021-11-20 10:00:00', 'itm-006', 4),
 
-- December bills
('bc-0017', 'bk-0009', 'bl-dec-01', '2021-12-05 12:00:00', 'itm-003', 5),
('bc-0018', 'bk-0009', 'bl-dec-01', '2021-12-05 12:00:00', 'itm-007', 3),
('bc-0019', 'bk-0010', 'bl-dec-02', '2021-12-22 17:00:00', 'itm-008', 6),
('bc-0020', 'bk-0010', 'bl-dec-02', '2021-12-22 17:00:00', 'itm-005', 2),
('bc-0021', 'bk-0011', 'bl-dec-03', '2021-12-30 11:00:00', 'itm-001', 10),
('bc-0022', 'bk-0011', 'bl-dec-03', '2021-12-30 11:00:00', 'itm-002', 5);

show databases;

USE hotel_db;

 --  Hotel Management System  |  Queries (Q1 – Q5)
 
-- ────────────────────────────────────────────────────────────
-- Q1. For every user, get user_id and last booked room_no
-- ────────────────────────────────────────────────────────────
-- Logic: Find the booking with MAX(booking_date) per user,
--        then pull the room_no for that booking.
-- ────────────────────────────────────────────────────────────
 
SELECT
    u.user_id,
    u.name,
    b.room_no        AS last_booked_room
FROM users u
JOIN bookings b
    ON b.booking_id = (
        SELECT booking_id
        FROM   bookings
        WHERE  user_id = u.user_id
        ORDER  BY booking_date DESC
        LIMIT  1
    );
 
-- ────────────────────────────────────────────────────────────
-- Q2. Booking_id and total billing amount for every booking
--     created in November 2021
-- ────────────────────────────────────────────────────────────
-- Logic: Join bookings → booking_commercials → items,
--        filter booking_date to November 2021,
--        SUM(item_quantity * item_rate) per booking.
-- ────────────────────────────────────────────────────────────
 
SELECT
    b.booking_id,
    SUM(bc.item_quantity * i.item_rate) AS total_billing_amount
FROM bookings b
JOIN booking_commercials bc ON bc.booking_id = b.booking_id
JOIN items i                ON i.item_id     = bc.item_id
WHERE YEAR(b.booking_date)  = 2021
  AND MONTH(b.booking_date) = 11          -- November
GROUP BY b.booking_id;
 
 
-- ────────────────────────────────────────────────────────────
-- Q3. Bill_id and bill amount of all bills raised in
--     October 2021 where bill amount > 1000
-- ────────────────────────────────────────────────────────────
-- Logic: Group by bill_id (a bill can have multiple line items),
--        filter by bill_date October 2021, use HAVING > 1000.
-- ────────────────────────────────────────────────────────────
 
SELECT
    bc.bill_id,
    SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON i.item_id = bc.item_id
WHERE YEAR(bc.bill_date)  = 2021
  AND MONTH(bc.bill_date) = 10            -- October
GROUP BY bc.bill_id
HAVING bill_amount > 1000;
 
 
-- ────────────────────────────────────────────────────────────
-- Q4. Most ordered and least ordered item for each month
--     of year 2021
-- ────────────────────────────────────────────────────────────
-- Logic:
--   Step 1 – Aggregate total quantity ordered per (month, item).
--   Step 2 – Rank items within each month (highest → most ordered,
--             lowest → least ordered).
--   Step 3 – Pick rank = 1 from each direction.
-- ────────────────────────────────────────────────────────────
 
WITH monthly_item_qty AS (
    SELECT
        MONTH(bc.bill_date)              AS order_month,
        i.item_id,
        i.item_name,
        SUM(bc.item_quantity)            AS total_qty
    FROM booking_commercials bc
    JOIN items i ON i.item_id = bc.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY order_month, i.item_id, i.item_name
),
ranked AS (
    SELECT
        order_month,
        item_name,
        total_qty,
        RANK() OVER (PARTITION BY order_month ORDER BY total_qty DESC) AS rank_most,
        RANK() OVER (PARTITION BY order_month ORDER BY total_qty ASC)  AS rank_least
    FROM monthly_item_qty
)
SELECT
    order_month,
    MAX(CASE WHEN rank_most  = 1 THEN item_name END) AS most_ordered_item,
    MAX(CASE WHEN rank_least = 1 THEN item_name END) AS least_ordered_item
FROM ranked
WHERE rank_most = 1 OR rank_least = 1
GROUP BY order_month
ORDER BY order_month;
 
 
-- ────────────────────────────────────────────────────────────
-- Q5. Customers with the 2nd highest bill value for each
--     month of year 2021
-- ────────────────────────────────────────────────────────────
-- Logic:
--   Step 1 – Calculate total bill amount per (month, user).
--   Step 2 – Rank users by bill amount within each month (DESC).
--   Step 3 – Filter where rank = 2.
-- ────────────────────────────────────────────────────────────
 
WITH user_monthly_bill AS (
    SELECT
        MONTH(bc.bill_date)             AS bill_month, 
        b.user_id,
        u.name,
        SUM(bc.item_quantity * i.item_rate) AS total_bill
    FROM booking_commercials bc
    JOIN bookings b ON b.booking_id = bc.booking_id
    JOIN users    u ON u.user_id    = b.user_id
    JOIN items    i ON i.item_id    = bc.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY bill_month, b.user_id, u.name
),
ranked AS (
    SELECT
        bill_month,
        user_id,
        name,
        total_bill,
        DENSE_RANK() OVER (PARTITION BY bill_month ORDER BY total_bill DESC) AS bill_rank
    FROM user_monthly_bill
)
SELECT
    bill_month,
    user_id,
    name          AS customer_name,
    total_bill    AS second_highest_bill
FROM ranked
WHERE bill_rank = 2
ORDER BY bill_month;




 -- Clinic Management System  |  Schema + Sample Data Details
-- ============================================================
 
CREATE DATABASE IF NOT EXISTS clinic_db;
USE clinic_db;
 
-- ────────────────────────────────────────────────────────────
-- Drop tables (child → parent order)
-- ────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS clinic_sales;
DROP TABLE IF EXISTS expenses;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS clinics;
 
-- ────────────────────────────────────────────────────────────
-- Create Tables
-- ────────────────────────────────────────────────────────────
 
CREATE TABLE clinics (
    cid         VARCHAR(50)  PRIMARY KEY,
    clinic_name VARCHAR(100) NOT NULL,
    city        VARCHAR(100),
    state       VARCHAR(100),
    country     VARCHAR(100)
);
 
CREATE TABLE customer (
    uid    VARCHAR(50)  PRIMARY KEY,
    name   VARCHAR(100) NOT NULL,
    mobile VARCHAR(15)
);
 
CREATE TABLE clinic_sales (
    oid          VARCHAR(50)    PRIMARY KEY,
    uid          VARCHAR(50)    NOT NULL,
    cid          VARCHAR(50)    NOT NULL,
    amount       DECIMAL(12, 2) NOT NULL,
    datetime     DATETIME       NOT NULL,
    sales_channel VARCHAR(50)   NOT NULL,
    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);
 
CREATE TABLE expenses (
    eid         VARCHAR(50)    PRIMARY KEY,
    cid         VARCHAR(50)    NOT NULL,
    description VARCHAR(200),
    amount      DECIMAL(12, 2) NOT NULL,
    datetime    DATETIME       NOT NULL,
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);
 
-- ────────────────────────────────────────────────────────────
-- Insert Sample Data
-- ────────────────────────────────────────────────────────────
 
-- Clinics  (3 cities, 2 states)
INSERT INTO clinics (cid, clinic_name, city, state, country) VALUES
('cnc-001', 'HealthFirst Clinic',  'Mumbai',    'Maharashtra', 'India'),
('cnc-002', 'CureCare Clinic',     'Pune',      'Maharashtra', 'India'),
('cnc-003', 'MedLife Clinic',      'Delhi',     'Delhi',       'India'),
('cnc-004', 'WellNest Clinic',     'Noida',     'Delhi',       'India'),
('cnc-005', 'PrimeCare Clinic',    'Mumbai',    'Maharashtra', 'India');
 
-- Customers
INSERT INTO customer (uid, name, mobile) VALUES
('cust-001', 'John Doe',    '9700000001'),
('cust-002', 'Jane Smith',  '9700000002'),
('cust-003', 'Bob Brown',   '9700000003'),
('cust-004', 'Alice Ray',   '9700000004'),
('cust-005', 'Charlie K',   '9700000005'),
('cust-006', 'Diana Prince','9700000006'),
('cust-007', 'Evan Hunt',   '9700000007'),
('cust-008', 'Fiona Green', '9700000008');
 
-- Sales (various channels: online, walk-in, sodat, referral)
INSERT INTO clinic_sales (oid, uid, cid, amount, datetime, sales_channel) VALUES
-- January 2021
('ord-0001', 'cust-001', 'cnc-001', 24999, '2021-01-05 10:00:00', 'online'),
('ord-0002', 'cust-002', 'cnc-001', 15000, '2021-01-10 11:00:00', 'walk-in'),
('ord-0003', 'cust-003', 'cnc-002', 18000, '2021-01-15 09:00:00', 'sodat'),
('ord-0004', 'cust-004', 'cnc-003', 22000, '2021-01-20 14:00:00', 'referral'),
('ord-0005', 'cust-005', 'cnc-004',  9000, '2021-01-25 16:00:00', 'online'),
-- February 2021
('ord-0006', 'cust-001', 'cnc-001', 30000, '2021-02-03 10:00:00', 'online'),
('ord-0007', 'cust-006', 'cnc-002', 12000, '2021-02-08 11:00:00', 'walk-in'),
('ord-0008', 'cust-007', 'cnc-003', 25000, '2021-02-14 09:00:00', 'referral'),
('ord-0009', 'cust-002', 'cnc-005', 17000, '2021-02-20 13:00:00', 'sodat'),
-- March 2021
('ord-0010', 'cust-003', 'cnc-001', 28000, '2021-03-01 08:00:00', 'online'),
('ord-0011', 'cust-008', 'cnc-002', 35000, '2021-03-10 11:00:00', 'walk-in'),
('ord-0012', 'cust-004', 'cnc-003', 14000, '2021-03-18 14:00:00', 'online'),
('ord-0013', 'cust-005', 'cnc-004', 19000, '2021-03-22 15:00:00', 'sodat'),
('ord-0014', 'cust-006', 'cnc-005', 42000, '2021-03-28 16:00:00', 'referral'),
-- April 2021
('ord-0015', 'cust-001', 'cnc-001', 55000, '2021-04-05 10:00:00', 'online'),
('ord-0016', 'cust-007', 'cnc-002', 11000, '2021-04-12 09:00:00', 'walk-in'),
('ord-0017', 'cust-008', 'cnc-004', 33000, '2021-04-19 13:00:00', 'referral'),
('ord-0018', 'cust-002', 'cnc-005', 27000, '2021-04-25 15:00:00', 'sodat');
 
-- Expenses
INSERT INTO expenses (eid, cid, description, amount, datetime) VALUES
-- January
('exp-0001', 'cnc-001', 'Medicines & Supplies',  5000, '2021-01-31 18:00:00'),
('exp-0002', 'cnc-002', 'Rent',                  8000, '2021-01-31 18:00:00'),
('exp-0003', 'cnc-003', 'Staff Salary',          12000,'2021-01-31 18:00:00'),
('exp-0004', 'cnc-004', 'Utilities',              3000, '2021-01-31 18:00:00'),
-- February
('exp-0005', 'cnc-001', 'Staff Salary',          11000,'2021-02-28 18:00:00'),
('exp-0006', 'cnc-002', 'Medicines & Supplies',   4500, '2021-02-28 18:00:00'),
('exp-0007', 'cnc-003', 'Rent',                   9000, '2021-02-28 18:00:00'),
('exp-0008', 'cnc-005', 'Utilities',              2500, '2021-02-28 18:00:00'),
-- March
('exp-0009', 'cnc-001', 'Medicines & Supplies',  6000, '2021-03-31 18:00:00'),
('exp-0010', 'cnc-002', 'Rent',                  8000, '2021-03-31 18:00:00'),
('exp-0011', 'cnc-003', 'Staff Salary',          13000,'2021-03-31 18:00:00'),
('exp-0012', 'cnc-004', 'Utilities',              3500, '2021-03-31 18:00:00'),
('exp-0013', 'cnc-005', 'Maintenance',            5000, '2021-03-31 18:00:00'),
-- April
('exp-0014', 'cnc-001', 'Staff Salary',          12000,'2021-04-30 18:00:00'),
('exp-0015', 'cnc-002', 'Medicines & Supplies',   4000, '2021-04-30 18:00:00'),
('exp-0016', 'cnc-004', 'Rent',                   7000, '2021-04-30 18:00:00'),
('exp-0017', 'cnc-005', 'Utilities',              3000, '2021-04-30 18:00:00');



--  Clinic Management System  |  Queries (Q1 – Q5)
-- ============================================================
USE clinic_db;
 
-- ────────────────────────────────────────────────────────────
-- Q1. Revenue from each sales channel in a given year
-- ────────────────────────────────────────────────────────────
-- Logic: GROUP BY sales_channel, SUM(amount), filter by year.
-- ────────────────────────────────────────────────────────────
 
SELECT
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021          -- ← change year as needed
GROUP BY sales_channel
ORDER BY total_revenue DESC;
 
 
-- ────────────────────────────────────────────────────────────
-- Q2. Top 10 most valuable customers in a given year
-- ────────────────────────────────────────────────────────────
-- Logic: SUM(amount) per customer, ORDER BY DESC, LIMIT 10.
-- ────────────────────────────────────────────────────────────
 
SELECT
    cs.uid,
    c.name          AS customer_name,
    c.mobile,
    SUM(cs.amount)  AS total_spend
FROM clinic_sales cs
JOIN customer c ON c.uid = cs.uid
WHERE YEAR(cs.datetime) = 2021
GROUP BY cs.uid, c.name, c.mobile
ORDER BY total_spend DESC
LIMIT 10;
 
 
-- ────────────────────────────────────────────────────────────
-- Q3. Month-wise Revenue, Expense, Profit,
--     and Status (profitable / not-profitable)
-- ────────────────────────────────────────────────────────────
-- Logic:
--   CTE-1 : Aggregate revenue per month from clinic_sales.
--   CTE-2 : Aggregate expenses per month from expenses.
--   Final  : JOIN both CTEs on month, calculate profit,
--            add a status flag.
-- ────────────────────────────────────────────────────────────
 
WITH monthly_revenue AS (
    SELECT
        MONTH(datetime) AS txn_month,
        SUM(amount)     AS total_revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021
    GROUP BY txn_month
),
monthly_expense AS (
    SELECT
        MONTH(datetime) AS exp_month,
        SUM(amount)     AS total_expense
    FROM expenses
    WHERE YEAR(datetime) = 2021
    GROUP BY exp_month
)
SELECT
    mr.txn_month                                    AS month_number,
    MONTHNAME(STR_TO_DATE(mr.txn_month,'%m'))       AS month_name,
    mr.total_revenue,
    COALESCE(me.total_expense, 0)                   AS total_expense,
    (mr.total_revenue - COALESCE(me.total_expense, 0)) AS profit,
    CASE
        WHEN (mr.total_revenue - COALESCE(me.total_expense, 0)) > 0
        THEN 'Profitable'
        ELSE 'Not-Profitable'
    END                                             AS status
FROM monthly_revenue mr
LEFT JOIN monthly_expense me ON me.exp_month = mr.txn_month
ORDER BY mr.txn_month;
 
 
-- ────────────────────────────────────────────────────────────
-- Q4. For each city, find the most profitable clinic
--     for a given month
-- ────────────────────────────────────────────────────────────
-- Logic:
--   CTE-1 : Revenue per (month, clinic).
--   CTE-2 : Expenses per (month, clinic).
--   CTE-3 : Profit = Revenue − Expenses.
--   CTE-4 : Rank clinics within each city by profit DESC.
--   Final  : Filter rank = 1.
-- ────────────────────────────────────────────────────────────
 
WITH clinic_revenue AS (
    SELECT
        MONTH(datetime) AS txn_month,
        cid,
        SUM(amount)     AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021
    GROUP BY txn_month, cid
),
clinic_expense AS (
    SELECT
        MONTH(datetime) AS exp_month,
        cid,
        SUM(amount)     AS expense
    FROM expenses
    WHERE YEAR(datetime) = 2021
    GROUP BY exp_month, cid
),
clinic_profit AS (
    SELECT
        cr.txn_month,
        cr.cid,
        cr.revenue,
        COALESCE(ce.expense, 0)              AS expense,
        cr.revenue - COALESCE(ce.expense, 0) AS profit
    FROM clinic_revenue cr
    LEFT JOIN clinic_expense ce
           ON ce.cid = cr.cid AND ce.exp_month = cr.txn_month
),
city_ranked AS (
    SELECT
        cp.txn_month,
        c.city,
        c.clinic_name,
        cp.profit,
        RANK() OVER (PARTITION BY cp.txn_month, c.city
                     ORDER BY cp.profit DESC) AS city_rank
    FROM clinic_profit cp
    JOIN clinics c ON c.cid = cp.cid
)
SELECT
    txn_month   AS month_number,
    city,
    clinic_name AS most_profitable_clinic,
    profit
FROM city_ranked
WHERE city_rank = 1
ORDER BY txn_month, city;
 
 
-- ────────────────────────────────────────────────────────────
-- Q5. For each state, find the 2nd LEAST profitable clinic
--     for a given month
-- ────────────────────────────────────────────────────────────
-- Logic: Same pipeline as Q4 but rank by profit ASC and
--        pick rank = 2 (second least profitable).
-- ────────────────────────────────────────────────────────────
 
WITH clinic_revenue AS (
    SELECT
        MONTH(datetime) AS txn_month,
        cid,
        SUM(amount)     AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021
    GROUP BY txn_month, cid
),
clinic_expense AS (
    SELECT
        MONTH(datetime) AS exp_month,
        cid,
        SUM(amount)     AS expense
    FROM expenses
    WHERE YEAR(datetime) = 2021
    GROUP BY exp_month, cid
),
clinic_profit AS (
    SELECT
        cr.txn_month,
        cr.cid,
        cr.revenue - COALESCE(ce.expense, 0) AS profit
    FROM clinic_revenue cr
    LEFT JOIN clinic_expense ce
           ON ce.cid = cr.cid AND ce.exp_month = cr.txn_month
),
state_ranked AS (
    SELECT
        cp.txn_month,
        c.state,
        c.clinic_name,
        cp.profit,
        RANK() OVER (PARTITION BY cp.txn_month, c.state
                     ORDER BY cp.profit ASC) AS state_rank
    FROM clinic_profit cp
    JOIN clinics c ON c.cid = cp.cid
)
SELECT
    txn_month   AS month_number,
    state,
    clinic_name AS second_least_profitable_clinic,
    profit
FROM state_ranked
WHERE state_rank = 2
ORDER BY txn_month, state;
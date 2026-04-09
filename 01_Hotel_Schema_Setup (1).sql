-- ============================================================
--  PlatinumRx Assignment | Phase 1 – Part A
--  Hotel Management System  |  Schema + Sample Data
-- ============================================================

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


--  PlatinumRx Assignment | Hotel Management System
--  File : 01_Hotel_Schema_Setup.sql
--  Desc : Table definitions + sample data


-- ── users ────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
    user_id         VARCHAR(50)  PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    phone_number    VARCHAR(20),
    mail_id         VARCHAR(100),
    billing_address TEXT
);

INSERT INTO users (user_id, name, phone_number, mail_id, billing_address) VALUES
('21wrcxuy-67erfn', 'John Doe',   '9712345678', 'john.doe@example.com',   '12, Street A, Mumbai'),
('21wrcxuy-67erfp', 'Jane Smith', '9823456789', 'jane.smith@example.com', '34, Street B, Delhi'),
('21wrcxuy-67erfq', 'Raj Kumar',  '9934567890', 'raj.kumar@example.com',  '56, Street C, Pune'),
('21wrcxuy-67erfr', 'Priya Nair', '9045678901', 'priya.nair@example.com', '78, Street D, Chennai');

-- ── bookings ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS bookings (
    booking_id   VARCHAR(50) PRIMARY KEY,
    booking_date DATETIME    NOT NULL,
    room_no      VARCHAR(50) NOT NULL,
    user_id      VARCHAR(50) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

INSERT INTO bookings (booking_id, booking_date, room_no, user_id) VALUES
('bk-09f3e-95hj', '2021-09-23 07:36:48', 'rm-bhf9-aerjn', '21wrcxuy-67erfn'),
('bk-10g4f-86ik', '2021-10-05 09:14:22', 'rm-chg0-bfskn', '21wrcxuy-67erfp'),
('bk-11h5g-77jl', '2021-10-18 14:52:10', 'rm-dih1-cgtlo', '21wrcxuy-67erfq'),
('bk-12i6h-68km', '2021-11-02 11:30:00', 'rm-ej2-dhump', '21wrcxuy-67erfn'),
('bk-13j7i-59ln', '2021-11-15 16:20:45', 'rm-fk3-eivnq', '21wrcxuy-67erfr'),
('bk-14k8j-40mo', '2021-11-28 08:05:33', 'rm-gl4-fjwor', '21wrcxuy-67erfp'),
('bk-15l9k-31np', '2021-12-10 10:00:00', 'rm-hm5-gkxps', '21wrcxuy-67erfq'),
('bk-16m0l-22oq', '2021-12-22 19:45:00', 'rm-in6-hlyqt', '21wrcxuy-67erfr');

-- ── items ────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS items (
    item_id   VARCHAR(50)    PRIMARY KEY,
    item_name VARCHAR(100)   NOT NULL,
    item_rate DECIMAL(10, 2) NOT NULL
);

INSERT INTO items (item_id, item_name, item_rate) VALUES
('itm-a9e8-q8fu',  'Tawa Paratha',    18.00),
('itm-a07vh-aer8', 'Mix Veg',         89.00),
('itm-w978-23u4',  'Masala Chai',     30.00),
('itm-b123-45cd',  'Paneer Butter',  149.00),
('itm-c456-78ef',  'Dal Tadka',       99.00),
('itm-d789-01gh',  'Biryani',        199.00),
('itm-e012-34ij',  'Mineral Water',   20.00),
('itm-f345-67kl',  'Fresh Juice',     60.00);

-- ── booking_commercials ───────────────────────────────────────
CREATE TABLE IF NOT EXISTS booking_commercials (
    id            VARCHAR(50)    PRIMARY KEY,
    booking_id    VARCHAR(50)    NOT NULL,
    bill_id       VARCHAR(50)    NOT NULL,
    bill_date     DATETIME       NOT NULL,
    item_id       VARCHAR(50)    NOT NULL,
    item_quantity DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (item_id)    REFERENCES items(item_id)
);

INSERT INTO booking_commercials (id, booking_id, bill_id, bill_date, item_id, item_quantity) VALUES
-- Sep booking
('q34r-3q4o8-q34u', 'bk-09f3e-95hj', 'bl-0a87y-q340', '2021-09-23 12:03:22', 'itm-a9e8-q8fu',  3),
('q3o4-ahf32-o2u4', 'bk-09f3e-95hj', 'bl-0a87y-q340', '2021-09-23 12:03:22', 'itm-a07vh-aer8', 1),
('134lr-oyfo8-3qk4','bk-09f3e-95hj', 'bl-34qhd-r7h8', '2021-09-23 12:05:37', 'itm-w978-23u4',  2),
-- Oct booking 1
('bc-001-oct-1',    'bk-10g4f-86ik', 'bl-oct-001',    '2021-10-05 10:00:00', 'itm-b123-45cd',  2),
('bc-002-oct-1',    'bk-10g4f-86ik', 'bl-oct-001',    '2021-10-05 10:00:00', 'itm-d789-01gh',  3),
('bc-003-oct-1',    'bk-10g4f-86ik', 'bl-oct-001',    '2021-10-05 10:00:00', 'itm-e012-34ij',  4),
-- Oct booking 2
('bc-001-oct-2',    'bk-11h5g-77jl', 'bl-oct-002',    '2021-10-18 15:00:00', 'itm-a9e8-q8fu',  5),
('bc-002-oct-2',    'bk-11h5g-77jl', 'bl-oct-002',    '2021-10-18 15:00:00', 'itm-c456-78ef',  2),
('bc-003-oct-2',    'bk-11h5g-77jl', 'bl-oct-002',    '2021-10-18 15:00:00', 'itm-f345-67kl',  1),
-- Nov booking 1
('bc-001-nov-1',    'bk-12i6h-68km', 'bl-nov-001',    '2021-11-02 12:00:00', 'itm-d789-01gh',  4),
('bc-002-nov-1',    'bk-12i6h-68km', 'bl-nov-001',    '2021-11-02 12:00:00', 'itm-a07vh-aer8', 3),
('bc-003-nov-1',    'bk-12i6h-68km', 'bl-nov-001',    '2021-11-02 12:00:00', 'itm-e012-34ij',  2),
-- Nov booking 2
('bc-001-nov-2',    'bk-13j7i-59ln', 'bl-nov-002',    '2021-11-15 17:00:00', 'itm-b123-45cd',  3),
('bc-002-nov-2',    'bk-13j7i-59ln', 'bl-nov-002',    '2021-11-15 17:00:00', 'itm-c456-78ef',  4),
-- Nov booking 3
('bc-001-nov-3',    'bk-14k8j-40mo', 'bl-nov-003',    '2021-11-28 09:00:00', 'itm-d789-01gh',  2),
('bc-002-nov-3',    'bk-14k8j-40mo', 'bl-nov-003',    '2021-11-28 09:00:00', 'itm-f345-67kl',  3),
-- Dec booking 1
('bc-001-dec-1',    'bk-15l9k-31np', 'bl-dec-001',    '2021-12-10 11:00:00', 'itm-a9e8-q8fu',  6),
('bc-002-dec-1',    'bk-15l9k-31np', 'bl-dec-001',    '2021-12-10 11:00:00', 'itm-d789-01gh',  5),
-- Dec booking 2
('bc-001-dec-2',    'bk-16m0l-22oq', 'bl-dec-002',    '2021-12-22 20:00:00', 'itm-b123-45cd',  2),
('bc-002-dec-2',    'bk-16m0l-22oq', 'bl-dec-002',    '2021-12-22 20:00:00', 'itm-c456-78ef',  3),
('bc-003-dec-2',    'bk-16m0l-22oq', 'bl-dec-002',    '2021-12-22 20:00:00', 'itm-f345-67kl',  4);

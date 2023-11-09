-- BAI 1 --
CREATE DATABASE QUANLYBANHANG;
USE QUANLYBANHANG;

CREATE TABLE customers (
    customer_id VARCHAR(4) NOT NULL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(25) NOT NULL UNIQUE,
    address VARCHAR(255) NOT NULL
);

CREATE TABLE orders (
    order_id VARCHAR(4) NOT NULL PRIMARY KEY,
    customer_id VARCHAR(4) NOT NULL,
    order_date DATE NOT NULL,
    total_amount DOUBLE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE products (
    product_id VARCHAR(4) NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DOUBLE NOT NULL,
    status BIT(1) NOT NULL DEFAULT 1
);

CREATE TABLE orders_details (
    order_id VARCHAR(4) NOT NULL,
    product_id VARCHAR(4) NOT NULL,
    quantity INT(11) NOT NULL,
    price DOUBLE NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- -----------------------------------------------------------------------------------------------------------------------------------------

-- BAI 2 --
INSERT INTO customers (customer_id, name, email, phone, address)
VALUES
    ('C001', 'Nguyễn Trung Mạnh', 'manhnt@gmail.com', '984756322', 'Cầu Giấy, Hà Nội'),
    ('C002', 'Hồ Hải Nam', 'namhh@gmail.com', '984875926', 'Ba Vì, Hà Nội'),
    ('C003', 'Tô Ngọc Vũ', 'vutn@gmail.com', '904725784', 'Mộc Châu, Sơn La'),
    ('C004', 'Phạm Ngọc Anh', 'anhpn@gmail.com', '984635365', 'Vinh, Nghệ An'),
    ('C005', 'Trương Minh Cường', 'cuongtm@gmailcom', '989735624', 'Hai Bà Trưng, Hà Nội');

INSERT INTO products (product_id, name, description, price)
VALUES
    ('P001', 'Iphone 13 ProMax', 'Bản 512 GB, xanh lá', 22999999),
    ('P002', 'Dell Vostro V3510', 'Core i5 , RAM 8GB', 14999999),
    ('P003', 'Macbook ProM2', '8CPU 10GPU 8GB 256GB', 28999999),
    ('P004', 'Apple Watch Ultra', 'Titanium Alpine Loop Smaill', 18999999),
    ('P005', 'Airpods 2 2022', 'Spatial Audio', 4090000);

INSERT INTO orders (order_id, customer_id, order_date, total_amount)
VALUES
    ('H001', 'C001', '2023-02-22', 52999997),
    ('H002', 'C001', '2023-03-11', 80999997),
    ('H003', 'C002', '2023-01-22', 54359998),
    ('H004', 'C003', '2023-03-14', 102999995),
    ('H005', 'C003', '2022-03-12', 80999997),
    ('H006', 'C004', '2023-02-01', 110449994),
    ('H007', 'C004', '2023-03-29', 79999996),
    ('H008', 'C005', '2023-02-14', 29999998),
    ('H009', 'C005', '2023-01-10', 28999999),
    ('H010', 'C005', '2023-04-01', 149999994);
    
INSERT INTO orders_details (order_id, product_id, price, quantity)
VALUES
    ('H001', 'P002', 14999999, 1),
    ('H001', 'P004', 18999999, 2),
    ('H002', 'P001', 22999999, 1),
    ('H002', 'P003', 28999999, 2),
    ('H003', 'P004', 18999999, 2),
    ('H003', 'P005', 4090000, 4),
    ('H004', 'P002', 14999999, 3),
    ('H004', 'P003', 28999999, 2),
    ('H005', 'P001', 22999999, 1),
    ('H005', 'P003', 28999999, 2),
    ('H006', 'P005', 4090000, 5),
    ('H006', 'P002', 14999999, 5),
    ('H007', 'P004', 18999999, 3),
    ('H007', 'P001', 22999999, 1),
    ('H008', 'P002', 14999999, 2),
    ('H009', 'P003', 28999999, 1),
    ('H010', 'P003', 28999999, 2),
    ('H010', 'P001', 22999999, 4);

-- -----------------------------------------------------------------------------------------------------------------------------------------

-- BAI 3 --
-- 1.Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers
SELECT name, email, phone, address
FROM customers;

-- 2.Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện thoại và địa chỉ khách hàng)
SELECT c.name, c.phone, c.address
FROM customers AS c
INNER JOIN orders AS o ON c.customer_id = o.customer_id
WHERE o.order_date BETWEEN '2023-03-01' AND '2023-03-31';

-- 3.Thống kê doanh thua theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm tháng và tổng doanh thu )
SELECT DATE_FORMAT(order_date, '%Y-%m') AS thang, SUM(total_amount) AS tong_doanh_thu
FROM orders
WHERE YEAR(order_date) = 2023
GROUP BY DATE_FORMAT(order_date, '%Y-%m');

-- 4.Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách hàng, địa chỉ , email và số điên thoại)
SELECT c.name, c.address, c.email, c.phone
FROM customers AS c
WHERE c.customer_id NOT IN (
    SELECT o.customer_id
    FROM orders AS o
    WHERE o.order_date BETWEEN '2023-02-01' AND '2023-02-28'
);

-- 5.Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã sản phẩm, tên sản phẩm và số lượng bán ra)
SELECT p.product_id, p.name AS ten_san_pham, SUM(od.quantity) AS so_luong_ban_ra
FROM products AS p
INNER JOIN orders_details AS od ON p.product_id = od.product_id
INNER JOIN orders AS o ON od.order_id = o.order_id
WHERE o.order_date BETWEEN '2023-03-01' AND '2023-03-31'
GROUP BY p.product_id, p.name;

-- 6.Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu)
SELECT c.customer_id, c.name AS ten_khach_hang, SUM(o.total_amount) AS muc_chi_tieu
FROM customers AS c
LEFT JOIN orders AS o ON c.customer_id = o.customer_id
WHERE YEAR(o.order_date) = 2023
GROUP BY c.customer_id, c.name
ORDER BY muc_chi_tieu DESC;

-- 7.Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm)
SELECT c.name AS ten_nguoi_mua, o.total_amount AS tong_tien, o.order_date AS ngay_tao_hoa_don, SUM(od.quantity) AS tong_so_luong_san_pham
FROM customers AS c
INNER JOIN orders AS o ON c.customer_id = o.customer_id
INNER JOIN orders_details AS od ON o.order_id = od.order_id
GROUP BY o.order_id, c.name, o.total_amount, o.order_date
HAVING SUM(od.quantity) >= 5;

-- -----------------------------------------------------------------------------------------------------------------------------------------

-- BAI 4 --
-- 1.Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng tiền và ngày tạo hoá đơn
CREATE VIEW view_order AS
SELECT c.name AS ten_khach_hang, c.phone, c.address, o.total_amount, o.order_date
FROM customers AS c
INNER JOIN orders AS o ON c.customer_id = o.customer_id;
SELECT * FROM view_order;

-- 2.Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng số đơn đã đặt
CREATE VIEW view_customer AS
SELECT c.name AS ten_khach_hang, c.address, c.phone, COUNT(o.order_id) AS tong_so_don_dat
FROM customers AS c
LEFT JOIN orders AS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.address, c.phone;
SELECT * FROM view_customer;

-- 3.Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã bán ra của mỗi sản phẩm
CREATE VIEW view_product AS
SELECT p.name AS ten_san_pham, p.description AS mo_ta, p.price, SUM(od.quantity) AS tong_so_luong_ban_ra
FROM products AS p
LEFT JOIN orders_details AS od ON p.product_id = od.product_id
GROUP BY p.product_id, p.name, p.description, p.price;
SELECT * FROM view_product;

-- 4.Đánh Index cho trường `phone` và `email` của bảng Customer
CREATE INDEX index_customer_phone ON customers(phone);
CREATE INDEX index_customer_email ON customers(email);

-- 5.Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng
DELIMITER //
CREATE PROCEDURE get_customer(IN customer_id_in VARCHAR(4))
BEGIN
    SELECT * FROM customers
    WHERE customer_id_in = customer_id;
END //
DELIMITER ;
CALL get_customer('C001');

-- 6.Tạo PROCEDURE lấy thông tin của tất cả sản phẩm
DELIMITER //
CREATE PROCEDURE get_all_products()
BEGIN
    SELECT * FROM products;
END //
DELIMITER ;
CALL get_all_products();

-- 7.Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng
DELIMITER //
CREATE PROCEDURE get_orders_by_customerId(IN customerId_in VARCHAR(4))
BEGIN
    SELECT * FROM orders
    WHERE customerId_in = customer_id;
END //
DELIMITER ;
CALL get_orders_by_customerId('C003');

-- 8.Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng, tổng tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo


-- 9.Tạo PROCEDURE thống kê số lượng bán ra của mỗi sản phẩm trong khoảng thời gian cụ thể với 2 tham số là ngày bắt đầu và ngày kết thúc
DELIMITER //
CREATE PROCEDURE product_sales_report(
    IN start_date DATE,
    IN end_date DATE
)
BEGIN
    SELECT p.product_id, p.name AS product_name, SUM(od.quantity) AS total_quantity
    FROM products p
    JOIN orders_details od ON p.product_id = od.product_id
    JOIN orders o ON od.order_id = o.order_id
    WHERE o.order_date BETWEEN start_date AND end_date
    GROUP BY p.product_id, p.name
    ORDER BY total_quantity DESC;
END //
DELIMITER ;
CALL product_sales_report('2023-03-01', '2023-04-30');

-- 10.Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra theo thứ tự giảm dần của tháng đó với tham số vào là tháng và năm cần thống kê
DELIMITER //
CREATE PROCEDURE monthly_product_sales_report(
    IN in_month INT,
    IN in_year INT
)
BEGIN
    SELECT p.product_id, p.name AS product_name, SUM(od.quantity) AS total_quantity
    FROM products p
    JOIN orders_details od ON p.product_id = od.product_id
    JOIN orders o ON od.order_id = o.order_id
    WHERE MONTH(o.order_date) = in_month AND YEAR(o.order_date) = in_year
    GROUP BY p.product_id, p.name
    ORDER BY total_quantity DESC;
END //
DELIMITER ;
CALL monthly_product_sales_report(3,2023);

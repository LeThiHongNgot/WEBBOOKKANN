﻿CREATE DATABASE QLBANSACH
GO
USE QLBANSACH
GO
begin /*Table*/
CREATE TABLE USERS
(
	Id VARCHAR(20) NOT NULL,
	FullName NVARCHAR(30) NOT NULL,
	Password VARCHAR(30) NOT NULL,
	Email VARCHAR(255),
	Phone CHAR(10) NOT NULL,
)

CREATE TABLE ROLES
(
	Id VARCHAR(20) NOT NULL,
	Name NVARCHAR(30) NOT NULL,
	mission Nvarchar(256)
)

CREATE TABLE USERROLES
(
	Id VARCHAR(20) NOT NULL,
	UserId VARCHAR(20) NOT NULL,
	RoleId VARCHAR(20) NOT NULL
)

CREATE TABLE CATEGORIES
(
	Id VARCHAR(20) NOT NULL,
	Name NVARCHAR(50)
)

CREATE TABLE BANNERS
(
	Id VARCHAR(20) NOT NULL,
	Image TEXT,
	Name NVARCHAR(50),
	Description NTEXT
)

CREATE TABLE VOUCHERS
(
	Id VARCHAR(20) NOT NULL,
	Quantity INT,
	PercentDiscount DECIMAL(5,2),
	MaxDiscount MONEY,
	DateBegin Date,
	DateEnd Date
)


CREATE TABLE AUTHORS
(
	Id VARCHAR(20) NOT NULL,
	Name NVARCHAR(50),
	Image TEXT,
	Description NTEXT
)

CREATE TABLE SUPPLIERS
(
	Id VARCHAR(20) NOT NULL,
	Name NVARCHAR(50),
	Email VARCHAR(255),
	Description NTEXT,
	Phone CHAR(10) NOT NULL
)

CREATE TABLE CUSTOMERS
(
	Id VARCHAR(20) NOT NULL,
	FullName NVARCHAR(50),
	Photo TEXT,
	Activated BIT,
	Password VARCHAR(50),
	Email VARCHAR(255),
	gender NVarchar(5),
	address nvarchar(256),
	birthday date,
	Phone VARCHAR(10) NULL,
)

-- Sửa kiểu dữ liệu của cột Id từ CHAR(10) thành NVARCHAR
CREATE TABLE BOOKS
(
	Id VARCHAR(20) NOT NULL,
	Title NVARCHAR(100),
	AuthorId VARCHAR(20) NOT NULL,
	SupplierId VARCHAR(20) NOT NULL,
	UnitPrice MONEY,
	PricePercent DECIMAL(10,2),
	PublishYear INT,
	Available BIT,
	Quantity INT
)

CREATE TABLE BOOKDETAILS
(
	BookId VARCHAR(20) NOT NULL,
	CategoryId VARCHAR(20) NOT NULL,
	Dimensions CHAR(20),
	Pages INT,
	Description NTEXT
)

CREATE TABLE BOOKIMG
(
	BookId VARCHAR(20) NOT NULL,
	Image0 TEXT,
	Image1 TEXT,
	Image2 TEXT,
	Image3 TEXT
)

CREATE TABLE PRODUCT_REVIEWS
(
    Id VARCHAR(50) NOT NULL,
    CustomerId VARCHAR(20) NOT NULL,
    BookId VARCHAR(20) NOT NULL,
    Rating INT NOT NULL,
    Comment NVARCHAR(MAX),
	NgayCommemt Date,
);

CREATE TABLE ORDERS
(
	Id VARCHAR(20) NOT NULL,
	CustomerId VARCHAR(20) NOT NULL,
	OrderDate DATETIME,
	Status TINYINT,
	Address  NVARCHAR(100),
	Description NVARCHAR(MAX),
	UnitPrice MONEY,
	Quantity INT,
	BookId VARCHAR(20) NOT NULL,
)


CREATE TABLE BILLS
(
	Id VARCHAR(20) NOT NULL,
	OrderId VARCHAR(20) NOT NULL,
	UserId VARCHAR(20) NOT NULL,
	VoucherId VARCHAR(20) NOT NULL,
	BillDate DATETIME,
	TotalAmount MONEY
)
CREATE TABLE CARTS
(
	Id VARCHAR(50) NOT NULL,
	BookId VARCHAR(20) NOT NULL,
	CustomerId VARCHAR(20) NOT NULL,
)

end
GO
begin /*Primary and Foreign key*/
-----Primary key 
ALTER TABLE USERS
ADD PRIMARY KEY (Id);

ALTER TABLE ROLES
ADD PRIMARY KEY (Id);

ALTER TABLE USERROLES
ADD PRIMARY KEY (Id);

ALTER TABLE CATEGORIES
ADD PRIMARY KEY (Id);

ALTER TABLE BANNERS
ADD PRIMARY KEY (Id);

ALTER TABLE VOUCHERS
ADD PRIMARY KEY (Id);

ALTER TABLE AUTHORS
ADD PRIMARY KEY (Id);

ALTER TABLE SUPPLIERS
ADD PRIMARY KEY (Id);

ALTER TABLE CUSTOMERS
ADD PRIMARY KEY (Id);

ALTER TABLE BOOKS
ADD PRIMARY KEY (Id);

ALTER TABLE BOOKDETAILS
ADD PRIMARY KEY (BookId);

ALTER TABLE BOOKIMG
ADD PRIMARY KEY (BookId);

ALTER TABLE ORDERS
ADD PRIMARY KEY (Id);

ALTER TABLE BILLS
ADD PRIMARY KEY (Id);

ALTER TABLE CARTS
ADD PRIMARY KEY(ID);

ALTER TABLE PRODUCT_REVIEWS
ADD PRIMARY KEY (Id);

-----Forgein key
--1
ALTER TABLE BOOKDETAILS
ADD CONSTRAINT FK_BOOKDETAILS_CATEGORIES
FOREIGN KEY (CategoryId) REFERENCES CATEGORIES(Id);
--2
ALTER TABLE BOOKDETAILS
ADD CONSTRAINT FK_BOOKDETAILS_BOOKS
FOREIGN KEY (BookId) REFERENCES BOOKS(Id);
--3
ALTER TABLE BOOKS
ADD CONSTRAINT FK_BOOKS_AUTHORS
FOREIGN KEY (AuthorId) REFERENCES AUTHORS(Id);
--4
ALTER TABLE BOOKS
ADD CONSTRAINT FK_BOOKS_SUPPLIERS
FOREIGN KEY (SupplierId) REFERENCES SUPPLIERS(Id);
--5
ALTER TABLE ORDERS
ADD CONSTRAINT FK_ORDER_BOOKS
FOREIGN KEY (BookId) REFERENCES BOOKS(Id);
--7
ALTER TABLE ORDERS
ADD CONSTRAINT FK_ORDERS_CUSTOMERS
FOREIGN KEY (CustomerId) REFERENCES CUSTOMERS(Id);
--8
ALTER TABLE BILLS
ADD CONSTRAINT FK_BILLS_VOUCHERS
FOREIGN KEY (VoucherId) REFERENCES VOUCHERS(Id);
--9
ALTER TABLE BILLS
ADD CONSTRAINT FK_BILLS_ORDERS
FOREIGN KEY (OrderId) REFERENCES ORDERS(Id);
--10
ALTER TABLE BILLS
ADD CONSTRAINT FK_BILLS_USERS
FOREIGN KEY (UserId) REFERENCES USERS(Id);
--11
ALTER TABLE USERROLES
ADD CONSTRAINT FK_USERROLES_USERS
FOREIGN KEY (UserId) REFERENCES USERS(Id);
--12
ALTER TABLE USERROLES
ADD CONSTRAINT FK_USERROLES_ROLES
FOREIGN KEY (RoleId) REFERENCES ROLES(Id);

ALTER TABLE BOOKIMG
ADD CONSTRAINT FK_BOOKIMG_BOOKS
FOREIGN KEY (BookId) REFERENCES BOOKS(Id);

ALTER TABLE CARTS
ADD CONSTRAINT FK_CARTS_CUSTOMER
FOREIGN KEY (CustomerId) REFERENCES CUSTOMERS(Id);

ALTER TABLE CARTS
ADD CONSTRAINT FK_CARTS_BOOKS
FOREIGN KEY (BookId) REFERENCES BOOKS(Id);

ALTER TABLE PRODUCT_REVIEWS
ADD CONSTRAINT FK_REVIEWS_CUSTOMERS
FOREIGN KEY (CustomerId) REFERENCES CUSTOMERS(Id);

ALTER TABLE PRODUCT_REVIEWS
ADD CONSTRAINT FK_REVIEWS_BOOKS
FOREIGN KEY (BookId) REFERENCES BOOKS(Id);

ALTER TABLE PRODUCT_REVIEWS
ADD CONSTRAINT UQ_CUSTOMER_BOOK_REVIEW
UNIQUE (CustomerId, BookId);
-- Đảm bảo mỗi người chỉ đánh giá một cuốn sách một lần
end
GO
/*Trigger, Store Procedure*/
---- CẬP NHẬT LẠI KHO HÀNG SÁCH
CREATE TRIGGER TG_CAPNHATSOLUONGTONKHO
ON ORDERS
AFTER INSERT
AS
BEGIN
	-- LẤY THÔNG TIN VỪA INSERT 
	DECLARE @BOOKID CHAR(10)
	DECLARE @QUANTITY INT
	SELECT @BOOKID=BookId,@QUANTITY =Quantity
	FROM INSERTED

	--CẬP NHẬT GIẢM SỐ LƯỢNG TỒN CỦA HÀNG HÓA
	UPDATE BOOKS
	SET Quantity = Quantity-@QUANTITY 
	WHERE Id=@BOOKID
END
GO
--- CẬP NHẬT LẠI SỐ LƯỢNG VOUCHER
CREATE TRIGGER TG_CAPNHATVOUCHER
ON BILLS
AFTER INSERT
AS
BEGIN
	DECLARE @IDVOUCHER CHAR(10)
	SELECT @IDVOUCHER= VoucherId 
	FROM INSERTED
	
	UPDATE VOUCHERS
	SET Quantity = Quantity-1
	WHERE Id=@IDVOUCHER
END
GO
--- CHECK MAIL CHO KHÁCH HÀNG
CREATE TRIGGER CHECK_MAIL
ON CUSTOMERS
AFTER INSERT
AS 
BEGIN
    IF EXISTS (
        SELECT 1
        FROM INSERTED
        WHERE Email NOT LIKE '%@gmail.com'
    )
    BEGIN
        RAISERROR('Định dạng email không hợp lệ. Email phải có định dạng name@example.com', 16, 1);
        ROLLBACK TRANSACTION;  -- Rollback the transaction if the format is invalid
    END
END
GO
-- CHECH PHONE
CREATE TRIGGER CHECK_PHONE
ON CUSTOMERS
AFTER INSERT
AS
BEGIN
IF EXISTS (
	SELECT 1
	FROM INSERTED
	WHERE Phone NOT LIKE '0[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	)
	BEGIN
	RAISERROR ('Số điện chưa đúng đinh dạng,vui lòng nhập lại',16,1)
	ROLLBACK TRANSACTION;
	END
END;
GO
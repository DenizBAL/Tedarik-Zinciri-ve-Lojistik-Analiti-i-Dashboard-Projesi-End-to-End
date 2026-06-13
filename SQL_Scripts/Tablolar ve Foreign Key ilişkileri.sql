------------------------TABLOLAR--------------------------
--MÜŞTERİLER
CREATE TABLE Dim_Customers(
	CustomerID INT PRIMARY KEY,
	CustomerName VARCHAR(100) NOT NULL,
	City VARCHAR(50),
	Country VARCHAR(50),
	Segment VARCHAR(30) --Kurumsal,Bireysel
);

-- ÜRÜNLER
CREATE TABLE Dim_Products(
	ProductID INT PRIMARY KEY,
	ProductName VARCHAR(100) NOT NULL,
	Category VARCHAR(50),
	SubCategory VARCHAR(50),
	ProductCost DECIMAL(18,2), -- Alış Maliyeti
	WareHouseLocation VARCHAR(50) -- Depo Konumu
);

-- KARGO ŞİRKETLERİ
CREATE TABLE Dim_Shippers(
	ShipperID INT PRIMARY KEY,
	ShipperName VARCHAR(50) NOT NULL,
	ContractedDeliveryDays INT, -- Sözleşmeye göre teslim etmesi gereken maksimum gün süresi
);

--SİPARİŞLER VE LOJİSTİK HAREKETLER
CREATE TABLE Fact_Orders(
	OrderID INT PRIMARY KEY,
	CustomerID INT NOT NULL,
	ProductID INT NOT NULL,
	ShipperID INT NOT NULL,
	OrderDate DATE NOT NULL,
	ShipperDate DATE,           -- Kargoya Veriliş Tarihi
	ScheduledDeliveryDate DATE,  -- Sistemin Planladğı Teslim Tarihi
	ActualDeliveryDate DATE, -- Müşteriye gerçekten teslim edilen tarih
    Quantity INT NOT NULL,
    Revenue DECIMAL(18,2) NOT NULL, -- Satış cirosu
    ShippingCost DECIMAL(18,2) NOT NULL, -- Lojistik/Nakliye maliyeti

		------------------------FOREIGN KEY İLİŞKİLER--------------------------
CONSTRAINT FK_FactOrders_Customers FOREIGN KEY (CustomerID) REFERENCES Dim_Customers(CustomerID),
CONSTRAINT FK_FactOrders_Products FOREIGN KEY (ProductID) REFERENCES Dim_Products(ProductID),
CONSTRAINT FK_FactOrders_Shippers FOREIGN KEY (ShipperID) REFERENCES Dim_Shippers(ShipperID)
)




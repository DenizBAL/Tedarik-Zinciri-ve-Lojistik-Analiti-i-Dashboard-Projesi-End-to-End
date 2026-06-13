--Tarih Sıralaması Kontrolü:
SELECT OrderID,OrderDate,ShipperDate,ActualDeliveryDate FROM Fact_Orders WHERE ShipperDate<OrderDate OR ActualDeliveryDate<ShipperDate

--Null Değer Kontrolü:
SELECT COUNT(*) AS 'Boş Değerler'  FROM Fact_Orders 
WHERE CustomerID IS NULL OR Revenue IS NULL OR Quantity <= 0;

--Kargo Firmalarının Ortalama Teslim Süreleri: 
SELECT F.ShipperID,S.ShipperName,AVG(DATEDIFF(day,F.ShipperDate,F.ActualDeliveryDate)) AS OrtTeslimSuresi  FROM Fact_Orders F
LEFT JOIN Dim_Shippers S ON F.ShipperID=S.ShipperID
GROUP BY F.ShipperID,S.ShipperName
ORDER BY OrtTeslimSuresi DESC

--Zarar Eden Siparişler:
SELECT COUNT(*) AS ZararEdenSiparisSayisi FROM Fact_Orders F
JOIN Dim_Products P ON F.ProductID=P.ProductID
WHERE (F.Revenue-(F.Quantity*P.ProductCost)-F.ShippingCost)<0

--Müşteri Sipariş Dağılımı:
SELECT F.CustomerID,C.CustomerName,COUNT(F.OrderID) AS SiparisSayisi FROM Fact_Orders F
JOIN Dim_Customers C ON F.CustomerID=C.CustomerID
GROUP BY F.CustomerID,C.CustomerName
ORDER BY SiparisSayisi DESC

-- TOP 5 Ürün Kategorisi:
SELECT TOP 5 p.Category,SUM(F.Revenue) AS TotalRevenue  FROM Fact_Orders F
JOIN Dim_Products p ON F.ProductID=p.ProductID
GROUP BY p.Category
ORDER BY TotalRevenue DESC

-- Dashboard İçin VIEW Oluşturma:
CREATE VIEW vW_Dashboard_Base as
SELECT 
-- Genel Bilgiler
	F.OrderID,
	F.Quantity,
	F.Revenue AS TotalRevenue,
	F.ShippingCost,
-- Tarih Alanları
	F.OrderDate,
	F.ShipperDate,
	F.ScheduledDeliveryDate,
	F.ActualDeliveryDate,
-- Müşteri Bilgileri
	C.CustomerID,
	C.CustomerName,
	--Dashboard, İsimlerin karışmaması için şehirle birleştirilmiş benzersiz isim.
	(C.CustomerName+'('+C.City+')') AS UniqeCustomerName,
	C.City AS CustomerCity,
	C.Country AS CustomerCountry,
	C.Segment AS CustomerSegment,
-- Ürün Bilgileri
	P.ProductID,
	P.ProductName,
	P.Category AS ProductCategory,
	P.SubCategory AS ProductSubCategory,
	P.ProductCost,
	P.WareHouseLocation,
--Kargo Bilgileri
	S.ShipperID,
	S.ShipperName,
	S.ContractedDeliveryDays,
--METRİKLER
--Toplam Maliyet: (Adet * Ürün Maliyeti) + Kargo Maliyeti
	((F.Quantity*P.ProductCost)+F.ShippingCost) AS TotalCost,
--Net Kâr: (Hasılat-(Adet*Ürün Maliyeti)-Kargo Maliyeti)
	(F.Revenue-(F.Quantity*P.ProductCost)-F.ShippingCost) AS NetProfit,
--Kâr Marjı (%): ((Hasılat-(Adet*Ürün Maliyeti)-Kargo Maliyeti)/Hasılat)*100
	CASE
		WHEN F.Revenue>0 THEN ((F.Revenue-(F.Quantity*P.ProductCost)-F.ShippingCost)/F.Revenue)*100
		ELSE 0
	END AS ProfitMarginPercentage,
--Toplam Teslimat Süresi
	DATEDIFF(day,F.OrderDate,F.ActualDeliveryDate) AS TotalDeliveryDays,
--Kargonun Yolda Geçirdiği Süre
	DATEDIFF(day,F.ShipperDate,F.ActualDeliveryDate) AS ShippingDurationDays,
--Gecikme Durumu:
	CASE
		WHEN DATEDIFF(day,F.ShipperDate,F.ActualDeliveryDate)>S.ContractedDeliveryDays THEN 'Gecikti'
		ELSE 'Zamanında'
	END AS DeliveryStatus,
-- Gecikme Süresi (Gün):
	CASE
		WHEN DATEDIFF(day,F.ShipperDate,F.ActualDeliveryDate)>S.ContractedDeliveryDays THEN DATEDIFF(day,F.ShipperDate,F.ActualDeliveryDate)-S.ContractedDeliveryDays
		ELSE 0
	END AS DaysDelayed
FROM Fact_Orders F
LEFT JOIN Dim_Customers C ON F.CustomerID=C.CustomerID
LEFT JOIN Dim_Products P ON F.ProductID=P.ProductID
LEFT JOIN Dim_Shippers S ON F.ShipperID=S.ShipperID
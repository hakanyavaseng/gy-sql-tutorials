SELECT O.ID, O.DATE_,  I.ITEMCODE, I.ITEMNAME, I.BRAND, I.CATEGORY1, I.CATEGORY2, I.CATEGORY3, OD.UNITPRICE, OD.LINETOTAL FROM ORDERS O 
INNER JOIN ORDERDETAILS OD ON OD.ORDERID = O.ID
INNER JOIN ITEMS I ON I.ID = OD.ITEMID
WHERE DATE_ BETWEEN '20220101' AND '2022-01-31 23:59:59'
ORDER BY DATE_ DESC

--Nazmiye Ercan kullan�c�s�n�n verdi�i sipari�leri getiren SQL Sorgusu
SELECT U.NAMESURNAME, O.ID, O.DATE_, I.ITEMCODE, I.ITEMNAME

FROM ORDERS O
JOIN USERS U ON U.ID = O.USERID
JOIN ORDERDETAILS OD ON OD.ORDERID = O.ID
JOIN ITEMS I ON I.ID = OD.ITEMID
WHERE U.NAMESURNAME = 'Nazmiye Ercan'
ORDER BY O.ID


--Her �ehrin il�elerini getiren sorgu
SELECT CITY SEHIR, TOWN ILCE FROM CITIES C 
JOIN TOWNS T ON T.CITYID = C.ID
ORDER BY CITY, TOWN


--Istanbul'da hangi il�ede ne kadar musteri oldugunu getiren sorgu
SELECT C.CITY, T.TOWN, COUNT(DISTINCT U.ID) FROM ADDRESS A
INNER JOIN USERS U ON U.ID = A.USERID
JOIN CITIES C ON C.ID = A.CITYID
JOIN TOWNS T ON T.ID = A.TOWNID
WHERE C.CITY = '�STANBUL'
GROUP BY C.CITY, T.TOWN

--2022 YILI MART AYINDA 20-30 YA� ARASI M��TER�LER�N VERD��� S�PAR��LER
SELECT U.USERNAME_, DATEDIFF(YEAR,U.BIRTHDATE, GETDATE()) YAS, C.CITY, O.DATE_, O.ID
FROM USERS U
JOIN ORDERS O ON O.USERID = U.ID
JOIN ADDRESS A ON A.ID = O.ADDRESSID
JOIN CITIES C ON C.ID = A. CITYID
WHERE DATEDIFF(YEAR,U.BIRTHDATE, GETDATE()) BETWEEN 20 AND 30
AND O.DATE_ BETWEEN '20220301' AND '2022-03-31 23:59:59'
ORDER BY O.DATE_

--Kullan�c�lar�n hangi �ehirde ka� adresi oldugunu getirin
SELECT U.ID, U.NAMESURNAME, CITY, COUNT(A.ID) 
FROM USERS U 
JOIN ADDRESS A ON A.USERID = U.ID
JOIN CITIES C ON C.ID = A.CITYID
GROUP BY U.ID, U.NAMESURNAME, C.CITY
ORDER BY U.NAMESURNAME


--ISTANBULDA YILIN ILK 3 AYINDA EN COK SATIS YAPILAN 10 URUNU GET�REN SORGU
SELECT TOP 10 C.CITY, I.ITEMCODE, I.ITEMNAME, I.BRAND
,I.CATEGORY1,I.CATEGORY2, I.CATEGORY3,
SUM(OD.AMOUNT), SUM(OD.LINETOTAL) TOPLAMTUTAR
FROM ORDERS O 
JOIN ADDRESS A ON A.ID = O.ADDRESSID
JOIN CITIES C ON C.ID = A.CITYID
JOIN ORDERDETAILS OD ON OD.ORDERID = O.ID
JOIN ITEMS I ON I.ID = OD.ITEMID
WHERE C.CITY = '�STANBUL' AND O.DATE_ BETWEEN '20220101' AND '2022-03-31 23:59:59'
GROUP BY C.CITY, I.ITEMCODE, I.ITEMNAME, I.BRAND
,I.CATEGORY1,I.CATEGORY2, I.CATEGORY3
ORDER BY SUM(OD.LINETOTAL) DESC

--HAFTANIN GUNLERINE GORE NE KADAR ALISVERIS YAPILDIGINI GETIREN SQL SORGUSU
SET LANGUAGE turkish

SELECT --DATEPART(DW, '2022-01-01 08:14:27.000') gunnr 
DATENAME(DW,DATE_) GUNADI, ROUND(SUM(TOTALPRICE),1) TOPLAMTUTAR, COUNT(ID) SIPARISSAYISI
FROM ORDERS
GROUP BY DATEPART(DW, DATE_), DATENAME(DW,DATE_)
ORDER BY DATEPART(DW, DATE_)

--SAAT ARALIGINA GORE NE KADAR ALISVERIS YAPILDIGI BILGISINI GETIREN SORGU
SELECT DATEPART(HOUR,DATE_) SAAT,
ROUND(SUM(TOTALPRICE),0) TOPLAMTUTAR, COUNT(ID) SIPARISSAYISI
FROM ORDERS 
GROUP BY DATEPART(HOUR,DATE_)
ORDER BY 1

--HER BIR SIPARIS ICIN TOPLAM SEVKETME SURESINI GETIREN SORGU
SELECT O.ID, U.NAMESURNAME KULLANICI, C.CITY SEHIR,
O.DATE_ SIPARISTARIHI,
I.DATE_ FATURATARIHI,
DATEDIFF(HOUR, O.DATE_, I.DATE_) SEVKSURESISAAT
FROM ORDERS O
JOIN USERS U ON U.ID = O.USERID
JOIN ADDRESS A ON A.ID = O.ADDRESSID
JOIN CITIES C ON C.ID = A.CITYID
JOIN INVOICES I ON I.ORDERID = O.ID
ORDER BY O.ID

--SIPARISLERIN GENEL OLARAK, BOLGELERE GORE VE SEHIRLERE GORE ORTALAMA SEVKETME SURELERINI GETIREN SORGU
SELECT  AVG(CONVERT(FLOAT,DATEDIFF(HOUR, O.DATE_,I.DATE_))) ORTALAMASEVKSURESISAAT
FROM ORDERS O 
JOIN INVOICES I ON I.ORDERID = O.ID


SELECT C.REGION,
AVG(CONVERT(FLOAT,DATEDIFF(HOUR, O.DATE_,I.DATE_))) ORTALAMASEVKSURESISAAT
FROM ORDERS O 
JOIN INVOICES I ON I.ORDERID = O.ID
JOIN ADDRESS A ON A.ID = O.ADDRESSID
JOIN CITIES C ON C.ID = A.CITYID
GROUP BY C.REGION


SELECT C.CITY,
AVG(CONVERT(FLOAT,DATEDIFF(HOUR, O.DATE_,I.DATE_))) ORTALAMASEVKSURESISAAT
FROM ORDERS O 
JOIN INVOICES I ON I.ORDERID = O.ID
JOIN ADDRESS A ON A.ID = O.ADDRESSID
JOIN CITIES C ON C.ID = A.CITYID
GROUP BY C.CITY
ORDER BY AVG(CONVERT(FLOAT,DATEDIFF(HOUR, O.DATE_,I.DATE_)))


--SIPARIS TARIHININ AYI ILE FATURA TARIHININ AYI FARKLI OLAN SIPARISLERI GETIRINIZ
SELECT O.ID SIPARISNO, O.DATE_ SIPARISTARIHI, I.DATE_ FATURATARIHI
, DATENAME(MONTH, O.DATE_) SIPARISAYI, DATENAME(MONTH, I.DATE_) FATURAAYI
FROM ORDERS O 
JOIN INVOICES I ON O.ID = I.ORDERID
WHERE DATENAME(MONTH, O.DATE_) <> DATENAME(MONTH, I.DATE_)
ORDER BY 1


--HER AY ICIN SIPARIS TARIHININ AYI ILE FATURA TARIHININ AYI FARKLI OLAN SIPARIS SAYILARI

SELECT DATENAME(MONTH, O.DATE_) SIPARISAYI, COUNT(DATENAME(MONTH, I.DATE_))
FROM ORDERS O 
JOIN INVOICES I ON O.ID = I.ORDERID
WHERE DATENAME(MONTH, O.DATE_) <> DATENAME(MONTH, I.DATE_)
GROUP BY DATENAME(MONTH, O.DATE_), DATEPART(MONTH, O.DATE_)
ORDER BY DATEPART(MONTH, O.DATE_)

--HER SEHIRDE NE KADAR ERKEK VE KADIN KULLANICININ OLDUGUNU GETIREN SORGUYU YAZINIZ
SELECT C.CITY SEHIR, U.GENDER CINSIYET, COUNT(U.ID) KULLANICISAYISI FROM USERS U 
JOIN ADDRESS A ON A.USERID = U.ID
JOIN CITIES C ON C.ID = A.CITYID
GROUP BY C.CITY, U.GENDER
ORDER BY SEHIR


--URUN KATEGORILERINI ALFABETIK OLARAK ANA KATEGORI VE EN COK SATAN OLARAK 
--ALT KATEGORI OLACAK SEKILDE GETIRIN

SELECT I.CATEGORY1 ANAKATEGORI, 
I.CATEGORY2 ALTKATEGORI
, SUM(OD.LINETOTAL)
FROM ORDERDETAILS OD
JOIN ITEMS I ON I.ID = OD.ITEMID
GROUP BY I.CATEGORY1, I.CATEGORY2
ORDER BY I.CATEGORY1



--DETERJAN TEMIZLIK VE GIDA KATEGORULERININ BOLGELERE GORE YAPILAN
--TOPLAM SATISLARINI GETIRINIZ
SELECT C.REGION, I.CATEGORY1, SUM(OD.LINETOTAL) FROM ORDERDETAILS OD
JOIN ITEMS I ON I.ID = OD.ITEMID
JOIN ORDERS O ON O.ID = OD.ORDERID
JOIN ADDRESS A ON A.ID = O.ADDRESSID
JOIN CITIES C ON C.ID = A.CITYID
WHERE I.CATEGORY1 IN('DETERJAN TEM�ZL�K', 'GIDA')
GROUP BY C.REGION,I.CATEGORY1
ORDER BY C.REGION

--HER BIR URUN ICIN TOPLAM NE KADARLIK SATIS YAPILDIGINI ADET VE TOPLAM CIRO OLARAK GETIRINIZ
--AYRICA HER BIR URUN ICIN EN DUSUK, EN YUKSEK, ORTALAMA SATIS VE MEVCUT FIYATA GORE KAR ZARAR
--HESABINI YAPAN SORGUYU GETIRINIZ

SELECT
I.ITEMCODE URUNKODU, I.ITEMNAME URUNADI, I.UNITPRICE BIRIMFIYAT,
SUM(OD.AMOUNT) TOPLAM_ADET, 
ROUND(SUM(OD.LINETOTAL),0) TOPLAM_SATIS,
MIN (OD.UNITPRICE) ENDUSUK_FIYAT, 
MAX(OD.UNITPRICE) ENYUKSEK_FIYAT, 
ROUND(AVG(OD.UNITPRICE),2) ORTALAMA_FIYAT,
ROUND(SUM(I.UNITPRICE*OD.AMOUNT),2) LISTEFIYATI_SATIS,
ROUND((SUM(OD.LINETOTAL) - SUM(I.UNITPRICE*OD.AMOUNT)),0 ) KAR_ZARAR, 
ROUND((SUM(OD.LINETOTAL) -SUM(I.UNITPRICE*OD.AMOUNT)),0 ) 
/ ROUND(SUM(I.UNITPRICE*OD.AMOUNT),2) * 100 KARZARARYUZDE
FROM ORDERDETAILS OD
JOIN ITEMS I ON OD.ITEMID = I.ID
GROUP BY I.ITEMCODE, I.ITEMNAME, I.UNITPRICE
ORDER BY I.ITEMCODE

--ALIS LISTE FIYATI VE SATIS FIYATI ILE SATILAN MIKTAR UZERINDEN
--EN COK KAR EDILEN 10 URUN ILE EN AZ KAR EDILEN 10 URUNU LISTELEYINIZ
SELECT TOP 10 *, TOPLAM_SATIS - LISTEFIYATI_SATIS KARZARAR,
ROUND(((TOPLAM_SATIS - LISTEFIYATI_SATIS) / LISTEFIYATI_SATIS * 100),2) KARZARARYUZDE

FROM
(
SELECT
I.ITEMCODE URUNKODU, I.ITEMNAME URUNADI, I.UNITPRICE BIRIMFIYAT,
SUM(OD.AMOUNT) TOPLAM_ADET, 
ROUND(SUM(OD.LINETOTAL),0) TOPLAM_SATIS,
MIN (OD.UNITPRICE) ENDUSUK_FIYAT, 
MAX(OD.UNITPRICE) ENYUKSEK_FIYAT, 
ROUND(AVG(OD.UNITPRICE),2) ORTALAMA_FIYAT,
ROUND(SUM(I.UNITPRICE*OD.AMOUNT),2) LISTEFIYATI_SATIS
FROM ORDERDETAILS OD
JOIN ITEMS I ON OD.ITEMID = I.ID
GROUP BY I.ITEMCODE, I.ITEMNAME, I.UNITPRICE

) T
ORDER BY KARZARARYUZDE DESC
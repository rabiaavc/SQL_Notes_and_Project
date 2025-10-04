
-- 1) KATEGORI
CREATE TABLE Kategori (
    kategori_id          INT IDENTITY(1,1) PRIMARY KEY,
    kategori_ad          NVARCHAR(200) NOT NULL UNIQUE
);

-- 2) SATICI
CREATE TABLE Satici (
    satici_id INT IDENTITY(1,1) PRIMARY KEY,
    satici_ad        NVARCHAR(200) NOT NULL,
    satici_adres     NVARCHAR(300)
);

-- 3) MUSTERI
CREATE TABLE Musteri (
    musteri_id            INT IDENTITY(1,1) PRIMARY KEY,
    musteri_ad            NVARCHAR(200) NOT NULL,
    musteri_soyad         NVARCHAR(200) NOT NULL,
    email                 NVARCHAR(200) NOT NULL UNIQUE,
    sehir                 NVARCHAR(200),
    kayit_tarihi          DATE NOT NULL DEFAULT (CAST(GETDATE() AS date))
);

-- 4) URUN
CREATE TABLE Urun (
    urun_id      INT IDENTITY(1,1) PRIMARY KEY,
    urun_ad           NVARCHAR(200) NOT NULL,
    urun_fiyat        DECIMAL(12,2) NOT NULL CHECK (urun_fiyat >= 0),
    urun_stok         INT NOT NULL CHECK (urun_stok >= 0),
    kategori_id  INT NOT NULL,
    satici_id    INT NOT NULL,

    CONSTRAINT FK_Urun_Kategori FOREIGN KEY (kategori_id) REFERENCES Kategori(kategori_id),


    CONSTRAINT FK_Urun_Satici   FOREIGN KEY (satici_id)   REFERENCES Satici(satici_id)


);

-- 5) SIPARIS
CREATE TABLE Siparis (
    siparis_id    INT IDENTITY(1,1) PRIMARY KEY,
    musteri_id    INT NOT NULL,
    siparis_tarih         DATETIME2 NOT NULL DEFAULT (GETDATE()),
    toplam_tutar  DECIMAL(12,2) NOT NULL DEFAULT (0) CHECK (toplam_tutar >= 0),
    odeme_turu    NVARCHAR(100) NOT NULL
        CHECK (odeme_turu IN (N'kredi_karti', N'havale', N'kapida_odeme', N'cuzdan')),

    CONSTRAINT FK_Siparis_Musteri FOREIGN KEY (musteri_id) REFERENCES Musteri(musteri_id)

);

-- 6) SIPARIS_DETAY
CREATE TABLE Siparis_Detay (
    siparis_detay_id INT IDENTITY(1,1) PRIMARY KEY,
    siparis_id       INT NOT NULL,
    urun_id          INT NOT NULL,
    adet             INT NOT NULL CHECK (adet > 0),
    fiyat            DECIMAL(12,2) NOT NULL CHECK (fiyat >= 0),

    CONSTRAINT FK_Detay_Siparis FOREIGN KEY (siparis_id) REFERENCES Siparis(siparis_id) ON DELETE CASCADE,
    CONSTRAINT FK_Detay_Urun    FOREIGN KEY (urun_id)    REFERENCES Urun(urun_id),
    CONSTRAINT UQ_Detay_Unique  UNIQUE (siparis_id, urun_id)
);

INSERT INTO Kategori (kategori_ad) VALUES
 (N'Oyuncak'),
 (N'Ofis'),
 (N'Mutfak Gereçleri'),
 (N'Bahçe'),
 (N'Oyun & Konsol'),
 (N'Elektronik'),
 (N'Spor');

INSERT INTO Satici (satici_ad, satici_adres) VALUES
 (N'Tech Store', N'Ýstanbul'),
 (N'Anadolu Pazarý', N'Ankara'),
 (N'Mega Distribütör', N'Ýzmir'),
 (N'Kuzey Ticaret', N'Trabzon'),
 (N'Ege Tedarik',   N'Ýzmir'),
 (N'Marmara Market',N'Ýstanbul');

INSERT INTO Musteri (musteri_ad, musteri_soyad, email, sehir) VALUES
 (N'Rabia',  N'Yýlmaz', N'rabia@example.com', N'Adana'),
 (N'Ahmet',  N'Demir',  N'ahmet@example.com', N'Ýzmir'),
 (N'Ayla',   N'Kaya',   N'ayla@example.com',  N'Ýstanbul'),
 (N'Can',    N'Þahin',  N'can.sahin@example.com', N'Bursa'),
 (N'Elif',   N'Koç',    N'elif.koc@example.com',  N'Antalya'),
 (N'Mehmet', N'Aslan',  N'mehmet.aslan@example.com', N'Ankara'),
 (N'Derya',  N'Acar',     N'derya.acar@example.com',    N'Eskiþehir'),
 (N'Burak',  N'Yýldýz',   N'burak.yildiz@example.com',  N'Kayseri'),
 (N'Zeynep', N'Er',       N'zeynep.er@example.com',     N'Samsun'),
 (N'Emre',   N'Güneþ',    N'emre.gunes@example.com',    N'Mersin'),
 (N'Selin',  N'Çelik',    N'selin.celik@example.com',   N'Konya'),
 (N'Kerem',  N'Doðan',    N'kerem.dogan@example.com',   N'Gaziantep'),
 (N'Pelin',  N'Uzun',     N'pelin.uzun@example.com',    N'Denizli'),
 (N'Yasin',  N'Arslan',   N'yasin.arslan@example.com',  N'Adýyaman'),
 (N'Cem',    N'Öz',       N'cem.oz@example.com',        N'Tekirdað'),
 (N'Aslý',   N'Yaman',    N'asli.yaman@example.com',    N'Malatya');

INSERT INTO Urun (urun_ad, urun_fiyat, urun_stok, kategori_id, satici_id) VALUES
(N'Kulaklýk',            450.00,  30, 6, 1),  -- Elektronik, Tech Store
 (N'Klavye',              700.00,  25, 6, 1),  -- Elektronik, Tech Store
 (N'Akýllý Lamba',        299.90,  40, 6, 3),  -- Elektronik, Mega Distribütör
 (N'Roman - Klasik',       95.00,  80, 2, 2),  -- Ofis (Kitap yok), Anadolu Pazarý
 (N'Programlama Kitabý',  220.00,  60, 2, 2),  -- Ofis, Anadolu Pazarý
 (N'Tiþört',              150.00,  50, 7, 2),  -- Spor (Giyim yok), Anadolu Pazarý
 (N'Koþu Ayakkabýsý',     899.00,  20, 7, 3),  -- Spor, Mega Distribütör
 (N'Süpürge',            1899.00,  10, 3, 3),  -- Mutfak Gereçleri, Mega Distribütör
 (N'Webcam',              375.00,  35, 6, 1),  -- Elektronik, Tech Store
 (N'Kulplu Kupa',          59.90, 100, 3, 2),  -- Mutfak Gereçleri, Anadolu Pazarý
 (N'Mouse',               299.00,  40, 6, 1),  -- Elektronik, Tech Store
 (N'Monitor 24"',        2499.00,  15, 6, 3),  -- Elektronik, Mega Distribütör
 (N'RGB Þerit LED',       149.90, 120, 6, 6),  -- Elektronik, Marmara Market
 (N'Mekanik Kurþun Kalem', 59.90, 200, 2, 2),  -- Ofis, Anadolu Pazarý
 (N'Not Defteri A5',       34.90, 300, 2, 5),  -- Ofis, Ege Tedarik
 (N'Tost Makinesi',       999.00,  25, 3, 4),  -- Mutfak Gereçleri, Kuzey Ticaret
 (N'Blender Seti',        749.00,  18, 3, 5),  -- Mutfak Gereçleri, Ege Tedarik
 (N'Bahçe Makasý',        189.90,  60, 4, 6),  -- Bahçe, Marmara Market
 (N'Sulama Hortumu 20m',  279.90,  35, 4, 4),  -- Bahçe, Kuzey Ticaret
 (N'Oyuncak Araba',        89.90, 150, 1, 2),  -- Oyuncak, Anadolu Pazarý
 (N'Peluþ Ayý',           159.90,  90, 1, 6),  -- Oyuncak, Marmara Market
 (N'Oyun Kumandasý',      499.00,  22, 5, 1),  -- Oyun & Konsol, Tech Store
 (N'PS4 Oyun - Macera',   399.00,  45, 5, 3),  -- Oyun & Konsol, Mega Distribütör
 (N'Spor Matý',           229.90,  70, 7, 5),  -- Spor, Ege Tedarik
 (N'Dumbell Set 2x5kg',   549.00,  26, 7, 4);  -- Spor, Kuzey Ticaret

INSERT INTO Siparis (musteri_id, odeme_turu, toplam_tutar) VALUES
 (1, N'kredi_karti', 995.00),
 (2, N'havale',      1239.60),
 (3, N'kapida_odeme',1498.80),
 (4, N'cuzdan',       745.00),
 (5,  N'kredi_karti', 403.90),
 (6,  N'havale',      1748.00),
 (7,  N'cuzdan',       659.20),
 (8,  N'kredi_karti', 2998.00),
 (9,  N'kapida_odeme', 339.70),
 (10, N'havale',       778.90),
 (11, N'kredi_karti',  789.70),
 (12, N'cuzdan',       900.00);

INSERT INTO Siparis_Detay (siparis_id, urun_id, adet, fiyat) VALUES
 (1, 1, 2, 450.00),
 (1, 4, 1, 95.00),

 (2, 2, 1, 700.00),
 (2, 10, 4, 59.90),
 (2, 6, 2, 150.00),

 (3, 7, 1, 899.00),
 (3, 3, 2, 299.90),

 (4, 9, 1, 375.00),
 (4, 6, 1, 150.00),
 (4, 5, 1, 220.00),

 (5, 11, 1, 299.00),
 (5, 15, 3,  34.90),

 (6, 16, 1, 999.00),
 (6, 17, 1, 749.00),

 (7, 13, 2, 149.90),
 (7, 10, 6,  59.90),

 (8, 12, 1, 2499.00),
 (8, 22, 1,  499.00),

 (9, 20, 2,  89.90),
 (9, 21, 1, 159.90),

 (10, 24, 1, 229.90),
 (10, 25, 1, 549.00),

 (11,  3, 2, 299.90),
 (11, 18, 1, 189.90),

 (12,  6, 3, 150.00),
 (12,  1, 1, 450.00);


  -- UPDATE
 -- Sipariþ 5 te toplam tutar hatasý
 UPDATE Siparis SET toplam_tutar = 403.90 where siparis_id = 5;

 --Sipariþ 11 odeme türü yanlýþ
 UPDATE Siparis SET odeme_turu = 'havale' where siparis_id = 11;

 -- Bahçe kategorisi Bahçe malzemeleri olmalý
 UPDATE Kategori Set kategori_ad = 'Bahçe Malzemeleri' where kategori_id = 4 ;



 -- Yeni Siparis Ekleme 1

--SCOPE_IDENTITY
--Bir tabloya yeni kayýt ekledin (IDENTITY sütunu var). 
--Hemen ardýndan o kaydýn kimliðini almak için kullanýrsýn; böylece iliþkili tablolara doðru id ile yazabilirsin.

 -- Aldýðý ürünler -> Kulaklýk = 450.0 , klavye = 700
INSERT INTO Siparis (musteri_id, odeme_turu, toplam_tutar)
VALUES (1, N'kredi_karti', 1150.00);
 --Siparis Detay ekleyelim 
INSERT INTO Siparis_Detay (siparis_id, urun_id, adet, fiyat)
VALUES

 (SCOPE_IDENTITY(), 1, 1, 450.00),  -- Kulaklýk (urun_id=1)
 (SCOPE_IDENTITY(), 2, 1, 700.00);  -- Klavye   (urun_id=2)

  -- Siparis ekledim stoktan düþücem 1 kulaklýk , 1 klavye
UPDATE Urun SET urun_stok = urun_stok - 1 WHERE urun_id = 1;  -- 1 kulaklýk düþtü
UPDATE Urun SET urun_stok = urun_stok - 1 WHERE urun_id = 2;  -- 1 klavye düþtü

--Sipariþ Ekleme 2
INSERT INTO Siparis (musteri_id, odeme_turu, toplam_tutar)
VALUES (2, N'kapida_odeme', 404.50);
--Sipariþ detaylarý (ayný ID otomatik)
INSERT INTO Siparis_Detay (siparis_id, urun_id, adet, fiyat)
VALUES
  (SCOPE_IDENTITY(), 15, 3,  34.90),   -- Not Defteri A5
  (SCOPE_IDENTITY(), 13, 2, 149.90);   -- RGB Þerit LED
-- Stok düþ
UPDATE Urun SET urun_stok = urun_stok - 3 WHERE urun_id = 15;
UPDATE Urun SET urun_stok = urun_stok - 2 WHERE urun_id = 13;

--Siparis Ekleme 3
--2*Tiþört + 4*Mouse = 300 + 1.196.0 = 1496.0
INSERT INTO Siparis (musteri_id, odeme_turu, toplam_tutar)
VALUES (1, N'kapida_odeme',1496.0 );
--Sipariþ detaylarý (ayný ID otomatik)
INSERT INTO Siparis_Detay (siparis_id, urun_id, adet, fiyat)
VALUES
  (SCOPE_IDENTITY(), 6, 2,  150.00),   -- Tiþört
  (SCOPE_IDENTITY(), 11, 4, 299.00);   -- Mouse
-- Stok düþ
UPDATE Urun SET urun_stok = urun_stok - 2 WHERE urun_id = 6;
UPDATE Urun SET urun_stok = urun_stok - 4 WHERE urun_id = 11;


--DELETE
-- Kullanýcý bir ürünü iade etti 13 nolu sipariste
SELECT * FROM Siparis WHERE siparis_id = 13;
-- Yapýlacaklar
-- Siparis tablosunda toplam tutar güncellenecek
--Siparis Detay tablosunda 1003 nolu siparis_detay_id satýrý silinecek
--Urun tablosunda urun_id = 1 olan ürünün stoðu 1 arttýrýlacak
UPDATE  Siparis SET toplam_tutar = 700 where siparis_id = 13;
DELETE FROM  Siparis_Detay where siparis_detay_id = 27;
UPDATE Urun SET urun_stok = urun_stok + 1 where urun_id = 1;

--TRUNCATE
--Siparis Detay tamamen temizle
TRUNCATE TABLE Siparis_Detay;
-- Siparis TRUNCATE edilemez (FK yüzünden), DELETE ile boþalt
DELETE FROM Siparis;
--Kimlik sayaçlarýný sýfýrla
DBCC CHECKIDENT ('Siparis', RESEED, 0);
DBCC CHECKIDENT ('Siparis_Detay', RESEED, 0);

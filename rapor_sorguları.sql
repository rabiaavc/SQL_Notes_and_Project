-- Raporlama Sorgularý 
--Temel Sorgular:
--- En çok sipariþ veren 5 müþteri.
SELECT TOP 5 
    M.musteri_id,
    M.musteri_ad + ' ' + M.musteri_soyad as [Musteri Adý],
    Count(S.siparis_id) as [Siparis Sayýsý]
FROM Musteri as M
INNER JOIN Siparis as S ON M.musteri_id = S.Musteri_id
Group by M.musteri_id, M.musteri_ad, M.musteri_soyad
ORDER BY [Siparis Sayýsý] DESC;

--- En çok satýlan ürünler.
SELECT * FROM SÝPARÝS_DETAY;
SELECT TOP 10
urun_id,
Sum(adet) as [Toplam Satýs Adedi]
FROM Siparis_detay 
GROUP BY urun_id
Order BY Sum(adet) DESC;

--- En yüksek cirosu olan satýcýlar.
SELECT TOP 5
    S.satici_id,
    S.satici_ad,
    SUM(SD.adet * SD.fiyat) AS [Toplam Ciro]
FROM Satici AS S
INNER JOIN Urun AS U ON S.satici_id = U.satici_id
INNER JOIN Siparis_Detay AS SD ON SD.urun_id = U.urun_id
GROUP BY S.satici_id , S.satici_ad
ORDER BY [Toplam Ciro] DESC;


--Aggregate & Group By:
--- Þehirlere göre müþteri sayýsý.
SELECT 
    M.sehir,
    COUNT(*) AS [Musteri Sayýsý]
FROM Musteri AS M
GROUP BY M.sehir
ORDER BY [Musteri Sayýsý] DESC ;

--- Kategori bazlý toplam satýþlar.
select * from kategori;
select * from urun;
select * from siparis_detay;
SELECT 
    K.kategori_ad,
    K.kategori_id,
    Sum(adet) as [Toplam Satýþ Adedi]
FROM Urun AS U
INNER JOIN Kategori AS K ON K.kategori_id = U.kategori_id
INNER JOIN Siparis_Detay AS D ON U.urun_id = D.urun_id
GROUP BY K.kategori_id, K.kategori_ad
ORDER BY [Toplam Satýþ Adedi] DESC;

--- Aylara göre sipariþ sayýsý
SELECT TOP 10
    YEAR(S.siparis_tarih) AS Yil,
    DATENAME(MONTH, S.siparis_tarih) AS Ay,
    COUNT(S.siparis_id) AS Siparis_Sayisi
FROM dbo.Siparis AS S
GROUP BY 
    YEAR(S.siparis_tarih),
    DATENAME(MONTH, S.siparis_tarih),
    MONTH(S.siparis_tarih)
ORDER BY 
    YEAR(S.siparis_tarih) DESC,
    MONTH(S.siparis_tarih) DESC;

--    JOIN’ler:
--- Sipariþlerde müþteri bilgisi + ürün bilgisi + satýcý bilgisi.
SELECT 
    SP.siparis_tarih as [Sipariþ Tarihi],
    M.musteri_ad + ' ' + M.musteri_soyad AS [Müþteri Bilgisi],
    U.urun_ad AS [Ürün Adý],
    U.urun_fiyat AS [Ürün Fiyatý],
    SA.satici_ad AS [Satýcý Adý],
    SA.satici_adres AS [Satýcý Adresi]
FROM Siparis AS SP
INNER JOIN Musteri AS M ON SP.musteri_id = M.musteri_id
INNER JOIN Siparis_Detay AS SD ON SP.siparis_id = SD.siparis_id
INNER JOIN Urun AS U ON SD.urun_id = U.urun_id
INNER JOIN Satici AS SA ON U.satici_id = SA.satici_id;

--- Hiç satýlmamýþ ürünler.
SELECT 
    U.urun_id,
    U.urun_ad,
    U.urun_fiyat,
    U.urun_stok
FROM Urun AS U
LEFT JOIN Siparis_Detay AS D
    ON U.urun_id = D.urun_id --tüm ürünleri getirir.
WHERE D.urun_id IS NULL; --Siparis_Detay’da kaydý olmayan (hiç satýlmamýþ) ürünleri filtreler.

--- Hiç sipariþ vermemiþ müþteriler.
SELECT 
    M.musteri_id,
    M.musteri_ad + ' ' + M.musteri_soyad AS [Müþteri Adý],
    M.email,
    M.sehir
FROM Musteri AS M
LEFT JOIN Siparis AS S ON M.musteri_id = S.musteri_id
WHERE S.musteri_id IS NULL;




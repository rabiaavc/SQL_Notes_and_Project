-- Raporlama Sorgular� 
--Temel Sorgular:
--- En �ok sipari� veren 5 m��teri.
SELECT TOP 5 
    M.musteri_id,
    M.musteri_ad + ' ' + M.musteri_soyad as [Musteri Ad�],
    Count(S.siparis_id) as [Siparis Say�s�]
FROM Musteri as M
INNER JOIN Siparis as S ON M.musteri_id = S.Musteri_id
Group by M.musteri_id, M.musteri_ad, M.musteri_soyad
ORDER BY [Siparis Say�s�] DESC;

--- En �ok sat�lan �r�nler.
SELECT * FROM S�PAR�S_DETAY;
SELECT TOP 10
urun_id,
Sum(adet) as [Toplam Sat�s Adedi]
FROM Siparis_detay 
GROUP BY urun_id
Order BY Sum(adet) DESC;

--- En y�ksek cirosu olan sat�c�lar.
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
--- �ehirlere g�re m��teri say�s�.
SELECT 
    M.sehir,
    COUNT(*) AS [Musteri Say�s�]
FROM Musteri AS M
GROUP BY M.sehir
ORDER BY [Musteri Say�s�] DESC ;

--- Kategori bazl� toplam sat��lar.
select * from kategori;
select * from urun;
select * from siparis_detay;
SELECT 
    K.kategori_ad,
    K.kategori_id,
    Sum(adet) as [Toplam Sat�� Adedi]
FROM Urun AS U
INNER JOIN Kategori AS K ON K.kategori_id = U.kategori_id
INNER JOIN Siparis_Detay AS D ON U.urun_id = D.urun_id
GROUP BY K.kategori_id, K.kategori_ad
ORDER BY [Toplam Sat�� Adedi] DESC;

--- Aylara g�re sipari� say�s�
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

--    JOIN�ler:
--- Sipari�lerde m��teri bilgisi + �r�n bilgisi + sat�c� bilgisi.
SELECT 
    SP.siparis_tarih as [Sipari� Tarihi],
    M.musteri_ad + ' ' + M.musteri_soyad AS [M��teri Bilgisi],
    U.urun_ad AS [�r�n Ad�],
    U.urun_fiyat AS [�r�n Fiyat�],
    SA.satici_ad AS [Sat�c� Ad�],
    SA.satici_adres AS [Sat�c� Adresi]
FROM Siparis AS SP
INNER JOIN Musteri AS M ON SP.musteri_id = M.musteri_id
INNER JOIN Siparis_Detay AS SD ON SP.siparis_id = SD.siparis_id
INNER JOIN Urun AS U ON SD.urun_id = U.urun_id
INNER JOIN Satici AS SA ON U.satici_id = SA.satici_id;

--- Hi� sat�lmam�� �r�nler.
SELECT 
    U.urun_id,
    U.urun_ad,
    U.urun_fiyat,
    U.urun_stok
FROM Urun AS U
LEFT JOIN Siparis_Detay AS D
    ON U.urun_id = D.urun_id --t�m �r�nleri getirir.
WHERE D.urun_id IS NULL; --Siparis_Detay�da kayd� olmayan (hi� sat�lmam��) �r�nleri filtreler.

--- Hi� sipari� vermemi� m��teriler.
SELECT 
    M.musteri_id,
    M.musteri_ad + ' ' + M.musteri_soyad AS [M��teri Ad�],
    M.email,
    M.sehir
FROM Musteri AS M
LEFT JOIN Siparis AS S ON M.musteri_id = S.musteri_id
WHERE S.musteri_id IS NULL;




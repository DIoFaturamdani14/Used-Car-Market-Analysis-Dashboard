-- implementasi tabel dimensi lokasi --
SELECT
ROW_NUMBER() OVER (ORDER BY Lokasi) AS Id_Lokasi,
Lokasi
INTO Dim_Lokasi
FROM
(
    SELECT DISTINCT Lokasi
    FROM Data_OLX_Final_Bersih
) x;

-- implementasi tabel dimensi waktu --
SELECT
ROW_NUMBER() OVER (ORDER BY Tahun) AS Id_Waktu,
Tahun
INTO Dim_Waktu
FROM
(
    SELECT DISTINCT
    CAST(Tahun AS INT)/10 AS Tahun
    FROM Data_OLX_Final_Bersih
) x;

-- implementasi tabel dimensi kendaraan --
SELECT
ROW_NUMBER() OVER (ORDER BY Merk_Mobil) AS Id_Kendaraan_Dim,
Merk_Mobil,
Model_Mobil,
Varian,
Transmisi,
Bahan_Bakar
INTO Dim_Kendaraan
FROM
(
    SELECT DISTINCT
    Merk_Mobil,
    Model_Mobil,
    Varian,
    Transmisi,
    Bahan_Bakar
    FROM Data_OLX_Final_Bersih
) x;


-- implementasi tabel fakta --
SELECT
d.Harga,
d.Kilometer,
d.Cluster,
d.Kategori_Mobil,
l.Id_Lokasi,
w.Id_Waktu,
k.Id_Kendaraan_Dim
INTO Fact_Kendaraan
FROM Data_OLX_Final_Bersih d
JOIN Dim_Lokasi l
ON d.Lokasi=l.Lokasi

JOIN Dim_Waktu w
ON CAST(d.Tahun AS INT)=w.Tahun

JOIN Dim_Kendaraan k
ON d.Merk_Mobil=k.Merk_Mobil
AND d.Model_Mobil=k.Model_Mobil
AND ISNULL(d.Varian,'')=ISNULL(k.Varian,'')
AND d.Transmisi=k.Transmisi
AND d.Bahan_Bakar=k.Bahan_Bakar;

SELECT COUNT(*)
FROM Fact_Kendaraan;

-- implementasi relasi antartabel --
ALTER TABLE Dim_Lokasi
ALTER COLUMN Id_Lokasi INT NOT NULL;

ALTER TABLE Dim_Waktu
ALTER COLUMN Id_Waktu INT NOT NULL;

ALTER TABLE Dim_Kendaraan
ALTER COLUMN Id_Kendaraan_Dim INT NOT NULL;

--- 

--- 
-- Primary Key

ALTER TABLE Fact_Kendaraan
ALTER COLUMN Id_Lokasi INT NOT NULL;

ALTER TABLE Fact_Kendaraan
ALTER COLUMN Id_Waktu INT NOT NULL;

ALTER TABLE Fact_Kendaraan
ALTER COLUMN Id_Kendaraan_Dim INT NOT NULL;


-- foreign key --
ALTER TABLE Fact_Kendaraan
ADD CONSTRAINT FK_Lokasi
FOREIGN KEY (Id_Lokasi)
REFERENCES Dim_Lokasi(Id_Lokasi);

ALTER TABLE Fact_Kendaraan
ADD CONSTRAINT FK_Waktu
FOREIGN KEY (Id_Waktu)
REFERENCES Dim_Waktu(Id_Waktu);

ALTER TABLE Fact_Kendaraan
ADD CONSTRAINT FK_Kendaraan
FOREIGN KEY (Id_Kendaraan_Dim)
REFERENCES Dim_Kendaraan(Id_Kendaraan_Dim);




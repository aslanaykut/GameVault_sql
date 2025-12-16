-- =====================================================
-- GAMEVAULT DATABASE
-- Veritabanı İşlemleri Ödevi
-- PostgreSQL Uyumlu SQL Dosyası
-- =====================================================
-- İçerik:
-- 1) Tablo Oluşturma
-- 2) Veri Ekleme
-- 3) Güncelleme / Silme
-- 4) Raporlama Sorguları
-- =====================================================


-- =====================================================
-- 1. TABLOLARIN OLUŞTURULMASI
-- =====================================================

-- Geliştirici firmalar tablosu
CREATE TABLE developers (
    id SERIAL PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    country VARCHAR(50),
    founded_year INT
);

-- Oyunlar tablosu
CREATE TABLE games (
    id SERIAL PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    price DECIMAL(8,2),
    release_date DATE,
    rating DECIMAL(3,1),
    developer_id INT,
    CONSTRAINT fk_developer
        FOREIGN KEY (developer_id)
        REFERENCES developers(id)
);

-- Oyun türleri tablosu
CREATE TABLE genres (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255)
);

-- Oyun - Tür ilişki tablosu
CREATE TABLE games_genres (
    id SERIAL PRIMARY KEY,
    game_id INT,
    genre_id INT,
    CONSTRAINT fk_game
        FOREIGN KEY (game_id)
        REFERENCES games(id),
    CONSTRAINT fk_genre
        FOREIGN KEY (genre_id)
        REFERENCES genres(id)
);


-- =====================================================
-- 2. VERİ EKLEME İŞLEMLERİ
-- =====================================================

-- Geliştirici firmalar
INSERT INTO developers (company_name, country, founded_year) VALUES
('CD Projekt Red', 'Poland', 2002),
('Rockstar Games', 'USA', 1998),
('Bethesda', 'USA', 1986),
('Valve', 'USA', 1996),
('Ubisoft', 'France', 1986);

-- Oyun türleri
INSERT INTO genres (name, description) VALUES
('RPG', 'Role Playing Game'),
('Open World', 'Open world exploration games'),
('Horror', 'Scary themed games'),
('FPS', 'First Person Shooter'),
('Sports', 'Sports themed games');

-- Oyunlar
INSERT INTO games (title, price, release_date, rating, developer_id) VALUES
('The Witcher 3', 599.99, '2015-05-19', 9.5, 1),
('Cyberpunk 2077', 499.99, '2020-12-10', 7.8, 1),
('GTA V', 699.99, '2013-09-17', 9.7, 2),
('Red Dead Redemption 2', 799.99, '2018-10-26', 9.8, 2),
('Skyrim', 399.99, '2011-11-11', 9.4, 3),
('Doom Eternal', 349.99, '2020-03-20', 8.9, 3),
('Half-Life 2', 199.99, '2004-11-16', 9.6, 4),
('CS:GO', 0.00, '2012-08-21', 8.5, 4),
('Assassin’s Creed Valhalla', 649.99, '2020-11-10', 8.3, 5),
('Far Cry 6', 599.99, '2021-10-07', 7.9, 5);

-- Oyun - Tür eşleştirmeleri
INSERT INTO games_genres (game_id, genre_id) VALUES
(1, 1), (1, 2),
(2, 1), (2, 2),
(3, 2),
(4, 2),
(5, 1),
(6, 4),
(7, 4),
(8, 4),
(9, 2),
(10, 2);


-- =====================================================
-- 3. GÜNCELLEME ve SİLME İŞLEMLERİ
-- =====================================================

-- Tüm oyunlara %10 indirim uygulanması
UPDATE games
SET price = price * 0.90;

-- Cyberpunk 2077 oyununun puanını güncelleme
UPDATE games
SET rating = 9.0
WHERE title = 'Cyberpunk 2077';

-- CS:GO oyununu silme (önce ilişki tablosundan)
DELETE FROM games_genres
WHERE game_id = (
    SELECT id FROM games WHERE title = 'CS:GO'
);

-- CS:GO oyununu games tablosundan silme
DELETE FROM games
WHERE title = 'CS:GO';


-- =====================================================
-- 4. RAPORLAMA SORGULARI (SELECT)
-- =====================================================

-- Oyunları geliştirici firmaları ile birlikte listeleme
SELECT
    g.title AS game_title,
    d.company_name AS developer
FROM games g
JOIN developers d ON g.developer_id = d.id;

-- RPG türündeki oyunları listeleme
SELECT
    g.title
FROM games g
JOIN games_genres gg ON g.id = gg.game_id
JOIN genres gr ON gg.genre_id = gr.id
WHERE gr.name = 'RPG';

-- Fiyatı 500 TL üzerindeki oyunlar
SELECT
    title, price
FROM games
WHERE price > 500;

-- Adında "War" geçen oyunlar
SELECT
    title
FROM games
WHERE title ILIKE '%War%';

-- En yüksek puanlı oyun
SELECT
    title, rating
FROM games
ORDER BY rating DESC
LIMIT 1;




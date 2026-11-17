-- ============================================================
-- Database & tabel untuk REST API UMKM (CodeIgniter 4)
-- Topic 10 - Rest API & JSON Parsing
-- ============================================================

CREATE DATABASE IF NOT EXISTS db_umkm
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE db_umkm;

DROP TABLE IF EXISTS umkm;

CREATE TABLE umkm (
  id         INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  nama_umkm  VARCHAR(150)  NOT NULL,
  pemilik    VARCHAR(100)  NOT NULL,
  alamat     TEXT          NOT NULL,
  kategori   VARCHAR(50)   NOT NULL,
  kontak     VARCHAR(20)   NOT NULL,
  created_at DATETIME      NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME      NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_umkm_kategori (kategori),
  KEY idx_umkm_nama (nama_umkm)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- Data contoh (data pertama sama dengan contoh di slide)
-- ------------------------------------------------------------
INSERT INTO umkm (nama_umkm, pemilik, alamat, kategori, kontak) VALUES
('Kopi Nusantara',   'Rafi A',        'Jl. Ayani No. 10, Banjarbaru',        'Kuliner',   '08123456789'),
('Batik Banjar Sasirangan', 'Siti Aminah', 'Jl. Pasar Baru No. 5, Banjarmasin', 'Fashion',   '08125550101'),
('Rotan Kalsel Craft','Budi Santoso',  'Jl. Veteran No. 22, Banjarmasin',     'Kerajinan', '08135550202'),
('Warung Soto Banjar','Hj. Norhayati', 'Jl. A. Yani Km 5, Banjarmasin',       'Kuliner',   '08115550303'),
('Laundry Kilat Bersih','Andi Pratama','Jl. Lambung Mangkurat No. 8, Banjarbaru','Jasa',    '08575550404');

CREATE DATABASE IF NOT EXISTS NetflixData;
USE NetflixData;

CREATE TABLE IF NOT EXISTS Shows (
    show_id VARCHAR(50) PRIMARY KEY,
    type ENUM('Movie', 'TV Show') NOT NULL,
    title VARCHAR(255) NOT NULL,
    director VARCHAR(255),
    cast TEXT,
    country VARCHAR(255),
    date_added DATE,
    release_year INT NOT NULL,
    rating VARCHAR(50),
    duration VARCHAR(50),
    listed_in TEXT NOT NULL,
    description TEXT NOT NULL
);
CREATE DATABASE IF NOT EXISTS ccdg
DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
CREATE TABLE example (
id           INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
zap          VARCHAR(64),
sproing      TIMESTAMP NULL
);
CREATE INDEX zap_idx ON example(zap);

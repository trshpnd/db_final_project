
/* Instancias.sql */

DROP VIEW IF EXISTS
	Bibliotecas;

DROP TABLE IF EXISTS 
	Categorization,
	Distribution,
	Development,
	Friendship,
	Credit_Card,
	Digital_Copy,
	Finished_Order,
	User_Order,
	Music_Track,
	Software,
	Soundtrack,
	Downloadable_Content,
	Game,
	Tag,
	Product,
	Company,
	Address,
	Usr;

CREATE TABLE Usr (
    steam_id BIGSERIAL NOT NULL PRIMARY KEY,
    email VARCHAR(60) NOT NULL,
    profile_url VARCHAR(30) NOT NULL,
    acc_name VARCHAR(30) NOT NULL,
    nickname VARCHAR(30),
    password CHAR(32) NOT NULL,
    profile_img VARCHAR(200),
    UNIQUE (email, profile_url)
);

CREATE TABLE Address (
    city VARCHAR(60),
    state VARCHAR(60),
    country VARCHAR(60),
    steam_id BIGSERIAL NOT NULL PRIMARY KEY
);

CREATE TABLE Company (
    cpny_id SERIAL NOT NULL PRIMARY KEY,
    cpny_name VARCHAR(60) NOT NULL
);

CREATE TABLE Product (
    product_id SERIAL PRIMARY KEY,
    product_url VARCHAR(30) NOT NULL,
    price NUMERIC(8,2) NOT NULL,
    release_date DATE NOT NULL,
    review_score SMALLINT CHECK (review_score>=0 AND review_score<7),
    product_name VARCHAR(100) NOT NULL,
    description VARCHAR(300),
    UNIQUE (product_url, product_name)
);

CREATE TABLE Tag (
    tag_id SMALLINT NOT NULL PRIMARY KEY,
    tag_name VARCHAR(30) NOT NULL UNIQUE,
	CHECK (tag_id >= 0)
);

CREATE TABLE Game (
    game_genre VARCHAR(30) NOT NULL,
    num_of_players SMALLINT NOT NULL,
    age_rating SMALLINT NOT NULL,
    product_id SERIAL PRIMARY KEY,
	CHECK (num_of_players>=0 AND num_of_players<=9),
	CHECK (age_rating>=0 AND age_rating<7)
);

CREATE TABLE Soundtrack (
    num_of_tracks SMALLINT NOT NULL,
    ost_length INTERVAL NOT NULL,
    product_id SERIAL PRIMARY KEY,
	CHECK (num_of_tracks >= 1)
);

CREATE TABLE Downloadable_Content (
    product_id SERIAL PRIMARY KEY,
    game_product_id SERIAL
);

CREATE TABLE Software (
    utility VARCHAR(30) NOT NULL,
    product_id SERIAL PRIMARY KEY
);

CREATE TABLE Music_Track (
    title VARCHAR(60) NOT NULL,
    duration INTERVAL NOT NULL,
    artist VARCHAR(60),
    track_id SERIAL NOT NULL PRIMARY KEY,
    product_id SERIAL
);

CREATE TABLE Digital_Copy (
    time_played INTERVAL NOT NULL DEFAULT '00:00:00',
    serial_key VARCHAR(30) UNIQUE,
    last_played DATE,
    steam_id BIGSERIAL,
    pchse_id SERIAL,
    product_id SERIAL,
    buyer_steam_id BIGSERIAL,
    PRIMARY KEY (steam_id, product_id)
);

CREATE TABLE User_Order (
    steam_id BIGSERIAL,
    product_id SERIAL,
    PRIMARY KEY (steam_id, product_id)
);

CREATE TABLE Finished_Order (
    payment_method SMALLINT NOT NULL,
    steam_id BIGSERIAL,
    pchse_id SERIAL,
    pchse_date DATE NOT NULL,
    pchse_type BOOLEAN NOT NULL,
    pchse_status SMALLINT NOT NULL,
    PRIMARY KEY (pchse_id, steam_id)
);

CREATE TABLE Credit_Card (
    card_name VARCHAR(30) NOT NULL,
    card_number CHAR(19) NOT NULL,
    security_code CHAR(3) NOT NULL,
    exp_date DATE NOT NULL,
    card_type SMALLINT NOT NULL,
    card_id SMALLINT NOT NULL,
    steam_id BIGSERIAL,
    PRIMARY KEY (card_id, steam_id)
);

CREATE TABLE Friendship (
    steam_id BIGSERIAL,
    friend_steam_id BIGSERIAL,
    PRIMARY KEY (steam_id, friend_steam_id)
);

CREATE TABLE Development (
    cpny_id SERIAL,
    product_id SERIAL,
    PRIMARY KEY (cpny_id, product_id)
);

CREATE TABLE Distribution (
    cpny_id SERIAL,
    product_id SERIAL,
    PRIMARY KEY (cpny_id, product_id)
);

CREATE TABLE Categorization (
    tag_id SMALLINT,
    product_id SERIAL,
    PRIMARY KEY (product_id, tag_id)
);
 
ALTER TABLE Address ADD CONSTRAINT FK_Address_2
    FOREIGN KEY (steam_id)
    REFERENCES Usr (steam_id);
 
ALTER TABLE Game ADD CONSTRAINT FK_Game_1
    FOREIGN KEY (product_id)
    REFERENCES Product (product_id)
    ON DELETE CASCADE;
 
ALTER TABLE Soundtrack ADD CONSTRAINT FK_Soundtrack_1
    FOREIGN KEY (product_id)
    REFERENCES Downloadable_Content (product_id)
    ON DELETE CASCADE;
 
ALTER TABLE Downloadable_Content ADD CONSTRAINT FK_Downloadable_Content_2
    FOREIGN KEY (product_id)
    REFERENCES Product (product_id)
    ON DELETE CASCADE;
 
ALTER TABLE Downloadable_Content ADD CONSTRAINT FK_Downloadable_Content_3
    FOREIGN KEY (game_product_id)
    REFERENCES Game (product_id)
    ON DELETE CASCADE;
 
ALTER TABLE Software ADD CONSTRAINT FK_Software_2
    FOREIGN KEY (product_id)
    REFERENCES Product (product_id)
    ON DELETE CASCADE;
 
ALTER TABLE Music_Track ADD CONSTRAINT FK_Music_Track_2
    FOREIGN KEY (product_id)
    REFERENCES Soundtrack (product_id)
    ON DELETE RESTRICT;
 
ALTER TABLE Digital_Copy ADD CONSTRAINT FK_Digital_Copy_2
    FOREIGN KEY (steam_id)
    REFERENCES Usr (steam_id)
    ON DELETE CASCADE;
 
ALTER TABLE Digital_Copy ADD CONSTRAINT FK_Digital_Copy_3
    FOREIGN KEY (pchse_id, buyer_steam_id)
    REFERENCES Finished_Order (pchse_id, steam_id)
    ON DELETE RESTRICT;
 
ALTER TABLE Digital_Copy ADD CONSTRAINT FK_Digital_Copy_4
    FOREIGN KEY (product_id)
    REFERENCES Product (product_id)
    ON DELETE CASCADE;
 
ALTER TABLE User_Order ADD CONSTRAINT FK_User_Order_1
    FOREIGN KEY (steam_id)
    REFERENCES Usr (steam_id)
    ON DELETE CASCADE;
 
ALTER TABLE User_Order ADD CONSTRAINT FK_User_Order_2
    FOREIGN KEY (product_id)
    REFERENCES Product (product_id)
    ON DELETE CASCADE;
 
ALTER TABLE Finished_Order ADD CONSTRAINT FK_Finished_Order_2
    FOREIGN KEY (steam_id)
    REFERENCES Usr (steam_id)
    ON DELETE CASCADE;
 
ALTER TABLE Credit_Card ADD CONSTRAINT FK_Credit_Card_2
    FOREIGN KEY (steam_id)
    REFERENCES Usr (steam_id)
    ON DELETE CASCADE;
 
ALTER TABLE Friendship ADD CONSTRAINT FK_Friendship_1
    FOREIGN KEY (steam_id)
    REFERENCES Usr (steam_id)
    ON DELETE CASCADE;
 
ALTER TABLE Friendship ADD CONSTRAINT FK_Friendship_2
    FOREIGN KEY (friend_steam_id)
    REFERENCES Usr (steam_id)
    ON DELETE CASCADE;
 
ALTER TABLE Development ADD CONSTRAINT FK_Development_1
    FOREIGN KEY (cpny_id)
    REFERENCES Company (cpny_id)
    ON DELETE RESTRICT;
 
ALTER TABLE Development ADD CONSTRAINT FK_Development_2
    FOREIGN KEY (product_id)
    REFERENCES Product (product_id)
    ON DELETE RESTRICT;
 
ALTER TABLE Distribution ADD CONSTRAINT FK_Distribution_1
    FOREIGN KEY (cpny_id)
    REFERENCES Company (cpny_id)
    ON DELETE RESTRICT;
 
ALTER TABLE Distribution ADD CONSTRAINT FK_Distribution_2
    FOREIGN KEY (product_id)
    REFERENCES Product (product_id)
    ON DELETE RESTRICT;
 
ALTER TABLE Categorization ADD CONSTRAINT FK_Categorization_1
    FOREIGN KEY (tag_id)
    REFERENCES Tag (tag_id)
    ON DELETE SET NULL;
 
ALTER TABLE Categorization ADD CONSTRAINT FK_Categorization_2
    FOREIGN KEY (product_id)
    REFERENCES Product (product_id)
    ON DELETE SET NULL;

INSERT INTO Usr VALUES(1000000000, 'returnofthe@king.com', '/strider_01', 'strider01', 'Strider', '5f4dcc3b5aa765d61d8327deb882cf99', 'keyboardcat.jpg');
INSERT INTO Usr VALUES(1100000000, 'iamelvenkin@mail.com', '/grnleaffff', 'legogrnlf', '360 No Scope', '6cb75f652a9b52798eb6cf2201057c73', 'nyancat.jpg');
INSERT INTO Usr VALUES(1110000000, 'sonofgloin@durinmail.com', '/youhavemyaxe', 'gimliofdurin', 'The Great Orc Slayer of Helm', '819b0643d6b89dc9b579fdfc9094f28e', 'grumpycat.jpg');
INSERT INTO Usr VALUES(1000110001, 'samgamgee@shire.net', '/sgamgee', 'samwisegg', 'Sam the Wise', '34cc93ece0ba9e3f6f235d4af979b16c', 'bigfloppa.png');
INSERT INTO Usr VALUES(1010110101, 'fbaggins@shire.net', '/fbaggins', 'fbaggins', 'Ringbearer', 'db0edd04aaac4506f7edab03ac855d56', 'maru_the_cat.png');
INSERT INTO Usr VALUES(1000000001, 'thewhite@isengard.com', '/ffffff_mage', 'iamcurunir', 'The White', '218dd27aebeccecae69ad8408d9a36bf', 'ohlongjohnson.bmp');
INSERT INTO Usr VALUES(1100000011, 'thegrey@pilgrimage.com', '/808080_mage', 'mithrandir', 'The Grey', '00cdb7bb942cf6b290ceb97d6aca64a3', 'bingus.bmp');
INSERT INTO Usr VALUES(1110000111, 'thelord@therings.com', '/000000_lord', 'makerofthe01', 'The Eye', 'a900c44095c521ad41a09bbdde914229', 'normalize_beig_evil.png');

INSERT INTO Address VALUES('Minas Tirith','White Mountains','Gondor',1000000000);
INSERT INTO Address VALUES('Woodland Realm','Mirkwood','Rhovanion',1100000000);
INSERT INTO Address VALUES('Lonely Mountain','Erebor','Rhovanion',1110000000);
INSERT INTO Address VALUES('Hobbiton','The Shire','Eriador',1000110001);
INSERT INTO Address VALUES('Hobbiton','The Shire','Eriador',1010110101);
INSERT INTO Address VALUES('Isengard','Misty Mountains','Eriador',1000000001);
INSERT INTO Address VALUES(NULL,NULL,'Arda',1100000011);
INSERT INTO Address VALUES('Barad-dur','Plateau of Gorgoroth','Mordor',1110000111);

INSERT INTO Company VALUES(1, 'Valve');
INSERT INTO Company VALUES(2, 'Obsidian Entertainment');
INSERT INTO Company VALUES(3, 'Bethesda Softworks');
INSERT INTO Company VALUES(4, 'Platinum Games');
INSERT INTO Company VALUES(5, 'SEGA');
INSERT INTO Company VALUES(6, 'From Software');
INSERT INTO Company VALUES(7, 'Bandai Namco');
INSERT INTO Company VALUES(8, 'Ensemble Studios');
INSERT INTO Company VALUES(9, 'Hidden Path');
INSERT INTO Company VALUES(10, 'Xbox Games Studios');
INSERT INTO Company VALUES(11, 'Manic Mind Game Lab');
INSERT INTO Company VALUES(12, 'Stellar Stone');
INSERT INTO Company VALUES(13, 'Nintendo');
INSERT INTO Company VALUES(14, 'Kunos Simulazioni');
INSERT INTO Company VALUES(15, 'Wallpaper Engine Team');

INSERT INTO Product VALUES(11, '/portal_2', 39.90, '2011-04-18', 6, 'Portal 2', 'Thinking with portals.');
INSERT INTO Product VALUES(12, '/fallout_new_vegas', 19.90, '2010-10-19', 5, 'Fallout: New Vegas', 'War never changes.');
INSERT INTO Product VALUES(13, '/bayonetta', 32.90, '2009-10-29', 5, 'Bayonetta', NULL);
INSERT INTO Product VALUES(14, '/assetto_corsa', 9.90, '2014-12-19', 4, 'Assetto Corsa', NULL);
INSERT INTO Product VALUES(15, '/dark_souls_3', 79.90, '2016-03-24', 5, 'Dark Souls III', 'Prepare to die. Again.');
INSERT INTO Product VALUES(16, '/age_of_empires_2_hd_edition', 24.90, '2016-12-19', 5, 'Age of Empires II - HD Edition', NULL);
INSERT INTO Product VALUES(17, '/mineirinho_ultra_adventures', 3.90, '2017-01-27', 2, 'Mineirinho Ultra Adventures', NULL);
INSERT INTO Product VALUES(18, '/big_rigs', 3.90, '2003-11-20', 0, 'Big Rigs: Over the Road Racing', 'The worst racing game ever made!');
INSERT INTO Product VALUES(21, '/source_filmmaker', 0.00, '2012-06-27', 5, 'Source Filmmaker', 'Make movies and animations with your favorite game franchises.');
INSERT INTO Product VALUES(22, '/wallpaper_engine', 9.99, '2016-10-10', 4, 'Wallpaper Engine', NULL);
INSERT INTO Product VALUES(31, '/portal_2_soundtrack', 0.00, '2011-04-18', NULL, 'Portal 2: Songs to Test By', NULL);
INSERT INTO Product VALUES(32, '/fallout_new_vegas_dead_money', 19.90, '2011-02-22', 4, 'Fallout New Vegas: Dead Money', NULL);
INSERT INTO Product VALUES(33, '/dark_souls_3_the_ringed_city', 49.90, '2017-03-27', 5, 'Dark Souls III: The Ringed City', NULL);

INSERT INTO Tag VALUES(1, 'Souls-like');
INSERT INTO Tag VALUES(2, 'Indie');
INSERT INTO Tag VALUES(3, 'Anime');
INSERT INTO Tag VALUES(4, 'Female Protagonist');
INSERT INTO Tag VALUES(5, 'Survival Horror');
INSERT INTO Tag VALUES(6, 'Open World');
INSERT INTO Tag VALUES(7, 'First-Person');
INSERT INTO Tag VALUES(8, 'Choices Matter');
INSERT INTO Tag VALUES(9, 'Retro');
INSERT INTO Tag VALUES(10, 'Sandbox');
INSERT INTO Tag VALUES(11, 'Windows Compatible');
INSERT INTO Tag VALUES(12, 'Linux Compatible');
INSERT INTO Tag VALUES(13, 'MacOS Compatible');

INSERT INTO Game VALUES('Puzzle', 2, 2, 11);
INSERT INTO Game VALUES('RPG', 1, 4, 12);
INSERT INTO Game VALUES('Action', 1, 4, 13);
INSERT INTO Game VALUES('Racing', 0, 1, 14);
INSERT INTO Game VALUES('Action', 0, 4, 15);
INSERT INTO Game VALUES('Real-Time Strategy', 8, 3, 16);
INSERT INTO Game VALUES('Platformer', 1, 0, 17);
INSERT INTO Game VALUES('Racing', 1, 1, 18);

INSERT INTO Downloadable_Content VALUES(31, 11);
INSERT INTO Downloadable_Content VALUES(32, 12);
INSERT INTO Downloadable_Content VALUES(33, 15);

INSERT INTO Soundtrack VALUES(10, '1:01:01', 31);

INSERT INTO Software VALUES('Animation', 21);
INSERT INTO Software VALUES('Customization', 22);

INSERT INTO Music_Track VALUES('Want You Gone', '2:21', 'Jonathan Coulton', 1, 31);
INSERT INTO Music_Track VALUES('Cara Mia Addio', '2:33', 'Aperture Science Psychoacoustics Laboratory', 2, 31);
INSERT INTO Music_Track VALUES('TEST', '6:14', 'Aperture Science Psychoacoustics Laboratory', 3, 31);
INSERT INTO Music_Track VALUES('Science is Fun', '2:33', 'Aperture Science Psychoacoustics Laboratory', 4, 31);

INSERT INTO Friendship VALUES(1000000000, 1100000000);
INSERT INTO Friendship VALUES(1000000000, 1110000000);
INSERT INTO Friendship VALUES(1100000000, 1110000000);

INSERT INTO Friendship VALUES(1000000000, 1000110001);
INSERT INTO Friendship VALUES(1000000000, 1010110101);
INSERT INTO Friendship VALUES(1000110001, 1010110101);

INSERT INTO Friendship VALUES(1100000011, 1000000001);
INSERT INTO Friendship VALUES(1100000011, 1000110001);
INSERT INTO Friendship VALUES(1100000011, 1010110101);

INSERT INTO Friendship VALUES(1000000001, 1110000111);

INSERT INTO Development VALUES(1, 11);
INSERT INTO Development VALUES(2, 12);
INSERT INTO Development VALUES(4, 13);
INSERT INTO Development VALUES(14, 14);
INSERT INTO Development VALUES(6, 15);
INSERT INTO Development VALUES(8, 16);
INSERT INTO Development VALUES(9, 16);
INSERT INTO Development VALUES(11, 17);
INSERT INTO Development VALUES(12, 18);
INSERT INTO Development VALUES(1, 21);
INSERT INTO Development VALUES(1, 31);
INSERT INTO Development VALUES(2, 32);
INSERT INTO Development VALUES(6, 33);
INSERT INTO Development VALUES(15, 22);

INSERT INTO Distribution VALUES(1, 11);
INSERT INTO Distribution VALUES(3, 12);
INSERT INTO Distribution VALUES(5, 13);
INSERT INTO Distribution VALUES(14, 14);
INSERT INTO Distribution VALUES(7, 15);
INSERT INTO Distribution VALUES(10, 16);
INSERT INTO Distribution VALUES(11, 17);
INSERT INTO Distribution VALUES(12, 18);
INSERT INTO Distribution VALUES(1, 21);
INSERT INTO Distribution VALUES(1, 31);
INSERT INTO Distribution VALUES(3, 32);
INSERT INTO Distribution VALUES(7, 33);

INSERT INTO Categorization VALUES(1, 15);
INSERT INTO Categorization VALUES(2, 14);
INSERT INTO Categorization VALUES(2, 17);
INSERT INTO Categorization VALUES(4, 13);
INSERT INTO Categorization VALUES(6, 12);
INSERT INTO Categorization VALUES(7, 11);
INSERT INTO Categorization VALUES(7, 12);
INSERT INTO Categorization VALUES(8, 12);
INSERT INTO Categorization VALUES(9, 16);
INSERT INTO Categorization VALUES(11, 11);
INSERT INTO Categorization VALUES(11, 12);
INSERT INTO Categorization VALUES(11, 13);
INSERT INTO Categorization VALUES(11, 14);
INSERT INTO Categorization VALUES(11, 15);
INSERT INTO Categorization VALUES(11, 16);
INSERT INTO Categorization VALUES(11, 17);
INSERT INTO Categorization VALUES(11, 18);
INSERT INTO Categorization VALUES(11, 21);
INSERT INTO Categorization VALUES(11, 22);
INSERT INTO Categorization VALUES(12, 11);
INSERT INTO Categorization VALUES(12, 21);

INSERT INTO Finished_Order VALUES(1, 1000000000, 1, '2022-02-02', FALSE, 2);
INSERT INTO Finished_Order VALUES(1, 1000000000, 2, '2022-11-06', FALSE, 2);
INSERT INTO Finished_Order VALUES(2, 1100000000, 1, '2020-02-02', FALSE, 2);
INSERT INTO Finished_Order VALUES(3, 1110000000, 1, '2019-11-06', FALSE, 2);
INSERT INTO Finished_Order VALUES(4, 1000000001, 1, '2021-01-31', FALSE, 2);
INSERT INTO Finished_Order VALUES(3, 1000000001, 2, '2022-01-31', TRUE, 2);
INSERT INTO Finished_Order VALUES(2, 1100000011, 1, '2019-11-06', FALSE, 2);
INSERT INTO Finished_Order VALUES(1, 1100000011, 2, '2022-02-02', TRUE, 2);

INSERT INTO Digital_Copy VALUES('05h 30m 00s', NULL, '2022-05-07', 1000000000, 1, 11, 1000000000);
INSERT INTO Digital_Copy VALUES('06h 40m 00s', NULL, '2022-05-06', 1000000000, 1, 12, 1000000000);
INSERT INTO Digital_Copy VALUES(DEFAULT, NULL, NULL, 1000000000, 2, 14, 1000000000);
INSERT INTO Digital_Copy VALUES(DEFAULT, NULL, NULL, 1000000000, 2, 16, 1000000000);

INSERT INTO Digital_Copy VALUES('10h 30m 00s', NULL, '2022-05-07', 1100000000, 1, 13, 1100000000);
INSERT INTO Digital_Copy VALUES('21h 00m 00s', NULL, '2022-05-08', 1100000000, 1, 15, 1100000000);
INSERT INTO Digital_Copy VALUES('106h 30m 00s', NULL, '2022-05-09', 1100000000, 1, 22, 1100000011);

INSERT INTO Digital_Copy VALUES('50h 00m 00s', NULL, '2021-05-08', 1100000011, 1, 11, 1100000011);
INSERT INTO Digital_Copy VALUES('101h 01m 01s', NULL, '2020-11-06', 1100000011, 2, 12, 1100000011);
INSERT INTO Digital_Copy VALUES('202h 02m 02s', NULL, '2019-01-31', 1100000011, 2, 16, 1100000011);

INSERT INTO Digital_Copy VALUES(DEFAULT, NULL, NULL, 1000000001, 1, 11, 1100000011);
INSERT INTO Digital_Copy VALUES('12h 12m 12s', NULL, '2022-05-07', 1000000001, 1, 15, 1000000001);
INSERT INTO Digital_Copy VALUES('55h 55m 55s', NULL, '2022-05-09', 1000000001, 1, 17, 1000000001);

INSERT INTO Digital_Copy VALUES(DEFAULT, NULL, NULL, 1110000111, 2, 18, 1000000001);

--SELECT nickname, product_name, time_played
--from Digital_Copy natural join Product natural join Usr;


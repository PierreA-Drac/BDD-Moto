CREATE DATABASE Moto;

CREATE USER 'Moto_Admin'@'127.0.0.1' IDENTIFIED BY 'moto_admin';
GRANT ALL ON Moto.* TO 'Moto_Admin'@'127.0.0.1' WITH GRANT OPTION;
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'Moto_Admin'@'127.0.0.1';

CREATE USER 'Moto_User'@'127.0.0.1' IDENTIFIED BY 'moto_user';
GRANT SELECT                 ON Moto.*       TO 'Moto_User'@'127.0.0.1';
GRANT INSERT, UPDATE, DELETE ON Moto.Possede TO 'Moto_User'@'127.0.0.1';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'Moto_User'@'127.0.0.1';

CREATE TABLE Utilisateurs (
    identifiant         VARCHAR(40) NOT NULL,
    mot_de_passe        VARCHAR(40) NOT NULL,
    date_inscription    VARCHAR(10) NOT NULL,
    age                 INT(3),
    sexe                VARCHAR(8),
    PRIMARY KEY (identifiant)
);

CREATE TABLE Modele_moto (
    marque      VARCHAR(40) NOT NULL,
    nom_modele  VARCHAR(40) NOT NULL,
    annee       INT(4)      NOT NULL,
    cylindree   INT(4),
    couple      INT,
    puissance   INT(3),
    poids       INT(3),
    prix        INT,
    type_moto   VARCHAR(40),
    PRIMARY KEY (nom_modele, annee)
);

CREATE TABLE Marque (
    nom             VARCHAR(40) NOT NULL,
    pays            VARCHAR(40),
    annee_creation  VARCHAR(4),
    PRIMARY KEY (nom)
);

CREATE TABLE Team (
    nom     VARCHAR(40) NOT NULL,
    marque  VARCHAR(40) NOT NULL,
    PRIMARY KEY (nom)
);

CREATE TABLE Pilote (
    id      INT         NOT NULL,
    nom     VARCHAR(40) NOT NULL,
    prenom  VARCHAR(40) NOT NULL,
    age     INT(3),
    pays    VARCHAR(40),
    sexe    VARCHAR(8),
    numero  INT(2),
    PRIMARY KEY (id)
);

CREATE TABLE Course_vitesse (
    championnat VARCHAR(40) NOT NULL,
    date_course VARCHAR(10) NOT NULL,
    circuit     VARCHAR(40) NOT NULL,
    pays        VARCHAR(40) NOT NULL,
    PRIMARY KEY (championnat, date_course)
);

CREATE TABLE Possede (
    identifiant VARCHAR(40) NOT NULL,
    modele      VARCHAR(40) NOT NULL,
    annee       INT(4)      NOT NULL,
    PRIMARY KEY (identifiant, modele, annee)
);

CREATE TABLE Utilise (
    id_pilote       INT         NOT NULL,
    modele          VARCHAR(40) NOT NULL,
    modele_annee    INT(4)      NOT NULL,
    annee_debut     VARCHAR(10) NOT NULL,
    annee_fin       VARCHAR(10),
    PRIMARY KEY (id_pilote, modele, modele_annee, annee_debut)
);

CREATE TABLE Fait_partie (
    id_pilote   INT         NOT NULL,
    nom_team    VARCHAR(40) NOT NULL,
    annee_debut  VARCHAR(10) NOT NULL,
    annee_fin    VARCHAR(10),
    PRIMARY KEY (id_pilote, nom_team, annee_debut)
);

CREATE TABLE Participe (
    id_pilote       INT         NOT NULL,
    championnat     VARCHAR(40) NOT NULL,
    date_course     VARCHAR(10) NOT NULL,
    classement      INT(2),
    points_gagnes   INT(2),
    vitesse_moy     INT(6),
    meilleur_tour   INT(6),
    PRIMARY KEY (id_pilote, championnat, date_course)
);

ALTER TABLE Modele_moto
    ADD FOREIGN KEY (marque) REFERENCES Marque (nom);

ALTER TABLE Team
    ADD FOREIGN KEY (marque) REFERENCES Marque (nom);

ALTER TABLE Possede
    ADD FOREIGN KEY (identifiant) REFERENCES Utilisateurs (identifiant),
    ADD FOREIGN KEY (modele, annee) REFERENCES Modele_moto (nom_modele, annee);

ALTER TABLE Utilise
    ADD FOREIGN KEY (id_pilote) REFERENCES Pilote (id),
    ADD FOREIGN KEY (modele, modele_annee) REFERENCES Modele_moto (nom_modele, annee);

ALTER TABLE Fait_partie
    ADD FOREIGN KEY (id_pilote) REFERENCES Pilote (id),
    ADD FOREIGN KEY (nom_team) REFERENCES Team (nom);

ALTER TABLE Participe
    ADD FOREIGN KEY (id_pilote) REFERENCES Pilote (id),
    ADD FOREIGN KEY (championnat, date_course) REFERENCES Course_vitesse (championnat, date_course);

INSERT INTO Marque VALUES
    ('Yamaha', 'Japon', 1887),
    ('Ducati', 'Italie', 1926),
    ('Kawasaki', 'Japon', 1896),
    ('BMW', 'Allemagne', 1916),
    ('Norton', 'Angleterre', 1898),
    ('Honda', 'Japon', 1948),
    ('Triumph', 'Angleterre', 1885),
    ('MV Agusta', 'Italie', 1948),
    ('Suzuki', 'Japon', 1909),
    ('Mash', NULL, NULL);

INSERT INTO Modele_moto VALUES
    ('Yamaha', 'R1', 2017, 998, 11.5, 200, 199, 18999, 'Sportive'),
    ('Ducati', '1299 Panigale', 2017, 1285, 14.74, 205, 190, 21390, 'Sportive'),
    ('Kawasaki', 'ZX-10R', 2015, 998, 11.6, 200, 206, 17599, 'Sportive'),
    ('Kawasaki', 'ZX-10R', 2016, 998, 11.6, 200, 206, 17599, 'Sportive'),
    ('Mash', '400 TT40 Cafe Racer', 2017, 397, 3.06, 28, 170, 4990, 'Cafe Racer'),
    ('Norton', '961 Commando Cafe Racer MK II', 2017, 961, 9.2, 80, 205, 23900, 'Cafe Racer'),
    ('BMW', '1200 Nine-T Racer', 2017, 1170, 11.8, 110, 220, 13850, 'Cafe Racer'),
    ('Ducati', 'Desmosedici GP', 2013, 1000, NULL, 250, 165, NULL, 'Sportive'),
    ('Yamaha', 'M1', 2016, 1000, NULL, 240, 157, NULL, 'Sportive'),
    ('Honda', 'RC213V', 2012, 1000, NULL, 260, 160, NULL, 'Sportive'),
    ('Honda', 'RC213V-RS', 2015, 1000, NULL, 260, 160, NULL, 'Sportive'),
    ('Suzuki', 'GSX-R1000', 2014, 1000, 12, 240, 157, 18500, 'Sportive'),
    ('Suzuki', 'GSX-RR', 2014, 1000, NULL, 193, 203, NULL, 'Sportive');

INSERT INTO Utilisateurs VALUES
    ('Pierre', 'pierre37', '27/11/2017', 20, 'Homme'),
    ('Claire', 'claire37', '28/11/2017', 21, 'Femme'),
    ('Damien', 'damien37', '21/11/2017', 26, 'Homme'),
    ('Florine', 'florine37', '23/11/2017', 20, 'Femme'),
    ('Pascal', 'pascal37', '14/11/2016', 56, 'Homme');

INSERT INTO Possede VALUES
    ('Pierre', '1299 Panigale', '2017'),
    ('Pierre', '961 Commando Cafe Racer MK II', '2017'),
    ('Damien', '1200 Nine-T Racer', '2017');

INSERT INTO Team VALUES
    ('Ducati Team', 'Ducati'),
    ('Monster Yamaha Tech3', 'Yamaha'),
    ('Movistar Yamaha MotoGP', 'Yamaha'),
    ('LCR Honda', 'Honda'),
    ('Repsol Honda Team', 'Honda'),
    ('Team Suzuki Ecstar MotoGP', 'Suzuki'),
    ('Voltcom Crescent Suzuki', 'Suzuki'),
    ('Kawasaki Racing Team', 'Kawasaki');

INSERT INTO Pilote VALUES
    (0, 'Dovizioso', 'Andrea', 31, 'Italie', 'Homme', 4),
    (1, 'Lorenzo', 'Jorgue', 30, 'Espagne', 'Homme', 99),
    (2, 'Zarco', 'Johann', 27, 'France', 'Homme', 5),
    (3, 'Folger', 'Jonas', 24, 'Allemagne', 'Homme', 94),
    (4, 'Rossi', 'Valentino', 38, 'Italie', 'Homme', 46),
    (5, 'Vinales', 'Maverick', 22, 'Espagne', 'Homme', 25),
    (6, 'Crutchlow', 'Cal', 32, 'Angleterre', 'Homme', 35),
    (7, 'Marquez', 'Marc', 24, 'Espagne', 'Homme', 93),
    (8, 'Pedrosa', 'Daniel', 32, 'Espagne', 'Homme', 26),
    (9, 'Ianonne', 'Andrea', 28, 'Italie', 'Homme', 29),
    (10, 'Rins', 'Alex', 21, 'Espagne', 'Homme', 42),
    (11, 'Miller', 'Jack', 22, 'Australie', 'Homme', 43),
    (12, 'de Puniet', 'Randy', 36, 'France', 'Homme', 14),
    (13, 'Lowes', 'Alex', 27, 'Angleterre', 'Homme', 22),
    (14, 'Sykes', 'Tom', 32, 'Angleterre', 'Homme', 66);

INSERT INTO Fait_partie VALUES
    (0, 'Monster Yamaha Tech3', 2012, 2012),
    (0, 'Ducati Team', 2013, NULL),
    (1, 'Movistar Yamaha MotoGP', 2009, 2016),
    (1, 'Ducati Team', 2017, NULL),
    (2, 'Monster Yamaha Tech3', 2017, NULL),
    (3, 'Monster Yamaha Tech3', 2017, NULL),
    (4, 'Ducati Team', 2011, 2012),
    (4, 'Movistar Yamaha MotoGP', 2013, NULL),
    (5, 'Team Suzuki Ecstar MotoGP', 2015, 2016),
    (5, 'Movistar Yamaha MotoGP', 2017, NULL),
    (6, 'Monster Yamaha Tech3', 2011, 2013),
    (6, 'Ducati Team', 2014, 2014),
    (6, 'LCR Honda', 2015, NULL),
    (7, 'Repsol Honda Team', 2013, NULL),
    (8, 'Repsol Honda Team', 2006, NULL),
    (9, 'Ducati Team', 2013, 2016),
    (9, 'Team Suzuki Ecstar MotoGP', 2017, NULL),
    (10, 'Team Suzuki Ecstar MotoGP', 2017, NULL),
    (11, 'LCR Honda', 2015, NULL),
    (12, 'Voltcom Crescent Suzuki', 2014, NULL),
    (13, 'Voltcom Crescent Suzuki', 2011, 2015),
    (14, 'Kawasaki Racing Team', 2010, NULL);

INSERT INTO Utilise VALUES
    (0, 'Desmosedici GP', 2013, 2016, NULL),
    (1, 'M1', 2016, 2016, 2016),
    (1, 'Desmosedici GP', 2013, 2017, NULL),
    (2, 'M1', 2016, 2016, NULL),
    (3, 'M1', 2016, 2016, NULL),
    (4, 'M1', 2016, 2016, NULL),
    (5, 'GSX-RR', 2014, 2015, 2016),
    (5, 'M1', 2016, 2017, NULL),
    (6, 'RC213V', 2012, 2015, NULL),
    (7, 'RC213V', 2012, 2013, NULL),
    (8, 'RC213V', 2012, 2012, NULL),
    (9, 'Desmosedici GP', 2013, 2013, 2016),
    (9, 'GSX-RR', 2014, 2017, NULL),
    (10, 'GSX-RR', 2014, 2017, NULL),
    (11, 'RC213V-RS', 2015, 2015, NULL),
    (12, 'GSX-R1000', 2014, 2014, NULL),
    (13, 'GSX-R1000', 2014, 2014, 2015),
    (14, 'ZX-10R', 2015, 2015, NULL);

INSERT INTO Course_vitesse VALUES
    ('MotoGP', '20/03/2016', 'Losail International Circuit', 'Quatar'),
    ('MotoGP', '24/04/2016', 'Circuit de Jerez', 'Espagne'),
    ('MotoGP', '05/06/2016', 'Circuit de Catalunya', 'Catalogne'),
    ('MotoGP', '26/06/2016', 'TT Circuit Assen', 'Pays-Bas'),
    ('MotoGP', '04/09/2016', 'Silverstone Circuit', 'Angleterre'),
    ('MotoGP', '25/09/2016', 'Motorland Aragón', 'Espagne'),
    ('Superbike', '22/02/2015', 'Phillip Island', 'Australie');

INSERT INTO Participe VALUES
    (1, 'MotoGP', '20/03/2016', 1, 25, 167.1, 114.543),
    (0, 'MotoGP', '20/03/2016', 2, 20, 167.0, NULL),
    (7, 'MotoGP', '20/03/2016', 3, 16, 167.0, NULL),
    (4, 'MotoGP', '20/03/2016', 4, 13, 167.0, NULL),
    (8, 'MotoGP', '20/03/2016', 5, 11, 166.2, NULL),
    (5, 'MotoGP', '20/03/2016', 6, 10, 166.1, NULL),
    (11, 'MotoGP', '20/03/2016', 14, 2, 164.4, NULL),
    (6, 'MotoGP', '20/03/2016', 0, 0, 165.0, NULL),
    (4, 'MotoGP', '24/04/2016', 1, 25, 157.5, 100.090),
    (1, 'MotoGP', '24/04/2016', 2, 20, 157.4, NULL),
    (7, 'MotoGP', '24/04/2016', 3, 16, 157.1, NULL),
    (8, 'MotoGP', '24/04/2016', 4, 13, 156.9, NULL),
    (5, 'MotoGP', '24/04/2016', 6, 10, 156.5, NULL),
    (9, 'MotoGP', '24/04/2016', 7, 9, 156.0, NULL),
    (6, 'MotoGP', '24/04/2016', 11, 5, 155.3, NULL),
    (11, 'MotoGP', '24/04/2016', 17, 0, 154.7, NULL),
    (0, 'MotoGP', '24/04/2016', 0, 0, 157.7, NULL),
    (4, 'MotoGP', '05/06/2016', 1, 25, 156.4, NULL),
    (7, 'MotoGP', '05/06/2016', 2, 20, 156.3, 105.971),
    (8, 'MotoGP', '05/06/2016', 3, 16, 156.0, NULL),
    (5, 'MotoGP', '05/06/2016', 4, 13, 155.0, NULL),
    (6, 'MotoGP', '05/06/2016', 6, 10, 154.3, NULL),
    (0, 'MotoGP', '05/06/2016', 7, 9, 154.0, NULL),
    (11, 'MotoGP', '05/06/2016', 10, 6, 153.6, NULL),
    (1, 'MotoGP', '05/06/2016', 0, 0, 155.9, NULL),
    (9, 'MotoGP', '05/06/2016', 0, 0, 155.8, NULL),
    (11, 'MotoGP', '26/06/2016', 1, 25, 146.7, NULL),
    (7, 'MotoGP', '26/06/2016', 2, 20, 146.4, NULL),
    (9, 'MotoGP', '26/06/2016', 5, 11, 144.7, NULL),
    (5, 'MotoGP', '26/06/2016', 9, 7, 143.8, NULL),
    (1, 'MotoGP', '26/06/2016', 10, 6, 143.7, NULL),
    (4, 'MotoGP', '26/06/2016', 0, 0, 145.1, NULL),
    (0, 'MotoGP', '26/06/2016', 0, 0, 140.8, NULL),
    (6, 'MotoGP', '26/06/2016', 0, 0, 0, NULL),
    (5, 'MotoGP', '04/09/2016', 1, 25, 172.1, 122.339),
    (6, 'MotoGP', '04/09/2016', 2, 20, 171.9, NULL),
    (4, 'MotoGP', '04/09/2016', 3, 16, 171.9, NULL),
    (7, 'MotoGP', '04/09/2016', 4, 13, 171.7, NULL),
    (8, 'MotoGP', '04/09/2016', 5, 11, 171.7, NULL),
    (0, 'MotoGP', '04/09/2016', 6, 10, 171.3, NULL),
    (1, 'MotoGP', '04/09/2016', 8, 8, 170.7, NULL),
    (11, 'MotoGP', '04/09/2016', 16, 0, 168.7, NULL),
    (7, 'MotoGP', '25/09/2016', 1, 25, 167.0, 108.694),
    (1, 'MotoGP', '25/09/2016', 2, 20, 166.8, NULL),
    (4, 'MotoGP', '25/09/2016', 3, 16, 166.6, NULL),
    (5, 'MotoGP', '25/09/2016', 4, 13, 166.4, NULL),
    (6, 'MotoGP', '25/09/2016', 5, 11, 166.1, NULL),
    (8, 'MotoGP', '25/09/2016', 6, 10, 165.8, NULL),
    (0, 'MotoGP', '25/09/2016', 11, 5, 164.8, NULL),
    (12, 'Superbike', '22/02/2015', 17, 0, NULL, 92.402),
    (13, 'Superbike', '22/02/2015', 9, 7, NULL, 92.690),
    (14, 'Superbike', '22/02/2015', 6, 10, NULL, 92.016);

CREATE VIEW MotoGP_2016_Score_pilotes AS
    SELECT Pi.id, Pi.prenom, Pi.nom, Pi.numero, SUM(Pa.points_gagnes) AS nombre_total_de_point
    FROM Pilote Pi, Participe Pa
    WHERE Pa.id_pilote = Pi.id
        AND Pa.championnat LIKE "MotoGP"
        AND Pa.date_course LIKE "%2016"
    GROUP BY Pi.id
    ORDER BY Nombre_total_de_point DESC;

CREATE VIEW MotoGP_2016_Score_teams AS
    SELECT F.nom_team, SUM(nombre_total_de_point) AS nombre_total_de_point
    FROM Fait_partie F, MotoGP_2016_Score_pilotes
    WHERE MotoGP_2016_Score_pilotes.id = F.id_pilote
        AND F.annee_debut <= 2016
        AND (
            F.annee_fin >= 2016
            OR F.annee_fin IS NULL
        )
    GROUP BY F.nom_team
    ORDER BY Nombre_total_de_point DESC;

CREATE VIEW MotoGP_2016_Score_constructeurs AS
    SELECT T.marque, SUM(nombre_total_de_point) AS nombre_total_de_point
    FROM Team T, MotoGP_2016_Score_teams
    WHERE T.nom = MotoGP_2016_Score_teams.nom_team
    GROUP BY T.marque
    ORDER BY Nombre_total_de_point DESC;

CREATE VIEW Pilote_stat AS
    SELECT Pi.id AS Identifiant, Pi.nom AS Nom, Pi.prenom AS Prenom,
        Pi.age AS Age, Pi.pays AS Pays, Pi.sexe AS Sexe, Pi.numero AS Numero,
    	SUM(Pa.points_gagnes) AS Nombre_de_point,
        MIN(Pa.classement) AS Classement,
        MAX(Pa.vitesse_moy) AS Vitesse_moyenne,
        MIN(Pa.meilleur_tour) AS Meilleur_tour
    FROM Pilote Pi, Participe Pa
    WHERE Pa.id_pilote = Pi.id;

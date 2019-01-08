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

ALTER TABLE Utilise
    ADD FOREIGN KEY (id_pilote) REFERENCES Pilote (id),
    ADD FOREIGN KEY (modele, modele_annee) REFERENCES Modele_moto (nom_modele, annee);

ALTER TABLE Fait_partie
    ADD FOREIGN KEY (id_pilote) REFERENCES Pilote (id),
    ADD FOREIGN KEY (nom_team) REFERENCES Team (nom);

ALTER TABLE Participe
    ADD FOREIGN KEY (id_pilote) REFERENCES Pilote (id),
    ADD FOREIGN KEY (championnat, date_course) REFERENCES Course_vitesse (championnat, date_course);

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

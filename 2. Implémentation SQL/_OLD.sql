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

ALTER TABLE Utilise
    ADD FOREIGN KEY (id_pilote) REFERENCES Pilote (id),
    ADD FOREIGN KEY (modele, modele_annee) REFERENCES Modele_moto (nom_modele, annee);

ALTER TABLE Fait_partie
    ADD FOREIGN KEY (id_pilote) REFERENCES Pilote (id),
    ADD FOREIGN KEY (nom_team) REFERENCES Team (nom);

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

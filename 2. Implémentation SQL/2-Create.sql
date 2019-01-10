-- Configuration basique.

-- Autorise l'écriture sur la sortie standard.
set serverout on
-- Configure l'éditeur de texte par défaut.
define _editor=vim
-- Configure le format de date par défaut.
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';

-- Création des tables.

CREATE TABLE Marque
(
    Nom         VARCHAR(32) NOT NULL,
    Annee       NUMBER(4),
    Nationalite CHAR(2) CHECK (Nationalite IN (NULL, 'FR', 'GB', 'US', 'IT', 'ES', 'JP', 'CH', 'DE')),
    PRIMARY KEY (Nom)
);

CREATE TABLE Team
(
    Nom    VARCHAR(32) NOT NULL,
    Marque VARCHAR(32) NOT NULL,
    PRIMARY KEY (nom)
);

CREATE TABLE Modele_moto
(
    Marque      VARCHAR(32) NOT NULL,
    Nom         VARCHAR(32) NOT NULL,
    Annee       DATE        NOT NULL,
    Cylindree   FLOAT,
    Couple      FLOAT,
    Puissance   FLOAT,
    Poids       FLOAT,
    Prix        NUMBER(6),
    Genre       VARCHAR(40),
    PRIMARY KEY (nom, annee)
);

CREATE TABLE Pilote
(
    Id          NUMBER(4)   NOT NULL,
    Nom         VARCHAR(32) NOT NULL,
    Prenom      VARCHAR(32) NOT NULL,
    Age         NUMBER(3),
    Nationalite CHAR(2),
    Sexe        CHAR(1),
    Numero      NUMBER(2),
    PRIMARY KEY (id)
);

CREATE TABLE Championnat
(
    Nom         VARCHAR(32) NOT NULL,
    Annee       DATE        NOT NULL,
    PRIMARY KEY (Nom, Annee)
);

CREATE TABLE Circuit
(
    Nom      VARCHAR(32) NOT NULL,
    Pays     CHAR(2)     NOT NULL,
    Longueur FLOAT,
    PRIMARY KEY (Nom)
);

CREATE TABLE Course_vitesse
(
    Championnat VARCHAR(32) NOT NULL,
    Annee       DATE        NOT NULL,
    Date_course DATE        NOT NULL,
    Circuit     VARCHAR(32) NOT NULL,
    Nb_tours    NUMBER(2),
    Duree       FLOAT,
    PRIMARY KEY (Championnat, Date_course)
);

CREATE TABLE Participe (
    Id_pilote       INT         NOT NULL,
    Championnat     VARCHAR(32) NOT NULL,
    Date_course     DATE        NOT NULL,
    Modele_moto     VARCHAR(32) NOT NULL,
    Annee_moto      DATE        NOT NULL,
    Classement      NUMBER(2),
    Points_gagnes   NUMBER(2),
    Vitesse_moy     FLOAT,
    Meilleur_tour   FLOAT,
    PRIMARY KEY (Id_pilote, Championnat, Date_course, Modele_moto, Annee_moto)
);

CREATE TABLE Contrat (
    Id_pilote   NUMBER(4)   NOT NULL,
    Moto_modele VARCHAR(32) NOT NULL,
    Moto_annee  DATE        NOT NULL,
    Team_nom    VARCHAR(32) NOT NULL,
    Annee_debut DATE        NOT NULL,
    Annee_fin   DATE,
    PRIMARY KEY (Id_pilote, Moto_modele, Moto_annee, Team_nom, Annee_debut)
);

-- Configure les clés étrangères.

ALTER TABLE Team
    ADD FOREIGN KEY (Marque) REFERENCES Marque (Nom);

ALTER TABLE Modele_moto
    ADD FOREIGN KEY (Marque) REFERENCES Marque (Nom);
    
ALTER TABLE Course_vitesse
    ADD FOREIGN KEY (Championnat, Annee) REFERENCES Championnat (Nom, Annee);
ALTER TABLE Course_vitesse
    ADD FOREIGN KEY (Circuit) REFERENCES Circuit (Nom);

ALTER TABLE Participe
    ADD FOREIGN KEY (Id_pilote) REFERENCES Pilote (Id);
ALTER TABLE Participe
    ADD FOREIGN KEY (Championnat, Date_course) REFERENCES Course_vitesse (Championnat, Date_course);
ALTER TABLE Participe
    ADD FOREIGN KEY (Modele_moto, Annee_moto) REFERENCES Modele_moto (Nom, Annee);

ALTER TABLE Contrat
    ADD FOREIGN KEY (Id_pilote) REFERENCES Pilote (Id);
ALTER TABLE Contrat
    ADD FOREIGN KEY (Moto_modele, Moto_annee) REFERENCES Modele_moto (Nom, Annee);
ALTER TABLE Contrat
    ADD FOREIGN KEY (Team_nom) REFERENCES Team (Nom);

-- Creéation des vues.

-- Liste des scores des pilotes au MotoGP de 2016.
CREATE VIEW MotoGP_2016_Score_pilotes AS
    SELECT Pi.Id, Pi.Numero, Pi.Nom, Pi.Prenom, SUM(Pa.Points_gagnes) AS Nombre_total_de_point
    FROM Participe Pa, Pilote Pi
    WHERE Pa.Id_pilote = Pi.Id
        AND Pa.Championnat LIKE 'MotoGP'
        AND TO_CHAR(Pa.Date_course, 'YYYY') LIKE '2016'
    GROUP BY Pi.Id, Pi.Numero, Pi.Nom, Pi.Prenom
    ORDER BY Nombre_total_de_point DESC;
    
-- Liste des scores des teams au MotoGP de 2016.
CREATE VIEW MotoGP_2016_Score_teams AS
    SELECT C.Team_nom, SUM(Nombre_total_de_point) AS Nombre_total_de_point
    FROM Contrat C, MotoGP_2016_Score_pilotes S
    WHERE S.Id = C.Id_pilote
        AND TO_CHAR(C.Annee_debut, 'YYYY') <= 2016
        AND (
            C.Annee_fin IS NULL
            OR
            TO_CHAR(C.Annee_fin, 'YYYY') >= 2016
        )
    GROUP BY C.Team_nom
    ORDER BY Nombre_total_de_point DESC;

-- List des scores des constructeurs au MotoGP de 2016.
CREATE VIEW MotoGP_2016_Score_construc AS
    SELECT T.Marque, SUM(Nombre_total_de_point) AS Nombre_total_de_point
    FROM Team T, MotoGP_2016_Score_teams S
    WHERE T.Nom = S.Team_nom
    GROUP BY T.Marque
    ORDER BY Nombre_total_de_point DESC;

-- Statistiques sur les pilotes du MotoGP.
CREATE VIEW MotoGP_Pilote_stat AS
    SELECT Pi.Numero, Pi.Nom, Pi.Prenom, Pi.Age, Pi.Nationalite, Pi.Sexe,
        SUM(Pa.Points_gagnes) AS Total_de_points_gagnes,
        MIN(Pa.Classement)    AS Meilleur_classement,
        MAX(Pa.Vitesse_moy)   AS Vitesse_moyenne,
        MIN(Pa.Meilleur_tour) AS Meilleur_tour
    FROM Pilote Pi, Participe Pa
    WHERE Pa.Id_pilote = Pi.Id
        AND Pa.Championnat LIKE 'MotoGP'
    GROUP BY Pi.Numero, Pi.Nom, Pi.Prenom, Pi.Age, Pi.Nationalite, Pi.Sexe;
-- TODO Fusionner la table ci-dessus et ci-dessous ?
-- Nombre de victoire des pilotes au MotoGP.
CREATE VIEW MotoGP_Pilote_win AS
    SELECT Pi.Numero, Pi.Nom, Pi.Prenom, COUNT(*) AS Nombre_de_victoire
    FROM Pilote Pi, Participe Pa
    WHERE Pa.Id_pilote = Pi.Id
        AND Pa.Championnat LIKE 'MotoGP'
        AND Pa.Classement = 1
    GROUP BY Pi.Numero, Pi.Nom, Pi.Prenom
    ORDER BY Nombre_de_victoire DESC;

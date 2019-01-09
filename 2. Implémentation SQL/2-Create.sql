set serverout on
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';

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
    Cylindree   NUMBER(4),
    Couple      NUMBER(3),
    Puissance   NUMBER(3),
    Poids       NUMBER(3),
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
    Longueur NUMBER(3),
    PRIMARY KEY (Nom)
);

CREATE TABLE Course_vitesse
(
    Championnat VARCHAR(32) NOT NULL,
    Annee       DATE        NOT NULL,
    Date_course DATE        NOT NULL,
    Circuit     VARCHAR(32) NOT NULL,
    Nb_tours    NUMBER(2),
    Duree       NUMBER(3),
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
    Vitesse_moy     NUMBER(4),
    Meilleur_tour   NUMBER(6),
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


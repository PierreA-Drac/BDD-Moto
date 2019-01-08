set serverout on

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
    Annee       NUMBER(4)   NOT NULL,
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
    Id          NUMBER(4)  NOT NULL,
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
    Annee       NUMBER(4) NOT NULL,
    PRIMARY KEY (Nom, Annee)
);

CREATE TABLE Circuit
(
    Nom      VARCHAR(32) NOT NULL,
    Pays     CHAR(2)     NOT NULL,
    Longueur NUMBER(3),
    PRIMARY KEY (Nom)
);

ALTER TABLE Team
    ADD FOREIGN KEY (Marque) REFERENCES Marque (Nom);

ALTER TABLE Modele_moto
    ADD FOREIGN KEY (Marque) REFERENCES Marque (Nom);

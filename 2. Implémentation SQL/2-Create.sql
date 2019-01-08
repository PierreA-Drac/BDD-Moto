set serverout on

CREATE TABLE Marque
(
    Nom VARCHAR(32) NOT NULL,
    Annee NUMBER(4),
    Nationalite CHAR(2) CHECK (Nationalite IN (NULL, 'FR', 'GB', 'US', 'IT', 'ES', 'JP', 'CH', 'DE')),
    PRIMARY KEY (Nom)
);

CREATE TABLE Team
(
    Nom     VARCHAR(32) NOT NULL,
    Marque  VARCHAR(32) NOT NULL,
    PRIMARY KEY (nom)
);

ALTER TABLE Team
    ADD FOREIGN KEY (Marque) REFERENCES Marque (Nom);

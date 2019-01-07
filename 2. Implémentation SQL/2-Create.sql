set serverout on

CREATE TABLE Marque
(
	Nom varchar(32) NOT NULL,
	Annee number(4),
	Nationalite char(2) CHECK (Nationalite IN (NULL, 'FR', 'GB', 'US', 'IT', 'ES', 'JP', 'CH', 'DE'))
);

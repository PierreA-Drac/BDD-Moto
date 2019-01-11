LOAD DATA
INFILE './Data/Pilote.csv'
TRUNCATE
INTO TABLE Pilote
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
(
    Id, Nom, Prenom, Age, Nationalite, Sexe, Numero
)

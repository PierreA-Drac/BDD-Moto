LOAD DATA
INFILE './Data/Marque.csv'
TRUNCATE
INTO TABLE Marque
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
(
    Nom,
    Annee DATE "YYYY",
    Nationalite
)

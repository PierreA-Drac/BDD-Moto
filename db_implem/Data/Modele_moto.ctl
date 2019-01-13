LOAD DATA
INFILE './Data/Modele_moto.csv'
TRUNCATE
INTO TABLE Modele_moto
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
(
    Marque,
    Nom,
    Annee DATE "YYYY",
    Cylindree,
    Couple,
    Puissance,
    Poids,
    Prix,
    Genre
)

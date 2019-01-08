LOAD DATA
INFILE './Data_CSV/Modele_moto.csv'
TRUNCATE
INTO TABLE Modele_moto
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
(
    Marque, Nom, Annee, Cylindree, Couple, Puissance, Poids, Prix, Genre
)

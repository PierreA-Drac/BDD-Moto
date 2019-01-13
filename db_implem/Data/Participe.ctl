LOAD DATA
INFILE './Data/Participe.csv'
TRUNCATE
INTO TABLE Participe
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
(
    Id_pilote,
    Championnat,
    Date_course DATE "YYYY-MM-DD",
    Modele_moto,
    Annee_moto DATE "YYYY",
    Classement,
    Points_gagnes,
    Vitesse_moy,
    Meilleur_tour
)

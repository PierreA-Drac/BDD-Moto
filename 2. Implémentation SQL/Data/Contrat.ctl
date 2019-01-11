LOAD DATA
INFILE './Data/Contrat.csv'
TRUNCATE
INTO TABLE Contrat
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
(
    Id_pilote,
    Moto_modele,
    Moto_annee  DATE "YYYY",
    Team_nom,
    Annee_debut DATE "YYYY-MM-DD",
    Annee_fin   DATE "YYYY-MM-DD"
)

LOAD DATA
INFILE './Data/Course_vitesse.csv'
TRUNCATE
INTO TABLE Course_vitesse
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
(
    Championnat,
    Annee DATE "YYYY",
    Date_course DATE "YYYY-MM-DD",
    Circuit,
    Nb_tours,
    Duree
)

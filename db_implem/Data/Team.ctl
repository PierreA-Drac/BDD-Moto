LOAD DATA
INFILE './Data/Team.csv'
TRUNCATE
INTO TABLE Team
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
(
    Nom, Marque
)
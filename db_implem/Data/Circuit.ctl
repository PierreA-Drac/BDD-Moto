LOAD DATA
INFILE './Data/Circuit.csv'
TRUNCATE
INTO TABLE Circuit
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
(
    Nom, Pays, Longueur
)

-- Liste toutes les contraites de clés étrangères -> clés primaires, trié
-- par nom de table.
SELECT C1.TABLE_NAME AS Table_esclave, C2.TABLE_NAME AS Table_maitre, C1.CONSTRAINT_NAME AS Contrainte_id
FROM USER_CONSTRAINTS C1, USER_CONSTRAINTS C2
WHERE C1.R_CONSTRAINT_NAME = C2.CONSTRAINT_NAME
    AND C1.CONSTRAINT_TYPE = 'R'
ORDER BY C1.TABLE_NAME ASC;

-- Censé lister les contraintes 'CHECK' de la table Participe. Cependant,
-- la table USER_CONSTRAINTS ne semble pas contenir les CHECK que l'on a
-- défini... Je ne comprends pas pourquoi.
SELECT C.TABLE_NAME, C.CONSTRAINT_NAME
FROM USER_CONSTRAINTS C
WHERE C.TABLE_NAME = 'Participe'
    AND C.CONSTRAINT_TYPE = 'C'
ORDER BY C.TABLE_NAME ASC;

exit

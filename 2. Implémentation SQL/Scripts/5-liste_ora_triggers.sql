-- Censé lister les triggers de la table Participe. Cependant, la table
-- ALL_TRIGGERS ne semble pas contenir les triggers que l'on a défini... Je
-- ne comprends pas pourquoi.
SELECT T.TABLE_NAME, T.TRIGGER_NAME, T.TRIGGER_TYPE, T.TRIGGERING_EVENT
FROM ALL_TRIGGERS T
WHERE T.TABLE_NAME = 'Participe'
ORDER BY T.TABLE_NAME ASC;

exit

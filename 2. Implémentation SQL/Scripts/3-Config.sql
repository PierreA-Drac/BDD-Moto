-- Configuration basique.

-- Autorise l'écriture sur la sortie standard.
set serverout on
-- Configure l'éditeur de texte par défaut.
define _editor=vim
-- Configure le format de date par défaut.
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
-- Configure la taille d'une ligne sur le terminal.
set linesize 230

-- Création des séquences.

-- 1. Création et configuration de la séquence des IDs des pilotes.
DECLARE
    max_pilote_id NUMBER := 0;
BEGIN
    SELECT MAX(Id) INTO max_pilote_id FROM Pilote;
    EXECUTE IMMEDIATE 'CREATE SEQUENCE PiloteID INCREMENT BY 1 START WITH ' || (max_pilote_id + 1);
END; 
/
CREATE OR REPLACE TRIGGER pilote_set_id BEFORE INSERT ON Pilote FOR EACH ROW
DECLARE
BEGIN
    :NEW.Id := PiloteID.NextVal;
END;
/

-- Création des plans d'exécution.

-- 1. Liste des scores des pilotes au MotoGP de 2016.
EXPLAIN PLAN FOR
    SELECT Pi.Id, Pi.Numero, Pi.Nom, Pi.Prenom, SUM(Pa.Points_gagnes) AS Nombre_total_de_point
    FROM Participe Pa, Pilote Pi
    WHERE Pa.Id_pilote = Pi.Id
        AND Pa.Championnat LIKE 'MotoGP'
        AND TO_CHAR(Pa.Date_course, 'YYYY') LIKE '2016'
    GROUP BY Pi.Id, Pi.Numero, Pi.Nom, Pi.Prenom
    ORDER BY Nombre_total_de_point DESC;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY('PLAN_TABLE', null, null));

-- 2. Liste des scores des teams au MotoGP de 2016.
EXPLAIN PLAN FOR
    SELECT C.Team_nom, SUM(Nombre_total_de_point) AS Nombre_total_de_point
    FROM Contrat C, MotoGP_2016_Score_pilotes S
    WHERE S.Id = C.Id_pilote
        AND TO_DATE(2016, 'YYYY') BETWEEN C.Annee_debut AND C.Annee_fin
    GROUP BY C.Team_nom
    ORDER BY Nombre_total_de_point DESC;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY('PLAN_TABLE', null, null));

-- 3. Statistiques diverses sur les pilotes du MotoGP.
EXPLAIN PLAN FOR
    SELECT Pi.Numero, Pi.Nom, Pi.Prenom, Pi.Age, Pi.Nationalite, Pi.Sexe,
        SUM(Pa.Points_gagnes) AS Total_de_points_gagnes,
        MIN(Pa.Classement)    AS Meilleur_classement,
        MAX(Pa.Vitesse_moy)   AS Vitesse_moyenne,
        MIN(Pa.Meilleur_tour) AS Meilleur_tour
    FROM Pilote Pi, Participe Pa
    WHERE Pa.Id_pilote = Pi.Id
        AND Pa.Championnat LIKE 'MotoGP'
    GROUP BY Pi.Numero, Pi.Nom, Pi.Prenom, Pi.Age, Pi.Nationalite, Pi.Sexe;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY('PLAN_TABLE', null, null));

exit

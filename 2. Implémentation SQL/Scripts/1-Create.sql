-- Supprime les précédentes créations si elles existent.

DROP SEQUENCE PiloteID;
DROP PROCEDURE date_inferior_to_current_time;
DROP PROCEDURE check_nationalite;
DROP VIEW MotoGP_Pilote_win;
DROP VIEW MotoGP_Pilote_stat;
DROP VIEW MotoGP_2016_Score_construc;
DROP VIEW MotoGP_2016_Score_teams;
DROP VIEW MotoGP_2016_Score_pilotes;
DROP TABLE Contrat;
DROP TABLE Participe;
DROP TABLE Course_vitesse;
DROP TABLE Circuit;
DROP TABLE Championnat;
DROP TABLE Pilote;
DROP TABLE Modele_moto;
DROP TABLE Team;
DROP TABLE Marque;

-- Configuration basique.

-- Autorise l'écriture sur la sortie standard.
set serverout on
-- Configure l'éditeur de texte par défaut.
define _editor=vim
-- Configure le format de date par défaut.
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';

-- Création des tables.

-- 1. Marques de moto.
CREATE TABLE Marque
(
    Nom         VARCHAR(32) NOT NULL,
    Annee       DATE,       -- CHECK with a trigger.
    Nationalite CHAR(2),    -- CHECK with a trigger.
    PRIMARY KEY (Nom)
);

-- 2. Teams concourrant aux championnats.
CREATE TABLE Team
(
    Nom    VARCHAR(32) NOT NULL,
    Marque VARCHAR(32) NOT NULL,
    PRIMARY KEY (nom)
);

-- 3. Modèles de moto.
CREATE TABLE Modele_moto
(
    Marque      VARCHAR(32) NOT NULL,
    Nom         VARCHAR(32) NOT NULL,
    Annee       DATE        NOT NULL, -- CHECK with a trigger.
    Cylindree   FLOAT       CHECK (Cylindree > 20 AND Cylindree < 2000),
    Couple      FLOAT       CHECK (Couple > 1     AND Couple < 20),
    Puissance   FLOAT       CHECK (Puissance > 1  AND Puissance < 500),
    Poids       FLOAT       CHECK (Poids > 30     AND Poids < 500),
    Prix        NUMBER(6)   CHECK (Prix > 100 AND Prix < 500000),
    Genre       VARCHAR(40) NOT NULL CHECK (Genre IN ('Sportive', 'Cafe Racer')),
    PRIMARY KEY (nom, annee)
);

-- 4. Pilotes appartenant aux teams.
CREATE TABLE Pilote
(
    Id          NUMBER(4)   NOT NULL, -- CHECK with a trigger.
    Nom         VARCHAR(32) NOT NULL,
    Prenom      VARCHAR(32) NOT NULL,
    Age         NUMBER(3)   CHECK (Age BETWEEN 10 and 100),
    Nationalite CHAR(2),    -- CHECK with a trigger.
    Sexe        CHAR(1)     CHECK (Sexe IN (NULL, 'H', 'F')),
    Numero      NUMBER(2)   CHECK (Numero BETWEEN 0 and 99),
    PRIMARY KEY (id)
);

-- 5. Championnats existants.
CREATE TABLE Championnat
(
    Nom         VARCHAR(32) NOT NULL,
    Annee       DATE        NOT NULL,   -- CHECK with a trigger.
    PRIMARY KEY (Nom, Annee)
);

-- 6. Circuits sur lesquels les courses se déroulent.
CREATE TABLE Circuit
(
    Nom      VARCHAR(32) NOT NULL,
    Pays     CHAR(2)     NOT NULL,  -- CHECK with a trigger.
    Longueur FLOAT       CHECK (Longueur BETWEEN 0.5 AND 20),
    PRIMARY KEY (Nom)
);

-- 7. Courses appartenants aux championnats.
CREATE TABLE Course_vitesse
(
    Championnat VARCHAR(32) NOT NULL,
    Annee       DATE        NOT NULL,
    Date_course DATE        NOT NULL, -- CHECK with trigger.
    Circuit     VARCHAR(32) NOT NULL,
    Nb_tours    NUMBER(2)   CHECK (Nb_tours BETWEEN 1 AND 30),
    Duree       FLOAT       CHECK (Duree BETWEEN 1 AND 100),
    PRIMARY KEY (Championnat, Date_course)
);

-- 8. Participation d'un pilote à une course.
CREATE TABLE Participe (
    Id_pilote       INT         NOT NULL,
    Championnat     VARCHAR(32) NOT NULL,
    Date_course     DATE        NOT NULL,
    Modele_moto     VARCHAR(32) NOT NULL,
    Annee_moto      DATE        NOT NULL,
    Classement      NUMBER(2)   CHECK (Classement BETWEEN 0 AND 30),
    Points_gagnes   NUMBER(2)   CHECK (Points_gagnes BETWEEN 0 AND 25),
    Vitesse_moy     FLOAT       CHECK (Vitesse_moy BETWEEN 0 AND 300),
    Meilleur_tour   FLOAT       CHECK (Meilleur_tour BETWEEN 0 AND 400),
    PRIMARY KEY (Id_pilote, Championnat, Date_course, Modele_moto, Annee_moto)
);

-- 9. Contrats liants un pilote, une équipe et un modèle de moto.
CREATE TABLE Contrat (
    Id_pilote   NUMBER(4)   NOT NULL,
    Moto_modele VARCHAR(32) NOT NULL,
    Moto_annee  DATE        NOT NULL,
    Team_nom    VARCHAR(32) NOT NULL,
    Annee_debut DATE        NOT NULL,
    Annee_fin   DATE        NOT NULL,
    PRIMARY KEY (Id_pilote, Moto_modele, Moto_annee, Team_nom, Annee_debut)
);

-- Configure les clés étrangères.

ALTER TABLE Team
    ADD FOREIGN KEY (Marque) REFERENCES Marque (Nom);

ALTER TABLE Modele_moto
    ADD FOREIGN KEY (Marque) REFERENCES Marque (Nom);
    
-- Désactivé car on utilise un trigger pour ces clés, conformément à la consigne.
--  ALTER TABLE Course_vitesse
    --  ADD FOREIGN KEY (Championnat, Annee) REFERENCES Championnat (Nom, Annee);
ALTER TABLE Course_vitesse
    ADD FOREIGN KEY (Circuit) REFERENCES Circuit (Nom);

ALTER TABLE Participe
    ADD FOREIGN KEY (Id_pilote) REFERENCES Pilote (Id);
ALTER TABLE Participe
    ADD FOREIGN KEY (Championnat, Date_course) REFERENCES Course_vitesse (Championnat, Date_course);
ALTER TABLE Participe
    ADD FOREIGN KEY (Modele_moto, Annee_moto) REFERENCES Modele_moto (Nom, Annee);

ALTER TABLE Contrat
    ADD FOREIGN KEY (Id_pilote) REFERENCES Pilote (Id);
ALTER TABLE Contrat
    ADD FOREIGN KEY (Moto_modele, Moto_annee) REFERENCES Modele_moto (Nom, Annee);
ALTER TABLE Contrat
    ADD FOREIGN KEY (Team_nom) REFERENCES Team (Nom);

-- Creéation des vues.

-- 1. Liste des scores des pilotes au MotoGP de 2016.
CREATE VIEW MotoGP_2016_Score_pilotes AS
    SELECT Pi.Id, Pi.Numero, Pi.Nom, Pi.Prenom, SUM(Pa.Points_gagnes) AS Nombre_total_de_point
    FROM Participe Pa, Pilote Pi
    WHERE Pa.Id_pilote = Pi.Id
        AND Pa.Championnat LIKE 'MotoGP'
        AND TO_CHAR(Pa.Date_course, 'YYYY') LIKE '2016'
    GROUP BY Pi.Id, Pi.Numero, Pi.Nom, Pi.Prenom
    ORDER BY Nombre_total_de_point DESC
    WITH READ ONLY;
GRANT SELECT ON MotoGP_2016_Score_pilotes to PUBLIC;
    
-- 2. Liste des scores des teams au MotoGP de 2016.
CREATE VIEW MotoGP_2016_Score_teams AS
    SELECT C.Team_nom, SUM(Nombre_total_de_point) AS Nombre_total_de_point
    FROM Contrat C, MotoGP_2016_Score_pilotes S
    WHERE S.Id = C.Id_pilote
        AND TO_DATE(2016, 'YYYY') BETWEEN C.Annee_debut AND C.Annee_fin
    GROUP BY C.Team_nom
    ORDER BY Nombre_total_de_point DESC
    WITH READ ONLY;
GRANT SELECT ON MotoGP_2016_Score_teams to PUBLIC;

-- 3. Liste des scores des constructeurs au MotoGP de 2016.
CREATE VIEW MotoGP_2016_Score_construc AS
    SELECT T.Marque, SUM(Nombre_total_de_point) AS Nombre_total_de_point
    FROM Team T, MotoGP_2016_Score_teams S
    WHERE T.Nom = S.Team_nom
    GROUP BY T.Marque
    ORDER BY Nombre_total_de_point DESC
    WITH READ ONLY;
GRANT SELECT ON MotoGP_2016_Score_construc to PUBLIC;

-- 4. Statistiques diverses sur les pilotes du MotoGP.
CREATE VIEW MotoGP_Pilote_stat AS
    SELECT Pi.Numero, Pi.Nom, Pi.Prenom, Pi.Age, Pi.Nationalite, Pi.Sexe,
        SUM(Pa.Points_gagnes) AS Total_de_points_gagnes,
        MIN(Pa.Classement)    AS Meilleur_classement,
        MAX(Pa.Vitesse_moy)   AS Vitesse_moyenne,
        MIN(Pa.Meilleur_tour) AS Meilleur_tour
    FROM Pilote Pi, Participe Pa
    WHERE Pa.Id_pilote = Pi.Id
        AND Pa.Championnat LIKE 'MotoGP'
    GROUP BY Pi.Numero, Pi.Nom, Pi.Prenom, Pi.Age, Pi.Nationalite, Pi.Sexe
    WITH READ ONLY;
GRANT SELECT ON MotoGP_Pilote_stat to PUBLIC;

-- 5. Nombre de victoire des pilotes au MotoGP.
CREATE VIEW MotoGP_Pilote_win AS
    SELECT Pi.Numero, Pi.Nom, Pi.Prenom, COUNT(*) AS Nombre_de_victoire
    FROM Pilote Pi, Participe Pa
    WHERE Pa.Id_pilote = Pi.Id
        AND Pa.Championnat LIKE 'MotoGP'
        AND Pa.Classement = 1
    GROUP BY Pi.Numero, Pi.Nom, Pi.Prenom
    ORDER BY Nombre_de_victoire DESC
    WITH READ ONLY;
GRANT SELECT ON MotoGP_Pilote_win to PUBLIC;

-- Création des procédures.

-- 1. Vérifie qu'une date est inférieure à la date du jour. Nécéssite un
-- trigger/une procédure pour utiliser SYSDATE.
CREATE OR REPLACE PROCEDURE date_inferior_to_current_time (new_date IN DATE) IS
BEGIN
    IF new_date > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20001, 'Insertion cannot be done because the date is greater than today !');
    END IF;
END;
/

-- 2. Vérifie qu'une nationalité est correct. On pourrait utiliser un CHECK, mais
-- il faudrait coper-coller les valeurs de nationalités à la main, alors que
-- l'on peux les regrouper dans une procédure.
CREATE OR REPLACE PROCEDURE check_nationalite (nat IN CHAR) IS
BEGIN
    IF (nat NOT IN ('FR', 'GB', 'US', 'IT', 'ES', 'JP', 'CH', 'DE', 'AU', 'QT', 'PB')) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Insertion cannot be done because the nationality is incorrect !');
    END IF;
END;
/

-- Création des triggers.

-- 1. Vérifie l'année de création et la nationalité d'une marque.
CREATE OR REPLACE TRIGGER marque_check BEFORE INSERT OR UPDATE ON Marque FOR EACH ROW
BEGIN
    date_inferior_to_current_time(:new.Annee);
    check_nationalite(:new.Nationalite);
END;
/

-- 2. Vérifie l'année d'un modèle de moto.
CREATE OR REPLACE TRIGGER modele_moto_check BEFORE INSERT OR UPDATE ON Modele_moto FOR EACH ROW
BEGIN
    date_inferior_to_current_time(:new.Annee);
END;
/

-- 3. Vérifie la nationalité d'un pilote.
CREATE OR REPLACE TRIGGER pilote_check BEFORE INSERT OR UPDATE ON Pilote FOR EACH ROW
DECLARE
    previous_pilote_id NUMBER := 0;
BEGIN
    check_nationalite(:new.Nationalite);
END;
/

-- 4. Vérifie l'année d'un championnat de moto.
CREATE OR REPLACE TRIGGER championnat_check BEFORE INSERT OR UPDATE ON Championnat FOR EACH ROW
BEGIN
    date_inferior_to_current_time(:new.Annee);
END;
/

-- 5. Vérifie le pays d'un circuit de moto.
CREATE OR REPLACE TRIGGER circuit_check BEFORE INSERT OR UPDATE ON Circuit FOR EACH ROW
BEGIN
    check_nationalite(:new.Pays);
END;
/

-- 6. Vérifie la date d'une course de vitesse.
CREATE OR REPLACE TRIGGER course_vitesse_check BEFORE INSERT OR UPDATE ON Course_vitesse FOR EACH ROW
BEGIN
    date_inferior_to_current_time(:new.Date_course);
END;
/

-- 7. Vérifie la date d'un contrat et qu'un pilote n'est pas déjà sous contrat valide
-- lors de la création d'un nouveau contrat.
CREATE OR REPLACE TRIGGER contrat_check BEFORE INSERT OR UPDATE ON Contrat FOR EACH ROW
DECLARE
    valide BOOLEAN := FALSE;
    CURSOR Contrat IS
        SELECT Annee_debut, Annee_fin
        FROM Contrat C
        WHERE Id_pilote = :NEW.Id_pilote;
BEGIN
    date_inferior_to_current_time(:new.Annee_debut);
    --  Désactivé car cela cause une erreur de table mutante. Je n'ai pas trouvé
    --  de résolution au problème, après avoir essayé de changer la structure de
    --  données ou utiliser une table temporaire...
    --  FOR tuple IN Contrat LOOP
        --  IF ((:NEW.Annee_debut BETWEEN tuple.Annee_debut AND tuple.Annee_fin)
                --  OR (:NEW.Annee_fin BETWEEN tuple.Annee_debut AND tuple.Annee_fin)) THEN
            --  valide := TRUE;
        --  END IF;
    --  END LOOP;
    --  IF valide = TRUE THEN
        --  RAISE_APPLICATION_ERROR(-20001, 'Insertion cannot be done because the pilot is/was already under a contract during this new contract !');
    --  END IF;
END;
/

-- 8. Vérifie qu'un pilote est bien sous un contrat valide lors de sa participation
-- à une course.
CREATE OR REPLACE TRIGGER participe_check BEFORE INSERT OR UPDATE ON Participe FOR EACH ROW
DECLARE
    valide BOOLEAN := FALSE;
    CURSOR Contrat IS
        SELECT Annee_debut, Annee_fin
        FROM Contrat C
        WHERE Id_pilote = :NEW.Id_pilote;
BEGIN
    FOR tuple IN Contrat LOOP
        IF (:NEW.Date_course BETWEEN tuple.Annee_debut AND tuple.Annee_fin) THEN
            valide := TRUE;
        END IF;
    END LOOP;
    IF valide = FALSE THEN
        RAISE_APPLICATION_ERROR(-20001, 'Insertion cannot be done because the pilot is/was not under a contract during the race !');
    END IF;
END;
/

-- 9. Vérifie les clés étrangères de la table Course_vitesse.
CREATE OR REPLACE TRIGGER verif_course_vitesse_cles BEFORE INSERT OR UPDATE ON Course_vitesse FOR EACH ROW
DECLARE
    nom Championnat.Nom%TYPE;
BEGIN
    SELECT Nom INTO nom
    FROM Championnat C
    WHERE C.Nom = :NEW.Championnat
        AND C.Annee = :NEW.Annee;

    IF SQL%NOTFOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Insertion cannot be done because the championship does not exist');
    END IF;
END;
/

exit

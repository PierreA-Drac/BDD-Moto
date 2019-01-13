
--1. Liste des championnats différents par année :
SELECT Cv.championnat, SUBSTRING_INDEX(Cv.date_course, "/", -1) AS Annee
FROM Course_vitesse Cv
GROUP BY Cv.championnat, Annee

--2. Score des pilotes au MotoGP de 2016 :

SELECT Pi.prenom, Pi.nom, Pi.numero, SUM(Pa.points_gagnes) AS Nombre_total_de_point
FROM Pilote Pi, Participe Pa
WHERE Pa.id_pilote = Pi.id
    AND Pa.championnat LIKE "MotoGP"
    AND YEAR(Pa.date_course) LIKE "%2016"
GROUP BY Pi.id
ORDER BY Nombre_total_de_point DESC;

--3. Score des teams au MotoGP de 2016 :

SELECT C.Team_nom, SUM(Nombre_total_de_point_pilote) AS Nombre_total_de_point
FROM Contrat AS C, (
    SELECT Pi.id, SUM(Pa.points_gagnes) AS Nombre_total_de_point_pilote
    FROM Pilote Pi, Participe Pa
    WHERE Pa.id_pilote = Pi.id
        AND Pa.championnat LIKE "MotoGP"
        AND Pa.date_course LIKE "%2016"
    GROUP BY Pi.id
) AS score_pilote
WHERE score_pilote.id = C.id_pilote
    AND YEAR(C.annee_debut) <= 2016
    AND (
        YEAR(C.annee_fin) >= 2016
        OR C.annee_fin IS NULL
    )
GROUP BY C.nom_team
ORDER BY Nombre_total_de_point DESC;

--4. Score des marques au MotoGP de 2016 :

SELECT T.marque, SUM(Nombre_total_de_point_team) AS Nombre_total_de_point
FROM Team T, (
    SELECT C.Team_nom, SUM(Nombre_total_de_point_pilote) AS Nombre_total_de_point_team
    FROM Contrat C, (
        SELECT Pi.id, SUM(Pa.points_gagnes) AS Nombre_total_de_point_pilote
        FROM Pilote Pi, Participe Pa
        WHERE Pa.id_pilote = Pi.id
            AND Pa.championnat LIKE "MotoGP"
            AND Pa.date_course LIKE "%2016"
        GROUP BY Pi.id
    ) AS score_pilote
    WHERE score_pilote.id = C.id_pilote
        AND YEAR(C.annee_debut) <= 2016
        AND (
            YEAR(C.annee_fin) >= 2016
            OR C.annee_fin IS NULL
        )
    GROUP BY C.nom_team
) AS score_team
WHERE T.nom = score_team.nom_team
GROUP BY T.marque
ORDER BY Nombre_total_de_point DESC

--5. Moyenne des points gagnés par course par des pilotes Espagnols au MotoGP :

SELECT Pi.prenom, Pi.nom, Pi.numero, AVG(Pa.points_gagnes) AS Moyenne
FROM Pilote Pi, Participe Pa
WHERE Pa.id_pilote = Pi.id
    AND Pa.championnat LIKE "MotoGP"
    AND Pi.pays LIKE "Espagne"
GROUP BY Pi.id

--6. Nombre de pilotes de motos de moins de 30 ans utilisant une moto sportive dans leur contrat actuel :

SELECT COUNT(*)
FROM Pilote P, Contrat C, Modele_moto M
WHERE P.Id = C.Id_pilote
    AND C.Moto_modele = M.Nom
    AND C.Moto_annee = M.Annee
    AND M.Genre = 'Sportive'
    AND P.Age <= 30
    AND YEAR(C.annee_fin) >= 2019;

--7. Affiche les pilotes n'ayant jamais participé à une course ainsi que ceux
-- ayant plus de 2 victoires :

SELECT Pi.prenom, Pi.nom, 0 AS Nombre_victoire
FROM Pilote Pi
WHERE Pi.id NOT IN (
    SELECT Pa.id_pilote
    FROM Participe Pa
)
UNION
SELECT Pi.prenom, Pi.nom, COUNT(*) AS Nombre_victoire
FROM Pilote Pi, Participe Pa
WHERE Pi.id = Pa.id_pilote
    AND Pa.classement = 1
GROUP BY Pi.id
HAVING Nombre_victoire >= 2


--8. Liste des modèles de motos ayant été utilisées plus de dix fois dans une course

SELECT Modele_moto, count(Modele_moto) as participations FROM Participe
WHERE participations >= 10
GROUP BY Modele_moto;


-- 9. Tous les contrats terminant en 2019 mais ayant une durée inférieure à 3 ans 
-- (donc commençant après 2016) sont allongés jusqu'à 2021
UPDATE Contrat 
SET annee_fin = '2021-12-31'
WHERE YEAR(annee_fin) = 2019
    AND YEAR(annee_fin) - YEAR(année_début) < 3

-- 10. Augmentation de 10% des prix de tous les modèles de moto appartenant à des marques britanniquess

UPDATE Modele_moto
SET Prix = Prix * 1.1
WHERE Marque = (SELECT Nom FROM Marque as M 
                WHERE Marque = M.nom
                AND Nationalite = 'GB');


-- 11. Donne le modèle de moto le plus puissant pour chaque marque, à condition que ce modèle ait déjà
-- été utilisé dans au moins un course, on donne ainsi également sa meilleure vitesse moyenne enregistrée en course.

SELECT MMA.Marque, MMA.Nom, MMA.Annee, MMA.Puissance, P.Vitesse_moy
FROM Modele_moto as MMA, Participe as P
WHERE Puissance = (SELECT MAX(Puissance) 
                    FROM Modele_moto AS MMB WHERE MMB.Marque = MMA.Marque)
    AND P.Vitesse_moy = (SELECT MAX(Vitesse_moy)
                        FROM Participe AS PB WHERE PB.Modele_moto = P.Modele_moto
                                                AND PB.Anne_moto = P.Anne_moto)
    AND MMA.Nom = P.Modele_moto
    AND MMA.Annee = P.Anne_moto;


-- 12. Supprime toutes les participations ayant été effectuées avec des motos de type
-- "cafe racer" de plus de 200 kg sur des circuits Espagnols

DELETE FROM Participe
WHERE Modele_moto = (SELECT Nom FROM Modele_moto 
                    WHERE Genre = 'Cafe Racer'
                        AND Poids >= 200)
AND Date_course = (SELECT Date_course FROM Course_vitesse
                    WHERE Circuit = (SELECT Nom FROM circuit
                                        WHERE Pays = 'ES'));




-- 13. Supprime toutes les participations effectuées par des pilotes brittaniques

DELETE FROM Participe
WHERE Id_pilote = (SELECT Id FROM Pilote 
                    WHERE Nationalite = 'GB');

-- 14. Augmentation de 1000€ des prix des modèles de motos ayant remporté la première place à au moins une course

UPDATE Modele_moto
SET Prix = Prix + 1000
WHERE Nom = SELECT(Modele_moto FROM Participe
                    WHERE Classement = 1
                        AND Participe.Modele_moto = Modele_moto.Nom)
    AND Annee = SELECT(Anne_moto FROM Participe
                    WHERE Classement = 1
                        AND Participe.Anne_moto = Modele_moto.Annee);

-- 15. Augmentation de 1 point de tous les scores obtenus lors de courses effectuées
-- dans un circuit Australien

UPDATE Participe
SET points_gagnes = points_gagnes + 1
WHERE date_course = (SELECT date_course as DCB FROM Course_vitesse as CV
                        WHERE CV.Circuit = ( SELECT Nom from Circuit as C
                                                WHERE C.Pays = 'AU') 
                        AND DCB = Participe.date_course)
AND Championnat = (SELECT Championnat as CHB FROM Course_vitesse as CV
                        WHERE CV.Circuit = ( SELECT Nom from Circuit as C
                                                WHERE C.Pays = 'AU') 
                        AND CHB = Participe.Championnat);


-- 16. Donne le nombre de contrats effectués pour chaque modèle de moto

SELECT Moto_modele, Moto_annee, count(Moto_modele,Moto_annee) AS nb_of_contracts
FROM Contrat
GROUP BY Moto_modele,Moto_annee;

-- 17. Donne le classement du nombre de victoires par pilote pour chaque circuit

SELECT C.Nom , P.Nom, P.Prenom, COUNT(PA.Id_pilote) as nb_win
FROM Circuit as C, Pilote as P, Participe as PA
WHERE PA.Id_pilote = P.Id
    AND PA.Date_course = (SELECT CV.Date_course FROM Course_vitesse as CV
                            WHERE CV.Circuit = C.Nom)
    AND PA.Classement = 1;
ORDER BY nb_win DESC


--18. Mise à jour de l'âge de tous les pilotes actif (encore sous contrat) pour la nouvelle année

UPDATE Pilote
SET Age = Age + 1
WHERE Id = (SELECT Id_pilote FROM contrat
            WHERE YEAR(annee_fin) >= 2019);

-- 19. Total de points gagnés par chaque pilotes au fil des championnats

SELECT P.Nom, P.Prenom, SUM(PA.points_gagnes) as total_point
FROM Piote as P,Participe as PA
GROUP BY P.Nom,P.Prenom, total_point;

-- 20. Donne la liste des pilotes actifs avec la date de leur dernière participation à une course

SELECT P.Nom,P.prenom,PA.Date_course
FROM Pilote as P, Participe as PA
WHERE P.Id = PA.id_pilote
    AND P.Id = (SELECT C.Id_pilote FROM Contrat as C
                WHERE YEAR(C.annee_fin)>=2019)
    AND PA.Date_course = MAX(Date_course);
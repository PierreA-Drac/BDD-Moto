
--1. Liste des championnats différents par année :
SELECT Cv.championnat, EXTRACT(YEAR FROM Cv.date_course) AS Annee
FROM Course_vitesse Cv
GROUP BY Cv.championnat, EXTRACT(YEAR FROM Cv.date_course);

--2. Score des pilotes au MotoGP de 2016 :

SELECT Pi.prenom, Pi.nom, Pi.numero, SUM(Pa.points_gagnes) AS Nombre_total_de_point
FROM Pilote Pi, Participe Pa
WHERE Pa.id_pilote = Pi.id
    AND Pa.championnat LIKE 'MotoGP'
    AND EXTRACT(YEAR FROM Pa.date_course) LIKE 2016
GROUP BY Pi.prenom, Pi.nom, Pi.numero
ORDER BY SUM(Pa.points_gagnes) DESC;

--4. Score des teams au MotoGP de 2016 :

SELECT C.Team_nom, SUM(Nombre_total_de_point_pilote) AS Nombre_total_de_point
FROM Contrat C, (
    SELECT Pi.id, SUM(Pa.points_gagnes) AS Nombre_total_de_point_pilote
    FROM Pilote Pi, Participe Pa
    WHERE Pa.id_pilote = Pi.id
        AND Pa.championnat LIKE 'MotoGP'
        AND EXTRACT(YEAR FROM Pa.date_course) LIKE 2016
    GROUP BY Pi.id
) score_pilote
WHERE score_pilote.id = C.id_pilote
    AND EXTRACT(YEAR FROM C.annee_debut) <= 2016
    AND (
        EXTRACT(YEAR FROM C.annee_fin) >= 2016
        OR C.annee_fin IS NULL
    )
GROUP BY C.team_nom
ORDER BY SUM(Nombre_total_de_point_pilote) DESC;

--5. Score des marques au MotoGP de 2016 :

SELECT T.marque, SUM(Nombre_total_de_point_team) AS Nombre_total_de_point
FROM Team T, (
    SELECT C.Team_nom, SUM(Nombre_total_de_point_pilote) AS Nombre_total_de_point_team
    FROM Contrat C, (
        SELECT Pi.id, SUM(Pa.points_gagnes) AS Nombre_total_de_point_pilote
        FROM Pilote Pi, Participe Pa
        WHERE Pa.id_pilote = Pi.id
            AND Pa.championnat LIKE 'MotoGP'
            AND EXTRACT(YEAR FROM Pa.date_course ) LIKE 2016
        GROUP BY Pi.id
    ) score_pilote
    WHERE score_pilote.id = C.id_pilote
        AND EXTRACT(YEAR FROM C.annee_debut) <= 2016
        AND (
            EXTRACT(YEAR FROM C.annee_fin) >= 2016
            OR C.annee_fin IS NULL
        )
    GROUP BY C.team_nom
) score_team
WHERE T.nom = score_team.team_nom
GROUP BY T.marque
ORDER BY Nombre_total_de_point DESC;

--6. Moyenne des points gagnés par course par des pilotes Espagnols au MotoGP :

SELECT Pi.prenom, Pi.nom, Pi.numero, AVG(Pa.points_gagnes) AS Moyenne
FROM Pilote Pi, Participe Pa
WHERE Pa.id_pilote = Pi.id
    AND Pa.championnat LIKE 'MotoGP'
    AND Pi.nationalite LIKE 'ES'
GROUP BY Pi.prenom, Pi.nom, Pi.numero;

--7. Nombre de pilotes de motos de moins de 30 ans utilisant une moto sportive dans leur contrat actuel :

SELECT COUNT(*) as nb_pilotes_moins_30_ans_moto_sportive
FROM Pilote P, Contrat C, Modele_moto M
WHERE P.Id = C.Id_pilote
    AND C.Moto_modele = M.Nom
    AND C.Moto_annee = M.Annee
    AND M.Genre = 'Sportive'
    AND P.Age <= 30
    AND EXTRACT(YEAR FROM C.annee_fin) >= 2019;

--8. Affiche les pilotes n'ayant jamais participé à une course ainsi que ceux
-- n'ayant jamais eu de victoire

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
GROUP BY Pi.prenom, Pi.nom
HAVING COUNT(*) = 0;


--9. Liste des modèles de motos ayant été utilisées plus de six fois dans des courses

SELECT Modele_moto, EXTRACT(YEAR FROM Annee_moto) as Annee, count(*) as Participations
FROM Participe
GROUP BY Modele_moto, Annee_moto
HAVING count(*) >= 6
ORDER BY count(*) DESC;


-- 10. Tous les contrats terminant en 2019 mais ayant une durée inférieure à 3 ans 
-- (donc commençant après 2016) sont allongés jusqu'à 2021
UPDATE Contrat 
SET annee_fin = TO_DATE('2021-12-31', 'YYYY-MM-DD')
WHERE EXTRACT(YEAR FROM annee_fin) = 2019
    AND EXTRACT(YEAR FROM annee_fin) - EXTRACT(YEAR FROM annee_debut) < 3;

-- 11. Augmentation de 10% des prix de tous les modèles de moto appartenant à des marques britanniques

UPDATE Modele_moto
SET Prix = Prix * 1.1
WHERE Marque = (SELECT Nom FROM Marque M 
                WHERE Marque = M.nom
                AND Nationalite = 'GB');


-- 12. Donne le modèle de moto le plus puissant pour chaque marque, à condition que ce modèle ait déjà
-- été utilisé dans au moins un course, on donne ainsi également sa meilleure vitesse moyenne enregistrée en course.

SELECT MMA.Marque, MMA.Nom, MMA.Annee, MMA.Puissance, P.Vitesse_moy
FROM Modele_moto MMA, Participe P
WHERE Puissance = (SELECT MAX(Puissance) 
                    FROM Modele_moto MMB 
                    WHERE MMB.Marque = MMA.Marque)
    AND P.Vitesse_moy = (SELECT MAX(Vitesse_moy)
                        FROM Participe PB 
                        WHERE PB.Modele_moto = P.Modele_moto
                        AND PB.Annee_moto = P.Annee_moto)
    AND MMA.Nom = P.Modele_moto
    AND MMA.Annee = P.Annee_moto;


-- 14. Supprime toutes les participations ayant été effectuées avec des motos de type
-- "cafe racer" de plus de 200 kg sur des circuits Espagnols

DELETE FROM Participe P
WHERE P.Modele_moto = (SELECT MM.Nom FROM Modele_moto MM
                    WHERE Genre = 'Cafe Racer'
                        AND Poids >= 200
                        AND MM.nom = P.Modele_moto
                        AND MM.annee = P.annee_moto)
AND Date_course = (SELECT Date_course FROM Course_vitesse CVT
            WHERE CVT.Date_course = P.Date_course
                        AND Circuit = (SELECT Nom FROM circuit
                                        WHERE Pays = 'ES'));



-- 13. Supprime toutes les participations effectuées par des pilotes brittaniques lors du championnat Superbike 2015

DELETE FROM Participe
WHERE Id_pilote = (SELECT Id FROM Pilote P
                    WHERE Nationalite = 'GB'
                    AND Id_pilote = P.Id)
AND Championnat = 'Superbike'
AND EXTRACT(YEAR FROM Date_course) = 2015;

-- 15. Augmentation de 1000€ des prix des modèles de motos ayant remporté la première place à au moins une course

UPDATE Modele_moto
SET Prix = Prix + 1000
WHERE (Nom,Annee) = (SELECT Modele_moto,Annee_moto FROM Participe
                    WHERE Classement = 1
                        AND Participe.Modele_moto = Modele_moto.Nom
                        AND Participe.Annee_moto = Modele_moto.Annee
                        GROUP BY Modele_moto,Annee_moto);

-- 16. Augmentation de 1 point de tous les scores obtenus lors de courses effectuées
-- dans un circuit Australien

UPDATE Participe P
SET points_gagnes = points_gagnes + 1
WHERE date_course = (SELECT date_course as DCB FROM Course_vitesse CV
                    WHERE CV.Date_course = P.date_course
                        AND CV.Circuit = ( SELECT Nom from Circuit C
                        WHERE C.Nom = CV.Circuit
                                                AND C.Pays = 'AU'));

-- 17. Donne le nombre de contrats effectués pour chaque modèle de moto

SELECT Moto_modele, EXTRACT(YEAR FROM Moto_annee) as Annee, count(*) AS Nb_of_contracts
FROM Contrat
GROUP BY Moto_modele,Moto_annee
ORDER BY count(*) DESC;

-- 18. Donne le classement du nombre de victoires par pilote pour chaque circuit

SELECT C.Nom , P.Nom, P.Prenom, COUNT(*) as nb_win
FROM Circuit C, Pilote P, Participe PA
WHERE PA.Id_pilote = P.Id
    AND PA.Date_course = (SELECT CV.Date_course FROM Course_vitesse CV
                            WHERE CV.Circuit = C.Nom
                            AND PA.Date_course = CV.date_course)
                            AND PA.Classement = 1
GROUP BY C.Nom , P.Nom, P.Prenom
ORDER BY count(*);


--19. Mise à jour de l'âge de tous les pilotes actif (encore sous contrat) pour la nouvelle année

UPDATE Pilote P
SET Age = Age + 1
WHERE Id = (SELECT Id_pilote FROM contrat C
        WHERE P.Id = C.Id_pilote
             AND EXTRACT(YEAR FROM annee_fin) >= 2019);

-- 3. Total de points gagnés par chaque pilotes au fil des championnats

SELECT P.Nom, P.Prenom, SUM(PA.points_gagnes) as total_point
FROM Pilote P,Participe PA
WHERE P.Id = PA.Id_pilote
GROUP BY P.Nom,P.Prenom
ORDER BY SUM(PA.points_gagnes) DESC;

-- 20. Donne la liste des pilotes actifs avec la date de leur dernière participation à une course
-- Ainsi que la date d'expiration de leur contrat actuel

SELECT P.Nom,P.prenom,PA.Date_course, EXTRACT(YEAR FROM C.annee_fin) as fin_contrat
FROM Pilote P, Participe PA, Contrat C
WHERE P.Id = PA.id_pilote
    AND P.Id = C.id_pilote
    AND EXTRACT(YEAR FROM C.annee_fin) >= 2019
    AND PA.Date_course = (SELECT MAX(Date_course) FROM Participe PAB
                WHERE PA.Date_course = PAB.Date_course
                AND PA.id_pilote = PAB.id_pilote)
GROUP BY P.Nom,P.prenom,PA.Date_course,EXTRACT(YEAR FROM C.annee_fin);
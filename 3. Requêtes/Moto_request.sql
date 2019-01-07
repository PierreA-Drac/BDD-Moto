-- La majorité des requêtes ci-dessous seront accessibles à partir du site par
-- des formulaires, ce qui permettra à l'utilisateur d'avoir des statistiques
-- sur les données qu'il souhaite. Pour la démonstration, les paramètres ici
-- seront fixés dans les requêtes.

-- Liste des championnat différents par années :
SELECT Cv.championnat, SUBSTRING_INDEX(Cv.date_course, "/", -1) AS Annee
FROM Course_vitesse Cv
GROUP BY Cv.championnat, Annee

-- Score des pilotes au MotoGP de 2016 :

SELECT Pi.prenom, Pi.nom, Pi.numero, SUM(Pa.points_gagnes) AS Nombre_total_de_point
FROM Pilote Pi, Participe Pa
WHERE Pa.id_pilote = Pi.id
    AND Pa.championnat LIKE "MotoGP"
    AND Pa.date_course LIKE "%2016"
GROUP BY Pi.id
ORDER BY Nombre_total_de_point DESC;

-- Score des teams au MotoGP de 2016 :

SELECT F.nom_team, SUM(Nombre_total_de_point_pilote) AS Nombre_total_de_point
FROM Fait_partie F, (
    SELECT Pi.id, SUM(Pa.points_gagnes) AS Nombre_total_de_point_pilote
    FROM Pilote Pi, Participe Pa
    WHERE Pa.id_pilote = Pi.id
        AND Pa.championnat LIKE "MotoGP"
        AND Pa.date_course LIKE "%2016"
    GROUP BY Pi.id
) AS score_pilote
WHERE score_pilote.id = F.id_pilote
    AND F.annee_debut <= 2016
    AND (
        F.annee_fin >= 2016
        OR F.annee_fin IS NULL
    )
GROUP BY F.nom_team
ORDER BY Nombre_total_de_point DESC;

-- Score des marques au MotoGP de 2016 :

SELECT T.marque, SUM(Nombre_total_de_point_team) AS Nombre_total_de_point
FROM Team T, (
    SELECT F.nom_team, SUM(Nombre_total_de_point_pilote) AS Nombre_total_de_point_team
    FROM Fait_partie F, (
        SELECT Pi.id, SUM(Pa.points_gagnes) AS Nombre_total_de_point_pilote
        FROM Pilote Pi, Participe Pa
        WHERE Pa.id_pilote = Pi.id
            AND Pa.championnat LIKE "MotoGP"
            AND Pa.date_course LIKE "%2016"
        GROUP BY Pi.id
    ) AS score_pilote
    WHERE score_pilote.id = F.id_pilote
        AND F.annee_debut <= 2016
        AND (
            F.annee_fin >= 2016
            OR F.annee_fin IS NULL
        )
    GROUP BY F.nom_team
) AS score_team
WHERE T.nom = score_team.nom_team
GROUP BY T.marque
ORDER BY Nombre_total_de_point DESC

-- Moyenne des points gagnés par course par des pilotes Espagnols au MotoGP :

SELECT Pi.prenom, Pi.nom, Pi.numero, AVG(Pa.points_gagnes) AS Moyenne
FROM Pilote Pi, Participe Pa
WHERE Pa.id_pilote = Pi.id
    AND Pa.championnat LIKE "MotoGP"
    AND Pi.pays LIKE "Espagne"
GROUP BY Pi.id

-- Nombre d'utilisateur de moto sportives de moins de 30 ans :

SELECT COUNT(*)
FROM Utilisateurs U, Possede P, Modele_moto M
WHERE U.identifiant = P.identifiant
    AND P.modele = M.nom_modele
    AND M.type_moto LIKE "Sportive"
    AND U.age < 30
    And U.sexe LIKE "Homme"

-- Affiche les pilotes n'ayant jamais participé à une course ainsi que ceux
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

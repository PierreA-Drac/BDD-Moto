CREATE VIEW MotoGP_2016_Score_pilotes AS
    SELECT Pi.id, Pi.prenom, Pi.nom, Pi.numero, SUM(Pa.points_gagnes) AS nombre_total_de_point
    FROM Pilote Pi, Participe Pa
    WHERE Pa.id_pilote = Pi.id
        AND Pa.championnat LIKE "MotoGP"
        AND Pa.date_course LIKE "%2016"
    GROUP BY Pi.id
    ORDER BY Nombre_total_de_point DESC;

CREATE VIEW MotoGP_2016_Score_teams AS
    SELECT F.nom_team, SUM(nombre_total_de_point) AS nombre_total_de_point
    FROM Fait_partie F, MotoGP_2016_Score_pilotes
    WHERE MotoGP_2016_Score_pilotes.id = F.id_pilote
        AND F.annee_debut <= 2016
        AND (
            F.annee_fin >= 2016
            OR F.annee_fin IS NULL
        )
    GROUP BY F.nom_team
    ORDER BY Nombre_total_de_point DESC;

CREATE VIEW MotoGP_2016_Score_constructeurs AS
    SELECT T.marque, SUM(nombre_total_de_point) AS nombre_total_de_point
    FROM Team T, MotoGP_2016_Score_teams
    WHERE T.nom = MotoGP_2016_Score_teams.nom_team
    GROUP BY T.marque
    ORDER BY Nombre_total_de_point DESC;

CREATE VIEW Pilote_stat AS
    SELECT Pi.id AS Identifiant, Pi.nom AS Nom, Pi.prenom AS Prenom,
        Pi.age AS Age, Pi.pays AS Pays, Pi.sexe AS Sexe, Pi.numero AS Numero,
    	SUM(Pa.points_gagnes) AS Nombre_de_point,
        MIN(Pa.classement) AS Classement,
        MAX(Pa.vitesse_moy) AS Vitesse_moyenne,
        MIN(Pa.meilleur_tour) AS Meilleur_tour
    FROM Pilote Pi, Participe Pa
    WHERE Pa.id_pilote = Pi.id;

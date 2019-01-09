CREATE VIEW Pilote_stat AS
    SELECT Pi.id AS Identifiant, Pi.nom AS Nom, Pi.prenom AS Prenom,
        Pi.age AS Age, Pi.pays AS Pays, Pi.sexe AS Sexe, Pi.numero AS Numero,
    	SUM(Pa.points_gagnes) AS Nombre_de_point,
        MIN(Pa.classement) AS Classement,
        MAX(Pa.vitesse_moy) AS Vitesse_moyenne,
        MIN(Pa.meilleur_tour) AS Meilleur_tour
    FROM Pilote Pi, Participe Pa
    WHERE Pa.id_pilote = Pi.id;

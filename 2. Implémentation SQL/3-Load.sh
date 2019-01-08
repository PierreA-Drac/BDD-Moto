sqlldr userid=projet/projet control=Data_CSV/Marque.ctl log=Data_TMP/Marque.log bad=Data_TMP/Marque.bad discard=Data_TMP/Marque.discard skip=1
sqlldr userid=projet/projet control=Data_CSV/Team.ctl log=Data_TMP/Team.log bad=Data_TMP/Team.bad discard=Data_TMP/Team.discard skip=1
sqlldr userid=projet/projet control=Data_CSV/Modele_moto.ctl log=Data_TMP/Modele_moto.log bad=Data_TMP/Modele_moto.bad discard=Data_TMP/Modele_moto.discard skip=1
sqlldr userid=projet/projet control=Data_CSV/Pilote.ctl log=Data_TMP/Pilote.log bad=Data_TMP/Pilote.bad discard=Data_TMP/Pilote.discard skip=1

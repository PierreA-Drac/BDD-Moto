sqlplus projet/projet @Scripts/1-Create.sql
sh                   ./Scripts/2-Load.sh
sqlplus projet/projet @Scripts/3-Config.sql
sqlplus projet/projet @Scripts/4-liste_ora_constraints.sql
sqlplus projet/projet @Scripts/5-liste_ora_triggers.sql

sqlplus projet/projet @Scripts/1-Create.sql
sh                   ./Scripts/2-Load.sh
sqlplus projet/projet @Scripts/3-Config.sql

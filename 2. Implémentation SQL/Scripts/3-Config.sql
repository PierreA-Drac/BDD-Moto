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

exit

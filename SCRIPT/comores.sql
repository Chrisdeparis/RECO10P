-- mon projet début 
--1
-- création de la bibliotheque (deja creer)
CREATE SCHEMA ocsi12;
--2 selection de la bibliotheque d'utilisation
SET CURRENT SCHEMA ocsi12;
VALUES CURRENT SCHEMA;

-- creation de la base de données avec un format different
create TABLE comores (numat char(5) not null primary key,
nom char(15) not null,
prenom char(16) not null,
sx char(1) not null,
prof char(12),
dat_nai date not null with default)
rcdfmt komor;

3-- creation des libelés pour les nom de colonnes
LABEL ON comores
(numat is 'numéro matricule',
nom is 'Nom',
prenom is 'prénom',
sx is 'sexe',
prof is 'profession',
dat_nai is 'date de naissance');

-- insertion de tous les champs 
insert into comores values ('TF001','DAOUDA', 'MYRIAM', 'F', 'ETUDIANTE', '1996-02-20'); 
insert into comores values ('TF002','DAOUDA', 'ASSIATA', 'F', 'ETUDIANTE', '1995-08-20');
insert into comores values ('TF003','DAOUDA', 'ISSA', 'F', 'EMPLOYEE', '1988-08-10');  
insert into comores values ('TF004','DAOUDA', 'HALMA', 'F', 'ELEVE', '2012-01-29'); 
insert into comores values ('TF005','ZITOUMBI', 'HADJIRATA', 'F', 'ELEVE', '2001-12-14'); 
insert into comores values ('TF013','MOHAMED', 'ALIM', 'M', 'EMPLOYE', '1990-03-11');
insert into comores values ('TF028','DAOUDA', 'HARMIYA', 'M', 'ELEVE', '2005-07-28'); 
insert into comores values ('TF029','SOUDJAI', 'ILLIASSA', 'F', 'ELEVE', '2010-03-13');
insert into comores values ('TFA01','KAMBI', 'MOHAMED', 'M', 'EMPLOYE', '1995-12-31');
insert into comores values ('TFA02','AHMED', 'OMAR', 'M', 'ETUDIANT', '1990-12-31');
insert into comores values ('TA009','IDI', 'ANOIR', 'M', 'EMPLOYE', '1985-03-10');
insert into comores values ('TF034','ABDOU', 'IKRAM', 'M', 'EMPLOYE', '1988-07-20');
insert into comores values ('TF037','IDRISS', 'FAINA', 'F', 'ETUDIANTE', '1985-11-13');

-- observation des resultats
select * from comores;

# RECO10P
lire 10 enregistrements dans une table et les charger dans un DS multi occurrence.

- rappel : la bonne exécution de TOUTE requete sql doit être vérifiée -> A FAIRE

- modification de consigne : la ds doit contenir 4 champs :  empno, lastname, firstname, age -> A FAIRE : modifier le nom du champ (passer de birthdate à age) et le type (à mettre en numérique) dans la ds car birthdate est une date et l'age est le résultat d'un calcul

- nouvelle consigne : afficher les 10 premières lignes (comme actuellement) puis charger les lignes suivantes dans la ds et les afficher (5 dernières) , tout cela pour prépare la suite (un affichage dans un sous fichier par bloc de 10 à la place des dsply) 


## Sous-Fichier

#### Un sous fichier est composé :

 d’un format sous fichier (type **SFL**) qui permet de décrire une ligne.

 d’un format de contrôle (type **SFLCTL**) qui permet la déclaration:

- des touches de fonctions

- de la taille d’une page de sous-fichier (SFLPAGE)

- de la taille du sous-fichier (SFLSIZ)

SFLPAGE est égal au nombre de lignes que l’on veut voir apparaitre à  chaque chargement.

SFLSIZE, la taille du sous-fichier est en général la valeur de SFLPAGE + 1 (pour gérer ROLLUP & SFLEND)

 Autres mots clés à  déclarer :

on associe, dans les DDS, des mots clés à  des indicateurs

- SFLDSP => Affichage du sous fichier

- SFLDSPCTL => Affichage du format de controle

- SFLCLR => Effacement sous-fichier

 Autres mots clés à  déclarer si le chargement est dynamique

- SFLRCDNBR => Rang

- SFLEND => + en fin de page si il y a encore des pages à  afficher

- ROLLUP => Pour gérer la pagination (cet indicateur se mettera en fonction quand l’utilisateur utilise la touche « rollup »).

## PROGRAMMATION

Le sous-fichier est un fichier d’organisation relative (accès direct).
Le cycle de programmation est toujours le même

- Effacement du sous fichier

- Chargement du sous-fichier (dynamique ou intégral)

- Affichage

#### Effacement du sous-fichier :

Il se fait par l’écriture du format de contrôle après avoir mis en fonction l’indicateur associé au mot clé SFLCLR.Dans le même temps, vous devez désactiver l’affichage (inutile dans ce cas) en désactivant les indicateurs liés aux mots clés SFLDSP et SFLDSPCTL.

 Chargement du sous-fichier :

Il existe 2 méthodes classiques de chargement

- Intégral, le sous-fichier est chargé entièrement avant l’affichage (9999 lignes maxi), les touches
ROLLUP et ROLLDOWN sont gérées par le système. Ce type de chargement est à  utiliser avec des fichiers peu volumineux.

- Dynamique, Le sous fichier est chargé page par page. Le fait d’activer la touche ROLLUP doit déclencher le chargement de la page suivante du sous-fichier. La touche ROLLDOWN est gérée par le système.

Vous pouvez aussi opter pour un chargement « FULL INTEGRAL » qui consiste à  charger page par page aussi bien en ROLLUP qu’en ROLLDOWN.
Dans ce cas le système ne gère pas les touches ROLLUP et ROLLDOWN, charge au programmeur de mémoriser la position de départ et de fin de page et de charger une page à  chaque activation de la touche ROLLUP ou ROLLDOWN. On rencontre parfois ce type de chargement en SQL et en mode CGI.

Dans tous les cas on doit écrire un enregistrement dans le sous fichier avec le format sous-fichier, sans oublier ⚠⚠⚠ d’incrémenter le rang relatif du sous fichier. Dans le cas d’un chargement statique, on affectera 1 à  la valeur du rang à  la fin du chargement et avant l’affichage pour se positionner au début.

 Affichage

L’affichage se fait à  partir du format de controle après avoir mis en fonction (*on) les indicateurs associés aux mots clés SFLDSP et SFLDSPCTL et hors fonction (*off) l’indicateur associé à  SFLCLR.
On ne peut pas afficher un sous fichier vide ou un sous fichier dont le rang est égal à  0.

— **Intégral**, pour afficher la 1ère page d’un sous-fichier intégral, remettre le rang à  1.

— **Dynamique**, il faut déclarer le mot clé SFLRCDNBR (DDS) associée à  une zone (ex : WRAN01) défini en 4S 0 (numérique étendu sur 4).
Dans le programme, il faut affecter à  cette zone le rang correspondant au 1er enregistrement de la page à  afficher.

Exemples :

Pour cet exemple nous allons nous appuyer sur le fichier BOOKS et le fichier écran BOOKFM.

 Descrition Fichier (BOOKS) :
 
 # RECO10P

**_Exercice de sous fichier_** :

lire 10 enregistrements dans une table et les charger dans un DS multi occurrence.
- rappel : la bonne exécution de TOUTE requete sql doit être vérifiée -> A FAIRE
- la ds doit contenir 4 champs : empno, lastname, firstname, age -> A FAIRE : modifier le nom du champ (passer de birthdate à age) et le type (à mettre en numérique) dans la ds car birthdate est une date et l’age est le résultat d’un calcul.
- afficher les 10 premières lignes (comme actuellement) puis charger les lignes suivantes dans la ds et les afficher (5 dernières) , tout cela pour prépare la suite (un affichage dans un sous fichier par bloc de 10 à la place des dsply)

## Le Programme RECO10P

C'est dans le programme [RECO10P](https://github.com/Chrisdeparis/RECO10P/blob/master/EMPLOYEE/RECO10P.SQLRPGLE) qu'on gère le sous-fichier. On récupère les valeurs de la table [EMPLOYEE](https://github.com/Chrisdeparis/RECO10P/blob/master/SCRIPT/RECO10P.SQL) à implémenter ensuite dans le sous-fichier.
```C
dcl-f EMPFM workstn SFILE(SFL01:RRN);
dcl-ds emploDs qualified dim(10);
  EMPNO CHAR(6);
  LASTNAME VARCHAR(15);
  FIRSTNME VARCHAR(12);
  AGE int(10);
end-ds;
dcl-s NbrOfRows int(5) inz(%elem(emploDs));
```
On déclare le fichier [EMPFM](https://github.com/Chrisdeparis/RECO10P/blob/master/EMPLOYEE/EMPFM.DSPF) DSPF avec le sous fichier et le rrn.
#### EMPLODS
On précise avec dim(10) la taille de la DS le nombre de lignes qu'on souhaite retourner.
#### Le format de contrôle FORC1
Dans une boucle à condition true, on execute le format de controle et la gestion de la sortie du programme avec la touche F3 (inkc).
```sql
dow 1 = 1;
  write FORB1; 
  exfmt FORC1;
  select;
    when *inkc = *on; // inkc = F3
      leave;
  other;
  endsl;
enddo;
```
#### LoadSubfile() 
On appelle la procédure et on initialise les indicateurs et rrn.
```
  rrn = 0;
  *in05 = *on; 
  *in06 = *on;
  write forc1;
  *in05 = *off;
  *in06 = *off;
```
L'indicateur 04 => SFLDSP :warning:
L'indicateur 05 => SFLDSPCTL :warning:

#### Traitement des données avec un Curseur
```sql
  if sqlcode >=0 and sqlcode <>100;
  exec sql
    declare c0 cursor for
    select empno, lastname, firstnme,
    year( current_date ) - year( date(birthdate) ) as age
    from employee
    order by birthdate desc;
  else;
    dsply ('erreur sqlcode declare c0 =' + %char(sqlcode));
  endif;
```
Avec la gestion des erreurs par le sqlcode :warning: :warning: :warning:
```sql
  if sqlcode >=0 and sqlcode <>100;
  exec sql
    open c0;
  else;
    dsply ('erreur sqlcode open c0 =' + %char(sqlcode));
  endif;
  
  if sqlcode >=0 and sqlcode <>100;
  exec sql
    fetch next from c0
    for :nbrofrows rows
    into :emplods;
  else;
    dsply ('erreur sqlcode fetch c0 =' + %char(sqlcode));
  endif;
```
Nbrofrows  est égale à dim(10) de la DS.
Puis on passe à l'alimentation des zones de travail avec un dow et un for.
Pour écrire chaque ligne d'enregistrements dans le sous fichier SFL01.
```sql
  dow sqlcode >=0 and sqlcode <> 100;
    for i = 1 to sqler3; //Sqler3 = le nombre total d'enregistrements dans employee
      w_lastName = %char(emplods(i).lastname);
      w_firstName = %char(emplods(i).firstnme);
      w_empno = %char(emplods(i).empno);
      w_age = %char(emplods(i).age);
      
      // implementation dans EMPFM
      lastname = %char(emplods(i).lastname);
      firstnme = %char(emplods(i).firstnme);
      empno = %char(emplods(i).empno);
      age = emplods(i).age;
      
      rrn = rrn + 1;
      write sfl01;
    endfor;
    if sqlcode >=0 and sqlcode <>100;
	exec sql
	  fetch next from C0
	  for :nbrofrows rows
	  into : emplods;
	else;
	  dsply ('erreur sqlcode fetch c0 =' + %char(sqlcode));
	endif;
  enddo;
```
Sqler3 permet de faire la boucle en utilisant le nombre total d'enregistrements dans employee
dans notre cas il y a 15 lignes dans la table. :warning: :warning:
Après cette boucle on gère le rrn et l'affichage du sous-fichier. (SFLDSP).
```sql
	if rrn = 0;
	  *in04 = *off;
	else;
	  rrn = 1;
	endif;
```
Puis on termine la procédure avec le close du curseur.
```sql
	exec sql
	  close c0;
  end-proc;
```
## Le fichier écran EMPFM
Dans ce fichier on indique les indicateurs et les zones à placer.
[EMPFM](https://github.com/Chrisdeparis/RECO10P/blob/master/EMPLOYEE/EMPFM.DSPF) : Ainsi dans l'écran il y aussi bien du visuel que la logique avec les indicateurs.

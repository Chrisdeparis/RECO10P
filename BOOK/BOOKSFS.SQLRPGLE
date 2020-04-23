**free
//----------------------------------------------------------------------
// Chargement Sous-fichier Statique exemple book
//----------------------------------------------------------------------
//FICHIER écran
dcl-f bookfm workstn sfile(sfl01:wran01);
//----------------------------------------------------------------------
//Pointeur de recouvrement des indicateurs
dcl-s indptr       pointer    inz(%addr(*in));

dcl-ds *n  based(indptr);
  rollup         char(1)    pos(2);
  sfldsp         char(1)    pos(4);
  sfldspctl      char(1)    pos(5);
  sflclr         char(1)    pos(6);
  sflend         char(1)    pos(7);
  sflnxtchg      char(1)    pos(8);
  fin_sfl        char(1)    pos(70);
end-ds;

//DS pour alimenter le FETCH
dcl-ds ds_fetch  extname('books');
end-ds;

//Variables de travail
dcl-s w_x          zoned(3:0) inz;
dcl-s w_fin_pgm    ind        inz(*off);
dcl-s w_nb_ligsfl  zoned(4:0) inz;
//Constantes
//----------------------------------------------------------------------
//Initialisation du programe
Exsr inisfl1;
dow not w_fin_pgm;
  exsr ecran1;
enddo;
exsr finpgm;
*inlr = *on;
//----------------------------------------------------------------------
begsr inisfl1;
  wran01 = 0;
  w_nb_ligsfl = 0;
  //effacement du sous-fichier
  sflend = *on;
  sflclr = *on;
  sfldsp = *off;
  sfldspctl = *off;
  write forc1;
  sfldspctl = *on;
  sflclr = *off;
  exsr prereq;
  exsr fetch;
  if sqlcod = 100;
    sflend = *on;
  //aucun enregistrement ne correspond
  else;
    exsr chasf1;
  endif;
  wran01 = 0 + 1;
endsr;

//----------------------------------------------------------------------
begsr ecran1;
  sfldspctl  = *on;
  write forc1;
  write forb1;
  //Lecture écran
  read forc1;
  //Traitement touche de fonction
  if *inkc;
    //Touche F3=Fin Programme
    w_fin_pgm = *on;
  else;
    exsr verif1;
  endif;
endsr;

//----------------------------------------------------------------------
begsr verif1;
  readc sfl01;
  dow fin_sfl=*off and w_fin_pgm=*off;
    if zcdsel <> *blank;
    //Enregistrement sélectionné alimentation paramètres
    endif;
    readc sfl01;
  enddo;
endsr;

//---------------------------------------------------------------------
begsr chasf1;
  //charge tout sfl01
  sfldsp     = *on;
  wran01 = w_nb_ligsfl;
  w_x = 0;
  dow sqlcod <> 100 and  sqlcod >= 0 and w_nb_ligsfl < *hival;
    w_x = w_x + 1;
    w_nb_ligsfl = w_nb_ligsfl + 1;
    wran01 = w_nb_ligsfl;
    zcdsel = *blank;
    write sfl01;
    exsr fetch;
  enddo;
endsr;

//----------------------------------------------------------------------
begsr prereq;
  exec sql
  declare customerbook cursor for
  select * from books
  order by numbr;

  exec sql
  open customerbook;

endsr;
//----------------------------------------------------------------------
begsr fetch;
  clear ds_fetch;
  //Lecture curseur
  exec sql
  fetch next from customerbook
  into :ds_fetch;

endsr;

//----------------------------------------------------------------------
begsr finpgm;
  exec sql
  close customerbook;

endsr;
//---------------------------------------------------------------------- 

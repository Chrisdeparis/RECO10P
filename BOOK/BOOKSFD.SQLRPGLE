**free
//------------------------------------------------------------------------
// Chargement Sous-fichier Dynamique
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
    fin sfl        char(1)    pos(70);
End-DS;
    //DS pour alimenter le FETCH
Dcl-DS ds_fetch  extname(books);
End-DS;
    //Variables de travail
Dcl-S W_MEM_RANG              LIKE(WRAN01) INZ;
Dcl-S W_NB_LIGSFL  Zoned(4:0) INZ;
Dcl-C W_NB_LIGPAG 19;
Dcl-S W_X          Zoned(3:0) INZ; 
Dcl-S W_FIN_PGM    Ind        INZ(*OFF);

//Constantes
//----------------------------------------------------------------------
//Initialisation du programme
EXSR INISFL1;
DOW NOT W_FIN_PGM;
    EXSR ECRAN1;
ENDDO;
EXSR FINPGM;
*INLR = *ON;

//----------------------------------------------------------------------
BEGSR INISFL1;
    WRAN01 = 0;
    W_NB_LIGSFL = 0;
    SFLEND = *ON;
    SFLCLR = *ON;
    SFLDSP = *OFF;
    SFLDSPCTL = *OFF;
    WRITE FORC1;
    SFLDSPCTL = *ON;
    SFLCLR = *OFF;
    EXSR PREREQ;
    EXSR FETCH;
    IF sqlcod = 100;
    SFLEND = *ON;
    //Å¡Aucun enregistrement ne correspond
    ELSE;
    EXSR CHASF1;
    ENDIF;
    WRAN01 = 0 + 1;
ENDSR;
//----------------------------------------------------------------------

BEGSR ECRAN1;
    SFLDSPCTL  = *ON;
    WRITE FORC1;
    WRITE FORB1;
    //Å¡ Lecture écran
    READ FORC1;
    //Å¡Traitement touche de fonction
    SELECT;
    WHEN *INKC;
        //Å¡Touche F3=Fin Programme
        W_FIN_PGM = *ON;
    WHEN ROLLUP = *ON;
        EXSR CHASF1;
    OTHER;
        EXSR VERIF1;
    ENDSL;
ENDSR;

//----------------------------------------------------------------------
BEGSR VERIF1;
    //Å¡Relecture du sous-fichier pour CTL
    READC SFL01;
    DOW FIN_SFL=*OFF AND W_FIN_PGM=*OFF;
    IF ZCDSEL <> *BLANK;
        //Å¡Enregistrement sélectionné alimentation paramètres
    ENDIF;
    READC SFL01;
    ENDDO;
ENDSR;

//----------------------------------------------------------------------
BEGSR CHASF1;
    //Charge 1 page SFL01
    SFLDSP     = *ON;
    WRAN01 = W_NB_LIGSFL;
    W_X = 0;
    DOW W_X < W_NB_LIGPAG AND SQLCOD <> 100 AND  SQLCOD >= 0 AND W_NB_LIGSFL < *HIVAL;
    W_X = W_X + 1;
    W_NB_LIGSFL = W_NB_LIGSFL + 1;
    WRAN01 = W_NB_LIGSFL;
    ZCDSEL = *blank;
    WRITE SFL01;
    EXSR FETCH;
    Enddo;
    IF SQLCOD = 100 OR SQLCOD < 0;
    SFLEND = *ON;
    ELSE;
    SFLEND = *OFF;
    Endif;
ENDSR;
//----------------------------------------------------------------------
BEGSR PREREQ;
    Exec SQL
    Declare CustomerBook Cursor For
    Select * from BOOKS
        Order By NUMBR.
    
    Exec SQL
    Open CustomerBook;
    
ENDSR;

//----------------------------------------------------------------------
BEGSR FETCH;
    clear DS_FETCH;
    //Lecture curseur
    EXEC SQL
    FETCH NEXT FROM CustomerBook 
    INTO :DS_FETCH;
    
ENDSR;

//----------------------------------------------------------------------
BEGSR FINPGM;
    Exec SQL
    Close CustomerBook;
    
ENDSR;
//----------------------------------------------------------------------


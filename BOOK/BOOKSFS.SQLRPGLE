**free
        //----------------------------------------------------------------------
        // Chargement Sous-fichier Statique
        //----------------------------------------------------------------------
        //FICHIER écran
        Dcl-F BOOKFM WORKSTN SFILE(SFL01:WRAN01);
        //----------------------------------------------------------------------
        //Pointeur de recouvrement des indicateurs
        Dcl-S IndPtr       Pointer    INZ(%ADDR(*IN));
        Dcl-DS *N  BASED(IndPtr);
          ROLLUP         Char(1)    Pos(2);
          SFLDSP         Char(1)    Pos(4);
          SFLDSPCTL      Char(1)    Pos(5);
          SFLCLR         Char(1)    Pos(6);
          SFLEND         Char(1)    Pos(7);
          SFLNXTCHG      Char(1)    Pos(8);
          FIN_SFL        Char(1)    Pos(70);
        End-DS;
          //DS pour alimenter le FETCH
        Dcl-DS DS_FETCH  EXTNAME('BOOKS');
        End-DS;
          //Variables de travail
        Dcl-S W_X          Zoned(3:0) INZ;
        Dcl-S W_FIN_PGM    Ind        INZ(*OFF);
        Dcl-S W_NB_LIGSFL  Zoned(4:0) INZ;
        //Constantes
        //----------------------------------------------------------------------
        //Initialisation du programe
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
          //Effacement du sous-fichier
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
            //Aucun enregistrement ne correspond
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
          //Lecture écran
          READ FORC1;
          //Traitement touche de fonction
          IF *INKC;
            //Touche F3=Fin Programme
            W_FIN_PGM = *ON;
          ELSE;
            EXSR VERIF1;
          ENDIF;
        ENDSR;
        //----------------------------------------------------------------------
        BEGSR VERIF1;
          READC SFL01;
          DOW FIN_SFL=*OFF AND W_FIN_PGM=*OFF;
            IF ZCDSEL <> *BLANK;
              //Enregistrement sélectionné alimentation paramètres
            ENDIF;
            READC SFL01;
          ENDDO;
        ENDSR;
        //---------------------------------------------------------------------
        BEGSR CHASF1;
          //Charge tout SFL01
          SFLDSP     = *ON;
          WRAN01 = W_NB_LIGSFL;
          W_X = 0;
          DOW SQLCOD <> 100 AND  SQLCOD >= 0 AND W_NB_LIGSFL < *HIVAL;
            W_X = W_X + 1;
            W_NB_LIGSFL = W_NB_LIGSFL + 1;
            WRAN01 = W_NB_LIGSFL;
            ZCDSEL = *blank;
            WRITE SFL01;
            EXSR FETCH;
          Enddo;
        ENDSR;
        //----------------------------------------------------------------------
        BEGSR PREREQ;
          exec sql
            declare customerbook cursor for
            select * from books
            order by numbr;

          exec sql
            open customerbook;

        endsr;
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
          exec sql
            close customerbook;

        endsr;
        //---------------------------------------------------------------------- 

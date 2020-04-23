       //===============================================================
      //    Nom programme : PGM02P
      //    But :   AFFCIHER ECRAN OPT SAISIE(CHAMP DE RECH: NUMAT)
      //    SI OK AFFICHER LES DONNEES CORREPONDANTES AU NUMAT
      //    ETAT DU PROGRAMME :  "SUCCES"( affich enreg par enreg)
      //    LES ZONES BD DIFFERENTES DES ZONES ECRANS
      //--------------------------------------------------------------
      //  Datagramme | Date     | Correction
      //--------------------------------------------------------------
      //             | 28.12.18 |    Création programme
      //--------------------------------------------------------------
      //-------------| XX.XX.XX |----- MISE A JOUR --------------------

      // --------- Déclaration des fichiers BD et Ecran --------------

       dcl-f PGM02E workstn;
       dcl-f comores disk usage(*input) keyed ;
      //=========================== CORPS DU PROGRAMME ==================
       //--------- Afficher l'écran de saisie de rech ------------
            EXFMT SAISIE;
       //--------- F3 permet de sortir du programme (tq no f3) ------------
            DOW NOT *IN03;
      //---- Vérification de la saisie --------------------------------------
            CHAIN NUMATE KOMOR;
           //--- Pas de données correspondantes trouvées -------------------
            IF NOT %FOUND;
           //-------------- Afficher message d'erreur ------------
               MESSAGE = 'Le code numat ' + %trim(numatE) + ' n''existe pas.';
            ELSE;
           //-----------Sinon (si trouvé) Remettre le message a blanc --------
               MESSAGE = *BLANKs;
        //--- Affichage deuxième écran -avec les infos du Matricule -----------
           // ***** Transfert des infos DB vers Ecran ***********************
                NUMATE = NUMAT;
                NOME = NOM ;
                PRENOME = PRENOM ;
                PROFE = PROF ;
                SXE = SX ;
                DAT_NAIE = DAT_NAI ;
               EXFMT AFFICH;
        //--- Tant que NO F12 rester sur l'écran d'info -------------------
               DOW NOT *in12;
                  EXFMT AFFICH;
               EndDo;
            EndIf;
        //--- F12 appuyez, revenir sur l'écran SAISIE numat NUMAT BLANC -----
            numatE = *blanks;
            EXFMT SAISIE;
            EndDo;
        //--- Fin du programme -----------
            *INLR = *On;




 

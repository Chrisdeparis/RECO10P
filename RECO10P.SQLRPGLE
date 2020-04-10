**free
ctl-opt option(*nodebugio:*srcstmt) dftactgrp(*no) ;
//Objectif : lire 10 enregistrements dans une table et les charger dans un DS multi occurrence.

// DS multi occurence
dcl-ds emploDs qualified dim(10);
  EMPNO       CHAR(6);
  LASTNAME    VARCHAR(15);
  FIRSTNME    VARCHAR(12);
  AGE         INT(3)
end-ds;

dcl-s RowsFetched int(5) ;
dcl-s Offset int(10) ;

*inlr = *on;

  dow (1 = 1);
    RechercheData();
    // increment offset => 10 emploDs
    Offset += %elem(emploDs) ;

    if (RowsFetched < %elem(emploDs)) ;
      leave ;
    endif ;
  enddo ;

  // Recherche Data
  dcl-proc RechercheData ;
    // nb d'enregistrements
    dcl-s NbrOfRows int(5) inz(%elem(emploDs));

    RowsFetched = 0;
    clear emploDs;
    
    if sqlcode=0; // DATA OK
      // declarer curseur
      exec sql 
        declare c0 cursor for
        select empno, lastname, firstnme,
        year( current_date ) - year( Date(BIRTHDATE) ) as AGE
        order by birthdate desc
        offset :offset rows;

      exec sql open c0;
      // charger data dans la ds
      exec sql 
        fetch c0 
        for :nbrofrows rows 
        into :emplods;

      exec sql 
        get diagnostics :rowsfetched = row_count;

      exec sql 
        close c0;
    else;
      //erreur sql
    endif;
  end-proc;
  
 





 

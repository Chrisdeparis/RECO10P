**free
ctl-opt option(*nodebugio:*srcstmt) dftactgrp(*no) ;
//Objectif : lire 10 enregistrements dans une table et les charger dans un DS multi occurrence.

// DS multi occurence
dcl-ds emploDs qualified dim(10);
  EMPNO       CHAR(6);
  LASTNAME    VARCHAR(15);
  FIRSTNME    VARCHAR(12);
//  AGE         int(5);
end-ds;

// variable de travail
dcl-s RowsFetched int(5) ;
dcl-s Offset int(10) ;
dcl-s w_empno char(6);
dcl-s w_lastName varchar(15);
dcl-s w_firstName varchar(12);
dcl-s w_age int(5);
dcl-s w_message char(50);
dcl-s i int(5);


*inlr = *on;

monitor;

  dow (1 = 1);
    RechercheData();
    Offset += %elem(emploDs) ;     //10

    // Boucle des 10 enregistrements
    for i=1 to 10;

      w_lastName = %char(emplods(i).lastname);
      w_firstName = %char(emplods(i).firstnme);
      w_empno = %char(emplods(i).empno);
      //w_age =  %char(emplods(i).age);

      w_message = 'LASTNAME: '
                  + %trim(w_lastName)
                  + ' FIRSTNAME: '
                  + %trim(w_firstName)
                  + ' EMPNO: '
                  + %char(w_empno)
//                  + ' AGE: '
//                  + %char(w_age)
                  + '.';

      dsply (%trim(w_message));

    endfor;

    if (RowsFetched < %elem(emploDs)) ;
      leave ;
    endif ;
  enddo ;

on-error *all;

endmon;

  // Recherche Data
  dcl-proc RechercheData ;
    dcl-s NbrOfRows int(5) inz(%elem(emploDs)) ;

    RowsFetched = 0 ;
    clear emploDs ;

    if sqlcode<>100; // DATA OK

      exec sql declare c0 cursor for
                 select empno, lastname, firstnme,
                   year( current_date ) - year( date(birthdate) ) as age
                 from employee
                 order by birthdate desc
                 offset :offset rows;

      exec sql open c0;

      exec sql fetch c0 for :nbrofrows rows into :emplods;

      exec sql get diagnostics :rowsfetched = row_count;

      exec sql close c0;



    else;
      //erreur sql
    endif;
  end-proc;


 

**free
ctl-opt option(*nodebugio:*srcstmt) dftactgrp(*no) ;
//Objectif : lire 10 enregistrements dans une table et les charger dans un DS multi occurrence.

// DS multi occurence
dcl-ds emploDs qualified dim(10);
  EMPNO       CHAR(6);
  LASTNAME    VARCHAR(15);
  FIRSTNME    VARCHAR(12);
  AGE         int(10);
end-ds;

// variable de travail
dcl-s RowsFetched int(5) ;
dcl-s Offset int(10) ;
dcl-s w_empno char(6);
dcl-s w_lastName varchar(15);
dcl-s w_firstName varchar(12);
dcl-s w_age char(2);
dcl-s w_message char(50);
dcl-s i int(5);
dcl-s NbrOfRows int(5) inz(%elem(emploDs));
*inlr = *on;



  //-----------------------------------------------------------------
  i=0;
  clear emploDs;
  loadSubfile();

   exec sql
    set result sets array :emplods for :i rows;

   clear emploDs;
   loadSubfile2();

    exec sql
    set result sets array :emplods for :i rows;

  // charge 10 premiers emp
  dcl-proc loadSubfile;
    offset=0;
    exec sql declare c0 cursor for
             select empno, lastname, firstnme,
               year( current_date ) - year( date(birthdate) ) as age
             from employee
             order by birthdate desc
             limit 10
             offset :offset;

    exec sql open c0;

    if (sqlcode <100);

      dou (sqlstate <> '00000');
        exec sql fetch c0 for :nbrofrows rows into :emplods;

        if (sqlstate = '00000');
          i += 1;
          w_lastName = %char(emplods(i).lastname);
          w_firstName = %char(emplods(i).firstnme);
          w_empno = %char(emplods(i).empno);
          w_age = %char(emplods(i).age);
        endif;
      enddo;
    endif;

  end-proc;

  // charge les 10 emp suivants...
  dcl-proc loadSubfile2;
    offset=10;
    exec sql declare c1 cursor for
             select empno, lastname, firstnme,
               year( current_date ) - year( date(birthdate) ) as age
             from employee
             order by birthdate desc
             offset :offset rows;

    exec sql open c1;

    if (sqlcode = 0);

      dou (sqlstate <> '00000');
        exec sql fetch c1 for :nbrofrows rows into :emplods;


        if (sqlstate = '00000');
          i += 1;
          w_lastName = %char(emplods(i).lastname);
          w_firstName = %char(emplods(i).firstnme);
          w_empno = %char(emplods(i).empno);
          w_age = %char(emplods(i).age);
        endif;
      enddo;
    endif;
  end-proc;



  

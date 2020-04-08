**free

//Objectif : lire 10 enregistrements dans une table et les charger dans un DS multi occurrence.


//// DS multi occurence
dcl-ds dsemp qualified dim(10);
  EMPNO CHAR(6);
  FIRSTNME VARCHAR(12);
  LASTNAME VARCHAR(15);
end-ds;

// variables de travail
dcl-s w_message      char(50);

// declaration curseur
exec sql
	declare C1 cursor for
	select EMPNO, FIRSTNME, LASTNAME from employeed
	order by BIRTHDATE desc;
	
exec sql
	Open C1;
  dow sqlcode <> 100; // data OK
    exec sql
    fetch from C1
    for 10 rows
    into :dsemp;
  enddo;
  
exec sql
	close C1;




*inlr = *on;
 

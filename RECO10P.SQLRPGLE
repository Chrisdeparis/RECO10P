**free

//Objectif : lire 10 enregistrements dans une table et les charger dans un DS multi occurrence.

// DS multi occurence
dcl-ds emploDs qualified dim(10);
  EMPNO       CHAR(6);
  LASTNAME    VARCHAR(15);
  FIRSTNME    VARCHAR(12);
  AGE         INT(3)
end-ds;      

// index Ds
dcl-ds ind_array qualified dim(10);
  inDs int(5) dim(14);
end-ds;



// variables de travail
dcl-s w_message      char(50);

// declaration curseur
exec sql
	declare C1 cursor for
	select EMPNO, FIRSTNME, LASTNAME, MIDINIT, WORKDEPT, PHONENO, HIREDATE
              JOB, EDLEVEL, SEX, BIRTHDATE, SALARY, BONUS, COMM
       from employee
	order by BIRTHDATE desc;
	
exec sql
	Open C1;
  dow sqlcode <> 100; // data OK
	exec sql
	  fetch from C1
       for 10 rows
	  into :emploDs:ind_array;
	
       //dsply ( %char(empno) + ' = n°employé') ;
       //dsply emploDs.ind_array;

       //dsply ('C1 in dsemp');
       //dsply (:emploDs:ind_array);
  enddo;
exec sql
	close C1;




*inlr = *on;
 

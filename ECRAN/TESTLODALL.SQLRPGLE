**free
ctl-opt option(*nodebugio:*srcstmt) dftactgrp(*no) ;
// Define Physical File
Dcl-F TESTFILE Usage(*Input);
//Dcl-F employee Usage(*Input);
// Define Subfile
Dcl-F TESTSUBFIL WORKSTN SFILE(SFDTAR:SFRRN);
// DS multi occurenc
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
dcl-s tour int(5);
dcl-s NbrOfRows int(5) inz(10);


        //*********************************************************************
       // Define Required Variables
        //*********************************************************************

        EXSR Sub_Init;

        EXSR Sub_Main;

        EXSR Sub_Exit;

        //*********************************************************************
       // Sub_Init - First time initialization routine
        //*********************************************************************

        BEGSR Sub_Init;

          SFPGMNAM = 'TESTLODALL';

       // Clear Subfile

          *In25 = *Off;
          *In26 = *Off;
          *In28 = *On;
          WRITE SFCTLR;
          *In28 = *Off;
          *In25 = *On;
          *In26 = *On;

        ENDSR;
        //*********************************************************************
       // Sub_Main - Main Processing Routine
        //*********************************************************************
        BEGSR Sub_Main;

          EXSR Sub_Load;
          DOW *In03 = *Off And *In03 = *Off;

       // If You Need Cursor to be Pointed on Specific Record,
       // You can move corresponding RRN to CSRRR field. In this
       // example I am placing Cursor on 3rd Page.
            CSRRRN = 17;
            IF SFRRN = 0;
              *In25 = *Off;
            ENDIF;
            WRITE SFFTRR;
            EXFMT SFCTLR;

          ENDDO;

        ENDSR;
        //*********************************************************************
       // Sub_Load - Load Subfile
        //*********************************************************************
        BEGSR Sub_Load;

          SFRRN  = 0;
          CSRRRN = 1;


          //READ TESTFILE;

          //DOW Not %Eof(TESTFILE) And SFRRN < 9999;
            //SFRRN = SFRRN + 1;
            //SFTSFLD1 = TSFLD1;
            //SFTSFLD2 = TSFLD2;
            //SFTSFLD3 = TSFLD3;
            //SFTSFLD4 = TSFLD4;
            //WRITE SFDTAR;
            //READ TESTFILE;
          //ENDDO;



           //--------------------------code from recop loadsubfile-------
          //offset=0;

          //exec sql declare c0 cursor for
               //select empno, lastname, firstnme,
               //year( current_date ) - year( date(birthdate) ) as age
               //from employee
               //order by birthdate desc
               //limit 10
               //offset :offset;

          //exec sql open c0;

          //if (sqlcode <100);

            ////'00000' = Unqualified Successful Completion
            //dou (sqlstate <> '00000');
              //exec sql fetch c0
              //into :emplods.empno, :emploDs.lastname,
                   //:emplods.firstnme, :emplods.age;

              //if (sqlstate = '00000');
                //i += 1;
                //w_lastName = %char(emplods(i).lastname);
                //w_firstName = %char(emplods(i).firstnme);
                //w_empno = %char(emplods(i).empno);
                //w_age = %char(emplods(i).age);
              //endif;
            //enddo;
          //endif;
          //exec sql close c0;
          //-------------------------fin dcl-proc loadsubfile-----------

          READ TESTFILE;

          DOW Not %Eof(TESTFILE) And SFRRN < 9999;
            SFRRN = SFRRN + 1;
            SFTSFLD1 = TSFLD1;
            SFTSFLD2 = TSFLD2;
            SFTSFLD3 = TSFLD3;
            SFTSFLD4 = TSFLD4;
            WRITE SFDTAR;
            READ TESTFILE;
          ENDDO;


          *In40 = *On;
        ENDSR;
        //*********************************************************************
       // Sub_Exit - Finalization Routine
        //*********************************************************************
        BEGSR Sub_Exit;

          *InLr = *On;

        ENDSR;



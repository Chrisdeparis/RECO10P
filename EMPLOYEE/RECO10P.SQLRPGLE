**free                                                                                                                 
        ctl-opt option(*nodebugio:*srcstmt) dftactgrp(*no) ;                                                     
                                                                                                                 
          dcl-f EMPFM workstn SFILE(SFL01:RRN);                                                                  
                                                                                                                 
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
                                                                                                                 
          i=0;                                                                                                   
            clear emploDs;                                                                                       
            loadSubfile();                                                                                       
                                                                                                                 
         dow 1 = 1;                                                                                              
            write FORB1;                                                                                         
            exfmt FORC1;                                                                                         
                                                                                                                 
           select;                                                                                               
             when *inkc = *on;                                                                                   
                 leave;                                                                                          
             other;                                                                                              
           endsl;                                                                                                
                                                                                                                 
         enddo;                                                                                                  
                                                                                                                 
           // charge 10 premiers emp                                                                             
           dcl-proc loadSubfile;                                                                                 
              rrn = 0;                                                                                           
              *in05 = *on;                                                                                        
              *in06 = *on;                                                                                        
              write forc1;                                                                                       
              *in05 = *off;                                                                                      
              *in06 = *off;                                                                                      
                                                                                                                 
             exec sql declare c0 cursor for                                                                      
                      select empno, lastname, firstnme,                                                          
                        year( current_date ) - year( date(birthdate) ) as age                                    
                      from employee                                                                              
                      order by birthdate desc;                                                                   
                                                                                                                 
             exec sql open c0;                                                                                   
             exec sql fetch next from c0                                                                         
                for :nbrofrows rows into :emplods;                                                               
                                                                                                                 
              dow sqlcode >=0 and sqlcode <> 100;                                                                
                       for i = 1 to sqler3;                                                                      
                          w_lastName = %char(emplods(i).lastname);                                               
                          w_firstName = %char(emplods(i).firstnme);                                              
                          w_empno = %char(emplods(i).empno);                                                     
                          w_age = %char(emplods(i).age);                                                         
                                                                                                                 
                                                                                                                 
                          lastname = %char(emplods(i).lastname);                                                 
                          firstnme = %char(emplods(i).firstnme);                                                 
                          empno   = %char(emplods(i).empno);                                                     
                          age   =       emplods(i).age;                                                          
                                                                                                                 
                          w_message = 'LN: '                                                                     
                                + %trim(w_lastName)                                                              
                                + ' FN: '                                                                        
                                + %trim(w_firstName)                                                             
                                + ' EMPNO: '                                                                     
                                + %char(w_empno)                                                                 
                                +' AGE: '                                                                        
                                + %char(w_age)                                                                   
                                + '.';                                                                           
                                                                                                                 
                 // dsply (%trim(w_message));                                                                    
                                                                                                                 
                    rrn = rrn + 1;                                                                               
                    write sfl01;                                                                                 
                                                                                                                 
                   endfor;                                                                                       
             exec sql fetch next from C0                                                                         
                 for :nbrofrows rows into : emplods;                                                             
               enddo;                                                                                            
                                                                                                                 
           if rrn = 0;                                                                                           
              *in04 = *off;                                                                                      
           else;                                                                                                 
              rrn = 1;                                                                                           
           endif;                                                                                                
                                                                                                                 
          exec sql close c0;                                                                                     
          end-proc;                                                                                             
                                                                                                                 

  
create table BOOKS (
        NUMBR decimal(4),
        AUTHR  char(25),
        TITLE  char(25),
        PRICE  decimal(6, 2),
        PRIMARY KEY (NUMBR)); 
        
        
        --data with mockaroo digit sequence ####, full name, movie title, digit sequence ####.##
insert into BOOKS (NUMBR, AUTHR, TITLE, PRICE) values (4863, 'Tansy Macauley', 'See You Next Tuesday', 3026.60) with NC;
insert into BOOKS (NUMBR, AUTHR, TITLE, PRICE) values (1623, 'Ann-marie Botley', 'Waiting to Exhale', 1409.94) with NC;
insert into BOOKS (NUMBR, AUTHR, TITLE, PRICE) values (9946, 'Shirl Eggerton', 'Good Hair', 9948.53) with NC;
insert into BOOKS (NUMBR, AUTHR, TITLE, PRICE) values (6002, 'Agneta Essery', 'Promise Me This (Zavet)', 5294.22) with NC;
insert into BOOKS (NUMBR, AUTHR, TITLE, PRICE) values (1630, 'Aurlie Levey', 'Robin Hood: Men in Tights', 8095.67) with NC;
insert into BOOKS (NUMBR, AUTHR, TITLE, PRICE) values (6440, 'Ailyn Zaniolo', 'Twelve and Holding', 6894.39) with NC;
insert into BOOKS (NUMBR, AUTHR, TITLE, PRICE) values (1722, 'Mirella Whordley', 'Outbound (Periferic)', 1224.40) with NC;
insert into BOOKS (NUMBR, AUTHR, TITLE, PRICE) values (3401, 'Dolli Frake', 'Naan Kadavul', 5033.15) with NC;
insert into BOOKS (NUMBR, AUTHR, TITLE, PRICE) values (4929, 'Joletta Mathelon', 'Forget Baghdad', 0216.96) with NC;
insert into BOOKS (NUMBR, AUTHR, TITLE, PRICE) values (0715, 'Nathanil Norval', 'Common Wealth', 2895.29) with NC;
insert into BOOKS (NUMBR, AUTHR, TITLE, PRICE) values (5542, 'Joellyn Maccrea', 'Werner Herzog Eats', 9460.47) with NC;
insert into BOOKS (NUMBR, AUTHR, TITLE, PRICE) values (5263, 'Kienan Kittredge', 'Princess Blade', 8675.89) with NC;
insert into BOOKS (NUMBR, AUTHR, TITLE, PRICE) values (2284, 'Emlynne Pearson', 'Des fleurs pour Algernon', 12.73) with NC;
insert into BOOKS (NUMBR, AUTHR, TITLE, PRICE) values (0521, 'Jenda Veeler', 'Filming ''Othello''', 3780.53) with NC;
insert into BOOKS (NUMBR, AUTHR, TITLE, PRICE) values (7834, 'Dina Labdon', 'Down Periscope', 4078.37) with NC;
                  
      select * from books
      order by numbr
      limit 10;

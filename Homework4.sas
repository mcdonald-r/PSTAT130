*/ Exercise 1;
*/ Part a);
proc import datafile='/home/u63840840/bestsellers.xlsx'
			out=work.bestsellers
			dbms=xlsx;
	 sheet='Pt1';
	 getnames=yes;
run;
	 
*/ Part b);
title bold justify=left color=blue height=6
'Best Sellers Data';
proc print data=work.bestsellers n;
run;
*/ There are 106 observations.;

*/ Part c);
ods listing file='/home/u63840840/BestSellers_Descriptor.lst';
options date ls=76 nonumber;
proc contents data=work.bestsellers;
run;
ods listing close;

*/ Exercise 2;
*/ Part a);
data books;
	set work.bestsellers;
	if original='FRE' then language='French';
    else if original='CHI' then language='Chinese';
    else if original='ENG' then language='English';
    else if original='SPA' then language='Spanish';
    else language='Other';
    keep Title Author Language Year SalesM Genre;
run;

*/ Part b);
title 'Books Observation Report';
option firstobs=1 obs=100;
proc print data=work.books label;
	var title author language year genre salesm;
	label language='Original Language'
		  year='Year Published'
		  salesm='Approximate Sales in Millions';
run;

*/ Part c);
*/ Some of the values in the language column are cut off.;

*/ Part d);
data books;
	set work.bestsellers;
	length language $ 7;
	if original='FRE' then language='French';
    else if original='CHI' then language='Chinese';
    else if original='ENG' then language='English';
    else if original='SPA' then language='Spanish';
    else language='Other';
    keep Title Author Language Year SalesM Genre;
run;

*/ Part e);
data books2;
	set work.books;
	keep Title Author Language Year SalesM saleslevel published;
	length saleslevel $ 20;
	if salesm<25 then saleslevel='Under 25 Million';
	else if 25<=salesm<=50 then saleslevel='25 to 50 Millon';
	else saleslevel='More than 50 Million';
	
	if 2000<=year<=2024 then published='2000-Present';
	else if 1950<=year<=1999 then published='1950-1999';
	else if 1900<=year<=1949 then published='1900-1949';
	else if 1850<=year<=1899 then published='1850-1899';
	else if 1800<=year<=1849 then published='1800-1849';
	else if 1700<=year<=1799 then published='1700-1799';
run;
	
*/ Part f);
title 'Book2 Report by Published';
proc sort data=work.books2;
	by published descending saleslevel language title;
run;

proc print data=books2 noobs label n;
	by published;
	id published;
	pageby published;
	var SalesLevel Language Title Author;
	label saleslevel='Sales in Millions'	
		  language='Original Language';
run;

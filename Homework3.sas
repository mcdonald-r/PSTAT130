*/ Exercise 1;
*/ Part a);
data work.netflix;
	infile '/home/u63840840/netflix.txt';
	input Title $ 1-34 Genre $ 36-69 Premiere $ 71-77 Finale $ 89-97 Seasons 107;
run;

/* Part b)
i) 47 records
ii) 47 observations
iii) 5 variables 
*/

*/ Part c);
proc contents data=work.netflix;
run;
*/ Premiere is a Char data type;

*/ Part d);
ods listing file='/home/u63840840/Netflix_Report.lst';
options date pageno=2 ls=130 ps=90;
title 'Netflix Report';
proc print data=work.netflix n;
run;
ods listing close;

*/ Exercise 2;
*/ Part a);
data work.netflix2;
	infile '/home/u63840840/netflix.txt';
	input Title $34. +1 Genre $34. +1 Premiere date7. +11 Finale date9. +9 Seasons;
run;

*/ Part b);
ods listing file='/home/u63840840/Netflix_Report_2.lst';
options pageno=4 ls=150;
title color=green bold height=6
'Netflix Report 2';
proc print data=work.netflix2;
	format premiere mmddyy10.
	       finale mmddyy8.;
run;
ods listing close;
/*
The page number and line size options applied to the report.
The title is applied to the report, however the title options,
color, bold, and height, don't get applied to the report.
*/

*/ Exercise 3;
*/ Part a);
data work.netflix2;
	infile '/home/u63840840/netflix.txt';
	input Title $34. +1 Genre $34. +1 Premiere date7. +11 Finale date9. +9 Seasons;
	format premiere mmddyy10.
	       finale mmddyy10.;
	label title='Title of Show'
	      premiere='Date of Premiere '
	      finale='Date of Finale'
	      seasons='Number of Seasons';
run;
proc contents data=work.netflix2;
run;

*/ Part b);
proc datasets library=work;
	modify netflix2;
	format finale date9.;
	label title='Show Title'
	      finale='Final Date';
run;
proc contents data=work.netflix2;
run;

*/ Exercise 4;
*/ Part a);
proc sort data=work.netflix2
          out=netflix2_sorted;
	by descending seasons genre title;
run;

*/ Part b);
ods listing file='/home/u63840840/Netflix_Report_Sorted.lst';
title1 'Netflix Original Shows';
title2 '- Sorted by Seasons, Genre, Title -';
footnote 'Note: These shows have ended.';
options pageno=6 date ls=98;
proc print data=netflix2_sorted n label;
	where mdy(2,1,2015)<=premiere<=mdy(1,31,2020);
	label title='Show Title'
	      finale='Finale Date';
	var genre title finale;
	by seasons notsorted;
	pageby seasons;
run;
ods listing close;
*/ There are 42 total observations;

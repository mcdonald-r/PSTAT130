*/ Look at the data set;
proc print data=hw.space;
run;

*/ Part a;
proc contents data=hw.space;
run;
/*
i) 21 observations
ii) 7 variables
iii) Cost, Duration, Launch, Name, Status, Target, Type
iv) Char
v) MMDDYY10.
*/

*/ Part b;
proc format;
	value $statusfmt 'A'='Active'
					 'C'='Completed'
					 'P'='Planned';
	value costfmt low-<1000000000='Less than 1 Billion'
                   1000000000-high='At least 1 Billion';
run;

*/ Look at the applied formats;
proc print data=hw.space;
	format status $statusfmt. cost costfmt.;
run;

*/ Part c;
ods listing file='/home/u63840840/list_report_space.lst';
options nonumber date linesize=100;

title color=red bold height=7 justify=left
	'Space Report';
proc print data=hw.space label n;
	var Name Type Target Status Launch Cost;
	where status='A' OR status='P';
	label name='Mission Name' 
	      type='Mission Type' 
	      target='Target or Destination'
	      status='Mission Status'
	      launch='Launch Date'
	      cost='Estimated Cost';
	format launch date7. 
	       status $statusfmt. 
	       cost costfmt.;
run;

ods listing close;
/*
The HTML report is in a table and has the title applied in the red, bolded and sized font.
The Listing report displays the date and time.
*/
	
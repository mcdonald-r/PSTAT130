* Problem 1;
* Part a);
proc means data=hw.airbnb;
run;

/* Part b)
The variables displayed in the report are id, host_id, price, min_nights,
n_reviews, last_review, reviews_month, host_listings, availability_365,
and reviews_ltm. 

No this only represent the variables that are of num type.
*/
proc contents data=hw.airbnb; run;

/* Part c)
I would consider excluding id and host_id from the analysis, because these
variabels are just used for identification and don't hold anything when 
doing analysis.
*/

* Part d);
proc means data=hw.airbnb mean min median max maxdec=0;
	var price n_reviews host_listings;
run;
	
* Part e);
proc sort data=hw.airbnb out=work.Airbnb_sorted;
	by city;
run;
	
proc means data=work.airbnb_sorted mean min median max maxdec=0 n;
	var price n_reviews host_listings;
	by city;
run;
* There is a minimum price of -98 which is unusual; 

* Problem 2;
* Part a);
proc freq data=hw.airbnb;
run;
* There are 13 tables which represents all the variables;

* Part b);
proc format;
	value reviews_month_fmt
		low -< 2 = 'At most 2'
		2 - 4 = 'Between 2 and 4'
		4 - high = 'Mort than 4';
run;

* Part c);
proc freq data=hw.airbnb;
	format reviews_month reviews_month_fmt.;
	tables city reviews_month;
run;
* There is 1 frequency missing;

* Part d);
proc freq data=hw.airbnb;
	tables city * reviews_month;
	where room_type = 'Entire home/apt';
run;

* Problem 3;
* Part a);
proc tabulate data=hw.airbnb;
	class min_nights;
	table min_nights;
run;
* There are negative values where there shouldn't be;

data Airbnb_updated;
	set hw.airbnb;
	if min_nights < 0 then min_nights = '';
	if price < 0 then price = '';
run;

proc tabulate data=work.airbnb_updated;
	class min_nights;
	table min_nights;
run;
* The values now in min_nights is 1, 2, 3, 4, 5, 10, 30;

* Part b);
proc tabulate data=work.airbnb_updated;
	class min_nights city;
	var price;
	table min_nights city*price*mean;
run;

* Part c);
proc tabulate data=work.airbnb_updated;
	class city min_nights;
	table city all, min_nights all;
	label city = 'City', 
		min_nights = 'Minimum Number of Nights';
run;

* Part d);
* The rows are the cities and the columns are minimum number of nights;

* Part e);
* The statistic being shown in the table is the total;

* Part f);
proc tabulate data=work.airbnb_updated;
	class city min_nights;
	var price;
	table city*price*mean all, min_nights all;
	label city = 'City', 
		min_nights = 'Minimum Number of Nights';
run;

* Problem 4;
* Part a);
ods listing file='/home/u63840840/airbnb_list.lst';
proc report data=work.airbnb_updated;
	column city reviews_month price; 
run;
ods listing close;

* Part b);
ods listing file='/home/u63840840/airbnb_summary.lst';
options date pageno=5;
title 'Airbnb Summary Report';
proc report data=work.airbnb_updated headskip split='*';
	format reviews_month reviews_month_fmt.;
	column city reviews_month price; 
	define city / group;
	define reviews_month / group width=17;
	define price / analysis mean format=dollar10.2 width=19;
	label city='City*_____________'
		  reviews_month='Reviews Per Month*_____________'
		  price='Average Daily Price*_____________';
	break after city / summarize dol;
	rbreak after / summarize ol;
run;
ods listing close;

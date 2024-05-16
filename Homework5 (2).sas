* Part a);
proc contents data=home.hoenn; run;
proc contents data=home.johto; run;
proc contents data=home.kanto; run;
proc contents data=home.sinnoh; run;

* Part b);
data work.hoenn;
	length name $21;
	set home.hoenn;
	Region = 'Hoenn';
run;

data work.johto;
	length name $21;
	set home.johto;
	Region = 'Johto';
run;

data work.kanto;
	length name $21;
	set home.kanto;
	Region = 'Kanto';
run;

data work.sinnoh;
	length name $21;
	set home.sinnoh;
	Region = 'Sinnoh';
run;

proc sort data=work.hoenn; by name; run;
proc sort data=work.johto; by name; run;
proc sort data=work.kanto; by name; run;
proc sort data=work.sinnoh; by name; run;

data work.Pokemon;
	length Region $7;
	set work.kanto
		  work.hoenn(rename=(HitPoints=HP))
		  work.johto(rename=(T1=Type1 T2=Type2))
		  work.sinnoh(rename=(Sp_Attack=SpAttack Sp_Defense=SpDefense));
run;

* Part d);
proc print data=work.pokemon;
run;
* There are 505 observations in the report;

* Part e);
data region_order;
	input Region $ 1-7 region_num;
	datalines;
Kanto  1
Johto  2
Hoenn  3
Sinnoh 4
	;
run;


proc sort data=work.pokemon out=work.pokemon_2;
	by region;
run;

proc sort data=region_order out=region_order_sort;
	by region;
run;

data work.pokemon_region_lookup;
    merge region_order_sort work.pokemon_2;
    by region;
run;

proc sort data=pokemon_region_lookup out=pokemon_ordered(drop=region_num);
	by region_num;
run;

* Part f);
ods listing file='/home/u63840840/Pokemon_Ordered_Report.lst';
options date pageno=3;
title 'Pokemon Report By Region';
proc print data=pokemon_ordered label noobs n;
	var name region type1 type2;
	label name='Pokemon Name'
		  type1='Type 1'
		  type2='Type 2';
run;
ods listing close;

* Part g);
* It is a lookup table;

* Part h);
proc sort data=home.types; by code; run;
proc sort data=pokemon_ordered out=pokemon_types_merge; by type1; run;

data pokemon_first_type_merge;
	length code $8;
	merge home.types(rename=(type=Type1))
		  pokemon_types_merge(rename=(type1=code));
	by code;
run;

proc sort data=pokemon_first_type_merge; by type2; run;
proc sort data=home.types; by code; run;

data pokemon_second_type_merge;
	length code2 $8;
	merge home.types(rename=(type=Type2 code=code2))
		  pokemon_first_type_merge(rename=(type2=code2));
	by code2;
run;

proc sort data=pokemon_second_type_merge; by descending name; run;

data Pokemon_Final(drop=code code2);
	set pokemon_second_type_merge;
	where legendary = 0;
	by descending name;
run;

* Part i);
proc print data=pokemon_final noobs n label;
	var Name Region Type1 Type2 HP Speed;
	title1 color=green height=7 
	'Non-Legendary Pokemon';
	title2 color=blue height=5
	'Generations 1-4';
	label name='Pokemon Name'
		  type1='Type 1'
		  type2='Type 2'
		  hp='Hit Points';
run;
* There are 470 observations on the report;

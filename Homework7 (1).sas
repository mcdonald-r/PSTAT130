* Part a);
proc contents data=hw.employees; run;
* There are 11 variables in the data set;

* Part b);
proc gchart data=hw.employees;
	vbar years / discrete;
run;

proc gchart data=hw.employees;
	hbar salary;
run;
* There is a negative value within the years variable;

* Part c);
proc gchart data=hw.employees;
	where years >= 0;
	vbar years / discrete;
run;

* Part d);
proc gchart data=hw.employees;
	pie education / sumvar=salary
					type=mean
					fill=solid
					explode='Bachelor';
	format salary dollar10.2;
run;

* Part e);
proc gplot data=hw.employees;
	title1 'Annual Salary vs. Years of Experience';
	title2 'Employees with Master’s Degrees';
	plot salary*years / regeqn vaxis=40000 to 95000 by 5000;
	symbol v=diamond c=green i=rl;
	label salary='Annual Salary'
		  years = 'Years of Experience';
	format salary dollar10.2;
run; quit;

* Part f);
* i;
data e1;
	set hw.employees;
	SalaryRT = sum(SalaryRT, salary);
	retain salaryrt;
run;

proc report data=e1 ;
	column employeeid salary salaryrt;
	define employeeid / display;
run;

* ii;
data e2;
	set hw.employees;
	salaryrt+salary;
run;

proc report data=e2;
	column employeeid salary salaryrt;
	define employeeid / display;
run;

* Part g);
proc sort data=hw.employees;
	by branch;
run;

data e3;
	set hw.employees;
	salaryrt+salary;
	by branch;
run;

proc report data=e3;
	column branch salaryrt;
	define branch / group;
	format salaryrt dollar14.;
run;

* Part h);
data work.salary;
	set hw.employees;
	year=1;
	if branch = 'Los Angeles' or branch = 'Boston'
		then Salary_Proj = sum(salary, salary*.051);
	if branch = 'Miami' or branch = 'Seattle'
		then Salary_Proj = sum(salary, salary*.049);
	output;
	year=2;
	if branch = 'Los Angeles' or branch = 'Boston'
		then Salary_Proj = sum(salary_proj, salary_proj*.051);
	if branch = 'Miami' or branch = 'Seattle'
		then Salary_Proj = sum(salary_proj, salary_proj*.049);
	output;
run;

proc sort data=work.salary; by employeeid; run;

proc print data=work.salary; 
	var employeeid branch salary year salary_proj;
	format salary salary_proj dollar14.2;
run;

* Part i);
data single(keep=EmployeeID Branch Years Salary Department Education
	 	PerformanceRating TrainingHours) 
	 married(keep=EmployeeID Branch Years Salary Department CommuteDistance
	 	MaritalStatus Education PerformanceRating TrainingHours YearsSincePromotion) 
	 divorced(keep=EmployeeID Branch Years Salary);
	set hw.employees;
	if maritalstatus = 'Single' then output single;
	else if maritalstatus = 'Married' then output married;
	else if maritalstatus = 'Divorced' then output divorced;
run;

* Part j);
/*
There are 521 observations in the Employees data set.
There are 124 observations in the Single data set.
There are 299 observations in the Married data set.
There are 98 observations in the Divorced data set.
*/

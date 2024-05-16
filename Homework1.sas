proc print data=data1.talent label N;
var FirstName LastName Address2 Height Rate;
label firstname='First Name'
      lastname='Last Name'
      address2='Location'
      height='Height(in)'
      rate='Daily Rate';
where address2^='CANTON, NJ' and rate<2700;
run;

DATA hw.paintings;
input title $ first $ last $ year price_paid;
datalines;
SalvatorMundi Leonardo daVinci 1500 450000000
Interchange Willem deKooning 1955 300000000
TheCardPlayers Paul Cezanne 1895 250000000
NafeaFaaIpoipo Paul Gauguin 1892 210000000
Number17A Jackson Pollock 1948 200000000
No6 Mark Rothko 1951 186000000
;
run; 

proc print data=hw.paintings label noobs;
var title first last year price_paid;
label title='Title of Painting'
      first='Artist First Name'
      last='Artist Last Name'
      year='Year Completed'
      price_paid='Most Recent Price Paid';
sum price_paid;
*Many of the values of title are cut short in the RESULTS;

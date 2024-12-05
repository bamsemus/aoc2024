/*Part1!!*/

data a(keep=n rename=(n=n1)) b(keep=n rename=(n=n2));
set ct;

n =input(scan(ft,1,''),8.); 
output a;
n =input(scan(ft,2,''),8.); 
output b;

run;

proc sort data=a;by n1;run;
proc sort data=b;by n2;run;

data a01;
set a;
nr = _N_;
run;

data b01;
set b;
nr = _N_;
run;

proc sql;
create table Part1 as
select 

sum(abs(a.n1-b.n2)) as Part1
 

from a01 a
join b01 b
on a.nr = b.nr;


quit;

/*Part 2*/

proc sql;
create table Part2 as

select 
sum(coalesce(b.ant,0)*a.n1) as Part2

from a01 a

left join (select distinct n2, count(*) as ant from b01 group by n2) b on 
a.n1 = b.n2;

quit;


data ct;
  infile datalines truncover;
  input  ft $20000.;
	
	retain lang 0;	

  	len = length(strip(ft));
	
	if len > lang then lang = len;

	call symput('antobs',strip(put(_N_,8.)));
	call symput('maxlen',strip(put(lang,8.)));

  datalines;
input_from_aoc
;

run;
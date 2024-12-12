data ct;
  infile datalines truncover;
  input  ft $20000.;
	
	retain lang 0;	

  	len = length(strip(ft));
	
	if len > lang then lang = len;

	call symput('antobs',strip(put(_N_,8.)));
	call symput('maxlen',strip(put(lang,8.)));

  datalines;
Input_from_aoc
;

run;

%macro gor(ds=,blink=);

data ct01(keep=num ant);
set ct;
do i = 1 to (countc(strip(ft),'')+1);
num = input(scan(strip(ft),i,''),8.);
ant=1;
output;
end;
run;

%do i = 1 %to %eval(&blink.);

%put "i:  &i.";

data ct01(keep=num ant);
set ct01;

if num = 0 then do;
num = 1;
output;
end;
else if mod((floor(log10(abs(num))) + 1),2) = 0 then do;

dig = floor(log10(abs(num))) + 1;
t = strip(put(num,32.));

num = input(strip(substr(t,1,dig/2)),32.);
output;
num = input(strip(substr(t,(dig/2)+1)),32.);
output;

end;
else do;
num = num * 2024;
output;
end;

run;

proc sql;
create table ct01a as
select num,ant, count(*) as nant
from ct01
group by num,ant;

quit;

proc sql;
create table ct01 as
select num,sum(ant*nant) as ant
from ct01a
group by num;

quit;


%end;


proc sql;
create table &ds. as 
select sum(ant) as p1 format 32.
from 
ct01;

quit;


%mend;

options nosource nonotes;
%gor(ds=Part1,blink=25);
%gor(ds=Part2,blink=75);
options source notes;
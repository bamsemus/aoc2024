data ct01(keep=num);
set ct;
do i = 1 to (countc(strip(ft),'')+1);
num = input(scan(strip(ft),i,''),8.);
output;
end;
run;

/*0 4 4979 24 4356119 914 85734 698829*/
/*
0:{4:2024} 
4:{3:8096}
4979:{2:4979}
24:{1:24}
4356119:{}
*/
/*data ct01;
num = 85734;
run;
*/

%macro gor;
%do i = 1 %to 25;

%put "i:  &i.";

data ct01(keep=num);
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

%end;
%mend;
%gor;

proc sql;
create table antal25 as
select num, count(*) as ant
from ct01
group by num;

quit;

data _null_;
set antal25;
call symput('antal25',strip(put(_N_,8.)));
run;
%put &=antal25;

data num50;run;

/*%let j=1;*/

options nosource nonotes;

%macro gor1;

%do j=1 %to %eval(&antal25.);
/*%do j=512 %to 513;*/

data _NULL_;
set antal25;
if _N_ = %eval(&j.);
call symput('_num',strip(put(num,32.)));
call symput('_ant',strip(put(ant,32.)));
run;

%put &=_num;
%put &=_ant;

data ct01(keep=num);
set antal25;
if num = %eval(&_num.);
run;

%do i = 1 %to 25;
data ct01(keep=num);
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
%end;

proc sql;
create table antal50 as
select num, (count(*))*%eval(&_ant.) as ant
from ct01
group by num;

quit;

data num50;
set num50 antal50;
if ant;
run;

%end;

proc sql;
create table num50 as
select num, sum(ant) as ant
from num50
group by num;

quit;

%mend;
%gor1;

options source notes;

proc sort data=num50; by num;run;

data x;set num50;run;

/**/

data _null_;
set num50;
call symput('antal50',strip(put(_N_,8.)));
run;
%put &=antal50;

data num75;run;

/*%let j=1;*/

options nosource nonotes;

%macro gor1;

%do j=1 %to %eval(&antal25.);
/*%do j=512 %to 513;*/

data _NULL_;
set num50;
if _N_ = %eval(&j.);
call symput('_num',strip(put(num,32.)));
call symput('_ant',strip(put(ant,32.)));
run;

%put &=_num;
%put &=_ant;

data ct01(keep=num);
set num50;
if num = %eval(&_num.);
run;

%do i = 1 %to 25;
data ct01(keep=num);
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
%end;

proc sql;
create table antal75 as
select num, (count(*))*%eval(&_ant.) as ant
from ct01
group by num;

quit;

data num75;
set num75 antal75;
if ant;
run;

%end;

proc sql;
create table num75 as
select num, sum(ant) as ant
from num75
group by num;

quit;

%mend;
%gor1;

options nosource nonotes;

proc sort data=num75; by num;run;

data Part2;
set num75 end=eof;
retain Part2;

if _N_ = 1 then Part2 = ant;
else Part2 = Part2 + ant;

if eof;
Format Part2 $32.;
run;


/*0 møder 0 efter 4 klik*/

data ct;
  infile datalines truncover;
  input  ft $20000.;
	
	retain lang 0;	

  	len = length(strip(ft));
	
	if len > lang then lang = len;

	call symput('antobs',strip(put(_N_,8.)));
	call symput('maxlen',strip(put(lang,8.)));

  datalines;
0 4 4979 24 4356119 914 85734 698829
;

run;

/*
data ct;
  infile datalines truncover;
  input  ft $20000.;
	
	retain lang 0;	

  	len = length(strip(ft));
	
	if len > lang then lang = len;

	call symput('antobs',strip(put(_N_,8.)));
	call symput('maxlen',strip(put(lang,8.)));

  datalines;
28 4 3179 96938 0 6617406 490 816207
;

run;
*/

/*
28: 	34730
4:  	26669
3179:	47246
96938:	10986
0:		19778
6617406: 5912
490:	17036
816207: 26810

*/

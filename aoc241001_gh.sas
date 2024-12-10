
data ct04(keep=nr vv ll);
set ct;

do i = 1 to len;
nr = input(substr(ft,i,1),8.);
vv = i;
ll = _N_;
output;
end;
run;


proc sql;
create table part2 as 

select count(*) as Part2 from (

select distinct
    nr9.nr as nr9,
    nr9.LL as LL9,
    nr9.VV as VV9


    %macro gor;
        %do i = 8 %to 0 %by -1;
            , nr&i..nr as nr&i.
            , nr&i..LL as LL&i.
            , nr&i..VV as VV&i.
        %end;
    %mend;
    %gor

from ct04 nr9

    
    %macro gor1;
        %do i = 8 %to 0 %by -1;
            join ct04 nr&i.
            on sum(abs(nr&i..LL - nr%eval(&i.+1).LL), abs(nr&i..VV - nr%eval(&i.+1).VV)) = 1 
            and nr&i..nr = &i.
        %end;
    %mend;
    %gor1

where nr9.nr = 9);
quit;

proc sql;
create table Part1 as 

select count(*) as Part1 from (

select distinct nr9,nr0,ll9,ll0,vv9,vv0 from (

select distinct
    nr9.nr as nr9,
    nr9.LL as LL9,
    nr9.VV as VV9


    %macro gor;
        %do i = 8 %to 0 %by -1;
            , nr&i..nr as nr&i.
            , nr&i..LL as LL&i.
            , nr&i..VV as VV&i.
        %end;
    %mend;
    %gor

from ct04 nr9

    
    %macro gor1;
        %do i = 8 %to 0 %by -1;
            join ct04 nr&i.
            on sum(abs(nr&i..LL - nr%eval(&i.+1).LL), abs(nr&i..VV - nr%eval(&i.+1).VV)) = 1 
            and nr&i..nr = &i.
        %end;
    %mend;
    %gor1

where nr9.nr = 9));
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
Input_from_aoc
;

run;

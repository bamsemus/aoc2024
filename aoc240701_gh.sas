data ct01(drop=ft lang len rest);

length eq ant_tal talnr result delres 8;

set ct;

eq = _N_;

rest = strip(scan(ft,2,':'));
ant_tal = countc(strip(rest),'')+1;

talnr = 1;

ant_regn = 2**(ant_tal-1);


array tal[12] 8. tal1-tal12;
do i = 1 to ant_tal;

tal[i] = input(scan(strip(rest),i,''),32.);


end;


result = input(scan(ft,1,':'),32.);


delres = tal[talnr];



run;


data keep_done;run;

%macro gor;
%do I = 1 %to 12;

data ct01 done;
set ct01;
array tal[12] 8. tal1-tal12;

talnr+1;

odelres = delres;

if tal[talnr] then do;

	delres = odelres + tal[talnr];
	
	if ant_tal = talnr and result = delres then output done;
	else if talnr < ant_tal and delres =< result then output ct01;


	delres = odelres * tal[talnr];

	if ant_tal = talnr and result = delres then output done;
	else if talnr < ant_tal and delres =< result then output ct01;
 

end;


run;

data keep_done;
set keep_done done;
run;

%end;
%mend;
%gor;

proc sort data=keep_done out=unik_keep_done nodupkey;by eq;run;


data Part1(Keep=Part1);
set unik_keep_done end=eof;
where result;
retain Part1 0;

Part1 = result + Part1;

if eof;
Format Part1 32.;
run;


/*find rest*/

data ct02(drop=ft lang len rest);

length eq ant_tal talnr result delres 8;

set ct;

eq = _N_;

rest = strip(scan(ft,2,':'));
ant_tal = countc(strip(rest),'')+1;

talnr = 1;

ant_regn = 2**(ant_tal-1);


array tal[12] 8. tal1-tal12;
array taltxt[12] $4. taltxt1-taltxt12;
do i = 1 to ant_tal;

tal[i] = input(scan(strip(rest),i,''),32.);
taltxt[i] = scan(strip(rest),i,'');

end;


result = input(scan(ft,1,':'),32.);


delres = tal[talnr];



run;

proc sql;

create table ct03 as select

A.* from ct02 a

left join (select distinct eq from unik_keep_done) b
on A.eq = B.eq

where b.eq = .
;


quit;

data keep_done2;run;

%macro gor;
%do I = 1 %to 12;

data ct03 done;
set ct03;
array tal[12] 8. tal1-tal12;
array taltxt[12] $4. taltxt1-taltxt12;

talnr+1;

odelres = delres;

if tal[talnr] then do;

	delres = odelres + tal[talnr];
	
	if ant_tal = talnr and result = delres then output done;
	else if talnr < ant_tal and delres =< result then output ct03;

	delres = odelres * tal[talnr];

	if ant_tal = talnr and result = delres then output done;
	else if talnr < ant_tal and delres =< result then output ct03;

	delres = input((strip(put(odelres,$32.))||strip(taltxt[talnr])),32.);

	if ant_tal = talnr and result = delres then output done;
	else if talnr < ant_tal and delres =< result then output ct03;
 

end;


run;

data keep_done2;
set keep_done2 done;
run;

%end;
%mend;
%gor;

proc sort data=keep_done2 out=unik_keep_done2 nodupkey;by eq;run;


data begge;
set unik_keep_done unik_keep_done2;
run;




data Part2(Keep=Part2);
set begge end=eof;
where result;
retain Part2 0;

Part2 = result + Part2;

if eof;
Format Part2 32.;
run;

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
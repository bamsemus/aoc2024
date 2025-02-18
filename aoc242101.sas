/*

Part2 kan maaske loeses ved at vaelge imellem de forskellige Paths,
vv^ over v^v ect. 

*/



data numpad;
  infile datalines truncover;
  input  ft $20000.;
	
	retain lang 0;	

  	len = length(strip(ft));
	
	if len > lang then lang = len;

	call symput('antobs',strip(put(_N_,8.)));
	call symput('maxlen',strip(put(lang,8.)));

  datalines;
#########
#########
#########
###789###
###456###
###123###
####0A###
#########
#########
#########
;

run;

%let ekstra_lod = 0;
%let ekstra_vand = 0;

%let lod_ant = %sysfunc(sum(%eval(&antobs.),%eval(&ekstra_lod)));
%let vand_ant = %sysfunc(sum(%eval(&maxlen.),%eval(&ekstra_vand)));
%put &=lod_ant.;
%put &=vand_ant.;

data numpad01(drop=ft lang len i);
set numpad end=eof;
retain %skriv_array_var(a=&lod_ant.,b=&vand_ant. ,at=gri , bt=d);

%skriv_array(navn=grid, type=$1.,a=&lod_ant.,b=&vand_ant. ,at=gri , bt=d);

do i = 1 to &vand_ant.;

grid{_n_,i} = substr(ft,i,1);
 
end;

if eof;
run;

/* numpad:
+---+---+---+
| 7 | 8 | 9 |
+---+---+---+
| 4 | 5 | 6 |
+---+---+---+
| 1 | 2 | 3 |
+---+---+---+
    | 0 | A |
    +---+---+
*/
/* direct
   +---+---+
    | ^ | A |
+---+---+---+
| < | v | > |
+---+---+---+
*/

/**/

/*

  2	
1	3
  4

*/



proc format;
    value drc
        1 = '<'  /* Map 1 to '<' */
        2 = '^'  /* Map 2 to '^' */
        3 = '>'  /* Map 3 to '>' */
        4 = 'v'; /* Map 4 to 'v' */
run;


data L5;
length dir $5.;
do i1 = 1 to 4;
do i2 = 1 to 4;
do i3 = 1 to 4;
do i4 = 1 to 4;
do i5 = 1 to 4;

dir = put(i1,drc.)||put(i2,drc.)||put(i3,drc.)||put(i4,drc.)||put(i5,drc.);

output;
end;
end;
end;
end;
end;
run;

data L5_check;
length dir_ok $5.;
set L5;

array i[5] i1-i5;

uniq_char = prxchange('s/(.)(?=.*\1)//', -1, dir);
if length(strip(uniq_char))>2 then delete;

if prxmatch('/(.).*?\1.*?\1.*?\1/', dir) then delete; /* A character appears more than 3 times */

do k = 1 to 5;

dir_ok = substr(dir,1,k);

output;

end;

run;

proc sort nodupkey; by dir_ok;run;

data L5_check01(keep= dir_ok i1-i5);
 set L5_check;

array i[5] i1-i5;

if index(dir_ok,'<') and index(dir_ok,'>') then delete;
if index(dir_ok,'^') and index(dir_ok,'v') then delete;

l_dir_ok = length(strip(dir_ok));

do j=(l_dir_ok+1) to 5;
i[j] = .;
end; 

run;

proc sql;
create table L5_check02 as
select A.*,b.*

from L5_check01 a
join  numpad01 b
on 1=1;



quit;


data L5_check03(keep= start slut dir_ok );
length start slut $1.;
set L5_check02;

array i[5] i1-i5;
%skriv_array(navn=grid, type=$1.,a=&lod_ant.,b=&vand_ant. ,at=gri , bt=d);


do lod = 1 to %eval(&LOD_ant.);
	do vand = 1 to %eval(&vand_ant.);

/*do lod = 4 to 4;
	do vand = 4 to 4;*/

		if grid{lod,vand} ne '#' then do;

		start = grid{lod,vand};

		dll=0;
		dvv=0;

			mulig=1;
			do k=1 to 5;

				if i[k] ne . then do;

				dL = mod(abs(i[k]-3),2)*(i[k]-3);
				dV = mod(abs(i[k]-2),2)*(i[k]-2);

				dll = dll + dl;
				dvv = dvv + dv;

				if grid{lod+dll,vand+dvv} = '#' then mulig=0; /*is travel over "#" ok? */

				end;
				
			end;
		
			/*put "dll: " dll ", dvv: " dvv;*/ 
			if grid{lod+dll,vand+dvv} ne '#' and mulig=1 then do;
				slut = grid{lod+dll,vand+dvv};
				output;
			end; 

		end;

	end;
end;

run;
proc sort data=L5_check03 nodupkey; by start slut dir_ok;run;



proc sql;
create table dir_to_num as select

A.*,count(*) as tot_rute


from L5_check03 a

group by start,slut
order by start,slut, dir_ok
;

quit;
data dir_to_num01;

set dir_to_num;
by start slut dir_ok;
retain nr_rute;



if first.slut then do;
nr_rute=1;
end;
else nr_rute+1;

run;


/****************/

/*	keypad
    +---+---+
    | ^ | A |
+---+---+---+
| < | v | > |
+---+---+---+

to keypad

    +---+---+
    | ^ | A |
+---+---+---+
| < | v | > |
+---+---+---+


*/
/*From,To,Seq*/
data keyp_to_keyp;
  infile datalines truncover;
  input  ft $20000.;
	
	retain lang 0;	

  	len = length(strip(ft));
	
	if len > lang then lang = len;

	call symput('antobs',strip(put(_N_,8.)));
	call symput('maxlen',strip(put(lang,8.)));

  datalines;
<,<,A
<,v,>A
<,>,>>A
<,^,>^A
<,A,>>^A
<,A,>^>A
v,v,A
v,>,>A
v,<,<A
v,^,^A
v,A,>^A
v,A,^>A
>,>,A
>,A,^A
>,^,<^A
>,^,^<A
>,v,<A
>,<,<<A
^,^,A
^,A,>A
^,v,vA
^,>,>vA
^,>,v>A
^,<,v<A
A,A,A
A,^,<A
A,>,vA
A,v,<vA
A,v,v<A
A,<,v<<A
A,<,<v<A
;

run;

data k2k_egen(keep=start slut dir_ok org_sort);
length start slut $1. dir_ok $5.;
set keyp_to_keyp;
start = scan(ft,1,',');
slut = scan(ft,2,',');
dir_ok = scan(ft,3,',');
org_sort = _N_;
run;

proc sort nodupkey; by start slut /*dir_ok*/ org_sort;run;


proc sql;
create table dir_to_dir as select

A.*,count(*) as tot_rute


from k2k_egen a

group by start,slut
order by start,slut, /*dir_ok*/ org_sort
;

quit;
data dir_to_dir01;
set dir_to_dir;
by start slut org_sort;
retain nr_rute;

if first.slut then do;
nr_rute=1;
end;
else nr_rute+1;

run;

%let _kode = 179A;
%let _kode = 029A;




%macro delres(_kode=);

%macro skriv;

%do k=1 %to 4;
 beg&k. end&k. 
%end;


%mend;

data testNY(drop=i);
length kode $4. %skriv $1.;
kode = "&_kode.";

array beg[4] $1. beg1-beg4;
array end[4] $1. end1-end4;

do i=1 to 4;

if i = 1 then do;
beg[i] = 'A';
end[i] = substr(kode,i,1);
end;
else do;
beg[i] = substr(kode,i-1,1);
end[i] = substr(kode,i,1);
end;

end;


run;

proc sql;
create table testny01 as select

a.kode
,a.beg1	
,a.end1
,a.beg2
,a.end2
,a.beg3
,a.end3
,a.beg4
,a.end4

,strip(b.dir_ok)||'A' as str length=100


from testny a
join dir_to_num01 b 
on a.beg1 = b.start
and a.end1 = b.slut;


quit;

%macro gor;
%do i = 2 %to 4; 
proc sql;
create table testny01 as select

a.kode
,a.beg1	
,a.end1
,a.beg2
,a.end2
,a.beg3
,a.end3
,a.beg4
,a.end4

,strip(a.str)||strip(b.dir_ok)||'A' as str

from testny01 a
join dir_to_num01 b 
on a.beg&i. = b.start
and a.end&i.= b.slut;

quit;
%end;
%mend;
%gor;

data testny02;
set testny01(drop=beg: end:);

array beg[100] $1. beg1-beg100;
array end[100] $1. end1-end100;



do i=1 to 100;

if i = 1 then do;
beg[i] = 'A';
end[i] = substr(str,i,1);
end;
else do;
beg[i] = substr(str,i-1,1);
end[i] = substr(str,i,1);
end;

end;

run;

proc sql;
create table testny03 as select

strip(b.dir_ok) as str length=100, a.*

from testny02 a
join dir_to_dir01 b 
on a.beg1 = b.start
and a.end1 = b.slut;


quit;


%macro gor;
%do i = 2 %to 40;

proc sql;
create table testny03 as select

strip(a.str)||strip(b.dir_ok) as str length=100,  a.*

from testny03 a
left join dir_to_dir01 b 
on a.beg&i. = b.start
and a.end&i.= b.slut;


quit;

%end;
%mend;
%gor;


data testny04;
set testny03(drop=beg: end:);

array beg[100] $1. beg1-beg100;
array end[100] $1. end1-end100;

do i=1 to 100;

if i = 1 then do;
beg[i] = 'A';
end[i] = substr(str,i,1);
end;
else do;
beg[i] = substr(str,i-1,1);
end[i] = substr(str,i,1);
end;

end;

run;


proc sql;
create table testny05 as select

strip(b.dir_ok) as str length=100, a.*

from testny04 a
join dir_to_dir01 b 
on a.beg1 = b.start
and a.end1 = b.slut;


quit;


%macro gor;
%do i = 2 %to 40;

proc sql;
create table testny05 as select

strip(a.str)||strip(b.dir_ok) as str length=100,  a.*

from testny05 a
left join dir_to_dir01 b 
on a.beg&i. = b.start
and a.end&i.= b.slut;


quit;

%end;
%mend;
%gor;


data delres(keep= kode kodenum lang delres);
set testny05 end=eof;
retain stor lang;

array beg[100] $1. beg1-beg100;
array end[100] $1. end1-end100;

if _N_=1 then do
stor = 0;
lang = 999999;
end;

do i = 1 to 100;
	if beg[i] = '' then do;
		if (i-1) > stor then stor = i-1;
		leave;
	end;
end;

if length(strip(str)) < lang then lang = length(strip(str)); 

*where strip(str) = '<vA<AA>>^AvAA<^A>A<v<A>>^AvA^A<vA>^A<v<A>^A>AAvA^A<v<A>A>^AAAvA<^A>A';

if eof then do;

kodenum = input(compress(strip(kode), , 'kd'),8.);

delres = kodenum * lang;
output;
end;

run;

data res;
set delres res;
if kode = '' then delete;
run;

%mend;

data res;run;


%delres(_kode=341A);
%delres(_kode=083A);
%delres(_kode=802A);
%delres(_kode=973A);
%delres(_kode=780A);

data Part1;
set res;
retain Part1 0;

Part1 = Part1 + delres;

run;

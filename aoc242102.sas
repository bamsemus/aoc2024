/*

Part2 kan maaske loeses ved at vaelge imellem de forskellige Paths,
vv^ over v^v ect.

A,<,v<<A
A,<,<v<A 

*/

data d2d;
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

data d2d(keep=start slut dir_ok org_sort);
length start slut $1. dir_ok $5.;
set d2d;
start = scan(ft,1,',');
slut = scan(ft,2,',');
dir_ok = scan(ft,3,',');

run;

proc sort nodupkey; by start slut dir_ok;run;


proc sql;
create table d2d as select

A.*,count(*) as tot_rute


from d2d a

group by start,slut
order by start,slut, dir_ok
;

quit;
data d2d;
set d2d;
by start slut dir_ok;
retain nr_rute;

if first.slut then do;
nr_rute=1;
end;
else nr_rute+1;

run;


proc format;
    value drc
        1 = '<'  /* Map 1 to '<' */
        2 = '^'  /* Map 2 to '^' */
        3 = '>'  /* Map 3 to '>' */
        4 = 'v'; /* Map 4 to 'v' */
run;


data L55;
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

data L55_check;
length dir_ok $5.;
set L55;

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

data L55_check01(keep= dir_ok i1-i5);
 set L55_check;

array i[5] i1-i5;

if index(dir_ok,'<') and index(dir_ok,'>') then delete;
if index(dir_ok,'^') and index(dir_ok,'v') then delete;

l_dir_ok = length(strip(dir_ok));

do j=(l_dir_ok+1) to 5;
i[j] = .;
end; 

run;

proc sql;
create table L55_check02 as
select A.*,b.*

from L55_check01 a
join  numpad01 b
on 1=1;



quit;


data L55_check03(keep= start slut dir_ok );
length start slut $1.;
set L55_check02;

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
proc sort data=L55_check03 nodupkey; by start slut dir_ok;run;


proc sql;
create table d2n as select

A.*,count(*) as tot_rute


from L55_check03 a

group by start,slut
order by start,slut, dir_ok
;

quit;

proc datasets library=work nolist;
    delete L55:;
quit;


data d2n;
length dir_ok $6.;
set d2n;
by start slut dir_ok;
retain nr_rute;

dir_ok = strip(dir_ok)||'A';

if first.slut then do;
nr_rute=1;
end;
else nr_rute+1;

run;

%macro lenskriv;
length 
%do i=1 %to 31;

d2d_st&i. d2d_sl&i. $1. d2d_dir&i. $5. d2d_nr_r&i. d2d_tot_r&i. 8.

%end;
;
%mend;

data d2d_arr;
%lenskriv;
set d2d end=eof;
retain 
d2d_st1-d2d_st31
d2d_sl1-d2d_sl31
d2d_dir1-d2d_dir31
d2d_nr_r1-d2d_nr_r31
d2d_tot_r1-d2d_tot_r31
;

array d2d_st[31] $1. d2d_st1-d2d_st31;
array d2d_sl[31] $1. d2d_sl1-d2d_sl31;
array d2d_dir[31] $6. d2d_dir1-d2d_dir31;
array d2d_nr_r[31] 8. d2d_nr_r1-d2d_nr_r31;
array d2d_tot_r[31] 8. d2d_tot_r1-d2d_tot_r31;

d2d_st[_N_] = start;
d2d_sl[_N_] = slut;
d2d_dir[_N_] = dir_ok;
d2d_nr_r[_N_] = nr_rute;
d2d_tot_r[_N_] = tot_rute;

if eof;
run;

%macro lenskriv;
length 
%do i=1 %to 234;

d2n_st&i. d2n_sl&i. $1. d2n_dir&i. $5. d2n_nr_r&i. d2n_tot_r&i. 8.

%end;
;
%mend;

data d2n_arr;
%lenskriv;
set d2n end=eof;
retain 
d2n_st1-d2n_st234
d2n_sl1-d2n_sl234
d2n_dir1-d2n_dir234
d2n_nr_r1-d2n_nr_r234
d2n_tot_r1-d2n_tot_r234
;

array d2n_st[234] $1. d2n_st1-d2n_st234;
array d2n_sl[234] $1. d2n_sl1-d2n_sl234;
array d2n_dir[234] $6. d2n_dir1-d2n_dir234;
array d2n_nr_r[234] 8. d2n_nr_r1-d2n_nr_r234;
array d2n_tot_r[234] 8. d2n_tot_r1-d2n_tot_r234;

d2n_st[_N_] = start;
d2n_sl[_N_] = slut;
d2n_dir[_N_] = dir_ok;
d2n_nr_r[_N_] = nr_rute;
d2n_tot_r[_N_] = tot_rute;

if eof;
run;

proc sql;
create table arr as 
select 

"&_kode" as kode ,a.*,b.* from

d2d_arr a
join d2n_arr b
on 1=1;

quit;



data arr01;
length kode $4. kStart1-kStart4 kSlut1-kSlut4 $1.;
set arr;

								/*lod = 10*/ /*vand = 10*/
%skriv_array(navn=grid, type=$100.,a=10,b=10 ,at=gri , bt=d);

array kStart[4] $1. kStart1-kStart4; 
array kSlut[4] $1. kSlut1-kSlut4; 


array d2d_st[31] $1. d2d_st1-d2d_st31;
array d2d_sl[31] $1. d2d_sl1-d2d_sl31;
array d2d_dir[31] $6. d2d_dir1-d2d_dir31;
array d2d_nr_r[31] 8. d2d_nr_r1-d2d_nr_r31;
array d2d_tot_r[31] 8. d2d_tot_r1-d2d_tot_r31;

array d2n_st[234] $1. d2n_st1-d2n_st234;
array d2n_sl[234] $1. d2n_sl1-d2n_sl234;
array d2n_dir[234] $6. d2n_dir1-d2n_dir234;
array d2n_nr_r[234] 8. d2n_nr_r1-d2n_nr_r234;
array d2n_tot_r[234] 8. d2n_tot_r1-d2n_tot_r234;

do i = 1 to 4;
	if i = 1 then do;
		kStart[i] = 'A';
		kSlut[i] = substr(kode,i,1);
	end;
	else do;
		kStart[i] = substr(kode,i-1,1);
		kSlut[i] = substr(kode,i,1);
	end;
end;

/*look up start and slut combinations in */

level = 0;


do i = 1 to 1; /*1-4, start with 3 - has several possible*/

sublevel = 0;
		level+1;

	do j = 1 to 234;
		if kStart[i] = d2n_st[j] and kslut[i] = d2n_sl[j] then do;

			sublevel+1;
			if i = 1 then do; 

					put "dir_ok: " d2n_dir[j];
					put "Sublevel: " Sublevel;

					grid{sublevel,level} = d2n_dir[j];

			end;
			else do;

			end;


		end;

	end;
end;


run;

data pr_grid(drop=v vand keep= v: );
set arr01;

%skriv_array(navn=grid, type=$100.,a=10,b=10 ,at=gri , bt=d);

%macro pr;


%do b = 1 %to &lod_ant.;
%do a = 1 %to &vand_ant.;

v%eval(&a.) = grid{&b.,&a.};
*if v%eval(&a.) = -8 then v%eval(&a.)= .;


%end;
output;
%end;

%mend;
%pr;


run;
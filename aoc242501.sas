data ct01(drop=lang len);
length ft $&maxlen..;
retain tal;
set ct;

nr=_N_;
if _N_=1 then tal=1;
else if ft='' then tal+1;

if ft = '' then delete;

run;

proc sort;by tal nr;run;

data ct02(drop=i);
set ct01;
by tal nr;
retain type;

array h[5] 8. h1-h5;

if first.tal then do;
if ft="#####" then type='L';
if ft="....." then type='K';
end;

do i=1 to 5;

if type = 'L' then do;

if substr(ft,i,1) = '#' then h[i]=1;
else h[i]=0;

end;
if type = 'K' then do;

if substr(ft,i,1) = '#' then h[i]=1;
else h[i]=0;

end;

end;

if first.tal and type='L' then delete;
if last.tal and type='K' then delete;

run;

proc sql;
create table ct03 as select
tal
,type
,sum(h1) as h1
,sum(h2) as h2
,sum(h3) as h3
,sum(h4) as h4
,sum(h5) as h5

from ct02 
group by tal, type;

quit;


data lock key;
set ct03;
if type = 'L' then output lock;
else output key;
run;

proc sql;
create table tjek as select
a.tal as key
,b.tal as lock

,case when sum(a.h1,b.h1) < 6 then 1 else 0 end as tj1
,case when sum(a.h2,b.h2) < 6 then 1 else 0 end as tj2
,case when sum(a.h3,b.h3) < 6 then 1 else 0 end as tj3
,case when sum(a.h4,b.h4) < 6 then 1 else 0 end as tj4
,case when sum(a.h5,b.h5) < 6 then 1 else 0 end as tj5

,case when (
calculated tj1 + calculated tj2 + calculated tj3 + calculated tj4 + calculated tj5) = 5 then 1 else 0
end as saml_tjek 


from key a
join lock b
on 1=1
;
quit;

proc sql;
create table Part1 as
select sum(saml_tjek) as Part1
from tjek;
quit;

/*
proc sort data=key out=key_sort;by tal descending nr;run;

data key_sort01;
set key_sort;

ft = tranwrd(ft,'.','|');
ft = tranwrd(ft,'#','=');

ft = tranwrd(ft,'|','#');
ft = tranwrd(ft,'=','.');

ft = reverse(ft);

run;
*/

data ct;
  infile datalines truncover;
  input  ft $20000.;
	
	retain lang 0;	

  	len = length(strip(ft));
	
	if len > lang then lang = len;

	call symput('antobs',strip(put(_N_,8.)));
	call symput('maxlen',strip(put(lang,8.)));

  datalines;
.....
.....
...#.
...#.
...##
.#.##
#####

.....
..#.#
..#.#
#.#.#
#.#.#
#####
#####

#####
#####
#.###
#.#.#
..#.#
.....
.....

#####
####.
####.
####.
.###.
.#.#.
.....

.....
.#...
###..
###.#
###.#
###.#
#####

.....
.....
.....
.#...
.##..
####.
#####

.....
..#.#
#.#.#
#.#.#
###.#
###.#
#####

#####
#####
#####
####.
.##..
..#..
.....

.....
.....
.....
#.#.#
#####
#####
#####

.....
.....
#..#.
#.###
#.###
#####
#####

#####
####.
####.
.#.#.
.....
.....
.....

.....
....#
..#.#
#.###
#.###
#####
#####

.....
.....
.#.#.
.#.##
.#.##
##.##
#####

#####
#####
####.
#.##.
#.#..
#....
.....

.....
..#..
#.#..
#.#.#
#.###
#####
#####

#####
####.
####.
#.##.
#.#..
..#..
.....

.....
.....
....#
....#
#.#.#
#.#.#
#####

.....
#...#
##..#
##.##
##.##
#####
#####

.....
.....
.#...
##...
###.#
###.#
#####

.....
.....
.....
.....
.#..#
##.##
#####

#####
#####
###.#
#.#.#
#.#..
#.#..
.....

.....
.#...
.#...
##...
##.#.
##.#.
#####

.....
.....
.#...
.#.#.
.#.##
##.##
#####

.....
.....
..#..
..#..
#.##.
####.
#####

#####
#####
#####
#####
##.##
#..#.
.....

#####
####.
.###.
..##.
...#.
.....
.....

#####
#####
#####
#####
#.#.#
#....
.....

.....
..#.#
..#.#
..#.#
.####
#####
#####

#####
##.##
.#.##
.#.##
.#..#
....#
.....

#####
.####
.####
..###
..###
..#.#
.....

.....
...#.
.#.#.
.#.#.
##.##
#####
#####

.....
....#
...##
..###
#.###
#####
#####

.....
.....
#....
#..#.
#..#.
##.##
#####

.....
#....
#...#
##.##
##.##
##.##
#####

.....
#.#..
#.#.#
#.###
#.###
#####
#####

.....
.....
#..#.
##.#.
##.##
##.##
#####

#####
#####
##.##
.#.##
.#.##
.#..#
.....

.....
..#..
#.#..
#.##.
#.##.
####.
#####

#####
###.#
###.#
#.#.#
....#
.....
.....

.....
.....
.....
#....
#.#.#
#.###
#####

.....
.#...
.#..#
.#.##
.####
.####
#####

#####
#.#.#
#.#.#
#...#
#...#
....#
.....

#####
#.###
#.##.
..##.
..##.
..#..
.....

.....
..#..
..#..
#.##.
#.##.
####.
#####

.....
.....
.....
..#..
..#..
.##.#
#####

#####
#####
#.###
..#.#
..#.#
..#.#
.....

#####
#.###
..#.#
..#.#
..#..
..#..
.....

#####
##.##
##..#
##..#
#...#
.....
.....

#####
###.#
###.#
###..
##...
#....
.....

.....
.....
.#..#
.#..#
.##.#
#####
#####

.....
#....
#.#.#
#####
#####
#####
#####

#####
#####
#.##.
...#.
...#.
.....
.....

.....
...#.
#..#.
#..#.
##.#.
#####
#####

#####
##.##
##.##
##.##
#..#.
.....
.....

.....
#..#.
#..#.
##.##
#####
#####
#####

#####
###.#
.##.#
.##.#
..#.#
....#
.....

.....
.....
.....
....#
#.#.#
#.#.#
#####

.....
#....
#..#.
##.#.
#####
#####
#####

#####
#.###
#.#.#
#.#.#
#...#
....#
.....

.....
#.#.#
###.#
###.#
#####
#####
#####

.....
#..#.
#.##.
#.###
#.###
#####
#####

#####
#####
#.##.
..#..
..#..
.....
.....

#####
#.###
...#.
...#.
...#.
...#.
.....

.....
#.#.#
#.#.#
#.#.#
#.#.#
#.###
#####

.....
....#
....#
.#.##
.#.##
##.##
#####

.....
.....
.....
.#...
.##.#
.##.#
#####

#####
.#.##
...##
...#.
...#.
...#.
.....

.....
#...#
#.#.#
#####
#####
#####
#####

.....
.....
.....
.....
.#..#
###.#
#####

.....
.....
.#..#
.#..#
.##.#
###.#
#####

#####
#####
##.##
#..##
#..#.
.....
.....

#####
##.##
##.##
##.##
##.#.
.#...
.....

#####
##.##
##.##
##.##
.#.#.
.....
.....

#####
##.##
#..##
...##
....#
.....
.....

#####
###.#
###.#
#.#.#
#.#..
..#..
.....

.....
.....
#....
#.#.#
#.#.#
#####
#####

.....
...#.
.#.#.
.#.##
.#.##
.#.##
#####

.....
.....
...#.
...#.
.#.##
.####
#####

#####
.#.#.
.#.#.
.#.#.
.#.#.
.....
.....

.....
#.#..
#.#..
#.#..
#.##.
####.
#####

#####
.####
.####
..###
..##.
...#.
.....

.....
#....
#....
#....
#.#.#
###.#
#####

.....
..#..
..#..
.##..
.##.#
#####
#####

#####
#####
#####
#####
.###.
.#.#.
.....

#####
#####
#####
##.#.
.#.#.
.#...
.....

#####
#####
###.#
###.#
.#...
.#...
.....

#####
#####
####.
#.#..
#.#..
..#..
.....

#####
.###.
.###.
.#.#.
.....
.....
.....

.....
.....
#...#
#...#
#...#
#.#.#
#####

.....
.#.#.
.###.
####.
####.
####.
#####

#####
###.#
.##.#
.##.#
.#..#
.....
.....

#####
#####
####.
##.#.
#..#.
#..#.
.....

.....
...#.
.#.##
.####
.####
#####
#####

.....
.....
..#..
#.#..
###..
####.
#####

#####
#####
#####
.####
..#.#
..#.#
.....

#####
#####
#.###
#..##
#...#
#...#
.....

#####
#####
#.##.
#.##.
#..#.
#..#.
.....

.....
.....
..#..
..#..
#.#..
#.##.
#####

#####
#####
###.#
###.#
.#..#
.#..#
.....

#####
###.#
###.#
.##..
..#..
.....
.....

.....
.....
.#..#
.#..#
##..#
###.#
#####

#####
##.##
##.#.
#..#.
#....
#....
.....

#####
####.
####.
###..
#.#..
#.#..
.....

#####
#####
.####
.###.
.###.
.#.#.
.....

#####
#.#.#
#.#.#
..#.#
.....
.....
.....

.....
.....
.....
#.#.#
###.#
#####
#####

.....
.#...
.#...
##.#.
####.
#####
#####

#####
####.
.##..
.#...
.#...
.....
.....

#####
#####
#####
##.##
##.##
.#.#.
.....

.....
...#.
...#.
..##.
.###.
.###.
#####

.....
....#
#.#.#
#.#.#
#.#.#
#.#.#
#####

.....
..#..
..##.
#.##.
#.###
#####
#####

#####
#####
#####
#####
#.##.
#.#..
.....

#####
#####
##.#.
.#.#.
...#.
...#.
.....

#####
#.###
#.###
#.#.#
#.#..
..#..
.....

.....
.....
.....
...#.
#.##.
#####
#####

#####
#####
##.##
.#.##
...##
....#
.....

.....
#.#..
###..
###..
####.
####.
#####

.....
.....
...#.
...##
..###
.####
#####

#####
.###.
.###.
.###.
.#.#.
.....
.....

#####
#####
####.
#.##.
#.##.
#..#.
.....

.....
.....
.....
.....
#.#..
####.
#####

.....
.....
....#
#..##
#..##
##.##
#####

.....
.....
#..#.
#..#.
#..##
#.###
#####

#####
#####
##.##
##.#.
##.#.
#....
.....

.....
#...#
#...#
##.##
##.##
##.##
#####

#####
#####
####.
#.##.
#..#.
#..#.
.....

#####
.####
.#.##
...##
...#.
...#.
.....

#####
##.##
##.#.
##.#.
.#...
.#...
.....

#####
#####
##.##
#..#.
.....
.....
.....

#####
#####
#.###
#.###
#..##
....#
.....

#####
###.#
##...
##...
##...
.#...
.....

#####
#####
#####
#.#.#
#.#..
#....
.....

#####
#.##.
#.#..
..#..
..#..
.....
.....

#####
###.#
###.#
#.#.#
#.#.#
..#..
.....

.....
..#..
..#.#
..###
#.###
#.###
#####

.....
..#.#
..#.#
#.#.#
#.#.#
###.#
#####

#####
#####
#.###
#.###
#..#.
#..#.
.....

#####
#.###
#.###
..###
..#.#
....#
.....

.....
.....
..#..
.##.#
.##.#
#####
#####

#####
#####
#.###
..##.
...#.
...#.
.....

.....
.....
.....
#.#..
#.#..
#.#.#
#####

.....
.....
#....
##...
##...
##.#.
#####

#####
.####
.####
.##.#
.##.#
..#.#
.....

#####
.#.##
.#.##
.#.##
....#
....#
.....

.....
.....
#....
#....
#.#.#
#.###
#####

.....
.....
.....
.....
#.#.#
#.###
#####

#####
#####
####.
#.##.
...#.
.....
.....

.....
.#..#
.#.##
##.##
##.##
##.##
#####

.....
.....
.....
.#..#
.#..#
.##.#
#####

.....
...#.
...##
..###
#.###
#####
#####

#####
#####
###.#
##..#
#....
#....
.....

.....
.....
.....
..#..
#.#.#
#.#.#
#####

.....
..#..
..#..
..#..
..#.#
#.###
#####

#####
#####
.####
..###
...#.
...#.
.....

.....
#....
#.#..
#.#..
#.#.#
#.#.#
#####

#####
.#.##
.#.##
.#.#.
.#.#.
.#.#.
.....

#####
.####
.####
.####
.#.#.
.....
.....

.....
.....
.....
....#
.#.##
.####
#####

#####
#.###
#..##
#..##
#..#.
...#.
.....

#####
.####
..##.
..##.
..#..
..#..
.....

.....
...#.
...##
..###
..###
.####
#####

.....
.....
....#
....#
.#.##
.####
#####

#####
###.#
###..
.##..
.##..
..#..
.....

#####
#####
#####
#.#.#
..#..
.....
.....

#####
#.###
#.###
#.#.#
#.#.#
....#
.....

.....
.....
#....
##..#
###.#
###.#
#####

.....
.....
.....
.....
..#..
#.#.#
#####

.....
.....
#.#..
#.#.#
#.###
#.###
#####

#####
###.#
.#..#
.#..#
.....
.....
.....

.....
.....
....#
..#.#
..#.#
.####
#####

.....
....#
#..##
#..##
##.##
#####
#####

.....
...#.
...#.
.#.#.
.#.#.
.#.##
#####

.....
..#..
.##..
###..
####.
####.
#####

.....
.....
...#.
...#.
.#.#.
.####
#####

#####
#####
#####
##.##
.#.##
.#.#.
.....

#####
#####
#.##.
#.#..
#....
#....
.....

#####
####.
##.#.
##.#.
##.#.
#....
.....

#####
####.
.#.#.
.#.#.
...#.
.....
.....

#####
#.###
#.###
#.#.#
#.#.#
#.#.#
.....

#####
####.
###..
.#...
.#...
.....
.....

.....
.#...
.#.#.
.#.##
.####
#####
#####

.....
.#..#
.#..#
.#..#
##.##
#####
#####

#####
####.
#.##.
#.##.
..##.
...#.
.....

#####
#####
##.##
##..#
.#..#
....#
.....

.....
...#.
...#.
.#.#.
.###.
.###.
#####

#####
#####
##.##
.#..#
.#..#
.#...
.....

#####
#.###
#..##
#..#.
#..#.
...#.
.....

.....
.....
.....
...#.
..##.
.###.
#####

#####
#####
#####
#.#.#
..#.#
....#
.....

#####
###.#
##...
##...
#....
#....
.....

#####
#####
####.
.###.
.#.#.
...#.
.....

#####
#####
##.##
.#.##
.#.##
....#
.....

#####
.####
.###.
..#..
..#..
.....
.....

.....
...#.
..###
..###
..###
.####
#####

#####
#####
###.#
##..#
#...#
.....
.....

#####
###.#
###.#
###.#
###.#
.#..#
.....

.....
....#
.#..#
.##.#
###.#
###.#
#####

.....
..#..
..#..
..#..
#.#.#
#.###
#####

.....
.....
.....
....#
#.#.#
#.###
#####

.....
.....
.#...
.#...
.##..
###.#
#####

.....
.....
#..#.
##.##
##.##
#####
#####

#####
#####
.###.
.#.#.
.#.#.
.....
.....

.....
.....
..#..
..#.#
.##.#
.####
#####

#####
####.
###..
.##..
..#..
..#..
.....

.....
...#.
.#.#.
##.#.
##.##
#####
#####

.....
...#.
.#.#.
.#.##
.#.##
.####
#####

#####
.####
.##.#
.#..#
.#..#
.....
.....

#####
#####
####.
.#.#.
.#.#.
...#.
.....

#####
###.#
###.#
###.#
.#..#
.#..#
.....

.....
....#
....#
.#..#
###.#
#####
#####

.....
..#..
..#..
.###.
.###.
.####
#####

#####
#####
##.##
#...#
#...#
#....
.....

.....
...#.
...#.
...#.
..##.
#.##.
#####

#####
#.#.#
#...#
#...#
....#
.....
.....

.....
...#.
...#.
..##.
.####
.####
#####

.....
.....
.#...
.#.#.
.#.##
.####
#####

#####
##.##
##..#
.#..#
.#..#
....#
.....

#####
##.##
##..#
.#...
.#...
.....
.....

#####
###.#
###.#
###.#
#.#.#
#....
.....

.....
.....
..#..
#.#..
####.
####.
#####

#####
#####
##.##
##.##
#..#.
...#.
.....

#####
#####
.###.
..##.
..#..
.....
.....

.....
.#..#
.#..#
.#..#
.##.#
#####
#####

#####
#####
###.#
##..#
#....
.....
.....

.....
.....
..#.#
.##.#
#####
#####
#####

.....
..#..
.##..
###.#
###.#
###.#
#####

.....
.#...
.#...
.##.#
###.#
###.#
#####

#####
###.#
#.#.#
#.#..
#.#..
..#..
.....

.....
.....
.....
.....
.#.#.
.####
#####

.....
..#..
..##.
.###.
.###.
#####
#####

#####
#####
#####
#.###
#.#.#
#.#..
.....

.....
.#...
##.#.
####.
#####
#####
#####

.....
#....
##.#.
##.#.
##.#.
####.
#####

.....
..#..
..#..
..##.
.###.
.###.
#####

#####
##.##
##.##
#..##
#...#
#...#
.....

#####
#####
#.#.#
#.#..
#....
.....
.....

#####
.#.#.
.#.#.
.#.#.
...#.
...#.
.....

.....
...#.
...#.
#..#.
#.###
#.###
#####

#####
##.##
.#.#.
...#.
...#.
...#.
.....

.....
....#
#.#.#
###.#
###.#
#####
#####

#####
.#.##
.#..#
....#
....#
.....
.....

.....
#....
#....
##..#
##..#
###.#
#####

.....
.....
#....
#..#.
#..#.
##.#.
#####

#####
#####
#.###
#..#.
...#.
.....
.....

.....
....#
....#
...##
...##
.#.##
#####

.....
.#...
.#...
.#...
.#.#.
.#.#.
#####

#####
###.#
###..
.#...
.#...
.....
.....

#####
#.###
#.##.
#.##.
..##.
..#..
.....

.....
.....
.....
...#.
.#.##
#####
#####

#####
#####
#####
###.#
.#..#
.....
.....

#####
#####
#.#.#
#.#..
#.#..
.....
.....

.....
.....
...#.
#..#.
#.##.
#.##.
#####

#####
##.##
.#..#
.#...
.#...
.....
.....

#####
#.#.#
#....
.....
.....
.....
.....

#####
#####
#.##.
#.##.
#..#.
.....
.....

.....
.#...
.#...
###..
###..
###.#
#####

.....
.#...
.#...
.#.#.
.#.#.
##.#.
#####

.....
.#...
.#..#
.#..#
##..#
##.##
#####

.....
.#...
.#..#
.#..#
.##.#
#####
#####

#####
.#.#.
.#.#.
.#...
.#...
.....
.....

.....
.....
.....
.#..#
.##.#
.##.#
#####

#####
####.
.#.#.
.#.#.
.#.#.
.#...
.....

#####
#.###
..#.#
....#
.....
.....
.....

#####
####.
###..
###..
.#...
.....
.....

#####
###.#
#.#.#
..#.#
..#..
..#..
.....

.....
.#...
.#.#.
.#.#.
.#.#.
####.
#####

#####
####.
#.##.
..##.
..##.
...#.
.....

.....
#...#
#..##
#.###
#.###
#####
#####

#####
##.##
##.##
##.##
##.#.
.#.#.
.....

#####
.####
.###.
.##..
.#...
.#...
.....

#####
###.#
##...
##...
##...
#....
.....

.....
...#.
..##.
..###
..###
#.###
#####

.....
.#.#.
.#.#.
.###.
####.
#####
#####

.....
.....
...#.
..##.
.###.
####.
#####

.....
#...#
##..#
##..#
##.##
##.##
#####

.....
.#...
.##..
.##..
.##.#
#####
#####

.....
...#.
.#.#.
##.#.
#####
#####
#####

#####
#####
#####
###.#
#.#..
#....
.....

#####
#.###
#.###
#.###
..#.#
.....
.....

.....
.#..#
.#..#
##..#
##..#
###.#
#####

.....
.....
..#..
..#.#
..###
.####
#####

#####
###.#
###.#
###.#
.#...
.#...
.....

.....
.....
.....
.#.#.
##.#.
#####
#####

.....
.....
...#.
.#.#.
####.
####.
#####

#####
.###.
.##..
.##..
.#...
.#...
.....

.....
.....
..#..
#.##.
#####
#####
#####

#####
##.##
.#.##
.#.#.
.#...
.#...
.....

#####
#####
.####
.##.#
.##..
..#..
.....

.....
#....
#.#.#
###.#
###.#
#####
#####

#####
##.##
##.#.
.#...
.#...
.....
.....

#####
##.##
##.#.
.#.#.
.#.#.
.....
.....

#####
#####
###.#
##..#
.#...
.....
.....

#####
####.
.###.
.###.
..#..
.....
.....

#####
#.###
..#.#
..#..
.....
.....
.....

#####
###.#
###.#
#.#.#
..#..
.....
.....

.....
#...#
#...#
#..##
#.###
#.###
#####

#####
#.###
#.##.
#.#..
#.#..
..#..
.....

.....
.#...
##...
##..#
##.##
##.##
#####

.....
#....
#..#.
#.##.
#.##.
#.###
#####

#####
#####
#####
#####
#.##.
#..#.
.....

.....
.....
....#
#.#.#
###.#
###.#
#####

.....
.....
....#
..#.#
.##.#
.####
#####

#####
#####
#####
.###.
.#.#.
.....
.....

#####
##.#.
##.#.
##...
#....
#....
.....

.....
.#.#.
.###.
.####
.####
.####
#####

#####
#####
###.#
#.#.#
.....
.....
.....

.....
.....
#....
##..#
##.##
#####
#####

#####
###.#
.##.#
..#..
.....
.....
.....

.....
....#
#...#
##..#
##.##
#####
#####

.....
..#.#
#.#.#
###.#
###.#
###.#
#####

#####
.#.##
.#.##
.#.##
.#.##
.#..#
.....

#####
####.
####.
.#.#.
.#...
.....
.....

.....
.....
..#..
#.#.#
###.#
###.#
#####

.....
..#..
..#..
.##..
.###.
.###.
#####

.....
.#...
.##..
.##.#
.##.#
.##.#
#####

#####
.####
.####
.#.##
.#.##
.#..#
.....

.....
.....
.#..#
.#.##
##.##
#####
#####

#####
.###.
.#.#.
...#.
.....
.....
.....

.....
....#
..#.#
..###
.####
.####
#####

.....
.....
.#...
.#.#.
##.##
#####
#####

#####
###.#
###.#
#.#.#
....#
....#
.....

.....
.....
.....
#....
##...
##.#.
#####

.....
....#
....#
#.#.#
#.###
#.###
#####

.....
....#
#..##
#..##
#.###
#.###
#####

#####
#####
###.#
##..#
##..#
#....
.....

.....
#....
#..#.
#..#.
#.##.
#####
#####

#####
#####
#####
#####
##.#.
.#...
.....

.....
#....
##.#.
#####
#####
#####
#####

.....
.....
..#..
..#..
#.#.#
#####
#####

#####
###.#
###.#
#.#.#
#...#
#....
.....

#####
.####
.#.##
...#.
...#.
.....
.....

.....
.#...
.#...
.#...
.#...
###.#
#####

#####
##.#.
##.#.
.#.#.
.#.#.
.....
.....

.....
...#.
..##.
..##.
#.###
#.###
#####

#####
##.##
#..##
#..##
#...#
#...#
.....

#####
#####
#####
##.##
#..##
#...#
.....

.....
.....
...#.
..##.
.###.
.####
#####

.....
.....
#..#.
#..#.
##.#.
##.##
#####

.....
.#...
.#...
##.#.
##.#.
##.#.
#####

#####
#####
#####
####.
.#.#.
.#...
.....

.....
.....
..#..
..#..
.##..
.###.
#####

.....
.....
#.#..
#.##.
#####
#####
#####

.....
.....
...#.
..##.
#.###
#.###
#####

.....
.#...
.#...
.#..#
##..#
##.##
#####

#####
#####
###.#
###..
###..
#.#..
.....

.....
#.#..
###.#
###.#
###.#
###.#
#####

#####
.####
.#.#.
...#.
.....
.....
.....

#####
####.
####.
.##..
.##..
..#..
.....

#####
.####
..##.
..#..
..#..
.....
.....

.....
...#.
...#.
#..#.
#.##.
#####
#####

.....
.#..#
.#..#
.#.##
.#.##
##.##
#####

.....
#.#..
#.#.#
#.#.#
#.#.#
#.#.#
#####

.....
.#...
.#...
##...
##.#.
#####
#####

#####
###.#
##..#
##..#
#...#
#...#
.....

.....
.#...
.#...
##..#
###.#
###.#
#####

#####
####.
#.##.
#..#.
...#.
.....
.....

.....
#.#..
#.#..
#.#..
#.#..
####.
#####

#####
####.
####.
##.#.
##.#.
#....
.....

.....
..#..
..#..
.##..
.###.
.####
#####

#####
#####
####.
.#.#.
.....
.....
.....

.....
....#
#...#
#...#
#.#.#
#####
#####

.....
....#
#...#
##..#
###.#
###.#
#####

.....
.....
.....
#..#.
#.##.
#####
#####

.....
.#.#.
##.#.
##.##
#####
#####
#####

.....
..#..
..#.#
.##.#
.####
#####
#####

#####
###.#
###.#
###.#
#.#.#
..#.#
.....

#####
.####
.####
.####
.##.#
..#..
.....

.....
.....
#...#
#...#
#.#.#
###.#
#####

.....
#.#..
###.#
###.#
###.#
#####
#####

.....
.#.#.
.#.##
#####
#####
#####
#####

.....
.#...
.#.#.
##.#.
##.##
##.##
#####

#####
#####
#####
#####
#.#.#
.....
.....

.....
.....
...#.
...#.
..###
#.###
#####

.....
#....
#.#..
#.#..
#.#.#
#.###
#####

.....
.....
.....
#....
#.#.#
#####
#####

#####
#####
.#.##
.#.##
.#.#.
.#.#.
.....

.....
....#
#..##
#..##
##.##
##.##
#####

.....
...#.
...#.
...#.
.#.#.
##.##
#####

#####
####.
.##..
..#..
..#..
.....
.....

#####
.####
.##.#
.##.#
.##..
.#...
.....

#####
.#.##
...#.
...#.
...#.
...#.
.....

#####
#####
#####
.####
.#.#.
.#.#.
.....

#####
##.##
##.##
##.#.
##...
#....
.....

.....
...#.
.#.#.
.###.
.###.
.####
#####

#####
#####
####.
####.
.#.#.
...#.
.....

.....
.#...
##.#.
####.
####.
#####
#####

.....
....#
....#
#...#
#...#
#.#.#
#####

.....
#....
#.#..
#.#..
###.#
###.#
#####

#####
#####
##.##
##..#
#...#
#...#
.....

#####
#####
#.###
#..#.
...#.
...#.
.....

.....
...#.
...#.
#..#.
##.##
#####
#####

#####
.####
.####
..#.#
.....
.....
.....

#####
#.###
#.###
..#.#
.....
.....
.....

#####
#####
.##.#
.##..
..#..
.....
.....

.....
...#.
...#.
...#.
#.##.
####.
#####

#####
#####
##.##
.#.##
.#.##
.#.#.
.....

#####
#.###
#.##.
#.##.
#..#.
#....
.....

#####
####.
####.
####.
.##..
.#...
.....

.....
.#.#.
.#.#.
.###.
####.
####.
#####

#####
.##.#
.#..#
.#..#
.#...
.....
.....

#####
.#.##
....#
....#
.....
.....
.....

#####
#.###
#.###
#.###
#.###
#..#.
.....

#####
##.##
.#.##
.#..#
.#..#
.....
.....

.....
....#
...##
#.###
#####
#####
#####

#####
#.#.#
....#
....#
....#
....#
.....

#####
##.#.
##.#.
##...
#....
.....
.....

#####
#####
###.#
###.#
##..#
#...#
.....

.....
.....
.#..#
.#..#
.#..#
.##.#
#####

.....
.#...
##.#.
##.#.
##.#.
##.#.
#####

#####
#####
#.###
#.##.
#.#..
#.#..
.....

#####
#####
##.#.
.#...
.#...
.....
.....

.....
#.#..
#.##.
####.
####.
####.
#####

#####
#.#.#
#...#
#...#
#....
#....
.....

#####
#####
#####
.#.#.
.#.#.
.....
.....

#####
####.
#.##.
#.##.
#..#.
.....
.....

#####
###.#
###..
#.#..
#....
.....
.....

#####
#####
####.
###..
#.#..
#.#..
.....

.....
.....
.#.#.
.###.
####.
#####
#####

.....
#....
#....
#.#..
#.##.
#.##.
#####

#####
.####
.##.#
..#.#
..#.#
....#
.....

#####
#####
#.#.#
#...#
#....
#....
.....

.....
.....
....#
.#..#
.##.#
.##.#
#####

.....
.....
.....
.#...
.#.#.
.#.#.
#####

.....
.....
.#...
.##..
.##..
.###.
#####

#####
###.#
#.#.#
#...#
#...#
#...#
.....

.....
.....
....#
.#..#
.#.##
##.##
#####

.....
...#.
...#.
.#.#.
.#.#.
##.##
#####

.....
.....
.....
.#.#.
.#.#.
##.##
#####

#####
#.###
#..##
...##
...##
...#.
.....

.....
...#.
...#.
..##.
.####
#####
#####

#####
####.
####.
#.##.
#..#.
#..#.
.....

.....
...#.
...#.
.#.#.
.#.##
.#.##
#####

#####
#####
#.###
#.###
#..##
#..#.
.....

.....
..#..
#.##.
#.###
#.###
#####
#####

#####
.##.#
..#.#
.....
.....
.....
.....

#####
#.###
#.###
#.##.
...#.
...#.
.....

#####
#####
##.##
.#..#
.#...
.....
.....

#####
##.##
#..##
...##
...#.
...#.
.....

.....
.....
.....
....#
#...#
##.##
#####

#####
####.
.###.
..#..
..#..
.....
.....

.....
..#..
#.##.
#.###
#.###
#.###
#####

#####
#.##.
#.##.
#.##.
#..#.
#....
.....

.....
.....
.#.#.
.###.
.###.
.####
#####

#####
####.
#.#..
#.#..
.....
.....
.....

.....
....#
..#.#
..#.#
..#.#
.##.#
#####

.....
.....
.....
.#...
.#.#.
.####
#####

#####
#.##.
#.##.
#.##.
..#..
..#..
.....

#####
#####
#####
#####
.#.##
.#..#
.....

.....
....#
....#
...##
.#.##
.#.##
#####

.....
.....
.#...
.##.#
#####
#####
#####

#####
#####
#.#.#
....#
....#
.....
.....

#####
#####
#####
###.#
.#..#
.#...
.....

#####
###.#
##..#
##..#
.#...
.....
.....

.....
....#
....#
....#
...##
#.###
#####

#####
##.#.
.#.#.
.....
.....
.....
.....

#####
#####
.##.#
.#..#
.#..#
.#...
.....

.....
...#.
...#.
.#.#.
#####
#####
#####

.....
.....
...#.
#.##.
#.##.
#.###
#####

#####
#.###
#.#.#
....#
.....
.....
.....

.....
...#.
...#.
.#.##
.####
#####
#####

#####
##.##
.#..#
.#...
.#...
.#...
.....

#####
#####
#####
####.
#.#..
.....
.....

#####
#####
.##.#
.##.#
..#..
..#..
.....

.....
#..#.
#.##.
#.##.
#####
#####
#####

.....
..#..
#.##.
#.##.
#.##.
#####
#####

.....
.#...
.#...
.#..#
.#.##
.#.##
#####

#####
.####
.###.
..#..
..#..
..#..
.....

.....
....#
#.#.#
#####
#####
#####
#####

#####
.#.##
...##
...##
....#
.....
.....

#####
.####
.##.#
.##.#
..#.#
..#..
.....

#####
#####
###.#
.#...
.#...
.....
.....

#####
##.##
.#.#.
.#.#.
.#...
.....
.....

#####
#####
#####
###.#
#.#.#
.....
.....

.....
.....
#....
#....
#..#.
##.##
#####

.....
#....
#...#
#.#.#
#####
#####
#####

#####
.#.##
...#.
...#.
.....
.....
.....

#####
.####
.####
.####
.####
.#.#.
.....

#####
#####
.####
.####
.#.#.
.....
.....

#####
#####
#.#.#
#.#..
#.#..
#....
.....

#####
###.#
#.#.#
#....
#....
.....
.....

.....
...#.
.#.#.
.#.#.
####.
#####
#####

#####
#.###
..###
..#.#
..#.#
..#.#
.....

#####
#####
#####
#.#.#
#.#.#
.....
.....

#####
#.###
#.###
..##.
..#..
..#..
.....

.....
.....
.#.#.
.#.#.
##.#.
#####
#####

.....
...#.
#..##
#..##
#..##
##.##
#####

#####
#####
##.##
.#..#
.....
.....
.....

.....
....#
....#
#.#.#
#.###
#####
#####

.....
.#...
.#..#
###.#
###.#
#####
#####

.....
#...#
#...#
##.##
##.##
#####
#####

.....
.#..#
.#.##
.#.##
#####
#####
#####

.....
..#..
..#.#
#.###
#####
#####
#####

#####
.####
.#.##
.#.##
.#.#.
.#.#.
.....

.....
.....
.....
.....
#....
#.#.#
#####

.....
.....
..#..
..#.#
.##.#
###.#
#####

.....
#.#..
####.
####.
####.
#####
#####

.....
.....
..#..
#.#..
#.##.
#.###
#####

.....
#....
#....
#....
#.#..
#.#.#
#####

#####
.##.#
.##.#
.##.#
.#..#
.....
.....
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
#####
.####
.####
.####
.#.#.
.#...
.....

#####
##.##
.#.##
...##
...#.
...#.
.....

.....
#....
#....
#...#
#.#.#
#.###
#####

.....
.....
#.#..
###..
###.#
###.#
#####

.....
.....
.....
#....
#.#..
#.#.#
#####
;

run;
*/
%let ekstra_lod = 6;
%let ekstra_vand = 6;

%let lod_ant = %sysfunc(sum(%eval(&antobs.),%eval(&ekstra_lod)));
%let vand_ant = %sysfunc(sum(%eval(&maxlen.),%eval(&ekstra_vand)));
%put &=lod_ant.;
%put &=vand_ant.;


data ekstra(keep=x rename=(x=ft));
length x $&vand_ant..;
set ct;
x = 'LLL'||strip(ft)||'RRR';
run;

data top(drop=i);
length ft $&vand_ant..;
ft = repeat('T',%eval(&vand_ant.));

do i = 1 to 3;
output;
end;

run;

data bund(drop=i);
length ft $&vand_ant..;
ft = repeat('B',%eval(&vand_ant.));

do i = 1 to 3;
output;
end;

run;

data ct01;
set 
top
ekstra
bund;
run;


data ct02(drop=ft);
set ct01 end=eof;
retain %skriv_array_var(a=&lod_ant.,b=&vand_ant. ,at=gri , bt=d);

%skriv_array(navn=grid, type=$1.,a=&lod_ant.,b=&vand_ant. ,at=gri , bt=d);

do i = 1 to &vand_ant.;

grid{_n_,i} = substr(ft,i,1);

end;

if eof;
run;

data Part1(keep=tal rename=(tal=Part1));
set ct02;
%skriv_array(navn=grid, type=$1.,a=&lod_ant.,b=&vand_ant. ,at=gri , bt=d);

tal = 0;
	do lod = 4 to %eval(&LOD_ant.)-3;
		do vand = 4 to %eval(&vand_ant.)-3;

			F = grid{lod,vand};

			if F = 'X' then do;

			str = grid{lod,vand}||grid{lod+1,vand}||grid{lod+2,vand}||grid{lod+3,vand};	if str = 'XMAS' then tal+1;
			str = grid{lod,vand}||grid{lod-1,vand}||grid{lod-2,vand}||grid{lod-3,vand};	if str = 'XMAS' then tal+1;
			str = grid{lod,vand}||grid{lod,vand+1}||grid{lod,vand+2}||grid{lod,vand+3};	if str = 'XMAS' then tal+1;
			str = grid{lod,vand}||grid{lod,vand-1}||grid{lod,vand-2}||grid{lod,vand-3};	if str = 'XMAS' then tal+1;
			str = grid{lod,vand}||grid{lod+1,vand+1}||grid{lod+2,vand+2}||grid{lod+3,vand+3};	if str = 'XMAS' then tal+1;
			str = grid{lod,vand}||grid{lod-1,vand-1}||grid{lod-2,vand-2}||grid{lod-3,vand-3};	if str = 'XMAS' then tal+1;
			str = grid{lod,vand}||grid{lod-1,vand+1}||grid{lod-2,vand+2}||grid{lod-3,vand+3};	if str = 'XMAS' then tal+1;
			str = grid{lod,vand}||grid{lod+1,vand-1}||grid{lod+2,vand-2}||grid{lod+3,vand-3};	if str = 'XMAS' then tal+1;

			end;
		end;
	end;

	put "Part1: " tal;
run;


data Part2(keep=tal rename=(tal=Part2));
set ct02;
%skriv_array(navn=grid, type=$1.,a=&lod_ant.,b=&vand_ant. ,at=gri , bt=d);

tal = 0;
	do lod = 4 to %eval(&LOD_ant.)-3;
		do vand = 4 to %eval(&vand_ant.)-3;

			F = grid{lod,vand};

			if F = 'A' then do;

				if  grid{lod-1,vand-1} in ('M','S') 
				and grid{lod+1,vand-1} in ('M','S') 
				and grid{lod+1,vand+1} in ('M','S') 
				and grid{lod-1,vand+1} in ('M','S') then do;

					if (grid{lod-1,vand-1} ne grid{lod+1,vand+1}) and (grid{lod+1,vand-1} ne grid{lod-1,vand+1}) then tal+1;

				end;
			end;
		end;
	end;

	put "Part2: " tal;
run;


%macro skriv_array(navn=pris, type=,a= ,b= ,at= , bt=);

array &navn.{&a.,&b.} &type 
%do k=1 %to &a.;

&at.&k.&bt.1-&at.&k.&bt.&b.

%end;
;

%mend;

%macro skriv_array_var(a= ,b= ,at= , bt=);

%do k=1 %to &a.;

&at.&k.&bt.1-&at.&k.&bt.&b.

%end;

%mend;


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
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
  ;
  run;
*/
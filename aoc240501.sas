data _null_;
set ct;
if ft = '' then call symput('midt',strip(put(_N_,8.)));
run;

%put &midt.;

data top bund;
set ct;
if _N_ < %eval(&midt.) then output top;
if _N_ > %eval(&midt.) then output bund;
run;


/***************/
/*program_dependencies: PROGRAM, variabel_type, VAERDI*/

/*************/

data top01;
set top;

f_ = input(scan(ft,1,'|'),8.);
s_ = input(scan(ft,2,'|'),8.);


call symput('ant_fs',strip(put(_N_,8.)));
run;
%put &=ant_fs.;

%macro skriv;
%do i = 1 %to &ant_fs.;

f&i. s&i.

%end;
8.
%mend;


data fs_arr(drop=ft lang len f_ s_);
length %skriv;
set top01 end=eof;

%single_array(ant=&ant_fs., navn=f, tp=8);
%single_array(ant=&ant_fs., navn=s, tp=8);

if eof;
run;

data opdate(drop=ft lang len i);
set bund;

ant_com = countc(ft,',')+1;

array tal[23] 8. tal1-tal23;

do i = 1 to ant_com;

tal[i] = input(scan(ft,i,','),8.);

end;

run;

proc sql;
create table opdate_regel as
select A.*, B.*
from opdate A
join fs_arr b
on 1 = 1;
quit;

data opdate_regel01;
length Part1 8.;
set opdate_regel;
retain Part1 0;


array tal[23] 8. tal1-tal23;
%skriv_single_array(ant=&ant_fs., navn=f, tp=8);
%skriv_single_array(ant=&ant_fs., navn=s, tp=8);

regel_ok = 1;
	do ff = 1 to ant_com-1;
		do ss = ff+1 to ant_com;
		
			do r=1 to &ant_fs.;

				if (tal[ff] = f[r] and tal[ss] = s[r]) or (tal[ff] = s[r] and tal[ss] = f[r]) then regel = r;
				
			end;
			if (tal[ff] ne f[regel]) or (tal[ss] ne s[regel]) then regel_ok=0;
		end;
	end;

	if regel_ok = 1 then do;

		Part1 = Part1 + tal[((ant_com-1)/2)+1];

	end;

run;

data opdate_regel02;
length Part2 8.;
set opdate_regel01(where=(regel_ok=0));
retain Part2 0;

array tal[23] 8. tal1-tal23;
%skriv_single_array(ant=&ant_fs., navn=f, tp=8);
%skriv_single_array(ant=&ant_fs., navn=s, tp=8);

put "OBS: " _N_;


	do ff = 1 to ant_com-1;
		do ss = ff+1 to ant_com;
		
			do r=1 to &ant_fs.;

				if (tal[ff] = f[r] and tal[ss] = s[r]) or (tal[ff] = s[r] and tal[ss] = f[r]) then regel = r;
				
			end;
			if (tal[ff] ne f[regel]) or (tal[ss] ne s[regel]) then do;

			f_tal = tal[ff];
			s_tal = tal[ss];
			tal[ff] = s_tal;
			tal[ss] = f_tal;
			


			end;



		end;
	end;

Part2 = Part2 + tal[((ant_com-1)/2)+1];

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

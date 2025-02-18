
data _null_;
set ct;
if len = 1 then call symput('split',strip(put(_N_,8.)));
run;
%put &=split;

data top bund;
set ct;
if _N_ < %eval(&split.) then do;

  	len = length(strip(ft));
	
	if len > lang then lang = len;

	call symput('antobs',strip(put(_N_,8.)));
	call symput('maxlen',strip(put(lang,8.)));

output top;
end;
if _N_ > %eval(&split.) then output bund;
run;

%let ekstra_lod = 0;
%let ekstra_vand = 0;

%let lod_ant = %sysfunc(sum(%eval(&antobs.),%eval(&ekstra_lod)));
%let vand_ant = %sysfunc(sum(%eval(&maxlen.),%eval(&ekstra_vand)));
%put &=lod_ant.;
%put &=vand_ant.;

data ct02(drop=ft i lang len);
set top end=eof;
retain %skriv_array_var(a=&lod_ant.,b=&vand_ant. ,at=gri , bt=d);

%skriv_array(navn=grid, type=$1.,a=&lod_ant.,b=&vand_ant. ,at=gri , bt=d);

do i = 1 to &vand_ant.;

grid{_n_,i} = substr(ft,i,1);
 
end;

if eof;
run;

data _Null_;
set bund end=eof;
retain tot_lang 0;
if _N_ = 1 then tot_lang = lang;
else tot_lang = lang + tot_lang;
call symput('tot_lang',strip(put(tot_lang,8.)));
run;
%put &=tot_lang;

data ct03(keep= dir:);
set bund end=eof;
retain tal dir1-dir%eval(&tot_lang.) ;

array dir[%eval(&tot_lang.)] $1. dir1-dir%eval(&tot_lang.);



do i=1 to lang;

tal+1;
dir[tal] = substr(ft,i,1);

end;


if eof;
run;

proc sql;
create table ct04 as

select 


b.*
,a.*

from ct02 a
join ct03 b
on 1=1; 

quit;

%macro finddldv;

if dir[flyt] = '<' then do;
dl = 0;
dv = -1;
end;
else if dir[flyt] = '^' then do;
dl = -1;
dv = 0;
end;
else if dir[flyt] = '>' then do;
dl = 0;
dv = +1;
end;
else if dir[flyt] = 'v' then do;
dl = +1;
dv = 0;
end;

%mend finddldv;

data Part1(keep=GPS rename=(GPS=Part1));
length GPS ol ov 8.;
set ct04;

%skriv_array(navn=grid, type=$1.,a=&lod_ant.,b=&vand_ant. ,at=gri , bt=d);
array dir[%eval(&tot_lang.)] $1. dir1-dir%eval(&tot_lang.);

/*find orig*/

do lod = 1 to %eval(&LOD_ant.);
	do vand = 1 to %eval(&vand_ant.);
		if grid{lod,vand} = '@' then do;

			ol = lod;
			ov = vand;

		end;
	end;
end;

l = ol;
v = ov;

do flyt=1 to dim(dir);

%finddldv;



if grid{l+dl,v+dv} = '#' then do;

/*put "FLYT IKKE MULIGT: dir[flyt]: " dir[flyt] ", dl: " dl ", dv: " dv;*/

end;

else if grid{l+dl,v+dv} = '.' then do;

grid{l,v} = '.';
grid{l+dl,v+dv} = '@';

/*put "dir[flyt]: " dir[flyt] ", dl: " dl ", dv: " dv;*/

l = l + dl;
v = v + dv;

end;
else if grid{l+dl,v+dv} = 'O' then do;

/*Otal er foerste felt der ikke er O */

Otal = 0;
tegn = 'O';

	do until(tegn ne 'O');

	Otal+1;

	Odl = dl*Otal;
	Odv = dv*Otal;

	tegn = grid{l+Odl,v+Odv};


	end;



	
	if tegn = '.' then do;

		do j = Otal to 0 by -1;

				Odl = dl*j;
				Odv = dv*j;

			if j = 0 then grid{l+Odl,v+Odv} = '.';
			else if j = 1 then grid{l+Odl,v+Odv} = '@';
			else grid{l+Odl,v+Odv} = 'O';

		end;

/*	put "dir[flyt]: " dir[flyt] ", dl: " dl ", dv: " dv "Otal: " Otal ", tegn: " tegn;
*/
		l = l + dl;
		v = v + dv;

	end;
	else do;

/*	put "FLYT IKKE MULIGT dir[flyt]: " dir[flyt] ", dl: " dl ", dv: " dv "Otal: " Otal ", tegn: " tegn;
*/
	end;



end;
end;

/*GPS*/

GPS=0;

do lod = 1 to %eval(&LOD_ant.);
	do vand = 1 to %eval(&vand_ant.);
		if grid{lod,vand} = 'O' then do;

		GPS = ((100 * (lod-1))+(vand-1)) + GPS;

		end;
	end;
end;


run;

data _null_;

vand = %eval(&vand_ant.)*2;
call symput('Dvand_ant',strip(put(vand,8.)));
run;
%put &=Dvand_ant.;

data ct02(drop=ft i lang len);
set top end=eof;
retain %skriv_array_var(a=&lod_ant.,b=&dvand_ant. ,at=gri , bt=d);

%skriv_array(navn=grid, type=$1.,a=&lod_ant.,b=&dvand_ant.,at=gri , bt=d);

do i = 1 to &vand_ant.;

if substr(ft,i,1) = '@' then do;
grid{_n_,((i)*2)-1} = '@';
grid{_n_,((i)*2)} = '.';
end;
else if substr(ft,i,1) = 'O' then do;
grid{_n_,((i)*2)-1} = '[';
grid{_n_,((i)*2)} = ']';
end;
else do;
grid{_n_,((i)*2)-1} = substr(ft,i,1);
grid{_n_,((i)*2)} = substr(ft,i,1);
end; 

end;

if eof;
run;

proc sql;
create table ct04 as

select 


b.*
,a.*

from ct02 a
join ct03 b
on 1=1; 

quit;

%macro byg_tower_op;

			if grid{l+dl,v+dv} = ']' then do;

				tower_ant+1;
				tower[1,tower_ant] = -1;
				tower[2,tower_ant] = -1;
				tower[3,tower_ant] = 0;

			end;
			else if grid{l+dl,v+dv} = '[' then do;

				tower_ant+1;
				tower[1,tower_ant] = -1;
				tower[2,tower_ant] = 0;
				tower[3,tower_ant] = 1;

			end;

			/*her skal der loopes igennem tower, hele tiden kig op, */

		do t=1 to 100;

			if tower{1,t} = . then do;
				leave;
			end;

			if grid{L+dl+tower{1,t},V+dv+tower{2,t}} = ']' and grid{L+dl+tower{1,t},V+dv+tower{3,t}} = '[' then do;
			/*To over*/

				tower_ant+1;
				tower[1,tower_ant] = tower{1,t}-1;
				tower[2,tower_ant] = tower{2,t}-1;
				tower[3,tower_ant] = tower{2,t};
				tower_ant+1;
				tower[1,tower_ant] = tower{1,t}-1;
				tower[2,tower_ant] = tower{2,t}+1;
				tower[3,tower_ant] = tower{2,t}+2;
			end;
			else if grid{L+dl+tower{1,t},V+dv+tower{2,t}} = ']' then do;
			/*kun venstre oevr*/
				tower_ant+1;
				tower[1,tower_ant] = tower{1,t}-1;
				tower[2,tower_ant] = tower{2,t}-1;
				tower[3,tower_ant] = tower{2,t};
			end;
			else if grid{L+dl+tower{1,t},V+dv+tower{3,t}} = '[' then do;
			/*kun hojre over*/

				tower_ant+1;
				tower[1,tower_ant] = tower{1,t}-1;
				tower[2,tower_ant] = tower{2,t}+1;
				tower[3,tower_ant] = tower{2,t}+2;
			end;
			else if grid{L+dl+tower{1,t},V+dv+tower{2,t}} = '[' then do;
			/*en lige over*/

				tower_ant+1;
				tower[1,tower_ant] = tower{1,t}-1;
				tower[2,tower_ant] = tower{2,t};
				tower[3,tower_ant] = tower{2,t}+1;
			end;
		end;

%mend byg_tower_op;


%macro byg_tower_ned;

			if grid{l+dl,v+dv} = ']' then do;

				tower_ant+1;
				tower[1,tower_ant] = 1;
				tower[2,tower_ant] = -1;
				tower[3,tower_ant] = 0;

			end;
			else if grid{l+dl,v+dv} = '[' then do;

				tower_ant+1;
				tower[1,tower_ant] = 1;
				tower[2,tower_ant] = 0;
				tower[3,tower_ant] = 1;

			end;

			/*her skal der loopes igennem tower, hele tiden kig ned, */

		do t=1 to 100;

			if tower{1,t} = . then do;
				leave;
			end;

			if grid{L+dl+tower{1,t},V+dv+tower{2,t}} = ']' and grid{L+dl+tower{1,t},V+dv+tower{3,t}} = '[' then do;
			/*To under*/

				tower_ant+1;
				tower[1,tower_ant] = tower{1,t}+1;
				tower[2,tower_ant] = tower{2,t}-1;
				tower[3,tower_ant] = tower{2,t};
				tower_ant+1;
				tower[1,tower_ant] = tower{1,t}+1;
				tower[2,tower_ant] = tower{2,t}+1;
				tower[3,tower_ant] = tower{2,t}+2;
			end;
			else if grid{L+dl+tower{1,t},V+dv+tower{2,t}} = ']' then do;
			/*kun venstre under*/
				tower_ant+1;
				tower[1,tower_ant] = tower{1,t}+1;
				tower[2,tower_ant] = tower{2,t}-1;
				tower[3,tower_ant] = tower{2,t};
				
			end;
			else if grid{L+dl+tower{1,t},V+dv+tower{3,t}} = '[' then do;
			/*kun hojre over*/

				tower_ant+1;
				tower[1,tower_ant] = tower{1,t}+1;
				tower[2,tower_ant] = tower{2,t}+1;
				tower[3,tower_ant] = tower{2,t}+2;
			end;
			else if grid{L+dl+tower{1,t},V+dv+tower{2,t}} = '[' then do;
			/*en lige over*/

				tower_ant+1;
				tower[1,tower_ant] = tower{1,t}+1;
				tower[2,tower_ant] = tower{2,t};
				tower[3,tower_ant] = tower{2,t}+1;
			end;
		end;

%mend byg_tower_ned;


data ct05(keep=gps);
length GPS ol ov 8.;
set ct04;


%skriv_array(navn=tower, type=8,a=3,b=100,at=towe , bt=r);

/* Tower:
1: L [-1;-99]
2: V1 
3: V2
*/


%skriv_array(navn=grid, type=$1.,a=&lod_ant.,b=&dvand_ant.,at=gri , bt=d);
array dir[%eval(&tot_lang.)] $1. dir1-dir%eval(&tot_lang.);

/*find orig*/

do lod = 1 to %eval(&LOD_ant.);
	do vand = 1 to %eval(&dvand_ant.);
		if grid{lod,vand} = '@' then do;

			ol = lod;
			ov = vand;

		end;
	end;
end;

l = ol;
v = ov;

do flyt=1 to dim(dir)/*11*/;

%finddldv;

	/*put "dir[flyt]: " dir[flyt] ", dl: " dl ", dv: " dv;*/

	if grid{l+dl,v+dv} = '#' then do;

		/*put "FLYT IKKE MULIGT: dir[flyt]: " dir[flyt] ", dl: " dl ", dv: " dv;*/

	end;

	else if grid{l+dl,v+dv} = '.' then do;

		grid{l,v} = '.';
		grid{l+dl,v+dv} = '@';

		/*put "dir[flyt]: " dir[flyt] ", dl: " dl ", dv: " dv;*/

		l = l + dl;
		v = v + dv;

	end;
	else if grid{l+dl,v+dv} in ('[',']') then do;

		/*flyt vandret og lodret behandles hver for sig*/
		/*vandret*/
		if dl = 0 then do;
			Otal = 0;
			tegn = 'X';
			do until(tegn not in ('[',']'));
				Otal+1;
				Odl = dl*Otal;
				Odv = dv*Otal;
				tegn = grid{l+Odl,v+Odv};
			end;

			/*put "tegn: " tegn ", otal: " otal;*/

			if tegn = '.' then do;
				do j = Otal to 1 by -1;
					Odl = dl*j;
					Odv = dv*j;
					fdl = dl*(j-1);
					fdv = dv*(j-1); 
					grid{l+Odl,v+Odv} = grid{l+fdl,v+fdv}; 
				end;
				grid{l,v} = '.';
				l = l + dl;
				v = v + dv;
			end;
		end;
		/*lodret*/
		else do;

			/*tom tower array*/
			do tlod = 1 to 3;
				do tvand = 1 to 100;

				tower{tlod,tvand} = .;

				end;
			end;

			tower_ant=0;

		/* hvor er kasse  */
			/*put "dl: " dl;*/
			/*hvor er kassen ovenover: tower L = -1*/
			if dl < 0 then do;

			%byg_tower_op;

			end;
			/*hvor er kassen under*/
			else if dl > 0 then do;

			%byg_tower_ned;

			end;

			/*Tjek om tower kan flyttes dl*/

			flyt_ok=1;
			do t=1 to 100;

				if tower{1,t} = . then do;
					leave;
				end;
/*
				put "L: " L ", dl: " dl ", tower{1,t}: " tower{1,t} ", V: " v ", tower{2,t}: " tower{2,t};
				put "L: " L ", dl: " dl ", tower{1,t}: " tower{1,t} ", V: " v ", tower{3,t}: " tower{3,t};
*/
				if grid{L+dl+tower{1,t},V+tower{2,t}} = '#' then flyt_ok=0;
				if grid{L+dl+tower{1,t},V+tower{3,t}} = '#' then flyt_ok=0;

			end;

			/*put "flyt_ok: " flyt_ok;*/

			if flyt_ok then do;


				do t=tower_ant to 1 by -1;

					if tower{1,t} = . then do;
						leave;
					end;

					grid{L+dl+tower{1,t},V+tower{2,t}} = grid{L+tower{1,t},V+tower{2,t}};
					grid{L+tower{1,t},V+tower{2,t}} = '.';

					grid{L+dl+tower{1,t},V+tower{3,t}} = grid{L+tower{1,t},V+tower{3,t}};
					grid{L+tower{1,t},V+tower{3,t}} = '.';

				end;

					grid{L+dl,V} = grid{L,V};
					grid{L,V} = '.';

					l = l + dl;
					v = v + dv;


			end;

		end;
	end;
end;

/*		GPS = ((100 * (lod-1))+(vand-1)) + GPS;*/


GPS=0;

do lod = 1 to %eval(&LOD_ant.);
	do vand = 1 to %eval(&dvand_ant.);
		if grid{lod,vand} = '[' then do;

		GPS = ((100 * (lod-1))+(vand-1)) + GPS;

		end;
	end;
end;

run;



data pr_grid(drop=v vand keep= v: );
set ct04;

%skriv_array(navn=grid, type=$1.,a=&lod_ant.,b=&dvand_ant. ,at=gri , bt=d);

%macro pr;


%do b = 1 %to &lod_ant.;
%do a = 1 %to &dvand_ant.;

v%eval(&a.) = grid{&b.,&a.};
*if v%eval(&a.) = -8 then v%eval(&a.)= .;


%end;
output;
%end;

%mend;
%pr;


run;


data pr_flyt(drop=v vand keep= v: );
set ct05;

%skriv_array(navn=grid, type=$1.,a=&lod_ant.,b=&dvand_ant. ,at=gri , bt=d);

%macro pr;


%do b = 1 %to &lod_ant.;
%do a = 1 %to &dvand_ant.;

v%eval(&a.) = grid{&b.,&a.};
*if v%eval(&a.) = -8 then v%eval(&a.)= .;


%end;
output;
%end;

%mend;
%pr;


run;


data pr_tower(drop=v vand keep= v: );
set ct05;

%skriv_array(navn=tower, type=8,a=3,b=100,at=towe , bt=r);

%macro pr;


%do b = 1 %to 3;
%do a = 1 %to 100;

v%eval(&a.) = tower{&b.,&a.};
*if v%eval(&a.) = -8 then v%eval(&a.)= .;


%end;
output;
%end;

%mend;
%pr;


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
;

run;


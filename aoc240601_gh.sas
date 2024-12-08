%let ekstra_lod = 6;
%let ekstra_vand = 6;

%let lod_ant = %sysfunc(sum(%eval(&antobs.),%eval(&ekstra_lod)));
%let vand_ant = %sysfunc(sum(%eval(&maxlen.),%eval(&ekstra_vand)));
%put &=lod_ant.;
%put &=vand_ant.;


data ekstra(keep=x rename=(x=ft));
length x $&vand_ant..;
set ct;
x = '***'||strip(ft)||'***';
run;

data top(drop=i);
length ft $&vand_ant..;
ft = repeat('*',%eval(&vand_ant.));

do i = 1 to 3;
output;
end;

run;

data bund(drop=i);
length ft $&vand_ant..;
ft = repeat('*',%eval(&vand_ant.));

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

data Part1/*(keep=tal rename=(tal=Part1))*/;
set ct02;
%skriv_array(navn=grid, type=$1.,a=&lod_ant.,b=&vand_ant. ,at=gri , bt=d);
%skriv_array(navn=xgrid, type=$1.,a=&lod_ant.,b=&vand_ant. ,at=xgri , bt=d);


	do lod = 1 to %eval(&LOD_ant.);
		do vand = 1 to %eval(&vand_ant.);

			if grid{lod,vand} not in ('#','.','*') then do;

			ol = lod;
			ov = vand;
			odir = grid{lod,vand};

			end;

			xgrid{lod,vand} = grid{lod,vand};

		end;
	end;

	put "ol: " ol;
	put "ol: " ov;
	put "odir: " odir;

	/**/

	pl = ol;
	pv = ov;
	pdir = odir;

	xgrid{ol,ov} = odir;




/* dir:
	2	
  1   3
	4
*/

	/*do dir = 1 to 4;*/

	kant = 0;

	do mange = 1 to 10000;

		if pdir = '^' then do;	%xlurd(_dir=u); end;
		else if pdir = '>' then do;	%xlurd(_dir=r); end;
		else if pdir = 'v' then do;	%xlurd(_dir=d); end;
		else if pdir = '<' then do;	%xlurd(_dir=l); end;

		if kant = 1 then do;

			leave;

		end;

	end;

		
	/*tal antal ikke #,.*/
	taller = 0;
	do lod = 1 to %eval(&LOD_ant.);
		do vand = 1 to %eval(&vand_ant.);
			if xgrid{lod,vand} not in ('#','.','*') then do;

				taller+1;
				
			end;
		end;
	end;

	put "taller: " taller;

run;

%put &=lod_ant;%put &=vand_ant;

data Part2/*(keep=tal rename=(tal=Part1))*/;
set Part1;
%skriv_array(navn=grid, type=$1.,a=&lod_ant.,b=&vand_ant. ,at=gri , bt=d);
%skriv_array(navn=xgrid, type=$1.,a=&lod_ant.,b=&vand_ant. ,at=xgri , bt=d);

	put "ol: " ol;
	put "ol: " ov;
	put "odir: " odir;

	begynd = 1;
	ring = 0;

do xlod = 1 to %eval(&LOD_ant.);
	do xvand = 1 to %eval(&vand_ant.);

		if xgrid{xlod,xvand} in ('^','v','<','>') and ^(xlod = ol and xvand = ov) then do;

		pl = ol;
		pv = ov;
		pdir = odir;

		/*put "xlod: " xlod;
		put "xvand: " xvand;*/



		/*reset grid*/
			if begynd = 0 then do;

				grid{pre_xlod,pre_xvand} = '.';

			end;

			grid{xlod,xvand} = '#';
				
			kant = 0;

			
			do mange = 1 to 67600;

				if pdir = '^' then do;	%lurd(_dir=u); end;
				else if pdir = '>' then do;	%lurd(_dir=r); end;
				else if pdir = 'v' then do;	%lurd(_dir=d); end;
				else if pdir = '<' then do;	%lurd(_dir=l); end;

				if kant = 1 then do;

					leave;

				end;

				if mange = 67600 and kant = 0 then do;

					ring+1;

				end;

			end;

			pre_xlod = xlod;
			pre_xvand = xvand;
			begynd = 0;

	

		end;
	end;
end;

put "ring: " ring;

run;




data pr_grid(drop=v keep= v: );
set Part1;

%skriv_array(navn=xgrid, type=$1.,a=&lod_ant.,b=&vand_ant. ,at=xgri , bt=d);

%macro pr;


%do b = 1 %to &lod_ant.;
%do a = 1 %to &vand_ant.;

v%eval(&a.) = xgrid{&b.,&a.};
*if v%eval(&a.) = -8 then v%eval(&a.)= .;


%end;
output;
%end;

%mend;
%pr;


run;

	%macro lurd(_dir=);

	%if &_dir. = l %then %do; %let _dir_str = 1,2,3,4;%end;
	%if &_dir. = u %then %do; %let _dir_str = 2,3,4,1;%end;
	%if &_dir. = r %then %do; %let _dir_str = 3,4,1,2;%end;
	%if &_dir. = d %then %do; %let _dir_str = 4,1,2,3;%end;


	do dir = &_dir_str.; 

		dL = mod(abs(dir-3),2)*(dir-3);
		dV = mod(abs(dir-2),2)*(dir-2);

		if grid{pl+dl,pv+dv} = '*' then do;

		kant = 1;

		leave;

		end;

		else if grid{pl+dl,pv+dv} = '.' then do;

		grid{pl,pv} = '.';

		pl = pl + dl;
		pv = pv + dv;

		if dir = 2 then pdir = '^';
		else if dir = 3 then pdir = '>';
		else if dir = 4 then pdir = 'v';
		else pdir = '<';

		/*xgrid{pl,pv} = pdir;*/

		leave;

		end;


				
	end;

	%mend;

		%macro xlurd(_dir=);

	%if &_dir. = l %then %do; %let _dir_str = 1,2,3,4;%end;
	%if &_dir. = u %then %do; %let _dir_str = 2,3,4,1;%end;
	%if &_dir. = r %then %do; %let _dir_str = 3,4,1,2;%end;
	%if &_dir. = d %then %do; %let _dir_str = 4,1,2,3;%end;


	do dir = &_dir_str.; 

		dL = mod(abs(dir-3),2)*(dir-3);
		dV = mod(abs(dir-2),2)*(dir-2);

		if grid{pl+dl,pv+dv} = '*' then do;

		kant = 1;

		leave;

		end;

		else if grid{pl+dl,pv+dv} = '.' then do;

		grid{pl,pv} = '.';

		pl = pl + dl;
		pv = pv + dv;

		if dir = 2 then pdir = '^';
		else if dir = 3 then pdir = '>';
		else if dir = 4 then pdir = 'v';
		else pdir = '<';

		xgrid{pl,pv} = pdir;

		leave;

		end;


				
	end;

	%mend;


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
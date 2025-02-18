%let ekstra_lod = 0;
%let ekstra_vand = 0;

%let lod_ant = %sysfunc(sum(%eval(&antobs.),%eval(&ekstra_lod)));
%let vand_ant = %sysfunc(sum(%eval(&maxlen.),%eval(&ekstra_vand)));
%put &=lod_ant.;
%put &=vand_ant.;

data ct02(drop=ft);
set ct end=eof;
retain %skriv_array_var(a=&lod_ant.,b=&vand_ant. ,at=gri , bt=d);

%skriv_array(navn=grid, type=$1.,a=&lod_ant.,b=&vand_ant. ,at=gri , bt=d);

do i = 1 to &vand_ant.;

grid{_n_,i} = substr(ft,i,1);
 
end;

if eof;
run;


data Part1(keep=taller rename=(taller=Part1));
set ct02;
%skriv_array(navn=grid, type=$1.,a=&lod_ant.,b=&vand_ant. ,at=gri , bt=d);
%skriv_array(navn=agrid, type=8.,a=&lod_ant.,b=&vand_ant. ,at=agri , bt=d);


do lod = 1 to %eval(&LOD_ant.);
	do vand = 1 to %eval(&vand_ant.);

		if grid{lod,vand} not in ('.') then do;	

		/*find same*/
			do L = 1 to %eval(&LOD_ant.);
				do V = 1 to %eval(&vand_ant.);

					if ^(lod = L and vand = v) and grid{lod,vand} = grid{L,V} then do;
							
						/*put "vand, lod : v, l: " vand ", " lod " - " v ", " l;*/

						vdif = vand - v;  	/*put "vdif: " vdif;*/
						ldif = lod - l; 	/*put "ldif: " ldif;*/
						
						av = vand + vdif; 	/*put "av: " av;*/
						al = lod + ldif; 	/*put "al: " al;*/

						/*if inside map and not on the other point*/
						if ((%eval(&LOD_ant.) >= al > 0) and (%eval(&vand_ant.) >= av > 0)) and ^(al = l and av = v) then do;

							agrid{al,av} = 1;

							/*put "grid{lod,vand}: " grid{lod,vand};
							put "vand, lod : v, l: " vand ", " lod " - " v ", " l;*/

						end;	
					end;
				end;
			end;
		end;
	end;
end;

taller = 0;
do lod = 1 to %eval(&LOD_ant.);
	do vand = 1 to %eval(&vand_ant.);
		if agrid{lod,vand} = 1 then taller+1;
	end;
end;

run;


data Part2(keep=taller rename=(taller=Part2));
set ct02;
%skriv_array(navn=grid, type=$1.,a=&lod_ant.,b=&vand_ant. ,at=gri , bt=d);
%skriv_array(navn=agrid, type=8.,a=&lod_ant.,b=&vand_ant. ,at=agri , bt=d);


do lod = 1 to %eval(&LOD_ant.);
	do vand = 1 to %eval(&vand_ant.);

		if grid{lod,vand} not in ('.') then do;	

		/*find same*/
			do L = 1 to %eval(&LOD_ant.);
				do V = 1 to %eval(&vand_ant.);

					if ^(lod = L and vand = v) and grid{lod,vand} = grid{L,V} then do;
							
						/*put "vand, lod : v, l: " vand ", " lod " - " v ", " l;*/

						vdif = vand - v;  	/*put "vdif: " vdif;*/
						ldif = lod - l; 	/*put "ldif: " ldif;*/
						
						do mange=-49 to 49;
						av = vand + (mange*vdif); 	/*put "av: " av;*/
						al = lod + (mange*ldif); 	/*put "al: " al;*/

						/*if inside map */
						if ((%eval(&LOD_ant.) >= al > 0) and (%eval(&vand_ant.) >= av > 0)) /*and ^(al = l and av = v)*/ then do;

							agrid{al,av} = 1;

							/*put "grid{lod,vand}: " grid{lod,vand};
							put "vand, lod : v, l: " vand ", " lod " - " v ", " l;*/

						end;
						end;	
					end;
				end;
			end;
		end;
	end;
end;

taller = 0;
do lod = 1 to %eval(&LOD_ant.);
	do vand = 1 to %eval(&vand_ant.);
		if agrid{lod,vand} = 1 then taller+1;
	end;
end;

run;


data pr_grid(drop=v vand keep= v: );
set Part1;

%skriv_array(navn=grid, type=$1.,a=&lod_ant.,b=&vand_ant. ,at=gri , bt=d);

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


data pr_agrid(drop=v vand keep= v: );
set Part1;

%skriv_array(navn=agrid, type=8.,a=&lod_ant.,b=&vand_ant. ,at=agri , bt=d);

%macro pr;


%do b = 1 %to &lod_ant.;
%do a = 1 %to &vand_ant.;

v%eval(&a.) = agrid{&b.,&a.};
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
..........1.............TE........................
....................................R.............
..................................................
.......................j.....Q....................
...................A................8.............
...........................s.......9...........k..
q.E..............6...............1R.w.........k...
..6...E..............1.........R...............t..
.....r.Q......6........Re..T..............9.......
.............................T........9...........
...............................................wv.
.P............A..................8.v....s.k.......
.q..................A......k.........8............
..........o.....1.....W..H............8.......w...
..Q........P.........O.........e...N.W............
P................z.........o.............N.......w
..............o.....p..........Z.s..........N.....
.....O.x......K.....................v..aN.........
..O...............U.....H.......t.................
.E.......q...6.....i..............................
..............z..........o...i...........aW.......
....O........r.............e.....Wt...............
...............U.7i........H......h........t......
......Q.......n..2...I...A....i.p.................
...........2...9n.................s........j......
..q................Ur..........p..................
.............n.................K..................
.....S....z.........I.....H.............e.j.......
..................7..prD..K...d...................
S.........V.....7....K............................
......................................0...........
..................................................
..................2..........I....j.Z.............
....................X.............J..Z....a.......
........SX............................x......0J...
................U....n........x...............0...
.........S......X................x....a...........
...5.......X.......................02.............
...............V.........................d...J....
.............................u.......4............
.....5...........................u.4..............
....5.............................................
......V................................3..........
......D..........................................d
....D.................................4...........
.....h....................................d7......
..............................P...................
.........D......h........3................u...4...
.............h..5.....3...........u.....I.........
..........3......V.............................J..
;

run;
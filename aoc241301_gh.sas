data ct01(drop=ft lang len);
set ct;
retain ax ay bx by px py;

costA  = 3;
costB = 1;

if index(ft,'A') then do;

ax = input(scan(ft,2,'+,'),8.);
ay = input(scan(ft,4,'+,'),8.);

end;
if index(ft,'B') then do;

bx = input(scan(ft,2,'+,'),8.);
by = input(scan(ft,4,'+,'),8.);

end;
if index(ft,'P') then do;

px = input(scan(ft,2,'=,'),8.);
py = input(scan(ft,4,'=,'),8.);
output;
end;
run;


/*
data ct02;
set ct01;
retain res 0;

maxA = floor(px/ax);
maxB = floor(px/bx);

minpris = 9999999;

do i = maxA to 0 by -1;

	do j = maxB to 0 by-1;


		if ((i * ax) + (j * bx)) = px then do;


			if ((i * ay) + (j * by)) = py then do;

				pris = ((i*costA) + (j*costB));

				if pris < minpris then minpris = pris;

			end;


		end;

	end;

end;

if minpris ne 9999999 then res = res + minpris;

run;
*/



data Part1(keep=res rename=(res=Part1));
set ct01 end=eof;
retain res 0;

a = ((px*by) - (py*bx)) / ((ax*by)-(ay*bx));
b = ((ax*py) - (px*ay)) / ((ax*by)-(ay*bx)); 


if mod(a,1) = 0 and mod(b,1) = 0 then do;

pris = (a*3) + (b);

res = res+pris;

end;

if eof;

run;

data ct02;
set ct01;

px = px + 10000000000000;
py = py + 10000000000000;

format px py 32.;
run;

data Part2/*(keep=res rename=(res=Part1))*/;
set ct02 end=eof;
retain res 0;



a = ((px*by) - (py*bx)) / ((ax*by)-(ay*bx));
b = ((ax*py) - (px*ay)) / ((ax*by)-(ay*bx)); 


if floor(a) = a and floor(b) = b then do;

/*if mod(a,1) = 0 and mod(b,1) = 0 then do;*/

pris = (a*3) + (b);

res = res+pris;

end;

*if eof;


format res a b 32.6; 

run;

/**/


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


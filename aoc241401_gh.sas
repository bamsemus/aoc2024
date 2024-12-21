

data Part1(keep= Part1);
length new_x new_y 8.;
set ct end=eof;
retain tq1 tq2 tq3 tq4 0;

ant = 100;

mX = 101; 
mY = 103; 

mid_x = ceil((mX-1)/2); 
mid_y = ceil((my-1)/2);

x = input(scan(ft,2,'=, '),3.);
y = input(scan(ft,3,'=, '),3.);

vx = input(scan(ft,5,'=, '),3.);
vy = input(scan(ft,6,'=, '),3.);


move_x = mod(ant*vx,mx);
new_x = mod(x +(mx + move_x),mx);

move_y = mod(ant*vy,my);
new_y = mod(y +(my + move_y),my);

q1=0;
q2=0;
q3=0;
q4=0;

     if new_x < mid_x and new_y < mid_y then q1 = 1;
else if new_x > mid_x and new_y < mid_y then q2 = 1;
else if new_x < mid_x and new_y > mid_y then q3 = 1;
else if new_x > mid_x and new_y > mid_y then q4 = 1;

tq1 = tq1+q1;
tq2 = tq2+q2;
tq3 = tq3+q3;
tq4 = tq4+q4;

Part1 = tq1 * tq2 * tq3 * tq4;
if eof;
run;


data ct02;
length new_x new_y 8.;
set ct end=eof;
retain x1-x500 y1-y500 vx1-vx500 vy1-vy500 nx1-nx500 ny1-ny500;

ant = 100;

mX = 101; 
mY = 103;

mid_x = ceil((mX-1)/2); 
mid_y = ceil((my-1)/2);

array x[500] 8. x1-x500;
array y[500] 8. y1-y500;

array vx[500] 8. vx1-vx500;
array vy[500] 8. vy1-vy500;

array nx[500] 8. nx1-nx500;
array ny[500] 8. ny1-ny500;

x[_N_] = input(scan(ft,2,'=, '),3.);
y[_N_] = input(scan(ft,3,'=, '),3.);

vx[_N_] = input(scan(ft,5,'=, '),3.);
vy[_N_] = input(scan(ft,6,'=, '),3.);

if eof;
run;

data ct03;
length Part1 q1 q2 q3 q4 8.;
set ct02;

array x[500] 8. x1-x500;
array y[500] 8. y1-y500;

array vx[500] 8. vx1-vx500;
array vy[500] 8. vy1-vy500;

array nx[500] 8. nx1-nx500;
array ny[500] 8. ny1-ny500;

ant = 100;

do i = 1 to 500;

move_x = mod(ant*vx[i],mx);
nx[i] = mod(x[i] +(mx + move_x),mx);

move_y = mod(ant*vy[i],my);
ny[i] = mod(y[i] +(my + move_y),my);

end;

q1=0;
q2=0;
q3=0;
q4=0;

do i = 1 to 500;

     if nx[i] < mid_x and ny[i] < mid_y then q1+1;
else if nx[i] > mid_x and ny[i] < mid_y then q2+1;
else if nx[i] < mid_x and ny[i] > mid_y then q3+1;
else if nx[i] > mid_x and ny[i] > mid_y then q4+1;

end;
Part1 = q1*q2*q3*q4;

run;


data Part2(keep=husk_ant rename=(husk_ant = Part2));
length husk_ant husk_ant_lille_r tot_r q1 q2 q3 q4 8.;
set ct02;

array x[500] 8. x1-x500;
array y[500] 8. y1-y500;

array vx[500] 8. vx1-vx500;
array vy[500] 8. vy1-vy500;

array nx[500] 8. nx1-nx500;
array ny[500] 8. ny1-ny500;

/*led efter koordinater med "lille" r*/

husk_ant_lille_r = 999999;
husk_ant = 0;

do ant = 0 to 100000;

do i = 1 to 500;

move_x = mod(ant*vx[i],mx);
nx[i] = mod(x[i] +(mx + move_x),mx);

move_y = mod(ant*vy[i],my);
ny[i] = mod(y[i] +(my + move_y),my);

end;

q1=0;
q2=0;
q3=0;
q4=0;

tot_r = 0;

do i = 1 to 500;

r = (((nx[i]- mid_x)**2)**(0.5))+(((ny[i]- mid_y)**2)**(0.5));
tot_r = tot_r + r;

end;

if husk_ant_lille_r > tot_r then do;
husk_ant_lille_r = tot_r;
husk_ant = ant;
end;

end;


run;

data _NULL_;
set part2;
call symput('_ant_til_print',strip(put(part2,8.)));
run;

%put &=_ant_til_print.;

data ct06;
length Part1 q1 q2 q3 q4 8.;
set ct02;

array x[500] 8. x1-x500;
array y[500] 8. y1-y500;

array vx[500] 8. vx1-vx500;
array vy[500] 8. vy1-vy500;

array nx[500] 8. nx1-nx500;
array ny[500] 8. ny1-ny500;

ant = %eval(&_ant_til_print.);

do i = 1 to 500;

move_x = mod(ant*vx[i],mx);
nx[i] = mod(x[i] +(mx + move_x),mx);

move_y = mod(ant*vy[i],my);
ny[i] = mod(y[i] +(my + move_y),my);

end;

q1=0;
q2=0;
q3=0;
q4=0;

do i = 1 to 500;

     if nx[i] < mid_x and ny[i] < mid_y then q1+1;
else if nx[i] > mid_x and ny[i] < mid_y then q2+1;
else if nx[i] < mid_x and ny[i] > mid_y then q3+1;
else if nx[i] > mid_x and ny[i] > mid_y then q4+1;

end;
Part1 = q1*q2*q3*q4;

%skriv_array(navn=longgrid, type=8.,a=103,b=101 ,at=longgri , bt=d);

do i = 1 to 500;

put "nx: " nx[i] ", ny: " ny[i];

if longgrid{ny[i]+1,nx[i]+1} = . then longgrid{ny[i]+1,nx[i]+1} = 1;
else longgrid{ny[i]+1,nx[i]+1} = longgrid{ny[i]+1,nx[i]+1} + 1;


end;

run;

data pr_single(keep= q: );
set ct06;

%skriv_array(navn=longgrid, type=$7.,a=103,b=101 ,at=longgri , bt=d);

%macro pr;


%do b = 1 %to 103;
%do a = 1 %to 101;

q%eval(&a.) = longgrid{&b.,&a.};


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
Input_from_aoc
;

run;

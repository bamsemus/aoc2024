%macro lenskriv;
length 
%do i = 1 %to &antobs.;
 a&i.  b&i. 
%end;
 $2.
;
%mend;

data ct01(drop=ft lang len);
%lenskriv;
set ct end=eof;
retain a: b:;

array a[&antobs.] $2. a1-a&antobs.;
array b[&antobs.] $2. b1-b&antobs.;

a[_N_] = scan(ft,1,'-');
b[_N_] = scan(ft,2,'-');

if eof;
run;

data ct02;
set ct01;

array a[&antobs.] $2. a1-a&antobs.;
array b[&antobs.] $2. b1-b&antobs.;

array cset [&antobs.] 8. cset1-cset&antobs.;
array tset [&antobs.] 8. tset1-tset&antobs.;
array aset [&antobs.] 8. aset1-aset&antobs.;

/*
array con[&antobs.] 8. b1-b&antobs.;
*/



/*find t sets*/
taller = 0;
do i =1 to %eval(&antobs.);

	if substr(a[i],1,1) = 't' or substr(b[i],1,1) = 't' then do;



		taller+1;
		tset[taller] = i;
		/* check connections*/
		
	end;
end;

/*available sets (all!)*/

do i =1 to %eval(&antobs.);

aset[i] = i;

end;

/*check sets*/

do i = 1 to dim(tset);

ccount = 2;
if tset[i] ne . then do;

		put "a[tset[i]]: " a[tset[i]] ", b[tset[i]]: " b[tset[i]];

		do j = 1 to dim(aset);

		if tset[i] = aset[j] then aset[j] = 0; /*only use a set once*/

		end;



end;

end;


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
kh-tc
qp-kh
de-cg
ka-co
yn-aq
qp-ub
cg-tb
vc-aq
tb-ka
wh-tc
yn-cg
kh-ub
ta-co
de-co
tc-td
tb-wq
wh-td
ta-ka
td-qp
aq-cg
wq-ub
ub-vc
de-ta
wq-aq
wq-vc
wh-yn
ka-de
kh-ta
co-tc
wh-qp
tb-vc
td-yn
;

run;
data ct01;
set ct;

nr = _N_;

/*
if index(ft,'z19') or index(ft,'z12') or index(ft,'z37')
or index(ft,'> djg') or index(ft,'> dsd') or index(ft,'> sbg');
*/

/*husk nr+1 convert.*/

/*

de tre z skal vaere xor, de tre andre skal være 2 and og 1 or



*/

/*
if nr in (141, 216 306) then to_be_xor = 1;
if nr in (170, 174, 223) then to_be_2And_1or = 1;
*/


run;

data top(drop=bl) bund(drop=bl);
length ft $30.;
set ct(drop=lang len);
retain bl 0;

if ft = '' then bl = 1;

if bl=0 then output top;
else if ft ne '' then output bund;

run;

/*switch bund*/


data bund_s;
set bund;



nr = _n_;
old_ft = ft;

a = strip(scan(ft,1,''));
ope = strip(scan(ft,2,''));
b = strip(scan(ft,3,''));
c = strip(scan(ft,5,''));

/*if index(ft,'z19') or index(ft,'z12') or index(ft,'z37') then c_to_xor = 1;*/

if c = 'z45' then keep = 1;
else if ope ne 'XOR' and substr(c,1,1) = 'z' then c_to_xor = 1;
/*else if ope = 'XOR' and substr(c,1,1) ne 'z' then c_to_2and_1or=1;*/

else if ope = 'XOR' and substr(c,1,1) = 'z' then keep=1;

else if ope = 'XOR' and substr(a,1,1) not in ('x','y') and substr(b,1,1) not in ('x','y') then c_to_2and_1or=1;




/*
if index(ft,'> djg') or index(ft,'> dsd') or index(ft,'> sbg') then c_to_2and_1or=1;

if index(ft,'> z') and ^c_to_xor then keep=1;
else if 
*/


run;

proc sort; by descending c_to_2and_1or descending c_to_xor descending keep ope;run;

data c_to_2and_1or(drop=c_to_2and_1or rename=(tal=c_to_2and_1or));
set bund_s(where=(c_to_2and_1or));
retain tal;

if tal=. then tal=1;
else tal+1;

run;





%let rest1 = 40; /*1-173*/
%let rest2 = 158; /*1-173*/

%let entotre = 1;

%macro gor;

/*
%do entotre=1 %to 3;
*/

data bund_s01;
set 
c_to_2and_1or
bund_s(where=(^c_to_2and_1or))
;

if keep then ft = old_ft;
else if c_to_xor then ft = tranwrd(tranwrd(ft,' OR ',' XOR '),' AND ',' XOR ');

else if c_to_2and_1or then do;

	if %eval(&entotre.) = c_to_2and_1or then ft = tranwrd(ft,' XOR ',' OR ');
	else ft = tranwrd(ft,' XOR ',' AND ');

end;

run;
proc sort; by descending c_to_2and_1or descending c_to_xor descending keep ope;run;

data bund_rest;
set bund_s01;
where ^keep and ^c_to_xor and ^c_to_2and_1or;

rest_nr = _N_;

run;

/*%do rest1 = 90 %to 92;
	%do rest2 = 138 %to 140;
*/

data _null_;
set bund_rest;

if rest_nr = %eval(&rest1.) then call symput('OPE1',strip(ope));
if rest_nr = %eval(&rest2.) then call symput('OPE2',strip(ope));


run;

%put &=OPE1;
%put &=OPE2;

/*%if "&OPE1" ne "&OPE2" %then %do;*/

data bund_rest;
set bund_rest;

if rest_nr = %eval(&rest1.) then do;

ft = tranwrd(ft,"&OPE1.","&OPE2.");

end;
if rest_nr = %eval(&rest2.) then do;

ft = tranwrd(ft,"&OPE2.","&OPE1.");

end;

run;

data bund_s02;
set bund_s01(where=(keep or c_to_xor or c_to_2and_1or))
bund_rest
;

run;
/*proc sort; by nr;run;*/

data topy;
set top;
where index(ft,'y');
call symput('anty',strip(put(_N_,8.)));
run;

data y_arr;
set topy end=eof;
retain y1-y&anty.;

array y[&anty.] 8. y1-y&anty.;
y[_N_] = input(scan(ft,2,':'),8.);

if eof;
run;

data topx;
set top;
where index(ft,'x');
call symput('antx',strip(put(_N_,8.)));
run;

data x_arr;
set topx end=eof;
retain x1-x&antx.;

array x[&antx.] 8. x1-x&antx.;
x[_N_] = input(scan(ft,2,':'),8.);

if eof;
run;

data _NULL_;
set bund_s02;
call symput('ant_beregn',strip(put(_N_,8.)));
run;

%macro lenskriv;

%do i = 1 %to &ant_beregn.;

 c&i. ope&i. a&i. b&i. 

%end;
%mend;

data beregn_arr;
length %lenskriv $3.;
set bund_s02(keep=ft) end=eof;
retain c1-c&ant_beregn. b1-b&ant_beregn. a1-a&ant_beregn. ope1-ope&ant_beregn.;

array c[&ant_beregn.] $3. c1-c&ant_beregn.;
array ope[&ant_beregn.] $3. ope1-ope&ant_beregn.;
array a[&ant_beregn.] $3. a1-a&ant_beregn.;
array b[&ant_beregn.] $3. b1-b&ant_beregn.;

a[_n_] = strip(scan(ft,1,''));
ope[_n_] = strip(scan(ft,2,''));
b[_n_] = strip(scan(ft,3,''));
c[_n_] = strip(scan(ft,5,''));

if eof;
run;


data bund01;
set bund_s02(keep=ft);

a = strip(scan(ft,1,''));
ope = strip(scan(ft,2,''));
b = strip(scan(ft,3,''));
c = strip(scan(ft,5,''));

run;

data ope;
set bund01(keep=ope );
run;
proc sort nodupkey;by ope;run;


data abc;
set 
bund01(keep=a rename=(a=u))
bund01(keep=b rename=(b=u))
bund01(keep=c rename=(c=u))

; 
run;
proc sort data=abc out=abc_unik nodupkey;by u;run;

data abc_unik;
set abc_unik;
if index(u,'x') or index(u,'y') then sort=1;
else if index(u,'z') then sort = 2;
else sort = 3;
run;
proc sort data=abc_unik;by sort u;run;

data _NULL_;
set abc_unik;
call symput('ant_abc_unik',strip(put(_N_,8.)));
run;

%put &=ant_beregn;
%put &=ant_abc_unik;


data abc_arr(drop=u);

set abc_unik end=eof;
retain Nabc1-Nabc&ant_abc_unik. /*Vabc1-Vabc&ant_abc_unik.*/;

Array Nabc[&ant_abc_unik.] $3. Nabc1-Nabc&ant_abc_unik.;
/*Array Vabc[&ant_abc_unik.] 8. Vabc1-Vabc&ant_abc_unik.;*/

Nabc[_N_] = strip(u);


if eof;
run;

proc sql;
create table abc_arr01 as

select a.ft, b.*

from top a

join abc_arr b
on 1 = 1
;


quit;


%macro lenskriv;

%do i = 1 %to &ant_abc_unik.;

Nabc&i. $3. Vabc&i. 8.

%end;
;
%mend;


data abc_arr02(drop=f s sort i);
length f $3. s 8. %lenskriv;

set abc_arr01 end=eof;
retain Vabc1-Vabc&ant_abc_unik.;


Array Nabc[&ant_abc_unik.] $3. Nabc1-Nabc&ant_abc_unik.;
Array Vabc[&ant_abc_unik.] 8. Vabc1-Vabc&ant_abc_unik.;

f = strip(scan(ft,1,':'));
s = input(scan(ft,2,':'),8.);

do i = 1 to dim(Nabc);

if f = strip(Nabc[i]) then Vabc[i] = s;  

end;

if eof;
run;

data saml;
length str $100.;
merge beregn_arr abc_arr02;

array c[&ant_beregn.] $3. c1-c&ant_beregn.;
array ope[&ant_beregn.] $3. ope1-ope&ant_beregn.;
array a[&ant_beregn.] $3. a1-a&ant_beregn.;
array b[&ant_beregn.] $3. b1-b&ant_beregn.;

Array Nabc[&ant_abc_unik.] $3. Nabc1-Nabc&ant_abc_unik.;
Array Vabc[&ant_abc_unik.] 8. Vabc1-Vabc&ant_abc_unik.;

level = 0;
tal = 1;
/*do mange = 1 to 10;*/
do until(tal=0);

level+1;

/*Put "level: " level;*/

do i = 1 to dim(c);

c_t = c[i];
ope_t = ope[i];
a_t = a[i];
b_t = b[i];

/*put "c: " c_T ", ope: " ope_t ", a: " a_T ", b " b_T;*/

c_v=.;c_v_j=.;
a_v=.;
b_v=.;

do j = 1 to dim(Nabc);

if c[i] = Nabc[j] then do; 
	c_v = Vabc[j];
	c_v_j = j; 
end;
if a[i] = Nabc[j] then a_v = Vabc[j];
if b[i] = Nabc[j] then b_v = Vabc[j];  

end;
/*
put "c_v: " c_v ", a_v: " a_v ", b_v: " b_v;
*/

if c_v = . and a_v ne . and b_v ne . then do;

if strip(ope[i]) = 'AND' then do;

/*put "c_v_j: " c_v_j;*/
	Vabc[c_v_j] = band(a_v,b_v);

end;
else if strip(ope[i]) = 'OR' then do;

/*put "c_v_j: " c_v_j;*/
	Vabc[c_v_j] = bor(a_v,b_v);

end;
else if strip(ope[i]) = 'XOR' then do;

/*put "c_v_j: " c_v_j;*/
	Vabc[c_v_j] = bxor(a_v,b_v);


end;

/*
put "c_v_j: " c_v_j;
put "Vabc[c_v_j]: " Vabc[c_v_j];
*/

	
end;

end;


tal = 0;
do y = 1 to dim(c);

if Vabc[y] = . then tal+1;

end;

/*put "tal: " tal;*/

end;


tal = 0;
str = '';
do y=dim(c) to 1 by -1;

if substr(Nabc[y],1,1) = 'z' then str = strip(str)||strip(put(Vabc[y],$1.));

end;


run;

%let _slut=0;
data Part1(keep=Part1 correct diff);
set saml(keep=str);

entotre = %eval(&entotre.);
rest1 = %eval(&rest1.);
rest2 = %eval(&rest2.);


Part1 = input(strip(str),binary64.);

correct = 64892933710960;

diff = correct - Part1;

call symput('_diff',strip(put(diff,32.)));

if diff = 0 then call symput('_slut','1');

Format correct Part1 diff 32.;
run;

%put &=_diff;
%put &=_slut.;


/*
%end;


%end;




%end;




%end;*/
%mend;

/*options nosource nonotes;*/
%gor;
/*options source notes;*/

/*
_DIFF=137422704640
_SLUT=0
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
x00: 1
x01: 1
x02: 0
x03: 0
x04: 0
x05: 1
x06: 0
x07: 1
x08: 1
x09: 0
x10: 1
x11: 0
x12: 0
x13: 0
x14: 1
x15: 0
x16: 0
x17: 1
x18: 0
x19: 1
x20: 0
x21: 1
x22: 0
x23: 1
x24: 0
x25: 0
x26: 1
x27: 0
x28: 0
x29: 0
x30: 0
x31: 1
x32: 1
x33: 1
x34: 1
x35: 1
x36: 1
x37: 1
x38: 0
x39: 1
x40: 1
x41: 0
x42: 1
x43: 1
x44: 1
y00: 1
y01: 0
y02: 1
y03: 1
y04: 0
y05: 0
y06: 1
y07: 1
y08: 0
y09: 1
y10: 1
y11: 1
y12: 1
y13: 0
y14: 1
y15: 1
y16: 0
y17: 0
y18: 0
y19: 1
y20: 1
y21: 0
y22: 0
y23: 1
y24: 1
y25: 1
y26: 0
y27: 1
y28: 0
y29: 0
y30: 0
y31: 1
y32: 1
y33: 0
y34: 1
y35: 0
y36: 0
y37: 0
y38: 1
y39: 0
y40: 1
y41: 0
y42: 1
y43: 1
y44: 1

x21 XOR y21 -> hgv
cpr OR tmw -> dhb
cpq AND tkb -> jqs
nbp AND tnq -> cpr
scj AND btd -> tpk
ffg OR tpj -> jrb
pft AND qcp -> bcq
djg OR djr -> nbf
qdg AND fqp -> trd
jkm AND wrg -> vsk
x39 AND y39 -> rjk
frt AND pgs -> vfq
nqk OR mdk -> tbs
y00 AND x00 -> ktt
pks OR ptm -> dnd
ntj AND fbk -> dps
y44 AND x44 -> dgh
wgw OR qqp -> rnc
y33 AND x33 -> jpc
x13 AND y13 -> ntm
y38 XOR x38 -> spf
fnq OR pcv -> scj
hjs OR vwj -> hhp
y38 AND x38 -> pgc
ftg AND mhv -> njj
wvw OR rdt -> trw
gkk AND nrd -> smk
jjc AND mpf -> gvt
x14 AND y14 -> tmw
mwp OR vsb -> jqc
mks OR jqs -> jrr
y40 XOR x40 -> cvb
hjm AND jrr -> rpj
x04 AND y04 -> csm
kdm AND cgt -> sch
jkm XOR wrg -> z33
wjh XOR cpv -> z17
bfn OR gwm -> smd
x06 AND y06 -> kfb
sqr XOR wpd -> z25
dkq OR jsf -> frt
x40 AND y40 -> wgw
sqt OR wnv -> hww
y12 AND x12 -> djr
y18 XOR x18 -> qcp
cpq XOR tkb -> z23
bsr OR njd -> cpq
rqp XOR hcd -> z10
ckt XOR jwg -> z20
x19 AND y19 -> z19
y37 AND x37 -> gqf
hqv XOR bcf -> z34
x41 XOR y41 -> mfp
x14 XOR y14 -> nbp
x42 XOR y42 -> qsg
y25 XOR x25 -> wpd
x27 AND y27 -> jqg
y05 AND x05 -> fjd
y28 XOR x28 -> gkk
x17 AND y17 -> bpg
y26 XOR x26 -> tmk
bgs OR rpc -> nqq
x13 XOR y13 -> fnc
x31 AND y31 -> jsf
y34 XOR x34 -> bcf
ftg XOR mhv -> z06
y10 AND x10 -> wnv
x00 XOR y00 -> z00
y15 AND x15 -> ptm
fnc AND nbf -> mwj
qmj XOR jqc -> z36
bcf AND hqv -> cwc
gkk XOR nrd -> z28
kbm AND dgv -> vsb
y34 AND x34 -> gbk
y33 XOR x33 -> jkm
y08 AND x08 -> wvw
y39 XOR x39 -> fkg
hhp XOR tjm -> dsd
cwc OR gbk -> dgv
dnd XOR nqd -> z16
dts XOR gpv -> z07
njf XOR jsb -> djg
y36 AND x36 -> hjs
y31 XOR x31 -> qvw
stm OR mgr -> cpv
y02 AND x02 -> kwm
x03 AND y03 -> jmr
wcc OR jjp -> fqp
btd XOR scj -> z43
y24 AND x24 -> hjm
y32 XOR x32 -> pgs
y12 XOR x12 -> jsb
y23 XOR x23 -> tkb
kfb OR njj -> gpv
y22 XOR x22 -> kvp
x16 XOR y16 -> nqd
dhr AND cvb -> qqp
y25 AND x25 -> ffg
fbk XOR ntj -> z03
wqw AND mtm -> rdt
qvw AND smd -> dkq
kgm OR smk -> rmg
hww XOR fkc -> z11
dcc OR wkn -> njf
x09 XOR y09 -> pmb
fbf OR npg -> gtk
y15 XOR x15 -> ktv
nbp XOR tnq -> z14
tbs AND kvp -> njd
qcp XOR pft -> z18
sqr AND wpd -> tpj
jmr OR dps -> mpf
y20 AND x20 -> rpc
tmc OR tpk -> fjb
fsc OR bcq -> qjc
qdg XOR fqp -> z27
x28 AND y28 -> kgm
y32 AND x32 -> psb
y17 XOR x17 -> wjh
mcq OR rpj -> sqr
dsd XOR spf -> z38
mfp AND rnc -> fbf
dgh OR vpj -> z45
jsb AND njf -> z12
kgp OR kmb -> rkn
dmn XOR rkw -> z30
csm OR gvt -> cgt
y03 XOR x03 -> fbk
y05 XOR x05 -> kdm
hhp AND tjm -> spj
qjc XOR kbs -> sbg
rqp AND hcd -> sqt
x01 XOR y01 -> rvb
y30 XOR x30 -> rkw
wqw XOR mtm -> z08
y08 XOR x08 -> wqw
mrf OR pgc -> kvh
x24 XOR y24 -> mcq
jpc OR vsk -> hqv
hww AND fkc -> dcc
dhb AND ktv -> pks
tbs XOR kvp -> z22
trd OR jqg -> nrd
jfn AND fjb -> vpj
trw AND pmb -> pvb
cpv AND wjh -> jtp
kbm XOR dgv -> z35
hhm XOR rmg -> z29
y07 XOR x07 -> dts
whm OR qss -> mtm
nqq AND hgv -> mdk
dmn AND rkw -> gwm
x43 AND y43 -> tmc
rmg AND hhm -> ktc
jjc XOR mpf -> z04
y23 AND x23 -> mks
frt XOR pgs -> z32
x19 XOR y19 -> kbs
kvh AND fkg -> qns
bnh OR sbg -> jwg
qsg AND gtk -> fnq
y11 XOR x11 -> fkc
vfq OR psb -> wrg
bpg OR jtp -> pft
x29 AND y29 -> rwk
qsg XOR gtk -> z42
x07 AND y07 -> qss
x41 AND y41 -> npg
kvh XOR fkg -> z39
jrb AND tmk -> wcc
y36 XOR x36 -> qmj
ntm OR mwj -> tnq
y11 AND x11 -> wkn
fjb XOR jfn -> z44
rwk OR ktc -> dmn
ktt XOR rvb -> z01
mfp XOR rnc -> z41
hgv XOR nqq -> z21
x35 XOR y35 -> kbm
y35 AND x35 -> mwp
x42 AND y42 -> pcv
dsd AND spf -> mrf
y02 XOR x02 -> ssq
x18 AND y18 -> fsc
y04 XOR x04 -> jjc
rkn XOR ssq -> z02
x43 XOR y43 -> btd
dhb XOR ktv -> z15
x20 XOR y20 -> ckt
jqc AND qmj -> vwj
y21 AND x21 -> nqk
x01 AND y01 -> kgp
qjc AND kbs -> bnh
fhf OR pvb -> rqp
fnc XOR nbf -> z13
dts AND gpv -> whm
smd XOR qvw -> z31
fjd OR sch -> ftg
y06 XOR x06 -> mhv
tmk XOR jrb -> z26
y27 XOR x27 -> qdg
x44 XOR y44 -> jfn
qns OR rjk -> dhr
kdm XOR cgt -> z05
kwm OR vsc -> ntj
x22 AND y22 -> bsr
cvb XOR dhr -> z40
y37 XOR x37 -> tjm
x16 AND y16 -> mgr
rkn AND ssq -> vsc
ktt AND rvb -> kmb
x10 XOR y10 -> hcd
pmb XOR trw -> z09
spj OR gqf -> z37
y30 AND x30 -> bfn
x26 AND y26 -> jjp
jrr XOR hjm -> z24
jwg AND ckt -> bgs
x29 XOR y29 -> hhm
x09 AND y09 -> fhf
dnd AND nqd -> stm
;

run;

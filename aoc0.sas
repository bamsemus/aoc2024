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
%let lenl = 32000;

data CT;
	infile "C:\Users\JB6028\Git\aoc2024\aoc2403.txt" truncover;
	length ft $&lenl.;
	input @1 ft $&lenl..;
	len = length(strip(ft));
run;

data ct01(keep=lang len);
	Length lang $20000.;
	set ct end=eof;
	retain lang '';

	if _N_=1 then
		lang = strip(ft);
	else lang = strip(lang)||strip(ft);
	len = length(strip(lang));

	if eof;
run;

data ct02(keep=mul);
	length mul $1000. next_mul 8.;
	set ct01;
	rest = substr(lang,index(lang,'mul('));
	next_mul = (index(substr(rest,2),'mul('))+1;

	do until(next_mul  < 2);
		mul = substr(rest,1,next_mul-1);
		rest = substr(rest,next_mul);
		next_mul = (index(substr(rest,2),'mul('))+1;
		put "mul: " mul;
		output;
	end;

	mul = rest;
	put "mul: " mul;
	output;
run;

data Part1(keep=Part1);
	set ct02 end=eof;
	retain Part1 0;
	mul = substr(mul,1,index(mul,')'));
	match = prxmatch('/^mul\(\d{1,3},\d{1,3}\)$/', strip(mul));

	if match then
		do;
			x = input(scan(mul,2,'(,)'),8.);
			y = input(scan(mul,3,'(,)'),8.);
			Part1 = (x * y) + Part1;
		end;

	if eof;
run;

data Part2 (keep=Part2);
	set ct02 end=eof;
	retain Part2 0 gor 0;

	if _N_ = 1 then
		do;
			gor=1;
		end;

	org_mul = mul;
	mul = substr(mul,1,index(mul,')'));
	match = prxmatch('/^mul\(\d{1,3},\d{1,3}\)$/', strip(mul));

	if match and gor then
		do;
			x = input(scan(mul,2,'(,)'),8.);
			y = input(scan(mul,3,'(,)'),8.);
			Part2 = (x * y) + Part2;
		end;

	/* 

	do og dont optraeder ikke sammen i dette input...
	for input hvor det gor skal nedenstående skrives om

	*/

	rev = reverse(strip(org_mul));
	dnt_idx = index(rev,")(t'nod");
	do_idx =  index(rev,")(od");


	if dnt_idx > 0 then
		gor = 0;
	else if do_idx > 0 then
		gor = 1;

	if eof;
run;
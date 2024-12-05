data ct01(drop=ft i lang len);
	set ct;

		report = _N_;

	Array level[8] 8. level1-level8;

	do i = 1 to 8;
		level[i]=input(scan(ft,i,''),8.);
	end;

	/*levels*/
	ant_level = 0;

	do i = 1 to 8;
		if level[i] then
			ant_level+1;
	end;

	/*inc*/
	inc=1;

	do i = 1 to ant_level-1;
		if level[i] >= level[i+1] then
			inc=0;
	end;

	/*inc*/
	dec=1;

	do i = 1 to ant_level-1;
		if level[i] <= level[i+1] then
			dec=0;
	end;

	/*step size*/
	size = 0;

	do i = 1 to ant_level-1;
		if abs(level[i] - level[i+1]) > size then
			size = abs(level[i] - level[i+1]);
	end;



	safe = 0;
	if (inc or dec) and size <= 3 then safe = 1; 

run;

data Part1(keep=Part1);
	set ct01 end=eof;
	where (inc or dec) and size <= 3;
	Part1 = _N_;


	call symput('Part1',Part1);

	if eof;
run;

data ct02(drop= i j tal );
set ct01;

where safe = 0;

Array olevel[8] 8. olevel1-olevel8;
Array level[8] 8. level1-level8;


do i = 1 to ant_level;

olevel[i]=level[i];

end;

/*levels*/

do i = 1 to ant_level;

level[i] = .;

end;


do j = 1 to ant_level;

tal = 0;
	do i = 1 to ant_level-1;

	tal+1;
	if i = j then tal+1;

		level[i]=olevel[tal];

	end;
	output;
end;



run;

data ct03;
set ct02;
Array level[8] 8. level1-level8;


	/*inc*/
	inc=1;

	do i = 1 to ant_level-2;
		if level[i] >= level[i+1] then
			inc=0;
	end;

	/*inc*/
	dec=1;

	do i = 1 to ant_level-2;
		if level[i] <= level[i+1] then
			dec=0;
	end;

	/*step size*/
	size = 0;

	do i = 1 to ant_level-2;
		if abs(level[i] - level[i+1]) > size then
			size = abs(level[i] - level[i+1]);
	end;



	safe = 0;
	if (inc or dec) and size <= 3 then safe = 1; 

run;

proc sort;
by report descending safe;
run;

proc sort nodupkey;
by report;
run;

data Part2(keep=Part2);
set ct03 end=eof;;
where safe = 1;

Part2 = %eval(&Part1) + _N_;
if eof;
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
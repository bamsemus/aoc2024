/*
data ct;
  infile datalines truncover;
  input  ft $20000.;
	
	retain lang 0;	

  	len = length(strip(ft));
	
	if len > lang then lang = len;

	call symput('antobs',strip(put(_N_,8.)));
	call symput('maxlen',strip(put(lang,8.)));

  datalines;
Register A: 729
Register B: 0
Register C: 0

Program: 0,1,5,4,3,0
;

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
Register A: 117440
Register B: 0
Register C: 0

Program: 0,3,5,4,3,0
;

run;
*/
/*
Register A: 729
Register B: 0
Register C: 0

Program: 0,1,5,4,3,0
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
Register A: 28422061
Register B: 0
Register C: 0

Program: 2,4,1,1,7,5,1,5,4,2,5,5,0,3,3,0
;

run;




/*
org: 
Program: 0,1,5,4,3,0
*/

data ct01(drop=ft len lang) ;
set ct end=eof;
retain regA regB regC;
if index(ft,'A') then regA = input(scan(ft,2,':'),10.);
if index(ft,'B') then regB = input(scan(ft,2,':'),10.);
if index(ft,'C') then regC = input(scan(ft,2,':'),10.);

if index(ft,'P') then str = scan(ft,2,':');

if eof then do;


ant_prog = countc(str,',')+1;
call symput('ant_prog',strip(put(ant_prog,8.)));

output;
end;

run;

%put &=ant_prog.;



data ct02;
length pointer opcode Operand ComboOperand 8. outp $1000.; 
set ct01;

array prog[%eval(&ant_prog.)] 8. prog1-prog%eval(&ant_prog.);

do i = 1 to %eval(&ant_prog.);

prog[i] = input(scan(str,i,','),8.);
/*prog[j] = cats(mod(int(i/4),2),mod(int(i/2),2), mod(i,2));*/

end;

/*

2,4 regB = mod(ComboOperand,8); 		=> mod(regA,8);
1,1 regB = bxor(regB, Operand); 		=> bxor(regB, 1);
7,5 regC = int(numerator/denumerator);  => int(regA/2**ReGB);
1,5 regB = bxor(regB, Operand); 		=> bxor(regB, 5);
4,2 regB = bxor(regB, regC); 			=> bxor(regB, regC)
5,5 out = strip(put(mod(ComboOperand, 8), 1.)); => out = strip(put(mod(regB, 8), 1.));
0,3
3,0 Hop

2,4 regB  		= mod(regA,8);
1,1 regB  		= bxor(regB, 1);
7,5 regC 		= int(regA/2**ReGB);
1,5 regB 		= bxor(regB, 5);
4,2 regB        = bxor(regB, regC)
5,5 out = strip(put(mod(ComboOperand, 8), 1.)); => out = strip(put(mod(regB, 8), 1.));
0,3 regA 		= int(RegA/2**3);
3,0 Hop			= loop

2,4 regB  		= ;
1,1 regB  		= bxor(mod(regA,8), 1);
7,5 regC 		= int(regA/2**ReGB);
1,5 regB 		= 
4,2 regB        = bxor(bxor(regB, 5), regC)
5,5 out = strip(put(mod(ComboOperand, 8), 1.)); => out = strip(put(mod(regB, 8), 1.));
0,3 regA 		= int(RegA/8);
3,0 Hop			= loop

*/

pointer = 0;

do mange = 1 to 100;


if pointer>15 then do;
leave;
end;


opcode = prog[pointer+1];
operand = prog[pointer+2];



if operand <= 3 then ComboOperand = operand;
else if operand = 4 then ComboOperand = regA;
else if operand = 5 then ComboOperand = regB;
else if operand = 6 then ComboOperand = regC;

/*
put "Opcode: " Opcode;
put "Operand: " Operand;
put "Combooperand: " Combooperand;
*/

/*put "opcode: " opcode;
put "operand: " operand;*/

if opcode = 0 then do;

	numerator = regA;
	denumerator = 2**ComboOperand;
	regA = int(numerator/denumerator);
	pointer = pointer+2;

	/*
	put "numerator: " numerator;
	put "denumerator: " denumerator;
	div = numerator/denumerator;
	put "div: " div;
	put "regA: " regA; 
 	*/

end;
else if opcode = 1 then do;

	regB = bxor(regB, Operand);
	pointer = pointer+2; 

end; 
else if opcode = 2 then do;


	/*put "ComboOperand: " ComboOperand;*/ 
	regB = mod(ComboOperand,8);
	pointer = pointer+2; 
	/*put "regB: " regB;*/

end;
else if opcode = 3 then do;


put "mange - hop: " mange;
put "regA: " regA;
put "pointer for: " pointer; 

	if regA = 0 then do;
		pointer = pointer+2; 
	end;
	else do;
		pointer = Operand;
	end;

put "pointer eft: " pointer;


end; 
else if opcode = 4 then do;

	regB = bxor(regB, regC);
	pointer = pointer+2; 


end; 
else if opcode = 5 then do;

    out = strip(put(mod(ComboOperand, 8), 1.));
    if missing(outp) then outp = out;
    else outp = catx(',', outp, out);

	pointer = pointer+2; 

	put "mange: " mange;
	put "outp: " outp;
	/*leave;*/

end;  
else if opcode = 6 then do;

	numerator = regA;
	denumerator = 2**ComboOperand;
	regB = int(numerator/denumerator);

	/*
	put "numerator: " numerator;
	put "denumerator: " denumerator;
	div = numerator/denumerator;
	put "div: " div;
	put "regB: " regB;
*/

	pointer = pointer+2; 

end;  
else if opcode = 7 then do;

	numerator = regA;
	denumerator = 2**ComboOperand;
	regC = int(numerator/denumerator);
	pointer = pointer+2;

	/*
	put "numerator: " numerator;
	put "denumerator: " denumerator;
	div = numerator/denumerator;
	put "div: " div;
	put "regC: " regC;
*/

end;  



/*put "pointer: " pointer; 
put "eft regA: " regA; 
put "eft regB: " regB; 
put "eft regC: " regC; */
/*put "outp: " outp;*/

/*
put "pointer: " pointer; 
put "Opcode: " Opcode;

*/

end;


/*

if pointer > 6 then leave!

*/

run;





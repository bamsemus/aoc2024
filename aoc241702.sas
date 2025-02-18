data v;
f = mod(22206,8);
run;

7,5, dvs ComboOperand = RegB

	numerator = regA;
	denumerator = 2**ReGB;
	regC = int(numerator/denumerator); => regC = int(regA/2**ReGB);
	pointer = pointer+2;

/*

	Org_regA: 820866749
Org_regA: 820867005
Org_regA: 829255357
Org_regA: 829255613
Org_regA: 837643965
Org_regA: 837644221
Org_regA: 1892841909
Org_regA: 1894608573
Org_regA: 1894608829
Org_regA: 1902997181
Org_regA: 1902997437
Org_regA: 1911385789
Org_regA: 1911386045
Org_regA: 2968350397
Org_regA: 2968350653
Org_regA: 2976739005
Org_regA: 2976739261
Org_regA: 2985127613
Org_regA: 2985127869

	*/

/*	Program: 2,4,1,1,7,5,1,5,4,2,5,5,0,3,3,0 */

data ct02;
/*length pointer opcode Operand ComboOperand 8. outp $1000.;*/ 
set ct01;

RegA = 5013381850;
org_regA = regA;

array prog[%eval(&ant_prog.)] 8. prog1-prog%eval(&ant_prog.);
/*array res[%eval(&ant_prog.)] 8. res1-res%eval(&ant_prog.);*/

do i = 1 to %eval(&ant_prog.);

prog[i] = input(scan(str,i,','),8.);
/*prog[j] = cats(mod(int(i/4),2),mod(int(i/2),2), mod(i,2));*/

end;

do until(regA=0);
regB  		= bxor(mod(regA,8), 1);
regC 		= int(regA/2**ReGB);
regB 		= bxor(bxor(regB, 5), regC);

out 		= mod(regB, 8);
put "out: " out;

regA 		= int(RegA/8);
end;


run;



data ct03;
/*length pointer opcode Operand ComboOperand 8. outp $1000.;*/ 
set ct01;

org_regA = regA;

array prog[%eval(&ant_prog.)] 8. prog1-prog%eval(&ant_prog.);

do i = 1 to %eval(&ant_prog.);

prog[i] = input(scan(str,i,','),8.);

end;

do stor = 296 to 303;

RegA = stor;
Org_RegA = RegA;

resnr = 0;
do until(regA=0);

regB  		= bxor(mod(regA,8),1);
regC 		= int(regA/2**ReGB);
regB 		= bxor(bxor(regB, 5), regC);


out 		= mod(regB, 8);
resnr+1;
if prog[resnr] ne out then do;
RegA = 0;
end;

else do;
/*put "resnr: " resnr;
put "out: " out;*/
if resnr > 2 then do;

str = strip(put(resnr,32.))||'_'||strip(put(Org_regA,32.));

	put "Org_regA: " str;

end;

regA 		= int(RegA/8);
end;

end;


end;

run;

/*	Program: 2,4,1,1,7,5,1,5,4,2,5,5,0,3,3,0 */

data ct02;
/*length pointer opcode Operand ComboOperand 8. outp $1000.;*/ 
set ct01;

RegA = 152995;
org_regA = regA;

array prog[%eval(&ant_prog.)] 8. prog1-prog%eval(&ant_prog.);
/*array res[%eval(&ant_prog.)] 8. res1-res%eval(&ant_prog.);*/

do i = 1 to %eval(&ant_prog.);

prog[i] = input(scan(str,i,','),8.);

end;

do until(regA=0);


out 		= mod(bxor(bxor(bxor(mod(regA,8), 1), 5), int(regA/2**(bxor(mod(regA,8), 1)))), 8);
put "out: " out;

regA 		= int(RegA/8);
end;


run;

/*	Program: 2,4,1,1,7,5,1,5,4,2,5,5,0,3,3,0 */

data loopct02;
/*length pointer opcode Operand ComboOperand 8. outp $1000.;*/ 
set ct01;



do j = 5013381848 to 5013381855;

RegA = j;

put "RegA: " RegA;

org_regA = regA;

array prog[%eval(&ant_prog.)] 8. prog1-prog%eval(&ant_prog.);
/*array res[%eval(&ant_prog.)] 8. res1-res%eval(&ant_prog.);*/

do i = 1 to %eval(&ant_prog.);

prog[i] = input(scan(str,i,','),8.);

end;

do until(regA=0);


out 		= mod(bxor(bxor(bxor(mod(regA,8), 1), 5), int(regA/2**(bxor(mod(regA,8), 1)))), 8);
put "out: " out;

regA 		= int(RegA/8);
end;

end;

run;

data xx;

maal = 5013381850;

do i = (maal-1)*8 to (maal+1)*8;

regA 		= int(i/8);
if regA = maal then output;
end;

run;



data x;


x = 164278496489149;
regA = x;


do i=1 to 16;
put "regA: " regA;
regA = int(regA/8);

end;
put "regA: " regA;

format x 32.;
run;


data f;
max_bxor = (2**32)-1; /*giver kun 11 decimaler*/
i_hvertfald = 164278496489149
				;

format max_bxor i_hvertfald 32.;
run;



data loopct02;
/*length pointer opcode Operand ComboOperand 8. outp $1000.;*/ 
set ct01;



do j = 5013381848 to 5013381855;

RegA = j;

put "RegA: " RegA;



do until(regA=0);


out 		= mod(bxor(bxor(bxor(mod(regA,8), 1), 5), int(regA/2**(bxor(mod(regA,8), 1)))), 8);
put "out: " out;

regA 		= int(RegA/8);
end;

end;

run;
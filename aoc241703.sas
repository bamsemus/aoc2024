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



/*	Program: 2,4,1,1,7,5,1,5,4,2,5,5,0,3,3,0 */

data ct02;
length xstr $64.;/*length pointer opcode Operand ComboOperand 8. outp $1000.;*/ 
set ct01;

RegA = 5013381850;
org_regA = regA;

array prog[%eval(&ant_prog.)] 8. prog1-prog%eval(&ant_prog.);
/*array res[%eval(&ant_prog.)] 8. res1-res%eval(&ant_prog.);*/

/*
array binB[64] $1. binB1-binB64;
array binC[64] $1. binC1-binC64;
array xor[64] $1. xor1-xorC64;
*/

do i = 1 to %eval(&ant_prog.);

prog[i] = input(scan(str,i,','),8.);
/*prog[j] = cats(mod(int(i/4),2),mod(int(i/2),2), mod(i,2));*/

end;

/*do until(regA=0);*/

regB		= mod(regA,8);
regB  		= bxor(regB, 1);
regC 		= int(regA/2**ReGB);
regB 		= bxor(regB, 5);

/**/

bin_regB 	= put(regB, binary64.);
bin_regC 	= put(regC, binary64.);

xstr='';
do k = 1 to 64;
b = substr(bin_regB,k,1);
c = substr(bin_regC,k,1);

if b='0' and c='0' then str='0';
else str='1';


if k=1 then xstr=str;
else xstr=strip(xstr)||strip(str);

 

end;



/**/

regb_ny = input(xstr,binary64.);
regB 		= bxor(regB, regC);

out 		= mod(regB, 8);
put "out: " out;

regA 		= int(RegA/8);
/*end;*/

format regb_ny 32.;
run;


data num;


    number = 626672733; /* Input number */
    binary = put(number, binary64.); 

	num_again = input(binary,binary64.);

format number num_again 32.;
run;

data g;
b1='0100000000011000000000000000000000000000000000000000000000000000';
b2='0100000111000010101011010010001000101101100000000000000000000000';

f = length(b1);

b1num = input(b1,binary64.);
b2num = input(b2,binary64.);

_bxor = bxor(b1num,b2num);

b_bxor = put(_bxor,binary64.);

format b1num b2num 32.;
run;


/*	Program: 2,4,1,1,7,5,1,5,4,2,5,5,0,3,3,0 */
/*



# Import necessary modules
def bxor(x, y):
    return x ^ y  # Bitwise XOR in Python

# Outer loop over the range
for j in range(5013381848, 5013381856):  # Python `range` is inclusive of the start, exclusive of the end
    regA = j
    print(f"RegA: {regA}")

    # Inner loop until regA becomes 0
    while regA != 0:
        out = (bxor(bxor(bxor(regA % 8, 1), 5), regA // (2 ** bxor(regA % 8, 1))) % 8)
        print(f"out: {out}")

        # Update regA
        regA = regA // 8


*/

data xx;

maal = 20534812061143;

do i = (maal-2)*8 to (maal+2)*8;

regA 		= int(i/8);
if regA = maal then output;
end;

format maal i 32.;
run;


RegA: 164278496489149
out: 2
out: 4
out: 1
out: 1
out: 7
out: 5
out: 1
out: 5
out: 4
out: 2
out: 5
out: 5
out: 0
out: 3
out: 3
out: 0

/*
164278496489149
20534812061143
2566851507642
320856438455
40107054806
5013381850
626672731
78334091
9791761
1223970
152996
19124
2390
298
37
4
*/
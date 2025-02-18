

data top(drop=top lang len) bund(drop=top);
set ct;
retain top;
if _N_ = 1 then top=1;
else if ft = '' then top=0;

ant_c = countc(ft,',')+1;
if top then call symput('ant_c',strip(put((ant_c),8.)));

if top and ft ne '' then output top;
else if ft ne '' then output bund;

run;

data top01(keep=_top _len _simple);
set top;

kort = 999;
lang = 0;

do i = 1 to &ant_c.;

_top = strip(scan(ft,i,','));
_len = length(_top); 

_simple = verify(strip(_top),'bgrw');

if length(_top) > lang then lang = length(_top);
if length(_top) < kort then kort = length(_top);


if _len = 1 or _simple > 0 then output;
end;

call symput('top_lang',strip(put(lang,8.)));
call symput('top_kort',strip(put(kort,8.)));
run;

proc sort; by descending _len _top;run;


data _NULL_;
set top01;
 call symput('ant_c',strip(put((_N_),8.)));
run;

%put &=top_lang;
%put &=top_kort;
%put &=ant_c;

/*delete top that can be made os 1 og 2*/

%macro skriv;
length 
%do q=1 %to &ant_c.;

top&q.  $&top_lang.. len&q. 8.

%end;
;
%mend;

data top02(drop=_top _len _simple);
%skriv;
set top01 end=eof;
retain top1-top&ant_c.   len1-len&ant_c.;
array top[&ant_c.] $&top_lang.. top1-top&ant_c.;
array len[&ant_c.] 8. len1-len&ant_c.;

top[_N_] = strip(_top);
len[_N_] = _len;

if eof;
run;

data top03;
set top02;
array top[&ant_c.] $&top_lang.. top1-top&ant_c.;
array len[&ant_c.] 8. len1-len&ant_c.;


/*len = 3*/
do z = 1 to dim(top);
	if len[z] = 3 then do;
	z_leave = 0;
		/*put "dim[z]: " top[z];*/
		do a = 1 to dim(top);
			if len[a] < 3 then do;
				do b = 1 to dim(top);
					if len[b] < 3 then do;
						if strip(top[a])||strip(top[b]) = top[z] then do;
							/*put "top[z] = " top[z] =", top[a]: " top[a] ", top[b]: " top[b];*/
							top[z] = '';
							len[z] = 99;
							z_leave = 1;
							leave;
						end;
					end;
				end;
			end;
			if z_leave = 1 then do;
				leave;
			end;
		end;
	end;
end;

/*len = 4*/
do z = 1 to dim(top);
	if len[z] = 4 then do;
	z_leave = 0;
		/*put "dim[z]: " top[z];*/
		do a = 1 to dim(top);
			if len[a] < 4 then do;
				do b = 1 to dim(top);
					if len[b] < 4 then do;

						do b = c to dim(top);
							if len[c] < 4 then do;


						if strip(top[a])||strip(top[b]) = top[z] then do;
							/*put "top[z] = " top[z] =", top[a]: " top[a] ", top[b]: " top[b];*/
							top[z] = '';
							len[z] = 99;
							z_leave = 1;
							leave;
						end;
					end;
				end;
			end;
			if z_leave = 1 then do;
				leave;
			end;
		end;
	end;
end;

run;

/*
data top03;
set top02;
array top[&ant_c.] $&top_lang.. top1-top&ant_c.;
array len[&ant_c.] 8. len1-len&ant_c.;

do a = 1 to dim(top);
	do b = 1 to dim(top);

	str = strip(top[a])||strip(top[b]);

		 do c = 1 to dim(top);

		 	if strip(str) = strip(top[c]) then do;

				put "top[a]: " top[a] ", top[b]: " top[b] ", str: " str; 

			end;
		 end;
	end;
end;
run;
*/


%macro skriv;
length 
%do q=1 %to &ant_c.;

top&q. trn&q.  $&top_lang.. len&q. 8.

%end;
;
%mend;

/*
data top03(keep= _top _len);
%skriv;
set top02;

array top[&ant_c.] $&top_lang.. top1-top&ant_c.;
array trn[&ant_c.] $&top_lang.. trn1-trn&ant_c.;

array len[&ant_c.] 8. len1-len&ant_c.;

do i = 1 to dim(top);

	trn[i] = top[i];

end;

do i = 1 to dim(top);

	if len[i] > 2 then do;

		do j = 1 to dim(top);

			if len[j]< 3 then do;

				trn[i] = tranwrd(strip(trn[i]),strip(trn[j]),'&');

			end;

		end;

	end;

end;


do i = 1 to dim(top);
	trn[i] = compress(trn[i],'&','');
	if strip(trn[i]) = '' then do;
		top[i] = '';

	end;
end;



do i = 1 to dim(top);

	trn[i] = top[i];

end;

do i = 1 to dim(top);

	if len[i] > 3 and trn[i] ne '' then do;

		do j = 1 to dim(top);

			if len[j]< 4 and trn[j] ne '' then do;

				trn[i] = tranwrd(strip(trn[i]),strip(trn[j]),'&');

			end;

		end;

	end;

end;


do i = 1 to dim(top);
	trn[i] = compress(trn[i],'&','');
	if strip(trn[i]) = '' then do;
		top[i] = '';

	end;
end;


ant_top3 = 0;
do i = 1 to dim(top);

	if strip(trn[i]) ne '' then do;

	_top = top[i];
	_len = len[i];

	ant_top3+1;
	call symput('ant_top3',strip(put(ant_top3,8.)));

	output;

	end;

end;


run;
%put &=ant_top3;
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
bubgb, buburr, rrrbrr, wubgbb, gggbw, wrr, rrbu, wbw, gubr, bruu, bub, rww, gguubguu, wwb, ugbrrw, burur, rgwwb, ugu, bbu, rug, uwwb, ggw, bgb, wbru, uuwrrrg, uuug, gur, urguw, ugru, urbwggg, bru, rgug, guu, g, grwr, rbuwb, bbr, wgbr, gubrw, rwrgb, rbw, buw, gbg, wrw, wrbrwg, gbrg, urgubgb, uwg, wggubgr, rgrub, bwuugrwr, gurgu, bur, wwgwwbu, bbbrgu, wbggru, wbuur, rgubg, rwww, br, wbr, wgrrggb, wwuubgg, gbu, uuu, rwbwb, uwugrgu, bugrgwwu, wgwbb, bgwwggr, wgbb, rubbr, ugbrbgub, urg, uruuwu, ggb, rgwwg, guw, uruur, wbgbr, wrbrbw, rrrggr, rgw, rgbgwbu, uru, bwgbgr, wwgg, ggbrgwr, rwgurruu, uwbr, rwur, uu, uugr, wg, wbuwuwr, bwbu, bgw, gbr, uugb, bubw, wrg, ugw, rwb, ww, rrggrb, ugww, bbw, wbb, ubbrwr, wrwr, uwbb, uwr, ugrg, ruu, gbw, gwurr, wwu, bbg, wbbw, rgww, wwbb, wuu, wwbwr, uugbwb, bbrw, wguwr, rugr, rgb, ubb, wrgr, grrrw, rrb, burwr, www, uub, wgbbwbb, rw, rbww, uwu, ugb, ugrw, ruuuubb, uwbbw, rgg, wuw, grbbw, gbru, rb, gwrwr, bgg, gwuug, rgu, bugrbb, rrrr, rubwu, bgbbu, wbgubbg, wwwuw, wwrb, uwgbg, rur, rbbu, rbr, rrrbwb, rgggugu, bgwuu, rbwgrbg, gbwwuuru, gg, wgru, grrub, ruurb, urgw, wuurgw, bbbgwww, gwb, gwwb, rbuw, ruuwwg, uuw, brggrw, wubgwu, ubw, ubgb, wbu, bubrrgww, wbg, brw, bggrrr, uwubw, wbbugu, bgu, rrbbww, ru, wbgbw, ggrwrugg, bwbwg, gbb, urwrrb, uuwuggr, gugw, urb, wbwbwrrb, grbwb, wwwgg, gwu, buwg, ug, gruwgub, gbgr, bgbbuwwr, rbb, ubuw, gww, b, wggg, wuwgub, gbbbbu, wgr, gwwbw, wurrb, gurw, rbur, brbrbrb, rgbu, ggbrb, rgggr, wwbrr, rrw, wur, urwwbgu, wubuwu, wwbu, bg, bbru, bgrguuuu, uwbru, bruburb, ugwrb, rbrwbgg, ugwru, ubu, ggwb, buu, burrbw, wr, rrrw, uuru, uurbbbb, wubrgb, gb, wbwwrug, rbu, bwrrww, uuwggrbb, gw, brg, uwrr, rbwb, rub, gggwr, gbbg, gwgb, rubggu, gbgu, wgb, brwurg, rrru, burg, rrbb, ubugub, uuwg, uwgu, grr, guwwww, gwg, grggg, ggwggbgb, wru, uurwwu, gbbbr, bbbb, brgu, buwgrr, grwgwu, buwbw, rru, gubwg, gub, wwr, gubgwg, buub, wrbbuw, urr, wu, bbgb, bw, uubb, ggrwrguw, wbgrrb, rrbuurb, ubwug, ggwww, bgrr, rgrgb, ur, brwuwbg, bubb, grruwwub, wurr, buuwbw, r, bu, brb, bgrurwb, bggrwg, rwu, wrwwbb, wbbugr, gggb, brbb, bwbuw, rwgurb, bgbuurg, buwb, uugu, ubwbggb, rruw, bggg, ubbrbw, grrr, bbruug, wgg, rwubgrgb, uubrruwr, wgbrb, bwb, gubrb, gwuurg, ggbr, wwg, ruww, bb, ggg, rgr, bww, gwburgwr, urw, gbbgb, rwg, bgr, ub, gwwug, bug, rr, rg, wrb, rrg, gggw, wwbbg, uwb, wwrw, bgbwrbg, ggrr, wug, wwuwww, bgrubw, gru, bubbgw, gwuww, gbggbb, gwbu, bgbugrb, wwrbr, ubbgr, brub, ugbwubug, uww, rugrb, rgbuu, w, wrrbw, rbg, rururwb, grbrwbwu, brurwb, ubgwrrr, ruw, bbrrrwu, ruwgw, rbrwu, rrgurg, ururbww, bbb, ugbb, bwu, wugb, uwrurwg, bwg, bggw, gug, bbgubw, uug, uur, grwwu, rrug, brgbbru, ggu, brwbu, grw, rwr, ubwbu, wbbb, wubrwg, gbgg, ugg, bbggub, gwr, ggub, wwgur, bwrw, rwbuw, wb, rbbr, urbb, gbggg, grg, ggwu, uwurgg, wbugug, ugr, rrbwr, gwuur, uwbgr, brrb, ubg, uuugwu, gr, bgbb, wggr, ggr, bwguw, ugubwbu, wgw, grb, wub, wbuww

wwwuwbugbggrwuwgwgbwwwgguggguguwbgguurbbbwgrubrgb
wbbwbrbrwwugbruubgurgwbbwwgugbbbbrbbbrwwwgrrrbgubwubwru
gwwgwbgbgbuugwurgggwrubrruuwgbwgwrgwrbwrugwwrrugrwgu
gbubwbrgugwrurggguruugbrwugrgwggrubgruuwubruuwwguggu
wwgrrgwguwugbgrbbguwguwubwuwwwuggguubuwgrwrrwwwuwbr
bbuwgwgwwwgrrgrbrwrwrbwwwbgrbrgwwwgbrgrubgwuguggwrburu
wuwbgbbrurwwwrbbubuwgwgwubbugrrurguurgguburbuugrw
gggwguwbbuwubgurrgwugwbubwbwguuwwbrwgwrgrbrggugu
gbbgggwgbbgwgguuurbbwggrrbugrggruwgrwgbgrbbruwwwrrwwgrww
grbrwggrurrwwrbuggugurburrrbrrrwwugrugrrugwruwrrgbg
urgbruwwurugbbbwgbruwgrubrrugrbwwruwuwrrubuggrwrgugbgbg
wgrbugrbbgrugrrbubgbubuwbrbuuuwuubrgwrwwrgwwburbrgwrbw
rururrurwwuurrrrgwgbugwubwwbubuuuwwbwbruuwugrbwuwbugw
uwwwwuurbwbguwruwwgggbggubbwwggbrbgrwgubrubguwwu
wgrwbgubgurbwrwwwrurwrbuggggurbrwwbrwubwrwgugurgururwu
gwwrbwwgwurgrwwguggubwwuuggrwbbggbuguwgrubbwbrwub
ubbrwwwbgbuuubggguwwbrggruwbrrwgrbggwuuuuggwu
wwwbrggrrgubwgrrbwwrrurrrugrubgrrgggbrwbrbuuwgrrrruwr
rgwbrbrugugwrbbrrbwrwrrgwggwurugurwwgugbrrbbbww
grwgggbrwurrrgbrwrrrubuwbwuwguuwbuuguuguwwbggwbguwrbb
wbgbgrbburgubbgbwubrwgrgruggwbrrguugurgrgugubgurrwgrugbwbb
rurgrbrrwrrgrgbrrubrgbwbbgwrrrbbgbgwwubgrrrugru
gwbrbguwgrgwwgurrgwggbbgrurguggbwwbbrugrww
wubgrbwuwuugbrubbgbwurbuubbwwuuuwwgrruuuuwb
buubbgggrrbrrrrwgrggbwgwgwubgggbgwbgrgbwgwwwrwrgrgbubgrbw
buuggwugrggbbubrbrubbrgbgbrwrgwwbruguugrwwbrwrggwggbgbuub
ugrbrbrururrruuwrwgwgrwgbrwbrgwwururgrgwurbbgbrubrubww
buwwgubrugubbbwugggwbwbgubuuruubrwgbgrbwwrbwgu
bbbuuuwrwrbgrugwgwggrwgbwgrgburbgbgggbbggur
bggwwwubbrbrrubggrbgbwruwgggwrwuuguwwrwwrrrurgguuruu
gguwwbbrwrwgbruggrwrbbuwruwuuugurrbgbrruwburwgbrwg
gwurruwbbggwbrgbubwwwrwgrbrbwubugbbruuwwgr
gwrrgrwbgbugbgrruwuuuugwbbuwgggwbgbuwgurgrwwuwg
rrgwwgguubguurwbrbwrwggbbrbgrrbwgwwbbgwgu
bwrwugrwwguwrwugrbuwrbgwbubggbgrbubgwwgu
wrrrurruurbbuwugrwwrwggbgwubwwuurrbbuuuuuwwrwgu
rbguuwwbgbbwgrurwwwwuwrbgurwgbwgrbbubugrbguru
gwuwwruugwggwgbbuwrgbgbwwrbwrwwwubuwggwggwwgu
ubrrbggrbwburbuubwrrurrggrwuwuwrubbggrubgwwburgbb
rruwrurbwgurwbbgruruuubrrrrgbrrbgwurgwbrrgwwur
bwwgrwwwbgbbrbbuugrwbrggugrrruggwwwwwgbrbrwwrru
rrgwgwwwrgurwuwrwburwbrwurrgwrggbgrrrwbwwrurwburgwu
bugbrbrrwbwbgbwugggrurubbwrwgwgbguugrwuwbguwruwrrruubwurbw
rurrwggubbrbrubgrgrrgrrwrruuggwwuurwuurwrbrgguuwbgw
uruwbgrwrurbwbgrubgubbruwguugwrbbgggbbbbwgu
wwubugrgwwugrwwbwruuubrgggwguwwgrwubwgrugwubrwwurruuubbw
uubgbrgubrwwbubbuguwwurrbgurbbgwbuwuwubuubwubwugw
gugbwbwgggwbbbuurrgwurugwrrgubrrubbbguurgrbgbuwgrwrbbbugwgu
rurbrwbruurrgrwbuwuguwurwubgrgbbgugubbuburgguwugugbug
gbgwrwgrbuugrgruuwrrrrbguggubgbrbwwrugbbrwuggrwwguug
rbrbrgugbwwgggurrrwrbwwwggguguubwuugrwwgubbbuwbbgbbrbuwu
rwwgrubuugwrwbgbuwuwububwrrrrrbgubbrrwggrwggu
bbugwuurgbubgwwrgbugwbgugrburrwrbgwurgrgwgu
grwgbbwugwbrwwgrwwrwwwbbggrbuugwuuurwwurgbbuwrrw
bgwrbrbrwrwugrrububwbuubwwrbrbgggrrubgwbggu
gwwuuwbgugwugguwrrgrrwwwbrwbwbrrbuwwrbugbubwurb
ubrggrrwbguuwrburwbgbrggwrbbrbwuubbbwgurggwwbgrrggrwgbrg
uwrwwwbuugbwugrgbrggbgbwruwguurwbbwbbwbbrubrwbwgwuwg
urggubbgrrbgwrrurwgurgrubuubwburgggrgbgwrbbrgbgwrrubr
uugrrrbwbruwugbbruuubrwggurwwgrgrrrbuguwwwbwwubwburuugg
buwgbbbrugrbgbuwrbbrgugbwuuwruwgurbggbbwgwgwwgbwuuwgr
uuurgwgrguuuubwubbrbbubgggbrgugwururwuuurbwwwububgru
rgugrbwuwguwgugbwgrwuubrwubbrwubwbwubugwbgubguruwuwuuuu
buwgwgbbbrubuugbwurwuububwgbuwgrugbrrwrbuwrg
uwurwrwuubbwrgwuwbruruwuwwgbgbuuurrwgwbwbgwgu
gwrbubruwwbwbwwgwbuwwggwwwbbrrgbwuwrgubbbgrrrbgur
urggwbrggguwrrguurggwrrurrugrgububgwwgwrwbuuuwwgwgrb
uugubwwrwgrgwbwrurgurrubuwgrbgrguurwbrwggugggwbrwurwrwrbwg
wbwwurwgrbbwgubwuubwugugbbgbugwugbgbwgwugrwbgr
rurwrwrwbwgrwbrugwbbugbbwwguwgbwwrwggbwubbbwggwwgbuurr
ubwgwgwwuuwggrbbrgbrbrgwwbgbrwugguwuwgwrrguuu
wwwrrwburwggbwbgrruurbrugburwbrbgurrwgggbw
bwubgwgubbwwgwwuwwugrrwgrbubbggwwburbuuurg
rrurrgrbbbbrurbuuwwrbbrwuwwurrgwbgrwwgbuwrwgu
wbbrwgugburrugbgugrrbwugwbbrwgrbguwrgrgwwrggr
rbwubrburgwrrrbgguurbrugbgrbruguwrwubwwbwwgu
wgubbwuburwuwrurgrguurwwrwrwwgrbwrrrrbbugr
wggubbubwbrrrwwuubgwwuwrgrgwuwbwbbwuguguuwurbbwugwb
rubuwuwwugrbwgrggrwguwgbwgbrrwwrgurrwrwguuuwuggwrbgrubgwrg
urwruguwgbrggrbbbwgbrgwggwbguburggrwbgrbwwrbgrbwggguwgu
rwbgbubrugubwwrwwgwwurwwgrurrbwbbwgbbugrurw
ggrwbuuwbrurbgrrwbububruwurrruwwwbugbrgwbrwgbgbbgrgub
gurububrrbwbwruwrbbguwuuurugwwrgrbrgguwbwrbggugwwuwwbwru
rrbrwrubwgwuurugguwubrgrrwbgwugburrurgwrgbuurubug
bbrwgwggrbwgrrwrrwggububwurrrggrubggrgurbbuwrwrgrgubwgrgu
ubwbuwgrwrrguwbwuubbubgwwuuwgguuggbuwrrubrrrw
bubuwugurwrwuurbbgrggrurwwbrugrbwrgrbwgggruwgrbb
gbwgrbrwggbwgwrgrwwubrugubwugwbrrwbrurrbbbwuuubgur
bwrbgbrguuwruuwurwwbuwwggrbbrgrwuwuruwrurgguubwggr
rwbubgubwuguwbbrugggrrubbuwgrguurwgrggbrggrrgrbbbbrwgubbu
rwwwgrgubbrruugwurwbgbubbbgurbwwwrurruwwrrrw
rugrbwbbruuggubwwbwbrurrwgbwwggbbrgubgubrwbrurwbwg
gbuwrbrwbwgggrbbgbwrubwbggrugubbubbgggubrbb
bbwrwbwbrurrrrrgbgwwgwbgrrruwgbbuwuugubgugguurrb
bggbuurbgwwgubrwgbgrgrrwbgbgurwrguwrwwbbwgwr
grbrgwububguggbbuwbgbrubuwwrwwwgwbbrurbrrgwgu
bwgwwgrurbbggrgwuwwwgrbbrgburgrguuuwgwuwwubbggwwuggguurwr
ubwrwgbuuwrwuurgrbbubuggrbrggwwuwurrbwrwwgrbwgu
gguwubrwwwrgrwrguwrrggubwuwwuubwbgguubbbwuurwub
grrugubwgrbbuuubuububgbwugurbwrrubgbubrbrrbbguurgbu
gwgrrrruwgwwwwwrrgurggubwuububggrrgggbugwg
rbrbguwuggwwgrgrgrwuubrbbbbugbwguuggbrggguururuu
wburrubgrrrrrwwrrwgurugwwurwwrrwugggwgrggwwubbuwugu
rrwgwwgubbrgruubuggwwuburuwuwubbbrugbrubggrr
bgbbbrrwrrgbuwbgrwubrgwwwbrugrrrwbwwrbrgrrrurubuggr
brwugwrbubuuuggggrwwwwrbwgwrggbburuwbugrwrgbrubrggrwb
wburuwwbgubggbbbrbugwbubrwwrwwwbbgguwwuurgrwuwwgu
rbubugrgwwugwgrurggwugbrurgwuwwubugwwwgbguuwrwgu
rbgbwgwbuubbbwbbuwuuwuwuwuwrbrgwuuggwrruwrbgbrgguwuurbbwr
buuwurwggwrgwwbwbugubgbrwubrrubbwbuwgrwbwbg
brwuwwrwrgbrgruuuubwwbwbwrgrrwrugwwguwwrwgwwgrgwrrrgrwwgu
rbgrwbggbwwruugrbgbububgbwbbuwbugugwrrwbgwbwguwgrrwr
uuurwurrbuwrububbrgruwrbwbwbwrrbrrbrguggburwgu
wuwwuuburrgrbbbwuguwuwgwbbbgwrurubwrruggwbwbrugbrgubgwgwgu
brbbwuguwgggrgwwrrububrbbwuburbgbbugwwwrbuwbuggu
wugwuwwrruwbgwrbwruwrrgrbggbgrbwgggurggbrubruwugwuubur
rwrwwurbguwbbbwburuuruwrgbbguwbgwgggwggbwwgrbg
uggrggwugubuuwbwwwrbgrbrbrgbbrruggbuuuwrbrwwbuggwgrw
rubwwrbwggbubuwwrrgwurruwggbbubggbgrgwwrwrwgbgggbwbbu
bgwrguwwwrrwrgurrrrbbwggguwugbbbubbguwrrurbbrrrrb
bwuuwgrbbugbwgwuwgbgguwuububgbrbubrwgrubgbbwb
ubbruwrwguurwwwgwgugwgguubrurruwrubbgrurwwugbbrrgbwwrbw
wgwwgrggrbwgruwuwgwgbubwgguwbbggrgbgrgruwgwu
gbrruwwwwbgurubrwgwggbrrwrrwrbbrwwgburwwrrb
ubugrrruwgwuwubgbuurgguwwwgubrbbrruurrrbuwwg
wwwgrbrgbguwbwurwurgrwuurwrrggrggrbwuugrwrurbruuwwwggrrgg
wgrrgggbbuubrubrrgwrurwrwbggbuwwbgbrwbwgbbruwbugur
uwugwrrrwruubruwguuugwugwugurrbgurguuwwgbwrwguwggwbgwrw
grgbugubwwgwggbrwwwwuggwwbrgbrururggurwubr
ggrggburuuuwruburbwrgggurguggbbbbwguubgugwrwggrggwugwbrw
rrrrruwgwwrruwgrgwuuuwuwrwbrbbrgrgggwgrurrruurugbrbgub
uguguggwgwrbbbgrwuuwuubgbgrbwuggbbgguwwrwwguruwbbug
gbwgbwbrugugwgbwrubururrrggrgburugwrwwwguuggug
gbrrrgrgrgwrwbgrwrbrwwwgrgwgwuwbwrbrguruburbwru
bwuuururrwgwbwwwruwrurbbgbwgubwwurubgwbubbbwbb
wgrbgubuwbrwugrggbwbruuubgburbbwbrggwrggbbgbuwwurugbbgwbbu
bgrbgwwbbuwrgrubugbbbrbugrwuwuuugwugbrruwuurbbgg
rgrwgbgrguuwbbuwwbrguwrwgrbwgbrbbbwruwgrguwrgwrwrwuuruur
bbwruuwuuwrrbbubgburbwrwwrgwuugbwgbrurrbuguuugwbrubgbwbb
gburbbrggburubugwgbgbgbrwgbrgbggwbugugbrwbwbwrwwgu
wrwgwrrrrrubgwuburgbubrrgwwuuwrrrwbbwrwbrwwgurbwuurguubb
rubwwbugwrwgrwrggwrbrwbbubwgwbbwgbgbrbrrrbubbgguuwggw
ugugbbbbwbuubgwgwgwurwwrwubgrgbubwrrbugrbgrubwgu
ggwggbuwbgrgbgrrrbrggrwruggbwbwrrwrurwrrgg
rrwurgrbrwrrrburwuwuwrrwggwbrwggrwbgggrurggwwrrbguru
wuwurbrbwwbrggbubwuggbbrrbwwbgwbgbbrrbgurwu
bbgwwbgrgurgwwbgggrrgwgwwrbugwgbrguwgrgrurgwurguwbur
wrbuwgubugwgubrggubrgggbbubbggrwggbrgrurgubburwgu
grgwubgrgwbrgurrbgbbbgbrbubwbuwgwubwwwrgrrgrur
bwruwgubgwwgwuubgugugrugbubrgbrguuggbrbbbwwrggwrbbwwb
bgrgbwrurbwwgbwwwgbgwrrrbgwrgbwburubwugwrwgu
ugbrruwgwggrbrrrbuwgwurguggrgurrugggbwburgwrrgr
bwwrgurrbubbguwgrwgwuwrbbwugrrwgbwubgbgrbguwwrburr
wgrbbbubggbuggrgubrbbwbugwgwrwrgrguuwbbrwbrrgrurubwwuw
rwrwrggugruwgrruwbrruurbgguruwwubguggbbbwugrgugbwrgbuuwr
rurwruuwubwrrrbuurwgrubbuwgugwwwggwwrbbbrwruruggbwgrggwugwgu
wuuwrrggrgwwwwgrgrguuuwubgwwwwgrguggwwrubuggggguububuggbu
gbrwgggrburrrbuubbwgwbwuwgrbwbggwgugbwwubuuubrwwgrgbbgwgu
wwgurguggguruuwwuuugurggrugruwrbugwwubwbbrggruwrwuurrgrb
rrbwrwgwbugubgurrrwugbgrbbwgbgrgbbwbgbbruugugubw
rwgugbbbrbrrgubwrrruwubuwbugubwugrubwbgubrbbbwurbrgrw
gbwrggwwbuurgburuurrgwbgwwrubgubwbrwrbguuurbggggrguwbb
rwbbwgwwubugwwbwrubbbrgbrwrbuugrrrubgruwbugrbrrbgwgu
brgwwwuwbubrrbwgrggbrugubuguubbuubbwugbbbrburugwgrw
ugbwurrrburrbrurgrbbgbrrggbbruwwrgbgugburrbuuubbbwgbbrug
ggrguuggurgrrrbrurguggugbwbwwuwrbrbgbwrbubuggg
bggruuruurrwgrwwrrggurguugrwgurgburrwwwrgugg
wwrruugrgbbgrbugbwrbbrrgubwbbuwwgrrgggrggugruubrbubgrg
ggbuuubwgrrubgwgbrrruwrbrrgrwubgguuwbrbggbrwgu
gggbuuruubrrbrwwbwgbuuuwggwrubguggbwbgruuugwgruubbbbgubu
guugwwurwruburruwuugrgruwgwugguggubgurruwggrrgwgbuwrrrub
uurwrbrugrbwugbgggugrrwguuuguguurggrrbbwgu
uburbrgwbgubggwbrrrwruwbgbbuwwrwggbwgrubwrbwgwuuwwgu
ugugrgwgrwrbuwbbbrrwguwwrbwgrwrugugwuubrwwrbwrrugwwbub
rbgbwrwurrruwbuuwrugbbwuwububrrrgbrgwbwrgwruwbuwrg
wbrruwrbubrwbwgrugbrbggwgbwubwruwrgurubrbrrrwrrgbrrr
urwguwrwbrbbggubgbbbuwwrgrbrwgrbguruwgbuwbgbugwbwurrrgw
ggwrgrgbuurbbuwwgurrrwbrwubugwrurbgwuwububburgbggbwwbwwbbwgu
urrbrwuuwurgrgbrgbruwrrwrbbruwwbbbrwwugwbrbwbwbrgugrbbwg
wrwwwuugwbwubugbugrwgubgrrgwguwgwguuuwbbbrrbu
gbgwwgugrwrwrbbbbgbgbburugurggugugwgbrbwwggrrgwrbwbggbgwb
wgburbuuwrbgruugwwwuuuugugbgrgwrbbwuwuggwuuguwubwrwrg
guwubrbbbuwrurbgwrwgwwwbgwwgwwruwuuguuwwbbgrrb
brwrwgurbuubuwrgbrbuurwbwwbgrbruwrrrrgwuwggbrwurr
uwwuuwrbggrrbbrgwrbbbgggbrrwgbgbgwbwbgubwbrggbbrw
rgbguugwwggrbrgwbbburbubwgruubwwubwbrwgrwwuuwrbu
gbgbubgugguruwbwrwbrrbwgbbugggbbwrruwbgurrguwwubwgrbwwggur
rrubgwwrugrrbwbuurbrwgbbrrbbbrrggurwuuuwrggb
rwrwwugbgugrgrggurbugwugbwgburrrgrgbbwwgwuuruggbgwwrbuurbwgu
ubwrgwubuwwbuuggbwwuurubburbuwrrbwgwwgrggrwwrr
uwgbrgburuwrwrgbgrrbuwgrbuguuwggrbbrugwgrbgggbubgbggwbwgu
uuwbbbwuruwguwrbrgguwuurbwgrgrwrbwurwuburgrrgb
wurruuubrruwrubwbwwuurubwwgrwurgwrurwrbwgu
rgggubgrwgwgubwwwuwuwurrruruwbwgrrugguwgwrguwwr
uubbruwuwubbbbrbgwwggwburgwrbubgugwgwbwbbuuuruuwgurb
rwgbuwugrwwurbuggwugruurugbguubwugbrrwbbwgbgrwrbggwbbgrbwgu
wrubwruuwgrguuubgbbugrrbgwrrrruuggwrwgwgrrww
bguggrrwwburrrwuburbgurggbbwgrwwruugbwbuwwrbwrbbbgbwgb
urwgbwbuggrwgbgguwgubugrgwbbwwgwwgrrrguwrr
ugwrrrwrwugrugbbgruwguurbggurbrbubguuubbwrbb
ubuggwrbgwggggrwwwrugbrwbrbrwrwwrrrwgburbbugbggrwwbrgrru
grbgugurggurwuggugwwrwubbgrurburbwbwuugrwrwggrruugbuwwgu
rbgurwrguwbgwbgbbrggwwrugbwugrbwugggbubburbr
ububbuggggwwgwubrwuugbgggrwgbguwurgburgwwrguwuwugb
rgrwrruuruuggrwrrrgbwbububbruuwbrgrgggwugbwrbrur
rbuwuwwrggwgwggbgbuurwbgwgbbrggguwrurwwgggwwwugbuwgwwugug
rbbbuuwbugbruugggwugrgruwbbuwubwgrbgrwrbgwwwbgrwwu
uwwwgruurbbrwbggrrbrugrwrubgwuburuubgurubub
bbgugbgruuubwrbrrwrwgbrwuwurgurggwrbgwwbgruubruw
bgwrgwwrwbubrrbrbrbwbbbruwuwwbuwwuruggbgbrbrgr
ugrgwbbrgubbbbrubrggubbwuugggugbuwbgbwguuugggrwbwbubwbuw
wrgwuwubwrgrgurrwrwbrgurbbbbwbgbubuubuugubgrbbwbggugrrwgu
uwbgrubgbggbbbgbbbwgguubguuwgrrrgwgguuubru
gwwrbuurrugwwbbgugburrggrgbggrwuwgrgububrrbgwbrugwuggrug
bbgrwbrguubggwgbrugwwubwburbbbrgrbgrruguwrrbwurur
bgwbbgrrubwbgwgbwbbggwbwuuwrurwuburgububugbuwrwbgr
uwuuurbrbbrurggwgbguuuwuwbbbuwrrgurwgbwruwwrg
wgwuwugubbubgrgubwubwwurwurbrurrrwwgwrgrbwwruuubbug
gwbwbwrrbrgrgbggubbggugrbrwbwgugbubggrbrgrwwu
wrbuurrbbuwgrbugwrrrgguwwbguwgugrrgbrgwwuuwrbwgu
gwbbwurwrgbbgwwguggbggruwgurubgrrwbrwwwwrwbwbrwuwrwguu
wugburugrgugurrrbgwwwgubuuggubbgbgrgbwbuurbrugggwur
bbwwwrrwrgrwwgggbggrrubbgggrwbrrrwwwwrbrwwr
burbgggrbwrbgbrwrwbubgwrgbwgwwbrrugrruwrgbbggrwgwgu
rbuwgggrggbrwbrgwwwgwgbbggwggbgbubrbugburwwrgwgu
wgbrbbuugguuwuwgurrggwburrugwwugugwuuuurrbwwrrrbrwg
grbbgbbuwwruwggwbbgubwuuuruugbbrwgbrrbbbwrurubwgbrbbburu
wrwgrurgbwwgrwwrwurugbrbgubgwbwbggurrurubuwuguubwbrwgu
brrurgwrbwuwbbrbgggbwwwbuuwbwrrbrwbguwuwbrugbrrggwgu
uwuuubuguuuurbuuugwbwurrrubuwguubrruwrrgugwrrwgwbrgbub
wbrwrrrrbggbubrrgwwrguguurrrwbwuugwwggrwgwgu
rgrrwugwgrgugubugrrrwburgrurguwbgrwrwgbbwwgu
wgrwbrugbwwbbubwwrgwugubrurguuwggruuuggbbgggbur
rwbwbwgruuubwbgwurrruguugurgguuuururgrurgg
gurruuwbbrrgbuuwbwwgwwwggrurwbgbwurrwwuwbugbggbrg
bbugwbuwbuwbbbwgruwggbwgggurrurwuuwgguuwbgwwuguwurruggww
brbwrbwubbuwgbwwgbbruurgwrwguguwubuwrbrguwguuguugbbwwub
rugwwuwrrbwbrrgbuuurwwgwruuubrbwbggwurwuubbuuuuguu
uggwurwbwggwwubgwbwuuburgwrubwgwubwrbwgu
bgggbwrgbugrbrbgbwbwbbwguubruugwbguuurgubuwbbrubwwgu
ubgggrbbubruurbgurubrgguwruurrbrgbgbbwgwgbgrwgg
rrbbgwbgggugbuwgrwwwuugruwwgwbwrwgwuwbbgbubuwbbwrb
uwggbrrgbrwbbbwrrwbwuugrwrrwrbwgurggburbwgu
grbbwrggrbgbwwrwugbwubuguugbburuguubbwuuwbg
brugwrwuggrwwrwbwrbbbguurbgwgwguwwuurrrugwrrgurwgu
wurruruwrguuwbrubbuwgwurrggrrwwuuuggwgbrrugb
rrbrrurguggrwruggrrwrwwrbbwwwuruwbbgrrgwgu
guugggbgwwurwwgbwbgwgggbbgrguggbuuwbwurrgbwbgrgrr
gurwurbgrrgrbguwwbwbuwrwrrurbwgrubbwgwwwrurwbrrwrr
rgrwrrggbrgwwwuwbrruggubgrguuuuburgugrurbrgwrbwurbuguww
buugwrwrrgurgrgbuwurwwbwrwrbrrrgwwbruwgwwgggrgrrruurubuu
ubgbugrrwwbwrurwuwugwurggbwbbuwrggbwrbrurrbb
bwwbwuwbwubgrbwuwwuwrbbwbubwruwwbrgwuuurwugbruwuggwbub
rggwbgubwbbbbgwggrgbubbbbuwugrrgugwbrbruwrg
gruuwbgrgrgwggwwwwrrwgbwgrguwrwbguurwrbggwgu
rwgrbbwgbrgbggrubrbwwugrwgubbubbuugbbrggrrwrurburbr
buggugrwwrwwuuubguruwbubgrwwwbubggrgbbrrwr
burbrrubrrwgurguwuuurbrrrrugrbrbwbbwbguuwubgwru
ggrubgugurgbbbbubgbugruurbwrgbuubrbbrbwguugw
rggwubbbbubuubbgwwwgbrwrwggbgrgwgwgrbrwbwuuwguwwwbbrrrb
rrwgguwbgwrrubuuggbbrwgwurubwubbuugwbgbrbbbwwurruwgbubu
rrruuuuwuubwubwrrbguwgbrurwrrgwrrbuwuwwbgwgwwgu
gwuuwrubururgbgruuwwuwwwrrrwubuwwbbuwrgugwrbwgwgrugrrrrw
rwugbruurbbwgugbrugwwbgbwuwwwwbrrbuggurwbwbggbwubbur
bgggbrurwrwgurruugrgwgwbwbwuwurwuwgrbuwbubwbbb
gbbbuwrbgguwgrguububrbubggrbgbrwggbrwuwwgugugbb
wbwbguggrrbuwrggrwugguubbbbrbbuguuurugbrrrrbbggrruubgbbrub
bggbwwurguwguwbugbururrrrbwrwburrrgubbbwwrrubuwg
rbuwrbwubrrrrwwggrwwuburuwrrbgruwwguwuuguggrwrbgbrbugu
bwbrurgugwbbgrwrrbwrrrrwbgwbbwguwubwuuwgrrwr
rwuwwbgwbwbrugbbbgrwbrgbuwuguwrwgrgbgbggbggbbwwuwbbgwgwb
bwrurugbrurgbrguuwbubururuugwuuuwugbuuwwruwuurg
wgbrurwguwrbrbbrbrbggbgbbuugwgwuwrrrrgubggrruuwuuugu
gggrgbuwbbgbgurgwbbgrbwwwwgbbwrgugbgwwwgu
bbrwguwuubguuubbwwrugubgwrbuggbrgbguwurruruwruwwgr
bbbgrgbbrbbgruwrwwrgugwuwbubrwuwrwurbwbgubwwur
gwrbruwbbbbrbwgubwwrruuuuggwrrgwrbbrgrubgubwrbggbwgu
wwwwubgrrurggwrgwbrburwbwwbbbgrggbubugbrbbbuwbwbwbbg
wbwburwgwrwwwgrbuuwwrgrbuuuwwurwruuwgrwbwgruwrruruw
gwuurrwgrbwwggwgggwwuwgurbuuugrwgrbrwbwurwwbgwgu
ubgwuggwgrbwubgurggrbrbrgrwurrrbrgwrggbrwugurbwubrwg
brbgbbgguwgbugbrrurwwugurwbbwgwgbwruwwgwbuwwgugbwgrubrbg
uwgbwgwugbrwuwggbrrgbgbrbuwrwubwwgubruwgrbggbuwwbgggrwg
uuwuuuubwburgbwrwguwbwgubuwuwbbugruwwugwuubgrruw
bbgwgwbbruwbbwggrgwgwbwubrugrrgwbgbwguwwbrgrbgwgu
wbbgbwggwruguggbbgruuuuwuuugbbbwwgbwrruwrbgrgwggubrwgb
urrrrwbgwubgubbgrrbwbruugwurwuwggwgrrgrrgugrwwrggbuurgb
rwbrggrwgwugrrbuwbrrurggwgrugbrurrrbbwwrgbwgubrguwrugrgu
urwrrgrwugbuggbbgwurgbugbrbbgrguuuuugurrurbwrbrwgwgu
wbwrwbwubgbbgugrrrwurgurgrwrugugbbrbrbbgrwgwbwgrrbbgbguwg
rwbwuwrurubwuwwgbrwugrwuurrbbubgguwbugwwrgbrrb
buguurggwrubgwurrbugugbgubrgwbggwgrgwggruur
grruwwububurbgubgbwubrurbrbwguuwgwgbbrbguwbguu
brgugwwbgggrgwbbbrugugbwgrbwuwgbbruuwuwgburwbugwwguruuuwb
wburbwruwugurugrrwrbwgbwubuubrbuugrgrwgrgrbrbru
rgwrgwwuruwguuwwbgubwgwruwuguuwggubgubugurru
rwwrrbwbuuuuwwgwuwguubbruuurgbrbrrgwgwgrbuwrwwbbubr
wrbrrgrbgggubrwwrrubbrrrbbrburrgugbwurwrggwruwubgwwug
ubwwwrgwbwburwrgwrwwwuuugwruwwwbwwuwguwgrrurb
gugwbwrgugggbbuggwwwrwuurrrwruwwrbguwrrwwrrrgwgurgrubbuw
wwubrurwwrrbwwwurrwruwwwrwruwwgrrrrbuwbgbggwwgu
gurgguwggggruububggwwbgbgggwuggbrwbrbuguwgwgwurrrugw
rrrguruggugwbwrwgbuwwurugggwwgwguwggwrrwrgwwuguwbrgrwb
bbwguuuwbugbrbuwrururbuwubwguuwrrgwwruugguurbbrwgruuurbwwb
bwrrwbubguuwggwwuwrbwwgugrbrgwrbguuuggubwurggwwg
rggwrbgrrugrbgrbwbrwbruuwbrugurrwgbwggbwrr
bwggbrbrguwurwwubuwuggwgwggrbbggurgbbbwwbgwbwg
bruwbwwuuuwrwrbwwgwbubwwuwbgrgggugbbrbbruubwrggguubwwr
uwugbgrbgburbrrubburbggbbguruwururbbwguwbururbugbugwg
gbwurgrrbbrrrbggwgbugwurbgbrbbwugrwbgwgbubw
uggrrbubburgbrgbuwbrrgggrwgbuubgrwgrruuwrggrrwuuggww
uwgrgurgbggwguuurbuuuruuwruwrwrubburruguubbwwrwgubugbbwg
brwgurruuguguururruurwuwwbgrbbbwgrgrrggbwbbwgu
wguugwurrgugwbwgwbrbgrbgubwwgbwurburubuugbubbbgwrbwgu
wbggrwwbbbgubrguwugrgbwbgbrwugwgbgwwwwuuwugubrbrbrrb
rgrgrwwbgggggwurugrrubbbuggrgbgrwrwwruguwrrurgggwguwwgbwbw
gurgrurrwbuwuwbrugrbwwrgbwruurugwwuwrrgggurrrwwwuurwggug
rwgwubgbuwuggurrugburwwgbwbwrbugrbrgbrgwgrugbgrubwgrwruu
uubrwbwgwrrruurrwbuwbgrbuuuwwwubrrubrwgwbwbuwbgbrwrw
rgwggggwruubuwurgrgbwgubgbwururugwwbbgbruuuwgrruubwbwbwr
gguwbggwwbwwubrgurwgbwurggwwuuubgrbbbrwrbububrbwrbr
ugubguwwuwuburbruubrbubwbrburrrubrruwbuwbuuwwbwggwubwwwrwgu
ururbbgbwwbwrrggwwubrurbwugwbgugugbuwbrgbbggrb
rbburwgrbugwuuuwrrggbbbwbrgbwwuuruurrwgbrrwrbburwbugwgu
gwggbrwbwguwbwuuuuguwgbbggbubwbbgugbwuuuwwbwrbwbbuwu
brbrwguwbruwwgugrurwugrgrgrwrguwugbrggurgrbuw
wubbbwuwuwwubbwbuwbubugggrbbgguubuuwwbrruuuwbbwgu
gwuubwuurwruugbgruuwrgwgrubgbbbrwuuwruubgbbbgrww
wwbbwbrbguburwbuugwrwbubgwgrgugrwwbbgwuwuwrgrgwwbggbubuwbu
gubbwugwgubbrbruuwubggwrbrbwwrguuwwuwugwuuurrrwgrbwrubwgr
grubbburrwbgrbgbwgbruwuwwwgwrwbwrggubbbwgrggbwuurwwgu
bugbbgurwwbggwrwgbgbbgbugrgugrbwrgurggwbrwgu
gwruugubwugrrbbwbgwburgwrbbgrugrrbbuugrwwugbuburggbwgu
wugruwwbwbburrgrgwubruwwbbwrgubwbrrwwgbrbgbbwgurwbrg
guggrbwubbbbgguuwrrrurbbuwgrwugbubbrurguugrgbubwubwgub
guwurburbgwbbrgbwuggwbuguwwggrururwbwwguwgwwwwwwrggbr
bwbbwrrwwubwgbwgggwbgrrbwgbbggrrwwubbwwggugurw
rgrbwuwruwbuwrwgrwwrbbgugbbbburbuguuuuuuwugurwbwgu
uwbguwrbuggwwuwbwgbgugugurguwbrubgrwrrrggguwbgwrgggbgugb
brwuuggbgrwuggbwbggggguwwguuwwrbgrrwggbrwbgbburguuwrrwuru
bgrrgugrbrrwgggbbugurugubgbrrbggbrurubuwguggbwwwwggrrugugu
wgwbubruuwrrrruwwggugburbrurbbggubbwuurrwwuwwruub
gggbwrwrbbubuuwgurwgwbrugwbwbwuurrbwuggbbgbbbbb
bubugbwubugugwrwbuurwwwgwwuugbuuwurrgbugggwuwrrubwgu
uuubbwwwbuggbbwbbugubuggggruwrguuwrruwrwwggb
rubbrwwrbwbgggburrwwwrggggubrwbgguwwrrwrrrwruwggb
gwrrwuwugrubgwwugrwrrbwwubwwrruuwwgbguugwrwugwgbb
ggwbguburwgbbgggbgbgrbwwbgubgugubbrguuwggrwwrgrurubgwrwug
bgwbruwuwuwurwbuwrrwbrwwwwbguggbugbbrbbuurugrugr
wgbbrrgrruugggggggbrrrwwgwuurrbwwbuuugrwrggbrwugrgbwb
rrrugbrurrwbwrgggwuugrurruwgrrwgugrbbbbrwgg
gbbrbwbwrgggubbrrurbggbwrrbuwwuugbwrwurwbwrbgggwruruguurrr
urgwurbrbubbgubrrrbwgbgbgggrruuggwguggubbwrrw
rwgrubbwbugrwrugugurrrbrubwbwurggrubggugrbu
brggrgrbguuguuwwwrrrrwwgwbwbwrguugubbuuuwurrr
buwbwuuuguurrwbbgbgbrgbwwburwrggwurwwrbbgbbbburgbuwgrgbwb
rrwuuruwubrgbubwrggwrguuuugwwrburgwwwwguuuurbggwbgwbw
grgggbruuwgurrbubbwrbwbugbwrbgbbguubuubwggrrgwu
rrwuurgubbuwwuuuwwrwgwrrwbbggugbugrruwbuurbbrrbgrgbruuruwb
brgwgwwguggwwuruguurwgbgrwbbuwbbwbrwwuwbgubruubbugwrguur
bbugugwrrgruwguwwrgwrggwwwwubrguwwbwguuwrbwrb
wguwwwbgbggrrrrwwwgugugrrbwrwurruurbgwuwuwwrgur
ubrbruwwbrwrurbrwgubrbggwuurbgburgurguwwrwbrgugrr
brwrwwgggubbbbbrwwwwbruwrrbbgwwbugbgwrbrgruugrrguruuuu
bbbguwbubrbwwwwgwbgguurgwrggrgguubgwwwrwrbwggrw
rgguwuruwgrwuubwwggrrrgbgbuwwrbrwwrrrgrgwwuwurbburbw
wuwuwwgwwgbwrwbbruwuurrugubwrgrwgbuwrwgubgbwbbw
bwrugbwwwggrwrguwurrbwgugrgurbrubuggugburg
rrruugguwuuwruuuwwubrrgwbgwububbbbbbwuruggu
ugrbwugbwwuuuwwurubwrbrrrgburuwrurrwuburwr
wrgrwwbwbwuwbggrwwbwwbrrrbrbbrwwgwwgggbrguubguwwrg
bbrubbrwruwggurrubrbwbgbwbbbrruwurgggrwwbbwuwuguburbb
ubgbuuburwrwbgbwrwwguwbbrrbwrrwrbggrruubrgbugrwrrrrrb
brbwuwuugwubrwrguwgbuuwgguwgubrbuwgugbbbgbwrrbgr
uuwwrruwwbuwbbbuwwwburugububwgggbbggbrgwuuugrrgr
bbbugguwubbbuubwwwurbwwgrggwgggwruuurbrrwubbbuwwu
gubrubwwwbwwggggurbbguuwwwgwbwwrgrwuwubwrwbggwbbug
rwgubgbrgbbrbruggrwrguwuuruwwgugwuuuugubrruwgbgwgu
bruuubrgugbgrgbwwuuwwgwrgrgguuwgbbgwwbuubgbbrbguburgrww
rwgbgubbwwrwwbbrwuguugrrgbburrubrbgwrrgrrrwgwubbwg
wrggbwrbuurwrgwwgrwugwubbbubrrgrgbubrbruwwgrrrrbbrgwrbw
bbuuurugrwrgubrrubgwgwuwbgwuguwgwwrgwbwgbwbg
wbbugbuuububuuruubwuwbuubugrgwugruurgubgruwburug
bgurrbgrruwwubrgrrwbwuubbwwgburwwrguwgrrwgu
gbbugwrbuwrbrrwurbwwgubuwwwbrwbbrwguggrbwrwgbgwwgbugr
bgrgwbwuugrrwgbbgruwgbwurgbbgurrgwbgurgbbruwuubrrrbuurbbrwgu
rwbwbrrbbruwbwwgggrrruubgwwrrbwrugwwrurrgurggwuwbuugbugb
uuuwuwbrgbuwgggwrrbwbubgbrruurbwububbubbrwrwuu
wbburrrwurbuubbwbugrguwurrgurrbuuwrwuwuburwugugwwwgg
rwgbrbwurggwrgguwrbrrrgbrgbgwuwrwbwwwbbwgbrbguwrurubwgwwur
wggggrbwrrwwwurbbuggubrrgbuburrbwwgrbrgwbgbw
ggbgbbrbbgubuwuuwggrubrwbwrbrwbbrggwgwbbwgbrrbwgu
ubrwgurrruuugubrbwbrwuruwruwrrwrgrwgwguuwub
uwrwwbububwgggwgwgggrrguwwuuurbgbwwbbwgbrwwuw
bwrwwurrwbbrbwbubuuwwgrbbwuurbuwrwgbuurwbgwwuruubwgb
wwggguwbbwwbbwrggwbgwbwugguugggbburbbrruwbbuguggw
bgwwuuguururgurgbrggruwrwbbbrrububuwurrwuwbgwgugubub
uwrbgbwubwrbrgwwuwgrbubggwrbbgwruwgrwubgrbbwgw
wgubruwgbgwrguggwwuwguwrurwgubbugwurwbbgrrwgrwbwgu
rbwuurguwwrgurrwwbrbwururwuwrwwggugwbwrrbggrwuurrgbrubbwgu
;

run;
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
r, wr, b, g, bwu, rb, gb, br

brwrr
bggr
gbbr
rrbgbr
ubwu
bwurrg
brgr
bbrgwb
;

run;
*/
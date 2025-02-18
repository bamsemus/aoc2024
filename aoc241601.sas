%let lod_ant = %sysfunc(sum(%eval(&antobs.),%eval(&ekstra_lod)));
%let vand_ant = %sysfunc(sum(%eval(&maxlen.),%eval(&ekstra_vand)));
%put &=lod_ant.;
%put &=vand_ant.;

data _null_;
set ct;
retain tal 0;

do i = 1 to &vand_ant.;
if substr(ft,i,1) ne '#' then tal+1;
end;

call symput('djik_ant',strip(put(tal,8.)));
run;
%put &=djik_ant;

data ct02(drop=ft i lang len);
set ct end=eof;
retain %skriv_array_var(a=&lod_ant.,b=&vand_ant. ,at=gri , bt=d) ;

%skriv_array(navn=grid, type=$1.,a=&lod_ant.,b=&vand_ant. ,at=gri , bt=d);

do i = 1 to &vand_ant.;

grid{_n_,i} = substr(ft,i,1);

 
end;

if eof;
run;

data dir;

do dir=1 to 4;
		dL = mod(abs(dir-3),2)*(dir-3);
		dV = mod(abs(dir-2),2)*(dir-2);
output;
end;
run;

data Part1(keep=dji3k1 rename=(dji3k1 = Part1));
set ct02;
%skriv_array(navn=grid, type=$1.,a=&lod_ant.,b=&vand_ant. ,at=gri , bt=d);
%skriv_array(navn=tgrid, type=8.,a=&lod_ant.,b=&vand_ant. ,at=tgri , bt=d);

%skriv_array(navn=djik, type=8.,a=7,b=&djik_ant. ,at=dji , bt=k);

/*
1: lod
2: vand
3: dist from S
4: pre lod
5: pre vand
6: visited
7: dir [1-4:
  2
1   3
  4
]


*/

tal = 0;
do lod = 1 to %eval(&LOD_ant.);
	do vand = 1 to %eval(&vand_ant.);

	if grid{lod,vand} = 'S' then do;

	tal+1;

	djik[1,tal] = lod;
	djik[2,tal] = vand;
 	djik{3,tal} = 0;   /**/
	djik{4,tal} = 0; /*pre Lod 0 for starting*/
	djik{5,tal} = 0; /*pre vand 0 for starting*/
	djik{6,tal} = 0; /*havent visited S yet...*/
	djik{7,tal} = 3; /*facing east*/

	end;
	else if grid{lod,vand} = 'E' then do;

	tal+1;

	djik[1,tal]=lod;
	djik[2,tal]=vand;
	djik{3,tal}=888888;
	djik{6,tal} = 0;


	end;


	end;
end;

do mange = 1 to 10000;
/*visit tile closet to S - min(djik{3,tal})*/

/*find min - not already visited*/
	min=999999;
	do i = 1 to &djik_ant.;

		if djik{1,i} = . then do;
			leave;
		end;

		if djik{6,i} ne 1 and djik{6,i} ne . then do;

			if djik{3,i} < min then do;

				min = djik{3,i};
				min_djik = i;

			end;
		end; 

/*	put "min: " min;
	put "min_djik: " min_djik;
*/
	end;
 
djik{6,min_djik} = 1;

if min_djik = 1 then do;
leave;
end;

/*When visit explore posible reachable locations:*/

	do dir=1 to 4;
		dL = mod(abs(dir-3),2)*(dir-3);
		dV = mod(abs(dir-2),2)*(dir-2);

		/*put "dL: " dl "dV: " dv;*/

		/*is adjecent not wall*/
		if grid{djik{1,min_djik}+dL,djik{2,min_djik}+dV} ne '#' then do;

			noted = 0;
/**********/do i = 1 to &djik_ant.;
				if djik{1,i} = . then do;
					leave;
				end;

				if djik{1,i} = djik{1,min_djik}+dL and
				   djik{2,i} = djik{2,min_djik}+dV then do;

					noted = 1;
					/*if already visited then leave*/
					if djik{6,i} = 1 then do;
						leave;
					end;
					/*if noted but not visited, check if distance is shorter*/
					else do;
					/*is distance from min_djik less than pre noted:*/
						if dir = djik{7,min_djik} then alt_dist = djik{3,min_djik}+1;
						else alt_dist = djik{3,min_djik}+1+1000;

						if alt_dist < djik{3,i} then do;

							djik{3,i} = alt_dist;
							djik{4,i} = djik{1,min_djik};
							djik{5,i} = djik{2,min_djik}; 

						end;
					end;
				end;
			end;
			if noted = 0 then do;

				tal+1;
				/*put "noted: " noted ", next tal:" tal;*/
				djik{1,tal} = djik{1,min_djik}+dL;
				djik{2,tal} = djik{2,min_djik}+dv;

				if dir = djik{7,min_djik} then alt_dist = djik{3,min_djik}+1;
				else alt_dist = djik{3,min_djik}+1+1000;

				djik{3,tal} = alt_dist;
				djik{4,tal} = djik{1,min_djik};
				djik{5,tal} = djik{2,min_djik};
				djik{6,tal} = 0;
				djik{7,tal} = dir;

			end;

/**********/

/*

			next = mange 2, flytter den til v4 som den skal?

			*/
		end;
	end;
end;


/**/



run;

data ct03;
length Part1 start_lod start_vand slut_lod slut_vand 8.;
set ct02;
%skriv_array(navn=grid, type=$1.,a=&lod_ant.,b=&vand_ant. ,at=gri , bt=d);
%skriv_array(navn=tgrid, type=8.,a=&lod_ant.,b=&vand_ant. ,at=tgri , bt=d);

%skriv_array(navn=djik, type=8.,a=7,b=&djik_ant. ,at=dji , bt=k);

/*actual path*/
%skriv_array(navn=agrid, type=8.,a=&lod_ant.,b=&vand_ant. ,at=agri , bt=d);

/*
1: lod
2: vand
3: dist from S
4: pre lod
5: pre vand
6: visited
7: dir [1-4:
  2
1   3
  4
]


*/

tal = 0;
do lod = 1 to %eval(&LOD_ant.);
	do vand = 1 to %eval(&vand_ant.);

	if grid{lod,vand} = 'S' then do;

	tal+1;

	djik[1,tal] = lod;
	djik[2,tal] = vand;
 	djik{3,tal} = 0;   /**/
	djik{4,tal} = 0; /*pre Lod 0 for starting*/
	djik{5,tal} = 0; /*pre vand 0 for starting*/
	djik{6,tal} = 0; /*havent visited S yet...*/
	djik{7,tal} = 3; /*facing east*/

	start_lod = lod;
	start_vand = vand;

	end;
	else if grid{lod,vand} = 'E' then do;

	tal+1;

	djik[1,tal]=lod;
	djik[2,tal]=vand;
	djik{3,tal}=888888;
	djik{6,tal} = 0;

	slut_lod = lod;
	slut_vand = vand;


	end;


	end;
end;

do mange = 1 to 10000;
/*visit tile closet to S - min(djik{3,tal})*/

/*find min - not already visited*/
	min=999999;
	do i = 1 to &djik_ant.;

		if djik{1,i} = . then do;
			leave;
		end;

		if djik{6,i} ne 1 and djik{6,i} ne . then do;

			if djik{3,i} < min then do;

				min = djik{3,i};
				min_djik = i;

			end;
		end; 

/*	put "min: " min;
	put "min_djik: " min_djik;
*/
	end;
 
djik{6,min_djik} = 1;

if min_djik = 1 then do;
leave;
end;

/*When visit explore posible reachable locations:*/

	do dir=1 to 4;
		dL = mod(abs(dir-3),2)*(dir-3);
		dV = mod(abs(dir-2),2)*(dir-2);

		/*put "dL: " dl "dV: " dv;*/

		/*is adjecent not wall*/
		if grid{djik{1,min_djik}+dL,djik{2,min_djik}+dV} ne '#' then do;

			noted = 0;
/**********/do i = 1 to &djik_ant.;
				if djik{1,i} = . then do;
					leave;
				end;

				if djik{1,i} = djik{1,min_djik}+dL and
				   djik{2,i} = djik{2,min_djik}+dV then do;

					noted = 1;
					/*if already visited then leave*/
					if djik{6,i} = 1 then do;
						leave;
					end;
					/*if noted but not visited, check if distance is shorter*/
					else do;
					/*is distance from min_djik less than pre noted:*/
						if dir = djik{7,min_djik} then alt_dist = djik{3,min_djik}+1;
						else alt_dist = djik{3,min_djik}+1+1000;

						if alt_dist < djik{3,i} then do;

							djik{3,i} = alt_dist;
							djik{4,i} = djik{1,min_djik};
							djik{5,i} = djik{2,min_djik}; 

						end;
					end;
				end;
			end;
			if noted = 0 then do;

				tal+1;
				/*put "noted: " noted ", next tal:" tal;*/
				djik{1,tal} = djik{1,min_djik}+dL;
				djik{2,tal} = djik{2,min_djik}+dv;

				if dir = djik{7,min_djik} then alt_dist = djik{3,min_djik}+1;
				else alt_dist = djik{3,min_djik}+1+1000;

				djik{3,tal} = alt_dist;
				djik{4,tal} = djik{1,min_djik};
				djik{5,tal} = djik{2,min_djik};
				djik{6,tal} = 0;
				djik{7,tal} = dir;

			end;

/**********/

/*

			next = mange 2, flytter den til v4 som den skal?

			*/
		end;
	end;
end;


/**/
/*do lod = 1 to %eval(&LOD_ant.);
	do vand = 1 to %eval(&vand_ant.);

	if grid{lod,vand} = '#' then tgrid{lod,vand} = 9999999;

	end;
end;*/


do i = 1 to &djik_ant.;

				if djik{1,i} = . then do;
					leave;
				end;

tl = djik{1,i};
tv = djik{2,i};
	/*tgrid{djik{1,i},{djik{2,i}} = djik{3,i};*/

/*if djik{6,i} = 1 then*/ tgrid{tl,tv} = djik{3,i};

/*put "tl: " tl ", tv: " tv;*/
end;

Part1 = dji3k1;



/*agrid{slut_lod,slut_vand} = tal;*/

pre_lod = slut_lod;
pre_vand = slut_vand;

slut=0;
do ap = 1 to 10000;

do i = 1 to &djik_ant.;

	if djik{1,i} = pre_lod and djik{2,i} = pre_vand then do;

	tal+1;
	agrid{djik{1,i},djik{2,i}} = djik{3,i};
	pre_lod = djik{4,i};
	pre_vand = djik{5,i};

	if agrid{djik{1,i},djik{2,i}} = 0 then do;
		slut=1;
	end;

	end; 
	if slut then do;
		leave;	
	end;

end;


end;

run;





data ct04;
length treeways djik_ant 8.;
set ct03(drop=dji:);
%skriv_array(navn=grid, type=$1.,a=&lod_ant.,b=&vand_ant. ,at=gri , bt=d);
%skriv_array(navn=tgrid, type=8.,a=&lod_ant.,b=&vand_ant. ,at=tgri , bt=d);
/*%skriv_array(navn=ogrid, type=8.,a=&lod_ant.,b=&vand_ant. ,at=ogri , bt=d);*/
/*%skriv_array(navn=djik, type=8.,a=7,b=&djik_ant. ,at=dji , bt=k);*/



/*taken path*/

/*bgrid{slut_lod,slut_vand}  = 0;*/

/*remove leaf nodes*/

do mange = 1 to 10;

do lod = 2 to %eval(&LOD_ant.)-1;
	do vand = 2 to %eval(&vand_ant.)-1;

		if ^(lod = start_lod and vand = start_vand) 
       and ^(lod = slut_lod and vand = slut_vand) then do; 

		ant_nabo = 0;
		do dir=1 to 4;

			dL = mod(abs(dir-3),2)*(dir-3);
			dV = mod(abs(dir-2),2)*(dir-2);
			if tgrid{lod+dl,vand+dv} > -1 then ant_nabo+1;

		end;
		if ant_nabo = 1 then tgrid{lod,vand} = .;

		end;
	end;
end;
do lod = (%eval(&LOD_ant.)-1) to 2 by -1;
	do vand = (%eval(&vand_ant.)-1) to 2 by -1;

		if ^(lod = start_lod and vand = start_vand) 
       and ^(lod = slut_lod and vand = slut_vand) then do; 

		ant_nabo = 0;
		do dir=1 to 4;

			dL = mod(abs(dir-3),2)*(dir-3);
			dV = mod(abs(dir-2),2)*(dir-2);
			if tgrid{lod+dl,vand+dv} > -1 then ant_nabo+1;

		end;
		if ant_nabo = 1 then tgrid{lod,vand} = .;

		end;
	end;
end;
end;

/*count 3 or 4 ways*/
treeways = 0;
do lod = 2 to %eval(&LOD_ant.)-1;
	do vand = 2 to %eval(&vand_ant.)-1;

		if tgrid{lod,vand} > -1 then do;
			ant_nabo = 0;
			do dir=1 to 4;

				dL = mod(abs(dir-3),2)*(dir-3);
				dV = mod(abs(dir-2),2)*(dir-2);
				if tgrid{lod+dl,vand+dv} > -1 then ant_nabo+1;

			end;
			if ant_nabo > 2 then treeways+1;
		end;
	end;
end;

/*each treeway can make at most 4 blocks*/

treeways = treeways*4;

call symput('block_ant',strip(put(treeways,8.)));



/*make simple grid*/

djik_ant = 0;
do lod = 1 to %eval(&LOD_ant.);
	do vand = 1 to %eval(&vand_ant.);

	if lod = start_lod and vand = start_vand then grid{lod,vand} = 'S';
	else if lod = slut_lod and vand = slut_vand then grid{lod,vand} = 'E';
	else if tgrid{lod,vand} = . then grid{lod,vand} = '#';
	else grid{lod,vand} = '.';
	
	if grid{lod,vand} in ('.','S','E') then djik_ant+1;

	end;
end;

call symput('djik_ant',strip(put(djik_ant,8.)));
run;

%put &=djik_ant;
%put &=block_ant.;


data ct05;
length Part2 dji1k1 dji2k1 dji3k1 start_lod start_vand slut_lod slut_vand 8.;
set ct04;
%skriv_array(navn=ogrid, type=$1.,a=&lod_ant.,b=&vand_ant. ,at=ogri , bt=d);
%skriv_array(navn=grid, type=$1.,a=&lod_ant.,b=&vand_ant. ,at=gri , bt=d);
%skriv_array(navn=tgrid, type=8.,a=&lod_ant.,b=&vand_ant. ,at=tgri , bt=d);

%skriv_array(navn=djik, type=8.,a=7,b=&djik_ant. ,at=dji , bt=k);
%skriv_array(navn=block, type=8.,a=2,b=&block_ant. ,at=bloc , bt=k);

%skriv_array(navn=agrid, type=8.,a=&lod_ant.,b=&vand_ant. ,at=agri , bt=d);

/*copy grid to ogrid, resetable*/
do lod = 1 to %eval(&LOD_ant.);
	do vand = 1 to %eval(&vand_ant.);

		ogrid{lod,vand} = grid{lod,vand};

	end;
end;

/*make block table*/

block_ant=0;
do lod = 2 to %eval(&LOD_ant.)-1;
	do vand = 2 to %eval(&vand_ant.)-1;

		if tgrid{lod,vand} > -1 then do;
			ant_nabo = 0;
			do dir=1 to 4;

				dL = mod(abs(dir-3),2)*(dir-3);
				dV = mod(abs(dir-2),2)*(dir-2);
				if tgrid{lod+dl,vand+dv} > -1 then ant_nabo+1;

			end;
			if ant_nabo > 2 then do;

				do dir=1 to 4;
	
					dL = mod(abs(dir-3),2)*(dir-3);
					dV = mod(abs(dir-2),2)*(dir-2);

					if tgrid{lod+dl,vand+dv} > -1 then do;

					/*check if on block list already*/
					already = 0;
					do j = 1 to &block_ant.;

						if block{1,j} = lod+dl and block{2,j} = vand+dv then already=1;

					end;
					if already = 0 then do;
					block_ant+1;

					block{1,block_ant} = lod+dl;
					block{2,block_ant} = vand+dv;
					end;
					end;

				end;
			end;
		end;
	end;
end;
/*kører meget lange - suboptiomal kode.*/
do allblock = 1 to 23 /*&block_ant.*/;

if block{1,allblock} = . then do;
leave;
end;

put "block{1,allblock}: " block{1,allblock};


/*reset all: */

do lod = 1 to 1;
	do vand = 1 to %eval(&djik_ant.);

		djik{lod,vand} = .;	

	end;
end;



do lod = 1 to %eval(&LOD_ant.);
	do vand = 1 to %eval(&vand_ant.);

	grid{lod,vand} = ogrid{lod,vand};

	end;
end;
/*grid{13,6} = '#';*/

grid{block{1,allblock}, block{2,allblock}} = '#';


tal = 0;
do lod = 1 to %eval(&LOD_ant.);
	do vand = 1 to %eval(&vand_ant.);

	if grid{lod,vand} = 'S' then do;

	tal+1;

	djik[1,tal] = lod;
	djik[2,tal] = vand;
 	djik{3,tal} = 0;   /**/
	djik{4,tal} = 0; /*pre Lod 0 for starting*/
	djik{5,tal} = 0; /*pre vand 0 for starting*/
	djik{6,tal} = 0; /*havent visited S yet...*/
	djik{7,tal} = 3; /*facing east*/

	start_lod = lod;
	start_vand = vand;

	end;
	else if grid{lod,vand} = 'E' then do;

	tal+1;

	djik[1,tal]=lod;
	djik[2,tal]=vand;
	djik{3,tal}=888888;
	djik{6,tal} = 0;

	slut_lod = lod;
	slut_vand = vand;


	end;


	end;
end;

do mange = 1 to 10000;
/*visit tile closet to S - min(djik{3,tal})*/

/*find min - not already visited*/
	min=999999;
	to_big = 0;
	do i = 1 to &djik_ant.;

		if djik{1,i} = . then do;
			leave;
		end;

		if djik{6,i} ne 1 and djik{6,i} ne . then do;

			if djik{3,i} < min then do;

				min = djik{3,i};
				min_djik = i;

			end;

			if min > Part1 then do;
				to_big = 1;
			end;
			put "to_big: " to_big;

		end; 

/*	put "min: " min;
	put "min_djik: " min_djik;
*/
	end;
 
djik{6,min_djik} = 1;

if min_djik = 1 /*or to_big=1*/ then do;
leave;
end;

/*When visit explore posible reachable locations:*/

	do dir=1 to 4;
		dL = mod(abs(dir-3),2)*(dir-3);
		dV = mod(abs(dir-2),2)*(dir-2);

		/*put "dL: " dl "dV: " dv;*/

		/*is adjecent not wall*/
		if grid{djik{1,min_djik}+dL,djik{2,min_djik}+dV} ne '#' then do;

			noted = 0;
/**********/do i = 1 to &djik_ant.;
				if djik{1,i} = . then do;
					leave;
				end;

				if djik{1,i} = djik{1,min_djik}+dL and
				   djik{2,i} = djik{2,min_djik}+dV then do;

					noted = 1;
					/*if already visited then leave*/
					if djik{6,i} = 1 then do;
						leave;
					end;
					/*if noted but not visited, check if distance is shorter*/
					else do;
					/*is distance from min_djik less than pre noted:*/
						if dir = djik{7,min_djik} then alt_dist = djik{3,min_djik}+1;
						else alt_dist = djik{3,min_djik}+1+1000;

						if alt_dist < djik{3,i} then do;

							djik{3,i} = alt_dist;
							djik{4,i} = djik{1,min_djik};
							djik{5,i} = djik{2,min_djik}; 

						end;
					end;
				end;
			end;
			if noted = 0 then do;

				tal+1;
				/*put "noted: " noted ", next tal:" tal;*/
				djik{1,tal} = djik{1,min_djik}+dL;
				djik{2,tal} = djik{2,min_djik}+dv;

				if dir = djik{7,min_djik} then alt_dist = djik{3,min_djik}+1;
				else alt_dist = djik{3,min_djik}+1+1000;

				djik{3,tal} = alt_dist;
				djik{4,tal} = djik{1,min_djik};
				djik{5,tal} = djik{2,min_djik};
				djik{6,tal} = 0;
				djik{7,tal} = dir;

			end;

/**********/


		end;
	end;
end;

pre_lod = slut_lod;
pre_vand = slut_vand;
slut=0;

if dji3k1 <= Part1 then do;


do ap = 1 to 10000;

do i = 1 to &djik_ant.;

	if djik{1,i} = pre_lod and djik{2,i} = pre_vand then do;

	tal+1;
	agrid{djik{1,i},djik{2,i}} = djik{3,i};
	pre_lod = djik{4,i};
	pre_vand = djik{5,i};

	if agrid{djik{1,i},djik{2,i}} = 0 then do;
		slut=1;
	end;

	end; 
	if slut then do;
		leave;	
	end;

end;


end;
end;

Part2 = 0;
do lod = 1 to %eval(&LOD_ant.);
	do vand = 1 to %eval(&vand_ant.);

	if agrid{lod,vand} ne . then Part2+1;

	end;
end;

end;



run;

data pr_block(drop=v vand keep= v: );
set ct05;

%skriv_array(navn=block, type=8.,a=2,b=&block_ant. ,at=bloc , bt=k);

%macro pr;


%do b = 1 %to 2;
%do a = 1 %to &block_ant.;

v%eval(&a.) = block{&b.,&a.};
*if v%eval(&a.) = -8 then v%eval(&a.)= .;


%end;
output;
%end;

%mend;
%pr;


run;


data pr_djik(drop=v vand keep= v: );
set ct05;

%skriv_array(navn=djik, type=8.,a=7,b=&djik_ant. ,at=dji , bt=k);

%macro pr;


%do b = 1 %to 7;
%do a = 1 %to &djik_ant.;

v%eval(&a.) = djik{&b.,&a.};
*if v%eval(&a.) = -8 then v%eval(&a.)= .;


%end;
output;
%end;

%mend;
%pr;


run;


data pr_grid(drop=v vand keep= v: );
set ct03;

%skriv_array(navn=grid, type=$1.,a=&lod_ant.,b=&vand_ant. ,at=gri , bt=d);

%macro pr;


%do b = 1 %to &lod_ant.;
%do a = 1 %to &vand_ant.;

v%eval(&a.) = grid{&b.,&a.};
*if v%eval(&a.) = -8 then v%eval(&a.)= .;


%end;
output;
%end;

%mend;
%pr;


run;

/*
proc format;
    value customfmt
        9999999 = '#'
		other = [8.]
        ; 
run;
*/
/*
data pr_tgrid(drop=v vand keep= v: );
set ct04;

%skriv_array(navn=tgrid, type=8.,a=&lod_ant.,b=&vand_ant. ,at=tgri , bt=d);

%macro pr;


%do b = 1 %to &lod_ant.;
%do a = 1 %to &vand_ant.;

v%eval(&a.) = tgrid{&b.,&a.};



%end;
output;
%end;

%mend;
%pr;

format V: customfmt.;
run;
*/

/*
data pr_bgrid(drop=v vand keep= v: );
set ct04;

%skriv_array(navn=bgrid, type=8.,a=&lod_ant.,b=&vand_ant. ,at=bgri , bt=d);

%macro pr;


%do b = 1 %to &lod_ant.;
%do a = 1 %to &vand_ant.;

v%eval(&a.) = bgrid{&b.,&a.};
*if v%eval(&a.) = -8 then v%eval(&a.)= .;


%end;
output;
%end;

%mend;
%pr;


run;
*/

data pr_tgrid(drop=v vand keep= v: );
set ct03;

%skriv_array(navn=tgrid, type=8.,a=&lod_ant.,b=&vand_ant. ,at=tgri , bt=d);

%macro pr;


%do b = 1 %to &lod_ant.;
%do a = 1 %to &vand_ant.;

v%eval(&a.) = tgrid{&b.,&a.};
*if v%eval(&a.) = -8 then v%eval(&a.)= .;


%end;
output;
%end;

%mend;
%pr;


run;

data pr_agrid(drop=v vand keep= v: );
set ct05;

%skriv_array(navn=agrid, type=8.,a=&lod_ant.,b=&vand_ant. ,at=agri , bt=d);

%macro pr;


%do b = 1 %to &lod_ant.;
%do a = 1 %to &vand_ant.;

v%eval(&a.) = agrid{&b.,&a.};
*if v%eval(&a.) = -8 then v%eval(&a.)= .;


%end;
output;
%end;

%mend;
%pr;


run;


data pr_tgrid_simpel(drop=v vand keep= v: );
set ct04;

%skriv_array(navn=tgrid, type=8.,a=&lod_ant.,b=&vand_ant. ,at=tgri , bt=d);

%macro pr;


%do b = 1 %to &lod_ant.;
%do a = 1 %to &vand_ant.;

v%eval(&a.) = tgrid{&b.,&a.};
*if v%eval(&a.) = -8 then v%eval(&a.)= .;


%end;
output;
%end;

%mend;
%pr;


run;

data pr_grid_simpel(drop=v vand keep= v: );
set ct04;

%skriv_array(navn=grid, type=8.,a=&lod_ant.,b=&vand_ant. ,at=gri , bt=d);

%macro pr;


%do b = 1 %to &lod_ant.;
%do a = 1 %to &vand_ant.;

v%eval(&a.) = grid{&b.,&a.};
*if v%eval(&a.) = -8 then v%eval(&a.)= .;


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


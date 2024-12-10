data ct01;
set ct;

tal = 0;
do i = 1 to len;

tal = input(substr(ft,i,1),8.) + tal; 

end;

call symput('ant_tal',strip(put(tal,8.)));

run;

data Part1(keep=checksum rename=(checksum=Part1));
set ct01;
array file[%eval(&ant_tal.)] 8. file1-file&ant_tal.;

id = -1;
her = 1;

/*create file*/
do i = 1 to len;
	modu = mod(i,2);
	if modu then do;
		id+1;
	end;

	step = input(substr(ft,i,1),8.);

	do j = her to (her+step-1);
		if modu then file[j] = id; 
	end;

	her = her + step;

end;

/*rearrange file*/

slut_L = %eval(&ant_tal.);

do k = 1 to %eval(&ant_tal.);
	if file[k] = . then do;
		do l = slut_L to k by -1;
			if file[l] ne . then do;

				file[k] = file[l];
				file[l] = .;
				slut_l = l;
				leave;

			end;
		end;
	end;
	if k > = slut_L then leave; 
end;

/*Checksum*/

checksum = 0;
do m = 1 to slut_L;
	if file[m] ne . then checksum = ((m-1)*file[m]) + checksum;
end;

format checksum 32.;
run;


data Part2(keep=checksum);
set ct01;
array file[%eval(&ant_tal.)] 8. file1-file&ant_tal.;


id = -1;
her = 1;

/*create file*/
do i = 1 to len;
	modu = mod(i,2);
	if modu then do;
		id+1;
	end;

	step = input(substr(ft,i,1),8.);

	do j = her to (her+step-1);
		if modu then file[j] = id; 
	end;

	her = her + step;

end;

/*find id*/
id_taller = 0;
do j = %eval(&ant_tal.) to 1 by -1;

	if file[j] ne . then do;

		id_taller+1;
		id_ant_taller = 1;

		do k= 1 to 8;

			if j - k > 0 then do;

				if file[j-k] ne . and file[j] = file[j-k]  then id_ant_taller+1;
				else do;
				leave;
				end;

			end; 


		end;
	
		/**/

		/*find empty space:*/

		emp_taller = 0;
		do l = 1 to /*%eval(&ant_tal.)*/ j;

			if file[l] = . then do;

				emp_taller+1;
				emp_ant_taller = 1;

				do m = 1 to 8;

					if l + m <= %eval(&ant_tal.) then do;

						if file[l + m] = . then emp_ant_taller+1;
						else do;
						leave;
						end;


					end;

				end;
/*
			put 'emp l: ' l;
			put "emp antal: " emp_ant_taller; 


			put "id_ant_taller: " id_ant_taller;
			put 'ID j: ' j;
				*/

				if id_ant_taller <= emp_ant_taller then do;
					
					
					
					do n = 1 to id_ant_taller;

						file[n+L-1] = file[J];

					end;
					do o=id_ant_taller to 1 by -1;

						
						file[J-o+1] = .;

					end;
					/*l = l + emp_ant_taller-1;*/
					leave;
				
				end;
			/*l = l + emp_ant_taller-1;*/
			end;
		end;

		/**/

		
		/*put "ID antal: " id_ant_taller;*/ 

		j = j - id_ant_taller+1;

	end; 
end;

checksum = 0;
do m = 1 to %eval(&ant_tal.);
	if file[m] ne . then checksum = ((m-1)*file[m]) + checksum;
end;

format checksum 32.;

run;


data ct;
  infile datalines truncover;
  input  ft $32000.;
	
	retain lang 0;	

  	len = length(strip(ft));
	
	if len > lang then lang = len;

	call symput('antobs',strip(put(_N_,8.)));
	call symput('maxlen',strip(put(lang,8.)));

  datalines;
Input_from_aoc
;

run;

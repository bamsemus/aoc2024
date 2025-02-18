
data ct;
  infile datalines truncover;
  input  ft $32000.;
	
	retain lang 0;	

  	len = length(strip(ft));
	
	if len > lang then lang = len;

	call symput('antobs',strip(put(_N_,8.)));
	call symput('maxlen',strip(put(lang,8.)));

  datalines;
1420246358115615159448658011444034495988947721324334285442101229872348312916304522703197195345597061772498605363984239553957302482663677272169494831829416248712671165699481784932213134289985741163494280789480479566522614248850258942381644783457519121322691625912162966151573446347716888172178835864207415862988675063532764201551877739539780656275351285822099801016985868354345143852172578669575251095812923575441842416751934692375928613673089902851511854338578603039415599771176117175225571201228261021752018208031608164823996213963751160129384296870382454451252975639885818448121584462462423691177228380776690488310495836869661942368339135556430555519746538388990398225583467258510344391474773468611572681443149442135549575213556246042284042718563921893348430454242939927932771507883136474815797505777306180654149942843738320431255218813199662731416966422433693905463654151183292889587802152844435264889768933495873809367868768364350748862158480666660439389802019531176214064326822731886882340748097731171958624497428803293956951988943755317512235729227683040988980796972587276164636243939913281668472626017911675661796847234657111626675637011356917382164631462841924506584655242774444825331117416699059989984271782723797405879607052478958401256663368423341925734509962558156409927509152243841364932184341567110578193311666357321583116298085795045224983174545521666718615821114618990275712427511143939243740737832839392854511609161537215747275113555443411529476289661744326821035264492127551951114517383908866582171567310446743764856482080844561498270495184494590404132431630913354845048549025914174812788965949279926438880869364255976332982739734468485832732685645602768955676445825678398575257105422519550191782348242617978302732909774763751143314899837865630733451927556917617754768126230768453658921645313899437435537592394103876919180255131824117889510308861935148617546785982652435763342524427551872589658297392116253919820634919263740521953136653228245492133308523954433154011885995539589114794194084504792499286541442397317118367608895697628647452677975783881808651853437533684834336694641407967312888598326303555872185785368737959969585361263251390183578212649239446154731565868903919645646492371242936497077419110765896276830537444368793119074596190624057924796698495999050478258303876328219794587103036697448576254969116175019313867198357236558746867789534391423878176352160191498532672812648236463811915342988345083659925471936517128453286685061181612416367469481807921688681857234535981552321613739501127923618472172618087955132369554754074932725974332514617723947402620338322363565947361447544131336855954579648511776573729811331594890432475632346995134986318579626758812843017298662189360368350486313755749822583127122652695463699171544713532639563393481591524624357385963803126177784432249778943549048821054307180798931871582467857445310285997654575334951348323531124935046362043442083702279911822843573769013859176608579706932994048133621167172595781616181679456871992969876374469521461269235906997502859843434996061928192352975157134996794699385837186712676321512714290169542989134971770354543567751279692255370599797776673475330942148988158841096424041653170329959576254158525543165529828983949658137281696206455435780297120539841202565907467892113712491538288304431542551928893971063997395127243435352541828223395641694417577214440396750311610701196896484658138329984467559899033988265516568477978429556275586689057148864108951192660958337831355834644614077813978724378596857336136958374175327875378946572777334453552558741315234226224775228208274679888421160341478801315185214887463654542581221845133809889801478493181345830385082584793943976943780277668716663684794389862832325943116785725936223833215315810746118137498625420463672186650508638492136815147772033106760934472228557794949987428155526192819236061693972505454629125365556235954195272207918619269803955771513604155899231436452139366262496542611399439305398803271706090478175737334417937922783226932549577422964796540941829553615159550605129294744393765978693552310715946819984593765361970802451149161535562786832882372481558758154174551709472404897556154886199527776127921174262403629506998166457985336604095636551639016935052437858862383504316322410775528616557928777102191936194837349606854789552439241178744607361833631776714269765621252659479685740292245782956706666766524561171746179624251711732966421435541696670625621339885873264598736475679727964933860189239167685225049219787652461556810682066437116395045404354301017219667967956113683731493998353363697778848686353768290967819681891784857966078428522475614175266799281595010497669522337563952687982142725801585625436938710697851496948443838865444268183736243553210741867446338624746471690891736747075849843925760176955566919826548966854656151649112309893647127392546618090246477991626587287269683606637711267387258561482712981263735598358244470224719123756309996961620263616459235629760153083474428584920308349182628635267812322117013571019599135949264108295134998635783184390242759624957262539717936755221825091317776216382942528314321296854135020351588544599714348182778341613298878403726554664733198668560603477729755642051261592584095493179869877411792946391855333781777607827716499345441421598753822862136226595902372154830777228111045756448854496757629391949494472689310341080978645507962421582761070727042388258958463876636338723231083205816158835731015859341528553452449538297728058105979613997406715282199657960622899243898237555255392175676211317371049157851923659782486749292795226425426674710279948933978306282994742397213902643143497492652697921106075131089837025785836826079223120728962633088105939763627341087417546581876446648237565396049872385567854477314952130481717459279308763805121443487117688108725545250506181314754393587564629697623538478318439709781682111145830595184539195113175246524517717743584495949214253843825688993775081355036314390143685154439432689925952876760118361959592204547174191662954328988976379326978856733829265573340251964965024611391942832718828535961665657124755769986884022722576908646549357251710492186775830848434123730837655452918929425681815716512812540823127443789402436741972185620125715749749297683419779675142881053327067539217767512251469892850696121716588293897112276405090412483245859427411829964522723787550208272787010592591979096598676672676512726108248507958133517617798866698362932328789556416601795355343648337725554686455674863208696112499843583881637498282329358665227771578359599585921707169544991451280641431548039203339879339742152733130603170762578877676524029124668822183335341457876365090974662893519266429465265698761722333934737255345583340576469121019663064825168726217933753592818198792746353544544714651857963871888111117415813254420994582869032512720904643706517963120546268394762337428127842243777303047565513609483938335174077712198978463725448927666207935402366964065965311707026168567964329667035643123442256627527386313258053104479951236413889746694863214741270256016769719831197334526846777317383576045568159501813209655561724207486527532258773919828317668376799381526428339987856289142683639194986186397684287441311797372376634285071795670586493788268275176892738566523161478164180643980226463319541992963379794165274917695868315612628775158687140637145903871483973169840532893833765325449816922828089105564835452163477564956851824411829534013504350875540362381295922411725336065678784979346506060196735363738295639921011796118311286874359464314581034423329608337116621793017546671745534217586669011555898983682957659557752914468662973735017206425102964479587671710281612817822602313915615271130615984104549887890553968483558425233476166727049949034347389784471435150594739432196866710516389728060186637183371519834203027701839667592789785113743657889862667825428994171108558643443281747866027918989619968936957597549227960998312138227273854643423972877266963288659676240275292178881178031768486541841137672507146806093535674108264587494412535526975798633414650983960976222235430304555396599756673494734174973391151188453507792114318764028648695445523298524985565778763623691441046781584634312302944781256459871619829148844657555736884461436806825395185788657612511918892101273146463197539125542418115626133561718777142328663902441632785314858353363336824558334231163965197651443536512835058212892452990447745567611545577881596414443125052403564444785397264512446912070592741628583337575892749587420287359757696183428459518387897771863565941185792285542248526328990862941653354795528359835758316564452361655644142318889232588815594861367795044188717253363192874516351816693682230985991801589613286265362445723751360411543761890746057666919585274225663556425978510531871697578409712593886814359248537843635882172963014178727349558721430969993536442312247162280831666815559908242483416101341755491423842193467442623171431706759591886666129722775105137617545502015109987533334573883828630265063658444465288991986601053105473227284608891915240949782486842695176889131805539816148522376852454341422529656245065441937162783785150609677301483693668583662985273321242995157798468264942972282998787784952748376431239844663696993733186288746524194808251528423925323857042282181683013891798186254636364391664705742612479304793229953263795647897379563117891103188565558183892571312279056133824253416399371639452601790637918919536955429319053364141692677482013552445986511416945636317569359919313985647398736139682638331335886479129458328279222602767981774162182638866478321548138481954175256321363116320133922282066555542539387958718369610435915399914399648395415851226439818469488816868942690881769825218482558986936579340392522198915799569573869189312889294809671806418755284768370934642702644794657225575488123877082206490724494989948334975382315793337879230706719347879714735756325942585894331933380728864325227567688643625106932131811844987816262143396759885978691152710602927421567458092683327732572128025191315267434518659647112609750227895419229665824143741467158781393187220608557727986382631132870409536397172591315799263938172972183607078329638561415977117581110235937216460453422724246686718554952516384363011373549106660929599235945612343794470824130381095401756916170322235147250391370865230356995478149204624673041396120127173999699235923642466109751393181569629435249846942418225701636596734191029479246234553263549937967553189397656783925631233104660647537745371224646586246266842497923517528688697384970836838463053903845338067346363381461643065997116279317872137708496393449736097717247959148761064635782848058624089232040115023545531885132763117909038941419864788137958232040637257837070619145909513863957587675959534296661314340178931787299884633678041548575729726212423748076256763257761403825395612148522139336149566662015552444642820278789197876616025835141737897747063749787906040739789658524767463524125588772211492159976829383728566541474583983874383306039782976756659333346173734845724694835407665492443457561373340354537769175609729667373299665541341444241954972925499618658684640623423635716293531362373962969819715851540377829394987372036802230192932255329363249205554238365762831655450455178322082382665287956398139246784431077402161661866205761372241265813852935475984477128906419544799732918891436308557504737197849766140612036418990125132251327307974305537905177527442707664894278955919173922114499667950633361361837987596568572326984131623236356371826218298492278152557485232726264217518219617755446566153129552162985819529594489557831641937577156377933222055848441726348893010383177335853955013221221796252297795361212682559956330477961289090715116757634422370932653864016646460997595632421187489973666391639287422686484274337637275894850547945882267552194561764526643617386994165826168122747134883594987714763735351136229739279859419903019364121489119461495601057612275452438604773356472194115869195637121424867147785182133417460755060563825856344445453908735568664388073224755869870387613599468962319585255975230436344132736747723819738407483612692668796283542979586261331194622265493851459921123376884614186592576365638253124925141802514209493504789855338346851507136717336571350456943924929477359992151477661466361401174893748538318215756684783868043466237866687345616836542874454948913839196445322211290487613766241693610705337798593471326623724524361675277459910857986716628511859891162858689954564951531182050715737108761756039704835787673557628536845592459392398159896773144704285179875569458238133968246824416551122778390752057452289497613275465147066236325814551834152203339351677232289342344431271251244757332373629384943267258237219396373903884784074227368895122205987807344943172155753609394293345138216568320755361722516803277856644202572325890531383969633918679881495802520739297716127304854508516555590591175443438921588129036131215373941398119735326703440959664124549882494346311297458433799869220363442274529467334934779164072794826972081282172934937941547508310681455179140924761924297779313242566686213189714599224701146392236859699518832913028414027786196558028264098338398894248269199945863564586841979364243197724502169172379778934837558569958624070904180947938666481938594865279296116931612575736875422629558256448366222113972252740918693657897169591365335237767382385361869805627671719899878631418754721605130186762847189128131603083874372611182578326724033942428367697218199937180774877103590488315946499294762243079472858624592432349972170614481853030374432838333457464584571833416246842551345259456308810638037157285868399774398566853492777831310293121363943478954793125529864746038193997901580737456789220351953905024847765259183215773703877963540239556975650325591881170582367824595763515647292898090376691613581627596658089383747291380484996751869949841443227963322435334375831233561674573323291259088844627719336776833302015319080229527114476695448565348328552316454174662355257812595479896279431161846879751485896778497388515295241138369952529662756604399663919657677593346251177308780116590847836718024724491331155321419373278812324486522446255956384211058588066352446929637778815558455373618316523878725506048136178102889626456566696944082308025743115314125398937463141423646306336935424211568384744303532573711883013923174152923731867951199514096375826481378929866358384884853864375825368411887412588923920394644294070592260458974212937633244369176635823632758666858288319594114229015838076482760948642425221356669249067343716128872887470663867854764865229664873192662927529132867246641304435472171434058747987366327829713717378977298401694639342693190214515742622271165949121516319264277113535234412328834732938406648121963825753275480442344927051527654211749242327352492686963965689676262329697139968287784705130436518131797648533936387117871952725369657266084536053718856922214157239355994297076582869713392707362182122445446795170424292911060132783569665634654132742669383634910253835123043579623168618417964233639435941478757226258239596899396501371506697901844812215925061514236128547536222412170825273438053103494437627895033726628861128272749255012839030775760214033934080975426559590738943594227823468145646359775763459772151637842758587458671417627183222612777526724814252966611562055287357925442316972176376582266422529746561629641673332981894836628878145343673225186266343311488418447834178123892453057724052141417839078362280806027541726105084575430203199929930345811453991199137793445671224228144563861357281251177223823264877703636381388177097721935408179183069911388153559457333719950713642262678682471569841235089992626573275186772153339742636596954441183815440992252682019769695723956151737575963287483642772537750674916896651586727738015744134614282363538598789491979939234548878776568358566544046515312151096987138378283845390859017785744648068828289269417195574776879363319633465914437811963907895314472348161401558425785483364614629191155313529908762591197745719769348697088587813237118656432546565767379681997355720812879675597381390181562755735884131568012672184889837459576205247712381671491716164189661592868536220878550212541457554721010717592236596445866131763668227786016431039372193373974441195875331357937887315832962793093555198117576507754132782527087575319394687317033724157932516605158246495308711329547423681497740949452526770163368945323893955487259934043776084245287397976719551321716318715713145305533742961953850531023369689131317364839202623721764622341327659502758974089963190554942649211116524426328313964652792324816299751945165436269996766616834271510212513458083587957946636874789917353708948553977171366353380804464651919637548926834101661878514119456886621341871931473599133805128806045766950145155505920365484174155618267936229552221256391182689286761726486216835441132808414597163432735781338949554469678472977715031298099749134997289621976208771453220267372589182283239451688998313267144569350902240294432988753894470295264687520424681938373562583255087728048259486239828201011689362408993151923485059166515678355491249203839723542685231672355317887701364357364291057925358382213233115998588502139439254819724365210803961716361637539643043423872465444912088997045124130908128257743473852809588466519438540878296825324489791766863851416985322919434475852941289437076454457289368459781608231466229811171669040558273597389503773367069235930616934594894961644595413259263846682536050914225489073921278301285287954384979131443443160904191271570259579463165846837435638169486932322767274184410973194617423866270644184119489885043109983413936815116951075127142958587241370845153495134672682965494716774598495653618359060457055474614846939855341795562979229875696693615849190718214803264443365555989802281265585716036477169484550368999708869656620915978174811749686273833742215429246928335134973616515181471387410209869106639888222281911802797104175102675132653156178464879134467294066757528578262652940622847851259646956963630968171433379914681375198178433612219973564165898511978383347875765575457987625524955411012808126233358866488574062442868717020343860199479835222176175761443691778659298981522446553836113225794899491951510594320683094766166919227419357671472817844706336785121777294724923785873928745584314102095172047187418403191691385578313608048919245673414549041176038133693431134526410248938729310451149102827617021943978507196705728102023546813604387158811377033877564395769648034809735725295504136591337159267437978807282239283794037144494805951788851397035267913754771464488191599396486218395445482719113287323615771898397109494321892386889637169802258299549859468199348185562192591632631754744509994475040452073993287177379141176649319639551445596241579766687376132489914242595548143696839387884965284259285417764994419843138837410237666442751643280853825773164907823603879294177304828483889294518353849741466622511699639282528753081971025679059684139621580777095535071665360195392182338452355456325162494112163704582961090789956618294461621183165312012479971818266781133902743264075584598852476181696428115822270792156614162327397253668556680558847128638979119257039153621696172449580508466643582525932856254648092971728523580594883843762631791394775222511139561981663278692757947397710692890676374549346494947554118916642868131604328267111246319248681869188106257323960383726753049618841475259118344315171229062565073611988469446636358642631244852895995712674263476244959332342419456972371545783542585463680672898319262681988976290329434971665767764812813239143469134712365698849924813752866945770404360409590222442934070511212675868453399902633234396957788254664471017743955489859253164198729519529126271123062375274655655658823412220584311234842422182425177618798753752356293808648295847997585108235874317255216557592221764772915913935596776543461204274235751557587966151396590256874632199884125895050694345104663433065639540683465626089252043238261305597498210971620486645442193609163392269961811809267582273395278917044741924125254872395423736798078861933707673975793627837826662928895577044965024401275454875647251476140548455105693954641417
;

run;

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



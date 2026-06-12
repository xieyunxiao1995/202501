import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../story_page.dart';

// ====================================================================
// 80 章剧情文案 — 每章约 50 字
// ====================================================================

const _kChapterStoryTexts = <String>[
  // ---- 序章 · 黄巾之乱 (0) ----
  '''东汉末年，桓灵失道，宦官弄权，朝政日非。巨鹿人张角偶得《太平要术》，自称大贤良师，以符水咒语广收信徒，聚众数十万，头裹黄巾，揭竿而起。天下大乱的序幕就此拉开。''',

  // ---- 第一章 · 桃园结义 (1) ----
  '''幽州涿郡，刘备、关羽、张飞三人在桃园中结为异姓兄弟，焚香盟誓："同心协力，上报国家，下安黎庶；不求同年同月同日生，但愿同年同月同日死。"从此开始了传奇征程。''',

  // ---- 第二章 · 十常侍乱政 (2) ----
  '''黄巾初平，灵帝驾崩。十常侍把持朝纲，卖官鬻爵、颠倒黑白。大将军何进欲诛宦官，却优柔寡断，召董卓率西凉兵入京。事泄，何进被十常侍诱杀，袁绍率兵冲入皇宫，宦官尽数伏诛。''',

  // ---- 第三章 · 何进之死 (3) ----
  '''何进优柔寡断，不听曹操劝谏，执意召外兵入京。十常侍假传太后懿旨，诱何进入宫。伏兵尽出，将其斩杀于嘉德殿前。洛阳城大乱骤起，血流成河。''',

  // ---- 第四章 · 董卓进京 (4) ----
  '''董卓率西凉铁骑入洛阳，收编何进旧部，又收买吕布刺杀丁原。他废少帝、立献帝，自封相国，权倾朝野，夜宿龙床、奸淫宫女，残暴不仁，百官人人自危。''',

  // ---- 第五章 · 曹操献刀 (5) ----
  '''曹操向王允借七星宝刀，假意献刀行刺董卓。事败后飞马逃出洛阳，被陈宫所擒又释。途经吕伯奢家，疑其欲害自己，竟杀其全家，留下"宁可我负天下人"之言。''',

  // ---- 第六章 · 诸侯讨董 (6) ----
  '''曹操逃回陈留发讨董檄文，袁绍为盟主，十八路诸侯齐聚汜水关。孙坚为先锋却被华雄所败。关羽温酒斩华雄，提刀出帐，片刻携华雄首级归，其酒尚温，一战成名。''',

  // ---- 第七章 · 温酒斩华雄 (7) ----
  '''华雄连斩联军祖茂、潘凤等数将，众皆失色。关羽挺身请战，曹操斟热酒一杯为其壮行。关羽道"酒且斟下"，出帐提刀上马，片刻斩华雄而归，掷首于地，其酒尚温。''',

  // ---- 第八章 · 三英战吕布 (8) ----
  '''虎牢关前，吕布手持方天画戟，跨下赤兔马，无人能敌。张飞挺丈八蛇矛出战，大战五十合不分胜负。关羽挥青龙偃月刀助阵，刘备掣双股剑加入，三英合力逼退吕布，名扬天下。''',

  // ---- 第九章 · 火烧洛阳 (9) ----
  '''董卓挟持天子迁都长安，劫掠百姓同行。临行纵兵焚洛阳，掘皇陵、掠珍宝，千年帝都化为焦土，百万黎民死伤遍野，沿途哭声震天，惨绝人寰。''',

  // ---- 第十章 · 孙坚得玉玺 (10) ----
  '''孙坚率兵入洛阳救火，于建章殿南枯井中偶得传国玉玺，乃昔日宦官张让所遗。程普谏曰此乃天命所归，孙坚遂生异心，托病率军返回江东，意欲以此号令天下。''',

  // ---- 第十一章 · 连环计 (11) ----
  '''司徒王允以义女貂蝉设连环计。先许吕布为妻，后献董卓为妾。貂蝉从中挑拨，对吕布哭诉被董卓霸占之苦，又对董卓暗指吕布调戏。二人反目成仇，吕布决意诛杀董卓。''',

  // ---- 第十二章 · 吕布杀董卓 (12) ----
  '''王允假传天子禅位诏书，诱董卓入未央宫受禅。董卓车驾刚入宫门，两旁伏兵齐出。吕布一戟刺穿其咽喉，暴尸街头，百姓燃火置其脐中，肥膏流地，火光数日不灭。''',

  // ---- 第十三章 · 李郭之乱 (13) ----
  '''董卓旧部李傕、郭汜采纳谋士贾诩之策，率西凉残兵反攻长安。吕布战败仓皇出逃，王允被满门抄斩。天子沦为傀儡，长安城再遭兵祸，百姓饿殍遍野。''',

  // ---- 第十四章 · 曹操救驾 (14) ----
  '''李傕郭汜内斗不休，献帝辗转流离于兵火之中。曹操采纳荀彧"奉天子以令不臣"之策，亲率大军迎天子于许昌，重建宗庙社稷。从此挟天子以令诸侯，名正言顺号令天下。''',

  // ---- 第十五章 · 吕布夺徐州 (15) ----
  '''吕布趁刘备率军征袁术之机，与曹豹里应外合，夜袭徐州得手。刘备回军，吕布反让刘备屯驻小沛。张飞醉酒失城，羞愤难当，几次欲拔剑自刎被刘备拦住。''',

  // ---- 第十六章 · 孙策定江东 (16) ----
  '''孙策以传国玉玺为质，从袁术处借兵三千、良马五百匹。与义弟周瑜联手，横扫江东六郡八十一州，所向披靡，人称"小霸王"。年少英武，奠定东吴三分天下之基业。''',

  // ---- 第十七章 · 辕门射戟 (17) ----
  '''袁术派大将纪灵率十万兵攻刘备于小沛，吕布设宴调解。令左右于辕门外一百五十步立方天画戟，一箭正中戟上小枝，箭矢穿环而过。双方骇然罢兵，吕布神射名不虚传。''',

  // ---- 第十八章 · 曹操征张绣 (18) ----
  '''曹操南征宛城张绣，张绣先降后叛。典韦为护曹操力战而死，身中数十枪屹立不倒。曹操长子曹昂亦殁。曹操痛哭："吾失长子、爱侄，不痛典韦！"三军落泪。''',

  // ---- 第十九章 · 吕布殒命 (19) ----
  '''曹操决沂泗之水淹下邳，吕布被部下侯成、宋宪捆绑献降。白门楼上，吕布求刘备说情，刘备一句"明公不见丁原董卓之事乎"，曹操下令缢杀吕布，枭首示众。''',

  // ---- 第二十章 · 煮酒论英雄 (20) ----
  '''曹操邀刘备至后园青梅煮酒，二人对坐畅饮。曹操指天论天下英雄，逐一评点诸侯，最后笑道："今天下英雄，惟使君与操耳。"刘备闻言大惊，手中匙箸落地，恰逢雷声掩饰。''',

  // ---- 第二十一章 · 衣带诏 (21) ----
  '''献帝咬破指尖血写密诏，藏于衣带之中赐予国丈董承。董承联络马腾、刘备、王子服等忠义之士，歃血为盟，密谋诛曹。不料事泄，董承等五人满门抄斩，株连数百人。''',

  // ---- 第二十二章 · 斩颜良诛文丑 (22) ----
  '''袁绍遣颜良攻白马，关羽单骑冲阵，视河北大军如草芥，一刀斩颜良于马下。复于延津诛文丑，河北军望风而溃。关羽报恩已毕，挂印封金，护二位嫂嫂千里寻兄。''',

  // ---- 第二十三章 · 过五关斩六将 (23) ----
  '''关羽护二位嫂嫂千里寻兄，一路过东岭关斩孔秀、洛阳斩韩福、汜水关斩卞喜、荥阳关斩王植、黄河渡口斩秦琪，过五关斩六将，忠义千秋，威震华夏。''',

  // ---- 第二十四章 · 古城相会 (24) ----
  '''关羽于古城遇张飞，张飞疑其降曹，不肯相认。恰逢曹将蔡阳追至，关羽一刀斩蔡阳以明心迹。不久刘备亦到，三兄弟历尽磨难终于重逢，抱头痛哭，悲喜交加。''',

  // ---- 第二十五章 · 官渡之战 (25) ----
  '''袁绍率精兵十万南下攻曹，双方在官渡对峙数月。曹操兵少粮匮，军士疲困，形势万分危急。然而袁绍刚愎自用，不听田丰沮授之谏，屡拒良谋，屡失战机。''',

  // ---- 第二十六章 · 乌巢烧粮 (26) ----
  '''袁绍谋士许攸弃袁投曹，献计夜袭乌巢。曹操亲率五千精兵，人衔枚、马裹蹄，夜行昼伏，火烧袁军囤粮大营。守将淳于琼醉卧帐中被斩，袁军粮草付之一炬。''',

  // ---- 第二十七章 · 袁绍败亡 (27) ----
  '''乌巢粮草被焚，袁军大乱，张郃高览阵前倒戈。曹操挥师掩杀，袁绍大败，仅带八百骑渡河北逃。十万大军一朝覆灭，袁绍羞愤交加，不久吐血郁郁而终。''',

  // ---- 第二十八章 · 平定河北 (28) ----
  '''袁绍死后，长子袁谭与幼子袁尚为争嗣位内讧不断，骨肉相残。曹操乘机逐一击破：先斩袁谭于南皮，又北征乌桓剿灭袁熙袁尚。历经数年，终将河北四州尽数收入囊中。''',

  // ---- 第二十九章 · 徐庶荐诸葛 (29) ----
  '''徐庶化名单福投刘备，大破曹仁。曹操扣押徐母，仿其笔迹修书逼徐庶北归。徐庶临行走马荐卧龙："此人有经天纬地之才，主公宜亲往求之。"言罢挥泪而去。''',

  // ---- 第三十章 · 三顾茅庐 (30) ----
  '''刘备三访隆中草庐。初次不遇，二次只遇其弟诸葛均，三次立于阶下候孔明午睡，大雪纷飞不肯离去。诸葛亮醒后出迎，头戴纶巾、身披鹤氅，飘然有神仙之姿。''',

  // ---- 第三十一章 · 隆中对 (31) ----
  '''诸葛亮展开西川地图，纵论天下大势：曹操拥百万之众不可争锋，孙权据有江东可援不可图。先取荆州为家，再图益州为基业，待天下有变，命一上将出宛洛，则可成鼎足之势。''',

  // ---- 第三十二章 · 博望坡之战 (32) ----
  '''夏侯惇率十万兵攻新野。诸葛亮初掌兵权，使赵云诈败诱敌，将夏侯惇引入博望坡狭谷。一声炮响，两边伏兵齐出，火光大作，烧得曹军人仰马翻，尸横遍野。''',

  // ---- 第三十三章 · 火烧新野 (33) ----
  '''曹操命曹仁率大军再攻新野。诸葛亮弃城诱敌，于城中房舍预先布下硫磺火种。曹军入城后火光大作，四处火起，死伤无数。曹仁败退白河，又被关羽放水淹没。''',

  // ---- 第三十四章 · 长坂坡救主 (34) ----
  '''曹操率虎豹骑追至长坂坡，刘备家小失散于乱军之中。赵云单枪匹马于曹军百万阵中七进七出，枪挑剑砍，杀曹将五十余员，救出阿斗，血染战袍，威震当阳。''',

  // ---- 第三十五章 · 当阳桥断后 (35) ----
  '''张飞率二十余骑立于当阳桥头，令军士在身后树林扬尘布疑。面对曹操大军，他厉声大喝："燕人张翼德在此！谁敢决一死战？"声如巨雷，曹军无人敢上前，夏侯杰惊落马下而死。''',

  // ---- 第三十六章 · 舌战群儒 (36) ----
  '''诸葛亮赴江东游说孙权抗曹，在朝堂上面见张昭、虞翻等主和派群儒。他从容答辩，引经据典，将众人逐一驳倒，字字珠玑。鲁肃为之折服，孙权为之动容。''',

  // ---- 第三十七章 · 草船借箭 (37) ----
  '''周瑜令诸葛亮十日造十万支箭。诸葛亮立军令状只需三日，暗向鲁肃借二十艘快船、草人千余。趁大雾弥江之夜，擂鼓逼近曹营。曹操疑有埋伏，命弓弩手万箭齐发，得箭十万余。''',

  // ---- 第三十八章 · 苦肉计 (38) ----
  '''老将黄盖主动献苦肉计，愿受军杖之刑以取信曹操。在帐前甘受军杖五十，皮开肉绽。阚泽渡江下诈降书，曹操见黄盖伤痕累累深信不疑，约定以青龙牙旗为号前来归降。''',

  // ---- 第三十九章 · 借东风 (39) ----
  '''万事俱备只欠东风，周瑜急火攻心病倒卧床。诸葛亮自称曾遇异人传授奇门遁甲，能借三日三夜东南风。登七星坛披发仗剑，焚香祝祷。霎时风起，旗幡尽向西飘。''',

  // ---- 第四十章 · 火烧赤壁 (40) ----
  '''东南风大作，黄盖率二十艘装满干柴火药的快船直冲曹营水寨。火借风势，烈焰冲天，曹军战船尽数焚毁，江面映成一片火海。周瑜挥军掩杀，曹操大败，率残兵沿华容道而逃。''',

  // ---- 第四十一章 · 华容道 (41) ----
  '''曹操败走华容道，道路泥泞，人马困乏。正遇关羽横刀立马拦住去路，曹操以昔日恩情相求，诉说旧日厚待之情。关羽念旧义不忍下手，长叹一声，回马放其逃生。''',

  // ---- 第四十二章 · 智取南郡 (42) ----
  '''周瑜与曹仁激战南郡，双方死伤惨重。诸葛亮趁虚遣赵云连夜夺城，又命关羽张飞截断曹仁归路。周瑜中箭负伤，又被蜀军抢了城池，气得金疮迸裂，大叫一声昏绝于地。''',

  // ---- 第四十三章 · 三气周瑜 (43) ----
  '''诸葛亮先取南郡，再以锦囊妙计助刘备过江娶孙权之妹孙尚香，又于芦花荡派黄忠魏延伏兵拦截。周瑜三次受挫，箭伤迸裂，长叹"既生瑜何生亮"，连叫数声气绝而亡，年仅三十六。''',

  // ---- 第四十四章 · 凤雏理政 (44) ----
  '''庞统经诸葛亮推荐来见刘备，初被慢待任耒阳县令。他一连数日不理政事、终日饮酒，刘备派张飞前去问罪。庞统却在一日内断尽积压数月的百件案件，明察秋毫，众人皆惊，刘备拜为副军师。''',

  // ---- 第四十五章 · 马超起兵 (45) ----
  '''马超为报杀父之仇，联合韩遂起兵反曹。西凉军骁勇善战，连破长安、潼关。曹操亲率大军与之对峙，却被马超杀得大败，割须弃袍方得脱逃，狼狈不堪。''',

  // ---- 第四十六章 · 许褚斗马超 (46) ----
  '''许褚裸衣卸甲，与马超在渭水之滨大战二百余合，不分胜负。两人换马再战，愈战愈勇。两军将士擂鼓呐喊看得目瞪口呆。曹操赞道："马超不减吕布之勇。"''',

  // ---- 第四十七章 · 刘备入川 (47) ----
  '''益州刘璋引刘备入蜀以防汉中张鲁。谋士法正、张松暗中投靠刘备，献西川地形图并密献取蜀之策。刘备驻军葭萌关，厚树恩德以收蜀中民心，为日后取益州埋下伏笔。''',

  // ---- 第四十八章 · 落凤坡 (48) ----
  '''庞统急于建功，率军从小路进攻雒城。行至落凤坡，蜀将张任早已设下伏兵。一声梆子响，两边乱箭齐发如飞蝗骤雨，庞统躲闪不及，中箭落马而亡，年仅三十六岁。''',

  // ---- 第四十九章 · 义释严颜 (49) ----
  '''张飞攻巴郡，用计生擒老将严颜。严颜昂首挺胸道："但有断头将军，无降将军！"张飞感其忠义，亲解其缚，扶之上座，拜伏请罪。严颜感其诚意，归降刘备。''',

  // ---- 第五十章 · 马超归刘 (50) ----
  '''马超被曹操离间计所败，家眷尽遭屠戮，走投无路投奔汉中张鲁。后闻刘备仁义爱士，遣人送书请降。刘备得马超如虎添翼，兵不血刃即逼降成都，益州遂定。''',

  // ---- 第五十一章 · 刘璋归降 (51) ----
  '''成都被围数十日，城中粮尽，百姓饿殍遍地。刘璋不忍百姓受苦，决意开城出降。刘备入主成都，自领益州牧，以诸葛亮为军师，法正为谋主，赏罚分明，蜀中大治。''',

  // ---- 第五十二章 · 逍遥津之战 (52) ----
  '''孙权率十万大军攻合肥。张辽率八百敢死队趁吴军立足未稳率先冲阵，大破吴军，杀伤无数。孙权纵马跃过断桥方得脱险。张辽威震逍遥津，江东小儿闻其名不敢夜啼。''',

  // ---- 第五十三章 · 曹操收汉中 (53) ----
  '''曹操亲率大军征汉中张鲁，张鲁不战而降，献上汉中全境。司马懿劝曹操乘胜南下取蜀，曹操因后方不稳、士卒疲困而退回许昌，留下夏侯渊、张郃镇守汉中。''',

  // ---- 第五十四章 · 定军山 (54) ----
  '''刘备亲率大军北征汉中，法正随军出谋划策。法正献策抢占定军山制高点，居高临下以逸待劳。夏侯渊率曹兵来夺山，两军在山前对峙，战鼓声震天动地。''',

  // ---- 第五十五章 · 黄忠斩夏侯 (55) ----
  '''法正在山顶举红旗为号，老将黄忠从定军山上俯冲而下，势如猛虎下山。刀光一闪，夏侯渊被劈落马下。曹军大乱，张郃率残部退守阳平关，汉中震动。''',

  // ---- 第五十六章 · 子龙一身胆 (56) ----
  '''赵云率数十骑出营侦察，遇曹操大军压境。他退入寨中却大开营门，偃旗息鼓，独自挺枪立马于营门之外。曹操疑有重兵埋伏，不敢冒进，引兵退去。赵云擂鼓追击，曹军大乱。''',

  // ---- 第五十七章 · 刘备称王 (57) ----
  '''曹操退兵，汉中全境归刘备。刘备于沔阳设坛，自立为汉中王，上表献帝。封关羽为前将军、张飞为右将军、马超为左将军、黄忠为后将军、赵云为翊军将军，合称五虎大将。''',

  // ---- 第五十八章 · 水淹七军 (58) ----
  '''关羽率军北攻樊城。八月天降大雨，汉水暴涨。关羽掘开堤坝，洪水汹涌而下，于禁七军尽数淹没。于禁投降，先锋庞德不屈被杀。关羽威震华夏，曹操几欲迁都以避其锋。''',

  // ---- 第五十九章 · 走麦城 (59) ----
  '''吕蒙诈病，陆逊献书骄关羽之心，使其抽调荆州守军北援。吕蒙趁机白衣渡江袭取荆州，关羽腹背受敌，败退麦城。突围时于临沮被吴军所擒，孙权下令斩首，一代名将陨落。''',

  // ---- 第六十章 · 曹操之死 (60) ----
  '''曹操患头风病日渐沉重，痛不可忍。华佗诊断须开颅取涎方可治愈，曹操疑其欲谋害自己，将华佗下狱拷打至死。建安二十五年正月，曹操病逝洛阳，终年六十六岁。''',

  // ---- 第六十一章 · 曹丕篡汉 (61) ----
  '''曹操病逝后曹丕继位，逼迫献帝禅让。献帝被迫在许昌筑受禅台，曹丕登基称帝，改国号为魏，追尊曹操为魏武帝。四百年大汉王朝至此终结，天下进入三足鼎立时代。''',

  // ---- 第六十二章 · 刘备称帝 (62) ----
  '''成都传闻献帝遇害，群臣纷纷劝进。刘备于建安二十六年登基称帝，国号汉（史称蜀汉），以诸葛亮为丞相，以许靖为司徒。下诏誓讨曹魏，复兴汉室。''',

  // ---- 第六十三章 · 张飞遇害 (63) ----
  '''关羽遇害，张飞悲愤欲绝，誓伐东吴为兄报仇。命部将范疆、张达三日内备齐白旗白甲，二人苦求宽限不得，趁夜潜入帐中刺杀张飞，割下首级投奔东吴。''',

  // ---- 第六十四章 · 夷陵之战 (64) ----
  '''刘备倾蜀汉举国之力伐吴，大军水陆并进。陆逊主动退却，让出数百里险要山地。蜀军长驱直入，连营七百余里。陆逊见蜀军兵疲意懈、营寨相连于密林之中，知战机已至。''',

  // ---- 第六十五章 · 火烧连营 (65) ----
  '''盛夏蜀军扎营密林深处以避酷暑。陆逊命士卒各执茅草火把，趁东南风起冲入蜀营纵火。火借风势，火烧连营七百里。蜀军大乱，自相践踏，刘备仅带数百骑逃入白帝城。''',

  // ---- 第六十六章 · 白帝托孤 (66) ----
  '''刘备病危召诸葛亮于白帝城永安宫榻前，托付后事："嗣子可辅则辅之，如其不才君可自取。"诸葛亮泣拜受命："臣敢竭股肱之力，效忠贞之节，继之以死。"言罢刘备驾崩。''',

  // ---- 第六十七章 · 七擒孟获 (67) ----
  '''南中蛮王孟获叛乱，诸葛亮亲自南征。与孟获交战，七次擒获七次释放。孟获终于诚心降服："丞相天威，南人不复反矣。"诸葛亮平定南中，班师回朝准备北伐。''',

  // ---- 第六十八章 · 出师表 (68) ----
  '''诸葛亮上《出师表》，辞别后主北伐曹魏。"先帝创业未半而中道崩殂，今天下三分，益州疲弊，此诚危急存亡之秋也。"字字泣血，句句忠心，千古流传。''',

  // ---- 第六十九章 · 收姜维 (69) ----
  '''诸葛亮攻天水郡，见魏将姜维文武双全、忠孝两全，心生爱才之意。设计离间，散布姜维已降蜀汉的假消息。天水太守中计怀疑姜维，将其拒之门外，姜维走投无路归降，后成蜀汉栋梁。''',

  // ---- 第七十章 · 失街亭 (70) ----
  '''马谡自告奋勇请守街亭要地，诸葛亮再三叮嘱当道下寨以拒魏兵。马谡刚愎自用扎营山顶，被张郃断水围攻，全军溃败。街亭失守，诸葛亮挥泪斩马谡，自贬三级以谢罪。''',

  // ---- 第七十一章 · 空城计 (71) ----
  '''司马懿十五万大军压境，诸葛亮城中仅余老弱残兵。他令大开城门，派老军洒扫街道，自己独坐城楼焚香抚琴。司马懿疑有埋伏，令后军变前军，引兵退去。此为千古绝唱。''',

  // ---- 第七十二章 · 六出祁山 (72) ----
  '''诸葛亮先后六次从祁山道北伐中原，虽屡战屡胜斩将夺城，但终因粮草不济、蜀道艰险未能克定中原。以攻为守，耗尽曹魏国力，维系蜀汉国运于不倒。''',

  // ---- 第七十三章 · 木牛流马 (73) ----
  '''蜀道艰险运粮困难，大军常因断粮而退。诸葛亮发明木牛流马，不饮不食能自行翻山越岭运送粮草。司马懿派兵抢夺仿制，却不知其中暗藏机关，反被蜀军所困。''',

  // ---- 第七十四章 · 上方谷 (74) ----
  '''诸葛亮诱司马懿入上方谷，伏兵四起火攻，山谷化为一片火海。司马懿下马抱二子大哭："我父子三人皆死于此地矣！"忽然天降倾盆大雨浇灭大火，司马懿父子侥幸逃脱。''',

  // ---- 第七十五章 · 五丈原 (75) ----
  '''诸葛亮积劳成疾，病倒五丈原军中。夜观天象见主星幽暗，自知命不久矣。临终遗命秘不发丧，嘱姜维缓缓退兵，又授杨仪锦囊妙计以诛魏延。言讫而逝，年仅五十四岁。''',

  // ---- 第七十六章 · 姜维北伐 (76) ----
  '''姜维继承丞相遗志，先后九次北伐中原，与邓艾斗智斗勇互有胜负。然蜀汉国小民贫，连年征战国力日衰，朝中又有黄皓弄权。姜维独木难支，终难扭转大势。''',

  // ---- 第七十七章 · 偷渡阴平 (77) ----
  '''邓艾率精锐从阴平小道攀崖而下，以毡裹身从绝壁滚落，三千将士历经七天七夜万险如神兵天降，直抵江油城下。蜀汉守将不战而降，邓艾长驱直入直逼成都。''',

  // ---- 第七十八章 · 蜀汉灭亡 (78) ----
  '''诸葛瞻父子率军战死绵竹，成都已无可用之兵。刘禅召群臣议降，谯周力主降魏。刘禅自缚出降，蜀汉历二帝四十三年而亡。后主被迁洛阳，留下"乐不思蜀"的千古笑谈。''',

  // ---- 第七十九章 · 三家归晋 (79) ----
  '''司马炎废魏帝曹奂自立，国号晋。晋军水陆并进伐吴，王濬楼船沿江东下势如破竹，孙皓效刘禅自缚请降。公元二百八十年天下归一，三国时代终结，正所谓"天下大势，分久必合"。''',
];

/// 剧情章节详情页
///
/// 从剧情列表 item 区域弹出，以古风卷轴/竹简样式
/// 滚动展示章节完整故事文案。
class StoryChapterPage extends StatefulWidget {
  const StoryChapterPage({super.key, required this.chapterIndex});

  final int chapterIndex;

  @override
  State<StoryChapterPage> createState() => _StoryChapterPageState();
}

class _StoryChapterPageState extends State<StoryChapterPage> {
  bool _textComplete = false;

  ChapterData get chapter => kChapters[widget.chapterIndex];
  String get storyText => _kChapterStoryTexts[widget.chapterIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          '${chapter.name} · ${chapter.title}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFFE2D9CD),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Color(0xFFE2D9CD),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFE2D9CD)),
        actions: [
          // 字数提示
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '约${storyText.length}字',
                style: const TextStyle(fontSize: 12, color: Color(0x668B7E6A)),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // 背景图
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/ui/story_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // 遮罩渐变
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0x001A0F0A),
                    const Color(0x801A0F0A),
                    const Color(0xCC1A0F0A),
                  ],
                  stops: const [0.0, 0.15, 1.0],
                ),
              ),
            ),
          ),
          // 卷轴正文内容
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
              physics: const BouncingScrollPhysics(),
              children: [
                // ---- 章节卷首 ----
                _ScrollHeader(chapter: chapter),
                const SizedBox(height: 28),

                // ---- 竹简/卷轴容器 ----
                _BambooScroll(
                  child: _StoryTextView(
                    storyText: storyText,
                    onComplete: () {
                      if (mounted) setState(() => _textComplete = true);
                    },
                  ),
                ),

                if (_textComplete) ...[
                  const SizedBox(height: 24),
                  _ChapterActionButton(chapterIndex: widget.chapterIndex),
                ],

                const SizedBox(height: 32),

                // ---- 底部印记 ----
                _ScrollFooter(chapter: chapter),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== 卷首标题 ====================

class _ScrollHeader extends StatelessWidget {
  const _ScrollHeader({required this.chapter});
  final ChapterData chapter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 标签
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0x25A11717),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0x40A11717), width: 0.5),
          ),
          child: Text(
            chapter.name,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xCCA11717),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // 标题
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFFFD78C), Color(0xFFE2D9CD), Color(0xFFFFD78C)],
          ).createShader(bounds),
          child: Text(
            chapter.title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(255, 236, 235, 231),
              letterSpacing: 8,
            ),
          ),
        ),
        const SizedBox(height: 8),
        // 副标题
        Text(
          chapter.plot,
          style: const TextStyle(
            fontSize: 13,
            color: Color.fromARGB(135, 235, 233, 231),
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 10),
        // 年代
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: const Color.fromARGB(20, 172, 30, 30),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            chapter.year,
            style: const TextStyle(
              fontSize: 12,
              color: Color.fromARGB(135, 223, 210, 190),
              letterSpacing: 2,
            ),
          ),
        ),
      ],
    );
  }
}

// ==================== 竹简卷轴容器 ====================

class _BambooScroll extends StatelessWidget {
  const _BambooScroll({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xEE1E1A16),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x30D4A84B), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0x40000000),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 竹简纹理（暗竖线）
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomPaint(painter: _BambooLinePainter()),
            ),
          ),
          // 内容
          Padding(padding: const EdgeInsets.all(20), child: child),
        ],
      ),
    );
  }
}

/// 竹简竖线纹理绘制器
class _BambooLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x08FFFFFF)
      ..strokeWidth = 1;
    const spacing = 30.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==================== 故事正文（逐字呈现） ====================

class _StoryTextView extends StatefulWidget {
  const _StoryTextView({required this.storyText, this.onComplete});
  final String storyText;
  final VoidCallback? onComplete;

  @override
  State<_StoryTextView> createState() => _StoryTextViewState();
}

class _StoryTextViewState extends State<_StoryTextView> {
  late final String _plainText;
  int _displayed = 0;
  Timer? _timer;
  bool _cursorVisible = true;
  Timer? _cursorTimer;

  // 逐字速度（毫秒/字）—— 快速呈现
  static const _kCharDelay = Duration(milliseconds: 28);

  @override
  void initState() {
    super.initState();
    // 将原文按段落拼接为纯文本，用于逐字计数
    _plainText = _flatten(widget.storyText);
    _startTyping();
  }

  @override
  void didUpdateWidget(covariant _StoryTextView old) {
    super.didUpdateWidget(old);
    if (old.storyText != widget.storyText) {
      _plainText = _flatten(widget.storyText);
      _displayed = 0;
      _startTyping();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  void _startTyping() {
    _timer?.cancel();
    _cursorTimer?.cancel();
    _cursorVisible = true;

    _cursorTimer = Timer.periodic(const Duration(milliseconds: 530), (t) {
      if (mounted) setState(() => _cursorVisible = !_cursorVisible);
    });

    _timer = Timer.periodic(_kCharDelay, (t) {
      if (!mounted) return;
      if (_displayed >= _plainText.length) {
        t.cancel();
        _cursorTimer?.cancel();
        if (mounted) setState(() => _cursorVisible = false);
        widget.onComplete?.call();
        return;
      }
      setState(() => _displayed++);
    });
  }

  /// 将原文展开为展示用的纯文本序列
  /// 每段: 首段无缩进，后续段落 "\n\n　　段落内容"
  static String _flatten(String source) {
    final buf = StringBuffer();
    final paragraphs = source.split('\n');
    for (int i = 0; i < paragraphs.length; i++) {
      final para = paragraphs[i].trim();
      if (para.isEmpty && i == 0) continue;
      if (para.isEmpty) {
        buf.write('\n');
        continue;
      }
      if (i == 0) {
        buf.write(para);
      } else {
        buf.write('\n\n\u3000\u3000$para');
      }
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final visible = _displayed > _plainText.length
        ? _plainText
        : _plainText.substring(0, _displayed);
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16,
          height: 2.0,
          color: Color(0xCCE8D5A3),
          fontWeight: FontWeight.w400,
          letterSpacing: 1.5,
          fontFamily: 'serif',
        ),
        children: [
          ..._buildVisibleSpans(visible),
          if (_displayed < _plainText.length || _cursorVisible)
            const TextSpan(
              text: '▎',
              style: TextStyle(fontSize: 16, color: Color(0xCCD4A84B)),
            ),
        ],
      ),
    );
  }

  List<TextSpan> _buildVisibleSpans(String visible) {
    final spans = <TextSpan>[];
    final paragraphs = visible.split('\n');

    for (int i = 0; i < paragraphs.length; i++) {
      final para = paragraphs[i];
      if (para.isEmpty) {
        spans.add(const TextSpan(text: '\n'));
        continue;
      }

      // 首段首字放大效果
      if (i == 0 && para.length >= 1) {
        spans.add(
          TextSpan(
            text: para.substring(0, 1),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFFD4A84B),
            ),
          ),
        );
        if (para.length > 1) {
          spans.add(TextSpan(text: para.substring(1)));
        }
        spans.add(const TextSpan(text: '\n'));
      } else {
        spans.add(TextSpan(text: para));
        if (i < paragraphs.length - 1) {
          spans.add(const TextSpan(text: '\n'));
        }
      }
    }

    return spans;
  }
}

// ==================== 章节操作按钮 ====================

class _ChapterActionButton extends StatelessWidget {
  const _ChapterActionButton({required this.chapterIndex});
  final int chapterIndex;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          );
        },
        child: GestureDetector(
          onTap: () {
            context.pushNamed(
              'stageList',
              pathParameters: {'chapterId': chapterIndex.toString()},
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF8B1A1A),
                  Color(0xFFA11717),
                  Color(0xFF6B1010),
                ],
              ),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0x60D4A84B), width: 1),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x60000000),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Text(
              '进入征战',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE2D9CD),
                letterSpacing: 6,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== 卷尾印记 ====================

class _ScrollFooter extends StatelessWidget {
  const _ScrollFooter({required this.chapter});
  final ChapterData chapter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 分隔线
        Row(
          children: [
            Expanded(
              child: Container(height: 0.5, color: const Color(0x306A0F0F)),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                Icons.auto_stories,
                size: 16,
                color: Color(0x406A0F0F),
              ),
            ),
            Expanded(
              child: Container(height: 0.5, color: const Color(0x306A0F0F)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          '—— ${chapter.name} · ${chapter.title}  终 ——',
          style: const TextStyle(
            fontSize: 13,
            color: Color(0x556A0F0F),
            letterSpacing: 3,
          ),
        ),
      ],
    );
  }
}

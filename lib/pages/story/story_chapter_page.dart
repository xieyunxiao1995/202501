import 'package:flutter/material.dart';

import '../story_page.dart';

// ====================================================================
// 80 章剧情文案 — 每章约 50 字
// ====================================================================

const _kChapterStoryTexts = <String>[
  // ---- 序章 · 黄巾之乱 (0) ----
  '''东汉末年，桓灵失道，宦官弄权。巨鹿人张角得《太平要术》，自称大贤良师，聚众数十万，头裹黄巾，揭竿而起。天下大乱的序幕就此拉开。''',

  // ---- 第一章 · 桃园结义 (1) ----
  '''幽州涿郡，刘备、关羽、张飞三人在桃园中结为异姓兄弟，立誓同心协力、上报国家、下安黎庶。从此开始了他们的传奇征程。''',

  // ---- 第二章 · 十常侍乱政 (2) ----
  '''黄巾初平，灵帝驾崩。十常侍把持朝纲，卖官鬻爵。何进召董卓入京，事泄被宦官所杀。袁绍率兵冲入皇宫，宦官尽数伏诛。''',

  // ---- 第三章 · 何进之死 (3) ----
  '''何进优柔寡断，不听曹操劝谏，执意召外兵入京。十常侍假传太后懿旨，诱何进入宫，伏兵将其斩杀。洛阳城大乱骤起。''',

  // ---- 第四章 · 董卓进京 (4) ----
  '''董卓率西凉铁骑入洛阳，收编何进旧部，又收买吕布杀丁原。他废少帝、立献帝，自封相国，权倾朝野，残暴不仁。''',

  // ---- 第五章 · 曹操献刀 (5) ----
  '''曹操向王允借七星宝刀，假意献刀行刺董卓。事败后飞马逃出洛阳，被陈宫所擒又释。曹操说"宁可我负天下人"，杀吕伯奢全家。''',

  // ---- 第六章 · 诸侯讨董 (6) ----
  '''曹操发讨董檄文，袁绍为盟主，十八路诸侯齐聚。孙坚为先锋攻汜水关，被华雄所败。关羽温酒斩华雄，一战成名。''',

  // ---- 第七章 · 温酒斩华雄 (7) ----
  '''华雄连斩联军数将，众皆失色。关羽请战，曹操斟热酒。关羽道"酒且斟下"，出帐提刀，片刻斩华雄归，其酒尚温。''',

  // ---- 第八章 · 三英战吕布 (8) ----
  '''虎牢关前，吕布手持方天画戟无人能敌。张飞挺矛出战，关羽挥刀助阵，刘备掣双股剑加入。三英合力逼退吕布，名扬天下。''',

  // ---- 第九章 · 火烧洛阳 (9) ----
  '''董卓挟持天子迁都长安。临行纵兵焚洛阳，掘皇陵、掠珍宝。千年帝都化为焦土，百万百姓死伤遍野，惨绝人寰。''',

  // ---- 第十章 · 孙坚得玉玺 (10) ----
  '''孙坚率兵入洛阳救火，于建章殿南枯井中偶得传国玉玺。程普谏曰此天命所归，孙坚遂生异心，托病率军返回江东。''',

  // ---- 第十一章 · 连环计 (11) ----
  '''王允以义女貂蝉设连环计。先许吕布，后献董卓。貂蝉从中挑拨，二人反目成仇。吕布为夺貂蝉，决意诛杀董卓。''',

  // ---- 第十二章 · 吕布杀董卓 (12) ----
  '''王允假传天子禅位诏书，诱董卓入宫。吕布一戟刺死董卓，暴尸街头，百姓燃火置其脐中。一代权臣就此毙命。''',

  // ---- 第十三章 · 李郭之乱 (13) ----
  '''董卓旧部李傕、郭汜纳贾诩之策，率西凉兵反攻长安。吕布败走，王允全家遇害。天子沦为傀儡，长安再遭兵祸。''',

  // ---- 第十四章 · 曹操救驾 (14) ----
  '''李傕郭汜内斗不休，献帝辗转于兵火。曹操采纳荀彧之策，迎天子于许昌，从此挟天子以令诸侯，名正言顺号令天下。''',

  // ---- 第十五章 · 吕布夺徐州 (15) ----
  '''吕布趁刘备征袁术之机，夜袭徐州得手。刘备回军，吕布反让刘备屯驻小沛。张飞醉酒失城，羞愤难当。''',

  // ---- 第十六章 · 孙策定江东 (16) ----
  '''孙策以传国玉玺为质，从袁术处借兵三千。与周瑜联手，横扫江东六郡八十一州，人称"小霸王"，奠定东吴基业。''',

  // ---- 第十七章 · 辕门射戟 (17) ----
  '''袁术派纪灵攻刘备，吕布设宴调解。他在辕门外立方天画戟，一箭正中戟上小枝，双方骇然罢兵。''',

  // ---- 第十八章 · 曹操征张绣 (18) ----
  '''曹操南征张绣，张绣先降后叛。典韦为护曹操力战而死，曹操长子曹昂亦殁。曹操痛哭："吾失长子，不痛典韦！"''',

  // ---- 第十九章 · 吕布殒命 (19) ----
  '''曹操水淹下邳，吕布被部下捆绑献降。白门楼上，刘备一句"明公不见丁原董卓之事乎"，曹操下令缢杀吕布。''',

  // ---- 第二十章 · 煮酒论英雄 (20) ----
  '''曹操邀刘备青梅煮酒，指天论天下英雄。刘备假借雷声惊箸掩饰，曹操笑道："今天下英雄，惟使君与操耳。"''',

  // ---- 第二十一章 · 衣带诏 (21) ----
  '''献帝血写密诏藏于衣带，赐国丈董承。董承联络马腾、刘备等忠义之士，密谋诛曹。事泄后五人满门抄斩。''',

  // ---- 第二十二章 · 斩颜良诛文丑 (22) ----
  '''袁绍遣颜良攻白马，关羽单骑冲阵，一刀斩颜良于马下。复于延津诛文丑，河北军望风而溃。关羽报恩已毕，挂印封金而去。''',

  // ---- 第二十三章 · 过五关斩六将 (23) ----
  '''关羽护二位嫂嫂千里寻兄，一路过东岭、洛阳、汜水、荥阳、黄河五关，连斩孔秀、韩福、卞喜、王植、秦琪六将。''',

  // ---- 第二十四章 · 古城相会 (24) ----
  '''关羽于古城遇张飞，张飞疑其降曹。恰逢蔡阳追至，关羽一刀斩蔡阳以明心迹。刘备亦到，三兄弟重逢，悲喜交加。''',

  // ---- 第二十五章 · 官渡之战 (25) ----
  '''袁绍率精兵十万南下攻曹。双方在官渡对峙数月。曹操兵少粮匮，形势危急，然而袁绍刚愎自用，屡拒良谋。''',

  // ---- 第二十六章 · 乌巢烧粮 (26) ----
  '''许攸投曹操献计袭乌巢。曹操亲率五千精兵，夜行昼伏，火烧袁军囤粮。淳于琼醉卧被斩，袁军粮草付之一炬。''',

  // ---- 第二十七章 · 袁绍败亡 (27) ----
  '''乌巢粮草被焚，袁军大乱。曹操挥师掩杀，袁绍仅带八百骑渡河北逃。十万大军一朝覆灭，袁绍不久郁郁而终。''',

  // ---- 第二十八章 · 平定河北 (28) ----
  '''袁绍死后诸子内讧，曹操乘机逐一击破。袁谭被斩，袁熙袁尚北逃乌桓。曹操历经数年，终将河北四州收入囊中。''',

  // ---- 第二十九章 · 徐庶荐诸葛 (29) ----
  '''徐庶助刘备大败曹仁，曹操扣押徐母逼其北归。徐庶临行荐卧龙："此人有经天纬地之才，主公宜亲往求之。"''',

  // ---- 第三十章 · 三顾茅庐 (30) ----
  '''刘备三访隆中。初次不遇，二次遇弟诸葛均，三次立于阶下候孔明午睡。诸葛亮醒后出迎，飘然有神仙之姿。''',

  // ---- 第三十一章 · 隆中对 (31) ----
  '''诸葛亮分析天下大势：曹操拥百万之众不可争锋，孙权据江东可援不可图。取荆州益州为基业，待时而动可成鼎足之势。''',

  // ---- 第三十二章 · 博望坡之战 (32) ----
  '''夏侯惇率十万兵攻新野。诸葛亮初掌兵权，使赵云诈败诱敌，引夏侯惇入博望坡。一把大火烧得曹军人仰马翻。''',

  // ---- 第三十三章 · 火烧新野 (33) ----
  '''曹操命曹仁再攻新野。诸葛亮弃城诱敌，于城中布下硫磺火种。曹军入城后火光大作，死伤无数，败退白河。''',

  // ---- 第三十四章 · 长坂坡救主 (34) ----
  '''曹操追至长坂坡，刘备家小失散。赵云单枪匹马于曹军阵中七进七出，杀曹将五十余员，救出阿斗，血染战袍。''',

  // ---- 第三十五章 · 当阳桥断后 (35) ----
  '''张飞率二十骑立于当阳桥头，厉声大喝："燕人张翼德在此！谁敢决一死战？"声如巨雷，曹军无人敢上前。''',

  // ---- 第三十六章 · 舌战群儒 (36) ----
  '''诸葛亮赴江东，面对张昭等主和派群儒，从容答辩、逐一驳倒。鲁肃为之折服，孙权为之动容。''',

  // ---- 第三十七章 · 草船借箭 (37) ----
  '''周瑜令诸葛亮十日造十万支箭。诸葛亮立军令状只需三日。趁大雾弥江，率二十草船擂鼓逼曹营，得箭十万余。''',

  // ---- 第三十八章 · 苦肉计 (38) ----
  '''黄盖主动献苦肉计，甘受军杖五十。阚泽渡江下诈降书，曹操见黄盖伤痕累累深信不疑，约定以青龙牙旗为号。''',

  // ---- 第三十九章 · 借东风 (39) ----
  '''万事俱备只欠东风，周瑜急病卧床。诸葛亮称能借三日三夜东南风，登七星坛披发仗剑作法。霎时风起，旗幡西指。''',

  // ---- 第四十章 · 火烧赤壁 (40) ----
  '''东南风大作，黄盖率二十艘火船直冲曹营。火借风势，烈焰冲天，曹军船舰尽数焚毁。周瑜挥军掩杀，曹操大败而逃。''',

  // ---- 第四十一章 · 华容道 (41) ----
  '''曹操败走华容道，遇关羽拦路。曹操以昔日恩情相求，关羽念旧义释曹操。孔明知其必放，以此偿还人情。''',

  // ---- 第四十二章 · 智取南郡 (42) ----
  '''周瑜与曹仁激战南郡，诸葛亮趁虚遣赵云夺城。周瑜中箭负伤，又被关羽张飞截杀。气得金疮迸裂，昏绝于地。''',

  // ---- 第四十三章 · 三气周瑜 (43) ----
  '''诸葛亮先取南郡，再以锦囊妙计助刘备过江成亲，又于芦花荡伏兵拦截。周瑜三次受挫，大叫"既生瑜何生亮"气绝而亡。''',

  // ---- 第四十四章 · 凤雏理政 (44) ----
  '''庞统经诸葛亮推荐见刘备，初被慢待任耒阳县令。他一月不理政事，却在一日内断尽积压百案，刘备大惊，拜为副军师。''',

  // ---- 第四十五章 · 马超起兵 (45) ----
  '''马超为报杀父之仇，联合韩遂起兵反曹。西凉军骁勇善战，连破长安潼关，曹操割须弃袍方得脱逃。''',

  // ---- 第四十六章 · 许褚斗马超 (46) ----
  '''许褚裸衣与马超在渭水之滨大战二百余合，不分胜负。两军将士看得目瞪口呆。曹操赞道："马超不减吕布之勇。"''',

  // ---- 第四十七章 · 刘备入川 (47) ----
  '''刘璋引刘备入蜀以防张鲁。法正、张松暗中投靠刘备，献西川地形图。刘备驻军葭萌关，厚树恩德以收蜀中民心。''',

  // ---- 第四十八章 · 落凤坡 (48) ----
  '''庞统急于建功，率军从小路进攻雒城。至落凤坡遭遇张任伏兵，乱箭齐发，庞统中箭落马而亡，年仅三十六岁。''',

  // ---- 第四十九章 · 义释严颜 (49) ----
  '''张飞攻巴郡，用计生擒老将严颜。严颜昂首道："但有断头将军，无降将军。"张飞感其忠义，亲解其缚待为上宾。''',

  // ---- 第五十章 · 马超归刘 (50) ----
  '''马超被曹操离间，兵败走投汉中。后闻刘备仁义，遣人送书请降。刘备得马超如虎添翼，兵不血刃逼降成都。''',

  // ---- 第五十一章 · 刘璋归降 (51) ----
  '''围城数十日，刘璋不忍百姓受苦，开城出降。刘备入主成都，自领益州牧。以诸葛亮为军师，法正为谋主。''',

  // ---- 第五十二章 · 逍遥津之战 (52) ----
  '''孙权率十万大军攻合肥。张辽率八百敢死队冲阵，大破吴军，孙权跃马过断桥方得脱险。张辽威震逍遥津。''',

  // ---- 第五十三章 · 曹操收汉中 (53) ----
  '''曹操亲征汉中张鲁，张鲁不战而降。司马懿劝曹操乘胜取蜀，曹操因后方不稳而退，留下夏侯渊镇守汉中。''',

  // ---- 第五十四章 · 定军山 (54) ----
  '''刘备亲率大军北征汉中。法正献策抢占定军山制高点，以逸待劳。夏侯渊率兵来夺，两军在山前对峙。''',

  // ---- 第五十五章 · 黄忠斩夏侯 (55) ----
  '''法正举旗为号，黄忠从定军山上俯冲而下。刀光闪过，夏侯渊被斩落马下。曹军大乱，张郃率残部退守。''',

  // ---- 第五十六章 · 子龙一身胆 (56) ----
  '''赵云率数十骑出营遇曹操大军。退入寨中大开营门，偃旗息鼓。曹操疑有伏兵退去，赵云擂鼓追击，曹军大乱。''',

  // ---- 第五十七章 · 刘备称王 (57) ----
  '''曹操退兵，汉中全境归刘。刘备于沔阳设坛，自立为汉中王。封关羽、张飞、马超、黄忠、赵云为五虎大将。''',

  // ---- 第五十八章 · 水淹七军 (58) ----
  '''关羽北攻樊城。八月大雨汉水暴涨，关羽掘堤放水，于禁七军尽数淹没。于禁投降，先锋庞德不屈被杀。''',

  // ---- 第五十九章 · 走麦城 (59) ----
  '''吕蒙白衣渡江袭取荆州。关羽腹背受敌，退守麦城。突围时于临沮被吴军所擒，孙权下令斩首，一代名将陨落。''',

  // ---- 第六十章 · 曹操之死 (60) ----
  '''曹操患头风病日渐沉重。华佗建议开颅取涎，曹操疑其谋害下狱。建安二十五年正月，曹操病逝洛阳，终年六十六岁。''',

  // ---- 第六十一章 · 曹丕篡汉 (61) ----
  '''曹丕继位后逼献帝禅让。献帝被迫筑受禅台，曹丕改国号为魏，迁都洛阳。四百年大汉王朝至此终结。''',

  // ---- 第六十二章 · 刘备称帝 (62) ----
  '''成都传闻献帝遇害，群臣劝进。刘备于建安二十六年登基，国号汉（史称蜀汉），以诸葛亮为丞相。''',

  // ---- 第六十三章 · 张飞遇害 (63) ----
  '''张飞悲愤伐吴，命部将范疆张达三日内备齐白旗白甲。二人苦求不得夜刺杀张飞，割下首级投奔东吴。''',

  // ---- 第六十四章 · 夷陵之战 (64) ----
  '''刘备倾举国之力伐吴。陆逊主动退却，让出数百里险要。蜀军长驱直入，连营七百余里，骄兵深入，埋下败因。''',

  // ---- 第六十五章 · 火烧连营 (65) ----
  '''盛夏蜀军扎营密林。陆逊命士卒手持茅草火攻，东南风起火烧连营七百里。蜀军大乱，刘备仅带数百骑逃入白帝城。''',

  // ---- 第六十六章 · 白帝托孤 (66) ----
  '''刘备病危召诸葛亮于榻前，托付后事："嗣子可辅则辅之，如其不才君可自取。"诸葛亮泣拜受命。言罢刘备驾崩。''',

  // ---- 第六十七章 · 七擒孟获 (67) ----
  '''南中叛乱，诸葛亮亲自南征。与蛮王孟获交战，七次擒获七次释放。孟获终于诚心降服："丞相天威，南人不复反矣。"''',

  // ---- 第六十八章 · 出师表 (68) ----
  '''诸葛亮上《出师表》，辞别后主北伐曹魏。"先帝创业未半而中道崩殂，今天下三分，益州疲弊，此诚危急存亡之秋也。"''',

  // ---- 第六十九章 · 收姜维 (69) ----
  '''诸葛亮攻天水，见姜维文武双全、忠孝两全，心生爱才之意。设计离间使其被天水太守所疑，姜维走投无路归降。''',

  // ---- 第七十章 · 失街亭 (70) ----
  '''马谡请守街亭，诸葛亮再三叮嘱当道下寨。马谡刚愎自用扎营山顶，被张郃断水围攻。街亭失守，诸葛亮挥泪斩马谡。''',

  // ---- 第七十一章 · 空城计 (71) ----
  '''司马懿十五万大军压境。诸葛亮大开城门，独坐城楼焚香抚琴。司马懿疑有埋伏，引兵退去。此为千古绝唱。''',

  // ---- 第七十二章 · 六出祁山 (72) ----
  '''诸葛亮先后六次从祁山道北伐中原，虽屡战屡胜但粮草不济未能克定中原。以攻为守，维系蜀汉国运。''',

  // ---- 第七十三章 · 木牛流马 (73) ----
  '''蜀道艰险运粮困难。诸葛亮发明木牛流马，不饮不食能自行运送粮草。司马懿派兵抢夺仿制，却被机关所困。''',

  // ---- 第七十四章 · 上方谷 (74) ----
  '''诸葛亮诱司马懿入上方谷，伏兵四起火攻。司马懿抱子大哭。忽然天降大雨浇灭大火，司马懿侥幸逃脱。''',

  // ---- 第七十五章 · 五丈原 (75) ----
  '''诸葛亮积劳成疾，病倒五丈原军中。夜观天象见将星幽暗，自知不久。临终遗命秘不发丧，嘱姜维缓缓退兵。''',

  // ---- 第七十六章 · 姜维北伐 (76) ----
  '''姜维继承丞相遗志，先后九次北伐中原。与邓艾斗智斗勇互有胜负。然蜀汉国力日衰，终难扭转大势。''',

  // ---- 第七十七章 · 偷渡阴平 (77) ----
  '''邓艾率精锐从阴平小道攀崖而下，以毡裹身滚落绝壁。全军历经万险如神兵天降，直抵江油城下。''',

  // ---- 第七十八章 · 蜀汉灭亡 (78) ----
  '''诸葛瞻父子战死绵竹。刘禅召群臣议降，谯周力主降魏。刘禅自缚出降，蜀汉历二帝四十三年而亡。''',

  // ---- 第七十九章 · 三家归晋 (79) ----
  '''司马炎废魏帝自立，国号晋。晋军水陆并进伐吴，孙皓效刘禅自缚请降。公元二百八十年天下归一，三国时代终结。''',
];

/// 剧情章节详情页
///
/// 从剧情列表 item 区域弹出，以古风卷轴/竹简样式
/// 滚动展示章节完整故事文案。
class StoryChapterPage extends StatelessWidget {
  const StoryChapterPage({super.key, required this.chapterIndex});

  /// 章节索引 (0 = 序章, 1 = 第一章, ..., 15 = 第十五章)
  final int chapterIndex;

  ChapterData get chapter => kChapters[chapterIndex];
  String get storyText => _kChapterStoryTexts[chapterIndex];

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
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFFE2D9CD)),
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
                _BambooScroll(child: _StoryTextView(storyText: storyText)),

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
            style: const TextStyle(fontSize: 12, color: Color(0xCCA11717), fontWeight: FontWeight.w500),
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
          style: const TextStyle(fontSize: 13, color: Color.fromARGB(135, 235, 233, 231), letterSpacing: 2),
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
            style: const TextStyle(fontSize: 12, color: Color.fromARGB(135, 223, 210, 190), letterSpacing: 2),
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
          BoxShadow(color: const Color(0x40000000), blurRadius: 16, offset: const Offset(0, 4)),
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
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

// ==================== 故事正文 ====================

class _StoryTextView extends StatelessWidget {
  const _StoryTextView({required this.storyText});
  final String storyText;

  @override
  Widget build(BuildContext context) {
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
        children: _buildSpans(storyText),
      ),
    );
  }

  List<TextSpan> _buildSpans(String text) {
    final spans = <TextSpan>[];
    final paragraphs = text.split('\n');

    for (int i = 0; i < paragraphs.length; i++) {
      final para = paragraphs[i].trim();
      if (para.isEmpty) {
        spans.add(const TextSpan(text: '\n'));
        continue;
      }

      // 首字放大效果
      if (i == 0 && para.length >= 2) {
        spans.add(TextSpan(
          text: para.substring(0, 1),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFFD4A84B),
          ),
        ));
        spans.add(TextSpan(text: '${para.substring(1)}\n'));
      } else {
        // 段落首行缩进
        spans.add(TextSpan(
          text: '　　$para',
        ));
        // 段落间空行
        if (i < paragraphs.length - 1) {
          spans.add(const TextSpan(text: '\n\n'));
        }
      }
    }

    return spans;
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
            Expanded(child: Container(height: 0.5, color: const Color(0x306A0F0F))),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.auto_stories, size: 16, color: Color(0x406A0F0F)),
            ),
            Expanded(child: Container(height: 0.5, color: const Color(0x306A0F0F))),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          '—— ${chapter.name} · ${chapter.title}  终 ——',
          style: const TextStyle(fontSize: 13, color: Color(0x556A0F0F), letterSpacing: 3),
        ),
      ],
    );
  }
}

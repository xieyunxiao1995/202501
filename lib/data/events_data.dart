import '../models/event_model.dart';

final List<GameEvent> allEvents = [
  // 1. Nine-Tailed Fox
  GameEvent(
    id: 'evt_nine_tailed_fox',
    title: '受伤的九尾狐',
    description: '你在灌木丛中发现一只白色的九尾狐，它身上有一道很深的伤口，正在流血。它用充满灵性的眼睛看着你。',
    icon: '🦊',
    options: [
      EventOption(
        label: '治疗它 (-10 精血)',
        description: '你消耗了自己的精血来治疗它。',
        type: EventOutcomeType.gainBuff,
        value: 'blessing_fox',
        probability: 0.7,
        failureOption: EventOption(
          label: '失败',
          description: '狐狸在惊慌中咬了你一口，然后跑掉了！',
          type: EventOutcomeType.damage,
          value: 10,
        ),
      ),
      EventOption(
        label: '猎杀它',
        description: '它的皮毛一定价值连城。',
        type: EventOutcomeType.gainGold,
        value: 100,
        probability: 1.0,
      ),
      EventOption(
        label: '无视',
        description: '不关我的事。',
        type: EventOutcomeType.none,
      ),
    ],
  ),

  // 2. Mysterious Peddler
  GameEvent(
    id: 'evt_peddler',
    title: '幽冥货郎',
    description: '一个驼背的旅行者拦住了你。“西域奇珍，”他低声说道，“但我只收精血作为报酬。”',
    icon: '👺',
    options: [
      EventOption(
        label: '购买灵药 (-20 精血)',
        description: '用生命交换力量。',
        type: EventOutcomeType.gainItem,
        value: 'potion_h',
        probability: 1.0,
      ),
      EventOption(
        label: '强抢',
        description: '能拿多少拿多少！',
        type: EventOutcomeType.gainGold,
        value: 50,
        probability: 0.5,
        failureOption: EventOption(
          label: '遭到反击',
          description: '他是个隐世高手！你受到了重创。',
          type: EventOutcomeType.damage,
          value: 25,
        ),
      ),
      EventOption(
        label: '离开',
        description: '慢慢走开。',
        type: EventOutcomeType.none,
      ),
    ],
  ),

  // 3. Ancient Stele
  GameEvent(
    id: 'evt_stele',
    title: '荒古遗碑',
    description: '一块刻满发光符文的石碑立在你面前。灵能感觉很不稳定。',
    icon: '🗿',
    options: [
      EventOption(
        label: '感悟石碑',
        description: '引导灵能。',
        type: EventOutcomeType.heal,
        value: 50,
        probability: 0.5,
        failureOption: EventOption(
          label: '灵力反噬！',
          description: '灵能失控了！',
          type: EventOutcomeType.damage,
          value: 20,
        ),
      ),
      EventOption(
        label: '摧毁它',
        description: '看起来很危险。',
        type: EventOutcomeType.gainGold,
        value: 20,
      ),
    ],
  ),
  
  // 4. Kuafu's Staff
  GameEvent(
    id: 'evt_kuafu_staff',
    title: '夸父的巨杖',
    description: '一根巨大的木杖深深插入干裂的大地。它散发着微弱的太阳余温。',
    icon: '🪵',
    options: [
      EventOption(
        label: '祈求力量',
        description: '你感受到了巨人的毅力。',
        type: EventOutcomeType.gainBuff,
        value: 'buff_strength',
        probability: 0.8,
        failureOption: EventOption(
          label: '晒伤',
          description: '热量太强了！',
          type: EventOutcomeType.damage,
          value: 15,
        ),
      ),
      EventOption(
        label: '寻找水源',
        description: '你在手杖周围挖掘，发现了一处小泉眼。',
        type: EventOutcomeType.heal,
        value: 30,
      ),
    ],
  ),

  // 5. Nüwa's Five-Colored Stone
  GameEvent(
    id: 'evt_nuwa_stone',
    title: '女娲的神石',
    description: '一块闪烁着五彩光芒的石头悬浮在空中。它似乎正在修复周围的空间。',
    icon: '💎',
    options: [
      EventOption(
        label: '吸收精华',
        description: '你的伤口瞬间愈合。',
        type: EventOutcomeType.heal,
        value: 100,
        probability: 0.6,
        failureOption: EventOption(
          label: '能量过载',
          description: '石头破碎，将你震飞！',
          type: EventOutcomeType.damage,
          value: 40,
        ),
      ),
      EventOption(
        label: '换取灵石',
        description: '这样的石头价值连城。',
        type: EventOutcomeType.gainGold,
        value: 250,
      ),
    ],
  ),
];

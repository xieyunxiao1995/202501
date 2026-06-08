/// 字符串常量类
///
/// 集中管理所有字符串常量，便于维护和后续 ARB 替换。
/// 当前所有字符串为硬编码中文，后续替换为 ARB 文件生成。
///
/// TODO: 后续使用 intl 的 ARB 文件和代码生成工具自动生成多语言字符串，
/// 替换本文件中的硬编码值。
class Strings {
  Strings._();

  // ============================================================
  // 应用信息
  // ============================================================

  /// 应用名称
  static const String appName = '三国谋定天下';

  /// 应用副标题
  static const String appSubtitle = '策略卡牌RPG';

  // ============================================================
  // 通用 UI
  // ============================================================

  /// 确定
  static const String confirm = '确定';

  /// 取消
  static const String cancel = '取消';

  /// 关闭
  static const String close = '关闭';

  /// 返回
  static const String back = '返回';

  /// 保存
  static const String save = '保存';

  /// 删除
  static const String delete = '删除';

  /// 编辑
  static const String edit = '编辑';

  /// 加载中
  static const String loading = '加载中...';

  /// 重试
  static const String retry = '重试';

  /// 提示
  static const String tip = '提示';

  /// 警告
  static const String warning = '警告';

  /// 错误
  static const String error = '错误';

  /// 成功
  static const String success = '成功';

  /// 失败
  static const String failure = '失败';

  /// 暂无数据
  static const String noData = '暂无数据';

  /// 更多
  static const String more = '更多';

  /// 全部
  static const String all = '全部';

  /// 搜索
  static const String search = '搜索';

  /// 筛选
  static const String filter = '筛选';

  /// 排序
  static const String sort = '排序';

  /// 升级
  static const String upgrade = '升级';

  /// 购买
  static const String buy = '购买';

  /// 出售
  static const String sell = '出售';

  /// 使用
  static const String use = '使用';

  /// 领取
  static const String claim = '领取';

  // ============================================================
  // 错误消息
  // ============================================================

  /// 网络连接失败
  static const String networkError = '网络连接失败，请检查网络设置';

  /// 服务器异常
  static const String serverError = '服务器异常，请稍后重试';

  /// 请求超时
  static const String timeoutError = '请求超时，请稍后重试';

  /// 未知错误
  static const String unknownError = '未知错误，请稍后重试';

  /// 登录过期
  static const String tokenExpired = '登录已过期，请重新登录';

  /// 账号被禁用
  static const String accountDisabled = '账号已被禁用，请联系客服';

  /// 版本过低
  static const String versionTooLow = '当前版本过低，请更新到最新版本';

  /// 维护中
  static const String maintenance = '服务器维护中，请稍后再试';

  /// 数据加载失败
  static const String dataLoadError = '数据加载失败';

  /// 存储空间不足
  static const String storageFull = '存储空间不足，请清理后重试';

  // ============================================================
  // 主界面导航
  // ============================================================

  /// 主城
  static const String mainCity = '主城';

  /// 战斗
  static const String battle = '战斗';

  /// 武将
  static const String generals = '武将';

  /// 背包
  static const String backpack = '背包';

  /// 商店
  static const String shop = '商店';

  /// 任务
  static const String quest = '任务';

  /// 阵容
  static const String formation = '阵容';

  /// 联盟
  static const String alliance = '联盟';

  /// 排行榜
  static const String ranking = '排行榜';

  /// 设置
  static const String settings = '设置';

  /// 邮件
  static const String mail = '邮件';

  /// 公告
  static const String announcement = '公告';

  /// 活动
  static const String event = '活动';

  // ============================================================
  // 章节名称
  // ============================================================

  /// 第一章：黄巾之乱
  static const String chapter1 = '第一章：黄巾之乱';

  /// 第二章：讨伐董卓
  static const String chapter2 = '第二章：讨伐董卓';

  /// 第三章：群雄割据
  static const String chapter3 = '第三章：群雄割据';

  /// 第四章：官渡之战
  static const String chapter4 = '第四章：官渡之战';

  /// 第五章：赤壁之战
  static const String chapter5 = '第五章：赤壁之战';

  /// 第六章：三分天下
  static const String chapter6 = '第六章：三分天下';

  /// 第七章：北伐中原
  static const String chapter7 = '第七章：北伐中原';

  /// 第八章：一统天下
  static const String chapter8 = '第八章：一统天下';

  // ============================================================
  // 战斗相关
  // ============================================================

  /// 开战
  static const String startBattle = '开战';

  /// 自动战斗
  static const String autoBattle = '自动战斗';

  /// 手动战斗
  static const String manualBattle = '手动战斗';

  /// 战斗胜利
  static const String battleVictory = '战斗胜利';

  /// 战斗失败
  static const String battleDefeat = '战斗失败';

  /// 回合
  static const String round = '回合';

  /// 伤害
  static const String damage = '伤害';

  /// 治疗
  static const String heal = '治疗';

  /// 暴击
  static const String criticalHit = '暴击';

  /// 闪避
  static const String dodge = '闪避';

  /// 格挡
  static const String block = '格挡';

  /// 战报
  static const String battleReport = '战报';

  /// 扫荡
  static const String sweep = '扫荡';

  // ============================================================
  // 武将相关
  // ============================================================

  /// 等级
  static const String level = '等级';

  /// 星级
  static const String starLevel = '星级';

  /// 攻击力
  static const String attack = '攻击力';

  /// 防御力
  static const String defense = '防御力';

  /// 兵力
  static const String troops = '兵力';

  /// 速度
  static const String speed = '速度';

  /// 智力
  static const String intelligence = '智力';

  /// 统率
  static const String leadership = '统率';

  /// 觉醒
  static const String awaken = '觉醒';

  /// 突破
  static const String breakthrough = '突破';

  /// 升星
  static const String starUp = '升星';

  /// 武将详情
  static const String generalDetail = '武将详情';

  /// 武将列表
  static const String generalList = '武将列表';

  /// 品质：传说
  static const String qualityLegendary = '传说';

  /// 品质：史诗
  static const String qualityEpic = '史诗';

  /// 品质：稀有
  static const String qualityRare = '稀有';

  /// 品质：普通
  static const String qualityCommon = '普通';

  // ============================================================
  // 势力名称
  // ============================================================

  /// 魏
  static const String factionWei = '魏';

  /// 蜀
  static const String factionShu = '蜀';

  /// 吴
  static const String factionWu = '吴';

  /// 群
  static const String factionQun = '群';

  // ============================================================
  // 资源相关
  // ============================================================

  /// 元宝
  static const String gold = '元宝';

  /// 铜钱
  static const String copper = '铜钱';

  /// 粮草
  static const String provisions = '粮草';

  /// 体力
  static const String stamina = '体力';

  /// 经验
  static const String experience = '经验';

  /// 兵书
  static const String tacticBook = '兵书';

  /// 体力不足
  static const String staminaNotEnough = '体力不足';

  /// 资源不足
  static const String resourceNotEnough = '资源不足';

  // ============================================================
  // 音频设置
  // ============================================================

  /// 音频设置
  static const String audioSettings = '音频设置';

  /// BGM 音量
  static const String bgmVolume = 'BGM 音量';

  /// 音效音量
  static const String sfxVolume = '音效音量';

  /// 语音音量
  static const String voiceVolume = '语音音量';

  /// 环境音音量
  static const String ambientVolume = '环境音音量';

  /// 静音
  static const String mute = '静音';

  // ============================================================
  // 登录相关
  // ============================================================

  /// 登录
  static const String login = '登录';

  /// 注册
  static const String register = '注册';

  /// 游客登录
  static const String guestLogin = '游客登录';

  /// 账号登录
  static const String accountLogin = '账号登录';

  /// 手机号
  static const String phoneNumber = '手机号';

  /// 密码
  static const String password = '密码';

  /// 验证码
  static const String verificationCode = '验证码';

  /// 获取验证码
  static const String getCode = '获取验证码';

  /// 用户协议
  static const String userAgreement = '用户协议';

  /// 隐私政策
  static const String privacyPolicy = '隐私政策';

  /// 同意协议
  static const String agreePolicy = '我已阅读并同意';
}

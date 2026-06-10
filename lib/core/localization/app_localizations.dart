import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// 支持的语言
enum AppLocale {
  /// 简体中文（默认）
  zh(name: 'zh', label: '简体中文'),

  /// 繁体中文
  zhHant(name: 'zh_Hant', label: '繁體中文'),

  /// 英文
  en(name: 'en', label: 'English'),

  /// 日文
  ja(name: 'ja', label: '日本語');

  const AppLocale({required this.name, required this.label});

  /// 语言代码
  final String name;

  /// 语言显示名称
  final String label;

  /// 转换为 Locale
  Locale toLocale() {
    switch (this) {
      case AppLocale.zh:
        return const Locale('zh', 'CN');
      case AppLocale.zhHant:
        return const Locale('zh', 'TW');
      case AppLocale.en:
        return const Locale('en', 'US');
      case AppLocale.ja:
        return const Locale('ja', 'JP');
    }
  }

  /// 从 Locale 转换
  static AppLocale fromLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'zh':
        if (locale.countryCode == 'TW' || locale.countryCode == 'HK') {
          return AppLocale.zhHant;
        }
        return AppLocale.zh;
      case 'en':
        return AppLocale.en;
      case 'ja':
        return AppLocale.ja;
      default:
        return AppLocale.zh;
    }
  }
}

/// 国际化文本封装
///
/// 当前仅支持简体中文，其他语言预留。
/// 所有字符串方法当前返回硬编码中文，后续替换为 ARB 生成代码。
///
/// 使用方式：
/// ```dart
/// final text = AppLocalizations.of(context).appName;
/// ```
///
/// TODO: 后续使用 intl 的 ARB 文件和代码生成工具自动生成多语言字符串
class AppLocalizations {
  /// 创建国际化文本实例
  AppLocalizations(this.locale);

  /// 当前语言
  final AppLocale locale;

  /// 从 BuildContext 获取
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(AppLocale.zh);
  }

  /// 应用名称
  String get appName => '三国谋定天下';

  // ---- 通用 ----

  /// 确定
  String get confirm => '确定';

  /// 取消
  String get cancel => '取消';

  /// 关闭
  String get close => '关闭';

  /// 返回
  String get back => '返回';

  /// 保存
  String get save => '保存';

  /// 删除
  String get delete => '删除';

  /// 编辑
  String get edit => '编辑';

  /// 加载中
  String get loading => '加载中...';

  /// 重试
  String get retry => '重试';

  /// 提示
  String get tip => '提示';

  /// 警告
  String get warning => '警告';

  /// 错误
  String get error => '错误';

  /// 成功
  String get success => '成功';

  /// 失败
  String get failure => '失败';

  /// 暂无数据
  String get noData => '暂无数据';

  /// 网络错误
  String get networkError => '网络连接失败，请检查网络设置';

  /// 服务器错误
  String get serverError => '服务器异常，请稍后重试';

  // ---- 主界面 ----

  /// 主城
  String get mainCity => '主城';

  /// 战斗
  String get battle => '战斗';

  /// 武将
  String get generals => '武将';

  /// 背包
  String get backpack => '背包';

  /// 商店
  String get shop => '商店';

  /// 任务
  String get quest => '任务';

  /// 阵容
  String get formation => '阵容';

  /// 联盟
  String get alliance => '联盟';

  /// 排行
  String get ranking => '排行榜';

  /// 设置
  String get settings => '设置';

  // ---- 战斗 ----

  /// 开战
  String get startBattle => '开战';

  /// 战斗胜利
  String get battleVictory => '战斗胜利';

  /// 战斗失败
  String get battleDefeat => '战斗失败';

  /// 回合
  String get round => '回合';

  /// 伤害
  String get damage => '伤害';

  /// 治疗
  String get heal => '治疗';

  /// 暴击
  String get criticalHit => '暴击';

  /// 技能释放
  String skillRelease(String skillName) => '$skillName 释放';

  // ---- 武将 ----

  /// 等级
  String get level => '等级';

  /// 星级
  String get starLevel => '星级';

  /// 攻击力
  String get attack => '攻击力';

  /// 防御力
  String get defense => '防御力';

  /// 兵力
  String get troops => '兵力';

  /// 速度
  String get speed => '速度';

  /// 智力
  String get intelligence => '智力';

  /// 统率
  String get leadership => '统率';

  /// 觉醒
  String get awaken => '觉醒';

  /// 突破
  String get breakthrough => '突破';

  /// 升星
  String get starUp => '升星';

  /// 武将详情
  String generalDetail(String name) => '$name 详情';

  // ---- 资源 ----

  /// 元宝
  String get gold => '元宝';

  /// 铜钱
  String get copper => '铜钱';

  /// 粮草
  String get provisions => '粮草';

  /// 体力
  String get stamina => '体力';

  /// 经验
  String get experience => '经验';

  /// 兵书
  String get tacticBook => '兵书';

  // ---- 音频设置 ----

  /// 音频设置
  String get audioSettings => '音频设置';

  /// BGM 音量
  String get bgmVolume => 'BGM 音量';

  /// 音效音量
  String get sfxVolume => '音效音量';

  /// 语音音量
  String get voiceVolume => '语音音量';

  /// 环境音音量
  String get ambientVolume => '环境音音量';

  /// 静音
  String get mute => '静音';

  /// 开启
  String get on => '开启';

  /// 关闭
  String get off => '关闭';

  /// 当前不支持此语言
  String get unsupportedLocale => '当前不支持此语言';

  /// 本地化代理列表，用于 MaterialApp.localizationsDelegates
  static const List<LocalizationsDelegate> localizationsDelegates = [
    AppLocalizationsDelegate.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// 支持的语言列表，用于 MaterialApp.supportedLocales
  static final List<Locale> supportedLocales =
      AppLocale.values.map((e) => e.toLocale()).toList();
}

/// AppLocalizations 的 LocalizationsDelegate
///
/// 用于在 MaterialApp 中配置国际化支持。
///
/// 使用方式：
/// ```dart
/// MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   locale: AppLocale.zh.toLocale(),
/// )
/// ```
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate._();

  /// 单例实例
  static const AppLocalizationsDelegate delegate = AppLocalizationsDelegate._();

  @override
  bool isSupported(Locale locale) {
    return AppLocale.values
        .map((e) => e.toLocale().languageCode)
        .contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final appLocale = AppLocale.fromLocale(locale);
    // TODO: 后续替换为 ARB 生成的翻译加载逻辑
    return AppLocalizations(appLocale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}

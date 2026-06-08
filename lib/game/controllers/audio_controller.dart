import 'package:flame/components.dart';

/// 战斗音频控制器
///
/// 管理战斗场景的所有音频播放，包括背景音乐、技能音效、环境音效等。
/// 通过 flame_audio 包实现音频播放和切换。
class AudioController extends Component with HasGameReference {
  /// 当前背景音乐标识
  String? currentBgm;

  /// 音效音量 (0.0 - 1.0)
  double sfxVolume = 1.0;

  /// 背景音乐音量 (0.0 - 1.0)
  double bgmVolume = 0.5;

  /// 是否静音
  bool isMuted = false;

  @override
  void update(double dt) {
    super.update(dt);
    // TODO: 更新音频系统状态
  }

  /// 播放背景音乐
  void playBgm(String bgmKey, {bool loop = true}) {
    // TODO: 播放指定背景音乐
    throw UnimplementedError();
  }

  /// 停止背景音乐
  void stopBgm() {
    // TODO: 停止当前背景音乐
    throw UnimplementedError();
  }

  /// 播放技能音效
  void playSkillSfx(String skillId) {
    // TODO: 播放技能对应的音效
    throw UnimplementedError();
  }

  /// 播放攻击音效
  void playAttackSfx(String troopType) {
    // TODO: 播放对应兵种的攻击音效
    throw UnimplementedError();
  }

  /// 播放受击音效
  void playHurtSfx() {
    // TODO: 播放受击音效
    throw UnimplementedError();
  }

  /// 播放计谋音效
  void playTacticSfx(String tacticType) {
    // TODO: 播放对应计谋的音效
    throw UnimplementedError();
  }

  /// 设置音效音量
  void setSfxVolume(double volume) {
    // TODO: 设置音效音量
    throw UnimplementedError();
  }

  /// 设置背景音乐音量
  void setBgmVolume(double volume) {
    // TODO: 设置背景音乐音量
    throw UnimplementedError();
  }

  /// 切换静音
  void toggleMute() {
    // TODO: 切换静音状态
    throw UnimplementedError();
  }
}

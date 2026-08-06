import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/app_widgets.dart';
import '../../services/background_music_service.dart';

/// 背景音乐播放设置页面
class BackgroundMusicPage extends StatefulWidget {
  const BackgroundMusicPage({super.key});

  @override
  State<BackgroundMusicPage> createState() => _BackgroundMusicPageState();
}

class _BackgroundMusicPageState extends State<BackgroundMusicPage> {
  final BackgroundMusicService _musicService = BackgroundMusicService();

  @override
  void initState() {
    super.initState();
    _musicService.addListener(_onMusicChanged);
  }

  void _onMusicChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _musicService.removeListener(_onMusicChanged);
    super.dispose();
  }

  /// 将曲目英文名转为可读标题
  String _trackTitle(String raw) {
    return raw.replaceAll('_', ' ');
  }

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: '背景音乐',
      subtitle: '选择喜欢的曲目，随时伴你左右',
      action: Icons.close_rounded,
      onAction: () => Navigator.pop(context),
      children: [
        // ── 播放控制卡片 ──
        SoftCard(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
          child: Column(
            children: [
              Row(
                children: [
                  // 唱片图标
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.lavender.withValues(alpha: 0.22),
                          AppColors.deepLavender.withValues(alpha: 0.10),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      _musicService.isPlaying
                          ? Icons.graphic_eq_rounded
                          : Icons.music_note_rounded,
                      color: AppColors.lavender,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 曲目名称 + 状态
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _trackTitle(_musicService.currentTrack),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _musicService.isPlaying
                                    ? const Color(0xFF6FCF97)
                                    : Colors.grey.shade300,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              _musicService.isPlaying ? '正在播放' : '已暂停',
                              style: TextStyle(
                                fontSize: 10,
                                color: _musicService.isPlaying
                                    ? const Color(0xFF6FCF97)
                                    : Colors.grey.shade400,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // 播放/暂停按钮
                  GestureDetector(
                    onTap: () => _musicService.togglePlayPause(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.lavender.withValues(alpha: 0.10),
                      ),
                      child: Icon(
                        _musicService.isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: AppColors.lavender,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
              // 音量滑块
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F5FC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.volume_down_rounded,
                      size: 16,
                      color: AppColors.lavender.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 2.5,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 12,
                          ),
                          activeTrackColor: AppColors.lavender,
                          inactiveTrackColor:
                              AppColors.lavender.withValues(alpha: 0.12),
                          thumbColor: AppColors.lavender,
                          overlayColor: AppColors.lavender.withValues(alpha: 0.15),
                        ),
                        child: Slider(
                          value: _musicService.volume,
                          onChanged: (value) => _musicService.setVolume(value),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.volume_up_rounded,
                      size: 16,
                      color: AppColors.lavender.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── 曲目列表 ──
        const SectionTitle(title: '选择曲目'),
        SoftCard(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
          child: Column(
            children: List.generate(_musicService.tracks.length, (index) {
              final isSelected = index == _musicService.currentIndex;
              final trackName = _trackTitle(_musicService.tracks[index]);
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _musicService.selectTrack(index),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                  child: Row(
                    children: [
                      // 序号圆圈
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppColors.lavender
                              : const Color(0xFFF5F0F7),
                        ),
                        child: Center(
                          child: isSelected
                              ? const Icon(Icons.play_arrow_rounded,
                                  color: Colors.white, size: 16)
                              : Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // 曲名
                      Expanded(
                        child: Text(
                          trackName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? AppColors.deepLavender : AppColors.ink,
                          ),
                        ),
                      ),
                      // 选中标签
                      if (isSelected)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.lavender.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '播放中',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: AppColors.deepLavender,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),

        const SizedBox(height: 4),
        Center(
          child: Text(
            '曲目将在播放完毕后自动切换',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade400,
            ),
          ),
        ),

        // ── 版权声明 ──
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.lavender.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.copyright_rounded,
                size: 14,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 6),
              Text(
                '本应用内所有背景音乐均由 AI 算法生成，可伴团队拥有完整版权。'
                '如有任何疑问或合作需求，请通过应用内「反馈与建议」联系我们。',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  height: 1.6,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../theme/theme.dart';

class BackgroundMusicPage extends StatefulWidget {
  const BackgroundMusicPage({super.key});

  @override
  State<BackgroundMusicPage> createState() => _BackgroundMusicPageState();
}

class _BackgroundMusicPageState extends State<BackgroundMusicPage> with WidgetsBindingObserver {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentPlayingIndex = -1;
  bool _isPlaying = false;
  int _playMode = 0;

  final List<String> _playModeLabels = ['顺序播放', '列表循环', '单曲循环'];
  final List<IconData> _playModeIcons = [Icons.skip_next, Icons.repeat, Icons.repeat_one];

  final List<Map<String, String>> _musicTracks = [
    {'name': 'Distinct Piece', 'file': 'A-Distinct-Piece.mp3'},
    {'name': 'Beat And Paradise', 'file': 'Beat-And-Paradise.mp3'},
    {'name': 'Cedar Tone', 'file': 'Cedar-Tone.mp3'},
    {'name': 'Chill Vibes', 'file': 'Chill-Vibes.mp3'},
    {'name': 'Key Bits', 'file': 'Key-Bits.mp3'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    _audioPlayer.onPlayerComplete.listen((_) {
      if (!mounted) return;
      if (_playMode == 1 && _musicTracks.length > 1) {
        final nextIndex = (_currentPlayingIndex + 1) % _musicTracks.length;
        _playMusic(nextIndex);
      } else if (_playMode == 0) {
        setState(() {
          _isPlaying = false;
          _currentPlayingIndex = -1;
        });
      }
    });
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  Future<void> _playMusic(int index) async {
    if (_currentPlayingIndex == index && _isPlaying) {
      await _audioPlayer.pause();
      return;
    }

    if (_currentPlayingIndex == index) {
      await _audioPlayer.resume();
      return;
    }

    await _audioPlayer.stop();
    await _audioPlayer.setSource(AssetSource('backgroundMusic/${_musicTracks[index]['file']!}'));
    await _audioPlayer.resume();
    setState(() {
      _currentPlayingIndex = index;
    });
  }

  Future<void> _stopMusic() async {
    await _audioPlayer.stop();
    setState(() {
      _currentPlayingIndex = -1;
      _isPlaying = false;
    });
  }

  void _togglePlayMode() {
    setState(() {
      _playMode = (_playMode + 1) % _playModeLabels.length;
      if (_playMode == 2) {
        _audioPlayer.setReleaseMode(ReleaseMode.loop);
      } else {
        _audioPlayer.setReleaseMode(ReleaseMode.stop);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Color(0xFF1A3A34),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '背景音乐',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A3A34),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNowPlayingCard(),
            const SizedBox(height: 24),
            _buildPlayModeButton(),
            const SizedBox(height: 16),
            const Text(
              '选择背景音乐',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF3E8FF), Color(0xFFE8F4FD)],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(color: const Color(0xFFC4B5E0)),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < _musicTracks.length; i++) ...[
                    _buildMusicTile(i),
                    if (i < _musicTracks.length - 1) _buildDivider(),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildDisclaimerCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildNowPlayingCard() {
    final isPlaying = _currentPlayingIndex != -1;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isPlaying
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.gradientPurpleStart,
                  AppColors.gradientPurpleEnd,
                ],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF3E8FF), Color(0xFFE8F4FD)],
              ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isPlaying
                ? AppColors.gradientPurpleStart.withOpacity(0.3)
                : AppColors.cardShadow,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isPlaying ? Colors.white.withOpacity(0.2) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  isPlaying ? Icons.music_note_rounded : Icons.music_off_rounded,
                  color: isPlaying ? Colors.white : const Color(0xFF6B5B95),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPlaying ? '正在播放' : '未播放',
                      style: TextStyle(
                        fontSize: 14,
                        color: isPlaying ? Colors.white.withOpacity(0.9) : const Color(0xFF6B5B95),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isPlaying ? _musicTracks[_currentPlayingIndex]['name']! : '选择一首音乐开始播放',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isPlaying ? Colors.white : const Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
              ),
              if (isPlaying)
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: () {
                    if (_isPlaying) {
                      _audioPlayer.pause();
                    } else {
                      _audioPlayer.resume();
                    }
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayModeButton() {
    return Center(
      child: OutlinedButton.icon(
        onPressed: _togglePlayMode,
        icon: Icon(_playModeIcons[_playMode]),
        label: Text(_playModeLabels[_playMode]),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF6B5B95),
          side: const BorderSide(color: Color(0xFFC4B5E0)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildMusicTile(int index) {
    final track = _musicTracks[index];
    final isCurrentTrack = _currentPlayingIndex == index;
    final isCurrentTrackPlaying = isCurrentTrack && _isPlaying;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: isCurrentTrackPlaying
              ? const LinearGradient(
                  colors: [
                    AppColors.gradientPurpleStart,
                    AppColors.gradientPurpleEnd,
                  ],
                )
              : const LinearGradient(
                  colors: [
                    Color(0xFFE0E0E0),
                    Color(0xFFBDBDBD),
                  ],
                ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isCurrentTrackPlaying
              ? [
                  BoxShadow(
                    color: AppColors.gradientPurpleStart.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Icon(
          isCurrentTrackPlaying ? Icons.music_note_rounded : Icons.play_arrow_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),
      title: Text(
        track['name']!,
        style: TextStyle(
          fontSize: 15,
          fontWeight: isCurrentTrack ? FontWeight.bold : FontWeight.w600,
          color: isCurrentTrack ? const Color(0xFF6B5B95) : const Color(0xFF1A1A2E),
        ),
      ),
      subtitle: isCurrentTrackPlaying
          ? const Text(
              '正在播放',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF6B5B95),
              ),
            )
          : null,
      trailing: isCurrentTrackPlaying
          ? Icon(
              Icons.pause_rounded,
              color: const Color(0xFF6B5B95),
              size: 24,
            )
          : Icon(
              Icons.play_arrow_rounded,
              color: isCurrentTrack ? const Color(0xFF6B5B95) : const Color(0xFF9E9E9E),
              size: 24,
            ),
      onTap: () => _playMusic(index),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(height: 1, color: const Color(0xFFC4B5E0)),
    );
  }

  Widget _buildDisclaimerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: const Color(0xFF9E9E9E),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '免责声明：本页面提供的所有背景音乐均由AI算法自动生成，仅供个人使用。',
              style: TextStyle(
                fontSize: 13,
                color: const Color(0xFF757575),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

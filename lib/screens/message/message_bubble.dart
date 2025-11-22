import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:zhenyu_flutter/models/chat_api_model.dart';
import 'package:zhenyu_flutter/theme.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.message,
    required this.currentUserAvatar,
    required this.peerAvatar,
    required this.onImageTap,
    required this.onLocationTap,
    this.onPeerIdTap,
  });

  final ChatMessage message;
  final String? currentUserAvatar;
  final String? peerAvatar;
  final void Function(String url) onImageTap;
  final void Function(ChatMessage message) onLocationTap;
  final VoidCallback? onPeerIdTap;

  @override
  Widget build(BuildContext context) {
    if (message.type == MessageContentType.system) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite10,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              message.text ?? '',
              style: TextStyle(fontSize: 22.sp, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final isMine = message.isMine;
    final avatarUrl = isMine
        ? currentUserAvatar
        : (message.avatarUrl ?? peerAvatar);

    final bubble = _buildBubbleContent(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isMine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMine)
            GestureDetector(
              onTap: onPeerIdTap,
              child: _AvatarView(avatarUrl: avatarUrl),
            ),
          if (!isMine) SizedBox(width: 12.w),
          Flexible(child: bubble),
          if (isMine) SizedBox(width: 12.w),
          if (isMine) _AvatarView(avatarUrl: avatarUrl),
        ],
      ),
    );
  }

  Widget _buildBubbleContent(BuildContext context) {
    final isMine = message.isMine;
    final background = isMine ? null : AppColors.backgroundWhite10;
    final gradient = isMine ? AppGradients.secondaryGradient : null;
    final textColor = isMine ? AppColors.btnText : AppColors.textPrimary;

    Widget child;
    switch (message.type) {
      case MessageContentType.text:
        child = Text(
          message.text ?? '',
          style: TextStyle(fontSize: 28.sp, color: textColor),
        );
        break;
      case MessageContentType.image:
        child = GestureDetector(
          onTap: () {
            if (message.imageUrl != null) {
              onImageTap(message.imageUrl!);
            }
          },
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 500.w, // Corresponds to max-width: 500rpx
              maxHeight: 400.h, // Corresponds to max-height: 400rpx
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                10.r,
              ), // Corresponds to border-radius: 10rpx
              child: Image.network(
                message.imageUrl ?? '',
                width: 300.w, // Corresponds to width: 300rpx
                fit: BoxFit
                    .fitWidth, // Ensures width is fixed and height is auto
                // Optional: Add loading and error builders for better UX
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, color: Colors.white54),
              ),
            ),
          ),
        );
        break;
      case MessageContentType.location:
        child = GestureDetector(
          onTap: () => onLocationTap(message),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.locationArea ?? '',
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                message.locationAddress ?? '',
                style: TextStyle(
                  fontSize: 22.sp,
                  color: textColor.withValues(alpha: 0.8),
                ),
              ),
              if ((message.mapUrl ?? '').isNotEmpty) ...[
                SizedBox(height: 12.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(message.mapUrl!, fit: BoxFit.cover),
                  ),
                ),
              ],
            ],
          ),
        );
        break;
      case MessageContentType.audio:
        child = _AudioMessageBubble(message: message, textColor: textColor);
        break;
      case MessageContentType.custom:
        child = Text(
          message.text ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 26.sp, color: textColor),
        );
        break;
      case MessageContentType.system:
        child = const SizedBox.shrink();
    }

    // For image messages, we don't want the default bubble padding and decoration,
    // as the new style handles it internally.
    if (message.type == MessageContentType.image) {
      return child;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: background,
        gradient: gradient,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
          bottomLeft: Radius.circular(message.isMine ? 20.r : 6.r),
          bottomRight: Radius.circular(message.isMine ? 6.r : 20.r),
        ),
      ),
      constraints: BoxConstraints(
        maxWidth: 500.w, // Apply max-width for text bubbles as well
      ),
      child: child,
    );
  }
}

class _AudioMessageBubble extends StatefulWidget {
  const _AudioMessageBubble({required this.message, required this.textColor});

  final ChatMessage message;
  final Color textColor;

  @override
  State<_AudioMessageBubble> createState() => _AudioMessageBubbleState();
}

class _AudioMessageBubbleState extends State<_AudioMessageBubble> {
  _AudioMessageBubbleState()
    : _player = AudioPlayer(),
      _playerState = PlayerState(false, ProcessingState.idle);

  static AudioPlayer? _activePlayer;

  final AudioPlayer _player;
  PlayerState _playerState;
  Duration _position = Duration.zero;
  Duration? _duration;
  bool _isLoading = false;

  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<PlayerState>? _playerStateSub;

  @override
  void initState() {
    super.initState();
    _player.setLoopMode(LoopMode.off);
    _positionSub = _player.positionStream.listen((position) {
      if (!mounted) return;
      setState(() => _position = position);
    });
    _durationSub = _player.durationStream.listen((duration) {
      if (!mounted) return;
      setState(() => _duration = duration);
    });
    _playerStateSub = _player.playerStateStream.listen((state) {
      if (!mounted) return;
      setState(() => _playerState = state);
      if (state.processingState == ProcessingState.completed) {
        if (identical(_activePlayer, _player)) {
          _activePlayer = null;
        }
        // Calling stop() ensures the player state is fully reset.
        _player.stop();
      }
    });
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _playerStateSub?.cancel();
    if (identical(_activePlayer, _player)) {
      _activePlayer = null;
    }
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlayback() async {
    if (_isLoading) return;

    final currentState = _playerState;
    if (currentState.playing) {
      await _player.pause();
      if (identical(_activePlayer, _player)) {
        _activePlayer = null;
      }
      return;
    }

    if (_activePlayer != null && !identical(_activePlayer, _player)) {
      await _activePlayer!.stop();
      _activePlayer = null;
    }

    if (currentState.processingState == ProcessingState.completed) {
      await _player.seek(Duration.zero);
    }

    if (currentState.processingState == ProcessingState.idle) {
      final prepared = await _prepareSource();
      if (!prepared) {
        return;
      }
    }

    try {
      await _player.play();
      _activePlayer = _player;
    } catch (_) {
      _showError('语音播放失败');
    }
  }

  Future<bool> _prepareSource() async {
    setState(() => _isLoading = true);
    try {
      final elem = widget.message.raw.soundElem;
      if (elem == null) {
        _showError('语音文件缺失');
        return false;
      }

      final localPath = elem.localUrl;
      final remoteUrl = elem.url;
      if (localPath != null && localPath.isNotEmpty) {
        try {
          final duration = await _player.setFilePath(localPath);
          _duration ??= duration ?? widget.message.audioDuration;
          return true;
        } catch (_) {
          // fall back to remote url
        }
      }

      if (remoteUrl != null && remoteUrl.isNotEmpty) {
        final duration = await _player.setUrl(remoteUrl);
        _duration ??= duration ?? widget.message.audioDuration;
        return true;
      }

      _showError('无法获取语音文件');
      return false;
    } catch (_) {
      _showError('加载语音失败');
      return false;
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String text) {
    if (!mounted) return;
    ScaffoldMessenger.maybeOf(
      context,
    )?.showSnackBar(SnackBar(content: Text(text)));
  }

  String _buildDurationLabel() {
    final total = _duration ?? widget.message.audioDuration;
    if (total != null && total > Duration.zero) {
      return '${total.inSeconds}"';
    }
    return '--"';
  }

  Widget _buildIcon() {
    if (_isLoading) {
      return SizedBox(
        width: 30.w,
        height: 30.w,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: widget.textColor,
        ),
      );
    }

    Widget iconWidget;
    if (_playerState.playing) {
      iconWidget = Image.asset(
        'assets/images/im/playVoiceing.gif',
        width: 30.w,
        height: 30.w,
      );
      if (widget.message.isMine) {
        return Transform.rotate(
          angle: 3.1415926535, // pi
          child: iconWidget,
        );
      }
    } else {
      iconWidget = Image.asset(
        'assets/images/im/voiceSta.png',
        width: 30.w,
        height: 30.w,
        color: widget.textColor,
      );
      if (!widget.message.isMine) {
        return Transform.rotate(
          angle: 3.1415926535, // pi
          child: iconWidget,
        );
      }
    }

    return iconWidget;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _togglePlayback,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _buildDurationLabel(),
            style: TextStyle(fontSize: 24.sp, color: widget.textColor),
          ),
          SizedBox(width: 8.w),
          _buildIcon(),
        ],
      ),
    );
  }
}

class _AvatarView extends StatelessWidget {
  const _AvatarView({this.avatarUrl});

  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    ImageProvider? provider;
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      if (avatarUrl!.startsWith('http')) {
        provider = NetworkImage(avatarUrl!);
      } else if (avatarUrl!.startsWith('assets/')) {
        provider = AssetImage(avatarUrl!);
      }
    }
    return CircleAvatar(
      radius: 26.r,
      backgroundColor: AppColors.backgroundWhite10,
      backgroundImage: provider,
      child: provider == null
          ? const Icon(Icons.person, color: AppColors.textSecondary)
          : null,
    );
  }
}

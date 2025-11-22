import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../Moodmodels/journal.dart';
import '../Moodmodels/emotion_tag.dart';
import '../Moodservices/storage_service.dart';

class JournalDetailScreen extends StatefulWidget {
  final String journalId;
  final StorageService storageService;
  const JournalDetailScreen({
    super.key,
    required this.journalId,
    required this.storageService,
  });

  @override
  State<JournalDetailScreen> createState() => _JournalDetailScreenState();
}

class _JournalDetailScreenState extends State<JournalDetailScreen> {
  Journal? _journal;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJournal();
  }

  Future<void> _loadJournal() async {
    final journals = await widget.storageService.getJournals();
    final journal = journals.firstWhere(
      (j) => j.id == widget.journalId,
      orElse: () => throw Exception('Journal not found'),
    );

    setState(() {
      _journal = journal;
      _isLoading = false;
    });
  }

  Color _getEmotionColor(String emotionName) {
    final tag = EmotionTag.getTagByName(emotionName);
    if (tag != null) {
      return Color(int.parse('0xFF${tag.color.substring(1)}'));
    }
    return Colors.grey;
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy年MM月dd日 HH:mm').format(date);
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('举报内容', style: TextStyle(color: Colors.white)),
        content: const Text(
          '我们已经收到您的反馈,会在24小时内核实和处理。',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定', style: TextStyle(color: Color(0xFF8A7CF5))),
          ),
        ],
      ),
    );
  }

  void _showBlockDialog() {
    if (_journal == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('拉黑用户', style: TextStyle(color: Colors.white)),
        content: const Text(
          '确定要拉黑该用户吗?拉黑后将不再看到该用户的内容。',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // 拉黑用户
              await widget.storageService.blockUser(_journal!.userId);
              if (mounted) {
                // 返回上一页
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('已拉黑该用户'),
                    backgroundColor: Color(0xFF8A7CF5),
                  ),
                );
              }
            },
            child: const Text('确定', style: TextStyle(color: Color(0xFFFF6B6B))),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(
                  Icons.report_outlined,
                  color: Color(0xFFFF9800),
                ),
                title: const Text('举报', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _showReportDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: Color(0xFFFF6B6B)),
                title: const Text(
                  '拉黑用户',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showBlockDialog();
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void _showCommentReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('举报评论', style: TextStyle(color: Colors.white)),
        content: const Text(
          '我们已经收到您的反馈,会在24小时内核实和处理。',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定', style: TextStyle(color: Color(0xFF8A7CF5))),
          ),
        ],
      ),
    );
  }

  void _showCommentBlockDialog(String commentUserId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('拉黑用户', style: TextStyle(color: Colors.white)),
        content: const Text(
          '确定要拉黑该用户吗?拉黑后将不再看到该用户的内容。',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // 拉黑评论用户
              await widget.storageService.blockUser(commentUserId);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('已拉黑该用户'),
                    backgroundColor: Color(0xFF8A7CF5),
                  ),
                );
                // 刷新页面以隐藏被拉黑用户的评论
                setState(() {});
              }
            },
            child: const Text('确定', style: TextStyle(color: Color(0xFFFF6B6B))),
          ),
        ],
      ),
    );
  }

  void _showCommentMoreOptions(String commentUserId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(
                  Icons.report_outlined,
                  color: Color(0xFFFF9800),
                ),
                title: const Text(
                  '举报评论',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showCommentReportDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: Color(0xFFFF6B6B)),
                title: const Text(
                  '拉黑用户',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showCommentBlockDialog(commentUserId);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentItem({
    required String username,
    required String comment,
    required String time,
    String userId = 'comment_user_001', // 评论用户ID
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF8A7CF5), Color(0xFF6B5BFF)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '匿',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(color: Colors.grey[500], fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white70,
                  size: 20,
                ),
                onPressed: () => _showCommentMoreOptions(userId),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 42),
            child: Text(
              comment,
              style: const TextStyle(
                color: Color(0xFFD0D0D0),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF000000),
        body: Center(
          child: CircularProgressIndicator(color: const Color(0xFF8A7CF5)),
        ),
      );
    }

    if (_journal == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF000000),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey[700]),
              const SizedBox(height: 16),
              Text(
                '日记未找到',
                style: TextStyle(fontSize: 18, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.45,
              pinned: true,
              elevation: 0,
              backgroundColor: const Color(0xFF1A1A1A),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: _journal!.imageUrl != null
                      ? (_journal!.imageUrl!.startsWith('http')
                            ? Image.network(
                                _journal!.imageUrl!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF8A7CF5),
                                          Color(0xFF6B5BFF),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : _journal!.imageUrl!.startsWith('assets/')
                            ? Image.asset(
                                _journal!.imageUrl!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF8A7CF5),
                                          Color(0xFF6B5BFF),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Image.file(
                                File(_journal!.imageUrl!),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF8A7CF5),
                                          Color(0xFF6B5BFF),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ))
                      : Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF8A7CF5), Color(0xFF6B5BFF)],
                            ),
                          ),
                        ),
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.white),
                  onPressed: () => _showMoreOptions(),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Container(
                color: const Color(0xFF000000),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDate(_journal!.createdAt),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (_journal!.isPrivate)
                            Icon(
                              Icons.lock_outline,
                              size: 16,
                              color: Colors.grey[400],
                            )
                          else
                            Icon(
                              Icons.public,
                              size: 16,
                              color: const Color(0xFF8A7CF5),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 4,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: LinearGradient(
                            colors: [
                              _getEmotionColor(
                                _journal!.emotionTags.isNotEmpty
                                    ? _journal!.emotionTags[0]
                                    : 'peaceful',
                              ),
                              _getEmotionColor(
                                _journal!.emotionTags.isNotEmpty
                                    ? _journal!.emotionTags[0]
                                    : 'peaceful',
                              ).withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _journal!.content,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFFD0D0D0),
                          height: 1.8,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_journal!.emotionTags.isNotEmpty) ...[
                        const Text(
                          '情绪标签',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _journal!.emotionTags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: _getEmotionColor(
                                  tag,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _getEmotionColor(
                                    tag,
                                  ).withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                '#${EmotionTag.getTagByName(tag)?.displayName ?? tag}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: _getEmotionColor(tag),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                      const SizedBox(height: 30),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.grey[900],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '评论 (0)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE0E0E0),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 示例评论（演示举报和拉黑功能）
                      _buildCommentItem(
                        username: '匿名用户',
                        comment: '这篇日记写得真好，很有共鸣！',
                        time: '2小时前',
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              style: const TextStyle(color: Color(0xFFE0E0E0)),
                              decoration: InputDecoration(
                                hintText: '写下你的评论...',
                                hintStyle: TextStyle(color: Colors.grey[600]),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: const Color(0xFF1A1A1A),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF8A7CF5), Color(0xFF6B5BFF)],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

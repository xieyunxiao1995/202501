import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../Moodmodels/journal.dart';
import '../Moodmodels/emotion_tag.dart';
import '../Moodservices/storage_service.dart';
import 'journal_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final StorageService storageService;
  const HomeScreen({super.key, required this.storageService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Journal> _journals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJournals();
  }

  Future<void> _loadJournals() async {
    final journals = await widget.storageService.getJournals();
    setState(() {
      _journals = journals;
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
    final now = DateTime.now();
    final diff = now.difference(date).inDays;

    if (diff == 0) {
      return '今天 ${DateFormat('HH:mm').format(date)}';
    } else if (diff == 1) {
      return '昨天 ${DateFormat('HH:mm').format(date)}';
    } else {
      return DateFormat('MM月dd日').format(date);
    }
  }

  Future<void> _refreshJournals() async {
    await _loadJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 80,
            floating: true,
            pinned: false,
            elevation: 0,
            backgroundColor: const Color(0xFF000000),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: const Color(0xFF000000),
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF8A7CF5), Color(0xFF6B5BFF)],
                        ).createShader(bounds),
                        child: const Text(
                          '心境日记',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(
                        color: Color(0xFF8A7CF5),
                      ),
                    ),
                  )
                : _journals.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: _refreshJournals,
                    color: const Color(0xFF8A7CF5),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _journals.length,
                        itemBuilder: (context, index) {
                          final journal = _journals[index];
                          return _buildJournalCard(journal);
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book_outlined, size: 80, color: Colors.grey[800]),
          const SizedBox(height: 16),
          Text(
            '还没有日记',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '开始记录你的第一篇心情',
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalCard(Journal journal) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                JournalDetailScreen(
                  journalId: journal.id,
                  storageService: widget.storageService,
                ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0.0, 0.1),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOut,
                            ),
                          ),
                      child: child,
                    ),
                  );
                },
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Hero(
          tag: 'journal-${journal.id}',
          child: Material(
            borderRadius: BorderRadius.circular(24),
            elevation: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 6,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          _getEmotionColor(
                            journal.emotionTags.isNotEmpty
                                ? journal.emotionTags[0]
                                : 'peaceful',
                          ),
                          _getEmotionColor(
                            journal.emotionTags.isNotEmpty
                                ? journal.emotionTags[0]
                                : 'peaceful',
                          ).withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDate(journal.createdAt),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (journal.isPrivate)
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
                        if (journal.imageUrl != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: journal.imageUrl!.startsWith('http')
                                ? Image.network(
                                    journal.imageUrl!,
                                    height: 288,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 288,
                                        width: double.infinity,
                                        color: Colors.grey[800],
                                        child: const Icon(
                                          Icons.broken_image,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  )
                                : journal.imageUrl!.startsWith('assets/')
                                ? Image.asset(
                                    journal.imageUrl!,
                                    height: 288,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 288,
                                        width: double.infinity,
                                        color: Colors.grey[800],
                                        child: const Icon(
                                          Icons.broken_image,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  )
                                : Image.file(
                                    File(journal.imageUrl!),
                                    height: 288,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 288,
                                        width: double.infinity,
                                        color: Colors.grey[800],
                                        child: const Icon(
                                          Icons.broken_image,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        if (journal.imageUrl != null)
                          const SizedBox(height: 16),
                        Text(
                          journal.content,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFFD0D0D0),
                            height: 1.6,
                            letterSpacing: 0.2,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        if (journal.emotionTags.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: journal.emotionTags.map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF252525),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '#${EmotionTag.getTagByName(tag)?.displayName ?? tag}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFA0A0A0),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

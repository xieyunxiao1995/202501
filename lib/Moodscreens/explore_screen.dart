import 'package:flutter/material.dart';
import 'dart:io';
import '../Moodmodels/journal.dart';
import '../Moodmodels/emotion_tag.dart';
import '../Moodservices/storage_service.dart';
import 'journal_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  final StorageService storageService;
  const ExploreScreen({super.key, required this.storageService});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _selectedFilter = 'All';
  List<Journal> _publicJournals = [];
  List<Journal> _filteredJournals = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadPublicJournals();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _applyFilters();
    });
  }

  Future<void> _loadPublicJournals() async {
    final journals = await widget.storageService.getJournals();
    final blockedUserIds = await widget.storageService.getBlockedUserIds();

    // 过滤掉被拉黑用户的日记
    final publicJournals =
        journals
            .where((j) => !j.isPrivate && !blockedUserIds.contains(j.userId))
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    setState(() {
      _publicJournals = publicJournals;
      _filteredJournals = publicJournals;
      _isLoading = false;
    });
  }

  void _filterJournals(String filter) {
    setState(() {
      _selectedFilter = filter;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Journal> filtered = List.from(_publicJournals);

    // 应用情绪标签过滤
    if (_selectedFilter != 'All') {
      filtered = filtered
          .where(
            (journal) => journal.emotionTags.any(
              (tag) => tag == _selectedFilter.toLowerCase(),
            ),
          )
          .toList();
    }

    // 应用搜索过滤
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((journal) {
        // 搜索内容
        final contentMatch = journal.content.toLowerCase().contains(query);
        // 搜索情绪标签
        final tagMatch = journal.emotionTags.any((tag) {
          final displayName = EmotionTag.getTagByName(tag)?.displayName ?? tag;
          return displayName.toLowerCase().contains(query) ||
              tag.toLowerCase().contains(query);
        });
        return contentMatch || tagMatch;
      }).toList();
    }

    _filteredJournals = filtered;
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 搜索头部
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF252525),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: '搜索内容或情绪标签...',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF8A7CF5),
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: const Color(0xFF1A1A1A),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        '取消',
                        style: TextStyle(color: Color(0xFF8A7CF5)),
                      ),
                    ),
                  ],
                ),
              ),
              // 搜索结果
              Flexible(
                child: _searchQuery.isEmpty
                    ? _buildSearchSuggestions()
                    : _buildSearchResults(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    return ListView(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      children: [
        const Text(
          '热门标签',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: emotionFilters.skip(1).map((filter) {
            final tag = EmotionTag.getTagByName(filter);
            return GestureDetector(
              onTap: () {
                _searchController.text = tag?.displayName ?? filter;
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF252525),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _getEmotionColor(filter).withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '#${tag?.displayName ?? filter}',
                  style: TextStyle(
                    color: _getEmotionColor(filter),
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_filteredJournals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[600]),
            const SizedBox(height: 16),
            Text(
              '没有找到相关内容',
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredJournals.length,
      itemBuilder: (context, index) {
        final journal = _filteredJournals[index];
        return _buildSearchResultItem(journal);
      },
    );
  }

  Widget _buildSearchResultItem(Journal journal) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JournalDetailScreen(
              journalId: journal.id,
              storageService: widget.storageService,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF252525),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (journal.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: journal.imageUrl!.startsWith('http')
                    ? Image.network(
                        journal.imageUrl!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[800],
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                              size: 24,
                            ),
                          );
                        },
                      )
                    : journal.imageUrl!.startsWith('assets/')
                    ? Image.asset(
                        journal.imageUrl!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[800],
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                              size: 24,
                            ),
                          );
                        },
                      )
                    : Image.file(
                        File(journal.imageUrl!),
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[800],
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                              size: 24,
                            ),
                          );
                        },
                      ),
              ),
            if (journal.imageUrl != null) const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    journal.content,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  if (journal.emotionTags.isNotEmpty)
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: journal.emotionTags.take(3).map((tag) {
                        final emotionColor = _getEmotionColor(tag);
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: emotionColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: emotionColor.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            '#${EmotionTag.getTagByName(tag)?.displayName ?? tag}',
                            style: TextStyle(
                              fontSize: 10,
                              color: emotionColor,
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
    );
  }

  Color _getEmotionColor(String emotionName) {
    final tag = EmotionTag.getTagByName(emotionName);
    if (tag != null) {
      return Color(int.parse('0xFF${tag.color.substring(1)}'));
    }
    return Colors.grey;
  }

  List<String> get emotionFilters {
    return [
      'All',
      'peaceful',
      'joy',
      'anxiety',
      'hope',
      'love',
      'energy',
      'tired',
      'grateful',
    ];
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
                          '情绪广场',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.white70),
                        onPressed: _showSearchDialog,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF000000),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SizedBox(
                height: 44,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: emotionFilters.length,
                  itemBuilder: (context, index) {
                    final filter = emotionFilters[index];
                    return GestureDetector(
                      onTap: () => _filterJournals(filter),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: _selectedFilter == filter
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF8A7CF5),
                                    Color(0xFF6B5BFF),
                                  ],
                                )
                              : null,
                          color: _selectedFilter == filter
                              ? null
                              : const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _selectedFilter == filter
                                ? const Color(0xFF8A7CF5)
                                : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: _selectedFilter == filter
                              ? [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF8A7CF5,
                                    ).withValues(alpha: 0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            filter == 'All'
                                ? '全部'
                                : EmotionTag.getTagByName(
                                        filter,
                                      )?.displayName ??
                                      filter,
                            style: TextStyle(
                              color: _selectedFilter == filter
                                  ? Colors.white
                                  : Colors.grey[400],
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          _isLoading
              ? const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF8A7CF5)),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final journal = _filteredJournals[index];
                      return _buildJournalCard(journal);
                    }, childCount: _filteredJournals.length),
                  ),
                ),
        ],
      ),
    );
  }

  void _showReportDialog(Journal journal) {
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

  void _showBlockDialog(Journal journal) {
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
              await widget.storageService.blockUser(journal.userId);
              // 重新加载日记列表
              await _loadPublicJournals();
              if (mounted) {
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

  void _showMoreOptions(Journal journal) {
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
                  _showReportDialog(journal);
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
                  _showBlockDialog(journal);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJournalCard(Journal journal) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JournalDetailScreen(
              journalId: journal.id,
              storageService: widget.storageService,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // 图片占满整个卡片
              if (journal.imageUrl != null)
                Positioned.fill(
                  child: journal.imageUrl!.startsWith('http')
                      ? Image.network(
                          journal.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
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
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
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
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[800],
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                ),
              // 半透明黑色渐变遮罩
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.85),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
              // 更多选项按钮
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => _showMoreOptions(journal),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
              // 内容叠加在图片上
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        journal.content,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                          shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      if (journal.emotionTags.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: journal.emotionTags.take(2).map((tag) {
                            final emotionColor = _getEmotionColor(tag);
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: emotionColor.withValues(alpha: 0.6),
                                ),
                              ),
                              child: Text(
                                '#${EmotionTag.getTagByName(tag)?.displayName ?? tag}',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: emotionColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
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
                                      ).withValues(alpha: 0.7),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    '匿',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                '匿名用户',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.favorite_border,
                                size: 12,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 3),
                              const Text(
                                '28',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.chat_bubble_outline,
                                size: 12,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 3),
                              const Text(
                                '6',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

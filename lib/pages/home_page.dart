import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/data.dart';
import '../theme/theme.dart';
import '../components/timeline_entry.dart';
import 'add_entry_page.dart';
import '../utils/responsive_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum HomeView { calendar, list }

class _HomePageState extends State<HomePage> {
  HomeView _view = HomeView.list;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  DateTime _selectedDate = DateTime.now();
  DateTime _calendarMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _filterByMonth();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _filterData(String query) {
    if (query.isEmpty) {
      _filterByMonth();
      return;
    }

    setState(() {
      _filteredData = AppState.instance.searchTimeline(query);
    });
  }

  void _filterByMonth() {
    setState(() {
      _filteredData = AppState.instance.getTimelineByMonth(_selectedDate);
      _filteredData.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    });
  }

  List<TimelineItem> _filteredData = [];

  Future<void> _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.textMain,
              surface: AppColors.surfaceLight,
              onSurface: AppColors.textMain,
            ),
            dialogBackgroundColor: AppColors.backgroundLight,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _calendarMonth = DateTime(picked.year, picked.month);
      });
      _filterByMonth();
    }
  }

  void _previousMonth() {
    setState(() {
      _calendarMonth = DateTime(_calendarMonth.year, _calendarMonth.month - 1);
      _selectedDate = DateTime(_calendarMonth.year, _calendarMonth.month);
    });
    _filterByMonth();
  }

  void _nextMonth() {
    setState(() {
      _calendarMonth = DateTime(_calendarMonth.year, _calendarMonth.month + 1);
      _selectedDate = DateTime(_calendarMonth.year, _calendarMonth.month);
    });
    _filterByMonth();
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: Column(
            children: [
              _buildHeader(greeting),
              if (_isSearching) _buildSearchBar(),
              _buildViewToggle(),
              Expanded(
                child: _view == HomeView.list
                    ? _buildListView()
                    : _buildCalendarView(),
              ),
            ],
          ),
          floatingActionButton: _buildFab(),
        );
      },
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return '早上好';
    } else if (hour < 17) {
      return '下午好';
    } else {
      return '晚上好';
    }
  }

  Widget _buildHeader(String greeting) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = ResponsiveHelper.getScaleFactor(context);
        final padding = ResponsiveHelper.responsivePadding(context);

        return Container(
          padding: EdgeInsets.fromLTRB(
            padding,
            padding * 0.8,
            padding,
            padding * 0.65,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.backgroundLight,
                Color(0xFFF3E8FF),
                Color(0xFFE8F4FD),
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            greeting,
                            style: TextStyle(
                              fontSize: 14 * scale,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF6B5B95),
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(height: 4 * scale),
                          Text(
                            '你的时间线',
                            style: TextStyle(
                              fontSize: 28 * scale,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1A1A2E),
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 8 * scale),
                          InkWell(
                            onTap: _showDatePicker,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16 * scale,
                                vertical: 8 * scale,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFE8D5F5),
                                    Color(0xFFD5E8F5),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFFC4B5E0),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.calendar_today_rounded,
                                    size: 16 * scale,
                                    color: const Color(0xFF6B5B95),
                                  ),
                                  SizedBox(width: 8 * scale),
                                  Text(
                                    DateFormat('yyyy年MM月').format(_selectedDate),
                                    style: TextStyle(
                                      fontSize: 15 * scale,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1A1A2E),
                                    ),
                                  ),
                                  SizedBox(width: 4 * scale),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: const Color(0xFF6B5B95),
                                    size: 18 * scale,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16 * scale),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isSearching = !_isSearching;
                          if (!_isSearching) {
                            _searchFocusNode.requestFocus();
                          } else {
                            _searchController.clear();
                            _filterData('');
                          }
                        });
                      },
                      child: Container(
                        width: 44 * scale,
                        height: 44 * scale,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE8D5F5), Color(0xFFD5E8F5)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFFC4B5E0),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          _isSearching
                              ? Icons.close_rounded
                              : Icons.search_rounded,
                          color: const Color(0xFF6B5B95),
                          size: 22 * scale,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: AppColors.backgroundLight,
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        onChanged: _filterData,
        style: const TextStyle(fontSize: 16, color: Color(0xFF1A1A2E)),
        decoration: InputDecoration(
          hintText: '搜索记录、标签、心情...',
          hintStyle: const TextStyle(fontSize: 16, color: Color(0xFF8A8A9A)),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xFF6B5B95),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    _filterData('');
                  },
                  child: const Icon(
                    Icons.clear_rounded,
                    color: Color(0xFF6B5B95),
                  ),
                )
              : null,
          filled: true,
          fillColor: const Color(0xFFF5F0FF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildViewToggle() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE8D5F5), Color(0xFFD5E8F5)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFC4B5E0), width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _view = HomeView.calendar),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: _view == HomeView.calendar
                        ? const LinearGradient(
                            colors: [
                              AppColors.gradientPurpleStart,
                              AppColors.gradientPurpleEnd,
                            ],
                          )
                        : null,
                    color: _view == HomeView.calendar
                        ? null
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: _view == HomeView.calendar
                        ? [
                            BoxShadow(
                              color: AppColors.gradientPurpleStart.withOpacity(
                                0.3,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        size: 18,
                        color: _view == HomeView.calendar
                            ? Colors.white
                            : const Color(0xFF6B5B95),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '日历',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: _view == HomeView.calendar
                              ? Colors.white
                              : const Color(0xFF6B5B95),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _view = HomeView.list),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: _view == HomeView.list
                        ? const LinearGradient(
                            colors: [
                              AppColors.gradientTealStart,
                              AppColors.gradientTealEnd,
                            ],
                          )
                        : null,
                    color: _view == HomeView.list ? null : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: _view == HomeView.list
                        ? [
                            BoxShadow(
                              color: AppColors.gradientTealStart.withOpacity(
                                0.3,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.view_list_rounded,
                        size: 18,
                        color: _view == HomeView.list
                            ? Colors.white
                            : const Color(0xFF6B5B95),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '列表',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: _view == HomeView.list
                              ? Colors.white
                              : const Color(0xFF6B5B95),
                        ),
                      ),
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

  Widget _buildListView() {
    if (_filteredData.isEmpty) {
      return _buildEmptyState('本月暂无记录');
    }

    return Stack(
      children: [
        Positioned(
          left: 23,
          top: 24,
          bottom: 0,
          child: Container(
            width: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.oatmeal.withOpacity(0.4),
                  AppColors.oatmeal.withOpacity(0.1),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView.builder(
            itemCount: _filteredData.length,
            itemBuilder: (context, index) {
              return TimelineEntry(
                item: _filteredData[index],
                isLast: index == _filteredData.length - 1,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 24),
          Text(
            message,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5A7A70),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '尝试选择其他月份或添加新记录',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarView() {
    final year = _calendarMonth.year;
    final month = _calendarMonth.month;

    final firstDayOfMonth = DateTime(year, month, 1);
    final firstWeekday = firstDayOfMonth.weekday % 7;

    final daysInMonth = DateTime(year, month + 1, 0).day;

    final days = List.generate(daysInMonth, (i) => i + 1);
    final blanks = List.generate(firstWeekday, (i) => i);
    final today = DateTime.now();
    final isCurrentMonth = today.year == year && today.month == month;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('yyyy年MM月').format(_calendarMonth),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              Row(
                children: [
                  _buildCalendarNavButton(
                    Icons.chevron_left_rounded,
                    _previousMonth,
                  ),
                  const SizedBox(width: 8),
                  _buildCalendarNavButton(
                    Icons.chevron_right_rounded,
                    _nextMonth,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['日', '一', '二', '三', '四', '五', '六']
                .map(
                  (day) => SizedBox(
                    width: 40,
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B5B95),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 4,
            childAspectRatio: 0.85,
            children: [
              ...blanks.map((_) => const SizedBox()),
              ...days.map((day) {
                final isToday = isCurrentMonth && day == today.day;
                final isSelected =
                    _selectedDate.day == day &&
                    _selectedDate.month == month &&
                    _selectedDate.year == year;
                final hasEntry = mockTimelineData.any(
                  (item) =>
                      item.timestamp.year == year &&
                      item.timestamp.month == month &&
                      item.timestamp.day == day,
                );

                final moodData = mockTimelineData.firstWhere(
                  (item) =>
                      item.timestamp.year == year &&
                      item.timestamp.month == month &&
                      item.timestamp.day == day,
                  orElse: () => mockTimelineData.first,
                );
                return _buildCalendarDay(
                  day,
                  isToday,
                  isSelected,
                  hasEntry,
                  moodData,
                );
              }),
            ],
          ),
          const SizedBox(height: 24),
          _buildSummaryCard(year, month),
        ],
      ),
    );
  }

  Widget _buildCalendarNavButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE8D5F5), Color(0xFFD5E8F5)],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF6B5B95), size: 20),
      ),
    );
  }

  Widget _buildCalendarDay(
    int day,
    bool isToday,
    bool isSelected,
    bool hasEntry,
    dynamic moodData,
  ) {
    final moodColor = _getMoodColorForType(moodData.mood.type);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = DateTime(
            _calendarMonth.year,
            _calendarMonth.month,
            day,
          );
        });
        _filterByMonth();
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [
                    AppColors.gradientPurpleStart,
                    AppColors.gradientPurpleEnd,
                  ],
                )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isToday
              ? Border.all(color: AppColors.gradientPurpleStart, width: 2)
              : Border.all(color: Colors.transparent),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.gradientPurpleStart.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                gradient: isToday || isSelected
                    ? const LinearGradient(
                        colors: [
                          AppColors.gradientPurpleStart,
                          AppColors.gradientPurpleEnd,
                        ],
                      )
                    : null,
                color: isToday || isSelected ? null : Colors.transparent,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '$day',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isToday || isSelected
                      ? FontWeight.bold
                      : FontWeight.w500,
                  color: isToday || isSelected
                      ? Colors.white
                      : const Color(0xFF1A1A2E),
                ),
              ),
            ),
            if (hasEntry) ...[
              const SizedBox(height: 4),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [moodColor, moodColor.withOpacity(0.7)],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getMoodColorForType(dynamic type) {
    switch (type) {
      case MoodType.happy:
        return AppColors.moodHappy;
      case MoodType.sad:
        return AppColors.moodSad;
      case MoodType.excited:
        return AppColors.moodExcited;
      case MoodType.chill:
        return AppColors.moodChill;
      default:
        return Colors.grey;
    }
  }

  Widget _buildSummaryCard(int year, int month) {
    final monthData = mockTimelineData
        .where(
          (item) =>
              item.timestamp.year == year && item.timestamp.month == month,
        )
        .toList();

    final happyCount = monthData
        .where((item) => item.mood.type == MoodType.happy)
        .length;
    final chillCount = monthData
        .where((item) => item.mood.type == MoodType.chill)
        .length;
    final sadCount = monthData
        .where((item) => item.mood.type == MoodType.sad)
        .length;
    final excitedCount = monthData
        .where((item) => item.mood.type == MoodType.excited)
        .length;
    final totalCount = monthData.length;

    String dominantMood = '平衡';
    String dominantEmoji = '😊';
    Color dominantColor = AppColors.moodHappy;
    String moodMessage = '你做得很好！';

    if (totalCount > 0) {
      final moodCounts = {
        '开心': happyCount,
        '放松': chillCount,
        '兴奋': excitedCount,
        '难过': sadCount,
      };
      final maxMood = moodCounts.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      );

      switch (maxMood.key) {
        case '开心':
          dominantMood = ' mostly 开心';
          dominantEmoji = '🤩';
          dominantColor = AppColors.moodHappy;
          moodMessage = '你度过了美好的一个月！';
          break;
        case '放松':
          dominantMood = ' mostly 放松';
          dominantEmoji = '😌';
          dominantColor = AppColors.moodChill;
          moodMessage = '达到了宁静与平和。';
          break;
        case '兴奋':
          dominantMood = ' mostly 兴奋';
          dominantEmoji = '🎉';
          dominantColor = AppColors.moodExcited;
          moodMessage = '多么冒险的一个月！';
          break;
        case '难过':
          dominantMood = '需要关爱';
          dominantEmoji = '💙';
          dominantColor = AppColors.moodSad;
          moodMessage = '有艰难的日子也没关系。';
          break;
      }
    }

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF3E8FF), Color(0xFFE8F4FD)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFC4B5E0), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.gradientPurpleStart,
                      AppColors.gradientPurpleEnd,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gradientPurpleStart.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.analytics_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '月度总结',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    Text(
                      DateFormat('yyyy年MM月').format(_calendarMonth),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B5B95),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  dominantColor.withOpacity(0.5),
                  dominantColor.withOpacity(0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: dominantColor.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Text(dominantEmoji, style: const TextStyle(fontSize: 36)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dominantMood,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        moodMessage,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B5B95),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [dominantColor, dominantColor.withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: dominantColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '$totalCount entries',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildMoodStat('开心', '$happyCount', '😊', AppColors.moodHappy),
              const SizedBox(width: 8),
              _buildMoodStat('放松', '$chillCount', '😌', AppColors.moodChill),
              const SizedBox(width: 8),
              _buildMoodStat(
                '兴奋',
                '$excitedCount',
                '🎉',
                AppColors.moodExcited,
              ),
              const SizedBox(width: 8),
              _buildMoodStat('难过', '$sadCount', '😢', AppColors.moodSad),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodStat(String label, String count, String emoji, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color.withOpacity(0.5), color.withOpacity(0.3)],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.5), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 4),
            Text(
              count,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                color: Color(0xFF6B5B95),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFab() {
    return Container(
      margin: const EdgeInsets.only(bottom: 80),
      child: FloatingActionButton(
        heroTag: 'home_add_fab',
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEntryPage(),
              allowSnapshotting: false,
            ),
          );

          if (result == true) {
            setState(() {
              _filterByMonth();
            });
          }
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [
                AppColors.gradientPurpleStart,
                AppColors.gradientPurpleEnd,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.gradientPurpleStart.withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.add_rounded, size: 32, color: Colors.white),
        ),
      ),
    );
  }
}

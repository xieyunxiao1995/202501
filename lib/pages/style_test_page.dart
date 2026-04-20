import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme.dart';
import 'style_result_page.dart';
import '../utils/responsive_helper.dart';

class StyleTestPage extends StatefulWidget {
  const StyleTestPage({super.key});

  @override
  State<StyleTestPage> createState() => _StyleTestPageState();
}

class _StyleTestPageState extends State<StyleTestPage> {
  int _currentQuestion = 0;
  final Map<int, String> _answers = {};

  final List<StyleQuestion> _questions = [
    StyleQuestion(
      id: 0,
      question: '你最喜欢的颜色是？',
      options: [
        '清新浅色系（白、浅蓝、浅粉）',
        '经典深色系（黑、深蓝、深灰）',
        '大地色系（卡其、棕色、米色）',
        '鲜艳亮色（红、黄、亮绿）',
      ],
    ),
    StyleQuestion(
      id: 1,
      question: '你常去的场合是？',
      options: [
        '职场通勤（办公室、会议）',
        '休闲社交（咖啡厅、聚会）',
        '运动户外（健身房、郊游）',
        '约会约会（餐厅、电影院）',
      ],
    ),
    StyleQuestion(
      id: 2,
      question: '你偏好的穿搭风格是？',
      options: [
        '简约极简（干净利落，少即是多）',
        '复古怀旧（经典元素，年代感）',
        '街头潮流（个性张扬，时尚前卫）',
        '优雅知性（温柔大方，气质出众）',
      ],
    ),
    StyleQuestion(
      id: 3,
      question: '你的预算范围是？',
      options: [
        '平价实惠（单件200元以内）',
        '中等价位（单件200-500元）',
        '轻奢品质（单件500-1000元）',
        '高端定制（单件1000元以上）',
      ],
    ),
    StyleQuestion(
      id: 4,
      question: '你的身材特点是？',
      options: [
        '纤细苗条（偏瘦，适合修身款）',
        '匀称标准（百搭，各种款式都可）',
        '丰满曲线（适合遮肉显瘦款）',
        '高挑修长（适合长款、阔腿裤）',
      ],
    ),
    StyleQuestion(
      id: 5,
      question: '你最喜欢的季节穿搭是？',
      options: [
        '春季（轻薄外套、碎花裙、针织衫）',
        '夏季（T恤、短裤、连衣裙）',
        '秋季（风衣、毛衣、牛仔裤）',
        '冬季（大衣、羽绒服、围巾搭配）',
      ],
    ),
    StyleQuestion(
      id: 6,
      question: '你对配饰的态度是？',
      options: [
        '必不可少（包包、首饰、帽子都要搭配）',
        '适度点缀（简单项链或手表）',
        '简约为主（偶尔搭配一两个）',
        '不太在意（舒适最重要）',
      ],
    ),
  ];

  void _selectAnswer(int questionId, String answer) {
    setState(() {
      _answers[questionId] = answer;
    });
  }

  void _nextQuestion() {
    HapticFeedback.lightImpact();
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
      });
    } else {
      _submitTest();
    }
  }

  void _previousQuestion() {
    HapticFeedback.lightImpact();
    if (_currentQuestion > 0) {
      setState(() {
        _currentQuestion--;
      });
    }
  }

  void _submitTest() {
    final answersList = _answers.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final answersText = answersList.map((e) => e.value).join('\n');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StyleResultPage(answers: answersText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = _questions[_currentQuestion];
    final progress = (_currentQuestion + 1) / _questions.length;
    final padding = ResponsiveHelper.responsivePadding(context);
    final scale = ResponsiveHelper.getScaleFactor(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(progress),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuestionCard(currentQ),
                    SizedBox(height: 32 * scale),
                    _buildAnswerOptions(currentQ),
                    SizedBox(height: 40 * scale),
                    _buildNavigationButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double progress) {
    final scale = ResponsiveHelper.getScaleFactor(context);
    final padding = ResponsiveHelper.responsivePadding(context);

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.backgroundLight,
            Color(0xFFF3E8FF),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(8 * scale),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 20 * scale,
                    color: AppColors.textMain,
                  ),
                ),
              ),
              SizedBox(width: 16 * scale),
              Text(
                '风格测试',
                style: TextStyle(
                  fontSize: 22 * scale,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),
            ],
          ),
          SizedBox(height: 20 * scale),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.gradientRoseStart,
            ),
            minHeight: 8,
          ),
          SizedBox(height: 8 * scale),
          Text(
            '第 ${_currentQuestion + 1} / ${_questions.length} 题',
            style: TextStyle(
              fontSize: 14 * scale,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(StyleQuestion question) {
    final scale = ResponsiveHelper.getScaleFactor(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24 * scale),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.gradientRoseStart,
            AppColors.gradientRoseEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.gradientRoseStart.withOpacity(0.3),
            blurRadius: 16 * scale,
            offset: Offset(0, 6 * scale),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.help_outline_rounded,
            color: Colors.white,
            size: 32 * scale,
          ),
          SizedBox(height: 16 * scale),
          Text(
            question.question,
            style: TextStyle(
              fontSize: 20 * scale,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerOptions(StyleQuestion question) {
    final scale = ResponsiveHelper.getScaleFactor(context);

    return Column(
      children: question.options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final isSelected = _answers[question.id] == option;

        return Padding(
          padding: EdgeInsets.only(bottom: 12 * scale),
          child: GestureDetector(
            onTap: () => _selectAnswer(question.id, option),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(20 * scale),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [
                          AppColors.gradientTealStart,
                          AppColors.gradientTealEnd,
                        ],
                      )
                    : null,
                color: isSelected ? null : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppColors.gradientTealStart
                      : Colors.grey.shade200,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? AppColors.gradientTealStart.withOpacity(0.2)
                        : Colors.black.withOpacity(0.03),
                    blurRadius: isSelected ? 12 * scale : 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 28 * scale,
                    height: 28 * scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.grey.shade400,
                        width: 2,
                      ),
                      color: isSelected ? Colors.white : Colors.transparent,
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check_rounded,
                            size: 18 * scale,
                            color: AppColors.gradientTealStart,
                          )
                        : null,
                  ),
                  SizedBox(width: 16 * scale),
                  Expanded(
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 15 * scale,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.textMain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNavigationButtons() {
    final scale = ResponsiveHelper.getScaleFactor(context);

    return Row(
      children: [
        if (_currentQuestion > 0)
          Expanded(
            child: GestureDetector(
              onTap: _previousQuestion,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16 * scale),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back_ios_rounded, size: 18 * scale),
                    SizedBox(width: 8 * scale),
                    Text(
                      '上一题',
                      style: TextStyle(
                        fontSize: 16 * scale,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (_currentQuestion > 0) SizedBox(width: 12 * scale),
        Expanded(
          child: GestureDetector(
            onTap: _answers[_currentQuestion] != null ? _nextQuestion : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(vertical: 16 * scale),
              decoration: BoxDecoration(
                gradient: _answers[_currentQuestion] != null
                    ? const LinearGradient(
                        colors: [
                          AppColors.gradientRoseStart,
                          AppColors.gradientRoseEnd,
                        ],
                      )
                    : null,
                color: _answers[_currentQuestion] != null
                    ? null
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
                boxShadow: _answers[_currentQuestion] != null
                    ? [
                        BoxShadow(
                          color: AppColors.gradientRoseStart.withOpacity(0.3),
                          blurRadius: 12 * scale,
                          offset: Offset(0, 4 * scale),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentQuestion == _questions.length - 1
                        ? '查看结果'
                        : '下一题',
                    style: TextStyle(
                      fontSize: 16 * scale,
                      fontWeight: FontWeight.bold,
                      color: _answers[_currentQuestion] != null
                          ? Colors.white
                          : Colors.grey.shade400,
                    ),
                  ),
                  SizedBox(width: 8 * scale),
                  Icon(
                    _currentQuestion == _questions.length - 1
                        ? Icons.check_rounded
                        : Icons.arrow_forward_ios_rounded,
                    size: 18 * scale,
                    color: _answers[_currentQuestion] != null
                        ? Colors.white
                        : Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class StyleQuestion {
  final int id;
  final String question;
  final List<String> options;

  const StyleQuestion({
    required this.id,
    required this.question,
    required this.options,
  });
}

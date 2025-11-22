import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zhenyu_flutter/screens/common/tag_chip.dart';
import 'package:zhenyu_flutter/shared/styled_dialog.dart';
import 'package:zhenyu_flutter/theme.dart';

class PickerUtils {
  static final DateTime _minBirthday = DateTime(1975, 1, 1);
  static final DateTime _maxBirthday = DateTime(2007, 12, 31);
  static final DateTime _defaultBirthday = DateTime(2005, 1, 1);

  static DateTime _clampBirthday(DateTime value) {
    if (value.isBefore(_minBirthday)) return _minBirthday;
    if (value.isAfter(_maxBirthday)) return _maxBirthday;
    return value;
  }

  static List<int> _availableMonths(int year) {
    final start = year == _minBirthday.year ? _minBirthday.month : 1;
    final end = year == _maxBirthday.year ? _maxBirthday.month : 12;
    return List<int>.generate(end - start + 1, (index) => start + index);
  }

  static List<int> _availableDays(int year, int month) {
    final totalDays = DateTime(year, month + 1, 0).day;
    final start = (year == _minBirthday.year && month == _minBirthday.month)
        ? _minBirthday.day
        : 1;
    final end = (year == _maxBirthday.year && month == _maxBirthday.month)
        ? _maxBirthday.day
        : totalDays;
    return List<int>.generate(end - start + 1, (index) => start + index);
  }

  static Future<DateTime?> showDatePicker(
    BuildContext context,
    DateTime? initial,
  ) async {
    DateTime initialDate = _clampBirthday(initial ?? _defaultBirthday);

    int selectedYear = initialDate.year;
    int selectedMonth = initialDate.month;
    int selectedDay = initialDate.day;

    final years = List.generate(
      _maxBirthday.year - _minBirthday.year + 1,
      (i) => _minBirthday.year + i,
    );
    List<int> months = _availableMonths(selectedYear);
    if (!months.contains(selectedMonth)) selectedMonth = months.first;
    List<int> days = _availableDays(selectedYear, selectedMonth);
    if (!days.contains(selectedDay)) selectedDay = days.first;

    int yearIndex = years.indexOf(selectedYear);
    int monthIndex = months.indexOf(selectedMonth);
    int dayIndex = days.indexOf(selectedDay);

    final yearController = FixedExtentScrollController(initialItem: yearIndex);
    final monthController = FixedExtentScrollController(
      initialItem: monthIndex,
    );
    final dayController = FixedExtentScrollController(initialItem: dayIndex);

    final result = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: AppColors.pickUtilsColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SizedBox(
          height: 300,
          child: StatefulBuilder(
            builder: (dialogCtx, setStateDialog) {
              return Column(
                children: [
                  _buildPickerHeader(
                    dialogCtx,
                    onConfirm: () => Navigator.of(
                      dialogCtx,
                    ).pop(DateTime(selectedYear, selectedMonth, selectedDay)),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: 32,
                            scrollController: yearController,
                            backgroundColor: AppColors.pickUtilsColor,
                            onSelectedItemChanged: (index) {
                              final newYear = years[index];
                              if (newYear == selectedYear) return;
                              selectedYear = newYear;

                              months = _availableMonths(selectedYear);
                              if (!months.contains(selectedMonth)) {
                                selectedMonth = months.first;
                              }
                              monthIndex = months.indexOf(selectedMonth);
                              monthController.jumpToItem(monthIndex);

                              days = _availableDays(
                                selectedYear,
                                selectedMonth,
                              );
                              if (!days.contains(selectedDay)) {
                                selectedDay = days.first;
                              }
                              dayIndex = days.indexOf(selectedDay);
                              dayController.jumpToItem(dayIndex);

                              setStateDialog(() {});
                            },
                            children: years
                                .map(
                                  (year) => Center(
                                    child: Text(
                                      '$year年',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: 32,
                            scrollController: monthController,
                            backgroundColor: AppColors.pickUtilsColor,
                            onSelectedItemChanged: (index) {
                              final newMonth = months[index];
                              if (newMonth == selectedMonth) return;
                              selectedMonth = newMonth;

                              days = _availableDays(
                                selectedYear,
                                selectedMonth,
                              );
                              if (!days.contains(selectedDay)) {
                                selectedDay = days.first;
                              }
                              dayIndex = days.indexOf(selectedDay);
                              dayController.jumpToItem(dayIndex);

                              monthIndex = index;
                              setStateDialog(() {});
                            },
                            children: months
                                .map(
                                  (month) => Center(
                                    child: Text(
                                      '${month.toString().padLeft(2, '0')}月',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: 32,
                            scrollController: dayController,
                            backgroundColor: AppColors.pickUtilsColor,
                            onSelectedItemChanged: (index) {
                              selectedDay = days[index];
                              dayIndex = index;
                            },
                            children: days
                                .map(
                                  (day) => Center(
                                    child: Text(
                                      '${day.toString().padLeft(2, '0')}日',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );

    yearController.dispose();
    monthController.dispose();
    dayController.dispose();

    return result;
  }

  static Future<int?> showHeightPicker(
    BuildContext context,
    int? initialHeight,
  ) {
    final heightOptions = List.generate(61, (index) => 140 + index);
    final initialValue = initialHeight ?? 165;
    int initialIndex = heightOptions.indexOf(initialValue);
    if (initialIndex < 0) initialIndex = (heightOptions.length / 2).floor();
    int tempSelection = heightOptions[initialIndex];

    return showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.pickUtilsColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SizedBox(
          height: 260,
          child: Column(
            children: [
              _buildPickerHeader(
                ctx,
                onConfirm: () => Navigator.of(ctx).pop(tempSelection),
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 32,
                  scrollController: FixedExtentScrollController(
                    initialItem: initialIndex,
                  ),
                  onSelectedItemChanged: (index) {
                    tempSelection = heightOptions[index];
                  },
                  backgroundColor: AppColors.pickUtilsColor,
                  children: heightOptions
                      .map(
                        (value) => Center(
                          child: Text(
                            '$value cm',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<int?> showWeightPicker(
    BuildContext context,
    int? initialWeight,
  ) {
    final weightOptions = List.generate(66, (index) => 35 + index);
    final initialValue = initialWeight ?? 50;
    int initialIndex = weightOptions.indexOf(initialValue);
    if (initialIndex < 0) initialIndex = (weightOptions.length / 2).floor();
    int tempSelection = weightOptions[initialIndex];

    return showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.pickUtilsColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SizedBox(
          height: 260,
          child: Column(
            children: [
              _buildPickerHeader(
                ctx,
                onConfirm: () => Navigator.of(ctx).pop(tempSelection),
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 32,
                  scrollController: FixedExtentScrollController(
                    initialItem: initialIndex,
                  ),
                  onSelectedItemChanged: (index) {
                    tempSelection = weightOptions[index];
                  },
                  backgroundColor: AppColors.pickUtilsColor,
                  children: weightOptions
                      .map(
                        (value) => Center(
                          child: Text(
                            '$value kg',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<String?> showFigureDialog(
    BuildContext context,
    String? initialFigure,
    List<String> figureOptions,
  ) {
    if (figureOptions.isEmpty) return Future.value(null);
    String? tempSelection = initialFigure;

    return StyledDialog.show<String>(
      context: context,
      titleText: '身材',
      showCancelButton: false,
      confirmText: '确认',
      dismissOnConfirm: false,
      onConfirm: (dialogCtx) {
        Navigator.of(dialogCtx).pop(tempSelection);
      },
      content: StatefulBuilder(
        builder: (dialogCtx, setStateDialog) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: figureOptions.map((option) {
                  final selected = option == tempSelection;
                  return TagChip(
                    label: option,
                    selected: selected,
                    onTap: () {
                      setStateDialog(() {
                        tempSelection = option;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  static Future<String?> showCommentDialog(
    BuildContext context,
    String? initialComment,
    List<String> commentOptions,
  ) {
    if (commentOptions.isEmpty) return Future.value(null);
    String? tempSelection = initialComment;

    return StyledDialog.show<String>(
      context: context,
      titleText: '点评',
      showCancelButton: false,
      confirmText: '确认',
      dismissOnConfirm: false,
      onConfirm: (dialogCtx) {
        Navigator.of(dialogCtx).pop(tempSelection);
      },
      content: StatefulBuilder(
        builder: (dialogCtx, setStateDialog) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: commentOptions.map((option) {
                  final selected = option == tempSelection;
                  return TagChip(
                    label: option,
                    selected: selected,
                    onTap: () {
                      setStateDialog(() {
                        tempSelection = option;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  static Widget _buildPickerHeader(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.pickUtilsColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消', style: TextStyle(color: Colors.white)),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onConfirm,
            child: const Text('确认', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

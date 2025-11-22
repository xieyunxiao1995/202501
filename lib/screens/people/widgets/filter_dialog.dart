import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zhenyu_flutter/models/index_api_model.dart';
import 'package:zhenyu_flutter/models/user_api_model.dart';
import 'package:zhenyu_flutter/screens/people/widgets/city_picker.dart';
import 'package:zhenyu_flutter/screens/people/widgets/select_tag_dialog.dart';
import 'package:zhenyu_flutter/shared/styled_button.dart';
import 'package:zhenyu_flutter/theme.dart';

class FilterOptions {
  final RangeValues ageRange;
  final bool onlyCertified;
  final bool hideFromNearby;
  final bool priorityOnline;
  final bool priorityDistance;
  final String? selectedTag;
  final String? selectedLocation;
  final String? cityCode;

  FilterOptions({
    required this.ageRange,
    required this.onlyCertified,
    required this.hideFromNearby,
    required this.priorityOnline,
    required this.priorityDistance,
    this.selectedTag,
    this.selectedLocation,
    this.cityCode,
  });
}

class FilterDialog extends StatefulWidget {
  final List<CityInfo>? cityData;
  final GetUserProfileData? userProfileData;
  final FilterOptions initialFilters;

  const FilterDialog({
    super.key,
    this.cityData,
    this.userProfileData,
    required this.initialFilters,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  // State holders
  late RangeValues _ageRange;
  late bool _onlyCertified;
  late bool _hideFromNearby;
  late bool _priorityOnline;
  late bool _priorityDistance;
  late String? _selectedTag;
  late String? _selectedLocation;
  late String? _cityCode;

  @override
  void initState() {
    super.initState();
    _ageRange = widget.initialFilters.ageRange;
    _onlyCertified = widget.initialFilters.onlyCertified;
    _hideFromNearby = widget.initialFilters.hideFromNearby;
    _priorityOnline = widget.initialFilters.priorityOnline;
    _priorityDistance = widget.initialFilters.priorityDistance;
    _selectedTag = widget.initialFilters.selectedTag;
    _selectedLocation = widget.initialFilters.selectedLocation;
    _cityCode = widget.initialFilters.cityCode;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1000.h,
      decoration: const BoxDecoration(
        color: Color(0xFF131218),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Column(
                  children: [
                    _buildAgeSlider(),
                    SizedBox(height: 20.h),
                    _buildSwitchTile('只看认证用户', _onlyCertified, (value) {
                      setState(() => _onlyCertified = value);
                    }),
                    _buildSwitchTile('不让太近的人看到我', _hideFromNearby, (value) {
                      setState(() => _hideFromNearby = value);
                    }),
                    _buildSwitchTile('优先查看在线用户', _priorityOnline, (value) {
                      setState(() => _priorityOnline = value);
                    }),
                    _buildSwitchTile('优先查看距离近的用户', _priorityDistance, (value) {
                      setState(() => _priorityDistance = value);
                    }),
                    _buildPickerTile('包含标签：', _selectedTag ?? '请选择', () async {
                      final tagProfile = widget.userProfileData?.userProfile
                          ?.firstWhere(
                            (p) => p.description == '标签',
                            // 误删！ “如果在 userProfile 列表中找不到 description 是 '标签' 的元素，请不要报错，而是立即创建一个新的、空的 UserProfileItem 对象并返回它。”
                            orElse: () => UserProfileItem(),
                          );
                      final tags = tagProfile?.defaultLabels ?? [];
                      if (tags.isEmpty) {
                        // Optionally show a message that tags are not available
                        return;
                      }
                      final result = await showDialog<String>(
                        context: context,
                        builder: (context) => SelectTagDialog(
                          tags: tags,
                          selectedTag: _selectedTag,
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          _selectedTag = result;
                        });
                      }
                    }),
                    _buildPickerTile(
                      '修改位置：',
                      _selectedLocation ?? '请选择',
                      () async {
                        if (widget.cityData == null) {
                          // Optionally show a message that city data is not available
                          return;
                        }
                        final result =
                            await showModalBottomSheet<Map<String, CityInfo?>>(
                              context: context,
                              builder: (context) =>
                                  CityPicker(provinces: widget.cityData!),
                            );
                        if (result != null) {
                          final province = result['province'];
                          final city = result['city'];
                          setState(() {
                            _selectedLocation =
                                '${province?.name ?? ''} ${city?.name ?? ''}'
                                    .trim();
                            // Assuming the city code is what we need for the API
                            _cityCode = city?.code ?? province?.code;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      child: Row(
        children: [
          Expanded(
            child: Center(child: Text('筛选', style: textStylePrimary)),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildAgeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Row(
            children: [
              Text('年龄范围', style: textStylePrimary.copyWith(fontSize: 27.sp)),
              SizedBox(width: 31.w),
              Text(
                '${_ageRange.start.round()}岁—${_ageRange.end.round() == 100 ? '不限' : '${_ageRange.end.round()}岁'}',
                style: textStylePrimary.copyWith(
                  fontSize: 27.sp,
                  color: AppColors.secondaryGradientStart,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 600.w,
          child: RangeSlider(
            values: _ageRange,
            min: 18,
            max: 100,
            divisions: 82,
            labels: RangeLabels(
              _ageRange.start.round().toString(),
              _ageRange.end.round() == 100
                  ? '不限'
                  : _ageRange.end.round().toString(),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _ageRange = values;
              });
            },
            activeColor: const Color(0xFFF2D199),
            inactiveColor: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: textStylePrimary.copyWith(fontSize: 27.sp)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFF2D199),
            // To match the smaller size in uniapp
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerTile(String title, String value, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: textStylePrimary.copyWith(fontSize: 27.sp)),
            Row(
              children: [
                Text(
                  value,
                  style: textStyleSecondary.copyWith(fontSize: 27.sp),
                ),
                SizedBox(width: 10.w),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 30.h),
      child: Row(
        children: [
          Expanded(
            flex: 250,
            child: StyledButton(
              onPressed: () {
                final defaultFilters = FilterOptions(
                  ageRange: const RangeValues(18, 100),
                  onlyCertified: false,
                  // Respect the initial hideFromNearby value from server
                  hideFromNearby: widget.initialFilters.hideFromNearby,
                  priorityOnline: false,
                  priorityDistance: false,
                  selectedTag: null,
                  selectedLocation: null,
                  cityCode: null,
                );
                Navigator.of(
                  context,
                ).pop({'filters': defaultFilters, 'applied': false});
              },
              backgroundColor: AppColors.btnText,
              child: Text(
                '重置',
                style: textStylePrimary.copyWith(fontSize: 31.sp),
              ),
            ),
          ),
          SizedBox(width: 41.w),
          Expanded(
            flex: 375,
            child: StyledButton(
              onPressed: () {
                final newFilters = FilterOptions(
                  ageRange: _ageRange,
                  onlyCertified: _onlyCertified,
                  hideFromNearby: _hideFromNearby,
                  priorityOnline: _priorityOnline,
                  priorityDistance: _priorityDistance,
                  selectedTag: _selectedTag,
                  selectedLocation: _selectedLocation,
                  cityCode: _cityCode,
                );
                Navigator.of(
                  context,
                ).pop({'filters': newFilters, 'applied': true});
              },
              gradient: AppGradients.primaryGradient,
              child: Text(
                '确定筛选',
                style: textStylePrimary.copyWith(
                  fontSize: 31.sp,
                  color: const Color(0xFF1F2635),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

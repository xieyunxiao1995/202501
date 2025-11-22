import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zhenyu_flutter/models/index_api_model.dart';
import 'package:zhenyu_flutter/theme.dart';

class CityPicker extends StatefulWidget {
  final List<CityInfo> provinces;

  const CityPicker({super.key, required this.provinces});

  @override
  State<CityPicker> createState() => _CityPickerState();
}

class _CityPickerState extends State<CityPicker> {
  List<CityInfo> _cities = [];

  int _selectedProvinceIndex = 0;
  int _selectedCityIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.provinces.isNotEmpty) {
      _updateCities(0);
    }
  }

  void _updateCities(int provinceIndex) {
    setState(() {
      _selectedProvinceIndex = provinceIndex;
      _cities = widget.provinces[_selectedProvinceIndex].list ?? [];
      _selectedCityIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.provinces.isEmpty) {
      return const Center(child: Text('No city data available.'));
    }
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          _buildToolbar(),
          Expanded(child: _buildPickers()),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              '取消',
              style: TextStyle(color: AppColors.primaryColor),
            ),
          ),
          TextButton(
            onPressed: () {
              final result = {
                'province': widget.provinces[_selectedProvinceIndex],
                'city': _cities.isNotEmpty ? _cities[_selectedCityIndex] : null,
              };
              Navigator.of(context).pop(result);
            },
            child: const Text(
              '确定',
              style: TextStyle(color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickers() {
    return Row(
      children: [
        _buildPickerColumn(
          widget.provinces,
          _selectedProvinceIndex,
          _updateCities,
        ),
        _buildPickerColumn(_cities, _selectedCityIndex, (index) {
          setState(() => _selectedCityIndex = index);
        }),
      ],
    );
  }

  Widget _buildPickerColumn(
    List<CityInfo> items,
    int selectedIndex,
    ValueChanged<int> onSelectedItemChanged,
  ) {
    return Expanded(
      child: CupertinoPicker(
        itemExtent: 40,
        scrollController: FixedExtentScrollController(
          initialItem: selectedIndex,
        ),
        onSelectedItemChanged: onSelectedItemChanged,
        children: items
            .map((item) => Center(child: Text(item.name ?? '')))
            .toList(),
      ),
    );
  }
}

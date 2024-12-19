import 'package:flutter/material.dart';
import 'package:ease/core/enums/time_range_type_enum.dart';

class TimeRangeProvider with ChangeNotifier {
  TimeRangeType _selectedType = TimeRangeType.monthly;
  late DateTime _currentDate;
  late DateTime _startDate;
  late DateTime _endDate;

  TimeRangeProvider() {
    _currentDate = DateTime.now();
    _calculateDateRange();
  }

  TimeRangeType get selectedType => _selectedType;
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;

  void setSelectedType(TimeRangeType type) {
    _selectedType = type;
    _calculateDateRange();
    notifyListeners();
  }

  void refresh() {
    _calculateDateRange();
    notifyListeners();
  }

  void _calculateDateRange() {
    switch (_selectedType) {
      case TimeRangeType.allTime:
        _startDate = DateTime(2000);
        _endDate = DateTime.now();
        break;
      case TimeRangeType.financialYear:
        final now = DateTime.now();
        final month = now.month;
        if (month >= 4) {
          _startDate = DateTime(now.year, 4);
          _endDate = DateTime(now.year + 1, 3, 31);
        } else {
          _startDate = DateTime(now.year - 1, 4);
          _endDate = DateTime(now.year, 3, 31);
        }
        break;
      case TimeRangeType.yearly:
        _startDate = DateTime(_currentDate.year);
        _endDate = DateTime(_currentDate.year + 1).subtract(Duration(days: 1));
        break;
      case TimeRangeType.quarterly:
        final quarter = (_currentDate.month / 3).ceil();
        _startDate = DateTime(_currentDate.year, (quarter - 1) * 3 + 1);
        _endDate = DateTime(_currentDate.year, quarter * 3 + 1)
            .subtract(Duration(days: 1));
        break;
      case TimeRangeType.monthly:
        _startDate = DateTime(_currentDate.year, _currentDate.month);
        _endDate = DateTime(_currentDate.year, _currentDate.month + 1)
            .subtract(Duration(days: 1));
        break;
      case TimeRangeType.weekly:
        final weekDay = _currentDate.weekday;
        _startDate = _currentDate.subtract(Duration(days: weekDay - 1));
        _endDate = _startDate.add(Duration(days: 6));
        break;
      case TimeRangeType.custom:
        // Handle custom date range
        // in this case the date range is set by calling setCustomDateRange, after showing the date picker
        break;
    }
  }

  void setCustomDateRange(DateTime start, DateTime end) {
    _startDate = start;
    _endDate = end;
    notifyListeners();
  }

  void navigateRange(bool forward) {
    switch (_selectedType) {
      case TimeRangeType.yearly:
        _currentDate = DateTime(_currentDate.year + (forward ? 1 : -1),
            _currentDate.month, _currentDate.day);
        break;
      case TimeRangeType.quarterly:
        _currentDate = DateTime(_currentDate.year,
            _currentDate.month + (forward ? 3 : -3), _currentDate.day);
        break;
      case TimeRangeType.monthly:
        _currentDate = DateTime(_currentDate.year,
            _currentDate.month + (forward ? 1 : -1), _currentDate.day);
        break;
      case TimeRangeType.weekly:
        _currentDate = _currentDate.add(Duration(days: forward ? 7 : -7));
        break;
      default:
        break;
    }
    _calculateDateRange();
    notifyListeners();
  }
}

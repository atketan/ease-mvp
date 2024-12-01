import 'package:ease/core/enums/time_range_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeRangeSelector extends StatefulWidget {
  final Function(DateTime startDate, DateTime endDate) onRangeSelected;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  const TimeRangeSelector({
    Key? key,
    required this.onRangeSelected,
    this.initialStartDate,
    this.initialEndDate,
  }) : super(key: key);

  @override
  _TimeRangeSelectorState createState() => _TimeRangeSelectorState();
}

class _TimeRangeSelectorState extends State<TimeRangeSelector> {
  TimeRangeType _selectedType = TimeRangeType.monthly;
  late DateTime _currentDate;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _calculateDateRange();
  }

  void _calculateDateRange() async {
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
        break;
    }
    widget.onRangeSelected(_startDate, _endDate);
  }

  void _navigateRange(bool forward) {
    switch (_selectedType) {
      case TimeRangeType.yearly:
        setState(() {
          _currentDate = DateTime(_currentDate.year + (forward ? 1 : -1),
              _currentDate.month, _currentDate.day);
        });
        break;
      case TimeRangeType.quarterly:
        setState(() {
          _currentDate = DateTime(_currentDate.year,
              _currentDate.month + (forward ? 3 : -3), _currentDate.day);
        });
        break;
      case TimeRangeType.monthly:
        setState(() {
          _currentDate = DateTime(_currentDate.year,
              _currentDate.month + (forward ? 1 : -1), _currentDate.day);
        });
        break;
      case TimeRangeType.weekly:
        setState(() {
          _currentDate = _currentDate.add(Duration(days: forward ? 7 : -7));
        });
        break;
      default:
        break;
    }
    _calculateDateRange();
  }

  String _getRangeText() {
    switch (_selectedType) {
      case TimeRangeType.allTime:
        return 'All Time';
      case TimeRangeType.financialYear:
        return 'FY ${_startDate.year}-${_endDate.year}';
      case TimeRangeType.yearly:
        return _currentDate.year.toString();
      case TimeRangeType.quarterly:
        final quarter = (_currentDate.month / 3).ceil();
        return 'Q$quarter ${_currentDate.year}';
      case TimeRangeType.monthly:
        return DateFormat('MMM yyyy').format(_currentDate);
      case TimeRangeType.weekly:
        return '${DateFormat('MMM d').format(_startDate)} - ${DateFormat('MMM d').format(_endDate)}';
      case TimeRangeType.custom:
        return '${DateFormat('MMM d, yyyy').format(_startDate)} - ${DateFormat('MMM d, yyyy').format(_endDate)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.only(
                left: 8.0, right: 4.0, top: 8.0, bottom: 8.0),
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColorLight),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<TimeRangeType>(
              value: _selectedType,
              isExpanded: true,
              underline: Container(), 
              items: TimeRangeType.values.map((TimeRangeType type) {
                return DropdownMenuItem<TimeRangeType>(
                  value: type,
                  child: Text(
                    type.displayName,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                );
              }).toList(),
              onChanged: (TimeRangeType? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedType = newValue;
                    if (newValue == TimeRangeType.custom) {
                      _showCustomDatePicker();
                    } else {
                      _currentDate = DateTime.now();
                      _calculateDateRange();
                    }
                  });
                }
              },
            ),
          ),
        ),
        // SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.only(
                right: 8.0, left: 4.0, top: 8.0, bottom: 8.0),
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColorLight),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_selectedType != TimeRangeType.custom)
                  IconButton(
                    icon: Icon(Icons.chevron_left),
                    onPressed: _selectedType != TimeRangeType.allTime
                        ? () => _navigateRange(false)
                        : null,
                  ),
                Container(
                  height: 48,
                  alignment: Alignment.center,
                  child: Text(
                    _getRangeText(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                if (_selectedType != TimeRangeType.custom)
                  IconButton(
                    icon: Icon(Icons.chevron_right),
                    onPressed: _selectedType != TimeRangeType.allTime
                        ? () => _navigateRange(true)
                        : null,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showCustomDatePicker() async {
    final now = DateTime.now();
    final lastDayOfMonth =
        DateTime(now.year, now.month + 1, 0); // Last day of current month

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: now,
      initialDateRange: DateTimeRange(
        start: DateTime(now.year, now.month, 1), // First day of current month
        end: lastDayOfMonth.isAfter(now)
            ? now
            : lastDayOfMonth, // Use earlier of last day of month or today
      ),
      initialEntryMode: DatePickerEntryMode.input,
      builder: (context, child) {
        return child!;
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        widget.onRangeSelected(_startDate, _endDate);
      });
    }
  }
}

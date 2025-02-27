import 'package:ease/core/enums/time_range_type_enum.dart';
import 'package:ease/widgets/time_range_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class TimeRangeSelector extends StatefulWidget {
  final Function(DateTime startDate, DateTime endDate) onRangeSelected;
  // final DateTime? initialStartDate;
  // final DateTime? initialEndDate;

  const TimeRangeSelector({
    Key? key,
    required this.onRangeSelected,
    // this.initialStartDate,
    // this.initialEndDate,
  }) : super(key: key);

  @override
  _TimeRangeSelectorState createState() => _TimeRangeSelectorState();
}

class _TimeRangeSelectorState extends State<TimeRangeSelector> {
  final timeRangeProvider = GetIt.instance<TimeRangeProvider>();

  // TimeRangeType timeRangeProvider.selectedType = TimeRangeType.monthly;
  // late DateTime _currentDate;
  // late DateTime _startDate;
  // late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    // _currentDate = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timeRangeProvider.refresh();
      widget.onRangeSelected(
        timeRangeProvider.startDate,
        timeRangeProvider.endDate,
      );
    });
    // _calculateDateRange();
  }

  // void _calculateDateRange() async {
  //   switch (timeRangeProvider.selectedType) {
  //     case TimeRangeType.allTime:
  //       _startDate = DateTime(2000);
  //       _endDate = DateTime.now();
  //       break;
  //     case TimeRangeType.financialYear:
  //       final now = DateTime.now();
  //       final month = now.month;
  //       if (month >= 4) {
  //         _startDate = DateTime(now.year, 4);
  //         _endDate = DateTime(now.year + 1, 3, 31);
  //       } else {
  //         _startDate = DateTime(now.year - 1, 4);
  //         _endDate = DateTime(now.year, 3, 31);
  //       }
  //       break;
  //     case TimeRangeType.yearly:
  //       _startDate = DateTime(_currentDate.year);
  //       _endDate = DateTime(_currentDate.year + 1).subtract(Duration(days: 1));
  //       break;
  //     case TimeRangeType.quarterly:
  //       final quarter = (_currentDate.month / 3).ceil();
  //       _startDate = DateTime(_currentDate.year, (quarter - 1) * 3 + 1);
  //       _endDate = DateTime(_currentDate.year, quarter * 3 + 1)
  //           .subtract(Duration(days: 1));
  //       break;
  //     case TimeRangeType.monthly:
  //       _startDate = DateTime(_currentDate.year, _currentDate.month);
  //       _endDate = DateTime(_currentDate.year, _currentDate.month + 1)
  //           .subtract(Duration(days: 1));
  //       break;
  //     case TimeRangeType.weekly:
  //       final weekDay = _currentDate.weekday;
  //       _startDate = _currentDate.subtract(Duration(days: weekDay - 1));
  //       _endDate = _startDate.add(Duration(days: 6));
  //       break;
  //     case TimeRangeType.custom:
  //       break;
  //   }
  //   widget.onRangeSelected(_startDate, _endDate);
  // }

  // void _navigateRange(bool forward) {
  //   switch (timeRangeProvider.selectedType) {
  //     case TimeRangeType.yearly:
  //       setState(() {
  //         _currentDate = DateTime(_currentDate.year + (forward ? 1 : -1),
  //             _currentDate.month, _currentDate.day);
  //       });
  //       break;
  //     case TimeRangeType.quarterly:
  //       setState(() {
  //         _currentDate = DateTime(_currentDate.year,
  //             _currentDate.month + (forward ? 3 : -3), _currentDate.day);
  //       });
  //       break;
  //     case TimeRangeType.monthly:
  //       setState(() {
  //         _currentDate = DateTime(_currentDate.year,
  //             _currentDate.month + (forward ? 1 : -1), _currentDate.day);
  //       });
  //       break;
  //     case TimeRangeType.weekly:
  //       setState(() {
  //         _currentDate = _currentDate.add(Duration(days: forward ? 7 : -7));
  //       });
  //       break;
  //     default:
  //       break;
  //   }
  //   _calculateDateRange();
  // }

  String _getRangeText(TimeRangeProvider provider) {
    switch (provider.selectedType) {
      case TimeRangeType.allTime:
        return 'All Time';
      case TimeRangeType.financialYear:
        return 'FY ${provider.startDate.year}-${provider.endDate.year}';
      case TimeRangeType.yearly:
        return provider.startDate.year.toString();
      case TimeRangeType.quarterly:
        final quarter = (provider.startDate.month / 3).ceil();
        return 'Q$quarter ${provider.startDate.year}';
      case TimeRangeType.monthly:
        return DateFormat('MMMM yyyy').format(provider.startDate);
      case TimeRangeType.weekly:
        return '${DateFormat('MMM d').format(provider.startDate)} - ${DateFormat('MMM d').format(provider.endDate)}';
      case TimeRangeType.custom:
        return '${DateFormat('MMM d, yyyy').format(provider.startDate)} - ${DateFormat('MMM d, yyyy').format(provider.endDate)}';
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
              value: timeRangeProvider.selectedType,
              isExpanded: true,
              underline: Container(),
              items: TimeRangeType.values.map((TimeRangeType type) {
                return DropdownMenuItem<TimeRangeType>(
                  value: type,
                  child: Text(
                    type.displayName,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                );
              }).toList(),
              onChanged: (TimeRangeType? newValue) {
                if (newValue != null) {
                  timeRangeProvider.setSelectedType(newValue);
                  if (newValue == TimeRangeType.custom) {
                    _showCustomDatePicker();
                  } else {
                    widget.onRangeSelected(
                      timeRangeProvider.startDate,
                      timeRangeProvider.endDate,
                    );
                  }
                }
                // if (newValue != null) {
                //   setState(() {
                //     timeRangeProvider.selectedType = newValue;
                //     if (newValue == TimeRangeType.custom) {
                //       _showCustomDatePicker();
                //     } else {
                //       _currentDate = DateTime.now();
                //       _calculateDateRange();
                //     }
                //   });
                // }
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
            child: Builder(builder: (context) {
              return Row(
                mainAxisAlignment:
                    (timeRangeProvider.selectedType == TimeRangeType.custom)
                        ? MainAxisAlignment.spaceAround
                        : MainAxisAlignment.spaceBetween,
                children: [
                  if (timeRangeProvider.selectedType != TimeRangeType.custom)
                    IconButton(
                      icon: Icon(Icons.chevron_left),
                      onPressed: timeRangeProvider.selectedType !=
                              TimeRangeType.allTime
                          ? () {
                              timeRangeProvider.navigateRange(false);
                              widget.onRangeSelected(
                                timeRangeProvider.startDate,
                                timeRangeProvider.endDate,
                              );
                            }
                          : null,
                    ),
                  Container(
                    height: 48,
                    alignment: Alignment.center,
                    child: Text(
                      _getRangeText(timeRangeProvider),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  if (timeRangeProvider.selectedType != TimeRangeType.custom)
                    IconButton(
                      icon: Icon(Icons.chevron_right),
                      onPressed: timeRangeProvider.selectedType !=
                              TimeRangeType.allTime
                          ? () {
                              timeRangeProvider.navigateRange(true);
                              widget.onRangeSelected(
                                timeRangeProvider.startDate,
                                timeRangeProvider.endDate,
                              );
                            }
                          : null,
                    ),
                ],
              );
            }),
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
        timeRangeProvider.setCustomDateRange(picked.start, picked.end);
        widget.onRangeSelected(picked.start, picked.end);
      });
      // setState(() {
      //   _startDate = picked.start;
      //   _endDate = picked.end;
      //   widget.onRangeSelected(_startDate, _endDate);
      // });
    }
  }
}

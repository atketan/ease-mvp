enum TimeRangeType {
  allTime,
  financialYear,
  yearly,
  quarterly,
  monthly,
  weekly,
  custom
}

extension TimeRangeTypeExtension on TimeRangeType {
  String get displayName {
    switch (this) {
      case TimeRangeType.allTime:
        return 'All Time';
      case TimeRangeType.financialYear:
        return 'Financial Year';
      case TimeRangeType.yearly:
        return 'Yearly';
      case TimeRangeType.quarterly:
        return 'Quarterly';
      case TimeRangeType.monthly:
        return 'Monthly';
      case TimeRangeType.weekly:
        return 'Weekly';
      case TimeRangeType.custom:
        return 'Custom';
    }
  }
}
import 'package:get_it/get_it.dart';
import 'package:ease/widgets/time_range_provider.dart';

GetIt getIt = GetIt.instance;

void registerDAOs() {
  // Register DAOs here
}

void registerProviders() {
  getIt.registerSingleton<TimeRangeProvider>(TimeRangeProvider());
}
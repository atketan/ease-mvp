import 'package:ease/core/database/app_user_configuration/firestore_app_user_configuration_dao.dart';
import 'package:ease/core/models/app_user_configuration.dart';
import 'package:get_it/get_it.dart';
import 'package:ease/widgets/time_range_provider.dart';

GetIt getIt = GetIt.instance;

void registerDAOs() {
  // Register DAOs here
  getIt.registerSingleton<FirestoreAppUserConfigurationDAO>(
      FirestoreAppUserConfigurationDAO());
}

void registerProviders() {
  getIt.registerSingleton<TimeRangeProvider>(TimeRangeProvider());
}

void registerDataSources() {
  getIt.registerSingleton<AppUserConfiguration>(
      AppUserConfiguration(enterpriseId: ''));
}

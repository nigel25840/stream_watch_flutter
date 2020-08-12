

import 'package:get_it/get_it.dart';
import 'package:streamwatcher/chart/chart_viewmodel.dart';
import 'package:streamwatcher/dataServices/data_provider.dart';
import 'package:streamwatcher/viewModel/favorites_view_model.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton<DataProvider>(() => DataProvider());
  serviceLocator.registerFactory<ChartViewModel>(() => ChartViewModel());
  serviceLocator.registerFactory<FavoritesViewModel>(() => FavoritesViewModel());
}
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet/features/common/route/router.gr.dart';

import 'di.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> configureDependencies() async => $initGetIt(getIt);

void resetGetIt<T extends Object>({
  Object? instance,
  String? instanceName,
  void Function(T)? disposingFunction,
}) {
  getIt.resetLazySingleton<T>(
    instance: instance,
    instanceName: instanceName,
    disposingFunction: disposingFunction,
  );
}

@module
abstract class DIModule {
  @singleton
  AppRouter get appRouter => AppRouter();
}

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../common/router.gr.dart' as _i3;
import '../features/common/balance_store.dart' as _i4;
import '../features/common/price_store.dart' as _i5;
import 'di.dart' as _i6; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final dIModule = _$DIModule();
  gh.singleton<_i3.AppRouter>(dIModule.appRouter);
  gh.lazySingleton<_i4.BalanceStore>(() => _i4.BalanceStore());
  gh.lazySingleton<_i5.PriceStore>(() => _i5.PriceStore());
  return get;
}

class _$DIModule extends _i6.DIModule {}

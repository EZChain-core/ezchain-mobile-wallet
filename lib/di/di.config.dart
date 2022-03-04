// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../common/router.gr.dart' as _i3;
import '../features/auth/pin/verify/pin_code_verify_store.dart' as _i5;
import '../features/common/balance_store.dart' as _i4;
import '../features/common/price_store.dart' as _i6;
import '../features/common/setting/wallet_setting.dart' as _i10;
import '../features/common/setting/wallet_setting_impl.dart' as _i11;
import '../features/common/validators_store.dart' as _i7;
import '../features/common/wallet_factory.dart' as _i8;
import '../features/common/wallet_factory_impl.dart' as _i9;
import 'di.dart' as _i12; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final dIModule = _$DIModule();
  gh.singleton<_i3.AppRouter>(dIModule.appRouter);
  gh.lazySingleton<_i4.BalanceStore>(() => _i4.BalanceStore());
  gh.lazySingleton<_i5.PinCodeVerifyStore>(() => _i5.PinCodeVerifyStore());
  gh.lazySingleton<_i6.PriceStore>(() => _i6.PriceStore());
  gh.lazySingleton<_i7.ValidatorsStore>(() => _i7.ValidatorsStore());
  gh.lazySingleton<_i8.WalletFactory>(() => _i9.WalletFactoryImpl());
  gh.lazySingleton<_i10.WalletSetting>(() => _i11.WalletSettingImpl());
  return get;
}

class _$DIModule extends _i12.DIModule {}

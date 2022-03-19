import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/ezc/sdk/apis/pvm/model/get_current_validators.dart';

part 'validators_store.g.dart';

@LazySingleton()
class ValidatorsStore = _ValidatorsStore with _$ValidatorsStore;

abstract class _ValidatorsStore with Store {
  final _wallet = getIt<WalletFactory>().activeWallet;

  @readonly
  //ignore: prefer_final_fields
  ObservableList<Validator> _validators = ObservableList.of([]);

  @action
  updateValidators() async {
    try {
      final validators = await _wallet.getPlatformValidators();
      _validators.clear();
      _validators.addAll(validators);
    } catch (e) {
      logger.e(e);
    }
  }

  @action
  dispose() {
    _validators.clear();
  }
}

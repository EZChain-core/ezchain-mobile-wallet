import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/common/storage.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/asset/erc20/types.dart';
import 'package:wallet/ezc/wallet/network/network.dart';
import 'package:wallet/features/common/wallet_factory.dart';

part 'token_store.g.dart';

@LazySingleton()
class TokenStore = _TokenStore with _$TokenStore;

abstract class _TokenStore with Store {
  final _wallet = getIt<WalletFactory>().activeWallet;

  String get _key => "${_wallet.getAddressX()}_${activeNetwork.evmChainId}";

  @observable
  List<Erc20TokenData> erc20Tokens = [];

  _TokenStore() {
    getToken();
  }

  Future<bool> addToken(Erc20TokenData token) async {
    try {
      erc20Tokens.add(token);
      String json = jsonEncode(erc20Tokens);
      await storage.write(key: _key, value: json);
      getToken();
      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  getToken() async {
    try {
      final json = await storage.read(key: _key);
      if (json == null || json.isEmpty) return;
      logger.e(json);
      final map = jsonDecode(json) as List<dynamic>;
      final cachedErc20Tokens =
          List<Erc20TokenData>.from(map.map((i) => Erc20TokenData.fromJson(i)));
      final evmAddress = _wallet.getAddressC();
      await Future.wait(
          cachedErc20Tokens.map((erc20) => erc20.getBalance(evmAddress, web3Client)));
      logger.e(cachedErc20Tokens.length);
      cachedErc20Tokens.sort((a, b) => a.balanceBN.compareTo(b.balanceBN));
      erc20Tokens = cachedErc20Tokens;
    } catch (e) {
      logger.e(e);
    }
  }
}

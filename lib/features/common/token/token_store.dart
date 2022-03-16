import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/common/storage.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/asset/erc20/types.dart';
import 'package:wallet/ezc/wallet/network/network.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:collection/collection.dart';
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
      logger.e('vit $_key');
      final json = await storage.read(key: _key);
      if (json == null || json.isEmpty) return;
      final map = jsonDecode(json) as List<dynamic>;
      final cachedErc20Tokens =
          List<Erc20TokenData>.from(map.map((i) => Erc20TokenData.fromJson(i)));
      final evmAddress = _wallet.getAddressC();
      await Future.wait(
          cachedErc20Tokens.map((erc20) => erc20.getBalance(evmAddress, web3Client)));
      cachedErc20Tokens.sort((a, b) => b.balanceBN.compareTo(a.balanceBN));
      logger.e('vit ${cachedErc20Tokens.length}');
      erc20Tokens = cachedErc20Tokens;
    } catch (e) {
      logger.e(e);
    }
  }

  @action
  updateBalance() async {
    try {
      final cachedErc20Tokens = erc20Tokens;
      final evmAddress = _wallet.getAddressC();
      await Future.wait(
          cachedErc20Tokens.map((erc20) => erc20.getBalance(evmAddress, web3Client)));
      cachedErc20Tokens.sort((a, b) => b.balanceBN.compareTo(a.balanceBN));
      erc20Tokens = cachedErc20Tokens;
    } catch (e) {
      logger.e(e);
    }
  }

  Erc20TokenData? find(String id) => erc20Tokens.firstWhereOrNull((element) => element.contractAddress == id);

  clear() {
    erc20Tokens.clear();
  }

}

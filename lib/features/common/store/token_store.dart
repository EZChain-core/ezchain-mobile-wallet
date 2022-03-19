import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/common/storage.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/sdk/apis/avm/constants.dart';
import 'package:wallet/ezc/sdk/apis/avm/utxos.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';
import 'package:wallet/ezc/wallet/asset/erc20/types.dart';
import 'package:wallet/ezc/wallet/asset/types.dart';
import 'package:wallet/ezc/wallet/network/network.dart';
import 'package:wallet/ezc/wallet/network/utils.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:collection/collection.dart';

part 'token_store.g.dart';

@LazySingleton()
class TokenStore = _TokenStore with _$TokenStore;

abstract class _TokenStore with Store {
  final _wallet = getIt<WalletFactory>().activeWallet;

  String get _key => "${_wallet.getAddressX()}_${getEvmChainId()}";

  @readonly
  //ignore: prefer_final_fields
  ObservableList<Erc20TokenData> _erc20Tokens = ObservableList.of([]);

  @readonly
  //ignore: prefer_final_fields
  ObservableList<AvaAsset> _antAssets = ObservableList<AvaAsset>();

  @readonly
  //ignore: prefer_final_fields
  ObservableList<AssetDescriptionClean> _nftAssets =
      ObservableList<AssetDescriptionClean>();

  bool isErc20Exists(String contractAddress) {
    return _erc20Tokens.firstWhereOrNull(
            (element) => element.contractAddress == contractAddress) !=
        null;
  }

  @action
  Future<bool> addErc20Token(Erc20TokenData token) async {
    try {
      _erc20Tokens.add(token);
      String json = jsonEncode(_erc20Tokens);
      await storage.write(key: _key, value: json);
      getErc20Tokens();
      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  @action
  getErc20Tokens() async {
    try {
      final json = await storage.read(key: _key);
      if (json == null || json.isEmpty) return;
      final map = jsonDecode(json) as List<dynamic>;
      final cachedErc20Tokens =
          List<Erc20TokenData>.from(map.map((i) => Erc20TokenData.fromJson(i)));
      final evmAddress = _wallet.getAddressC();
      await Future.wait(cachedErc20Tokens
          .map((erc20) => erc20.getBalance(evmAddress, web3Client)));
      cachedErc20Tokens.sort((a, b) => b.balanceBN.compareTo(a.balanceBN));
      _erc20Tokens.clear();
      _erc20Tokens.insertAll(0, cachedErc20Tokens);
    } catch (e) {
      logger.e(e);
    }
  }

  @action
  updateErc20Balance() async {
    try {
      final cachedErc20Tokens = _erc20Tokens.toList();
      final evmAddress = _wallet.getAddressC();
      await Future.wait(cachedErc20Tokens
          .map((erc20) => erc20.getBalance(evmAddress, web3Client)));
      cachedErc20Tokens.sort((a, b) => b.balanceBN.compareTo(a.balanceBN));
      _erc20Tokens.clear();
      _erc20Tokens.addAll(cachedErc20Tokens);
    } catch (e) {
      logger.e(e);
    }
  }

  Erc20TokenData? findErc20(String id) =>
      _erc20Tokens.firstWhereOrNull((element) => element.contractAddress == id);

  @action
  dispose() {
    _erc20Tokens.clear();
    _antAssets.clear();
    _nftAssets.clear();
  }

  @action
  getAvaAssets() {
    final avaAssetId = getAvaxAssetId();
    final assetUtxoMap = <String, AvmUTXO>{};
    for (final utxo in _wallet.utxosX.utxos.values) {
      assetUtxoMap[cb58Encode(utxo.assetId)] = utxo;
    }
    final unknownAssets = _wallet.getUnknownAssets();

    final antAssets = <AssetDescriptionClean>[];
    final nftAssets = <AssetDescriptionClean>[];

    for (final unknownAsset in unknownAssets) {
      final output = assetUtxoMap[unknownAsset.assetId]?.getOutput();
      if (output == null) {
        continue;
      }
      if (output.getOutputId() == SECPXFEROUTPUTID &&
          unknownAsset.assetId != avaAssetId) {
        antAssets.add(unknownAsset);
      }
      if (output.getOutputId() == NFTMINTOUTPUTID) {
        nftAssets.add(unknownAsset);
      }
    }

    final balanceDict = _wallet.getBalanceX();
    final assets = antAssets.map((asset) {
      final avaAsset = AvaAsset(
        id: asset.assetId,
        name: asset.name,
        symbol: asset.symbol,
        denomination: int.tryParse(asset.denomination) ?? 0,
      );
      avaAsset.resetBalance();

      final balanceAmt = balanceDict[avaAsset.id];
      if (balanceAmt != null) {
        avaAsset.resetBalance();
        avaAsset.addBalance(balanceAmt.unlocked);
        avaAsset.addBalanceLocked(balanceAmt.locked);
      }
      return avaAsset;
    }).toList();

    assets.customSort(avaAssetId);

    _antAssets.clear();
    _antAssets.addAll(assets);

    _nftAssets.clear();
    _nftAssets.addAll(nftAssets);
  }
}

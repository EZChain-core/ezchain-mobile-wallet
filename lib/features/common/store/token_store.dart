import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/common/storage.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/sdk/apis/avm/constants.dart';
import 'package:wallet/ezc/sdk/apis/avm/outputs.dart';
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
  ObservableList<AvaNFTFamily> _nftFamilies = ObservableList<AvaNFTFamily>();

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
    _nftFamilies.clear();
  }

  @action
  getAvaAssets() {
    final avaAssetId = getAvaxAssetId();
    final assetUtxoDict = <String, AvmUTXO>{};

    final nftMintUTXOs = <AvmUTXO>[];
    final nftMintUTXOsDict = <String, List<AvmUTXO>>{};

    final nftUTXOs = <AvmUTXO>[];
    final nftUTXOsDict = <String, List<AvmUTXO>>{};

    final utxos = _wallet.utxosX.utxos.values;

    for (final utxo in utxos) {
      assetUtxoDict[cb58Encode(utxo.assetId)] = utxo;
      final outputId = utxo.output.getOutputId();
      if (outputId == NFTMINTOUTPUTID) {
        nftMintUTXOs.add(utxo);
      }
      if (outputId == NFTXFEROUTPUTID) {
        nftUTXOs.add(utxo);
      }
    }

    final unknownAssets = _wallet.getUnknownAssets();

    final antAssets = <AssetDescriptionClean>[];
    final nftAssets = <AssetDescriptionClean>[];

    for (final unknownAsset in unknownAssets) {
      final output = assetUtxoDict[unknownAsset.assetId]?.getOutput();
      if (output == null) {
        continue;
      }
      final outputId = output.getOutputId();
      if (outputId == SECPXFEROUTPUTID && unknownAsset.assetId != avaAssetId) {
        antAssets.add(unknownAsset);
      }
      if (outputId == NFTMINTOUTPUTID || outputId == NFTXFEROUTPUTID) {
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

    for (final nftUTXO in nftUTXOs) {
      final assetId = cb58Encode(nftUTXO.getAssetId());
      final current = nftUTXOsDict[assetId];
      if (current == null) {
        nftUTXOsDict[assetId] = [nftUTXO];
      } else {
        current.add(nftUTXO);
      }
    }

    for (final nftMintUTXO in nftMintUTXOs) {
      final assetId = cb58Encode(nftMintUTXO.getAssetId());
      final current = nftMintUTXOsDict[assetId];
      if (current == null) {
        nftMintUTXOsDict[assetId] = [nftMintUTXO];
      } else {
        current.add(nftMintUTXO);
      }
    }

    nftMintUTXOsDict.forEach((key, value) {
      value.sort((a, b) {
        final groupIdA = (a.getOutput() as AvmNFTMintOutput).getGroupId();
        final groupIdB = (b.getOutput() as AvmNFTMintOutput).getGroupId();
        return groupIdA.compareTo(groupIdB);
      });
    });

    final nftFamilies = <AvaNFTFamily>[];
    for (final entry in nftMintUTXOsDict.entries) {
      final assetId = entry.key;
      final mintUTXOS = entry.value;
      if (mintUTXOS.isEmpty) {
        continue;
      }
      final firstMintUTXO = mintUTXOS.first;
      final ids = <int>[];
      final nftAsset =
          nftAssets.firstWhereOrNull((element) => element.assetId == assetId);
      if (nftAsset != null) {
        final nftUtxos = nftUTXOsDict[assetId] ?? [];
        final filtered = nftUtxos.where((utxo) {
          final groupId =
              (utxo.getOutput() as AvmNFTTransferOutput).getGroupId();
          if (ids.contains(groupId)) {
            return false;
          } else {
            ids.add(groupId);
            return true;
          }
        }).toList();
        filtered.sort((a, b) {
          final groupIdA = (a.getOutput() as AvmNFTTransferOutput).getGroupId();
          final groupIdB = (b.getOutput() as AvmNFTTransferOutput).getGroupId();
          return groupIdA.compareTo(groupIdB);
        });
        nftFamilies.add(AvaNFTFamily(
          asset: nftAsset,
          nftMintUTXO: firstMintUTXO,
          nftUTXOs: filtered,
        ));
      }
    }

    _nftFamilies.clear();
    _nftFamilies.addAll(nftFamilies);
  }
}

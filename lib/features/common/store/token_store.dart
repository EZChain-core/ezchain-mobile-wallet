import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/ezc/wallet/asset/erc721/types.dart';
import 'package:wallet/features/common/storage/storage.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/sdk/apis/avm/constants.dart';
import 'package:wallet/ezc/sdk/apis/avm/outputs.dart';
import 'package:wallet/ezc/sdk/apis/avm/utxos.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';
import 'package:wallet/ezc/sdk/utils/payload.dart';
import 'package:wallet/ezc/wallet/asset/erc20/types.dart';
import 'package:wallet/ezc/wallet/asset/types.dart';
import 'package:wallet/ezc/wallet/network/network.dart';
import 'package:wallet/ezc/wallet/network/utils.dart';
import 'package:wallet/ezc/wallet/wallet.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:collection/collection.dart';

part 'token_store.g.dart';

@LazySingleton()
class TokenStore = _TokenStore with _$TokenStore;

abstract class _TokenStore with Store {
  final _walletFactory = getIt<WalletFactory>();

  WalletProvider get _wallet => _walletFactory.activeWallet;

  String get _erc20Key =>
      "${_wallet.getAddressC()}_${getEvmChainId()}_ERC20_TOKENS";

  String get _erc721Key =>
      "${_wallet.getAddressC()}_${getEvmChainId()}_ERC721_TOKENS";

  @readonly
  //ignore: prefer_final_fields
  ObservableList<Erc20Token> _erc20Tokens = ObservableList.of([]);

  @readonly
  //ignore: prefer_final_fields
  ObservableList<Erc721Token> _erc721Tokens = ObservableList.of([]);

  @readonly
  //ignore: prefer_final_fields
  ObservableList<AvaAsset> _antAssets = ObservableList<AvaAsset>();

  @readonly
  //ignore: prefer_final_fields
  ObservableList<AvaNFTFamily> _nftFamilies = ObservableList<AvaNFTFamily>();

  @readonly
  //ignore: prefer_final_fields
  ObservableList<AvaNFTCollectible> _nftCollectibles =
      ObservableList<AvaNFTCollectible>();

  Erc20Token? findErc20(String contractAddress) =>
      _erc20Tokens.firstWhereOrNull(
          (element) => element.contractAddress == contractAddress);

  bool isErc20Exists(String contractAddress) {
    return findErc20(contractAddress) != null;
  }

  @action
  Future<bool> addErc20Token(Erc20Token erc20) async {
    try {
      if (isErc20Exists(erc20.contractAddress)) return false;
      final evmAddress = _wallet.getAddressC();
      await erc20.getBalance(evmAddress);
      _erc20Tokens.add(erc20);
      String json = jsonEncode(_erc20Tokens);
      await storage.write(key: _erc20Key, value: json);
      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  @action
  getErc20Tokens() async {
    try {
      final json = await storage.read(key: _erc20Key);
      if (json == null || json.isEmpty) return;
      final map = jsonDecode(json) as List<dynamic>;
      final cachedErc20Tokens =
          List<Erc20Token>.from(map.map((i) => Erc20Token.fromJson(i)));
      final evmAddress = _wallet.getAddressC();
      await Future.wait(
          cachedErc20Tokens.map((erc20) => erc20.getBalance(evmAddress)));
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
      await Future.wait(
          cachedErc20Tokens.map((erc20) => erc20.getBalance(evmAddress)));
      cachedErc20Tokens.sort((a, b) => b.balanceBN.compareTo(a.balanceBN));
      _erc20Tokens.clear();
      _erc20Tokens.addAll(cachedErc20Tokens);
    } catch (e) {
      logger.e(e);
    }
  }

  Erc721Token? findErc721(String contractAddress) =>
      _erc721Tokens.firstWhereOrNull(
          (element) => element.contractAddress == contractAddress);

  bool isErc721Exists(String contractAddress) {
    return findErc721(contractAddress) != null;
  }

  @action
  Future<bool> addErc721Token(Erc721Token erc721) async {
    try {
      if (isErc721Exists(erc721.contractAddress)) return false;
      await erc721.canSupport();
      final address = _wallet.getAddressC();
      final tokenIds = await erc721.getTokensIds(address);
      await Future.wait(
          tokenIds.map((tokenId) => erc721.getTokenURIMetadata(tokenId)));
      _erc721Tokens.add(erc721);
      String json = jsonEncode(_erc721Tokens);
      await storage.write(key: _erc721Key, value: json);
      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  @action
  getErc721Tokens() async {
    try {
      final json = await storage.read(key: _erc721Key);
      if (json == null || json.isEmpty) return;
      final map = jsonDecode(json) as List<dynamic>;
      final cachedErc721Tokens =
          List<Erc721Token>.from(map.map((i) => Erc721Token.fromJson(i)));

      await Future.wait(cachedErc721Tokens.map((token) => token.canSupport()));

      final evmAddress = _wallet.getAddressC();

      await Future.wait(cachedErc721Tokens
          .map((token) => token.getAllTokenURIMetadata(evmAddress)));

      _erc721Tokens.clear();
      _erc721Tokens.insertAll(0, cachedErc721Tokens);
    } catch (e) {
      logger.e(e);
    }
  }

  @action
  removeErc721Token(String contractAddress, BigInt tokenId) {
    final erc721 = findErc721(contractAddress);
    erc721?.removeTokenId(tokenId);
  }

  @action
  dispose() {
    _erc20Tokens.clear();
    _erc721Tokens.clear();
    _antAssets.clear();
    _nftFamilies.clear();
  }

  @action
  getAvaAssets() {
    final avaAssetId = getAvaxAssetId();
    final antAssetIds = <String>{};

    final nftMintUTXOs = <AvmUTXO>[];
    final nftMintUTXOsDict = <String, List<AvmUTXO>>{};

    final nftUTXOs = <AvmUTXO>[];
    final nftUTXOsDict = <String, List<AvmUTXO>>{};

    final utxos = _wallet.utxosX.utxos.values;

    for (final utxo in utxos) {
      final outputId = utxo.output.getOutputId();
      if (outputId == SECPXFEROUTPUTID) {
        final assetId = cb58Encode(utxo.assetId);
        if (assetId != avaAssetId) {
          antAssetIds.add(assetId);
        }
      }
      if (outputId == NFTMINTOUTPUTID) {
        nftMintUTXOs.add(utxo);
      }
      if (outputId == NFTXFEROUTPUTID) {
        nftUTXOs.add(utxo);
      }
    }

    for (final nftUTXO in nftUTXOs) {
      final assetId = cb58Encode(nftUTXO.getAssetId());
      final current = nftUTXOsDict[assetId];
      if (current == null) {
        nftUTXOsDict[assetId] = [nftUTXO];
      } else {
        current.add(nftUTXO);
      }
    }

    nftUTXOsDict.forEach((key, value) {
      value.sort((a, b) {
        final groupIdA = (a.getOutput() as AvmNFTTransferOutput).getGroupId();
        final groupIdB = (b.getOutput() as AvmNFTTransferOutput).getGroupId();
        return groupIdA.compareTo(groupIdB);
      });
    });

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

    final unknownAssets = _wallet.getUnknownAssets();

    final nftFamilies = <AvaNFTFamily>[];
    final nftCollectibles = <AvaNFTCollectible>[];
    final antAssets = <AssetDescriptionClean>[];

    for (final asset in unknownAssets) {
      final assetId = asset.assetId;
      if (antAssetIds.contains(assetId)) {
        antAssets.add(asset);
      } else {
        final nftMintUTXOs = nftMintUTXOsDict[assetId] ?? [];
        final nftUTXOs = nftUTXOsDict[assetId] ?? [];

        final filteredNftUTXOs = <AvmUTXO>[];
        final nftUTXOGroupQuantityDict = <int, int>{};
        final nftUTXOGroupIds = <int>{};

        for (final nftUTXO in nftUTXOs) {
          final groupId =
              (nftUTXO.getOutput() as AvmNFTTransferOutput).getGroupId();
          if (nftUTXOGroupIds.add(groupId)) {
            filteredNftUTXOs.add(nftUTXO);
            nftUTXOGroupQuantityDict[groupId] = 1;
          } else {
            nftUTXOGroupQuantityDict[groupId] =
                nftUTXOGroupQuantityDict[groupId]! + 1;
          }
        }

        final groupIdPayloadDict = <int, PayloadBase>{};

        for (final utxo in filteredNftUTXOs) {
          try {
            final output = utxo.getOutput() as AvmNFTTransferOutput;
            var payloadBuff = output.getPayloadBuffer();
            final typeId = PayloadTypes.instance.getTypeId(payloadBuff);
            final content = PayloadTypes.instance.getContent(payloadBuff);
            groupIdPayloadDict[output.getGroupId()] =
                PayloadTypes.instance.select(typeId, content);
          } catch (e) {
            logger.e(e);
          }
        }

        if (assetId != avaAssetId) {
          if (nftMintUTXOs.isNotEmpty) {
            nftFamilies.add(AvaNFTFamily(
              asset: asset,
              nftMintUTXO: nftMintUTXOs.first,
              nftUTXOs: filteredNftUTXOs,
              groupIdPayloadDict: groupIdPayloadDict,
            ));
          }

          nftCollectibles.add(AvaNFTCollectible(
            asset: asset,
            nftUTXOs: filteredNftUTXOs,
            nftMintUTXO: nftMintUTXOs.firstOrNull,
            groupIdPayloadDict: groupIdPayloadDict,
            groupIdQuantityDict: nftUTXOGroupQuantityDict,
          ));
        }
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
        avaAsset.addBalance(balanceAmt.unlocked);
        avaAsset.addBalanceLocked(balanceAmt.locked);
      }
      return avaAsset;
    }).toList()
      ..customSort(avaAssetId);

    _antAssets.clear();
    _antAssets.addAll(assets);

    _nftCollectibles.clear();
    _nftCollectibles.addAll(nftCollectibles);

    _nftFamilies.clear();
    _nftFamilies.addAll(nftFamilies);
  }
}

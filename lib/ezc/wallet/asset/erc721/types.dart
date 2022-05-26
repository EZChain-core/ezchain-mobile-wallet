import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/common/dio_logger.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/ezc/wallet/asset/erc721/erc721.dart';
import 'package:wallet/ezc/wallet/network/network.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

part 'types.g.dart';

@JsonSerializable()
class Erc721TokenData {
  static const erc721MetadataId = '0x5b5e139f';
  static const erc721EnumerableId = '0x780e9d63';

  int evmChainId;
  String contractAddress;
  String name;
  String symbol;

  @JsonKey(ignore: true)
  final ERC721 erc721;

  @JsonKey(ignore: true)
  bool? _canSupport;

  @JsonKey(ignore: true)
  final cachedURIs = <BigInt, String>{};

  @JsonKey(ignore: true)
  final cachedMetadata = <BigInt, String>{};

  Erc721TokenData({
    required this.evmChainId,
    required this.contractAddress,
    required this.name,
    required this.symbol,
    ERC721? erc721,
  }) : erc721 = erc721 ??
            ERC721(
              address: EthereumAddress.fromHex(contractAddress),
              client: web3Client,
              chainId: getEvmChainId(),
            );

  @override
  String toString() {
    return "evmChainId = $evmChainId, contractAddress = $contractAddress, name = $name, symbol = $symbol, cachedMetadata = ${cachedMetadata.values.toString()}";
  }

  canSupport() async {
    if (_canSupport != null) return _canSupport;
    try {
      final metadata =
          await erc721.supportsInterface(hexToBytes(erc721MetadataId));
      final enumerable =
          await erc721.supportsInterface(hexToBytes(erc721EnumerableId));
      _canSupport = metadata && enumerable;
    } catch (e) {
      _canSupport = false;
      logger.e(e);
    }
    return _canSupport;
  }

  Future<int> getBalance(String address) async {
    try {
      final balance = await erc721.balanceOf(EthereumAddress.fromHex(address));
      return balance.toInt();
    } catch (e) {
      logger.e(e);
      return 0;
    }
  }

  Future<List<BigInt>> getAllTokensIds(String address) async {
    if (!(await canSupport())) return [];
    final balance = await getBalance(address);
    final tokenIds = <BigInt>[];
    for (var i = 0; i < balance.toInt(); i++) {
      final tokenId = await erc721.tokenOfOwnerByIndex(
        EthereumAddress.fromHex(address),
        BigInt.from(i),
      );
      tokenIds.add(tokenId);
    }
    return tokenIds;
  }

  Future<List<String>> getAllTokenData(String address) async {
    final tokenIds = await getAllTokensIds(address);
    final uris = <String>[];
    for (final tokenId in tokenIds) {
      final data = await erc721.tokenURI(tokenId);
      uris.add(data);
    }
    return uris;
  }

  Future<String> getTokenURI(BigInt tokenId) async {
    final cachedURI = cachedURIs[tokenId];
    if (cachedURI != null) return cachedURI;
    final remoteURI = await erc721.tokenURI(tokenId);
    cachedURIs[tokenId] = remoteURI;
    return remoteURI;
  }

  Future<String> getTokenURIData(BigInt tokenId) async {
    final cachedData = cachedMetadata[tokenId];
    if (cachedData != null) return cachedData;
    final uriString = await getTokenURI(tokenId);
    dynamic data;
    try {
      final uri = Uri.tryParse(uriString);
      if (uri != null && uri.hasAbsolutePath) {
        final dio = Dio()..interceptors.add(prettyDioLogger);
        final response = (await dio.get(uriString)).data;
        if (response is Map<String, dynamic>) {
          data = response["image"] ?? response["img"] ?? uriString;
        } else {
          data = uriString;
        }
      } else {
        data = uriString;
      }
    } catch (e) {
      logger.e(e, uriString);
      data = uriString;
    }
    cachedMetadata[tokenId] = data;
    return data;
  }

  removeTokenId(BigInt tokenId) {
    cachedURIs.remove(tokenId);
    cachedMetadata.remove(tokenId);
  }

  static Future<Erc721TokenData?> getData(
    String contractAddress,
    Web3Client client,
    int evmChainId,
  ) async {
    try {
      final erc721 = ERC721(
        address: EthereumAddress.fromHex(contractAddress),
        client: client,
        chainId: evmChainId,
      );
      final name = await erc721.name();
      final symbol = await erc721.symbol();
      return Erc721TokenData(
        evmChainId: evmChainId,
        contractAddress: contractAddress,
        name: name,
        symbol: symbol,
        erc721: erc721,
      );
    } catch (e) {
      return null;
    }
  }

  factory Erc721TokenData.fromJson(Map<String, dynamic> json) =>
      _$Erc721TokenDataFromJson(json);

  Map<String, dynamic> toJson() => _$Erc721TokenDataToJson(this);
}

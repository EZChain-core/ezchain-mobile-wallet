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
class Erc721Token {
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
  final cachedMetadata = <BigInt, Erc721TokenMetadata>{};

  Erc721Token({
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

  Future<List<BigInt>> getTokensIds(String address) async {
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

  Future<String> getTokenURI(BigInt tokenId) async {
    final cachedURI = cachedURIs[tokenId];
    if (cachedURI != null) return cachedURI;
    final remoteURI = await erc721.tokenURI(tokenId);
    cachedURIs[tokenId] = remoteURI;
    return remoteURI;
  }

  Future<List<String>> getTokenURIs(String address) async {
    final tokenIds = await getTokensIds(address);
    return await Future.wait(tokenIds.map((tokenId) => getTokenURI(tokenId)));
  }

  Future<Erc721TokenMetadata> getTokenURIMetadata(BigInt tokenId) async {
    final cachedData = cachedMetadata[tokenId];
    if (cachedData != null) return cachedData;
    final uriString = await getTokenURI(tokenId);
    Erc721TokenMetadata data;
    try {
      final uri = Uri.tryParse(uriString);
      if (uri != null && uri.hasAbsolutePath) {
        final dio = Dio()..interceptors.add(prettyDioLogger);
        final response = (await dio.get(uriString)).data;
        if (response is Map<String, dynamic>) {
          final url = response["image"] ?? response["img"] ?? uriString;
          data = Erc721TokenMetadata(
            uri: url,
            name: response["name"],
            description: response["description"],
          );
        } else {
          data = Erc721TokenMetadata(uri: uriString);
        }
      } else {
        data = Erc721TokenMetadata(uri: uriString);
      }
    } catch (e) {
      logger.e(e, uriString);
      data = Erc721TokenMetadata(uri: uriString);
    }
    cachedMetadata[tokenId] = data;
    return data;
  }

  Future<List<Erc721TokenMetadata>> getAllTokenURIMetadata(
    String address,
  ) async {
    final tokenIds = await getTokensIds(address);
    return await Future.wait(
        tokenIds.map((tokenId) => getTokenURIMetadata(tokenId)));
  }

  removeTokenId(BigInt tokenId) {
    cachedURIs.remove(tokenId);
    cachedMetadata.remove(tokenId);
  }

  static Future<Erc721Token?> getData(
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
      return Erc721Token(
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

  factory Erc721Token.fromJson(Map<String, dynamic> json) =>
      _$Erc721TokenFromJson(json);

  Map<String, dynamic> toJson() => _$Erc721TokenToJson(this);
}

class Erc721TokenMetadata {
  String uri;
  String? name;
  String? description;

  Erc721TokenMetadata({required this.uri, this.name, this.description});

  @override
  String toString() {
    return "uri = $uri, name = $name, description = $description";
  }
}

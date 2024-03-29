import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/ezc/wallet/asset/erc20/erc20.dart';
import 'package:wallet/ezc/wallet/network/network.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:web3dart/web3dart.dart';

part 'types.g.dart';

@JsonSerializable()
class Erc20Token {
  int evmChainId;
  String contractAddress;
  String name;
  String symbol;
  int decimals;

  @JsonKey(ignore: true)
  final ERC20 erc20;

  @JsonKey(ignore: true)
  BigInt balanceBN = BigInt.zero;

  Erc20Token({
    required this.evmChainId,
    required this.contractAddress,
    required this.name,
    required this.symbol,
    required this.decimals,
    ERC20? erc20,
  }) : erc20 = erc20 ??
            ERC20(
              address: EthereumAddress.fromHex(contractAddress),
              client: web3Client,
              chainId: evmChainId,
            );

  String get balance => balanceBN.toLocaleString(denomination: decimals);

  @override
  String toString() {
    return "evmChainId = $evmChainId, contractAddress = $contractAddress, name = $name, symbol = $symbol, decimals = $decimals, balance = $balance";
  }

  Future<BigInt> getBalance(String address) async {
    try {
      balanceBN = await erc20.balanceOf(EthereumAddress.fromHex(address));
    } catch (e) {
      balanceBN = BigInt.zero;
    }
    return balanceBN;
  }

  static Future<Erc20Token?> getData(
    String contractAddress,
    Web3Client client,
    int evmChainId,
  ) async {
    try {
      final erc20 = ERC20(
        address: EthereumAddress.fromHex(contractAddress),
        client: client,
        chainId: evmChainId,
      );
      final name = await erc20.name();
      final symbol = await erc20.symbol();
      final decimals = await erc20.decimals();
      return Erc20Token(
        evmChainId: evmChainId,
        contractAddress: contractAddress,
        name: name,
        symbol: symbol,
        decimals: decimals.toInt(),
        erc20: erc20,
      );
    } catch (e) {
      return null;
    }
  }

  factory Erc20Token.fromJson(Map<String, dynamic> json) =>
      _$Erc20TokenFromJson(json);

  Map<String, dynamic> toJson() => _$Erc20TokenToJson(this);
}

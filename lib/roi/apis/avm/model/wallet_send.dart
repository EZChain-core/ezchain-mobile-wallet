import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/common/rpc/rpc_request_wrapper.dart';

part 'wallet_send.g.dart';

@JsonSerializable()
class WalletSendRequest with RpcRequestWrapper<WalletSendRequest> {
  @JsonKey(name: "assetID")
  final String assetId;

  final int amount;

  final String to;

  final String memo;

  final List<String> from;

  @JsonKey(name: "changeAddr")
  final String changeAddress;

  final String username;

  final String password;

  const WalletSendRequest(
      {required this.assetId,
      required this.amount,
      required this.to,
      required this.memo,
      required this.from,
      required this.changeAddress,
      required this.username,
      required this.password});

  @override
  String method() {
    return "wallet.send";
  }

  factory WalletSendRequest.fromJson(Map<String, dynamic> json) =>
      _$WalletSendRequestFromJson(json);

  Map<String, dynamic> toJson() => _$WalletSendRequestToJson(this);
}

@JsonSerializable()
class WalletSendResponse {
  @JsonKey(name: "txID")
  final String txId;

  @JsonKey(name: "changeAddr")
  final String changeAddress;

  const WalletSendResponse({required this.txId, required this.changeAddress});

  factory WalletSendResponse.fromJson(Map<String, dynamic> json) =>
      _$WalletSendResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WalletSendResponseToJson(this);
}

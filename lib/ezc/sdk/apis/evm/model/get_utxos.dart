import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/ezc/sdk/apis/evm/utxos.dart';
import 'package:wallet/ezc/sdk/common/rpc/rpc_request_wrapper.dart';

part 'get_utxos.g.dart';

@JsonSerializable()
class GetUTXOsRequest with RpcRequestWrapper<GetUTXOsRequest> {
  final List<String> addresses;
  final int? limit;
  final GetUTXOsStartIndex? startIndex;
  final String? sourceChain;
  final String encoding;

  GetUTXOsRequest(
      {required this.addresses,
      this.limit,
      this.startIndex,
      this.sourceChain,
      this.encoding = "cb58"});

  @override
  String method() {
    return "ezc.getUTXOs";
  }

  factory GetUTXOsRequest.fromJson(Map<String, dynamic> json) =>
      _$GetUTXOsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetUTXOsRequestToJson(this);
}

@JsonSerializable()
class GetUTXOsStartIndex {
  final String address;
  final String utxo;

  GetUTXOsStartIndex(this.address, this.utxo);

  factory GetUTXOsStartIndex.fromJson(Map<String, dynamic> json) =>
      _$GetUTXOsStartIndexFromJson(json);

  Map<String, dynamic> toJson() => _$GetUTXOsStartIndexToJson(this);
}

@JsonSerializable()
class GetUTXOsResponse {
  final String numFetched;
  final List<String> utxos;
  final GetUTXOsEndIndex endIndex;
  final String? sourceChain;
  final String encoding;

  GetUTXOsResponse(
      {required this.numFetched,
      required this.utxos,
      required this.endIndex,
      this.sourceChain,
      required this.encoding});

  EvmUTXOSet getUTXOs() {
    return EvmUTXOSet()..addArray(utxos, overwrite: false);
  }

  factory GetUTXOsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUTXOsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetUTXOsResponseToJson(this);
}

@JsonSerializable()
class GetUTXOsEndIndex {
  final String address;
  final String utxo;

  GetUTXOsEndIndex(this.address, this.utxo);

  factory GetUTXOsEndIndex.fromJson(Map<String, dynamic> json) =>
      _$GetUTXOsEndIndexFromJson(json);

  Map<String, dynamic> toJson() => _$GetUTXOsEndIndexToJson(this);
}

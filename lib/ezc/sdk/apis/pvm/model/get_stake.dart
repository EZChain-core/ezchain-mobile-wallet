import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/ezc/sdk/apis/pvm/outputs.dart';
import 'package:wallet/ezc/sdk/common/rpc/rpc_request_wrapper.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';

part 'get_stake.g.dart';

@JsonSerializable()
class GetStakeRequest with RpcRequestWrapper<GetStakeRequest> {
  final List<String> addresses;
  final String encoding;

  GetStakeRequest({required this.addresses, this.encoding = "cb58"});

  @override
  String method() {
    return "platform.getStake";
  }

  factory GetStakeRequest.fromJson(Map<String, dynamic> json) =>
      _$GetStakeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetStakeRequestToJson(this);
}

@JsonSerializable()
class GetStakeResponse {
  final String staked;
  final List<String> stakedOutputs;

  BigInt get stakedBN => BigInt.tryParse(staked) ?? BigInt.zero;

  GetStakeResponse({required this.staked, required this.stakedOutputs});

  List<PvmTransferableOutput> get stakedTransferableOutputs =>
      stakedOutputs.map((stakedOutput) {
        return PvmTransferableOutput()
          ..fromBuffer(cb58Decode(stakedOutput), offset: 2);
      }).toList();

  factory GetStakeResponse.fromJson(Map<String, dynamic> json) =>
      _$GetStakeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetStakeResponseToJson(this);
}

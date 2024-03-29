import 'package:wallet/ezc/sdk/common/rpc/rpc_request.dart';

abstract class RpcRequestWrapper<T> {
  String method();

  RpcRequest<T> toRpc() {
    return RpcRequest(
      method: method(),
      params: this as T,
    );
  }
}

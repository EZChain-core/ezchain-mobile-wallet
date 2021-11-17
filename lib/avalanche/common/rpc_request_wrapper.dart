import 'package:wallet/avalanche/common/rpc_request.dart';

abstract class RpcRequestWrapper<T> {
  String method();

  RpcRequest<T> createRpcRequest(int id) {
    return RpcRequest(
      method: method(),
      params: this as T,
      id: id,
    );
  }
}

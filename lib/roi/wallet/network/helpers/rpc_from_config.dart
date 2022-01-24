import 'package:wallet/roi/wallet/network/types.dart';

String getRpcC(NetworkConfig conf) {
  return "${conf.apiProtocol}://${conf.apiIp}:${conf.apiPort}/ext/bc/C/rpc";
}

String getRpcX(NetworkConfig conf) {
  return "${conf.apiProtocol}://${conf.apiIp}:${conf.apiPort}/ext/bc/X";
}

String getRpcP(NetworkConfig conf) {
  return "${conf.apiProtocol}://${conf.apiIp}:${conf.apiPort}/ext/bc/P";
}

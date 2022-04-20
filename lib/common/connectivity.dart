import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:wallet/features/common/ext/extensions.dart';
import 'package:wallet/generated/l10n.dart';

Future<bool> hasInternetConnection() async {
  final connectivityResult = await (Connectivity().checkConnectivity());
  return connectivityResult != ConnectivityResult.none;
}

showInternetConnectionConnectedSnackBar() {
  showSnackBar(Strings.current.internet_connection_connected);
}

showInternetConnectionDisconnectedSnackBar() {
  showSnackBar(Strings.current.internet_connection_disconnected);
}

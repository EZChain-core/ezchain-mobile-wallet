import 'package:wallet/roi/wallet/utils/constants.dart';

String getAccountPathAvalanche(int accountIndex) {
  return "$AVAX_TOKEN_PATH/$accountIndex";
}

String getAccountPathEVM(int accountIndex) {
  return "$ETH_ACCOUNT_PATH/0/$accountIndex";
}

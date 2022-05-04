import 'package:wallet/ezc/wallet/utils/constants.dart';

/// Given an account number, returns the Avalanche account derivation path as a string
/// @param accountIndex
String getAccountPathAvalanche(int accountIndex) {
  if (accountIndex < 0) {
    throw Exception("Account index can not be less than 0.");
  }
  return "$AVAX_TOKEN_PATH/$accountIndex'";
}

/// Returns the string `m/44'/60'/0'/0/n` where `n` is the account index.
/// @param accountIndex
String getAccountPathEVM(int accountIndex) {
  if (accountIndex < 0) {
    throw Exception("Account index can not be less than 0.");
  }
  return "$ETH_ACCOUNT_PATH/0/$accountIndex";
}

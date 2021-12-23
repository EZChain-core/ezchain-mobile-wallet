import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:web3dart/credentials.dart';

bool validateAddress(String address) {
  return validateAddressX(address) ||
      validateAddressP(address) ||
      validateAddressEvm(address);
}

bool validateAddressX(String address) {
  try {
    final buff = parseAddress(address, "X");
    return buff.isNotEmpty;
  } catch (e) {
    return false;
  }
}

bool validateAddressP(String address) {
  try {
    final buff = parseAddress(address, "X");
    return buff.isNotEmpty;
  } catch (e) {
    return false;
  }
}

bool validateAddressEvm(String address) {
  try {
    EthereumAddress.fromHex(address);
    return true;
  } catch (e) {
    return false;
  }
}

String getAddressHrp(String address) {
  if (!validateAddress(address)) {
    throw Exception("Invalid X or P address.");
  }
  return address.split("-")[1].split("1")[0];
}

String getAddressChain(String address) {
  if (!validateAddress(address)) {
    throw Exception("Invalid address.");
  }
  if (validateAddressEvm(address)) {
    return "C";
  } else {
    return address[0];
  }
}

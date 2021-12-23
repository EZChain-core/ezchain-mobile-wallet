import 'package:wallet/roi/wallet/network/network.dart';

BigInt getTxFeeX() {
  return xChain.getTxFee();
}

BigInt getTxFeeP() {
  return pChain.getTxFee();
}

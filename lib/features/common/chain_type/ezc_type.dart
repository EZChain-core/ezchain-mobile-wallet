enum EZCType { xChain, pChain, cChain }

extension EZCTypeExtension on EZCType {
  String get name {
    return ["X-Chain", "P-Chain", "C-chain"][index];
  }
}

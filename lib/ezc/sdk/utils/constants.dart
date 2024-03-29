const protocols = ["http", "https"];

const privateKeyPrefix = "PrivateKey-";
const evmPrivateKeyPrefix = "0x";
const nodeIdPrefix = "NodeID-";
const primaryAssetAlias = "EZC";
const mainnetAPI = "api.avax.network";
const fujiAPI = "api.avax-test.network";

const networkIdToHRP = {
  0: "custom",
  1: "ezc",
  2: "cascade",
  3: "denali",
  4: "everest",
  5: "fuji",
  12345: "local"
};

const hrpToNetworkId = {
  "custom": 0,
  "ezc": 1,
  "cascade": 2,
  "denali": 3,
  "everest": 4,
  "fuji": 5,
  "local": 12345
};

const fallbackHRP = "custom";
const fallbackNetworkName = "Custom Network";
const fallbackEVMChainId = 43112;

const defaultNetworkId = 1;

const platformChainId = "11111111111111111111111111111111LpoYY";
const primaryNetworkId = "11111111111111111111111111111111LpoYY";
const xChainAlias = "X";
const cChainAlias = "C";
const pChainAlias = "P";
const xChainVMName = "avm";
const cChainVMName = "evm";
const pChainVMName = "platformvm";

// DO NOT use the following private keys and/or mnemonic on Fuji or Testnet
// This address/account is for testing on the local avash network
const defaultLocalGenesisPrivateKey =
    "ewoqjP7PxY4yr3iLTpLisriqt94hdyDFNgchSxGGztUrTXtNN";
const defaultEVMLocalGenesisPrivateKey =
    "0x56289e99c94b6912bfc12adc093c9b51124f0dc54ac7a766b2bc5ccf558d8027";
const defaultEVMLocalGenesisAddress =
    "0x8db97C7cEcE249c2b98bDC0226Cc4C2A57BF52FC";
const mnemonic =
    "output tooth keep tooth bracket fox city sustain blood raise install pond stem reject long scene clap gloom purpose mean music piece unknown light";

//ignore: non_constant_identifier_names
final ONEAVAX = BigInt.from(1000000000);

//ignore: non_constant_identifier_names
final DECIAVAX = ONEAVAX ~/ BigInt.from(10);

//ignore: non_constant_identifier_names
final CENTIAVAX = ONEAVAX ~/ BigInt.from(100);

//ignore: non_constant_identifier_names
final MILLIAVAX = ONEAVAX ~/ BigInt.from(1000);

//ignore: non_constant_identifier_names
final MICROAVAX = ONEAVAX ~/ BigInt.from(1000000);

//ignore: non_constant_identifier_names
final NANOAVAX = ONEAVAX ~/ BigInt.from(1000000000);

//ignore: non_constant_identifier_names
final WEI = BigInt.from(1);

//ignore: non_constant_identifier_names
final GWEI = WEI * BigInt.from(1000000000);

//ignore: non_constant_identifier_names
final AVAXGWEI = NANOAVAX;

//ignore: non_constant_identifier_names
final AVAXSTAKECAP = ONEAVAX * BigInt.from(3000000);

// Start Manhattan
final n0X = X(
    blockchainId: "2vrXWHgGxh5n3YsLHMV16YVVJTpT4z45Fmb4y3bL6si8kLCyg9",
    avaxAssetId: "",
    alias: xChainAlias,
    vm: xChainVMName,
    fee: MILLIAVAX,
    creationTxFee: CENTIAVAX);

final n0P = P(
    blockchainId: platformChainId,
    alias: pChainAlias,
    vm: pChainVMName,
    fee: MILLIAVAX,
    creationTxFee: CENTIAVAX,
    minConsumption: 0.1,
    maxConsumption: 0.12,
    maxStakingDuration: BigInt.from(31536000),
    maxSupply: BigInt.from(720000000) * ONEAVAX,
    minStake: ONEAVAX * BigInt.from(2000),
    minStakeDuration: 2 * 7 * 24 * 60 * 60,
    //two weeks
    maxStakeDuration: 365 * 24 * 60 * 60,
    // one year
    minDelegationStake: ONEAVAX * BigInt.from(25),
    minDelegationFee: BigInt.from(2));

final n0C = C(
    blockchainId: "2fFZQibQXcd6LTE4rpBPBAkLVXFE91Kit8pgxaBG1mRnh5xqbb",
    alias: cChainAlias,
    vm: cChainVMName,
    fee: MILLIAVAX,
    gasPrice: GWEI * BigInt.from(470),
    //equivalent to gas price
    chainId: 43111);
// End Manhattan

// Start mainnet
const _avaxAssetId = "2rdddfp8Q8dPd1vLszNBYr4guX1Gs8so9aBkS3bqxL39qKzD39";

final n1X = X(
    blockchainId: "27zYmr1rRJqf9BFG8nYZYxeRdn1mXYwqkNVp4oSDg1ZtCZQTGi",
    avaxAssetId: _avaxAssetId,
    alias: xChainAlias,
    vm: xChainVMName,
    txFee: MILLIAVAX,
    creationTxFee: CENTIAVAX);

final n1P = P(
    blockchainId: platformChainId,
    avaxAssetId: _avaxAssetId,
    alias: pChainAlias,
    vm: pChainVMName,
    txFee: MILLIAVAX,
    creationTxFee: CENTIAVAX,
    minConsumption: 0.1,
    maxConsumption: 0.12,
    maxStakingDuration: BigInt.from(31536000),
    maxSupply: BigInt.from(720000000) * ONEAVAX,
    minStake: ONEAVAX * BigInt.from(2000),
    minStakeDuration: 2 * 7 * 24 * 60 * 60,
    //two weeks
    maxStakeDuration: 365 * 24 * 60 * 60,
    // one year
    minDelegationStake: ONEAVAX * BigInt.from(25),
    minDelegationFee: BigInt.from(2));

final n1C = C(
    blockchainId: "ApQXdDnBUBnDLMigPkSk79jkBXKdjNaEhQuGW37URtBkJRfjq",
    alias: cChainAlias,
    vm: cChainVMName,
    txBytesGas: 1,
    costPerSignature: 1000,
    txFee: MILLIAVAX,
    gasPrice: GWEI * BigInt.from(225),
    minGasPrice: GWEI * BigInt.from(25),
    maxGasPrice: GWEI * BigInt.from(1000),
    chainId: 0xa34);
// End Mainnet

// Start Cascade
final n2X = X(
    blockchainId: "4ktRjsAKxgMr2aEzv9SWmrU7Xk5FniHUrVCX4P1TZSfTLZWFM",
    avaxAssetId: "",
    alias: xChainAlias,
    vm: xChainVMName,
    txFee: BigInt.zero,
    creationTxFee: BigInt.zero);

final n2P = P(
    blockchainId: platformChainId,
    alias: pChainAlias,
    vm: pChainVMName,
    txFee: BigInt.zero,
    creationTxFee: BigInt.zero,
    minConsumption: 0.1,
    maxConsumption: 0.12,
    maxStakingDuration: BigInt.from(31536000),
    maxSupply: BigInt.from(720000000) * ONEAVAX,
    minStake: ONEAVAX * BigInt.from(2000),
    minStakeDuration: 2 * 7 * 24 * 60 * 60,
    //two weeks
    maxStakeDuration: 365 * 24 * 60 * 60,
    // one year
    minDelegationStake: ONEAVAX * BigInt.from(25),
    minDelegationFee: BigInt.from(2));

final n2C = C(
    blockchainId: "2mUYSXfLrDtigwbzj1LxKVsHwELghc5sisoXrzJwLqAAQHF4i",
    alias: cChainAlias,
    vm: cChainVMName,
    gasPrice: BigInt.zero,
    chainId: 0);
// End Cascade

// Start Denali
final n3X = X(
    blockchainId: "rrEWX7gc7D9mwcdrdBxBTdqh1a7WDVsMuadhTZgyXfFcRz45L",
    avaxAssetId: "",
    alias: xChainAlias,
    vm: xChainVMName,
    txFee: BigInt.zero,
    creationTxFee: BigInt.zero);

final n3P = P(
    blockchainId: "",
    alias: pChainAlias,
    vm: pChainVMName,
    txFee: BigInt.zero,
    creationTxFee: BigInt.zero,
    minConsumption: 0.1,
    maxConsumption: 0.12,
    maxStakingDuration: BigInt.from(31536000),
    maxSupply: BigInt.from(720000000) * ONEAVAX,
    minStake: ONEAVAX * BigInt.from(2000),
    minStakeDuration: 2 * 7 * 24 * 60 * 60,
    //two weeks
    maxStakeDuration: 365 * 24 * 60 * 60,
    // one year
    minDelegationStake: ONEAVAX * BigInt.from(25),
    minDelegationFee: BigInt.from(2));

final n3C = C(
    blockchainId: "zJytnh96Pc8rM337bBrtMvJDbEdDNjcXG3WkTNCiLp18ergm9",
    alias: cChainAlias,
    vm: cChainVMName,
    gasPrice: BigInt.zero,
    chainId: 0);
// End Denali

// Start Everest
final n4X = X(
    blockchainId: "jnUjZSRt16TcRnZzmh5aMhavwVHz3zBrSN8GfFMTQkzUnoBxC",
    avaxAssetId: "",
    alias: xChainAlias,
    vm: xChainVMName,
    txFee: MILLIAVAX,
    creationTxFee: CENTIAVAX);

final n4P = P(
    blockchainId: platformChainId,
    alias: pChainAlias,
    vm: pChainVMName,
    txFee: MILLIAVAX,
    creationTxFee: CENTIAVAX,
    minConsumption: 0.1,
    maxConsumption: 0.12,
    maxStakingDuration: BigInt.from(31536000),
    maxSupply: BigInt.from(720000000) * ONEAVAX,
    minStake: ONEAVAX * BigInt.from(2000),
    minStakeDuration: 2 * 7 * 24 * 60 * 60,
    //two weeks
    maxStakeDuration: 365 * 24 * 60 * 60,
    // one year
    minDelegationStake: ONEAVAX * BigInt.from(25),
    minDelegationFee: BigInt.from(2));

final n4C = C(
    blockchainId: "saMG5YgNsFxzjz4NMkEkt3bAH6hVxWdZkWcEnGB3Z15pcAmsK",
    alias: cChainAlias,
    vm: cChainVMName,
    gasPrice: GWEI * BigInt.from(470),
    chainId: 43110);
// End Everest

// Start Fuji
final n5X = X(
    blockchainId: "2bUiRRqUr9ZkDAVehjeaM4J8PsW52X2EbuGW1K5e56KZcT6yi7",
    avaxAssetId: "2hnSEtkBGTb11GJUmeoWUXPC7zSaBG818c1GZc3WtCpbqZQS11",
    alias: xChainAlias,
    vm: xChainVMName,
    txFee: MILLIAVAX,
    creationTxFee: CENTIAVAX);

final n5P = P(
    blockchainId: "11111111111111111111111111111111LpoYY",
    avaxAssetId: "2hnSEtkBGTb11GJUmeoWUXPC7zSaBG818c1GZc3WtCpbqZQS11",
    alias: pChainAlias,
    vm: pChainVMName,
    txFee: MILLIAVAX,
    creationTxFee: CENTIAVAX,
    minConsumption: 0.1,
    maxConsumption: 0.12,
    maxStakingDuration: BigInt.from(31536000),
    maxSupply: BigInt.from(720000000) * ONEAVAX,
    minStake: ONEAVAX,
    minStakeDuration: 24 * 60 * 60,
    //one day
    maxStakeDuration: 365 * 24 * 60 * 60,
    // one year
    minDelegationStake: ONEAVAX,
    minDelegationFee: BigInt.from(2));

final n5C = C(
    blockchainId: "V2EVDYfeusw3xQu6wTQrC74NfbkEXaQu26y3da9eswQMGzhhv",
    alias: cChainAlias,
    vm: cChainVMName,
    txBytesGas: 1,
    costPerSignature: 1000,
// DEPRECATED - txFee
// WILL BE REMOVED IN NEXT MAJOR VERSION BUMP
    txFee: MILLIAVAX,
// DEPRECATED - gasPrice
// WILL BE REMOVED IN NEXT MAJOR VERSION BUMP
    gasPrice: GWEI * BigInt.from(225),
    minGasPrice: GWEI * BigInt.from(25),
    maxGasPrice: GWEI * BigInt.from(1000),
    chainId: 0xa35);
// End Fuji

// Start local network
final n12345X = X(
    blockchainId: "2eNy1mUFdmaxXNj1eQHUe7Np4gju9sJsEtWQ4MX3ToiNKuADed",
    avaxAssetId: _avaxAssetId,
    alias: xChainAlias,
    vm: xChainVMName,
    txFee: MILLIAVAX,
    creationTxFee: CENTIAVAX);

final n12345P = P(
    blockchainId: platformChainId,
    avaxAssetId: "2b5EBv57UhJ5QbcApsgpmr3NiQoqed3w15xKqmm1GQ1JytPtZ2",
    alias: pChainAlias,
    vm: pChainVMName,
    txFee: MILLIAVAX,
    creationTxFee: CENTIAVAX,
    minConsumption: 0.1,
    maxConsumption: 0.12,
    maxStakingDuration: BigInt.from(31536000),
    maxSupply: BigInt.from(720000000) * ONEAVAX,
    minStake: ONEAVAX,
    minStakeDuration: 24 * 60 * 60,
    //one day
    maxStakeDuration: 365 * 24 * 60 * 60,
    // one year
    minDelegationStake: ONEAVAX,
    minDelegationFee: BigInt.from(2));

final n12345C = C(
    blockchainId: "2CA6j5zYzasynPsFeNoqWkmTCt3VScMvXUZHbfDJ8k3oGzAPtU",
    avaxAssetId: _avaxAssetId,
    alias: cChainAlias,
    vm: cChainVMName,
    txBytesGas: 1,
    costPerSignature: 1000,
// DEPRECATED - txFee
// WILL BE REMOVED IN NEXT MAJOR VERSION BUMP
    txFee: MILLIAVAX,
// DEPRECATED - gasPrice
// WILL BE REMOVED IN NEXT MAJOR VERSION BUMP
    gasPrice: GWEI * BigInt.from(225),
    minGasPrice: GWEI * BigInt.from(25),
    maxGasPrice: GWEI * BigInt.from(1000),
    chainId: 43112);
// End local network

final networks = {
  0: NetWork(
    c: n0C,
    x: n0X,
    p: n0P,
    hrp: networkIdToHRP[0]!,
    keys: {
      "2fFZQibQXcd6LTE4rpBPBAkLVXFE91Kit8pgxaBG1mRnh5xqbb": n0C,
      "2vrXWHgGxh5n3YsLHMV16YVVJTpT4z45Fmb4y3bL6si8kLCyg9": n0X,
      "11111111111111111111111111111111LpoYY": n0P,
    },
  ),
  1: NetWork(
    c: n1C,
    x: n1X,
    p: n1P,
    hrp: networkIdToHRP[1]!,
    keys: {
      "2q9e4r6Mu3U68nU1fYjgbR6JvwrRx36CohpAX5UQxse55x1Q5": n1C,
      "2oYMBNV4eNHyqk2fjjV5nVQLDbtmNJzq5s3qs3Lo6ftnC6FByM": n1X,
      "11111111111111111111111111111111LpoYY": n1P,
    },
  ),
  2: NetWork(
    c: n2C,
    x: n2X,
    p: n2P,
    hrp: networkIdToHRP[2]!,
    keys: {
      "2mUYSXfLrDtigwbzj1LxKVsHwELghc5sisoXrzJwLqAAQHF4i": n2C,
      "4ktRjsAKxgMr2aEzv9SWmrU7Xk5FniHUrVCX4P1TZSfTLZWFM": n2X,
      "11111111111111111111111111111111LpoYY": n2P,
    },
  ),
  3: NetWork(
    c: n3C,
    x: n3X,
    p: n3P,
    hrp: networkIdToHRP[3]!,
    keys: {
      "zJytnh96Pc8rM337bBrtMvJDbEdDNjcXG3WkTNCiLp18ergm9": n3C,
      "rrEWX7gc7D9mwcdrdBxBTdqh1a7WDVsMuadhTZgyXfFcRz45L": n3X,
      "11111111111111111111111111111111LpoYY": n3P,
    },
  ),
  4: NetWork(
    c: n4C,
    x: n4X,
    p: n4P,
    hrp: networkIdToHRP[4]!,
    keys: {
      "saMG5YgNsFxzjz4NMkEkt3bAH6hVxWdZkWcEnGB3Z15pcAmsK": n4C,
      "jnUjZSRt16TcRnZzmh5aMhavwVHz3zBrSN8GfFMTQkzUnoBxC": n4X,
      "11111111111111111111111111111111LpoYY": n4P,
    },
  ),
  5: NetWork(
    c: n5C,
    x: n5X,
    p: n5P,
    hrp: networkIdToHRP[5]!,
    keys: {
      "2XNs8nmfB8HdDeHhf41yTd1KQ5md3PBsnz3mvFevtr3DzBAiib": n5C,
      "2bUiRRqUr9ZkDAVehjeaM4J8PsW52X2EbuGW1K5e56KZcT6yi7": n5X,
      "11111111111111111111111111111111LpoYY": n5P,
    },
  ),
  12345: NetWork(
    c: n12345C,
    x: n12345X,
    p: n12345P,
    hrp: networkIdToHRP[12345]!,
    keys: {
      "2CA6j5zYzasynPsFeNoqWkmTCt3VScMvXUZHbfDJ8k3oGzAPtU": n12345C,
      "11111111111111111111111111111111LpoYY": n12345P,
      "2eNy1mUFdmaxXNj1eQHUe7Np4gju9sJsEtWQ4MX3ToiNKuADed": n12345X,
    },
  )
};

class C {
  final String blockchainId;
  final String alias;
  final String vm;
  final BigInt? fee;
  final BigInt? gasPrice;
  final int chainId;
  final BigInt? minGasPrice;
  final BigInt? maxGasPrice;
  final int? txBytesGas;
  final int? costPerSignature;
  final BigInt? txFee;
  final String? avaxAssetId;

  C(
      {required this.blockchainId,
      required this.alias,
      required this.vm,
      this.fee,
      this.gasPrice,
      required this.chainId,
      this.minGasPrice,
      this.maxGasPrice,
      this.txBytesGas,
      this.costPerSignature,
      this.txFee,
      this.avaxAssetId});
}

class X {
  String blockchainId;
  final String alias;
  final String vm;
  final BigInt creationTxFee;
  String avaxAssetId;
  final BigInt? txFee;
  final BigInt? fee;

  X(
      {required this.blockchainId,
      required this.alias,
      required this.vm,
      required this.creationTxFee,
      required this.avaxAssetId,
      this.txFee,
      this.fee});
}

class P {
  final String blockchainId;
  final String alias;
  final String vm;
  final BigInt? creationTxFee;
  final num minConsumption;
  final num maxConsumption;
  final BigInt maxStakingDuration;
  final BigInt maxSupply;
  final BigInt minStake;
  final num minStakeDuration;
  final num maxStakeDuration;
  final BigInt minDelegationStake;
  final BigInt minDelegationFee;
  final String? avaxAssetId;
  final BigInt? txFee;
  final BigInt? fee;

  P(
      {required this.blockchainId,
      required this.alias,
      required this.vm,
      this.creationTxFee,
      required this.minConsumption,
      required this.maxConsumption,
      required this.maxStakingDuration,
      required this.maxSupply,
      required this.minStake,
      required this.minStakeDuration,
      required this.maxStakeDuration,
      required this.minDelegationStake,
      required this.minDelegationFee,
      this.avaxAssetId,
      this.txFee,
      this.fee});
}

class NetWork {
  final C c;
  final X x;
  final P p;
  final String hrp;
  final Map<String, dynamic> keys;

  const NetWork(
      {required this.c,
      required this.x,
      required this.p,
      required this.hrp,
      required this.keys});

  String? findAliasByBlockChainId(String blockChainId) {
    if (x.blockchainId == blockChainId) {
      return x.alias;
    } else if (p.blockchainId == blockChainId) {
      return p.alias;
    } else if (c.blockchainId == blockChainId) {
      return c.alias;
    } else {
      return null;
    }
  }
}

/// Rules used when merging sets
enum MergeRule {
  intersection,
  differenceSelf,
  differenceNew,
  symDifference,
  union,
  unionMinusNew,
  unionMinusSelf,
  error,
}

extension MergeRuleString on MergeRule {
  String get rule {
    switch (this) {
      case MergeRule.intersection:
        return "intersection";
      case MergeRule.differenceSelf:
        return "differenceSelf";
      case MergeRule.differenceNew:
        return "differenceNew";
      case MergeRule.symDifference:
        return "symDifference";
      case MergeRule.union:
        return "union";
      case MergeRule.unionMinusNew:
        return "unionMinusNew";
      case MergeRule.unionMinusSelf:
        return "unionMinusSelf";
      case MergeRule.error:
        return "ERROR";
    }
  }
}

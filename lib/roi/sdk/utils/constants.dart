const protocols = ["http", "https"];

const privateKeyPrefix = "PrivateKey-";
const nodeIdPrefix = "NodeID-";
const primaryAssetAlias = "AVAX";
const mainNetAPI = "api.avax.network";
const fujiAPI = "api.avax-test.network";

const networkIdToHRP = {
  0: "custom",
  1: "avax",
  2: "cascade",
  3: "denali",
  4: "everest",
  5: "fuji",
  12345: "local"
};

const hrpToNetworkId = {
  "custom": 0,
  "avax": 1,
  "cascade": 2,
  "denali": 3,
  "everest": 4,
  "fuji": 5,
  "local": 12345
};

const networkIdToNetworkNames = {
  0: ["Manhattan"],
  1: ["Avalanche", "Mainnet"],
  2: ["Cascade"],
  3: ["Denali"],
  4: ["Everest"],
  5: ["Fuji", "Testnet"],
  12345: ["Local Network"]
};

const networkNameToNetworkId = {
  "Manhattan": 0,
  "Avalanche": 1,
  "Mainnet": 1,
  "Cascade": 2,
  "Denali": 3,
  "Everest": 4,
  "Fuji": 5,
  "Testnet": 5,
  "Local Network": 12345
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

final ONEAVAX = BigInt.from(1000000000);

final DECIAVAX = ONEAVAX ~/ BigInt.from(10);

final CENTIAVAX = ONEAVAX ~/ BigInt.from(100);

final MILLIAVAX = ONEAVAX ~/ BigInt.from(1000);

final MICROAVAX = ONEAVAX ~/ BigInt.from(1000000);

final NANOAVAX = ONEAVAX ~/ BigInt.from(1000000000);

final WEI = BigInt.from(1);

final GWEI = WEI * BigInt.from(1000000000);

final AVAXGWEI = NANOAVAX;

final AVAXSTAKECAP = ONEAVAX * BigInt.from(3000000);

// Start Manhattan
final n0X = X(
    blockchainId: "2vrXWHgGxh5n3YsLHMV16YVVJTpT4z45Fmb4y3bL6si8kLCyg9",
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
const avaxAssetId = "FvwEAhmxKfeiG8SnEvq42hc6whRyY3EFYAvebMqDNDGCgxN5Z";
final n1X = X(
    blockchainId: "2oYMBNV4eNHyqk2fjjV5nVQLDbtmNJzq5s3qs3Lo6ftnC6FByM",
    avaxAssetId: avaxAssetId,
    alias: xChainAlias,
    vm: xChainVMName,
    txFee: MILLIAVAX,
    creationTxFee: CENTIAVAX);

final n1P = P(
    blockchainId: platformChainId,
    avaxAssetId: avaxAssetId,
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
    blockchainId: "2q9e4r6Mu3U68nU1fYjgbR6JvwrRx36CohpAX5UQxse55x1Q5",
    alias: cChainAlias,
    vm: cChainVMName,
    txBytesGas: 1,
    costPerSignature: 1000,
    txFee: MILLIAVAX,
    gasPrice: GWEI * BigInt.from(225),
    minGasPrice: GWEI * BigInt.from(25),
    maxGasPrice: GWEI * BigInt.from(1000),
    chainId: 43114);
// End Mainnet

// Start Cascade
final n2X = X(
    blockchainId: "4ktRjsAKxgMr2aEzv9SWmrU7Xk5FniHUrVCX4P1TZSfTLZWFM",
    alias: xChainAlias,
    vm: xChainVMName,
    txFee: BigInt.from(0),
    creationTxFee: BigInt.from(0));

final n2P = P(
    blockchainId: platformChainId,
    alias: pChainAlias,
    vm: pChainVMName,
    txFee: BigInt.from(0),
    creationTxFee: BigInt.from(0),
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
    gasPrice: BigInt.from(0));
// End Cascade

// Start Denali
final n3X = X(
    blockchainId: "rrEWX7gc7D9mwcdrdBxBTdqh1a7WDVsMuadhTZgyXfFcRz45L",
    alias: xChainAlias,
    vm: xChainVMName,
    txFee: BigInt.from(0),
    creationTxFee: BigInt.from(0));

final n3P = P(
    blockchainId: "",
    alias: pChainAlias,
    vm: pChainVMName,
    txFee: BigInt.from(0),
    creationTxFee: BigInt.from(0),
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
    gasPrice: BigInt.from(0));
// End Denali

// Start Everest
final n4X = X(
    blockchainId: "jnUjZSRt16TcRnZzmh5aMhavwVHz3zBrSN8GfFMTQkzUnoBxC",
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
    blockchainId: "2JVSBoinj9C2J33VntvzYtVJNZdN2NKiwwKjcumHUWEb5DbBrm",
    avaxAssetId: "U8iRqJoiJm8xZHAacmvYyZVwqQx6uDNtQeP3CQ6fcgQk3JqnK",
    alias: xChainAlias,
    vm: xChainVMName,
    txFee: MILLIAVAX,
    creationTxFee: CENTIAVAX);

final n5P = P(
    blockchainId: platformChainId,
    avaxAssetId: avaxAssetId,
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
    blockchainId: "yH8D7ThNJkxmtkuv2jgBa4P1Rn3Qpr4pPr7QYNfcdoS6k6HWp",
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
    chainId: 43113);
// End Fuji

// Start local network
final n12345X = n5X
  ..blockchainId = "2eNy1mUFdmaxXNj1eQHUe7Np4gju9sJsEtWQ4MX3ToiNKuADed"
  ..avaxAssetId = avaxAssetId;

final n12345P = n5P..blockchainId = platformChainId;

final n12345C = n5C
  ..blockchainId = "2CA6j5zYzasynPsFeNoqWkmTCt3VScMvXUZHbfDJ8k3oGzAPtU"
  ..avaxAssetId = avaxAssetId
  ..chainId = 43112;
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
  5: NetWork(c: n5C, x: n5X, p: n5P, hrp: networkIdToHRP[5]!, keys: {
    "yH8D7ThNJkxmtkuv2jgBa4P1Rn3Qpr4pPr7QYNfcdoS6k6HWp": n5C,
    "2JVSBoinj9C2J33VntvzYtVJNZdN2NKiwwKjcumHUWEb5DbBrm": n5X,
    "11111111111111111111111111111111LpoYY": n5P,
  }),
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
  String blockchainId;
  final String alias;
  final String vm;
  final BigInt? fee;
  final BigInt? gasPrice;
  int? chainId;
  final BigInt? minGasPrice;
  final BigInt? maxGasPrice;
  final num? txBytesGas;
  final num? costPerSignature;
  final BigInt? txFee;
  String? avaxAssetId;

  C(
      {required this.blockchainId,
      required this.alias,
      required this.vm,
      this.fee,
      this.gasPrice,
      this.chainId,
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
  String? avaxAssetId;
  final BigInt? txFee;
  final BigInt? fee;

  X(
      {required this.blockchainId,
      required this.alias,
      required this.vm,
      required this.creationTxFee,
      this.avaxAssetId,
      this.txFee,
      this.fee});
}

class P {
  String blockchainId;
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

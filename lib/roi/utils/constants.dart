const protocols = ["http", "https"];

const int defaultNetworkID = 1;

const PrivateKeyPrefix = "PrivateKey-";
const NodeIDPrefix = "NodeID-";
const PrimaryAssetAlias = "AVAX";
const MainnetAPI = "api.avax.network";
const FujiAPI = "api.avax-test.network";

const networkIDToHRP = {
  0: "custom",
  1: "avax",
  2: "cascade",
  3: "denali",
  4: "everest",
  5: "fuji",
  12345: "local",
};

const hrpToNetworkID = {
  "custom": 0,
  "avax": 1,
  "cascade": 2,
  "denali": 3,
  "everest": 4,
  "fuji": 5,
  "local": 12345
};

const networkIDToNetworkNames = {
  0: ["Manhattan"],
  1: ["Avalanche", "Mainnet"],
  2: ["Cascade"],
  3: ["Denali"],
  4: ["Everest"],
  5: ["Fuji", "Testnet"],
  12345: ["Local Network"]
};

const networkNameToNetworkID = {
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

const FallbackHRP = "custom";
const FallbackNetworkName = "Custom Network";
const FallbackEVMChainID = 43112;

const DefaultNetworkID = 1;

const PlatformChainID = "11111111111111111111111111111111LpoYY";
const PrimaryNetworkID = "11111111111111111111111111111111LpoYY";
const XChainAlias = "X";
const CChainAlias = "C";
const PChainAlias = "P";
const XChainVMName = "avm";
const CChainVMName = "evm";
const PChainVMName = "platformvm";

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

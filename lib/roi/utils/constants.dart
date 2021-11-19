const protocols = ["http", "https"];

const int defaultNetworkID = 1;

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

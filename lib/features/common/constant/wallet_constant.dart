import 'package:flutter_dotenv/flutter_dotenv.dart';

const ezcSymbol = 'EZC';
const ezcName = 'EZChain';

final privateKeyTest = dotenv.get("PRIVATE_KEY", fallback: "");
final receiverAddressXTest = dotenv.get("X_ADDRESS_TEST", fallback: "");
final receiverAddressCTest = dotenv.get("C_ADDRESS_TEST", fallback: "");
final erc20AddressTest = dotenv.get("ERC20_ADDRESS_TEST", fallback: "");

const defaultNodeLogo =
    'https://ezchain-image.sgp1.digitaloceanspaces.com/Logo-default.png';

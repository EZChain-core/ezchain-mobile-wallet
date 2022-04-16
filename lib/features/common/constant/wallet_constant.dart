import 'package:flutter_dotenv/flutter_dotenv.dart';

const ezcSymbol = 'EZC';
const ezcName = 'EZChain';

final privateKeyTest = dotenv.get("PRIVATE_KEY", fallback: "");
const receiverAddressXTest = 'X-fuji129sdwasyyvdlqqsg8d9pguvzlqvup6cmtd8jad';
const receiverAddressCTest = '0xd30a9f6645a73f67b7850b9304b6a3172dda75bf';
const erc20AddressTest = '0xE9cD92d3De1FB47a76f00e1E404ec6a577428938';

const defaultNodeLogo = 'https://ezchain-image.sgp1.digitaloceanspaces.com/Logo-default.png';

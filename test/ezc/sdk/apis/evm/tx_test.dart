import 'package:test/test.dart';
import 'package:wallet/ezc/sdk/apis/evm/export_tx.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';
import 'package:wallet/ezc/sdk/utils/constants.dart';

const networkID = 12345;
final blockchainID = networks[networkID]!.c.blockchainId;
final sourcechainID = networks[networkID]!.x.blockchainId;

void main() {
  test("ExportTx", () {
    final exportTx = EvmExportTx(
        networkId: networkID,
        blockchainId: cb58Decode(blockchainID),
        destinationChain: cb58Decode(platformChainId));

    expect(hexEncode(exportTx.getDestinationChain()),
        hexEncode(cb58Decode(platformChainId)));
  });
}

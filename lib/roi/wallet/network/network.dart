import 'package:http/http.dart';
import 'package:wallet/roi/roi.dart';
import 'package:web3dart/web3dart.dart';

const String rpcUrl = 'http://localhost:7545';

final web3 = Web3Client(rpcUrl, Client());

final roi = ROI.create(host: "host", port: 8080, protocol: "protocol");

final xChain = roi.avmApi;

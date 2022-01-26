import 'dart:typed_data';

import 'package:wallet/roi/sdk/common/input.dart';
import 'package:wallet/roi/sdk/common/output.dart';
import 'package:wallet/roi/sdk/utils/bintools.dart';

class AssetAmount {
  final Uint8List assetId;
  var _amount = BigInt.from(0);
  var _burn = BigInt.from(0);

  var _spent = BigInt.from(0);
  var _stakeableLockSpent = BigInt.from(0);
  var _change = BigInt.from(0);
  var _stakeableLockChange = false;

  var _finished = false;

  AssetAmount({required this.assetId, BigInt? amount, BigInt? burn}) {
    _amount = amount ?? BigInt.from(0);
    _burn = burn ?? BigInt.from(0);
    _spent = BigInt.from(0);
    _stakeableLockSpent = BigInt.from(0);
    _stakeableLockChange = false;
  }

  Uint8List getAssetId() => assetId;

  String getAssetIdString() => hexEncode(assetId);

  BigInt getAmount() => _amount;

  BigInt getSpent() => _spent;

  BigInt getBurn() => _burn;

  BigInt getChange() => _change;

  BigInt getStakeableLockSpent() => _stakeableLockSpent;

  bool getStakeableLockChange() => _stakeableLockChange;

  bool isFinished() => _finished;

  bool spendAmount(BigInt amt, {bool stakeableLocked = false}) {
    if (_finished) {
      throw Exception(
          "Error - AssetAmount.spendAmount: attempted to spend excess funds");
    }
    _spent += amt;
    if (stakeableLocked) {
      _stakeableLockSpent += amt;
    }
    final total = _amount + _burn;
    if (_spent >= total) {
      _change = _spent - total;
      if (stakeableLocked) {
        _stakeableLockChange = true;
      }
      _finished = true;
    }
    return _finished;
  }
}

abstract class StandardAssetAmountDestination<
    TO extends StandardTransferableOutput,
    TI extends StandardTransferableInput> {
  final _amounts = <AssetAmount>[];
  final List<Uint8List> destinations = [];
  final List<Uint8List> senders = [];
  final List<Uint8List> changeAddresses = [];
  final _amountKey = {};
  final _inputs = <TI>[];
  final _outputs = <TO>[];
  final _change = <TO>[];

  StandardAssetAmountDestination(
      {List<Uint8List> destinations = const [],
      List<Uint8List> senders = const [],
      List<Uint8List> changeAddresses = const []}) {
    this.destinations.clear();
    this.destinations.addAll(destinations);
    this.senders.clear();
    this.senders.addAll(senders);
    this.changeAddresses.clear();
    this.changeAddresses.addAll(changeAddresses);
  }

  void addAssetAmount(Uint8List assetId, BigInt amount, BigInt burn) {
    final aa = AssetAmount(assetId: assetId, amount: amount, burn: burn);
    _amounts.add(aa);
    _amountKey[aa.getAssetIdString()] = aa;
  }

  void addInput(TI input) {
    _inputs.add(input);
  }

  void addOutput(TO output) {
    _outputs.add(output);
  }

  void addChange(TO output) {
    _change.add(output);
  }

  List<AssetAmount> getAmounts() {
    return _amounts;
  }

  List<Uint8List> getDestinations() {
    return destinations;
  }

  List<Uint8List> getSenders() {
    return senders;
  }

  List<Uint8List> getChangeAddresses() {
    return changeAddresses;
  }

  AssetAmount getAssetAmount(String assetHexStr) {
    return _amountKey[assetHexStr];
  }

  bool assetExists(String assetHexStr) {
    return _amountKey.keys.contains(assetHexStr);
  }

  List<TI> getInputs() {
    return _inputs;
  }

  List<TO> getOutputs() {
    return _outputs;
  }

  List<TO> getChangeOutputs() {
    return _change;
  }

  List<TO> getAllOutputs() {
    return _outputs + _change;
  }

  bool canComplete() {
    for (int i = 0; i < _amounts.length; i++) {
      if (!_amounts[i].isFinished()) {
        return false;
      }
    }
    return true;
  }
}

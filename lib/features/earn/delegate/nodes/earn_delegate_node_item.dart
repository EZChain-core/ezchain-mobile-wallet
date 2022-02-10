import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wallet/themes/theme.dart';

class EarnDelegateNodeItem {
  final String nodeId;
  final String validatorStake;
  final String available;
  final int numberOfDelegators;
  final String endTime;
  final String fee;

  EarnDelegateNodeItem(this.nodeId, this.validatorStake, this.available,
      this.numberOfDelegators, this.endTime, this.fee);
}

class EarnDelegateNodeItemWidget extends StatelessWidget {
  final EarnDelegateNodeItem item;

  const EarnDelegateNodeItemWidget({Key? key, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Container(),
    );
  }
}

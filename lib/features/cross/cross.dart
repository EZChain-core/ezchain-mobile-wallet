import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/cross/cross_store.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/inputs.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class CrossScreen extends StatelessWidget {
  const CrossScreen({Key? key}) : super(key: key);

  void _onClickConfirm() {}

  void _onClickTransfer() {}

  void _onClickCancel() {}

  @override
  Widget build(BuildContext context) {
    final crossStore = CrossStore();
    crossStore.setSourceChain(crossStore.sourceChain);
    final amountController = TextEditingController();

    bool _isConfirm = false;

    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              children: [
                Row(
                  children: [
                    Assets.icons.icRoi.svg(),
                    const SizedBox(width: 8),
                    Text(
                      'ROI',
                      style:
                          ROIBodyLargeTextStyle(color: provider.themeMode.text),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: provider.themeMode.bg,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Observer(
                          builder: (_) => ROIDropdown<CrossChainType>(
                            label: Strings.current.sharedSource,
                            items: CrossChainType.values,
                            onChanged: (type) {
                              crossStore.setSourceChain(type);
                            },
                            parseString: (type) => type.name,
                            initValue: crossStore.sourceChain,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Observer(
                          builder: (_) => ROIAmountTextField(
                            label: Strings.current.sharedAmount,
                            backgroundColor: provider.themeMode.white,
                            hint: '0.0',
                            suffixText: Strings.current
                                .walletSendBalance(crossStore.balance),
                            rateUsd: crossStore.avaxPrice,
                            error: crossStore.amountError,
                            onChanged: (_) => crossStore.removeAmountError(),
                            controller: amountController,
                            onSuffixPressed: () {
                              amountController.text =
                                  crossStore.balance.replaceAll(',', '');
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Stack(
                        children: [
                          Divider(
                            height: 48,
                            thickness: 1,
                            color: provider.themeMode.text10,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: 48,
                              height: 48,
                              margin: const EdgeInsets.only(right: 16),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: provider.themeMode.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 1,
                                      color: provider.themeMode.text10)),
                              child: Assets.icons.icSwitchArrow.svg(),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Observer(
                          builder: (_) => ROIDropdown<CrossChainType>(
                            label: Strings.current.sharedDestination,
                            items: crossStore.destinationList,
                            parseString: (type) => type.name,
                            initValue: crossStore.destinationChain,
                            onChanged: (t) {
                              crossStore.destinationChain = t;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Strings.current.crossFee,
                        style: ROITitleLargeTextStyle(
                            color: provider.themeMode.text60),
                      ),
                      Text(
                        '0.02 AVAX',
                        style: ROITitleLargeTextStyle(
                            color: provider.themeMode.text60),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 87),
                if (!_isConfirm)
                  ROIMediumPrimaryButton(
                    text: Strings.current.sharedConfirm,
                    width: 185,
                    padding: const EdgeInsets.symmetric(),
                    onPressed: _onClickConfirm,
                  ),
                if (_isConfirm) ...[
                  ROIMediumSuccessButton(
                    text: Strings.current.sharedSendTransaction,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 64,
                      vertical: 8,
                    ),
                    onPressed: _onClickTransfer,
                  ),
                  const SizedBox(height: 4),
                  ROIMediumNoneButton(
                    width: 82,
                    text: Strings.current.sharedCancel,
                    textColor: provider.themeMode.text90,
                    onPressed: _onClickCancel,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

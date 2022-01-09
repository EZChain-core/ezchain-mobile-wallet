import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/features/cross/cross_store.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/inputs.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class CrossScreen extends StatefulWidget {
  const CrossScreen({Key? key}) : super(key: key);

  @override
  State<CrossScreen> createState() => _CrossScreenState();
}

class _CrossScreenState extends State<CrossScreen> {
  final crossStore = CrossStore();
  final amountController = TextEditingController();

  @override
  void initState() {
    crossStore.setSourceChain(crossStore.sourceChain);
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void _onClickConfirm() {
    final amount = double.tryParse(amountController.text) ?? 0;
    crossStore.isConfirm = crossStore.validate(amount);
    if (crossStore.isConfirm) {
      setState(() {});
    }
  }

  void _onClickTransfer() {
    context.router.push(CrossTransferRoute(crossStore: crossStore));
  }

  void _onClickCancel() {
    setState(() {
      crossStore.isConfirm = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                            enabled: !crossStore.isConfirm,
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
                                .walletSendBalance(crossStore.sourceBalance),
                            rateUsd: crossStore.avaxPrice,
                            error: crossStore.amountError,
                            onChanged: (_) => crossStore.removeAmountError(),
                            controller: amountController,
                            onSuffixPressed: () {
                              amountController.text =
                                  crossStore.sourceBalance.replaceAll(',', '');
                            },
                            enabled: !crossStore.isConfirm,
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
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Observer(
                          builder: (_) => ROIDropdown<CrossChainType>(
                            label: Strings.current.sharedDestination,
                            items: crossStore.destinationList,
                            parseString: (type) => type.name,
                            initValue: crossStore.destinationChain,
                            onChanged: (t) {
                              crossStore.destinationChain = t;
                            },
                            enabled: !crossStore.isConfirm,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Observer(
                        builder: (_) => Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(right: 16),
                          child: Text(
                            Strings.current.walletSendBalance(
                                crossStore.destinationBalance),
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.end,
                            style: ROILabelMediumTextStyle(
                                color: provider.themeMode.text60),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
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
                if (!crossStore.isConfirm)
                  ROIMediumPrimaryButton(
                    text: Strings.current.sharedConfirm,
                    width: 185,
                    padding: const EdgeInsets.symmetric(),
                    onPressed: _onClickConfirm,
                  ),
                if (crossStore.isConfirm) ...[
                  ROIMediumSuccessButton(
                    text: Strings.current.sharedTransfer,
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

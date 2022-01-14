import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/price_store.dart';
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
  CrossStore _crossStore = CrossStore();
  final _amountController = TextEditingController();

  @override
  void initState() {
    _crossStore.init();
    super.initState();
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
                      'EZC',
                      style:
                          EZCBodyLargeTextStyle(color: provider.themeMode.text),
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
                          builder: (_) => EZCDropdown<CrossChainType>(
                            label: Strings.current.sharedSource,
                            items: CrossChainType.values,
                            onChanged: (type) {
                              _crossStore.setSourceChain(type);
                            },
                            parseString: (type) => type.name,
                            initValue: _crossStore.sourceChain,
                            enabled: !_crossStore.isConfirm,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Observer(
                          builder: (_) => EZCAmountTextField(
                            label: Strings.current.sharedAmount,
                            backgroundColor: provider.themeMode.white,
                            hint: '0.0',
                            suffixText: Strings.current
                                .walletSendBalance(_crossStore.sourceBalance),
                            rateUsd: _crossStore.avaxPrice,
                            error: _crossStore.amountError,
                            onChanged: (amount) {
                              _crossStore.amount = double.tryParse(amount) ?? 0;
                              _crossStore.removeAmountError();
                              _crossStore.updateFee();
                            },
                            controller: _amountController,
                            onSuffixPressed: () {
                              _amountController.text =
                                  _crossStore.sourceBalance.replaceAll(',', '');
                            },
                            enabled: !_crossStore.isConfirm,
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
                          builder: (_) => EZCDropdown<CrossChainType>(
                            label: Strings.current.sharedDestination,
                            items: _crossStore.destinationList,
                            parseString: (type) => type.name,
                            initValue: _crossStore.destinationChain,
                            onChanged: (t) {
                              _crossStore.destinationChain = t;
                            },
                            enabled: !_crossStore.isConfirm,
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
                                _crossStore.destinationBalance),
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.end,
                            style: EZCLabelMediumTextStyle(
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
                    children: [
                      Text(
                        Strings.current.crossFee,
                        style: EZCTitleLargeTextStyle(
                            color: provider.themeMode.text60),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Observer(
                          builder: (_) => Text(
                            '${_crossStore.fee} EZC',
                            textAlign: TextAlign.end,
                            style: EZCTitleLargeTextStyle(
                                color: provider.themeMode.text60),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 87),
                if (!_crossStore.isConfirm)
                  EZCMediumPrimaryButton(
                    text: Strings.current.sharedConfirm,
                    width: 185,
                    padding: const EdgeInsets.symmetric(),
                    onPressed: _onClickConfirm,
                  ),
                if (_crossStore.isConfirm) ...[
                  EZCMediumSuccessButton(
                    text: Strings.current.sharedTransfer,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 64,
                      vertical: 8,
                    ),
                    onPressed: _onClickTransfer,
                  ),
                  const SizedBox(height: 4),
                  EZCMediumNoneButton(
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

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onClickConfirm() {
    _crossStore.isConfirm = _crossStore.validate();
    if (_crossStore.isConfirm) {
      setState(() {});
    }
  }

  Future<void> _onClickTransfer() async {
    _crossStore.transferring();
    final isRefreshCrossScreen = await context.router.push<bool>(CrossTransferRoute(crossStore: _crossStore));
    if(isRefreshCrossScreen == true) {
      setState(() {
        _crossStore = CrossStore();
        _amountController.text = '';
      });
    }
  }

  void _onClickCancel() {
    setState(() {
      _crossStore.isConfirm = false;
    });
  }
}

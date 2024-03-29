// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/common/route/router.gr.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/features/auth/pin/verify/pin_code_verify.dart';
import 'package:wallet/features/common/constant/wallet_constant.dart';
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
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  Row(
                    children: [
                      Assets.icons.icEzc64.svg(width: 32, height: 32),
                      const SizedBox(width: 8),
                      Text(
                        ezcSymbol,
                        style: EZCBodyLargeTextStyle(
                            color: provider.themeMode.text),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Observer(
                    builder: (_) => !_crossStore.isConfirm
                        ? Container(
                            decoration: BoxDecoration(
                              color: provider.themeMode.bg,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16)),
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
                                        _amountController.text = '';
                                      },
                                      parseString: (type) => type.name,
                                      initValue: _crossStore.sourceChain,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Observer(
                                    builder: (_) => EZCAmountTextField(
                                      label: Strings.current.sharedAmount,
                                      backgroundColor: provider.themeMode.white,
                                      hint: '0.0',
                                      suffixText: Strings.current
                                          .walletSendBalance(_crossStore
                                              .sourceBalance
                                              .toLocaleString(decimals: 3)),
                                      rateUsd: _crossStore.avaxPrice,
                                      error: _crossStore.amountError,
                                      onChanged: (amount) {
                                        _crossStore.amount =
                                            Decimal.tryParse(amount) ??
                                                Decimal.zero;
                                        _crossStore.removeAmountError();
                                        _crossStore.updateFee();
                                      },
                                      controller: _amountController,
                                      onSuffixPressed: () {
                                        _amountController.text = _crossStore
                                            .maxSourceAmount
                                            .toString();
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
                                      child: GestureDetector(
                                        onTap: _crossStore.switchChain,
                                        child: Container(
                                          width: 48,
                                          height: 48,
                                          margin:
                                              const EdgeInsets.only(right: 16),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                              color: provider.themeMode.white,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  width: 1,
                                                  color: provider
                                                      .themeMode.text10)),
                                          child:
                                              Assets.icons.icSwitchArrow.svg(),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Observer(
                                    builder: (_) => EZCDropdown<CrossChainType>(
                                      label: Strings.current.sharedDestination,
                                      items: _crossStore.destinationList,
                                      parseString: (type) => type.name,
                                      initValue: _crossStore.destinationChain,
                                      onChanged: (type) {
                                        _crossStore.destinationChain = type;
                                        _amountController.text = '';
                                      },
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
                                          _crossStore.destinationBalance
                                              .toLocaleString(decimals: 3)),
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
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: provider.themeMode.bg,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Strings.current.sharedSource,
                                        style: EZCTitleLargeTextStyle(
                                            color: provider.themeMode.text60),
                                      ),
                                      Observer(
                                        builder: (_) => Text(
                                          _crossStore.sourceChain.name,
                                          style: EZCBodyLargeTextStyle(
                                              color: provider.themeMode.text),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Strings.current.sharedAmount,
                                        style: EZCTitleLargeTextStyle(
                                            color: provider.themeMode.text60),
                                      ),
                                      Observer(
                                        builder: (_) => Text(
                                          '${_crossStore.amount}',
                                          style: EZCBodyLargeTextStyle(
                                              color: provider.themeMode.text),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Observer(
                                  builder: (_) => Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: Text(
                                      Strings.current.walletSendBalance(
                                          _crossStore.sourceBalance
                                              .toLocaleString(decimals: 3)),
                                      style: EZCLabelMediumTextStyle(
                                          color: provider.themeMode.text60),
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
                                        margin:
                                            const EdgeInsets.only(right: 16),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: provider.themeMode.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            width: 1,
                                            color: provider.themeMode.text10,
                                          ),
                                        ),
                                        child:
                                            Assets.icons.icArrowDownBlack.svg(),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Strings.current.sharedDestination,
                                        style: EZCTitleLargeTextStyle(
                                            color: provider.themeMode.text60),
                                      ),
                                      Observer(
                                        builder: (_) => Text(
                                          _crossStore.destinationChain.name,
                                          style: EZCBodyLargeTextStyle(
                                              color: provider.themeMode.text),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Observer(
                                  builder: (_) => Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: Text(
                                      Strings.current.walletSendBalance(
                                          _crossStore.destinationBalance
                                              .toLocaleString(decimals: 3)),
                                      style: EZCLabelMediumTextStyle(
                                          color: provider.themeMode.text60),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
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
                              '${_crossStore.fee.toLocaleString(decimals: 5)} $ezcSymbol',
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
    if (!await verifyPinCode()) return;

    final isRefreshCrossScreen = await context.router.push<bool>(
        CrossTransferRoute(crossTransferInfo: _crossStore.crossTransferInfo));
    if (isRefreshCrossScreen == true) {
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

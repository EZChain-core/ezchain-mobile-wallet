// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/features/common/constant/wallet_constant.dart';
import 'package:wallet/features/wallet/send/evm/wallet_send_evm_store.dart';
import 'package:wallet/features/wallet/send/widgets/wallet_send_widgets.dart';
import 'package:wallet/features/wallet/token/wallet_token_item.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/inputs.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class WalletSendEvmScreen extends StatefulWidget {
  final WalletTokenItem? fromToken;

  WalletSendEvmScreen({Key? key, this.fromToken}) : super(key: key) {}

  @override
  State<WalletSendEvmScreen> createState() => _WalletSendEvmScreenState();
}

class _WalletSendEvmScreenState extends State<WalletSendEvmScreen> {
  final _walletSendEvmStore = WalletSendEvmStore();

  final _amountController = TextEditingController();

  final _addressController = TextEditingController(text: receiverAddressCTest);

  @override
  void initState() {
    _walletSendEvmStore.setWalletToken(widget.fromToken);
    _walletSendEvmStore.getBalanceC();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => DefaultTabController(
        length: 2,
        child: Scaffold(
          body: SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EZCAppBar(
                    title: Strings.current.sharedSend,
                    onPressed: context.router.pop,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 16),
                                Assets.icons.icEzc64.svg(width: 32, height: 32),
                                const SizedBox(width: 8),
                                Text(
                                  widget.fromToken != null
                                      ? widget.fromToken!.symbol
                                      : ezcSymbol,
                                  style: EZCBodyLargeTextStyle(
                                      color: provider.themeMode.text),
                                ),
                                const SizedBox(width: 16),
                                const EZCChainLabelText(text: 'C-Chain'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Observer(
                                builder: (_) => EZCAddressTextField(
                                    label: Strings.current.sharedSendTo,
                                    hint: Strings.current.sharedPasteAddress,
                                    controller: _addressController,
                                    error: _walletSendEvmStore.addressError,
                                    enabled: !_walletSendEvmStore.isConfirm,
                                    onChanged: (text) {
                                      _walletSendEvmStore.address = text;
                                      _walletSendEvmStore.removeAddressError();
                                    }),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Observer(
                                builder: (_) => EZCAmountTextField(
                                  label: Strings.current.sharedSetAmount,
                                  hint: '0.0',
                                  suffixText: Strings.current.walletSendBalance(
                                      _walletSendEvmStore.balanceCString),
                                  rateUsd: _walletSendEvmStore.avaxPrice,
                                  error: _walletSendEvmStore.amountError,
                                  enabled: !_walletSendEvmStore.isConfirm,
                                  onChanged: (amount) {
                                    _walletSendEvmStore.amount =
                                        Decimal.tryParse(amount) ??
                                            Decimal.zero;
                                    _walletSendEvmStore.removeAmountError();
                                  },
                                  controller: _amountController,
                                  onSuffixPressed: () {
                                    _amountController.text = _walletSendEvmStore
                                        .maxAmount
                                        .toString();
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              height: 40,
                              padding: const EdgeInsets.all(4),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: provider.themeMode.secondary10,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Observer(
                                builder: (_) => IgnorePointer(
                                  ignoring: _walletSendEvmStore.isConfirm,
                                  child: TabBar(
                                    indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: provider.themeMode.secondary,
                                    ),
                                    labelStyle: EZCTitleSmallTextStyle(
                                        color: provider.themeMode.primary),
                                    labelColor: provider.themeMode.primary,
                                    unselectedLabelStyle:
                                        EZCTitleSmallTextStyle(
                                            color: provider.themeMode.text40),
                                    unselectedLabelColor:
                                        provider.themeMode.text40,
                                    tabs: [
                                      Tab(
                                          text: Strings
                                              .current.walletSendDefaultFee),
                                      Tab(
                                          text: Strings
                                              .current.walletSendCustomFee)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 450,
                              child: Observer(
                                builder: (_) => TabBarView(
                                  physics: _walletSendEvmStore.isConfirm
                                      ? const NeverScrollableScrollPhysics()
                                      : null,
                                  children: [
                                    _WalletSendEvmDefaultFeeTab(
                                      walletSendEvmStore: _walletSendEvmStore,
                                    ),
                                    _WalletSendEvmCustomFeeTab(
                                      walletSendEvmStore: _walletSendEvmStore,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
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
    _addressController.dispose();
    super.dispose();
  }
}

class _WalletSendEvmDefaultFeeTab extends StatelessWidget {
  final WalletSendEvmStore walletSendEvmStore;

  const _WalletSendEvmDefaultFeeTab(
      {Key? key, required this.walletSendEvmStore})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Observer(
              builder: (_) => EZCTextField(
                label: Strings.current.walletSendGasPriceGWEI,
                hint: '0',
                enabled: false,
                controller: TextEditingController(
                    text: walletSendEvmStore.gasPriceNumber.toString()),
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: Text(
                Strings.current.walletSendGasPriceNote,
                style:
                    EZCLabelMediumTextStyle(color: provider.themeMode.text40),
              ),
            ),
            const SizedBox(height: 16),
            Observer(
              builder: (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!walletSendEvmStore.confirmDefaultFeeSuccess) ...[
                    Text(
                      Strings.current.walletSendGasLimit,
                      style: EZCTitleLargeTextStyle(
                          color: provider.themeMode.text60),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Strings.current.walletSendGasLimitNote,
                      style: EZCLabelMediumTextStyle(
                          color: provider.themeMode.text40),
                    ),
                  ],
                  if (walletSendEvmStore.confirmDefaultFeeSuccess)
                    EZCTextField(
                      label: Strings.current.walletSendGasLimit,
                      hint: '0',
                      enabled: false,
                      controller: TextEditingController(
                          text: walletSendEvmStore.gasLimit.toString()),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Observer(
              builder: (_) => walletSendEvmStore.confirmDefaultFeeSuccess
                  ? Column(
                      children: [
                        WalletSendHorizontalText(
                          title: Strings.current.sharedTransactionFee,
                          content:
                              '${walletSendEvmStore.defaultFee.toLocaleString(decimals: 9)} $ezcSymbol',
                          rightColor: provider.themeMode.text60,
                        ),
                        const SizedBox(height: 44),
                        EZCMediumSuccessButton(
                          text: Strings.current.sharedSendTransaction,
                          width: 251,
                          onPressed: () => walletSendEvmStore.sendEvm(false),
                          isLoading: walletSendEvmStore.isDefaultFeeLoading,
                        ),
                        if (!walletSendEvmStore.isDefaultFeeLoading)
                          EZCMediumNoneButton(
                            width: 82,
                            text: Strings.current.sharedCancel,
                            textColor: provider.themeMode.text90,
                            onPressed: walletSendEvmStore.cancelDefaultFee,
                          ),
                      ],
                    )
                  : EZCMediumPrimaryButton(
                      text: Strings.current.sharedConfirm,
                      width: 185,
                      padding: const EdgeInsets.symmetric(),
                      onPressed: () => walletSendEvmStore.confirm(false),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletSendEvmCustomFeeTab extends StatefulWidget {
  final WalletSendEvmStore walletSendEvmStore;

  const _WalletSendEvmCustomFeeTab({Key? key, required this.walletSendEvmStore})
      : super(key: key);

  @override
  State<_WalletSendEvmCustomFeeTab> createState() =>
      _WalletSendEvmCustomFeeTabState();
}

class _WalletSendEvmCustomFeeTabState
    extends State<_WalletSendEvmCustomFeeTab> {
  final _gasPriceController = TextEditingController();

  final _gasLimitController = TextEditingController();

  final _nonceController = TextEditingController();

  @override
  void initState() {
    _gasPriceController.text = widget.walletSendEvmStore.customGasPriceString;
    _gasLimitController.text =
        widget.walletSendEvmStore.customGasLimit.toString();
    _nonceController.text = widget.walletSendEvmStore.nonce.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Observer(
              builder: (_) => EZCTextField(
                label: Strings.current.walletSendGasPriceGWEI,
                inputType: TextInputType.number,
                enabled: !widget.walletSendEvmStore.confirmCustomFeeSuccess,
                error: widget.walletSendEvmStore.gasPriceError,
                hint: '0',
                controller: _gasPriceController,
                onChanged: (text) {
                  widget.walletSendEvmStore.customGasPriceString = text;
                  widget.walletSendEvmStore.removeGasPriceError();
                },
              ),
            ),
            const SizedBox(height: 16),
            Observer(
              builder: (_) => EZCTextField(
                label: Strings.current.walletSendGasLimit,
                inputType: TextInputType.number,
                error: widget.walletSendEvmStore.gasLimitError,
                enabled: !widget.walletSendEvmStore.confirmCustomFeeSuccess,
                hint: '0',
                controller: _gasLimitController,
                onChanged: (text) {
                  widget.walletSendEvmStore.customGasLimit =
                      int.tryParse(text) ?? 0;
                  widget.walletSendEvmStore.removeGasLimitError();
                },
              ),
            ),
            const SizedBox(height: 16),
            Observer(
              builder: (_) => EZCTextField(
                label: Strings.current.sharedNonce,
                inputType: TextInputType.number,
                enabled: !widget.walletSendEvmStore.confirmCustomFeeSuccess,
                error: widget.walletSendEvmStore.nonceError,
                hint: '0',
                controller: _nonceController,
                onChanged: (text) {
                  widget.walletSendEvmStore.nonce = int.tryParse(text) ?? 0;
                  widget.walletSendEvmStore.removeNonceError();
                },
              ),
            ),
            const SizedBox(height: 16),
            Observer(
              builder: (_) => WalletSendHorizontalText(
                title: Strings.current.sharedTransactionFee,
                content:
                    '${widget.walletSendEvmStore.customFee.toLocaleString(decimals: 9)} $ezcSymbol',
                rightColor: provider.themeMode.text60,
              ),
            ),
            const SizedBox(height: 44),
            Observer(
              builder: (_) => widget.walletSendEvmStore.confirmCustomFeeSuccess
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        EZCMediumSuccessButton(
                          text: Strings.current.sharedSendTransaction,
                          width: 251,
                          onPressed: () =>
                              widget.walletSendEvmStore.sendEvm(true),
                          isLoading:
                              widget.walletSendEvmStore.isCustomFeeLoading,
                        ),
                        if (!widget.walletSendEvmStore.isCustomFeeLoading)
                          EZCMediumNoneButton(
                            width: 82,
                            text: Strings.current.sharedCancel,
                            textColor: provider.themeMode.text90,
                            onPressed:
                                widget.walletSendEvmStore.cancelCustomFee,
                          ),
                      ],
                    )
                  : EZCMediumPrimaryButton(
                      text: Strings.current.sharedConfirm,
                      width: 185,
                      padding: const EdgeInsets.symmetric(),
                      onPressed: () => widget.walletSendEvmStore.confirm(true),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _gasPriceController.dispose();
    _gasLimitController.dispose();
    _nonceController.dispose();
    super.dispose();
  }
}

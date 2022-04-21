// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/common/dialog/dialog_extensions.dart';
import 'package:wallet/common/router.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/features/auth/pin/verify/pin_code_verify.dart';
import 'package:wallet/features/common/constant/wallet_constant.dart';
import 'package:wallet/features/wallet/send/evm/confirm/wallet_send_evm_confirm.dart';
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

class WalletSendEvmScreen extends StatelessWidget {
  final WalletTokenItem? fromToken;

  WalletSendEvmScreen({Key? key, this.fromToken}) : super(key: key) {
    _walletSendEvmStore.setWalletToken(fromToken);
  }

  final _walletSendEvmStore = WalletSendEvmStore();
  final _amountController = TextEditingController();
  final _addressController = TextEditingController(text: receiverAddressCTest);

  @override
  Widget build(BuildContext context) {
    _walletSendEvmStore.getBalanceC();

    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EZCAppBar(
                title: Strings.current.sharedSend,
                onPressed: () {
                  context.router.pop();
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Assets.icons.icEzc64.svg(width: 32, height: 32),
                            const SizedBox(width: 8),
                            Text(
                              fromToken != null ? fromToken!.symbol : ezcSymbol,
                              style: EZCBodyLargeTextStyle(
                                  color: provider.themeMode.text),
                            ),
                            const SizedBox(width: 16),
                            const EZCChainLabelText(text: 'C-Chain'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Observer(
                          builder: (_) => EZCAddressTextField(
                            label: Strings.current.sharedSendTo,
                            hint: Strings.current.sharedPasteAddress,
                            controller: _addressController,
                            error: _walletSendEvmStore.addressError,
                            onChanged: (_) =>
                                _walletSendEvmStore.removeAddressError(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Observer(
                          builder: (_) => EZCAmountTextField(
                            label: Strings.current.sharedSetAmount,
                            hint: '0.0',
                            suffixText: Strings.current.walletSendBalance(
                                _walletSendEvmStore.balanceCString),
                            rateUsd: _walletSendEvmStore.avaxPrice,
                            error: _walletSendEvmStore.amountError,
                            onChanged: (amount) {
                              _walletSendEvmStore.amount =
                                  Decimal.tryParse(amount) ?? Decimal.zero;
                              _walletSendEvmStore.removeAmountError();
                            },
                            controller: _amountController,
                            onSuffixPressed: () {
                              _amountController.text =
                                  _walletSendEvmStore.maxAmount.toString();
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Observer(
                          builder: (_) => EZCTextField(
                            label: Strings.current.walletSendGasPriceGWEI,
                            hint: '0',
                            enabled: false,
                            controller: TextEditingController(
                                text: _walletSendEvmStore.gasPriceNumber
                                    .toString()),
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            Strings.current.walletSendGasPriceNote,
                            style: EZCLabelMediumTextStyle(
                                color: provider.themeMode.text40),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Observer(
                          builder: (_) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!_walletSendEvmStore.confirmSuccess) ...[
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
                              if (_walletSendEvmStore.confirmSuccess)
                                EZCTextField(
                                  label: Strings.current.walletSendGasLimit,
                                  hint: '0',
                                  enabled: false,
                                  controller: TextEditingController(
                                      text: _walletSendEvmStore.gasLimit
                                          .toString()),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Observer(
                          builder: (_) => WalletSendHorizontalText(
                            title: Strings.current.sharedTransactionFee,
                            content: '${_walletSendEvmStore.fee} $ezcSymbol',
                            rightColor: provider.themeMode.text60,
                          ),
                        ),
                        const SizedBox(height: 100),
                        Observer(
                          builder: (_) => _walletSendEvmStore.confirmSuccess
                              ? EZCMediumSuccessButton(
                                  text: Strings.current.sharedSendTransaction,
                                  width: 251,
                                  onPressed: _onClickSendTransaction,
                                  isLoading: _walletSendEvmStore.isLoading,
                                )
                              : EZCMediumPrimaryButton(
                                  text: Strings.current.sharedConfirm,
                                  width: 185,
                                  padding: const EdgeInsets.symmetric(),
                                  onPressed: _onClickConfirm,
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
    );
  }

  void _onClickConfirm() {
    // FocusManager.instance.primaryFocus?.unfocus();
    final address = _addressController.text;
    _walletSendEvmStore.confirm(address);
  }

  void _showWarningDialog() {
    walletContext?.showWarningDialog(
      Assets.images.imgSendChainError.svg(width: 130, height: 130),
      Strings.current.walletSendCChainErrorAddress,
    );
  }

  Future<void> _onClickSendTransaction() async {
    final verified = await verifyPinCode();
    if (!verified) return;

    final address = _addressController.text;
    final sendSuccess = await _walletSendEvmStore.sendEvm(address);
    final symbol = fromToken != null ? fromToken!.symbol : ezcSymbol;
    if (sendSuccess) {
      walletContext?.router.push(
        WalletSendEvmConfirmRoute(
          transactionInfo: WalletSendEvmTransactionViewData(
              _addressController.text,
              _walletSendEvmStore.gasPriceNumber,
              _walletSendEvmStore.gasLimit,
              _walletSendEvmStore.amount,
              _walletSendEvmStore.fee,
              symbol),
        ),
      );
    }
  }
}

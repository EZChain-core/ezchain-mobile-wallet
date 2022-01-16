import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/features/wallet/send/avm/confirm/wallet_send_avm_confirm.dart';
import 'package:wallet/features/wallet/send/avm/wallet_send_avm_store.dart';
import 'package:wallet/features/wallet/send/widgets/wallet_send_widgets.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/inputs.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class WalletSendAvmScreen extends StatelessWidget {
  WalletSendAvmScreen({Key? key}) : super(key: key);

  final _walletSendAvmStore = WalletSendAvmStore();
  final _addressController = TextEditingController(
      text: 'X-fuji129sdwasyyvdlqqsg8d9pguvzlqvup6cmtd8jad');
  final _amountController = TextEditingController();
  final _memoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _walletSendAvmStore.getBalanceX();

    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: Column(
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
                            Assets.icons.icRoi.svg(),
                            const SizedBox(width: 8),
                            Text(
                              'EZC',
                              style: EZCBodyLargeTextStyle(
                                  color: provider.themeMode.text),
                            ),
                            const SizedBox(width: 16),
                            const EZCChainLabelText(text: 'X-Chain'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Observer(
                          builder: (_) => EZCAddressTextField(
                            label: Strings.current.sharedSendTo,
                            hint: Strings.current.sharedPasteAddress,
                            controller: _addressController,
                            error: _walletSendAvmStore.addressError,
                            onChanged: (_) =>
                                _walletSendAvmStore.removeAddressError(),
                            onSuffixPressed: () {
                              context.pushRoute(const QrCodeRoute());
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Observer(
                          builder: (_) => EZCAmountTextField(
                            label: Strings.current.sharedSetAmount,
                            hint: '0.0',
                            suffixText: Strings.current.walletSendBalance(
                                _walletSendAvmStore.balanceXString),
                            rateUsd: _walletSendAvmStore.avaxPrice,
                            error: _walletSendAvmStore.amountError,
                            onChanged: (amount) {
                              _walletSendAvmStore.amount =
                                  Decimal.tryParse(amount) ?? Decimal.zero;
                              _walletSendAvmStore.removeAmountError();
                            },
                            controller: _amountController,
                            onSuffixPressed: () {
                              _amountController.text =
                                  _walletSendAvmStore.maxAmount.toString();
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        EZCTextField(
                          label: Strings.current.walletSendMemo,
                          hint: Strings.current.sharedMemo,
                          maxLines: 3,
                          controller: _memoController,
                        ),
                        const SizedBox(height: 16),
                        Observer(
                          builder: (_) => WalletSendHorizontalText(
                            title: Strings.current.sharedTransactionFee,
                            content: '${_walletSendAvmStore.fee} EZC',
                            rightColor: provider.themeMode.text60,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Observer(
                          builder: (_) => WalletSendHorizontalText(
                            title: Strings.current.sharedTotal,
                            content: '${_walletSendAvmStore.total} USD',
                            rightColor: provider.themeMode.text60,
                          ),
                        ),
                        const SizedBox(height: 157),
                        EZCMediumPrimaryButton(
                          text: Strings.current.sharedConfirm,
                          width: 185,
                          padding: const EdgeInsets.symmetric(),
                          onPressed: _onClickConfirm,
                        )
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
    final address = _addressController.text;
    if (_walletSendAvmStore.validate(address)) {
      walletContext?.router.push(
        WalletSendAvmConfirmRoute(
          transactionInfo: WalletSendAvmTransactionViewData(
            address,
            _memoController.text,
            _walletSendAvmStore.amount,
            _walletSendAvmStore.fee,
            _walletSendAvmStore.total,
          ),
        ),
      );
    }
  }
}

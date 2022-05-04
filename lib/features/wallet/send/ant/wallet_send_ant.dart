// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/common/route/router.dart';
import 'package:wallet/features/common/route/router.gr.dart';
import 'package:wallet/features/common/constant/wallet_constant.dart';
import 'package:wallet/features/wallet/send/ant/confirm/wallet_send_ant_confirm.dart';
import 'package:wallet/features/wallet/send/ant/wallet_send_ant_store.dart';
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

class WalletSendAntScreen extends StatelessWidget {
  final WalletTokenItem token;

  WalletSendAntScreen({Key? key, required this.token}) : super(key: key) {
    _walletSendAntStore.setToken(token);
  }

  final _walletSendAntStore = WalletSendAntStore();
  final _addressController = TextEditingController(text: receiverAddressXTest);
  final _amountController = TextEditingController();
  final _memoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Column(
              children: [
                EZCAppBar(
                  title: Strings.current.sharedSend,
                  onPressed: context.router.pop,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Assets.icons.icEzc64.svg(width: 32, height: 32),
                            const SizedBox(width: 8),
                            Text(
                              token.symbol,
                              style: EZCBodyLargeTextStyle(
                                  color: provider.themeMode.text),
                            ),
                            const SizedBox(width: 16),
                            EZCChainLabelText(text: token.chain),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Observer(
                          builder: (_) => EZCAddressTextField(
                            label: Strings.current.sharedSendTo,
                            hint: Strings.current.sharedPasteAddress,
                            controller: _addressController,
                            error: _walletSendAntStore.addressError,
                            onChanged: (_) =>
                                _walletSendAntStore.removeAddressError(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Observer(
                          builder: (_) => EZCAmountTextField(
                            label: Strings.current.sharedSetAmount,
                            hint: '0.0',
                            suffixText: Strings.current
                                .walletSendBalance(token.balanceText),
                            rateUsd: token.price,
                            error: _walletSendAntStore.amountError,
                            onChanged: (amount) {
                              _walletSendAntStore.amount =
                                  Decimal.tryParse(amount) ?? Decimal.zero;
                              _walletSendAntStore.removeAmountError();
                            },
                            controller: _amountController,
                            onSuffixPressed: () {
                              _amountController.text =
                                  (token.balance - _walletSendAntStore.fee)
                                      .toString();
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
                            content: '${_walletSendAntStore.fee} $ezcSymbol',
                            rightColor: provider.themeMode.text60,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Observer(
                          builder: (_) => WalletSendHorizontalText(
                            title: Strings.current.sharedTotal,
                            content: '${_walletSendAntStore.total} USD',
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onClickConfirm() {
    final address = _addressController.text;
    if (_walletSendAntStore.validate(address)) {
      walletContext?.router.push(
        WalletSendAntConfirmRoute(
          args: WalletSendAntConfirmArgs(
            token,
            address,
            _memoController.text,
            _walletSendAntStore.amount,
            _walletSendAntStore.fee,
            _walletSendAntStore.total,
          ),
        ),
      );
    }
  }
}

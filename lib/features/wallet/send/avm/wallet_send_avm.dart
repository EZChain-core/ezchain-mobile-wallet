// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:decimal/decimal.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/common/constant/wallet_constant.dart';
import 'package:wallet/features/common/route/router.dart';
import 'package:wallet/features/common/route/router.gr.dart';
import 'package:wallet/features/nft/collectible/nft_collectible_item.dart';
import 'package:wallet/features/wallet/send/avm/confirm/wallet_send_avm_confirm.dart';
import 'package:wallet/features/wallet/send/avm/nft/wallet_send_avm_nft_item.dart';
import 'package:wallet/features/wallet/send/avm/wallet_send_avm_store.dart';
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

class WalletSendAvmScreen extends StatefulWidget {
  final WalletTokenItem? fromToken;

  const WalletSendAvmScreen({Key? key, this.fromToken}) : super(key: key);

  @override
  State<WalletSendAvmScreen> createState() => _WalletSendAvmScreenState();
}

class _WalletSendAvmScreenState extends State<WalletSendAvmScreen> {
  final _walletSendAvmStore = WalletSendAvmStore();

  final _addressController = TextEditingController(text: receiverAddressXTest);

  final _amountController = TextEditingController();

  final _memoController = TextEditingController();

  @override
  void initState() {
    _walletSendAvmStore.setWalletToken(widget.fromToken);
    _walletSendAvmStore.getBalanceX();
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
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
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
                        Observer(
                          builder: (_) => SizedBox(
                            height: 130,
                            child: ListView.separated(
                              padding: const EdgeInsets.all(0),
                              itemCount: _walletSendAvmStore.nft.length + 1,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (_, index) {
                                if (index == _walletSendAvmStore.nft.length) {
                                  return _AddNftWidget(
                                    onPickNft: _walletSendAvmStore.onPickNft,
                                  );
                                }
                                return WalletSendAvmNftItemWidget(
                                    item: _walletSendAvmStore.nft[index],
                                    onDeleteNft: _walletSendAvmStore.deleteNft,
                                );
                              },
                              separatorBuilder: (_, index) =>
                                  const SizedBox(width: 12),
                            ),
                          ),
                        ),
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
                            content: '${_walletSendAvmStore.fee} $ezcSymbol',
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
                        const SizedBox(height: 70),
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

  @override
  void dispose() {
    _addressController.dispose();
    _amountController.dispose();
    _memoController.dispose();

    super.dispose();
  }

  void _onClickConfirm() {
    final address = _addressController.text;
    if (_walletSendAvmStore.validate(address)) {
      walletContext?.router.push(
        WalletSendAvmConfirmRoute(
          args: WalletSendAvmConfirmArgs(
            address,
            _memoController.text,
            _walletSendAvmStore.amount,
            _walletSendAvmStore.fee,
            _walletSendAvmStore.total,
            token: widget.fromToken,
            nft: _walletSendAvmStore.nft.toList(),
          ),
        ),
      );
    }
  }
}

class _AddNftWidget extends StatelessWidget {
  final VoidCallback onPickNft;

  const _AddNftWidget({Key? key, required this.onPickNft}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: 80,
        height: 80,
        child: Column(
          children: [
            InkWell(
              onTap: onPickNft,
              child: DottedBorder(
                color: provider.themeMode.text10,
                strokeWidth: 1,
                radius: const Radius.circular(8),
                borderType: BorderType.RRect,
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Assets.icons.icPlusGray.svg(),
                      const SizedBox(height: 4),
                      Text(
                        Strings.current.walletSendAddNFT,
                        style: EZCLabelMediumTextStyle(
                            color: provider.themeMode.text60),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

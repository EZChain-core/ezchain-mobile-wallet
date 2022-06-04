// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/ezc/wallet/asset/erc721/types.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/features/common/constant/wallet_constant.dart';
import 'package:wallet/features/wallet/send/erc721/wallet_send_erc721_store.dart';
import 'package:wallet/features/wallet/send/widgets/wallet_send_widgets.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/inputs.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class WalletSendErc721Screen extends StatefulWidget {
  final WalletSendErc721Args args;

  const WalletSendErc721Screen({Key? key, required this.args})
      : super(key: key);

  @override
  State<WalletSendErc721Screen> createState() => _WalletSendErc721ScreenState();
}

class _WalletSendErc721ScreenState extends State<WalletSendErc721Screen> {
  final _walletSendErc721Store = WalletSendErc721Store();

  final _addressController = TextEditingController(text: receiverAddressCTest);

  @override
  void initState() {
    _walletSendErc721Store.setArgs(widget.args);
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
                                widget.args.title,
                                style: EZCBodyLargeTextStyle(
                                    color: provider.themeMode.text),
                              ),
                              const SizedBox(width: 16),
                              const EZCChainLabelText(text: 'C-Chain'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Observer(
                              builder: (_) => EZCAddressTextField(
                                  label: Strings.current.sharedSendTo,
                                  hint: Strings.current.sharedPasteAddress,
                                  controller: _addressController,
                                  error: _walletSendErc721Store.addressError,
                                  enabled:
                                      !_walletSendErc721Store.confirmSuccess,
                                  onChanged: (text) {
                                    _walletSendErc721Store.address = text;
                                    _walletSendErc721Store.removeAddressError();
                                  }),
                            ),
                          ),
                          SizedBox(
                            height: 450,
                            child: _WalletSendErc721DefaultFeeTab(
                              walletSendErc721Store: _walletSendErc721Store,
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
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }
}

class _WalletSendErc721DefaultFeeTab extends StatelessWidget {
  final WalletSendErc721Store walletSendErc721Store;

  const _WalletSendErc721DefaultFeeTab(
      {Key? key, required this.walletSendErc721Store})
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
                    text: walletSendErc721Store.gasPriceNumber.toString()),
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
                  if (!walletSendErc721Store.confirmSuccess) ...[
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
                  if (walletSendErc721Store.confirmSuccess)
                    EZCTextField(
                      label: Strings.current.walletSendGasLimit,
                      hint: '0',
                      enabled: false,
                      controller: TextEditingController(
                          text: walletSendErc721Store.gasLimit.toString()),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Observer(
              builder: (_) => walletSendErc721Store.confirmSuccess
                  ? Column(
                      children: [
                        WalletSendHorizontalText(
                          title: Strings.current.sharedTransactionFee,
                          content:
                              '${walletSendErc721Store.fee.toLocaleString(decimals: 9)} $ezcSymbol',
                          rightColor: provider.themeMode.text60,
                        ),
                        const SizedBox(height: 44),
                        EZCMediumSuccessButton(
                          text: Strings.current.sharedSendTransaction,
                          width: 251,
                          onPressed: () => walletSendErc721Store.sendErc721(),
                          isLoading: walletSendErc721Store.isLoading,
                        ),
                        if (!walletSendErc721Store.isLoading)
                          EZCMediumNoneButton(
                            width: 82,
                            text: Strings.current.sharedCancel,
                            textColor: provider.themeMode.text90,
                            onPressed: walletSendErc721Store.cancelDefaultFee,
                          ),
                      ],
                    )
                  : EZCMediumPrimaryButton(
                      text: Strings.current.sharedConfirm,
                      width: 185,
                      padding: const EdgeInsets.symmetric(),
                      onPressed: () => walletSendErc721Store.confirm(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class WalletSendErc721Args {
  final Erc721Token erc721;
  final BigInt tokenId;

  WalletSendErc721Args(this.erc721, this.tokenId);

  String get title => "TOKEN ID $tokenId (${erc721.symbol})";
}

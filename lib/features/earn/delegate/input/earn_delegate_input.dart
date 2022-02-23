import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/extensions.dart';
import 'package:wallet/common/router.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/features/earn/delegate/confirm/earn_delegate_confirm.dart';
import 'package:wallet/features/earn/delegate/input/earn_delegate_input_store.dart';
import 'package:wallet/features/earn/delegate/nodes/earn_delegate_node_item.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/inputs.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class EarnDelegateInputScreen extends StatelessWidget {
  final EarnDelegateInputArgs args;

  EarnDelegateInputScreen({Key? key, required this.args}) : super(key: key);

  final _earnDelegateInputStore = EarnDelegateInputStore();
  final _addressController = TextEditingController();
  final _amountController = TextEditingController();

  final _firstDate = DateTime.now().add(const Duration(days: 14));

  late DateTime _stakingEndDate;

  @override
  Widget build(BuildContext context) {
    _stakingEndDate = _getIntDate();
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              EZCAppBar(
                title: Strings.current.sharedDelegate,
                onPressed: () {
                  context.router.pop();
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: provider.themeMode.bg,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Strings.current.sharedNodeId,
                              style: EZCTitleLargeTextStyle(
                                  color: provider.themeMode.text60),
                            ),
                            Text(
                              args.delegateItem.nodeId.useCorrectEllipsis(),
                              style: EZCTitleLargeTextStyle(
                                  color: provider.themeMode.text),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      EZCDateTimeTextField(
                        label: Strings.current.earnStakingEndDate,
                        prefixText: Strings.current.earnStakingEndDateNote,
                        initDate: _getIntDate(),
                        firstDate: _firstDate,
                        lastDate: args.endDate,
                        onChanged: (selectedDate) {
                          _stakingEndDate = selectedDate;
                        },
                      ),
                      const SizedBox(height: 16),
                      Observer(
                        builder: (_) => EZCAmountTextField(
                          label: Strings.current.earnStakeAmount,
                          hint: '0.0',
                          controller: _amountController,
                          error: _earnDelegateInputStore.amountError,
                          prefixText: Strings.current.earnStakeBalance(
                              _earnDelegateInputStore.balancePString),
                          onChanged: (amount) {
                            _earnDelegateInputStore.removeAmountError();
                          },
                          onSuffixPressed: () {
                            _amountController.text =
                                _earnDelegateInputStore.balanceP.toString();
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Observer(
                        builder: (_) => _EarnAddressTextField(
                          label: Strings.current.earnRewardAddress,
                          myAddress: _earnDelegateInputStore.addressP,
                          controller: _addressController,
                          error: _earnDelegateInputStore.addressError,
                          onChanged: (amount) {
                            _earnDelegateInputStore.removeAddressError();
                          },
                        ),
                      ),
                      const SizedBox(height: 100),
                      EZCMediumPrimaryButton(
                        text: Strings.current.sharedConfirm,
                        width: 169,
                        isLoading: false,
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
    );
  }

  _onClickConfirm() {
    final address = _addressController.text;
    final amount = Decimal.tryParse(_amountController.text) ?? Decimal.zero;
    if (_earnDelegateInputStore.validate(address, amount)) {
      walletContext?.pushRoute(EarnDelegateConfirmRoute(
          args: EarnDelegateConfirmArgs(
            args.delegateItem,
        address,
        amount,
        _stakingEndDate,
      )));
    }
  }

  DateTime _getIntDate() {
    final now = DateTime.now();
    final diffDays = args.endDate.difference(now).inDays;
    if (diffDays > 21) {
      return DateTime.now().add(const Duration(days: 21));
    }
    return _firstDate;
  }
}

class _EarnAddressTextField extends StatefulWidget {
  final String? hint;

  final TextInputType? inputType;

  final String? label;

  final String? error;

  final TextEditingController? controller;

  final VoidCallback? onSuffixPressed;

  final ValueChanged<String>? onChanged;

  final String? myAddress;

  const _EarnAddressTextField({
    Key? key,
    this.hint,
    this.inputType,
    this.label,
    this.controller,
    this.onSuffixPressed,
    this.onChanged,
    this.error,
    this.myAddress,
  }) : super(key: key);

  @override
  State<_EarnAddressTextField> createState() => _EarnAddressTextFieldState();
}

class _EarnAddressTextFieldState extends State<_EarnAddressTextField> {
  bool usedMyAddress = true;

  @override
  Widget build(BuildContext context) {
    final _hasError = widget.error != null;
    if (usedMyAddress && widget.myAddress != null) {
      widget.controller?.text = widget.myAddress!;
    }
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.label != null)
                  Text(
                    widget.label!,
                    style: EZCTitleLargeTextStyle(
                        color: provider.themeMode.text60),
                  ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (usedMyAddress) {
                        usedMyAddress = false;
                        widget.controller?.text = '';
                      } else {
                        usedMyAddress = true;
                        widget.controller?.text = widget.myAddress ?? '';
                      }
                    });
                  },
                  child: Text(
                    usedMyAddress
                        ? Strings.current.earnCustomAddress
                        : Strings.current.earnUseYourWallet,
                    style: EZCTitleLargeTextStyle(
                        color: provider.themeMode.primary),
                  ),
                )
              ],
            ),
            if (widget.label != null) const SizedBox(height: 4),
            SizedBox(
              height: 48,
              child: TextField(
                enabled: !usedMyAddress,
                style: EZCTitleLargeTextStyle(color: provider.themeMode.text),
                cursorColor: provider.themeMode.text,
                controller: widget.controller,
                onChanged: widget.onChanged,
                decoration: InputDecoration(
                  filled: usedMyAddress,
                  fillColor: provider.themeMode.text10,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  hintText: widget.hint,
                  hintStyle:
                      EZCTitleLargeTextStyle(color: provider.themeMode.text40),
                  suffixIcon: IconButton(
                    iconSize: 40,
                    icon: Row(
                      children: [
                        VerticalDivider(
                          width: 1,
                          color: provider.themeMode.text10,
                        ),
                        const SizedBox(width: 12),
                        Assets.icons.icScanBarcode.svg()
                      ],
                    ),
                    onPressed: _onClickQrScanner,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: ezcBorder,
                    borderSide: BorderSide(
                        color: _hasError
                            ? provider.themeMode.red
                            : provider.themeMode.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: ezcBorder,
                    borderSide: BorderSide(
                        color: _hasError
                            ? provider.themeMode.red
                            : provider.themeMode.borderActive),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: ezcBorder,
                    borderSide: BorderSide(color: provider.themeMode.border),
                  ),
                ),
                keyboardType: widget.inputType ?? TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
            ),
            if (_hasError) ...[
              const SizedBox(height: 4),
              Text(
                widget.error!,
                style: EZCLabelMediumTextStyle(
                    color: provider.themeMode.stateDanger),
              ),
            ]
          ],
        ),
      ),
    );
  }

  _onClickQrScanner() async {
    final address = await walletContext?.pushRoute<String>(const QrCodeRoute());
    if (address != null && widget.controller != null) {
      widget.controller!.text = address;
    }
  }
}

class EarnDelegateInputArgs {
  final EarnDelegateNodeItem delegateItem;

  EarnDelegateInputArgs(this.delegateItem);

  DateTime get endDate =>
      DateTime.fromMillisecondsSinceEpoch(delegateItem.endTime);
}

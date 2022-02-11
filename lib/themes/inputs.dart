import 'dart:ui';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/extensions.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

const ezcBorder = BorderRadius.all(Radius.circular(8));

class EZCTextField extends StatelessWidget {
  final String hint;

  final TextInputType? inputType;

  final String? label;

  final String? error;

  final Widget? prefixIcon;

  final Widget? suffixIcon;

  final int? maxLines;

  final TextEditingController? controller;

  final ValueChanged<String>? onChanged;

  final bool? enabled;

  const EZCTextField(
      {Key? key,
      required this.hint,
      this.inputType,
      this.label,
      this.prefixIcon,
      this.suffixIcon,
      this.controller,
      this.maxLines,
      this.onChanged,
      this.error,
      this.enabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _hasError = error != null;

    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                if (label != null)
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      label!,
                      style: EZCTitleLargeTextStyle(
                          color: provider.themeMode.text60),
                    ),
                  ),
                if (_hasError)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      error!,
                      style: EZCLabelMediumTextStyle(
                          color: provider.themeMode.stateDanger),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            TextField(
              style: EZCBodyLargeTextStyle(color: provider.themeMode.text),
              enabled: enabled,
              cursorColor: provider.themeMode.text,
              controller: controller,
              onChanged: onChanged,
              maxLines: maxLines,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(12),
                hintText: hint,
                hintStyle:
                    EZCBodyLargeTextStyle(color: provider.themeMode.text40),
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
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
              keyboardType: inputType,
              textInputAction: TextInputAction.next,
            )
          ],
        ),
      ),
    );
  }
}

class EZCAmountTextField extends StatefulWidget {
  final String? hint;

  final TextInputType? inputType;

  final String? label;

  final String? error;

  final String? prefixText;

  final String? suffixText;

  final TextEditingController? controller;

  final VoidCallback? onSuffixPressed;

  final ValueChanged<String>? onChanged;

  final Decimal? rateUsd;

  final Color? backgroundColor;

  final bool? enabled;

  const EZCAmountTextField(
      {Key? key,
      this.hint,
      this.inputType,
      this.label,
      this.controller,
      this.onSuffixPressed,
      this.prefixText,
      this.suffixText,
      this.onChanged,
      this.rateUsd,
      this.error,
      this.backgroundColor,
      this.enabled})
      : super(key: key);

  @override
  State<EZCAmountTextField> createState() => _EZCAmountTextFieldState();
}

class _EZCAmountTextFieldState extends State<EZCAmountTextField> {
  Decimal _usdValue = Decimal.zero;

  @override
  void initState() {
    widget.controller?.addListener(() {
      _onChanged(widget.controller!.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _hasError = widget.error != null;
    final hasBottomText =
        widget.prefixText != null || widget.suffixText != null;
    final hasTopText = widget.label != null || _hasError;

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
                if (_hasError)
                  Text(
                    widget.error!,
                    style: EZCLabelMediumTextStyle(
                        color: provider.themeMode.stateDanger),
                  ),
              ],
            ),
            if (hasTopText) const SizedBox(height: 4),
            SizedBox(
              height: 48,
              child: TextField(
                enabled: widget.enabled,
                style: EZCTitleLargeTextStyle(color: provider.themeMode.text),
                cursorColor: provider.themeMode.text,
                controller: widget.controller,
                decoration: InputDecoration(
                  filled: widget.backgroundColor != null,
                  fillColor: widget.backgroundColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  hintText: widget.hint,
                  hintStyle:
                      EZCTitleLargeTextStyle(color: provider.themeMode.text40),
                  suffixIcon: IconButton(
                    iconSize: 50,
                    icon: Text(
                      'MAX',
                      style: EZCTitleLargeTextStyle(
                          color: provider.themeMode.text40),
                    ),
                    onPressed: widget.onSuffixPressed,
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
                keyboardType: widget.inputType ?? TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            if (hasBottomText) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.prefixText != null || widget.rateUsd != null)
                    Expanded(
                      flex: 1,
                      child: Text(
                        widget.prefixText ??
                            '\$ ${decimalToLocaleString(_usdValue, decimals: 3)}',
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: EZCLabelMediumTextStyle(
                            color: provider.themeMode.text60),
                      ),
                    ),
                  if (widget.suffixText != null) ...[
                    const SizedBox(width: 4),
                    Expanded(
                      flex: 1,
                      child: Text(
                        widget.suffixText!.useCorrectEllipsis(),
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: EZCLabelMediumTextStyle(
                            color: provider.themeMode.text60),
                      ),
                    ),
                  ]
                ],
              )
            ],
          ],
        ),
      ),
    );
  }

  void _onChanged(text) {
    if (widget.rateUsd != null) {
      final amount = Decimal.tryParse(text) ?? Decimal.zero;
      setState(() {
        _usdValue = widget.rateUsd! * amount;
      });
    }
    widget.onChanged?.call(text);
  }
}

class EZCAddressTextField extends StatelessWidget {
  final String? hint;

  final TextInputType? inputType;

  final String? label;

  final String? error;

  final TextEditingController? controller;

  final VoidCallback? onSuffixPressed;

  final ValueChanged<String>? onChanged;

  const EZCAddressTextField({
    Key? key,
    this.hint,
    this.inputType,
    this.label,
    this.controller,
    this.onSuffixPressed,
    this.onChanged,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _hasError = error != null;
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (label != null)
                  Text(
                    label!,
                    style: EZCTitleLargeTextStyle(
                        color: provider.themeMode.text60),
                  ),
                const Spacer(),
                if (_hasError)
                  Text(
                    error!,
                    style: EZCLabelMediumTextStyle(
                        color: provider.themeMode.stateDanger),
                  ),
              ],
            ),
            if (label != null) const SizedBox(height: 4),
            SizedBox(
              height: 48,
              child: TextField(
                style: EZCTitleLargeTextStyle(color: provider.themeMode.text),
                cursorColor: provider.themeMode.text,
                controller: controller,
                onChanged: onChanged,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  hintText: hint,
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
                    onPressed: () {},
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
                ),
                keyboardType: inputType ?? TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EZCDateTimeTextField extends StatelessWidget {
  final String? hint;

  final String? label;

  final String? error;

  final String? prefixText;

  final String? suffixText;

  final VoidCallback? onSuffixPressed;

  final ValueChanged<String>? onChanged;

  final Color? backgroundColor;

  final bool? enabled;

  const EZCDateTimeTextField(
      {Key? key,
      this.hint,
      this.label,
      this.onSuffixPressed,
      this.prefixText,
      this.suffixText,
      this.onChanged,
      this.error,
      this.backgroundColor,
      this.enabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _hasError = error != null;
    final hasBottomText = prefixText != null || suffixText != null;
    final hasTopText = label != null || _hasError;

    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (label != null)
                  Text(
                    label!,
                    style: EZCTitleLargeTextStyle(
                        color: provider.themeMode.text60),
                  ),
                const Spacer(),
                if (_hasError)
                  Text(
                    error!,
                    style: EZCLabelMediumTextStyle(
                        color: provider.themeMode.stateDanger),
                  ),
              ],
            ),
            if (hasTopText) const SizedBox(height: 4),
            Container(
              height: 48,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: provider.themeMode.text10)),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '',
                      style: EZCTitleLargeTextStyle(
                          color: provider.themeMode.text),
                    ),
                  ),
                  IconButton(
                    iconSize: 50,
                    icon: Text(
                      'MAX',
                      style: EZCTitleLargeTextStyle(
                          color: provider.themeMode.text40),
                    ),
                    onPressed: () {

                    },
                  ),
                ],
              ),
            ),
            if (hasBottomText) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (prefixText != null)
                    Expanded(
                      flex: 1,
                      child: Text(
                        prefixText!,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: EZCLabelMediumTextStyle(
                            color: provider.themeMode.text60),
                      ),
                    ),
                  if (suffixText != null) ...[
                    const SizedBox(width: 4),
                    Expanded(
                      flex: 1,
                      child: Text(
                        suffixText!.useCorrectEllipsis(),
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: EZCLabelMediumTextStyle(
                            color: provider.themeMode.text60),
                      ),
                    ),
                  ]
                ],
              )
            ],
          ],
        ),
      ),
    );
  }
}

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/extensions.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

const roiBorder = BorderRadius.all(Radius.circular(8));

class ROITextField extends StatefulWidget {
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

  const ROITextField(
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
  State<ROITextField> createState() => _ROITextFieldState();
}

class _ROITextFieldState extends State<ROITextField> {
  bool _hasError = false;

  @override
  void initState() {
    _hasError = widget.error != null;
    if (widget.controller != null) {
      widget.controller?.addListener(() {
        if (_hasError) {
          setState(() {
            _hasError = false;
          });
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                if (widget.label != null)
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      widget.label!,
                      style: ROITitleLargeTextStyle(
                          color: provider.themeMode.text60),
                    ),
                  ),
                if (_hasError)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      widget.error!,
                      style: ROILabelMediumTextStyle(
                          color: provider.themeMode.stateDanger),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            TextField(
              style: ROIBodyLargeTextStyle(color: provider.themeMode.text),
              enabled: widget.enabled,
              cursorColor: provider.themeMode.text,
              controller: widget.controller,
              onChanged: widget.onChanged,
              maxLines: widget.maxLines,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(12),
                hintText: widget.hint,
                hintStyle:
                    ROIBodyLargeTextStyle(color: provider.themeMode.text40),
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.suffixIcon,
                enabledBorder: OutlineInputBorder(
                  borderRadius: roiBorder,
                  borderSide: BorderSide(
                      color: _hasError
                          ? provider.themeMode.red
                          : provider.themeMode.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: roiBorder,
                  borderSide: BorderSide(
                      color: _hasError
                          ? provider.themeMode.red
                          : provider.themeMode.borderActive),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: roiBorder,
                  borderSide: BorderSide(color: provider.themeMode.border),
                ),
              ),
              keyboardType: widget.inputType,
              textInputAction: TextInputAction.next,
            )
          ],
        ),
      ),
    );
  }
}

class ROIAmountTextField extends StatefulWidget {
  final String? hint;

  final TextInputType? inputType;

  final String? label;

  final String? error;

  final String? prefixText;

  final String? suffixText;

  final TextEditingController? controller;

  final VoidCallback? onSuffixPressed;

  final ValueChanged<String>? onChanged;

  final double? rateUsd;

  final Color? backgroundColor;

  final bool? enabled;

  const ROIAmountTextField(
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
  State<ROIAmountTextField> createState() => _ROIAmountTextFieldState();
}

class _ROIAmountTextFieldState extends State<ROIAmountTextField> {
  double _usdValue = 0;
  bool _hasError = false;

  @override
  void initState() {
    widget.controller?.addListener(() {
      if (widget.rateUsd != null) {
        String text = widget.controller!.text;
        final amount = double.tryParse(text) ?? 0;
        setState(() {
          _usdValue = widget.rateUsd! * amount;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _hasError = widget.error != null;
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
                    style: ROITitleLargeTextStyle(
                        color: provider.themeMode.text60),
                  ),
                const Spacer(),
                if (_hasError)
                  Text(
                    widget.error!,
                    style: ROILabelMediumTextStyle(
                        color: provider.themeMode.stateDanger),
                  ),
              ],
            ),
            if (hasTopText) const SizedBox(height: 4),
            SizedBox(
              height: 48,
              child: TextField(
                enabled: widget.enabled,
                style: ROITitleLargeTextStyle(color: provider.themeMode.text),
                cursorColor: provider.themeMode.text,
                controller: widget.controller,
                onChanged: widget.onChanged,
                decoration: InputDecoration(
                  filled: widget.backgroundColor != null,
                  fillColor: widget.backgroundColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  hintText: widget.hint,
                  hintStyle:
                      ROITitleLargeTextStyle(color: provider.themeMode.text40),
                  suffixIcon: IconButton(
                    iconSize: 50,
                    icon: Text(
                      'MAX',
                      style: ROITitleLargeTextStyle(
                          color: provider.themeMode.text40),
                    ),
                    onPressed: widget.onSuffixPressed,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: roiBorder,
                    borderSide: BorderSide(
                        color: _hasError
                            ? provider.themeMode.red
                            : provider.themeMode.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: roiBorder,
                    borderSide: BorderSide(
                        color: _hasError
                            ? provider.themeMode.red
                            : provider.themeMode.borderActive),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: roiBorder,
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
                        widget.prefixText ?? '\$ $_usdValue',
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: ROILabelMediumTextStyle(
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
                        style: ROILabelMediumTextStyle(
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

class ROIAddressTextField extends StatelessWidget {
  final String? hint;

  final TextInputType? inputType;

  final String? label;

  final String? error;

  final TextEditingController? controller;

  final VoidCallback? onSuffixPressed;

  final ValueChanged<String>? onChanged;

  const ROIAddressTextField({
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
    print('builddddd');
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
                    style: ROITitleLargeTextStyle(
                        color: provider.themeMode.text60),
                  ),
                const Spacer(),
                if (_hasError)
                  Text(
                    error!,
                    style: ROILabelMediumTextStyle(
                        color: provider.themeMode.stateDanger),
                  ),
              ],
            ),
            if (label != null) const SizedBox(height: 4),
            SizedBox(
              height: 48,
              child: TextField(
                style: ROITitleLargeTextStyle(color: provider.themeMode.text),
                cursorColor: provider.themeMode.text,
                controller: controller,
                onChanged: onChanged,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  hintText: hint,
                  hintStyle:
                      ROITitleLargeTextStyle(color: provider.themeMode.text40),
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
                    borderRadius: roiBorder,
                    borderSide: BorderSide(
                        color: _hasError
                            ? provider.themeMode.red
                            : provider.themeMode.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: roiBorder,
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

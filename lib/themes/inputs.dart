import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

const roiBorder = BorderRadius.all(Radius.circular(8));

class ROITextField extends StatelessWidget {
  final String hint;

  final TextInputType? inputType;

  final String? label;

  final Widget? prefixIcon;

  final Widget? suffixIcon;

  final int? maxLines;

  final TextEditingController? controller;

  final ValueChanged<String>? onChanged;

  const ROITextField(
      {Key? key,
      required this.hint,
      this.inputType,
      this.label,
      this.prefixIcon,
      this.suffixIcon,
      this.controller,
      this.maxLines,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            label != null
                ? Text(
                    label!,
                    style: ROITitleLargeTextStyle(
                        color: provider.themeMode.text60),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 4),
            TextField(
              style: ROIBodyLargeTextStyle(color: provider.themeMode.text),
              cursorColor: provider.themeMode.text,
              controller: controller,
              onChanged: onChanged,
              maxLines: maxLines,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(12),
                hintText: hint,
                hintStyle:
                    ROIBodyLargeTextStyle(color: provider.themeMode.text40),
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                enabledBorder: OutlineInputBorder(
                  borderRadius: roiBorder,
                  borderSide: BorderSide(color: provider.themeMode.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: roiBorder,
                  borderSide:
                      BorderSide(color: provider.themeMode.borderActive),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: roiBorder,
                  borderSide: BorderSide(color: provider.themeMode.red),
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

class ROIAmountTextField extends StatefulWidget {
  final String? hint;

  final TextInputType? inputType;

  final String? label;

  final String? prefixText;

  final String? suffixText;

  final TextEditingController? controller;

  final VoidCallback? onSuffixPressed;

  final ValueChanged<String>? onChanged;

  final double? rateUsd;

  const ROIAmountTextField(
      {Key? key,
      this.hint,
      this.inputType,
      this.label,
      this.controller,
      this.onSuffixPressed,
      this.prefixText,
      this.suffixText,
      this.onChanged, this.rateUsd})
      : super(key: key);

  @override
  State<ROIAmountTextField> createState() => _ROIAmountTextFieldState();
}

class _ROIAmountTextFieldState extends State<ROIAmountTextField> {

  @override
  Widget build(BuildContext context) {
    final hasBottomText = widget.prefixText != null || widget.suffixText != null;
    // final amount =
    // final usdValue = widget.rateUsd != null ? (widget.rateUsd * ( ? 0) : null
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label != null)
              Text(
                widget.label!,
                style: ROITitleLargeTextStyle(color: provider.themeMode.text60),
              ),
            if (widget.label != null) const SizedBox(height: 4),
            SizedBox(
              height: 48,
              child: TextField(
                style: ROITitleLargeTextStyle(color: provider.themeMode.text),
                cursorColor: provider.themeMode.text,
                controller: widget.controller,
                onChanged: widget.onChanged,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  hintText: widget.hint,
                  hintStyle:
                      ROITitleLargeTextStyle(color: provider.themeMode.text40),
                  suffixIcon: IconButton(
                    iconSize: 40,
                    icon: Text(
                      'MAX',
                      style: ROITitleLargeTextStyle(
                          color: provider.themeMode.text40),
                    ),
                    onPressed: widget.onSuffixPressed,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: roiBorder,
                    borderSide: BorderSide(color: provider.themeMode.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: roiBorder,
                    borderSide:
                        BorderSide(color: provider.themeMode.borderActive),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: roiBorder,
                    borderSide: BorderSide(color: provider.themeMode.red),
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
                    Text(
                      widget.prefixText! ?? '\$ ',
                      style: ROILabelMediumTextStyle(
                          color: provider.themeMode.text60),
                    ),
                  if (widget.suffixText != null)
                    Text(
                      widget.suffixText!,
                      style: ROILabelMediumTextStyle(
                          color: provider.themeMode.text60),
                    ),
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null)
              Text(
                label!,
                style: ROITitleLargeTextStyle(color: provider.themeMode.text60),
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
                    borderSide: BorderSide(color: provider.themeMode.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: roiBorder,
                    borderSide:
                        BorderSide(color: provider.themeMode.borderActive),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: roiBorder,
                    borderSide: BorderSide(color: provider.themeMode.red),
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

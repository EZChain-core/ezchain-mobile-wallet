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

  const ROITextField(
      {Key? key,
      required this.hint,
      this.inputType,
      this.label,
      this.prefixIcon,
      this.suffixIcon,
      this.controller, this.maxLines})
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

class ROIAmountTextField extends StatelessWidget {
  final String? hint;

  final TextInputType? inputType;

  final String? label;

  final String? prefixText;

  final String? suffixText;

  final TextEditingController? controller;

  final VoidCallback? onSuffixPressed;

  const ROIAmountTextField(
      {Key? key,
      this.hint,
      this.inputType,
      this.label,
      this.controller,
      this.onSuffixPressed,
      this.prefixText,
      this.suffixText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasBottomText = prefixText != null || suffixText != null;
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
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  hintText: hint,
                  hintStyle:
                      ROITitleLargeTextStyle(color: provider.themeMode.text40),
                  suffixIcon: IconButton(
                    iconSize: 40,
                    icon: Text(
                      'MAX',
                      style: ROITitleLargeTextStyle(
                          color: provider.themeMode.text40),
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
                keyboardType: inputType ?? TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            if (hasBottomText) const SizedBox(height: 4),
            if (hasBottomText)
              Stack(
                children: [
                  if (prefixText != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        prefixText!,
                        style: ROILabelMediumTextStyle(
                            color: provider.themeMode.text60),
                      ),
                    ),
                  if (suffixText != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        suffixText!,
                        style: ROILabelMediumTextStyle(
                            color: provider.themeMode.text60),
                      ),
                    ),
                ],
              )
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

  const ROIAddressTextField({
    Key? key,
    this.hint,
    this.inputType,
    this.label,
    this.controller,
    this.onSuffixPressed,
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

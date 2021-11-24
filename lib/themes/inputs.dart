import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  const ROITextField({Key? key,
    required this.hint,
    this.inputType,
    this.label,
    this.prefixIcon,
    this.suffixIcon})
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
              decoration: InputDecoration(
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

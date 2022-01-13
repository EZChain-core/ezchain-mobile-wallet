import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class EZCWarningDialog extends StatelessWidget {
  final Widget image;
  final String content;

  const EZCWarningDialog({Key? key, required this.image, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 36),
              image,
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  content,
                  textAlign: TextAlign.center,
                  style: EZCHeadlineSmallTextStyle(
                      color: provider.themeMode.text70),
                ),
              ),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }
}

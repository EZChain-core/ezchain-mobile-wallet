import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/auth/pin/verify/pin_code_verify_store.dart';
import 'package:wallet/features/auth/pin/widgets/pin_code_input.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class PinCodeVerifyScreen extends StatelessWidget {
  final _pinCodeVerifyStore = PinCodeVerifyStore();

  PinCodeVerifyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                child: Text(
                  Strings.current.sharedConfirm,
                  style: EZCHeadlineMediumTextStyle(
                    color: provider.themeMode.text,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: true
                    ? const SizedBox.shrink()
                    : SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              Strings.current.pinCodeWrong,
                              style: EZCBodyMediumTextStyle(
                                color: provider.themeMode.red,
                              ),
                            ),
                            TextButton(
                              child: Text(
                                Strings.current.pinCodeSetNewPin,
                                style: EZCBodyMediumTextStyle(
                                        color: provider.themeMode.primary)
                                    .copyWith(
                                        decoration: TextDecoration.underline),
                              ),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                alignment: Alignment.topCenter,
                              ),
                              onPressed: () {
                                context.router.push(const PinCodeSetupRoute());
                              },
                            ),
                          ],
                        ),
                      ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: PinCodeInput(
                    onChanged: () {},
                    onSuccess: (String confirmPin) async {
                      final isCorrect =
                          await _pinCodeVerifyStore.isPinCorrect(confirmPin);
                      if (isCorrect) {
                        context.popRoute<bool>(true);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> verifyPinCode() async {
  return await walletContext?.pushRoute<bool>(PinCodeVerifyRoute()) ?? false;
}

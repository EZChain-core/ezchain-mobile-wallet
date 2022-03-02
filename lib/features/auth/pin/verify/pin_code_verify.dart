import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/features/auth/pin/verify/pin_code_verify_store.dart';
import 'package:wallet/features/auth/pin/widgets/pin_code_input.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

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
              EZCAppBar(
                title: Strings.current.pinCodeConfirm,
                onPressed: () {
                  context.router.pop();
                },
              ),
              Expanded(
                flex: 1,
                child: Observer(
                  builder: (_) => _pinCodeVerifyStore.isPinWrong
                      ? SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                Strings.current.pinCodeConfirmWrong,
                                style: EZCBodyMediumTextStyle(
                                  color: provider.themeMode.red,
                                ),
                              ),
                              Text(
                                Strings.current.sharedTryAgain,
                                style: EZCBodyLargeTextStyle(
                                  color: provider.themeMode.text70,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: PinCodeInput(
                    onChanged: _pinCodeVerifyStore.removeError,
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

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/auth/pin/pin_code_confirm_store.dart';
import 'package:wallet/features/auth/pin/widgets/pin_code_input.dart';
import 'package:wallet/features/common/route/router.gr.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class PinCodeConfirmScreen extends StatelessWidget {
  final String pin;

  PinCodeConfirmScreen({Key? key, required this.pin}) : super(key: key);

  final _pinCodeConfirmStore = PinCodeConfirmStore();

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
                child: Observer(
                  builder: (_) => _pinCodeConfirmStore.isPinCorrect
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
                                  context.router
                                      .push(const PinCodeSetupRoute());
                                },
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: PinCodeInput(
                    onChanged: () {
                      _pinCodeConfirmStore.setPinCorrect(true);
                    },
                    onSuccess: (String confirmPin) {
                      if (confirmPin == pin) {
                        _pinCodeConfirmStore.savePinCode(confirmPin);
                        context.router.replaceAll([const DashboardRoute()]);
                      } else {
                        _pinCodeConfirmStore.setPinCorrect(false);
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

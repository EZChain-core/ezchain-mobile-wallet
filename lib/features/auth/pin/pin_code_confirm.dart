import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/auth/pin/widgets/pin_code_input.dart';
import 'package:wallet/features/common/setting/wallet_setting.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class PinCodeConfirmScreen extends StatefulWidget {
  final String pin;

  const PinCodeConfirmScreen({Key? key, required this.pin}) : super(key: key);

  @override
  State<PinCodeConfirmScreen> createState() => _PinCodeConfirmScreenState();
}

class _PinCodeConfirmScreenState extends State<PinCodeConfirmScreen> {
  bool isPinCorrect = true;
  final _walletSetting = getIt<WalletSetting>();

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
                child: isPinCorrect
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
                    onChanged: () {
                      setState(() {
                        isPinCorrect = true;
                      });
                    },
                    onSuccess: (String confirmPin) {
                      if (confirmPin == widget.pin) {
                        _walletSetting.savePinCode(confirmPin);
                        context.router.replaceAll([const DashboardRoute()]);
                      } else {
                        setState(() {
                          isPinCorrect = false;
                        });
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

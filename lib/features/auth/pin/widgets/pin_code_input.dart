import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class PinCodeInput extends StatefulWidget {
  final Function(String pin) onSuccess;

  final VoidCallback? onChanged;

  final bool? touchIdEnabled;

  final VoidCallback? onTouchIdPressed;

  const PinCodeInput(
      {Key? key,
      required this.onSuccess,
      this.onChanged,
      this.touchIdEnabled,
      this.onTouchIdPressed})
      : super(key: key);

  @override
  State<PinCodeInput> createState() => _PinCodeInputState();
}

class _PinCodeInputState extends State<PinCodeInput> {
  final passSize = 4;
  final pin = <int>[];

  List<Widget> _buildPass() => List.generate(
      passSize, (index) => _PassCircle(isFilled: index < pin.length));

  void _addPin(int number) {
    if (pin.length >= passSize) {
      return;
    }
    if (widget.onChanged != null) {
      widget.onChanged!();
    }
    setState(() {
      pin.add(number);
    });
    if (pin.length == passSize) {
      var pinString = pin.join('');
      widget.onSuccess(pinString);
      setState(() {
        pin.clear();
      });
    }
  }

  void _removePin() {
    if (pin.isEmpty) {
      return;
    }
    setState(() {
      pin.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Wrap(
              spacing: 16,
              children: _buildPass(),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                children: [
                  _CircleDigitKey(
                      number: 1,
                      onPressed: (int number) {
                        _addPin(number);
                      }),
                  _CircleDigitKey(
                      number: 2,
                      onPressed: (int number) {
                        _addPin(number);
                      }),
                  _CircleDigitKey(
                      number: 3,
                      onPressed: (int number) {
                        _addPin(number);
                      }),
                  _CircleDigitKey(
                      number: 4,
                      onPressed: (int number) {
                        _addPin(number);
                      }),
                  _CircleDigitKey(
                      number: 5,
                      onPressed: (int number) {
                        _addPin(number);
                      }),
                  _CircleDigitKey(
                      number: 6,
                      onPressed: (int number) {
                        _addPin(number);
                      }),
                  _CircleDigitKey(
                      number: 7,
                      onPressed: (int number) {
                        _addPin(number);
                      }),
                  _CircleDigitKey(
                      number: 8,
                      onPressed: (int number) {
                        _addPin(number);
                      }),
                  _CircleDigitKey(
                      number: 9,
                      onPressed: (int number) {
                        _addPin(number);
                      }),
                  widget.touchIdEnabled == true
                      ? IconButton(
                          icon: Assets.icons.icTouchId.svg(
                            width: 56,
                            height: 56,
                          ),
                          padding: const EdgeInsets.all(0),
                          onPressed: widget.onTouchIdPressed,
                        )
                      : const SizedBox.shrink(),
                  _CircleDigitKey(
                      number: 0,
                      onPressed: (int number) {
                        _addPin(number);
                      }),
                  IconButton(
                    onPressed: _removePin,
                    padding: const EdgeInsets.all(1),
                    icon: Assets.icons.icBackspaceSecondary
                        .svg(color: provider.themeMode.secondary),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _PassCircle extends StatelessWidget {
  final bool isFilled;

  const _PassCircle({Key? key, required this.isFilled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: provider.themeMode.primary),
          color: isFilled ? provider.themeMode.primary : Colors.transparent,
        ),
      ),
    );
  }
}

class _CircleDigitKey extends StatelessWidget {
  final int number;

  final Function(int number) onPressed;

  const _CircleDigitKey(
      {Key? key, required this.number, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> textOfNumber = <String>[
      '',
      '',
      'A B C',
      'D E F',
      'G H I',
      'J K L',
      'M N O',
      'P Q R S',
      'T U V',
      'W X Y Z'
    ];

    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => TextButton(
        style: TextButton.styleFrom(
          backgroundColor: provider.themeMode.secondary10,
          padding: EdgeInsets.zero,
          shape: CircleBorder(
            side: BorderSide(width: 1, color: provider.themeMode.secondary60),
          ),
        ),
        onPressed: () {
          onPressed(number);
        },
        child: Column(
          children: [
            const SizedBox(height: 5),
            Expanded(
                child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    '$number',
                    style: EZCHeadlineSmallTextStyle(
                        color: provider.themeMode.secondary),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    textOfNumber[number],
                    style: EZCLabelSmallTextStyle(
                        color: provider.themeMode.secondary),
                  ),
                ),
              ],
            )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

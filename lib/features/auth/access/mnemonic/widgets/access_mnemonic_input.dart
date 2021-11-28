import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class AccessMnemonicInput extends StatefulWidget {
  final List<String>? phrase;

  final Function(List<String> phrases) onPhrasesChanged;

  const AccessMnemonicInput(
      {Key? key, this.phrase, required this.onPhrasesChanged})
      : super(key: key);

  @override
  State<AccessMnemonicInput> createState() => _AccessMnemonicInputState();
}

class _AccessMnemonicInputState extends State<AccessMnemonicInput> {
  final inputController = TextEditingController();
  final phrase = <String>[];
  final space = ' ';

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.phrase != null) {
      phrase.addAll(widget.phrase!);
    }
    inputController.addListener(_handlePhrases);
  }

  void _handlePhrases() {
    String text = inputController.text;
    var splits = text.split(space).where((element) => element.isNotEmpty);
    if (splits.length > 1) {
      // case paste
      phrase.addAll(splits);
      _resetState();
    } else if (text.trim().isNotEmpty & text.endsWith(space)) {
      // case ấn dấu cách
      phrase.add(text.trim());
      _resetState();
    } else if (text.isEmpty & phrase.isNotEmpty) {
      // case xóa dấu cách
      phrase.removeLast();
      _resetState();
    }
  }

  void _resetState() {
    // default thêm 1 dấu cách để detect xóa phrase
    inputController.text = space;
    inputController.selection = TextSelection.fromPosition(
        TextPosition(offset: inputController.text.length));
    setState(() {});
    widget.onPhrasesChanged(phrase);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildList() {
      var phraseWidgets = <Widget>[];
      phrase.forEachIndexed((index, word) {
        phraseWidgets.add(ROIMnemonicText(text: '${index + 1}. $word'));
      });
      phraseWidgets.add(_MnemonicTextField(
        controller: inputController,
      ));
      return phraseWidgets;
    }

    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Container(
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: provider.themeMode.border),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _buildList(),
        ),
      ),
    );
  }
}

class _MnemonicTextField extends StatelessWidget {
  final TextEditingController? controller;

  const _MnemonicTextField({Key? key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Container(
        width: 90,
        height: 32,
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          style: ROIBodySmallTextStyle(color: provider.themeMode.text),
          cursorColor: provider.themeMode.text,
          controller: controller,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
          keyboardType: TextInputType.text,
        ),
      ),
    );
  }
}

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class AccessMnemonicInput extends StatefulWidget {
  final Function(List<String> phrases) onPhrasesChanged;

  const AccessMnemonicInput({Key? key, required this.onPhrasesChanged})
      : super(key: key);

  @override
  State<AccessMnemonicInput> createState() => _AccessMnemonicInputState();
}

class _AccessMnemonicInputState extends State<AccessMnemonicInput> {
  final _inputController = TextEditingController();
  final _phrase = <String>[];
  final _space = ' ';
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _inputController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_handlePhrases);
  }

  void _handlePhrases() {
    String text = _inputController.text;
    var splits = text.split(_space).where((element) => element.isNotEmpty);
    if (splits.length > 1) {
      // case paste
      _phrase.addAll(splits);
      _resetState();
    } else if (text.trim().isNotEmpty & text.endsWith(_space)) {
      // case ấn dấu cách
      _phrase.add(text.trim());
      _resetState();
    } else if (text.isEmpty & _phrase.isNotEmpty) {
      // case xóa dấu cách
      _phrase.removeLast();
      _resetState();
    }
  }

  void _resetState() {
    // default thêm 1 dấu cách để detect xóa phrase
    _inputController.text = _space;
    _inputController.selection = TextSelection.fromPosition(
        TextPosition(offset: _inputController.text.length));
    setState(() {});
    widget.onPhrasesChanged(_phrase);
  }

  void _openKeyboard() {
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildList() {
      var phraseWidgets = <Widget>[];
      _phrase.forEachIndexed((index, word) {
        phraseWidgets.add(ROIMnemonicText(text: '${index + 1}. $word'));
      });
      phraseWidgets.add(_MnemonicTextField(
        controller: _inputController,
        focusNode: _focusNode,
      ));
      return phraseWidgets;
    }

    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => GestureDetector(
        onTap: () {
          _openKeyboard();
        },
        child: Container(
          width: double.infinity,
          height: 384,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: provider.themeMode.border),
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _buildList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _MnemonicTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const _MnemonicTextField({Key? key, this.controller, this.focusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
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
          focusNode: focusNode,
          autofocus: true,
        ),
      ),
    );
  }
}

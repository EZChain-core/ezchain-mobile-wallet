//ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/features/common/ext/extensions.dart';
import 'package:wallet/features/common/route/router.dart';
import 'package:wallet/features/common/route/router.gr.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

const ezcBorder = BorderRadius.all(Radius.circular(8));

class EZCTextField extends StatelessWidget {
  final String? hint;

  final TextInputType? inputType;

  final String? label;

  final String? error;

  final Widget? prefixIcon;

  final Widget? suffixIcon;

  final int? maxLines;

  final int? maxLength;

  final double? height;

  final double? width;

  final BorderRadius? borderRadius;

  final TextEditingController? controller;

  final ValueChanged<String>? onChanged;

  final bool? enabled;

  final TextCapitalization? textCapitalization;

  final TextInputAction? textInputAction;

  const EZCTextField({
    Key? key,
    this.hint,
    this.inputType,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.maxLines,
    this.maxLength,
    this.onChanged,
    this.error,
    this.enabled,
    this.textCapitalization,
    this.textInputAction,
    this.height, this.width, this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasError = error != null;
    final hasLabel = label != null;

    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: width ?? double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasLabel)
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      label!,
                      style: EZCTitleLargeTextStyle(
                          color: provider.themeMode.text60),
                    ),
                  ),
                  if (hasError)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        error!,
                        style: EZCLabelMediumTextStyle(
                            color: provider.themeMode.stateDanger),
                      ),
                    ),
                ],
              ),
            if (hasLabel) const SizedBox(height: 4),
            SizedBox(
              height: height ?? 48,
              child: TextField(
                style: EZCBodyLargeTextStyle(color: provider.themeMode.text),
                enabled: enabled,
                cursorColor: provider.themeMode.text,
                controller: controller,
                onChanged: onChanged,
                maxLines: maxLines,
                maxLength: maxLength,
                textCapitalization:
                    textCapitalization ?? TextCapitalization.none,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(12),
                  hintText: hint,
                  hintStyle:
                      EZCBodyLargeTextStyle(color: provider.themeMode.text40),
                  prefixIcon: prefixIcon,
                  suffixIcon: suffixIcon,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: borderRadius ?? ezcBorder,
                    borderSide: BorderSide(
                        color: hasError
                            ? provider.themeMode.red
                            : provider.themeMode.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: borderRadius ?? ezcBorder,
                    borderSide: BorderSide(
                        color: hasError
                            ? provider.themeMode.red
                            : provider.themeMode.borderActive),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: borderRadius ?? ezcBorder,
                    borderSide: BorderSide(color: provider.themeMode.border),
                  ),
                ),
                keyboardType: inputType,
                textInputAction: textInputAction ?? TextInputAction.next,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EZCAmountTextField extends StatefulWidget {
  final String? hint;

  final TextInputType? inputType;

  final String? label;

  final String? error;

  final String? prefixText;

  final String? suffixText;

  final TextEditingController? controller;

  final VoidCallback? onSuffixPressed;

  final ValueChanged<String>? onChanged;

  final Decimal? rateUsd;

  final Color? backgroundColor;

  final bool? enabled;

  const EZCAmountTextField(
      {Key? key,
      this.hint,
      this.inputType,
      this.label,
      this.controller,
      this.onSuffixPressed,
      this.prefixText,
      this.suffixText,
      this.onChanged,
      this.rateUsd,
      this.error,
      this.backgroundColor,
      this.enabled})
      : super(key: key);

  @override
  State<EZCAmountTextField> createState() => _EZCAmountTextFieldState();
}

class _EZCAmountTextFieldState extends State<EZCAmountTextField> {
  Decimal _usdValue = Decimal.zero;

  @override
  void initState() {
    widget.controller?.addListener(() {
      _onChanged(widget.controller!.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _hasError = widget.error != null;
    final hasBottomText =
        widget.prefixText != null || widget.suffixText != null;
    final hasTopText = widget.label != null || _hasError;

    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.label != null)
                  Text(
                    widget.label!,
                    style: EZCTitleLargeTextStyle(
                        color: provider.themeMode.text60),
                  ),
                const Spacer(),
                if (_hasError)
                  Text(
                    widget.error!,
                    style: EZCLabelMediumTextStyle(
                        color: provider.themeMode.stateDanger),
                  ),
              ],
            ),
            if (hasTopText) const SizedBox(height: 4),
            SizedBox(
              height: 48,
              child: TextField(
                enabled: widget.enabled,
                style: EZCTitleLargeTextStyle(color: provider.themeMode.text),
                cursorColor: provider.themeMode.text,
                controller: widget.controller,
                decoration: InputDecoration(
                  filled: widget.backgroundColor != null,
                  fillColor: widget.backgroundColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  hintText: widget.hint,
                  hintStyle:
                      EZCTitleLargeTextStyle(color: provider.themeMode.text40),
                  suffixIcon: IconButton(
                    iconSize: 50,
                    icon: Text(
                      'MAX',
                      style: EZCTitleLargeTextStyle(
                          color: provider.themeMode.text40),
                    ),
                    onPressed: widget.onSuffixPressed,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: ezcBorder,
                    borderSide: BorderSide(
                        color: _hasError
                            ? provider.themeMode.red
                            : provider.themeMode.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: ezcBorder,
                    borderSide: BorderSide(
                        color: _hasError
                            ? provider.themeMode.red
                            : provider.themeMode.borderActive),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: ezcBorder,
                    borderSide: BorderSide(color: provider.themeMode.border),
                  ),
                ),
                keyboardType: widget.inputType ?? TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            if (hasBottomText) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.prefixText != null || widget.rateUsd != null)
                    Expanded(
                      flex: 1,
                      child: Text(
                        widget.prefixText ??
                            '\$ ${_usdValue.toLocaleString(decimals: 3)}',
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: EZCLabelMediumTextStyle(
                            color: provider.themeMode.text60),
                      ),
                    ),
                  if (widget.suffixText != null) ...[
                    const SizedBox(width: 4),
                    Expanded(
                      flex: 1,
                      child: Text(
                        widget.suffixText!.useCorrectEllipsis(),
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: EZCLabelMediumTextStyle(
                            color: provider.themeMode.text60),
                      ),
                    ),
                  ]
                ],
              )
            ],
          ],
        ),
      ),
    );
  }

  void _onChanged(text) {
    if (widget.rateUsd != null) {
      final amount = Decimal.tryParse(text) ?? Decimal.zero;
      setState(() {
        _usdValue = widget.rateUsd! * amount;
      });
    }
    widget.onChanged?.call(text);
  }
}

class EZCAddressTextField extends StatelessWidget {
  final String? hint;

  final TextInputType? inputType;

  final String? label;

  final String? error;

  final TextEditingController? controller;

  final VoidCallback? onSuffixPressed;

  final ValueChanged<String>? onChanged;

  final bool? enabled;

  const EZCAddressTextField({
    Key? key,
    this.hint,
    this.inputType,
    this.label,
    this.controller,
    this.onSuffixPressed,
    this.onChanged,
    this.error,
    this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _hasError = error != null;
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (label != null)
                  Text(
                    label!,
                    style: EZCTitleLargeTextStyle(
                        color: provider.themeMode.text60),
                  ),
                const Spacer(),
                if (_hasError)
                  Text(
                    error!,
                    style: EZCLabelMediumTextStyle(
                        color: provider.themeMode.stateDanger),
                  ),
              ],
            ),
            if (label != null) const SizedBox(height: 4),
            SizedBox(
              height: 48,
              child: TextField(
                enabled: enabled,
                style: EZCTitleLargeTextStyle(color: provider.themeMode.text),
                cursorColor: provider.themeMode.text,
                controller: controller,
                onChanged: onChanged,
                decoration: InputDecoration(
                  filled: enabled == false,
                  fillColor: provider.themeMode.text10,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  hintText: hint,
                  hintStyle:
                      EZCTitleLargeTextStyle(color: provider.themeMode.text40),
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
                    onPressed: _onClickQrScanner,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: ezcBorder,
                    borderSide: BorderSide(
                        color: _hasError
                            ? provider.themeMode.red
                            : provider.themeMode.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: ezcBorder,
                    borderSide: BorderSide(
                        color: _hasError
                            ? provider.themeMode.red
                            : provider.themeMode.borderActive),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: ezcBorder,
                    borderSide: BorderSide(color: provider.themeMode.border),
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

  _onClickQrScanner() async {
    final address = await walletContext?.pushRoute<String>(const QrCodeRoute());
    if (address != null && controller != null) {
      controller!.text = address;
    }
  }
}

class EZCDateTimeTextField extends StatefulWidget {
  final String? hint;

  final String? label;

  final String? error;

  final String? prefixText;

  final String? suffixText;

  final VoidCallback? onSuffixPressed;

  final ValueChanged<DateTime>? onChanged;

  final Color? backgroundColor;

  final bool? enabled;

  final DateTime? initDate;

  final DateTime? firstDate;

  final DateTime? lastDate;

  const EZCDateTimeTextField(
      {Key? key,
      this.hint,
      this.label,
      this.onSuffixPressed,
      this.prefixText,
      this.suffixText,
      this.onChanged,
      this.error,
      this.backgroundColor,
      this.enabled,
      this.initDate,
      this.firstDate,
      this.lastDate})
      : super(key: key);

  @override
  State<EZCDateTimeTextField> createState() => _EZCDateTimeTextFieldState();
}

class _EZCDateTimeTextFieldState extends State<EZCDateTimeTextField> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final _hasError = widget.error != null;
    final hasBottomText =
        widget.prefixText != null || widget.suffixText != null;
    final hasTopText = widget.label != null || _hasError;
    selectedDate ??= widget.initDate ?? DateTime.now();
    widget.onChanged?.call(selectedDate!);
    final String selectedTime = selectedDate!.formatYMMdDateHoursTime();

    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.label != null)
                  Text(
                    widget.label!,
                    style: EZCTitleLargeTextStyle(
                        color: provider.themeMode.text60),
                  ),
                const Spacer(),
                if (_hasError)
                  Text(
                    widget.error!,
                    style: EZCLabelMediumTextStyle(
                        color: provider.themeMode.stateDanger),
                  ),
              ],
            ),
            if (hasTopText) const SizedBox(height: 4),
            Container(
              height: 48,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: provider.themeMode.text10)),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                          alignment: Alignment.centerLeft,
                          splashFactory: NoSplash.splashFactory),
                      child: Text(
                        selectedTime,
                        style: EZCTitleLargeTextStyle(
                            color: provider.themeMode.text),
                      ),
                      onPressed: () {
                        _showDatePicker();
                      },
                    ),
                  ),
                  IconButton(
                    iconSize: 50,
                    icon: Text(
                      'MAX',
                      style: EZCTitleLargeTextStyle(
                          color: provider.themeMode.text40),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedDate = widget.lastDate;
                      });
                    },
                  ),
                ],
              ),
            ),
            if (hasBottomText) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.prefixText != null)
                    Expanded(
                      flex: 1,
                      child: Text(
                        widget.prefixText!,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: EZCLabelMediumTextStyle(
                            color: provider.themeMode.text60),
                      ),
                    ),
                  if (widget.suffixText != null) ...[
                    const SizedBox(width: 4),
                    Expanded(
                      flex: 1,
                      child: Text(
                        widget.suffixText!.useCorrectEllipsis(),
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: EZCLabelMediumTextStyle(
                            color: provider.themeMode.text60),
                      ),
                    ),
                  ]
                ],
              )
            ],
          ],
        ),
      ),
    );
  }

  _showDatePicker() async {
    final context = walletContext;
    final initDate = selectedDate;
    final firstDate = widget.firstDate ?? DateTime.now();
    final lastDate = widget.lastDate ?? DateTime(2101);
    if (context == null || initDate == null) return;
    final DateTime? date = await showDatePicker(
        context: context,
        initialDate: initDate,
        firstDate: firstDate,
        lastDate: lastDate);
    if (date != null) {
      final TimeOfDay? selectedTime = await showTimePicker(
        initialTime: TimeOfDay.fromDateTime(initDate),
        context: context,
      );
      if (selectedTime != null) {
        final dateTime = date.applied(selectedTime);
        if (dateTime.millisecondsSinceEpoch - firstDate.millisecondsSinceEpoch <
            0) {
          selectedDate = firstDate;
        } else if (dateTime.millisecondsSinceEpoch -
                lastDate.millisecondsSinceEpoch >
            0) {
          selectedDate = lastDate;
        } else if (dateTime != selectedDate) {
          selectedDate = dateTime;
        }
        setState(() {});
      }
    }
  }
}

class EZCSearchTextField extends StatefulWidget {
  final String? hint;

  final TextEditingController? controller;

  final ValueChanged<String>? onChanged;

  const EZCSearchTextField({
    Key? key,
    this.hint,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  State<EZCSearchTextField> createState() => _EZCSearchTextFieldState();
}

class _EZCSearchTextFieldState extends State<EZCSearchTextField> {
  TextEditingController? _controller;

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: double.infinity,
        child: TextField(
          style: EZCTitleLargeTextStyle(color: provider.themeMode.text),
          cursorColor: provider.themeMode.text,
          controller: _controller,
          onChanged: (text) {
            widget.onChanged?.call(text);
            setState(() {});
          },
          maxLines: 1,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(12),
            hintText: widget.hint,
            hintStyle: EZCTitleLargeTextStyle(color: provider.themeMode.text40),
            prefixIcon: Padding(
                padding: const EdgeInsets.all(14),
                child: Assets.icons.icSearchBlack.svg()),
            suffixIcon: _controller?.text.isNotEmpty == true
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _controller?.text = '';
                        widget.onChanged?.call('');
                      });
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Assets.icons.icClearBlack.svg()),
                  )
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: ezcBorder,
              borderSide: BorderSide(color: provider.themeMode.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: ezcBorder,
              borderSide: BorderSide(color: provider.themeMode.borderActive),
            ),
          ),
          textInputAction: TextInputAction.next,
        ),
      ),
    );
  }
}

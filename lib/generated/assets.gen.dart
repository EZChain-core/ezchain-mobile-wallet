/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// ignore_for_file: directives_ordering

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class $AssetsEnvGen {
  const $AssetsEnvGen();

  /// File path: assets/env/.env.production
  String get envProduction => 'assets/env/.env.production';

  /// File path: assets/env/.env.staging
  String get envStaging => 'assets/env/.env.staging';
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/ic_arrow_down.svg
  SvgGenImage get icArrowDown =>
      const SvgGenImage('assets/icons/ic_arrow_down.svg');

  /// File path: assets/icons/ic_arrow_up.svg
  SvgGenImage get icArrowUp =>
      const SvgGenImage('assets/icons/ic_arrow_up.svg');

  /// File path: assets/icons/ic_backspace_secondary.svg
  SvgGenImage get icBackspaceSecondary =>
      const SvgGenImage('assets/icons/ic_backspace_secondary.svg');

  /// File path: assets/icons/ic_change_pin.svg
  SvgGenImage get icChangePin =>
      const SvgGenImage('assets/icons/ic_change_pin.svg');

  /// File path: assets/icons/ic_doc_outline_black.svg
  SvgGenImage get icDocOutlineBlack =>
      const SvgGenImage('assets/icons/ic_doc_outline_black.svg');

  /// File path: assets/icons/ic_earn_outline.svg
  SvgGenImage get icEarnOutline =>
      const SvgGenImage('assets/icons/ic_earn_outline.svg');

  /// File path: assets/icons/ic_folder_ouline_black.svg
  SvgGenImage get icFolderOulineBlack =>
      const SvgGenImage('assets/icons/ic_folder_ouline_black.svg');

  /// File path: assets/icons/ic_general_setting.svg
  SvgGenImage get icGeneralSetting =>
      const SvgGenImage('assets/icons/ic_general_setting.svg');

  /// File path: assets/icons/ic_key_outline_black.svg
  SvgGenImage get icKeyOutlineBlack =>
      const SvgGenImage('assets/icons/ic_key_outline_black.svg');

  /// File path: assets/icons/ic_question.svg
  SvgGenImage get icQuestion =>
      const SvgGenImage('assets/icons/ic_question.svg');

  /// File path: assets/icons/ic_security.svg
  SvgGenImage get icSecurity =>
      const SvgGenImage('assets/icons/ic_security.svg');

  /// File path: assets/icons/ic_setting_outline.svg
  SvgGenImage get icSettingOutline =>
      const SvgGenImage('assets/icons/ic_setting_outline.svg');

  /// File path: assets/icons/ic_touch_id.svg
  SvgGenImage get icTouchId =>
      const SvgGenImage('assets/icons/ic_touch_id.svg');

  /// File path: assets/icons/ic_two_arrow.svg
  SvgGenImage get icTwoArrow =>
      const SvgGenImage('assets/icons/ic_two_arrow.svg');

  /// File path: assets/icons/ic_wallet_outline.svg
  SvgGenImage get icWalletOutline =>
      const SvgGenImage('assets/icons/ic_wallet_outline.svg');
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/img_bg_on_board.png
  AssetGenImage get imgBgOnBoard =>
      const AssetGenImage('assets/images/img_bg_on_board.png');

  /// File path: assets/images/img_bg_wallet.png
  AssetGenImage get imgBgWallet =>
      const AssetGenImage('assets/images/img_bg_wallet.png');

  /// File path: assets/images/img_logo_roi.png
  AssetGenImage get imgLogoRoi =>
      const AssetGenImage('assets/images/img_logo_roi.png');

  /// File path: assets/images/img_onboard_one.png
  AssetGenImage get imgOnboardOne =>
      const AssetGenImage('assets/images/img_onboard_one.png');

  /// File path: assets/images/img_private_key_wraning.png
  AssetGenImage get imgPrivateKeyWraning =>
      const AssetGenImage('assets/images/img_private_key_wraning.png');

  /// File path: assets/images/img_splash.png
  AssetGenImage get imgSplash =>
      const AssetGenImage('assets/images/img_splash.png');

  /// File path: assets/images/img_warning.svg
  SvgGenImage get imgWarning =>
      const SvgGenImage('assets/images/img_warning.svg');
}

class Assets {
  Assets._();

  static const $AssetsEnvGen env = $AssetsEnvGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName) : super(assetName);

  Image image({
    Key? key,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return Image(
      key: key,
      image: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
    );
  }

  String get path => assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    Color? color,
    BlendMode colorBlendMode = BlendMode.srcIn,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      color: color,
      colorBlendMode: colorBlendMode,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      clipBehavior: clipBehavior,
    );
  }

  String get path => _assetName;
}

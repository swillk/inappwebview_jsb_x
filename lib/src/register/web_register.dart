import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:inappwebview_jsb_x/inappwebview_jsb_x.dart';

import 'package:inappwebview_jsb_x/src/register/web_register_base.dart';

/// Web register
class WebRegister extends WebRegisterBase {
  ///Register event
  @override
  void registerEvent(InAppWebViewJSBridgeX jsBridge) =>
      throw UnimplementedError();

  /// Web register
  @override
  void createdRegister(
    InAppWebViewController controller,
    InAppWebViewJSBridgeX jsBridge,
  ) =>
      throw UnimplementedError();

  /// IFrame request focus
  @override
  void iFrameRequestFocus() => throw UnimplementedError();

  /// IFrame un focus
  @override
  void iFrameUnFocus() => throw UnimplementedError();

  /// default inject javascript
  @override
  Future<String> get defaultInceptJS => throw UnimplementedError();

  /// async inject javascript
  @override
  Future<String> get asyncInceptJS => throw UnimplementedError();
}

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:inappwebview_jsb_x/inappwebview_jsb_x.dart';

abstract class WebRegisterBase {
  ///Register event
  void registerEvent(InAppWebViewJSBridgeX jsBridge);

  /// Web register
  void createdRegister(
    InAppWebViewController controller,
    InAppWebViewJSBridgeX jsBridge,
  );

  /// IFrame request focus
  void iFrameRequestFocus();

  /// IFrame un focus
  void iFrameUnFocus();

  /// default inject javascript
  Future<String> get defaultInceptJS;

  /// async inject javascript
  Future<String> get asyncInceptJS;
}

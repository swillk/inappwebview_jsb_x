import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:inappwebview_jsb_x/src/inappwebview_jsb_x.dart';
import 'package:inappwebview_jsb_x/src/register/web_register_base.dart';

class WebRegister extends WebRegisterBase {
  /// Web register for native
  @override
  void createdRegister(
    InAppWebViewController controller,
    InAppWebViewJSBridgeX jsBridge,
  ) {
    controller.addJavaScriptHandler(
      handlerName: jsBridge.channelName,
      callback: (message) {
        jsBridge.onMessageReceived(message.first.toString());
      },
    );
  }

  /// IFrame request focus
  @override
  void iFrameRequestFocus() => throw UnimplementedError();

  /// IFrame un focus
  @override
  void iFrameUnFocus() => throw UnimplementedError();

  /// Register event not need implemented in native
  @override
  void registerEvent(InAppWebViewJSBridgeX jsBridge) {}

  /// default inject javascript for native
  @override
  Future<String> get defaultInceptJS => rootBundle.loadString(
      'packages/inappwebview_jsb_x/assets/javascript/native/es5.js');

  /// async inject javascript for native
  @override
  Future<String> get asyncInceptJS => rootBundle.loadString(
      'packages/inappwebview_jsb_x/assets/javascript/native/es5.js');
}

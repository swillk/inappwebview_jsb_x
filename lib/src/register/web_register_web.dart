import 'dart:html' as html;

import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:inappwebview_jsb_x/inappwebview_jsb_x.dart';

/// Web register for web not need implemented in web
void createdRegister(
  InAppWebViewController controller,
  InAppWebViewJSBridgeX jsBridge,
) {}

/// Register event for web
void registerEvent(InAppWebViewJSBridgeX jsBridge) {
  html.window.addEventListener(
    'message',
    (event) {
      final messageEvent = event as html.MessageEvent;
      final data = messageEvent.data as String;
      jsBridge.onMessageReceived(data);
    },
    true,
  );
}

/// default inject javascript for web
Future<String> get defaultInceptJS => rootBundle
    .loadString('packages/inappwebview_jsb_x/assets/javascript/web/es5.js');

/// async inject javascript for web
Future<String> get asyncInceptJS => rootBundle
    .loadString('packages/inappwebview_jsb_x/assets/javascript/web/es7.js');

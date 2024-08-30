import 'dart:html' as html;

import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:inappwebview_jsb_x/inappwebview_jsb_x.dart';
import 'package:inappwebview_jsb_x/src/register/web_register_base.dart';

class WebRegister extends WebRegisterBase {
  /// Web register for web not need implemented in web
  @override
  void createdRegister(
    InAppWebViewController controller,
    InAppWebViewJSBridgeX jsBridge,
  ) {}

  /// Register event for web
  @override
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

  /// IFrame request focus
  @override
  void iFrameRequestFocus() {
    final shadow = html.querySelector('flt-glass-pane')?.shadowRoot;
    final platformViewSlot = shadow?.querySelector('flt-platform-view-slot');
    platformViewSlot?.style.pointerEvents = 'auto';
  }

  /// IFrame un focus
  @override
  void iFrameUnFocus() {
    final shadow = html.querySelector('flt-glass-pane')?.shadowRoot;
    final platformViewSlot = shadow?.querySelector('flt-platform-view-slot');
    platformViewSlot?.style.pointerEvents = 'none';
  }

  /// default inject javascript for web
  @override
  Future<String> get defaultInceptJS => rootBundle
      .loadString('packages/inappwebview_jsb_x/assets/javascript/web/es5.js');

  /// async inject javascript for web
  @override
  Future<String> get asyncInceptJS => rootBundle
      .loadString('packages/inappwebview_jsb_x/assets/javascript/web/es7.js');
}

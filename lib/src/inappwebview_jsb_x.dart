import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:inappwebview_jsb_x/inappwebview_jsb_x.dart';
import 'package:inappwebview_jsb_x/src/register/web_register_base.dart';

export 'register/web_register.dart'
    if (dart.library.html) 'register/web_register_web.dart'
    if (dart.library.io) 'register/web_register_native.dart';

/// type def for handler
typedef WebViewJSBridgeXHandler<T extends Object?> = Future<T?> Function(
  Object? data,
);

/// InAppWebView JS Bridge version
enum WebViewXInjectJsVersion {
  /// Default JavaScript methods
  es5,

  /// Async JavaScript methods
  es7,
}

/// InAppWebView JS Bridge
class InAppWebViewJSBridgeX {
  /// InAppWebView constructor
  InAppWebViewController? controller;

  final _completers = <int, Completer<Object?>>{};
  var _completerIndex = 0;
  final _handlers = <String, WebViewJSBridgeXHandler>{};
  final WebRegister _webRegister = WebRegister();

  /// default handler
  WebViewJSBridgeXHandler? defaultHandler;

  /// channel name
  String get channelName => 'FlutterJSBridgeChannel';

  /// get web register
  WebRegisterBase get register => _webRegister;

  /// inject javascript
  Future<void> injectJavascript({
    WebViewXInjectJsVersion esVersion = WebViewXInjectJsVersion.es5,
  }) async {
    final js = esVersion == WebViewXInjectJsVersion.es5
        ? await _webRegister.defaultInceptJS
        : await _webRegister.asyncInceptJS;
    await controller?.evaluateJavascript(source: js);
    await controller?.evaluateJavascript(
      source: await rootBundle.loadString(
        'packages/inappwebview_jsb_x/assets/javascript/web_support.js',
      ),
    );
  }

  /// Register handler， handlerName is unique for each handler， if handlerName
  ///  already exists, the old handler will be replaced with the new handler
  void registerHandler(String handlerName, WebViewJSBridgeXHandler handler) {
    _handlers[handlerName] = handler;
  }

  /// Remove handler, handlerName is unique for each handler,
  /// if handlerName is not exist,
  /// nothing will be done
  void removeHandler(String handlerName) {
    _handlers.remove(handlerName);
  }

  /// onMessageReceived
  void onMessageReceived(String message) {
    final decodeStr = Uri.decodeFull(message);
    final jsonData = jsonDecode(decodeStr) as Map<String, dynamic>;
    final type = jsonData['type'] as String;
    switch (type) {
      case 'request':
        _jsCall(jsonData);
      case 'response':
      case 'error':
        _nativeCallResponse(jsonData);
      default:
        break;
    }
  }

  /// Call javascript
  Future<void> _jsCall(Map<String, dynamic> jsonData) async {
    if (jsonData.containsKey('handlerName')) {
      final handlerName = jsonData['handlerName'] as String;
      if (_handlers.containsKey(handlerName)) {
        final data = await _handlers[handlerName]?.call(jsonData['data']);
        _jsCallResponse(jsonData, data);
      } else {
        _jsCallError(jsonData);
      }
    } else {
      if (defaultHandler != null) {
        final data = await defaultHandler?.call(jsonData['data']);
        _jsCallResponse(jsonData, data);
      } else {
        _jsCallError(jsonData);
      }
    }
  }

  /// Evaluate javascript to send response
  void _jsCallResponse(Map<String, dynamic> jsonData, Object? data) {
    jsonData['type'] = 'response';
    jsonData['data'] = data;
    _evaluateJavascript(jsonData);
  }

  /// Evaluate javascript to send error
  void _jsCallError(Map<String, dynamic> jsonData) {
    jsonData['type'] = 'error';
    _evaluateJavascript(jsonData);
  }

  /// Call native
  Future<T?> callHandler<T extends Object?>(
    String handlerName, {
    Object? data,
  }) async {
    return _nativeCall<T>(handlerName: handlerName, data: data);
  }

  /// Call native with default handler
  Future<T?> send<T extends Object?>(Object data) async {
    return _nativeCall<T>(data: data);
  }

  /// Call native to evaluate javascript request methods
  Future<T?> _nativeCall<T extends Object?>({
    String? handlerName,
    Object? data,
  }) async {
    final jsonData = {
      'index': _completerIndex,
      'type': 'request',
    };
    if (data != null) {
      jsonData['data'] = data;
    }
    if (handlerName != null) {
      jsonData['handlerName'] = handlerName;
    }

    final completer = Completer<T>();
    _completers[_completerIndex] = completer;
    _completerIndex += 1;

    _evaluateJavascript(jsonData);
    return completer.future;
  }

  void _nativeCallResponse(Map<String, dynamic> jsonData) {
    final index = jsonData['index'] as int;
    final completer = _completers[index];
    _completers.remove(index);
    if (jsonData['type'] == 'response') {
      completer?.complete(jsonData['data']);
    } else {
      completer?.completeError('native call js error for request $jsonData');
    }
  }

  void _evaluateJavascript(Map<String, dynamic> jsonData) {
    final jsonStr = jsonEncode(jsonData);
    final encodeStr = Uri.encodeFull(jsonStr);
    final script = 'WebViewJavascriptBridge.nativeCall("$encodeStr")';
    controller?.evaluateJavascript(source: script);
  }
}

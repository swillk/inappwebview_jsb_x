import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:inappwebview_jsb_x/inappwebview_jsb_x.dart';
import 'package:inappwebview_jsb_x_example/js_handler/app_handler.dart';
import 'package:inappwebview_jsb_x_example/js_handler/request_handler.dart';
import 'package:url_launcher/url_launcher.dart';

typedef WebViewCreatedCallback = void Function(
  InAppWebViewController controller,
);
typedef WebViewProgressCallback = void Function(
  InAppWebViewController controller,
  int progress,
);

typedef WebViewPageCallback = void Function(
  InAppWebViewController controller,
  Uri? url,
);

class WebView extends StatefulWidget {
  const WebView({
    this.request,
    super.key,
    this.esVersion = WebViewXInjectJsVersion.es7,
    this.debug = kDebugMode,
    this.onWebViewCreated,
    this.onProgress,
    this.onPageFinished,
    this.onPageStarted,
    this.webKey,
    this.jsBridge,
    this.settings,
  });
  final URLRequest? request;
  final bool debug;
  final WebViewXInjectJsVersion esVersion;
  final Key? webKey;
  final WebViewCreatedCallback? onWebViewCreated;
  final WebViewProgressCallback? onProgress;
  final WebViewPageCallback? onPageStarted;
  final WebViewPageCallback? onPageFinished;
  final InAppWebViewJSBridgeX? jsBridge;
  final InAppWebViewSettings? settings;

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  late InAppWebViewJSBridgeX jsBridge;

  late AppHandler appHandler;
  late RequestHandler requestHandler;
  final Completer<InAppWebViewController> _controller =
      Completer<InAppWebViewController>();
  final jsHandlers = <JSBridgeHandler>[];

  late InAppWebViewSettings options;

  @override
  void initState() {
    super.initState();
    jsHandlers
      ..add(AppHandler(context, _controller))
      ..add(RequestHandler(context));
    options = widget.settings ??
        InAppWebViewSettings(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false,
          supportZoom: false,
          preferredContentMode: UserPreferredContentMode.MOBILE,
          transparentBackground: true,
          layoutAlgorithm: LayoutAlgorithm.TEXT_AUTOSIZING,
          allowsInlineMediaPlayback: true,
        );
    jsBridge = widget.jsBridge ?? InAppWebViewJSBridgeX();
    jsBridge.register.registerEvent(jsBridge);
  }

  @override
  void dispose() {
    jsBridge.controller = null;
    for (final handler in jsHandlers) {
      jsBridge.removeHandler(handler.name);
    }
    jsHandlers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        final controller = await _controller.future;
        if (await controller.canGoBack()) {
          await controller.goBack();
          return;
        }
        if (context.mounted) Navigator.of(context).pop();
      },
      child: InAppWebView(
        initialUrlRequest: widget.request,
        initialSettings: options,
        onWebViewCreated: (controller) async {
          jsBridge.register.createdRegister(controller, jsBridge);
          if (!kIsWeb) {
            controller.addJavaScriptHandler(
              handlerName: jsBridge.channelName,
              callback: (message) {
                jsBridge.onMessageReceived(message.first.toString());
              },
            );
          }

          _controller.complete(controller);

          jsBridge
            ..controller = controller
            ..defaultHandler = _defaultHandler;
          for (final handler in jsHandlers) {
            jsBridge.registerHandler(handler.name, handler.handler);
          }
          widget.onWebViewCreated?.call(controller);
        },
        shouldOverrideUrlLoading: (controller, action) async {
          final uri = action.request.url;
          if (uri == null) {
            return NavigationActionPolicy.ALLOW;
          }
          if (uri.isScheme('https') || uri.isScheme('http')) {
            return NavigationActionPolicy.ALLOW;
          }
          try {
            await launchUrl(uri);
          } catch (e) {
            debugPrint(e.toString());
          }
          return NavigationActionPolicy.CANCEL;
        },
        onNavigationResponse: (controller, navigationResponse) async {
          if (navigationResponse.response?.url
                  ?.toString()
                  .contains('__bridge_loaded__') ??
              false) {
            await jsBridge
                .injectJavascript(esVersion: widget.esVersion)
                .then((value) {
              debugPrint('inject javascript success');
            }).catchError((e) {
              debugPrint('inject javascript failed, error: $e');
            });
            return NavigationResponseAction.CANCEL;
          }
          return NavigationResponseAction.ALLOW;
        },
        onProgressChanged: (controller, progress) {
          controller.getUrl().then((value) {
            if (value.toString() != 'about:blank') {
              widget.onProgress?.call(controller, progress);
            }
          });
        },
        onLoadStart: (controller, uri) {
          widget.onPageStarted?.call(controller, uri);
        },
        onLoadStop: (controller, uri) {
          // inject javascript
          jsBridge.injectJavascript(esVersion: widget.esVersion).then((value) {
            debugPrint('inject javascript success');
          }).catchError((e) {
            debugPrint('inject javascript failed, error: $e');
          });
          if (uri.toString() != 'about:blank') {
            widget.onPageFinished?.call(controller, uri);
          }
        },
      ),
    );
  }

  Future<dynamic> _defaultHandler(dynamic data) async {
    await Future.delayed(const Duration(seconds: 1), () {});
    return 'hello world!';
  }
}

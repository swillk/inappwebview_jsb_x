import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:inappwebview_jsb_x/inappwebview_jsb_x.dart';
import 'package:inappwebview_jsb_x_example/pages/webview.dart';

class WebPage extends StatelessWidget {
  const WebPage({super.key});

  @override
  Widget build(BuildContext context) {
    final jsBridge = InAppWebViewJSBridgeX();

    Future<void> sendHello() async {
      final res = await jsBridge.send('hello from native');
      print('_sendHello res: $res');
    }

    Future<void> callJSEcho() async {
      final res =
          await jsBridge.callHandler('JSEcho', data: 'callJs from native');
      print('_callJSEcho res: $res');
    }

    Future<void> callNotExist() async {
      final res =
          await jsBridge.callHandler('NotExist', data: 'callJs from native');
      print('_callNotExist res: $res');
    }

    Future<Object?> defaultHandler(Object? data) async {
      await Future.delayed(const Duration(seconds: 1), () {});
      return '_defaultHandler res from native';
    }

    Future<Object?> nativeEchoHandler(Object? data) async {
      await Future.delayed(const Duration(seconds: 1), () {});
      return '_nativeEchoHandler res from native';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inappwebview JSB X Example'),
        centerTitle: true,
      ),
      body: Row(
        children: [
          Expanded(
            child: WebView(
              // request: URLRequest(
              //   url: WebUri('http://172.19.80.204:5500/default.html'),
              // ),
              onWebViewCreated: (controller) async {
                final html =
                    await rootBundle.loadString('assets/html/default.html');
                final baseUrl = WebUri('https://example.com/');
                unawaited(
                  controller.loadData(
                    data: html,
                    baseUrl: baseUrl,
                    historyUrl: baseUrl,
                  ),
                );
              },
              esVersion: WebViewXInjectJsVersion.es5,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Text('native'),
                TextButton(
                  onPressed: sendHello,
                  child: const Text(
                    'sendHello',
                  ),
                ),
                TextButton(
                  onPressed: callJSEcho,
                  child: const Text(
                    'callJSEcho',
                  ),
                ),
                TextButton(
                  onPressed: callNotExist,
                  child: const Text(
                    '_callNotExist',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

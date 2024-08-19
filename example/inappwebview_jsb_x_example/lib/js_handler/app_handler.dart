import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:inappwebview_jsb_x/inappwebview_jsb_x.dart';

class AppHandler extends JSBridgeHandler {
  factory AppHandler(
    BuildContext context,
    Completer<InAppWebViewController> controller,
  ) =>
      AppHandler._internal(context, controller);

  AppHandler._internal(this.context, this.controller);
  final BuildContext context;
  final Completer<InAppWebViewController> controller;

  @override
  JSBridgeXHandler get handler => (json) async {
        debugPrint('app_handler: $json');
        final bridgeData = BridgeData.fromJson(json as Map<String, dynamic>);
        final method = bridgeData.method;
        switch (method) {
          case 'getScreenInfo':
            final size = MediaQuery.of(context).size;
            final topSafeHeight = MediaQuery.of(context).viewPadding.top;
            final bottomSafeHeight = MediaQuery.of(context).viewPadding.bottom;
            return BridgeResult.success(
              data: {
                'width': size.width,
                'height': size.height,
                'topSafeHeight': topSafeHeight,
                'bottomSafeHeight': bottomSafeHeight,
              },
            );
          default:
            return BridgeResult.error();
        }
      };

  @override
  String get name => 'AppEcho';
}

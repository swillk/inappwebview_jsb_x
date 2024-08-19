import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inappwebview_jsb_x/inappwebview_jsb_x.dart';

class RequestHandler extends JSBridgeHandler {
  factory RequestHandler(BuildContext context) =>
      RequestHandler._internal(context);
  RequestHandler._internal(this.context);
  final _api = Dio();
  final BuildContext context;

  @override
  JSBridgeXHandler get handler => (json) async {
        debugPrint('RequestHandler onReceive message: $json');
        final data = BridgeData.fromJson(json as Map<String, dynamic>);
        final method = data.method;
        final path = (data.data as Map<String, dynamic>)['path'] as String?;
        final params = (data.data as Map<String, dynamic>)['params']
            as Map<String, dynamic>?;
        if (path == null || path.isEmpty) {
          return BridgeResult.error(message: 'path is empty');
        }
        switch (method) {
          case 'get':
            final response =
                await _api.get<dynamic>(path, queryParameters: params);
            return BridgeResult.success(
              data: response.data,
              message: response.statusMessage,
            );
          case 'post':
            final response = await _api.post(path, data: params);
            return BridgeResult.success(
              data: response.data,
              message: response.statusMessage,
            );
          default:
            return BridgeResult.error(message: 'method not support');
        }
      };

  @override
  String get name => 'RequestEcho';
}

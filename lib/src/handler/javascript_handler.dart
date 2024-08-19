///js bridge handler function
typedef JSBridgeXHandler = Future<dynamic> Function(dynamic data);

/// JS Bridge Handler
abstract class JSBridgeHandler {
  /// handler name
  String get name;

  /// handler function
  JSBridgeXHandler get handler;
}

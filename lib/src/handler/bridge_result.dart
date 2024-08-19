import 'package:json_annotation/json_annotation.dart';

part 'bridge_result.g.dart';

/// Bridge Result
@JsonSerializable()
class BridgeResult {
  /// Bridge Result
  BridgeResult({
    required this.code,
    this.data,
    this.message,
  });

  /// fromJson
  factory BridgeResult.fromJson(Map<String, dynamic> json) =>
      _$BridgeResultFromJson(json);

  /// success bridge result, code = 0
  factory BridgeResult.success({
    dynamic data,
    String? message,
  }) =>
      BridgeResult(code: 0, data: data);

  /// error bridge result, code = -1, message is error message, data is null
  factory BridgeResult.error({String? message}) =>
      BridgeResult(code: -1, message: message);

  /// bridget result status code, 0 is success, -1 is error, or custom specific code
  final int code;
  @JsonKey(includeIfNull: false)

  /// bridget result data
  final dynamic data;

  /// bridget result message
  @JsonKey(includeIfNull: false)
  final String? message;

  /// toJson
  Map<String, dynamic> toJson() => _$BridgeResultToJson(this);
}

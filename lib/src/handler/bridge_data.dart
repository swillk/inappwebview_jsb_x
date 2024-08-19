import 'package:json_annotation/json_annotation.dart';

part 'bridge_data.g.dart';

/// Bridge Data
@JsonSerializable()
class BridgeData {
  /// Bridge Data
  BridgeData(this.method, this.data);

  /// fromJson
  factory BridgeData.fromJson(Map<String, dynamic> json) =>
      _$BridgeDataFromJson(json);

  /// method, custom method name
  final String method;

  /// data, custom data
  final dynamic data;

  /// toJson
  Map<String, dynamic> toJson() => _$BridgeDataToJson(this);
}

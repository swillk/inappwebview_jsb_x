// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bridge_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BridgeResult _$BridgeResultFromJson(Map<String, dynamic> json) => BridgeResult(
      code: json['code'] as int,
      data: json['data'],
      message: json['message'] as String?,
    );

Map<String, dynamic> _$BridgeResultToJson(BridgeResult instance) {
  final val = <String, dynamic>{
    'code': instance.code,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('data', instance.data);
  writeNotNull('message', instance.message);
  return val;
}

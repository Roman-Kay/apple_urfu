
import 'package:json_annotation/json_annotation.dart';

part 'push_model.g.dart';

@JsonSerializable()
class PushSendModel {
  PushSendModel({
    required this.text,
    required this.userId,
    required this.readed,
  });

  final String? text;
  final String? userId;
  final bool? readed;

  factory PushSendModel.fromJson(Map<String, dynamic> json) => _$PushSendModelFromJson(json);

  Map<String, dynamic> toJson() => _$PushSendModelToJson(this);

}

@JsonSerializable()
class PushSendView {
  PushSendView({
    required this.text,
    required this.authorId,
    required this.timestamp,
    required this.userId,
    required this.readed,
    required this.id,
    required this.authorDisplayName,
  });

  final String? text;
  final String? authorId;
  final int? timestamp;
  final String? userId;
  final bool? readed;
  final String? id;
  final String? authorDisplayName;

  factory PushSendView.fromJson(Map<String, dynamic> json) => _$PushSendViewFromJson(json);

  Map<String, dynamic> toJson() => _$PushSendViewToJson(this);

}

@JsonSerializable()
class PushReadView {
  PushReadView({
    required this.readed,
  });

  final bool? readed;

  factory PushReadView.fromJson(Map<String, dynamic> json) => _$PushReadViewFromJson(json);

  Map<String, dynamic> toJson() => _$PushReadViewToJson(this);

}

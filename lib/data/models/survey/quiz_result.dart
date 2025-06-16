import 'package:json_annotation/json_annotation.dart';

part 'quiz_result.g.dart';

@JsonSerializable()
class Result {
  Result({
    this.message,
    this.color,
    this.type,
    this.comment,
    this.text,
    this.next,
    this.buttons,
    this.balls_id
  });

  final String? message;
  final String? type;
  final String? color;
  final String? comment;
  final String? text;
  final List<int>? next;
  final int? balls_id;
  final List<Button>? buttons;

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);

}

@JsonSerializable()
class Button {
  Button({
    this.title,
    this.items,
  });

  final String? title;
  final List<Item>? items;

  factory Button.fromJson(Map<String, dynamic> json) => _$ButtonFromJson(json);

  Map<String, dynamic> toJson() => _$ButtonToJson(this);

}

@JsonSerializable()
class Item {
  Item({
    this.resourceType,
    this.resourceId,
    this.resourceTitle,
    this.resourceName
  });

  @JsonKey(name: 'resource_type')
  final String? resourceType;

  @JsonKey(name: 'resource_id')
  final int? resourceId;

  @JsonKey(name: 'resource_title')
  final String? resourceTitle;

  @JsonKey(name: 'resource_name')
  final String? resourceName;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);

}

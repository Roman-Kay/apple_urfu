

import 'package:json_annotation/json_annotation.dart';

part 'activity_response.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class ClientActivityResponse{
  ClientActivityResponse({
    this.message,
    this.code,
    this.activities
});

  int? code;
  String? message;
  List<ClientActivityView>? activities;

  factory ClientActivityResponse.fromJson(Map<String, dynamic> json) => _$ClientActivityResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ClientActivityResponseToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ClientActivityView{
  ClientActivityView({
    this.durationMi,
    this.clientActivityId,
    this.activityDate,
    this.health,
    this.calories,
    this.update,
    this.create,
    this.clientId,
    this.activity
});

  ReferenceActivityView? activity;

  @JsonKey(
    name: 'activityDate',
  )
  String? activityDate;
  int? calories;

  @JsonKey(
    name: 'clientActivityId',
  )
  int? clientActivityId;

  @JsonKey(
    name: 'clientId',
  )
  int? clientId;
  String? create;

  @JsonKey(
    name: 'durationMi',
  )
  int? durationMi;
  String? health;
  String? update;

  factory ClientActivityView.fromJson(Map<String, dynamic> json) => _$ClientActivityViewFromJson(json);
  Map<String, dynamic> toJson() => _$ClientActivityViewToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ReferenceActivityView{
  ReferenceActivityView({
    this.name,
    this.id
});

  int? id;
  String? name;

  factory ReferenceActivityView.fromJson(Map<String, dynamic> json) => _$ReferenceActivityViewFromJson(json);
  Map<String, dynamic> toJson() => _$ReferenceActivityViewToJson(this);
}
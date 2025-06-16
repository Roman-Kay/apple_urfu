

import 'package:json_annotation/json_annotation.dart';

part 'create_target_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ClientTargetsUpdateRequest{
  ClientTargetsUpdateRequest({
    this.pointB,
    this.pointA,
    this.dateB,
    this.dateA,
    this.clientTargetId,
    this.targetId,
    this.completed
});

  @JsonKey(
    name: 'clientTargetId',
  )
  int? clientTargetId;
  bool? completed;

  @JsonKey(
    name: 'dateA',
  )
  String? dateA;

  @JsonKey(
    name: 'dateB',
  )
  String? dateB;

  @JsonKey(
    name: 'pointA',
  )
  int? pointA;

  @JsonKey(
    name: 'pointB',
  )
  int? pointB;

  @JsonKey(
    name: 'targetId',
  )
  int? targetId;

  factory ClientTargetsUpdateRequest.fromJson(Map<String, dynamic> json) => _$ClientTargetsUpdateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ClientTargetsUpdateRequestToJson(this);
}
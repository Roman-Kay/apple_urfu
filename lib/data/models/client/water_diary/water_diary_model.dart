

import 'package:json_annotation/json_annotation.dart';

part 'water_diary_model.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class ClientWaterView{
  ClientWaterView({
    this.id,
    this.message,
    this.update,
    this.code,
    this.clientFirstName,
    this.clientId,
    this.clientLastName,
    this.dayNorm,
    this.dayVal,
    this.val
});

  @JsonKey(
    name: 'clientFirstName',
  )
  String? clientFirstName;

  @JsonKey(
    name: 'clientId',
  )
  int? clientId;

  @JsonKey(
    name: 'clientLastName',
  )
  String? clientLastName;

  int? code;

  @JsonKey(
    name: 'dayNorm',
  )
  int? dayNorm;

  @JsonKey(
    name: 'dayVal',
  )
  int? dayVal;

  int? id;
  String? message;
  String? update;
  int? val;

  factory ClientWaterView.fromJson(Map<String, dynamic> json) => _$ClientWaterViewFromJson(json);
  Map<String, dynamic> toJson() => _$ClientWaterViewToJson(this);
}
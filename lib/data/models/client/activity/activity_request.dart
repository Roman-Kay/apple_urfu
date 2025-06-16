
import 'package:json_annotation/json_annotation.dart';

part 'activity_request.g.dart';


@JsonSerializable()
class PeriodDateRequest{
  PeriodDateRequest({
    required this.dateStart,
    required this.dateEnd
});

  String dateEnd;
  String dateStart;

  factory PeriodDateRequest.fromJson(Map<String, dynamic> json) => _$PeriodDateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PeriodDateRequestToJson(this);
}



@JsonSerializable(fieldRename: FieldRename.snake)
class ClientActivityRequest{
  ClientActivityRequest({
    this.calories,
    this.comment,
    this.health,
    this.activityDate,
    this.activityId,
    this.clientActivityId,
    this.durationMi
});

  @JsonKey(
    name: 'activityDate',
  )
  String? activityDate;

  @JsonKey(
    name: 'activityId',
  )
  int? activityId;
  int? calories;

  @JsonKey(
    name: 'clientActivityId',
  )
  int? clientActivityId;
  String? comment;

  @JsonKey(
    name: 'durationMi',
  )
  int? durationMi;
  String? health;

  factory ClientActivityRequest.fromJson(Map<String, dynamic> json) => _$ClientActivityRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ClientActivityRequestToJson(this);
}
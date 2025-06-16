
import 'package:json_annotation/json_annotation.dart';

part 'calendar_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class EventRequest{

  EventRequest({
    this.fio,
    this.expertId,
    this.eventName,
    this.eventDate,
    this.address,
    this.clientId,
    this.position,
    this.eventId,
    this.eventStatusId,
    this.firstRequest,
    this.eventFinish,
    this.description,
    this.additionally,
    this.fullDay
  });

  String? additionally;
  String? address;
  String? description;
  String? fio;
  String? position;

  @JsonKey(
    name: 'fullDay',
  )
  bool? fullDay;

  @JsonKey(
    name: 'firstRequest',
  )
  bool? firstRequest;

  @JsonKey(
    name: 'clientId',
  )
  int? clientId;

  @JsonKey(
    name: 'eventDate',
  )
  String? eventDate;

  @JsonKey(
    name: 'eventFinish',
  )
  String? eventFinish;

  @JsonKey(
    name: 'eventName',
  )
  String? eventName;

  @JsonKey(
    name: 'eventId',
  )
  int? eventId;

  @JsonKey(
    name: 'eventStatusId',
  )
  int? eventStatusId;

  @JsonKey(
    name: 'expertId',
  )
  int? expertId;

  factory EventRequest.fromJson(Map<String, dynamic> json) => _$EventRequestFromJson(json);
  Map<String, dynamic> toJson() => _$EventRequestToJson(this);

}
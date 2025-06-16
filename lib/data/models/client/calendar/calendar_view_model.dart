
import 'package:json_annotation/json_annotation.dart';

part 'calendar_view_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class EventResponse{
  EventResponse({
    required this.code,
    this.message,
    this.events
});

  int code;
  List<EventView>? events;
  String? message;

  factory EventResponse.fromJson(Map<String, dynamic> json) => _$EventResponseFromJson(json);
  Map<String, dynamic> toJson() => _$EventResponseToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class EventView{
  EventView({
    this.id,
    this.position,
    this.clientId,
    this.address,
    this.create,
    this.clientLastName,
    this.clientFirstName,
    this.update,
    this.eventDate,
    this.eventName,
    this.eventStatus,
    this.expertFirstName,
    this.expertId,
    this.fio,
    this.typeName,
    this.description,
    this.expertLastName,
    this.eventFinish,
    this.firstRequest,
    this.additionally,
    this.fullDay
  });

  String? address;
  String? create;
  String? description;
  String? additionally;

  String? fio;
  int? id;
  String? position;
  String? update;

  @JsonKey(
    name: 'fullDay',
  )
  bool? fullDay;

  @JsonKey(
    name: 'firstRequest',
  )
  bool? firstRequest;

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
    name: 'expertId',
  )
  int? expertId;

  @JsonKey(
    name: 'expertFirstName',
  )
  String? expertFirstName;

  @JsonKey(
    name: 'expertLastName',
  )
  String? expertLastName;

  @JsonKey(
    name: 'typeName',
  )
  String? typeName;


  @JsonKey(
    name: 'eventStatus',
  )
  ReferenceEventStatusView? eventStatus;


  factory EventView.fromJson(Map<String, dynamic> json) => _$EventViewFromJson(json);
  Map<String, dynamic> toJson() => _$EventViewToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ReferenceEventStatusView{
  ReferenceEventStatusView({
    this.name,
    this.id
});

  int? id;
  String? name;

  factory ReferenceEventStatusView.fromJson(Map<String, dynamic> json) => _$ReferenceEventStatusViewFromJson(json);
  Map<String, dynamic> toJson() => _$ReferenceEventStatusViewToJson(this);
}
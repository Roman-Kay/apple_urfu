
import 'package:json_annotation/json_annotation.dart';

part 'sensors_request.g.dart';


@JsonSerializable()
class CreateClientSensorsRequest{
  CreateClientSensorsRequest({
    this.healthSensorVal,
    this.clientSensorId,
    this.dateSensor,
    this.healthSensorId,
    this.insulin,
    this.health,
    this.conditions,
    this.comment
  });


  int? clientSensorId;
  String? dateSensor;
  int? healthSensorId;
  num? healthSensorVal;
  String? comment;
  String? conditions;
  String? health;
  bool? insulin;


  factory CreateClientSensorsRequest.fromJson(Map<String, dynamic> json) => _$CreateClientSensorsRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateClientSensorsRequestToJson(this);

}


@JsonSerializable(fieldRename: FieldRename.snake)
class ClientSensorHoursRequest{
  ClientSensorHoursRequest({
    this.healthSensorId,
    this.date,
    this.clientId
});

  @JsonKey(
    name: 'clientId',
  )
  int? clientId;
  String? date;

  @JsonKey(
    name: 'healthSensorId',
  )
  int? healthSensorId;

  factory ClientSensorHoursRequest.fromJson(Map<String, dynamic> json) => _$ClientSensorHoursRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ClientSensorHoursRequestToJson(this);

}


@JsonSerializable(fieldRename: FieldRename.snake)
class ClientSensorDayRequest{
  ClientSensorDayRequest({
    this.dateEnd,
    this.dateStart,
    this.healthSensorId,
    this.clientId
});

  @JsonKey(
    name: 'clientId',
  )
  int? clientId;

  @JsonKey(
    name: 'dateEnd',
  )
  String? dateEnd;

  @JsonKey(
    name: 'dateStart',
  )
  String? dateStart;

  @JsonKey(
    name: 'healthSensorId',
  )
  int? healthSensorId;

  factory ClientSensorDayRequest.fromJson(Map<String, dynamic> json) => _$ClientSensorDayRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ClientSensorDayRequestToJson(this);

}

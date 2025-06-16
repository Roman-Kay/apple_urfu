
import 'package:json_annotation/json_annotation.dart';

part 'activated_sensors.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class UpdateClientActivatedSensorsRequest{
  UpdateClientActivatedSensorsRequest({
    this.healthSensorId,
    this.active
});

  bool? active;

  @JsonKey(
    name: 'healthSensorId',
  )
  int? healthSensorId;

  factory UpdateClientActivatedSensorsRequest.fromJson(Map<String, dynamic> json) => _$UpdateClientActivatedSensorsRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateClientActivatedSensorsRequestToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ClientActivatedSensorsResponse{
  ClientActivatedSensorsResponse({
    this.code,
    this.message,
    this.activatedSensors
});

  int? code;
  String? message;

  @JsonKey(
    name: 'activatedSensors',
  )
  List<ClientActivatedSensorsView>? activatedSensors;

  factory ClientActivatedSensorsResponse.fromJson(Map<String, dynamic> json) => _$ClientActivatedSensorsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ClientActivatedSensorsResponseToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ClientActivatedSensorsView{
  ClientActivatedSensorsView({
    this.active,
    this.healthSensorId,
    this.clientId,
    this.healthSensorName
});

  @JsonKey(
    name: 'clientId',
  )
  int? clientId;

  @JsonKey(
    name: 'healthSensorId',
  )
  int? healthSensorId;

  @JsonKey(
    name: 'healthSensorName',
  )
  String? healthSensorName;
  bool? active;

  factory ClientActivatedSensorsView.fromJson(Map<String, dynamic> json) => _$ClientActivatedSensorsViewFromJson(json);
  Map<String, dynamic> toJson() => _$ClientActivatedSensorsViewToJson(this);
}
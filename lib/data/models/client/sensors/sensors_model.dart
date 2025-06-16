
import 'package:garnetbook/data/models/client/target/target_view_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sensors_model.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class ClientSensorsResponse{
  ClientSensorsResponse({
    required this.code,
    this.message,
    this.clientSensors,
    this.target,
    this.currentVal,
    this.periodRequest
});

  int code;
  String? message;

  @JsonKey(
    name: 'clientSensors',
  )
  List<ClientSensorsView>? clientSensors;

  @JsonKey(
    name: 'currentVal',
  )
  ClientSensorsView? currentVal;

  @JsonKey(
    name: 'periodRequest',
  )
  String? periodRequest;

  ClientTargetsView? target;

  factory ClientSensorsResponse.fromJson(Map<String, dynamic> json) => _$ClientSensorsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ClientSensorsResponseToJson(this);
}


@JsonSerializable()
class ClientSensorsView{
  ClientSensorsView({
    this.dateSensor,
    this.clientSensorId,
    this.healthSensorVal,
    this.clientId,
    this.healthSensor,
    this.create,
    this.update,
    this.comment,
    this.conditions,
    this.health,
    this.insulin
});


  int? clientId;
  int? clientSensorId;
  String? create;
  String? update;
  String? dateSensor;
  num? healthSensorVal;
  HealthSensorsView? healthSensor;
  String? comment;
  String? conditions;
  String? health;
  bool? insulin;

  factory ClientSensorsView.fromJson(Map<String, dynamic> json) => _$ClientSensorsViewFromJson(json);
  Map<String, dynamic> toJson() => _$ClientSensorsViewToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class HealthSensorsView{
  HealthSensorsView({
    this.id,
    this.name,
    this.unit
});

  int? id;
  String? name;
  String? unit;

  factory HealthSensorsView.fromJson(Map<String, dynamic> json) => _$HealthSensorsViewFromJson(json);
  Map<String, dynamic> toJson() => _$HealthSensorsViewToJson(this);
}

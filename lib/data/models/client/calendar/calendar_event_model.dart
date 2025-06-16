
import 'package:garnetbook/data/models/client/calendar/calendar_view_model.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'calendar_event_model.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class EventsAndIndicatorsForDayResponse{
  EventsAndIndicatorsForDayResponse({
    this.food,
    this.day,
    this.code,
    this.message,
    this.events,
    this.sensorsStep,
    this.water
});

  int? code;
  String? day;
  List<EventView>? events;
  ClientFoodOfDayView? food;
  String? message;

  @JsonKey(
    name: 'sensorsStep',
  )
  ClientSensorsStepView? sensorsStep;
  ClientWaterOfDayView? water;

  factory EventsAndIndicatorsForDayResponse.fromJson(Map<String, dynamic> json) => _$EventsAndIndicatorsForDayResponseFromJson(json);
  Map<String, dynamic> toJson() => _$EventsAndIndicatorsForDayResponseToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ClientFoodOfDayView{
  ClientFoodOfDayView({
    this.id,
    this.normCalories,
    this.periodCalories,
    this.dayCalories
});

  @JsonKey(
    name: 'dayCalories',
  )
  int? dayCalories;
  int? id;

  @JsonKey(
    name: 'normCalories',
  )
  int? normCalories;

  @JsonKey(
    name: 'periodCalories',
  )
  int? periodCalories;

  @JsonKey(
    name: 'dateFood',
  )
  String? dateFood;

  @JsonKey(
    name: 'dateFoodLoc',
  )
  String? dateFoodLoc;

  factory ClientFoodOfDayView.fromJson(Map<String, dynamic> json) => _$ClientFoodOfDayViewFromJson(json);
  Map<String, dynamic> toJson() => _$ClientFoodOfDayViewToJson(this);
}


@JsonSerializable()
class ClientSensorsStepView{
  ClientSensorsStepView({
    this.date,
    this.clientId,
    this.healthSensor,
    this.sumVal,
    this.targetVal,
    this.currentVal
});


  int? clientId;
  String? date;
  num? currentVal;
  HealthSensorsView? healthSensor;
  double? sumVal;
  int? targetVal;

  factory ClientSensorsStepView.fromJson(Map<String, dynamic> json) => _$ClientSensorsStepViewFromJson(json);
  Map<String, dynamic> toJson() => _$ClientSensorsStepViewToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ClientWaterOfDayView{
  ClientWaterOfDayView({
    this.id,
    this.date,
    this.dayTarget,
    this.dayVal,
    this.dayNorm,
    this.dateFoodLoc
});

  String? date;

  @JsonKey(
    name: 'dateFoodLoc',
  )
  String? dateFoodLoc;


  @JsonKey(
    name: 'dayNorm',
  )
  int? dayNorm;

  @JsonKey(
    name: 'dayTarget',
  )
  int? dayTarget;

  @JsonKey(
    name: 'dayVal',
  )
  int? dayVal;
  int? id;

  factory ClientWaterOfDayView.fromJson(Map<String, dynamic> json) => _$ClientWaterOfDayViewFromJson(json);
  Map<String, dynamic> toJson() => _$ClientWaterOfDayViewToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'target_view_model.g.dart';

@JsonSerializable()
class ClientTargetsView{
  ClientTargetsView({
    this.target,
    this.id,
    this.create,
    this.clientId,
    this.calories,
    this.update,
    this.clientLastName,
    this.clientFirstName,
    this.dateA,
    this.dateB,
    this.healthSensorVal,
    this.lessDays,
    this.lessPrc,
    this.pointA,
    this.pointB,
    this.pointUnit,
    this.totalDays,
    this.unitByDay,
    this.completed
});

  int? calories;
  String? clientFirstName;
  int? clientId;
  String? clientLastName;

  bool? completed;
  String? create;
  String? dateA;
  String? dateB;
  int? healthSensorVal;
  int? id;
  int? lessDays;
  int? lessPrc;

  int? pointA;
  int? pointB;
  String? pointUnit;
  int? totalDays;
  int? unitByDay;

  String? update;
  ReferenceTargetView? target;

  factory ClientTargetsView.fromJson(Map<String, dynamic> json) => _$ClientTargetsViewFromJson(json);
  Map<String, dynamic> toJson() => _$ClientTargetsViewToJson(this);
}

@JsonSerializable()
class ReferenceTargetView{
  ReferenceTargetView({
   this.pointUnit,
   this.id,
   this.name,
   this.healthSensor,
   this.targetCategory
});

  int? id;
  String? name;
  String? pointUnit;
  HealthSensorsView? healthSensor;
  ReferenceTargetCategoriesView? targetCategory;


  factory ReferenceTargetView.fromJson(Map<String, dynamic> json) => _$ReferenceTargetViewFromJson(json);
  Map<String, dynamic> toJson() => _$ReferenceTargetViewToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class HealthSensorsView{
  HealthSensorsView({
    this.name,
    this.id,
    this.unit
});

  int? id;
  String? name;
  String? unit;

  factory HealthSensorsView.fromJson(Map<String, dynamic> json) => _$HealthSensorsViewFromJson(json);
  Map<String, dynamic> toJson() => _$HealthSensorsViewToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ReferenceTargetCategoriesView{
  ReferenceTargetCategoriesView({
    this.id,
    this.name
});

  int? id;
  String? name;

  factory ReferenceTargetCategoriesView.fromJson(Map<String, dynamic> json) => _$ReferenceTargetCategoriesViewFromJson(json);
  Map<String, dynamic> toJson() => _$ReferenceTargetCategoriesViewToJson(this);
}
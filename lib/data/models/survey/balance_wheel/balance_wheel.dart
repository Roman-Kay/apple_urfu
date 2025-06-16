
import 'package:json_annotation/json_annotation.dart';

part "balance_wheel.g.dart";

@JsonSerializable()
class BalanceWheel{
  BalanceWheel({
    this.color,
    this.categoryName,
    this.id,
    this.clientId,
    this.create,
    this.grade
  });

  String? categoryName;
  int? clientId;
  String? color;
  String? create;
  int? grade;
  int? id;

  factory BalanceWheel.fromJson(Map<String, dynamic> json) => _$BalanceWheelFromJson(json);
  Map<String, dynamic> toJson() => _$BalanceWheelToJson(this);
}


@JsonSerializable()
class BalanceWheelsRequest{
  BalanceWheelsRequest({
    this.categoryName,
    this.dateEnd,
    this.dateStart
});

  String? categoryName;
  String? dateEnd;
  String? dateStart;

  factory BalanceWheelsRequest.fromJson(Map<String, dynamic> json) => _$BalanceWheelsRequestFromJson(json);
  Map<String, dynamic> toJson() => _$BalanceWheelsRequestToJson(this);
}


@JsonSerializable()
class BalanceWheelsCreateRequest{
  BalanceWheelsCreateRequest({
    this.categoryName,
    this.grade,
    this.create,
    this.color
});

  String? color;
  String? categoryName;
  String? create;
  int? grade;

  factory BalanceWheelsCreateRequest.fromJson(Map<String, dynamic> json) => _$BalanceWheelsCreateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$BalanceWheelsCreateRequestToJson(this);
}
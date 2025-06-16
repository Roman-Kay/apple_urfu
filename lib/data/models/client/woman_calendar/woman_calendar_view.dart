import 'package:json_annotation/json_annotation.dart';

part 'woman_calendar_view.g.dart';


@JsonSerializable()
class ClientPeriodView {
  ClientPeriodView({
    this.checkDate,
    this.clientFirstName,
    this.clientId,
    this.clientLastName,
    this.clientPeriodId,
    this.code,
    this.comment,
    this.create,
    this.cycleIndicator,
    this.digestion,
    this.discharge,
    this.factors,
    this.heavy,
    this.message,
    this.mood,
    this.others,
    this.period,
    this.stool,
    this.symptoms,
    this.temperature,
    this.update,
  });

  final String? checkDate;
  final String? clientFirstName;
  final int? clientId;
  final String? clientLastName;
  final int? clientPeriodId;
  final int? code;
  final String? comment;
  final String? create;
  final CycleIndicatorsView? cycleIndicator;
  final String? digestion;
  final String? discharge;
  final String? factors;
  final int? heavy;
  final String? message;
  final String? mood;
  final String? others;
  final bool? period;
  final String? stool;
  final String? symptoms;
  final int? temperature;
  final String? update;

  factory ClientPeriodView.fromJson(Map<String, dynamic> json) => _$ClientPeriodViewFromJson(json);

  Map<String, dynamic> toJson() => _$ClientPeriodViewToJson(this);

}

@JsonSerializable()
class CycleIndicatorsView {
  CycleIndicatorsView({
    this.ovulationDay,
    this.fertil,
    this.cycleDay,
    this.cycleLong,
    this.daysToNext,
    this.firstDay,
    this.firstDay2,
    this.firstDay3,
    this.firstDay4,
    this.ovulationDay2,
    this.ovulationDay3,
    this.ovulationDay4,
    this.periods
  });

  num? cycleDay;
  num? cycleLong;
  num? daysToNext;
  num? fertil;
  String? firstDay;
  String? firstDay2;
  String? firstDay3;
  String? firstDay4;
  String? ovulationDay;
  String? ovulationDay2;
  String? ovulationDay3;
  String? ovulationDay4;
  num? periods;

  factory CycleIndicatorsView.fromJson(Map<String, dynamic> json) => _$CycleIndicatorsViewFromJson(json);

  Map<String, dynamic> toJson() => _$CycleIndicatorsViewToJson(this);

}


import 'package:json_annotation/json_annotation.dart';

part 'woman_calendar_request.g.dart';

@JsonSerializable()
class WomanCalendarRequest {
  WomanCalendarRequest({
    this.checkDate,
    this.clientPeriodId,
    this.comment,
    this.digestion,
    this.discharge,
    this.factors,
    this.heavy,
    this.mood,
    this.others,
    this.period,
    this.stool,
    this.symptoms,
    this.temperature,
  });

  final String? checkDate;
  final int? clientPeriodId;
  final String? comment;
  final String? digestion;
  final String? discharge;
  final String? factors;
  final int? heavy;
  final String? mood;
  final String? others;
  final bool? period;
  final String? stool;
  final String? symptoms;
  final int? temperature;

  factory WomanCalendarRequest.fromJson(Map<String, dynamic> json) => _$WomanCalendarRequestFromJson(json);

  Map<String, dynamic> toJson() => _$WomanCalendarRequestToJson(this);

}


import 'package:garnetbook/data/models/client/woman_calendar/woman_calendar_view.dart';
import 'package:json_annotation/json_annotation.dart';

part 'woman_calendar_response.g.dart';


@JsonSerializable()
class ResponseWomenCalendarResponse{
  ResponseWomenCalendarResponse({
    this.cycleIndicator,
    this.code,
    this.message,
    this.dateCalCycle,
    this.periodView,
});

  int? code;
  CycleIndicatorsView? cycleIndicator;
  String? dateCalCycle;
  String? message;
  List<ClientPeriodView>? periodView;

  factory ResponseWomenCalendarResponse.fromJson(Map<String, dynamic> json) => _$ResponseWomenCalendarResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseWomenCalendarResponseToJson(this);
}

import 'package:garnetbook/data/models/client/calendar/calendar_event_model.dart';
import 'package:json_annotation/json_annotation.dart';

part "water_diary.g.dart";

@JsonSerializable(fieldRename: FieldRename.snake)
class ExpertClientWaterInfoResponse{
  ExpertClientWaterInfoResponse({
    this.code,
    this.message,
    this.waters
});

  int? code;
  String? message;
  List<ClientWaterOfDayView>? waters;

  factory ExpertClientWaterInfoResponse.fromJson(Map<String, dynamic> json) => _$ExpertClientWaterInfoResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertClientWaterInfoResponseToJson(this);
}
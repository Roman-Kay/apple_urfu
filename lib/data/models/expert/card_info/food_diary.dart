

import 'package:garnetbook/data/models/client/calendar/calendar_event_model.dart';
import 'package:json_annotation/json_annotation.dart';

part "food_diary.g.dart";


@JsonSerializable(fieldRename: FieldRename.snake)
class ExpertClientFoodInfoResponse{
  ExpertClientFoodInfoResponse({
    this.message,
    this.code,
    this.foods
});

  int? code;
  String? message;
  List<ClientFoodOfDayView>? foods;

  factory ExpertClientFoodInfoResponse.fromJson(Map<String, dynamic> json) => _$ExpertClientFoodInfoResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertClientFoodInfoResponseToJson(this);

}


@JsonSerializable(fieldRename: FieldRename.snake)
class ClientFoodRequestExpert{
  ClientFoodRequestExpert({
   this.clientId,
   this.dateFrom,
   this.dateBy
});

  @JsonKey(
    name: 'clientId',
  )
  int? clientId;

  @JsonKey(
    name: 'dateBy',
  )
  String? dateBy;

  @JsonKey(
    name: 'dateFrom',
  )
  String? dateFrom;

  factory ClientFoodRequestExpert.fromJson(Map<String, dynamic> json) => _$ClientFoodRequestExpertFromJson(json);
  Map<String, dynamic> toJson() => _$ClientFoodRequestExpertToJson(this);
}
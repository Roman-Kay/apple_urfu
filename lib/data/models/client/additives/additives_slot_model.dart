import 'package:json_annotation/json_annotation.dart';

part "additives_slot_model.g.dart";


@JsonSerializable()
class ClientSlotAdditivesRequest{
  ClientSlotAdditivesRequest({
    this.dayUnits,
    this.timeUnits,
    this.start,
    this.additiveStatusId,
    this.additiveId,
    this.finish
});

  int? additiveId;
  int? additiveStatusId;
  String? dayUnits;
  String? start;
  String? finish;
  String? timeUnits;


  factory ClientSlotAdditivesRequest.fromJson(Map<String, dynamic> json) => _$ClientSlotAdditivesRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ClientSlotAdditivesRequestToJson(this);

}


@JsonSerializable()
class AdditiveSlotsView{
  AdditiveSlotsView({
    this.id,
    this.update,
    this.create,
    this.needChecked,
    this.checked,
    this.clientAdditiveId,
    this.comment,
    this.clientAdditiveName
});

  bool? checked;
  int? clientAdditiveId;
  String? clientAdditiveName;
  String? create;
  int? id;
  String? needChecked;
  String? update;
  String? comment;

  factory AdditiveSlotsView.fromJson(Map<String, dynamic> json) => _$AdditiveSlotsViewFromJson(json);
  Map<String, dynamic> toJson() => _$AdditiveSlotsViewToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part "slot_view.g.dart";


@JsonSerializable(fieldRename: FieldRename.snake)
class ClientTrackerSlotsView{
  ClientTrackerSlotsView({
    this.trackerName,
    this.clientTrackerId,
    this.create,
    this.update,
    this.checked,
    this.needChecked,
    this.trackerSlotId
});

  bool? checked;

  @JsonKey(
    name: 'clientTrackerId',
  )
  int? clientTrackerId;
  String? create;

  @JsonKey(
    name: 'needChecked',
  )
  String? needChecked;

  @JsonKey(
    name: 'trackerName',
  )
  String? trackerName;

  @JsonKey(
    name: 'trackerSlotId',
  )
  int? trackerSlotId;
  String? update;

  factory ClientTrackerSlotsView.fromJson(Map<String, dynamic> json) => _$ClientTrackerSlotsViewFromJson(json);
  Map<String, dynamic> toJson() => _$ClientTrackerSlotsViewToJson(this);

}
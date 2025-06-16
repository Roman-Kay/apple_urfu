
import 'package:garnetbook/data/models/client/trackers/slot_view.dart';
import 'package:json_annotation/json_annotation.dart';

part "tracker_response.g.dart";


@JsonSerializable(fieldRename: FieldRename.snake)
class ClientTrackerResponse{
  ClientTrackerResponse({
    this.code,
    this.message,
    this.trackers
});

  int? code;
  String? message;
  List<ClientTrackerView>? trackers;

  factory ClientTrackerResponse.fromJson(Map<String, dynamic> json) => _$ClientTrackerResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ClientTrackerResponseToJson(this);
}


@JsonSerializable()
class ClientTrackerView{
  ClientTrackerView({
    this.update,
    this.create,
    this.clientTrackerId,
    this.trackerName,
    this.duration,
    this.expertId,
    this.clientId,
    this.startDate,
    this.clientFirstName,
    this.expertLastName,
    this.expertFirstName,
    this.clientLastName,
    this.slots,
    this.trackerStatus,
    this.slotFinishQuantity,
    this.slotQuantity,
    this.dayUnits,
    this.timeUnits
});

  int? slotFinishQuantity;
  int? slotQuantity;
  String? clientFirstName;
  int? clientId;
  String? clientLastName;
  int? clientTrackerId;
  String? create;
  int? duration;
  String? expertFirstName;
  int? expertId;
  String? expertLastName;
  List<ClientTrackerSlotsView>? slots;
  String? startDate;
  String? trackerName;
  ReferenceTrackerStatusesView? trackerStatus;
  String? update;
  String? dayUnits;
  String? timeUnits;

  factory ClientTrackerView.fromJson(Map<String, dynamic> json) => _$ClientTrackerViewFromJson(json);
  Map<String, dynamic> toJson() => _$ClientTrackerViewToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ReferencePeriodicityView{
  ReferencePeriodicityView({
    this.id,
    this.name,
    this.days
});

  int? days;
  int? id;
  String? name;

  factory ReferencePeriodicityView.fromJson(Map<String, dynamic> json) => _$ReferencePeriodicityViewFromJson(json);
  Map<String, dynamic> toJson() => _$ReferencePeriodicityViewToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ReferenceTrackerStatusesView{
  ReferenceTrackerStatusesView({
    this.name,
    this.id,
    this.create
});

  String? create;
  int? id;
  String? name;

  factory ReferenceTrackerStatusesView.fromJson(Map<String, dynamic> json) => _$ReferenceTrackerStatusesViewFromJson(json);
  Map<String, dynamic> toJson() => _$ReferenceTrackerStatusesViewToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part "tracker_request.g.dart";


@JsonSerializable()
class ClientTrackerRequest{
  ClientTrackerRequest({
    this.clientId,
    this.start,
    this.expertId,
    this.duration,
    this.clientTrackerId,
    this.trackerName,
    this.trackerStatusId,
    this.timeUnits,
    this.dayUnits
});


  int? clientId;
  int? clientTrackerId;
  int? duration;
  int? expertId;
  String? start;
  String? trackerName;
  int? trackerStatusId;
  String? dayUnits;
  String? timeUnits;

  factory ClientTrackerRequest.fromJson(Map<String, dynamic> json) => _$ClientTrackerRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ClientTrackerRequestToJson(this);
}
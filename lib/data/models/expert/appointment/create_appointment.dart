
import 'package:garnetbook/data/models/expert/appointment/appointment_model.dart';
import 'package:json_annotation/json_annotation.dart';


part 'create_appointment.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CreateClientAppointmentsRequest{
  CreateClientAppointmentsRequest({
    this.sleep,
    this.ration,
    this.prescriptionType,
    this.prescriptionName,
    this.prescriptionDesc,
    this.duration,
    this.expertId,
    this.clientId,
    this.prescriptionId,
    this.prescriptionStatus
});

  @JsonKey(
    name: 'clientId',
  )
  int? clientId;
  int? duration;

  @JsonKey(
    name: 'expertId',
  )
  int? expertId;

  @JsonKey(
    name: 'prescriptionDesc',
  )
  String? prescriptionDesc;

  @JsonKey(
    name: 'prescriptionId',
  )
  int? prescriptionId;

  @JsonKey(
    name: 'prescriptionName',
  )
  String? prescriptionName;

  @JsonKey(
    name: 'prescriptionStatus',
  )
  AppointmentsStatusView? prescriptionStatus;

  @JsonKey(
    name: 'prescriptionType',
  )
  int? prescriptionType;
  String? ration;
  String? sleep;

  factory CreateClientAppointmentsRequest.fromJson(Map<String, dynamic> json) => _$CreateClientAppointmentsRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateClientAppointmentsRequestToJson(this);

}
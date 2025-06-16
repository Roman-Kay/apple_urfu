
import 'package:json_annotation/json_annotation.dart';

part 'appointment_model.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class ClientAppointmentsRequest{
  ClientAppointmentsRequest({
    this.expertId,
    this.id,
    this.clientId
});

  @JsonKey(
    name: 'clientId',
  )
  int? clientId;

  @JsonKey(
    name: 'expertId',
  )
  int? expertId;
  int? id;

  factory ClientAppointmentsRequest.fromJson(Map<String, dynamic> json) => _$ClientAppointmentsRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ClientAppointmentsRequestToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ClientAppointmentsResponse{
  ClientAppointmentsResponse({
    required this.code,
    this.message,
    this.appointment
});

  List<ClientAppointmentsView>? appointment;
  int code;
  String? message;

  factory ClientAppointmentsResponse.fromJson(Map<String, dynamic> json) => _$ClientAppointmentsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ClientAppointmentsResponseToJson(this);
}



@JsonSerializable(fieldRename: FieldRename.snake)
class ClientAppointmentsView{
  ClientAppointmentsView({
    this.id,
    this.clientId,
    this.expertId,
    this.update,
    this.create,
    this.duration,
    this.clientFirstName,
    this.clientLastName,
    this.expertFirstName,
    this.appointmentsStatus,
    this.expertLastName,
    this.prescriptionDesc,
    this.prescriptionName,
    this.prescriptionType,
    this.ration,
    this.sleep
});

  @JsonKey(
    name: 'appointmentsStatus',
  )
  AppointmentsStatusView? appointmentsStatus;

  @JsonKey(
    name: 'clientFirstName',
  )
  String? clientFirstName;

  @JsonKey(
    name: 'clientId',
  )
  int? clientId;

  @JsonKey(
    name: 'clientLastName',
  )
  String? clientLastName;
  String? create;
  int? duration;

  @JsonKey(
    name: 'expertFirstName',
  )
  String? expertFirstName;

  @JsonKey(
    name: 'expertId',
  )
  int? expertId;

  @JsonKey(
    name: 'expertLastName',
  )
  String? expertLastName;
  int? id;

  @JsonKey(
    name: 'prescriptionDesc',
  )
  String? prescriptionDesc;

  @JsonKey(
    name: 'prescriptionName',
  )
  String? prescriptionName;

  @JsonKey(
    name: 'prescriptionType',
  )
  int? prescriptionType;
  String? ration;
  String? sleep;
  String? update;

  factory ClientAppointmentsView.fromJson(Map<String, dynamic> json) => _$ClientAppointmentsViewFromJson(json);
  Map<String, dynamic> toJson() => _$ClientAppointmentsViewToJson(this);
}



@JsonSerializable(fieldRename: FieldRename.snake)
class AppointmentsStatusView{
  AppointmentsStatusView({
    this.id,
    this.name
});
  int? id;
  String? name;

  factory AppointmentsStatusView.fromJson(Map<String, dynamic> json) => _$AppointmentsStatusViewFromJson(json);
  Map<String, dynamic> toJson() => _$AppointmentsStatusViewToJson(this);
}
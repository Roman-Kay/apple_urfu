
import 'package:garnetbook/data/models/client/additives/additives_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'additives_request.g.dart';


@JsonSerializable()
class CreateClientAdditivesResponse{
  CreateClientAdditivesResponse({
    this.code,
    this.message,
    this.additive
});

  ClientAdditivesView? additive;
  int? code;
  String? message;


  factory CreateClientAdditivesResponse.fromJson(Map<String, dynamic> json) => _$CreateClientAdditivesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CreateClientAdditivesResponseToJson(this);

}


@JsonSerializable()
class ClientAdditivesRequest{
  ClientAdditivesRequest({
    this.timeUnits,
    this.source,
    this.queueNum,
    this.finish,
    this.course,
    this.comment,
    this.additiveEffect,
    this.rejectReason,
    this.start,
    this.clientId,
    this.duration,
    this.additiveId,
    this.additiveStatusId,
    this.additiveName,
    this.dose,
    this.doseUnit,
    this.expertId,
    this.queueName,
    this.protocolId,
    this.dayUnits
});

  int? additiveStatusId;
  String? additiveEffect;
  int? additiveId;
  String? additiveName;
  int? clientId;
  String? course;
  int? duration;
  int? expertId;
  String? finish;
  int? queueNum;
  String? rejectReason;
  String? comment;
  String? queueName;
  String? source;
  String? start;
  String? timeUnits;
  int? dose;
  String? doseUnit;
  int? protocolId;
  String? dayUnits;


  factory ClientAdditivesRequest.fromJson(Map<String, dynamic> json) => _$ClientAdditivesRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ClientAdditivesRequestToJson(this);
}


@JsonSerializable()
class ClientChangeStatusAdditivesRequest{
  ClientChangeStatusAdditivesRequest({
    this.additiveStatusId,
    this.additiveId
});

  int? additiveId;
  int? additiveStatusId;


  factory ClientChangeStatusAdditivesRequest.fromJson(Map<String, dynamic> json) => _$ClientChangeStatusAdditivesRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ClientChangeStatusAdditivesRequestToJson(this);
}


@JsonSerializable()
class ClientAdditivesSlotCheckRequest{
  ClientAdditivesSlotCheckRequest({
    required this.checked,
    required this.clientAdditiveId,
    required this.slotId
});

  bool checked;
  int clientAdditiveId;
  int slotId;

  factory ClientAdditivesSlotCheckRequest.fromJson(Map<String, dynamic> json) => _$ClientAdditivesSlotCheckRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ClientAdditivesSlotCheckRequestToJson(this);
}
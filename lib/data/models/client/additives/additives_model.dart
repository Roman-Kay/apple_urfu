
import 'package:garnetbook/data/models/client/additives/protocols_model.dart';
import 'package:garnetbook/data/models/expert/card_info/additives.dart';
import 'package:json_annotation/json_annotation.dart';

part 'additives_model.g.dart';


@JsonSerializable()
class MyAdditivesResponse{
  MyAdditivesResponse({
    this.code,
    this.message,
    this.expertAdditives,
    this.myAdditives
});

  int? code;
  String? message;
  List<CardClientAdditivesView>? myAdditives;
  Map<dynamic, List<CardClientAdditivesView>>? expertAdditives;

  factory MyAdditivesResponse.fromJson(Map<String, dynamic> json) => _$MyAdditivesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MyAdditivesResponseToJson(this);
}



@JsonSerializable(fieldRename: FieldRename.snake)
class ClientAdditivesResponse{
  ClientAdditivesResponse({
    required this.code,
    this.message,
    this.additives,
    this.token,
    this.protocols
});

  List<ClientAdditivesView>? additives;
  int code;
  String? message;
  String? token;
  List<ProtocolView>? protocols;

  factory ClientAdditivesResponse.fromJson(Map<String, dynamic> json) => _$ClientAdditivesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ClientAdditivesResponseToJson(this);

}


@JsonSerializable()
class ClientAdditivesView{
  ClientAdditivesView({
    this.id,
    this.expertId,
    this.update,
    this.clientLastName,
    this.clientId,
    this.create,
    this.clientFirstName,
    this.expertFirstName,
    this.duration,
    this.start,
    this.expertPosition,
    this.rejectReason,
    this.expertLastName,
    this.additiveEffect,
    this.additiveStatus,
    this.course,
    this.finish,
    this.prcProgress,
    this.queueNum,
    this.comment,
    this.source,
    this.timeUnits,
    this.dose,
    this.doseUnits,
    this.additiveName,
    this.queueName,
    this.protocolId,
    this.completed,
    this.dayUnits
});


  String? additiveName;
  String? additiveEffect;
  AdditiveStatusesView2? additiveStatus;
  String? clientFirstName;
  int? clientId;
  String? clientLastName;
  String? comment;
  bool? completed;
  String? course;
  String? create;
  int? duration;
  String? expertFirstName;
  int? expertId;
  String? expertLastName;
  String? expertPosition;
  String? finish;
  int? id;
  int? protocolId;
  int? prcProgress;
  int? queueNum;
  String? rejectReason;
  String? source;
  String? start;
  String? timeUnits;
  int? dose;
  String? doseUnits;
  String? update;
  String? queueName;
  String? dayUnits;

  factory ClientAdditivesView.fromJson(Map<String, dynamic> json) => _$ClientAdditivesViewFromJson(json);
  Map<String, dynamic> toJson() => _$ClientAdditivesViewToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class AdditiveStatusesView{
  AdditiveStatusesView({
    this.name,
    this.days,
    this.additivePeriodicityId
});

  @JsonKey(
    name: 'additivePeriodicityId',
  )
  int? additivePeriodicityId;
  int? days;
  String? name;

  factory AdditiveStatusesView.fromJson(Map<String, dynamic> json) => _$AdditiveStatusesViewFromJson(json);
  Map<String, dynamic> toJson() => _$AdditiveStatusesViewToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class AdditiveStatusesView2{
  AdditiveStatusesView2({
    this.name,
    this.additiveStatusId
});

  @JsonKey(
    name: 'additiveStatusId',
  )
  int? additiveStatusId;
  String? name;

  factory AdditiveStatusesView2.fromJson(Map<String, dynamic> json) => _$AdditiveStatusesView2FromJson(json);
  Map<String, dynamic> toJson() => _$AdditiveStatusesView2ToJson(this);
}


@JsonSerializable()
class ClientRejectAdditivesRequest{
  ClientRejectAdditivesRequest({
    this.additiveId,
    this.rejectReason
});

  int? additiveId;
  String? rejectReason;

  factory ClientRejectAdditivesRequest.fromJson(Map<String, dynamic> json) => _$ClientRejectAdditivesRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ClientRejectAdditivesRequestToJson(this);
}


@JsonSerializable()
class ClientListAdditivesRequest{
  ClientListAdditivesRequest({
    this.additiveIds
});

  List<int>? additiveIds;


  factory ClientListAdditivesRequest.fromJson(Map<String, dynamic> json) => _$ClientListAdditivesRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ClientListAdditivesRequestToJson(this);
}
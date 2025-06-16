

import 'package:garnetbook/data/models/others/file_view.dart';
import 'package:json_annotation/json_annotation.dart';

part 'claims_model.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class ClaimForExpertRequest{
  ClaimForExpertRequest({
    this.requestId
});

  @JsonKey(
    name: 'requestId',
  )
  int? requestId;

  factory ClaimForExpertRequest.fromJson(Map<String, dynamic> json) => _$ClaimForExpertRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ClaimForExpertRequestToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ClientClaimResponse{
  ClientClaimResponse({
    required this.code,
    this.message,
    this.claims
});

  int code;
  String? message;
  List<ClientClaimView>? claims;

  factory ClientClaimResponse.fromJson(Map<String, dynamic> json) => _$ClientClaimResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ClientClaimResponseToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ClientClaimView{
  ClientClaimView({
    this.anamnesis,
    this.diagnosis,
    this.id,
    this.expertId,
    this.clientId,
    this.duration,
    this.expertLastName,
    this.clientLastName,
    this.expertFirstName,
    this.clientFirstName,
    this.create,
    this.update,
    this.comment,
    this.status,
    this.reason,
    this.rejectReason,
    this.avatarExpertBase64,
    this.expertPosition
});


  @JsonKey(
    name: 'diagnosis',
  )
  String? diagnosis;


  @JsonKey(
    name: 'anamnesis',
  )
  String? anamnesis;

  @JsonKey(
    name: 'expertPosition',
  )
  String? expertPosition;

  @JsonKey(
    name: 'avatarExpertBase64',
  )
  FileView? avatarExpertBase64;

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
  String? comment;
  String? create;
  String? duration;

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
  String? reason;

  @JsonKey(
    name: 'rejectReason',
  )
  String? rejectReason;
  String? update;
  ClaimStatusView? status;

  factory ClientClaimView.fromJson(Map<String, dynamic> json) => _$ClientClaimViewFromJson(json);
  Map<String, dynamic> toJson() => _$ClientClaimViewToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ClaimStatusView{
  ClaimStatusView({
    this.id,
    this.name
});

  int? id;
  String? name;

  factory ClaimStatusView.fromJson(Map<String, dynamic> json) => _$ClaimStatusViewFromJson(json);
  Map<String, dynamic> toJson() => _$ClaimStatusViewToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class EditFieldRequest{
  EditFieldRequest({
    this.id,
    this.value,
    this.clientId
});

  int? id;

  @JsonKey(
    name: 'clientId',
  )
  int? clientId;
  String? value;

  factory EditFieldRequest.fromJson(Map<String, dynamic> json) => _$EditFieldRequestFromJson(json);
  Map<String, dynamic> toJson() => _$EditFieldRequestToJson(this);
}
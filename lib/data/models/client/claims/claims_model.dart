
import 'package:json_annotation/json_annotation.dart';

part 'claims_model.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class CreateClientClaimRequest{
  CreateClientClaimRequest({
    this.expertId,
    this.clientId,
    this.reason,
    this.comment,
    this.requestId,
    this.statusId,
    this.rejectReason,
    this.duration
});

  @JsonKey(
    name: 'clientId',
  )
  int? clientId;
  String? comment;
  String? duration;

  @JsonKey(
    name: 'expertId',
  )
  int? expertId;
  String? reason;

  @JsonKey(
    name: 'rejectReason',
  )
  String? rejectReason;

  @JsonKey(
    name: 'requestId',
  )
  int? requestId;

  @JsonKey(
    name: 'statusId',
  )
  int? statusId;

  factory CreateClientClaimRequest.fromJson(Map<String, dynamic> json) => _$CreateClientClaimRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateClientClaimRequestToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ClientClaimRequest{
  ClientClaimRequest({
    this.requestId,
    this.clientId
});

  @JsonKey(
    name: 'clientId',
  )
  int? clientId;

  @JsonKey(
    name: 'requestId',
  )
  int? requestId;

  factory ClientClaimRequest.fromJson(Map<String, dynamic> json) => _$ClientClaimRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ClientClaimRequestToJson(this);
}
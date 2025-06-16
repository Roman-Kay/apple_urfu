

import 'package:json_annotation/json_annotation.dart';

part 'client_claim_operation.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class ClaimOperationRequest{
  ClaimOperationRequest({
    this.rejectReason,
    this.statusId,
    this.requestId
});

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

  factory ClaimOperationRequest.fromJson(Map<String, dynamic> json) => _$ClaimOperationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ClaimOperationRequestToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'client_profile_update_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CreateClientRequest{
  CreateClientRequest({
    this.userId,
    this.weight,
    this.height,
    this.target,
    this.familyStatus,
    this.address,
    this.clientId,
    this.position
});

  String? address;

  @JsonKey(
    name: 'clientId',
  )
  int? clientId;

  @JsonKey(
    name: 'familyStatus',
  )
  String? familyStatus;
  int? height;
  String? position;
  String? target;

  @JsonKey(
    name: 'userId',
  )
  int? userId;
  int? weight;

  factory CreateClientRequest.fromJson(Map<String, dynamic> json) => _$CreateClientRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateClientRequestToJson(this);

}
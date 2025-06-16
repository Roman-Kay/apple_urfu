

import 'package:garnetbook/data/models/expert/client_claims/claims_model.dart';
import 'package:garnetbook/data/models/user/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'client_profile_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ClientProfileView{
  ClientProfileView({
    this.target,
    this.comment,
    this.reason,
    this.id,
    this.create,
    this.userId,
    this.address,
    this.update,
    this.weight,
    this.height,
    this.anamnesis,
    this.claim,
    this.diagnosis,
    this.familyStatus,
    this.imt,
    this.user
  });

  String? address;
  String? anamnesis;
  ClientClaimView? claim;
  String? comment;
  String? create;
  String? diagnosis;
  UserView? user;

  @JsonKey(
    name: 'familyStatus',
  )
  String? familyStatus;
  int? height;
  int? id;
  int? imt;
  String? reason;
  String? target;
  String? update;

  @JsonKey(
    name: 'userId',
  )
  int? userId;
  int? weight;

  factory ClientProfileView.fromJson(Map<String, dynamic> json) => _$ClientProfileViewFromJson(json);
  Map<String, dynamic> toJson() => _$ClientProfileViewToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ClientProfileResponse{
  ClientProfileResponse({
    required this.code,
    this.message,
    this.clientProfile
});

  @JsonKey(
    name: 'clientProfile',
  )
  ClientProfileView? clientProfile;
  int code;
  String? message;

  factory ClientProfileResponse.fromJson(Map<String, dynamic> json) => _$ClientProfileResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ClientProfileResponseToJson(this);
}
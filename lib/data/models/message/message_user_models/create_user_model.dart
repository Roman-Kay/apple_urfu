
import 'package:json_annotation/json_annotation.dart';

part "create_user_model.g.dart";

@JsonSerializable()
class CreateUserResponse{
  CreateUserResponse({
    this.id,
    this.displayName,
    this.secret,
    this.os,
    this.clientToken
});

  String? id;
  @JsonKey(name: 'displayName')
  String? displayName;
  String? secret;
  String? os;
  @JsonKey(name: 'clientToken')
  String? clientToken;

  factory CreateUserResponse.fromJson(Map<String, dynamic> json) => _$CreateUserResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CreateUserResponseToJson(this);
}


@JsonSerializable()
class CreateUserRequest{
  CreateUserRequest({
    this.serverSecret,
    this.displayName,
    this.id,
    this.clientToken,
    this.os
});

  String? id;
  @JsonKey(name: 'displayName')
  String? displayName;
  @JsonKey(name: 'serverSecret')
  String? serverSecret;
  @JsonKey(name: 'clientToken')
  String? clientToken;
  String? os;

  factory CreateUserRequest.fromJson(Map<String, dynamic> json) => _$CreateUserRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateUserRequestToJson(this);

}


@JsonSerializable()
class UpdateUserRequest{
  UpdateUserRequest({
    this.displayName,
    this.serverSecret,
    this.secret,
    this.os,
    this.clientToken
});

  String? secret;
  @JsonKey(name: 'displayName')
  String? displayName;
  @JsonKey(name: 'serverSecret')
  String? serverSecret;
  @JsonKey(name: 'clientToken')
  String? clientToken;
  String? os;

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) => _$UpdateUserRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateUserRequestToJson(this);
}


@JsonSerializable()
class UserDataResponse{
  UserDataResponse({
    this.displayName,
    this.id,
    this.clientToken,
    this.os
});

  String? id;
  @JsonKey(name: 'displayName')
  String? displayName;
  @JsonKey(name: 'clientToken')
  String? clientToken;
  String? os;

  factory UserDataResponse.fromJson(Map<String, dynamic> json) => _$UserDataResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataResponseToJson(this);
}
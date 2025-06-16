
import 'package:json_annotation/json_annotation.dart';

part "login_request.g.dart";


@JsonSerializable()
class LoginPasswordRequest{
  LoginPasswordRequest({
    this.roleId,
    this.login,
    this.password
});

  String? login;
  String? password;
  int? roleId;

  factory LoginPasswordRequest.fromJson(Map<String, dynamic> json) => _$LoginPasswordRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginPasswordRequestToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'login_social.g.dart';


@JsonSerializable()
class RegisterSocialRequest{
  RegisterSocialRequest({
    this.roleId,
    this.genderId,
    this.email,
    this.birthDate,
    this.providerId,
    this.socProviderId,
    this.userName
});


  String? birthDate;
  String? email;
  int? genderId;
  int? providerId;
  int? roleId;
  String? socProviderId;
  String? userName;

  factory RegisterSocialRequest.fromJson(Map<String, dynamic> json) => _$RegisterSocialRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterSocialRequestToJson(this);
}



@JsonSerializable(fieldRename: FieldRename.snake)
class LoginSocialRequest{
  LoginSocialRequest({
    this.roleId,
    this.email,
    this.providerId,
    this.userName,
    this.socProviderId,
});


  String? email;

  @JsonKey(
    name: 'providerId',
  )
  int? providerId;

  @JsonKey(
    name: 'roleId',
  )
  int? roleId;

  @JsonKey(
    name: 'socProviderId',
  )
  String? socProviderId;

  @JsonKey(
    name: 'userName',
  )
  String? userName;

  factory LoginSocialRequest.fromJson(Map<String, dynamic> json) => _$LoginSocialRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginSocialRequestToJson(this);
}

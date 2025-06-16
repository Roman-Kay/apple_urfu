
import 'package:json_annotation/json_annotation.dart';

part "create_user.g.dart";


@JsonSerializable()
class UserCreateRequest{
  UserCreateRequest({
    this.email,
    this.socProfile,
    this.phone,
    this.passwordMd5,
    this.roleId
});

  String? email;
  String? passwordMd5;
  String? phone;
  int? roleId;
  bool? socProfile;

  factory UserCreateRequest.fromJson(Map<String, dynamic> json) => _$UserCreateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UserCreateRequestToJson(this);
}

@JsonSerializable()
class UserUpdateRequest{
  UserUpdateRequest({
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.avatar,
    this.birthDate,
    this.genderId,
    this.socProfile,
    this.phone
});

  ImageView? avatar;
  String? birthDate;
  String? email;
  String? firstName;
  int? genderId;
  String? lastName;
  bool? socProfile;
  int? userId;
  String? phone;

  factory UserUpdateRequest.fromJson(Map<String, dynamic> json) => _$UserUpdateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UserUpdateRequestToJson(this);
}

@JsonSerializable()
class ImageView{
  ImageView({
    this.name,
    this.base64,
    this.format
});

  String? name;
  String? format;
  String? base64;

  factory ImageView.fromJson(Map<String, dynamic> json) => _$ImageViewFromJson(json);
  Map<String, dynamic> toJson() => _$ImageViewToJson(this);
}